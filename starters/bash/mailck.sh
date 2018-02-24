#!/bin/ksh
SERVER=$1
echo $1
(
sleep 2
echo EHLO $SERVER
sleep 1
echo QUIT
sleep 1
echo HELP
) | telnet $SERVER 25
