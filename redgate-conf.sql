--Redgate Linux PostgreSQL configuration

--Create the utility database
CREATE DATABASE redgatemonitor;
 
--Create the user with basic monitoring permissions
CREATE USER redgatemonitor WITH PASSWORD 'Y0uRp@s$w0rD';
GRANT pg_monitor TO redgatemonitor;
GRANT ALL PRIVILEGES ON DATABASE redgatemonitor TO redgatemonitor;



CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS file_fdw;
CREATE SERVER sqlmonitor_file_server FOREIGN DATA WRAPPER file_fdw;
GRANT pg_read_server_files TO redgatemonitor;
GRANT EXECUTE ON FUNCTION pg_catalog.pg_current_logfile(text) TO redgatemonitor;
GRANT USAGE ON FOREIGN SERVER sqlmonitor_file_server TO redgatemonitor;
GRANT ALL PRIVILEGES ON SCHEMA public TO redgatemonitor;


#### Start for Redgate test
#Essential
auto_explain.log_format = json
auto_explain.log_level = LOG
 
#Throttle which explain plans are recorded
auto_explain.log_min_duration = 2000
auto_explain.sample_rate = 1.0
 
#Configure detail level
auto_explain.log_verbose = true
auto_explain.log_settings = true
auto_explain.log_nested_statements = true
auto_explain.log_analyze = true
auto_explain.log_buffers = true
auto_explain.log_wal = true
auto_explain.log_timing = true
auto_explain.log_triggers = true
 
#Capture io performance
track_io_timing = true
 
#Ensure the pg_stat_statements extension captures data
pg_stat_statements.track = top
#### END for Redgate test

############## Configure ssh
ssh-keygen -t ed25519 -C "<YOUR USERNAME>"
ssh-keygen -t ed25519 -C "salam"

cd ~
cd .ssh
cat <PUBLIC_KEY_FILEPATH> | ssh <USERNAME>@<REMOTE_HOST> "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat >> ~/.ssh/authorized_keys"
cat id_ed25519.pub | ssh salam@mytestserver "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat >> ~/.ssh/authorized_keys"



