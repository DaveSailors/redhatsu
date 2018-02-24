#!/bin/bash
PS=`/bin/ps -ef | grep syslogd`
#echo $PS
for element in $(seq 0 $((${#PS[@]} - 1)))
  do
    echo -n "${PS[$element]}"
  done
echo
exit 0
