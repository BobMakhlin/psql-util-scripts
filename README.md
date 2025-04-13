Useful scripts for db administration and development in Postgres.

admin
- connection_analysis.sql – Shows the number of active connections grouped by database and state. Helps monitor connection usage and detect unusual patterns.
- hot_updates.sql – Analyzes the percentage of hot updates (updates where the new row version fits in the same data page as the old one) for user tables. Helps identify optimization opportunities for frequent updates.
- index_scans_vs_seq_scans.sql – Compares index scans and sequential scans for user tables, showing the percentage of index usage and performance metrics like tuples read per scan. Helps assess scan efficiency and identify optimization opportunities.
- index_usage_and_size.sql – Retrieves index size and usage statistics for user indexes, including the number of index scans and average tuples read per scan. Helps monitor index efficiency and identify large or underused indexes.
- query_analysis.sql – Analyzes query execution performance from pg_stat_statements, showing total execution time, number of calls, rows returned, and cache hit percentage. Helps identify slow queries and optimize cache usage for better performance.
- show_statistics.sql – Displays detailed query statistics from pg_stat_statements, including execution time per call, time per row, cache hit percentage, and block read time. Useful for in-depth performance analysis and identifying slow or resource-heavy queries.
- show_stat2.sql – Similar to show_statistics.sql, this query provides detailed statistics from pg_stat_statements, including total execution time, time per call, and cache hit percentage. It may use different timing metrics (e.g., total_time instead of total_exec_time) for performance analysis.
- admin_table_operations_stats.sql – Provides statistics on table operations (inserts, updates, and deletes) from pg_stat_user_tables, showing the percentage of each operation type. Helps identify tables with heavy update/delete activity, which may benefit from reindexing or vacuuming.

development
- generate_insert_statement_string.sql – A stored procedure that generates a dynamic INSERT statement for a given table, listing all column names automatically. Useful for quickly constructing INSERT statements based on a table's schema.
- json-array-to-temp-table.sql – A set of stored procedures to dynamically create a temporary table from a JSON array and insert the data into it. Useful for transforming JSON data into relational table format on the fly.
