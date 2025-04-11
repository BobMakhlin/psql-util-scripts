-- index vs seq scans
  SELECT schemaname, relname,seq_scan, idx_scan,
       cast(idx_scan AS numeric) / (idx_scan + seq_scan)
       AS idx_scan_pct 
FROM pg_stat_user_tables 
       WHERE (idx_scan + seq_scan) > 0 ORDER BY idx_scan_pct;
	   
-- tuples	   
SELECT relname, seq_tup_read, idx_tup_fetch,
       cast(idx_tup_fetch AS numeric) / (idx_tup_fetch + seq_tup_read) 
       AS idx_tup_pct 
FROM pg_stat_user_tables 
       WHERE (idx_tup_fetch + seq_tup_read) > 0 ORDER BY idx_tup_pct;

SELECT schemaname, relname, seq_scan, seq_tup_read, 
       seq_tup_read / seq_scan AS avg, idx_scan 
FROM   pg_stat_user_tables 
WHERE  seq_scan > 0 
ORDER BY seq_tup_read DESC  
LIMIT  25; 
