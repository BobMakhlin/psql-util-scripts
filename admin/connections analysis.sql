select count(0), datname, state,--, query --285 --88

(select count(0) from pg_stat_activity)

from pg_stat_activity t

where 1=1

--and client_addr not in ('10.160.144.68','10.160.144.69','10.160.144.71')

group by datname, state--, query

order by 1 desc;