#!/bin/sh

RAID=md125
STATS=`grep md125 /proc/diskstats`

LOCKFILE=/tmp/spinDown.lock
STATFILE=/tmp/spinDown
DOWNFILE=/tmp/spinDown

if [ -f $LOCKFILE ]; then
    # we are already running
    exit 1
fi

touch $LOCKFILE

DATE=`/bin/date`

if [ -f ${STATFILE}.${RAID}.stat ]; then
    PREVSTATS=`/bin/cat ${STATFILE}.${RAID}.stat`
    if [ "$STATS" == "$PREVSTATS" ] && [ ! -f ${DOWNFILE}.${RAID}.down ]; then
        # Disk stats unchanged and the disk spinning.  Hence, idle -> spin down.
        echo "$DATE ${RAID} idle, spinning down" >> /tmp/spinDown.log
        /sbin/service smartd stop > /dev/null
        /usr/bin/sdparm --command=sync /dev/sdb &> /dev/null
        /usr/bin/sdparm --command=stop /dev/sdb &> /dev/null
        /usr/bin/sdparm --command=sync /dev/sdc &> /dev/null
        /usr/bin/sdparm --command=stop /dev/sdc &> /dev/null
        /usr/bin/sdparm --command=sync /dev/sdd &> /dev/null
        /usr/bin/sdparm --command=stop /dev/sdd &> /dev/null
        /usr/bin/sdparm --command=sync /dev/sde &> /dev/null
        /usr/bin/sdparm --command=stop /dev/sde &> /dev/null
        STATS=`grep ${RAID} /proc/diskstats`
        echo "$STATS" > ${STATFILE}.${RAID}.stat
        touch ${DOWNFILE}.${RAID}.down
    else
        if [ "$STATS" != "$PREVSTATS" ] && [ -f ${DOWNFILE}.${RAID}.down ]; then
            # Disk stats are different & disk was down.  Remove the down state file.
            echo "$DATE stats different for ${RAID}" >> /tmp/spinDown.log
            /sbin/service smartd start > /dev/null
            rm -f ${DOWNFILE}.${RAID}.down
        fi
        if [ "$STATS" != "$PREVSTATS" ]; then
            echo "$STATS" > ${STATFILE}.${RAID}.stat
        fi
    fi
else
    # Initialise the state file
    echo "$DATE initialising for ${RAID}" >> /tmp/spinDown.log
    echo "$STATS" > ${STATFILE}.${RAID}.stat
fi

rm -f $LOCKFILE
