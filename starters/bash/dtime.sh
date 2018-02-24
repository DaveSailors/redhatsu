#!/bin/bash
DAY=$(date +%d)
MONTH=$(date +%m)
YEAR=$(date +%Y)
HOUR=$(date +%H)
MINUTE=$(date +%M)
SECOND=$(date +%S)
TSTAMP="$MONTH.$DAY.$YEAR-$HOUR.$MINUTE.$SECOND"

HOSTNAME=`hostname`;

#------------------------------------------
echo "$TSTAMP $0 running on $HOSTNAME"
#------------------------------------------

