#!/bin/bash
PROGRAM=`basename $0`
echo $PROGRAM
DIRECTORY=`dirname $0`
echo $DIRECTORY
if [ -f "$DIRECTORY/db.lck" ]; then
        echo "ERROR:  Lock File Found....!!\nExiting...\n" 1>&2
        exit 1
fi
currentID=$(id 2> /dev/null | cut -d"=" -f2 2> /dev/null | cut -d"(" -f1 2> /dev/null)
echo current ID $currentID
