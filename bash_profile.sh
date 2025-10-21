#!/bin/ksh
clear
stty erase ^H
EDITOR=vi
TERM=vt100
TMP=/tmp
TMPDIR=$TMP
echo " "
echo "===================================================================="
echo "PostgresSQL Database Server version: 12.5"
echo "===================================================================="
echo "Software PATH      : /usr/pgsql-12/bin"
echo "Config file & Data : /var/lib/pgsql/12/data"
echo "===================================================================="
echo "Start DB by command :systemctl start postgresql-12  by root "
echo "Stop  DB by command :systemctl stop postgresql-12  by root "
echo "===================================================================="

PG_STATUS=$(ps -ef | grep postgres|grep recovering|grep -v grep|wc -l)
if [ "${PG_STATUS}" -gt 0 ] ;
then
  PSQL_SID=Slave
else
  PSQL_SID=Master
fi

PSQL_HOSTNAME=rs-idam-db-401
PS1="`tput smso`[$PSQL_SID]` `[$PSQL_HOSTNAME]`tput rmso`"'($PWD)$ '
NLS_LANG=AMERICAN_AMERICA.TH8TISASCII
PATH=$PATH:$HOME/bin:/usr/pgsql-12/bin:/usr/bin
UPTIME=`uptime | awk '{for ( i = 3; i <= NF-7; i++ ) if ( i != NF-7 ) print $i; else print substr($i,1,length($i)-1);}'`
H_PATH=/usr/home/postgres
rm -f $H_PATH/issue
echo  ' +-+-+-+-+-+-+-+-+-+-+ +-+-+-+ +-+-+-+-+ '>> $H_PATH/issue
echo  ' |P|o|s|t|g|r|e|S|Q|L| |F|o|r| |D|T|A|C| '>> $H_PATH/issue
echo  ' +-+-+-+-+-+-+-+-+-+-+ +-+-+-+ +-+-+-+-+ '>> $H_PATH/issue
echo  ''$(date)' - ''System Uptime: '$UPTIME'' >> $H_PATH/issue
cp -f $H_PATH/issue $H_PATH/issue.lst
cat $H_PATH/issue
ps -ef |grep postgres
echo " "

export VISUAL="vi"
export PGDATA=/var/lib/pgsql/12/data
export PGPORT=5432
