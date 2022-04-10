#!/usr/bin/bash
# Set ENV: DRIVE,FREQUENCY
FILTER=${HOME}/scripts/cronjobs/filter_rsync.txt
LOG_FILE=${HOME}/.local/log/rsync_${DRIVE}_${FILES}_${FREQUENCY}.log
rm -f $LOG_FILE
rsync -a -i --delete -f 'merge '${FILTER} \
--log-file $LOG_FILE \
/home/user/ /media/user/${DRIVE}/backups/${FREQUENCY}
