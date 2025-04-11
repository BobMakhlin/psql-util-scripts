
		
CREATE OR REPLACE PROCEDURE generate_insert_statement(schema_name text, target_table text)
LANGUAGE plpgsql
AS $$
DECLARE
    column_list text;
    result text;
BEGIN
    SELECT string_agg(quote_ident(column_name), ', ' ORDER BY ordinal_position)
    INTO column_list
    FROM information_schema.columns
    WHERE table_schema = schema_name
      AND table_name = target_table;

    IF column_list IS NULL THEN
        RAISE NOTICE 'Table "%" not found.', target_table;
        RETURN;
    END IF;

    result := format('INSERT INTO %I (%s) VALUES (...);', target_table, column_list);

    RAISE NOTICE '%', result;
END;
$$;


--INSERT INTO item (id, name, description, version, date) VALUES (...);
call generate_insert_statement('public', 'item');



drop procedure generate_insert_statement;