#!/bin/bash
SRC="webtroter@leto.feralhosting.com:/media/sde1/webtroter/Completed/"
DEST="/media/Share/Feral/"
LOG_FILE="/var/log/seedbox/rsync_`date +%Y%m%d-%Hh%M`.log"

# Lock 

LOCKDIR="/var/lock/sync-seedbox"
LOCKFILE="${LOCKDIR}/`basename $0`.lock"
mkdir "${LOCKDIR}" &>/dev/null
if [ -f $LOCKFILE ]; then
    echo "Lockfile Exists"
    #check if process is running
    MYPID=`head -n 1 "${LOCKFILE}"`
    TEST_RUNNING=`ps -p ${MYPID} | grep ${MYPID}`
    if [ -z "${TEST_RUNNING}" ]; then
        echo "The process is not running, resuming normal operation!"
        rm $LOCKFILE
    else
        echo "`basename $0` is already running [${MYPID}]"
        exit 1
    fi
fi
echo $$ > "${LOCKFILE}"

#Sync Process
ln -sf $LOG_FILE ~/rsync-feral.log # Link Log File
rsync -rlvuz -P -e ssh $SRC $DEST --progress --remove-source-files --log-file=$LOG_FILE
ssh webtroter@leto.feralhosting.com "scripts/remove_empty_dir.sh" #Remove Empty Dir in seedbox
cp ~/rsync-feral.log $DEST # Copy log into share
find /var/log/seedbox/rsync* -mtime +7 -exec rm {} \;  # Remove old logs

# Remove Lock
rm $LOCKFILE
exit 0