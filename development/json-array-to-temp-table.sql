CREATE OR REPLACE PROCEDURE create_temp_table_from_json(temp_table_name TEXT, json_input TEXT)
LANGUAGE plpgsql
AS $$
DECLARE
    first_elem JSON;
    key TEXT;
    create_stmt TEXT := 'CREATE TEMP TABLE ';
BEGIN
    -- Extract the first object from the JSON array to determine the keys (columns)
    SELECT json_array_elements(json_input::json) LIMIT 1 INTO first_elem;

    -- Start the CREATE TABLE statement
    create_stmt := create_stmt || format('%I (', temp_table_name);

    -- Dynamically iterate over the keys and add columns to the CREATE statement
    FOR key IN SELECT json_object_keys(first_elem)
    LOOP
        -- Add column definitions to the CREATE statement (assuming UUID type for simplicity)
        create_stmt := create_stmt || format('%I UUID, ', key);
    END LOOP;

    -- Remove the trailing comma and space, then add closing parenthesis
    create_stmt := left(create_stmt, length(create_stmt) - 2) || ');';

    -- Execute the dynamic CREATE TABLE statement
    EXECUTE create_stmt;
END;
$$;


CREATE OR REPLACE PROCEDURE insert_json_to_temp_table(temp_table_name TEXT, json_input TEXT)
LANGUAGE plpgsql
AS $$
DECLARE
    row JSON;
    key TEXT;
    insert_stmt TEXT := 'INSERT INTO ';
    column_names TEXT := '';
    insert_values TEXT := '';
BEGIN
    -- Start building the INSERT INTO statement
    insert_stmt := insert_stmt || format('%I (', temp_table_name);

    -- Dynamically fetch column names from the temp table
    FOR key IN 
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = temp_table_name
		ORDER BY column_name
    LOOP
        column_names := column_names || format('%I, ', key);
    END LOOP;

    -- Remove trailing commas from column names and value placeholders
    column_names := left(column_names, length(column_names) - 2);

    -- Finalize the INSERT INTO statement with column names
    insert_stmt := insert_stmt || column_names || ')';

    -- Iterate over the JSON array and insert each row
    FOR row IN SELECT * FROM json_array_elements(json_input::json)
    LOOP
        -- Prepare insert values by dynamically extracting each column's value from the JSON row
        insert_values := 'VALUES (';
        
        FOR key IN 
            SELECT column_name
	        FROM information_schema.columns
	        WHERE table_name = temp_table_name
			ORDER BY column_name
        LOOP
            -- Use json_extract_path_text to extract the corresponding value from the row
            insert_values := insert_values || format('%L, ', row->>key);
        END LOOP;

        -- Remove trailing comma from insert_values string
        insert_values := left(insert_values, length(insert_values) - 2) || ')';

        -- Log the dynamic insertion values
        RAISE NOTICE 'Inserting: %', insert_stmt || ' ' || insert_values;

        -- Execute the insert statement
        EXECUTE insert_stmt || ' ' || insert_values;
        
    END LOOP;
END;
$$;

CREATE OR REPLACE PROCEDURE build_temp_table_from_json(temp_table_name TEXT, json_input TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Call the procedure to create the temporary table based on the JSON input
    CALL create_temp_table_from_json(temp_table_name, json_input);

    -- Call the procedure to insert the data into the temporary table
    CALL insert_json_to_temp_table(temp_table_name, json_input);
    
    -- Optionally log completion
    RAISE NOTICE 'Temporary table "%", and data insertion completed successfully.', temp_table_name;
END;
$$;

-- Example: Create and insert into the temp table from the given JSON input
CALL build_temp_table_from_json('my_temp_table', '[{"aId":"d4fd545f-af91-4643-9702-e1e4931478b8","bId":"9e47b94f-1217-4012-9178-6617981f3be5","cId":"5b08b4f4-ae61-4d72-ad6f-6aea4f01359a"}]');



