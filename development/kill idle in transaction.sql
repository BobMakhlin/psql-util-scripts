SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE state = 'idle in transaction'
  AND query ILIKE 'SET TRANSACTION ISOLATION LEVEL READ COMMITTED%'
  AND pid <> pg_backend_pid();
