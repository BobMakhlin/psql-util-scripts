SELECT query, (SELECT ttt.datname FROM pg_database ttt where ttt.oid = dbid),

       case when calls = 0 then 0 else

       total_exec_time/calls end time_per_cal,

       calls, total_exec_time, rows,

       case when rows = 0 then 0 else

       total_exec_time/rows end time_per_row,

			   100.0 * shared_blks_hit / nullif(shared_blks_hit + shared_blks_read, 0) AS hit_percent,

			   blk_read_time

          FROM pg_stat_statements

          where 1=1

          and (SELECT ttt.datname FROM pg_database ttt where ttt.oid = dbid) like '%%'

          and upper(query) like '%%'

          --and (query like '%insert%' or query like '%updat%' or query like '%delet%')

          ORDER BY total_exec_time DESC LIMIT 1000;
          
         