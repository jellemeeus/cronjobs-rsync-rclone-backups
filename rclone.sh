#!/usr/bin/bash
# Set ENV: DRIVE,FILES
FILTER=${HOME}/scripts/cronjobs/filter_${FILES}.txt
LOG_FILE=${HOME}/.local/log/rclone_copy_${DRIVE}_${FILES}.log
rm -f $LOG_FILE
rclone copy -v --tpslimit 4 --filter-from $FILTER \
--log-file $LOG_FILE \
$HOME $DRIVE:Ubuntu
