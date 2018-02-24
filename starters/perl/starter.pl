#!/usr/bin/perl
####################################
##
## xx/xx/20 - dsailors - initial creation
##
####################################
#-----------------------------
$year=`date +%Y`; chop($year);
$month=`date +%m`;chop($month);
$day=`date +%d`;  chop($day);
$hour=`date +%H`; chop($hour);
$min=`date +%M`;  chop($min);
$sec=`date +%S`;  chop($sec);
$tstamp = "$year.$month.$day.$hour.$min.$sec";
#-----------------------------
$PID=$$;
$host=`hostname`;
chop($host);
print "$tstamp - $0 starting on $host\n";
