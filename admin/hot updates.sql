-- ==HOT UPDATES==
-- a tuple hot update refers to a specific optimization during the update process 
-- where the new version of a tuple (row) is placed in the same data page as the old version.
SELECT relname,n_tup_upd, n_tup_hot_upd,
       cast(n_tup_hot_upd AS numeric) / (case when n_tup_upd = 0 then 1 else n_tup_upd end) AS hot_pct 
FROM pg_stat_user_tables 
       WHERE n_tup_upd>0 ORDER BY hot_pct;
      
-- Consider using Fill Factor to reserve free space for every block (page) for a specific table,
-- so that there's reserved space for hot updates.
