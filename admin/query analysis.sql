SELECT query, calls, total_exec_time, rows,
100.0 * shared_blks_hit /nullif(shared_blks_hit + shared_blks_read, 0) AS hit_percent 
FROM pg_stat_statements 
where query like '%part-of-your-query%' 
ORDER BY total_exec_time DESC LIMIT 50;

-- should be 100 ideally