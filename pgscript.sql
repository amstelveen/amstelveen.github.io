stop db on slave
-------------------------------------------------------
systemctl stop postgres11.service
mv /var/lib/pgsql/11/data/ /var/lib/pgsql/11/data_old
mkdir /var/lib/pgsql/11/data/
pg_basebackup -h 10.94.160.235 -D /var/lib/pgsql/11/data/ -U rep  -Fp -Xs -P -R

nohup pg_basebackup -h 10.90.2.180 -U replicator -p 5432 -D /postgres_data/data -Fp -Xs -P -R &

pg_basebackup -h 10.128.0.8 -D /var/lib/pgsql/12/data -U rep -P -v -R -X stream --checkpoint=fast 

password : superman
systemctl start postgres11.service
supperman or superman   (not sure)

log_checkpoints = on

psql -h 172.31.39.243 -d xdb -U enterprisedb

systemctl list-unit-files|grep postgres

lasso -H /tmp -p 5444 postgres

On master:
select * from pg_stat_replication;

On standby
select * from pg_stat_wal_receiver;

SELECT      pg_walfile_name(pg_current_wal_lsn()),
            last_archived_wal FROM pg_stat_archiver;
            
test=# SELECT pg_current_wal_lsn() - '3/B549A845'::pg_lsn;
  ?column?
-----------
 616376827
(1 row)


select setting, source, sourcefile, sourceline , context
from pg_settings ;
where name = 'log_disconnections';
 setting |       source       |             sourcefile              | sourceline
---------+--------------------+-------------------------------------+------------
 on      | configuration file | /postgres_data/data/postgresql.conf |        432

select name, setting, source,  context
from pg_settings ;

\! hostname; date --> run shell in postgres

select
(select pg_read_file('/etc/hostname')) as hostname,
( select version() as version ) ;

\pset format wrapped
\pset linestyle unicode
\pset format aligned-wrapped
\pset border 2
\pset format
 html
\pset format csv
\timing
SELECT 
    pid
    ,datname
    ,usename
    ,application_name
    ,query
    ,state
    ,client_hostname
FROM pg_stat_activity;



\pset format wrapped
\pset linestyle unicode
\timing
SELECT
    a.pid,
    a.usename,
    a.datname,
    a.client_addr,
    a.query,
    a.state,
    a.query_start,
    l.locktype,
    l.mode,
    l.granted
FROM
    pg_stat_activity a
JOIN
    pg_locks l ON a.pid = l.pid
ORDER BY
    a.pid;

---locking
select pid, 
       usename, 
       pg_blocking_pids(pid) as blocked_by, 
       query as blocked_query
from pg_stat_activity
where cardinality(pg_blocking_pids(pid)) > 0;

startup time 
SELECT pg_postmaster_start_time() as startup_time;

SHOW data_directory;
SELECT inet_server_port() AS portNumber;

command to check memory usage
=============================
uname -n ;ps -eo pid,ppid,cmd,user,comm,%mem,%cpu --sort=-%mem | head -10

awk '/Mem:/ {printf("Available Memory Percentage: %.2f%\n", $7/$2 * 100)}' <(free -m)


command to check cpu usage
=============================
uname -n ;ps -eo pid,ppid,cmd,user,comm,%mem,%cpu --sort=-%cpu | head -10



CREATE USER moncdr WITH PASSWORD 'moncdr#123';
GRANT CONNECT ON DATABASE bldb TO moncdr;
GRANT ALL PRIVILEGES ON DATABASE bldb TO moncdr;
psql -d bldb -U moncdr -h 10.89.89.212


SELECT count(*),
       state
FROM pg_stat_activity
GROUP BY 2;

postgres=# \! hostname


SELECT
  pg_is_in_recovery() AS is_slave,
  pg_last_wal_receive_lsn() AS receive,
  pg_last_wal_replay_lsn() AS replay,
  pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() AS synced;
  
psql -c "SELECT  state,  now()as date_time, COUNT(state) AS count FROM pg_stat_activity GROUP BY  state ORDER BY count DESC;"
psql -c "SELECT pid, now() - pg_stat_activity.query_start AS duration, query_start,application_name, usename,query, state FROM pg_stat_activity order by query_start;" -P format=wrapped

  
SELECT pid, now() - pg_stat_activity.query_start AS duration, query 
FROM pg_stat_activity 
WHERE (now() - pg_stat_activity.query_start) > interval '60 minutes';


SELECT name, 
       setting, 
       short_desc
FROM pg_settings
WHERE context = 'postmaster'
ORDER BY name;
If the parameter is dynamic (i.e., context is sighup or user), you can apply changes immediately without a restart.
If the parameter requires a restart (context = 'postmaster'), you need to restart the PostgreSQL service for the change to take effect.
