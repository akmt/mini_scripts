#!/bin/bash

function kill_children {
    # jobs -l | perl -ne 'print "kill $1\n" if /^\S+?\s+(\d+)/'  | sh;
    pkill -P $$;
    wait;
}

trap "kill_children" EXIT

KEYWORD=$1
SERVERS="sv01 sv02 sv03"
LOGDIR="/var/log/servers"

DATE=`date +%Y-%m-%d`
echo $DATE

for host in $SERVERS; do
    # TAIL="ssh $host grep -6 $KEYWORD $LOGDIR/$host/app/$DATE/app.log"
    TAIL="grep -6 $KEYWORD $LOGDIR/$host/app/$DATE/app.log"
    echo '================================================'
    echo $TAIL
    $TAIL
done

wait
