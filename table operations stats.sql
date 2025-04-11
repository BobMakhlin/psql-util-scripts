 SELECT relname,
       cast(n_tup_ins AS numeric) / (case when (n_tup_ins + n_tup_upd + n_tup_del) = 0 then 1 else (n_tup_ins + n_tup_upd + n_tup_del) end) AS ins_pct,
       cast(n_tup_upd AS numeric) / (case when (n_tup_ins + n_tup_upd + n_tup_del) = 0 then 1 else (n_tup_ins + n_tup_upd + n_tup_del) end) AS upd_pct,
       cast(n_tup_del AS numeric) / (case when (n_tup_ins + n_tup_upd + n_tup_del) = 0 then 1 else (n_tup_ins + n_tup_upd + n_tup_del) end) AS del_pct 
FROM pg_stat_user_tables 
       ORDER BY relname;
-- ins_pct - ration of inserts;
-- upd_pct - ration of updates (if that's a lot of updates, maybe we need to reindex)
-- del_pct - ration of deletes (the table might have a lot of dead tuples, maybe vacuum full might help here...)
      