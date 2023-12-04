#!/bin/sh

disk=$1

STATS=`/sbin/hdparm -C /dev/${disk} | grep 'active'|awk '{print $4}'`
STATCMDFILE=/tmp/spinDown.CMD
LOGFILE=/root/hdspindown/spinDown
DATE=`date`
if [ -f ${STATCMDFILE}.${disk} ]; then
    PREVSTATS=`cat ${STATCMDFILE}.${disk}`
    if [ "$STATS" = "$PREVSTATS" ]; then
        exit 0
    else
        echo "$DATE state change $PREVSTATS -->$STATS">>${LOGFILE}.${disk}.alert.log
        echo "$STATS" > ${STATCMDFILE}.${disk}
    fi
else
    echo "$STATS" > ${STATCMDFILE}.${disk}
fi
