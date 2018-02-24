#!/usr/bin/perl
####################################
## Description:
## A script to increment an event counter
##
## 01/18/2013 - dsailors - initial creation
##
##
####################################
#-----------------------------
$lockAlert1 = '5';
$lockAlert2 = '7';
$lockAlert3 = '9';
$lockAlert4 = '15';
$lockAlert5 = '20';
#-----------------------------
$year=`date +%Y`; chop($year);
$month=`date +%m`;chop($month);
$day=`date +%d`;  chop($day);
$hour=`date +%H`; chop($hour);
$min=`date +%M`;  chop($min);
$sec=`date +%S`;  chop($sec);
$tstamp = "$year.$month.$day.$hour.$min.$sec";
$datime = "$month/$day/$year $hour:$min:$sec";
#-----------------------------
$PID=$$;
$host=`hostname`;
chomp($host);
#-----------------------------
$basepath = "/home/impactmail";
$archpath = "$basepath/mail-archive";
$counterpath = "$basepath/EventCounter";
$counterfile = "$counterpath/counter.txt";
$lockfile = "$counterpath/LockFile.txt";
$workpath = "$basepath/work";
#-----------------------------
$lockfileExists = 'true';
while ($lockfileExists eq 'true')
   {
      if ($debug eq 'yes') { print "checking for lockfile at $lockfile\n"; }
      $return = `ls -al $lockfile 2>&1`;
      chomp($return);
      #print "----> $return\n";
      if (index($return,'No such file or directory') ge 0)
        {
           $lockfileExists = 'false';
        } else 
               {
                  $lockPID = `cat $lockfile`;
                  chomp($lockPID);
                  if ($debug eq 'yes') { print "Lock File Exists. Its PID is $lockPID.\n"; }
                  $lockfileExists = 'true';
                  if ($debug eq 'yes') { print "Checking to see if the process is running\n"; }
                  $cmd1 = "ps -ef | grep $lockPID | grep -v grep | grep -v sleep";
                  if ($debug eq 'yes') { print "$cmd1\n"; }
                  $return1 = `$cmd1`;
                  chop($return1);
                  if ($debug eq 'yes') { print "process = $return1\n"; }
                  if ($return1 ne '')
                    {
                       if ($debug eq 'yes') { print "process $return1 is running\n"; }
                       $sleepct++;
                       if (($sleepct eq $lockAlert1) or ($sleepct eq $lockAlert2) or ($sleepct eq $lockAlert3) or ($sleepct eq $lockAlert4))
                          {
                             $message = "$0 is waiting on a lockfile on $host ($lockfile). sleepct = $sleepct";
                             $rc = system("echo \"$message\" | mailx -s \"Lockfile Alert on $host\" dsailors\@central.com");
                             if ($debug eq 'yes') { print "***** Sending email alert $rc\n"; } 
                          }
                       sleep 3;
                    } else { 
                             $message =  "There is no process running for $lockPID. Deleting it and moving on..";
                             $rc = system("echo \"$message\" | mailx -s \"Lockfile Alert on $host\" dsailors\@central.com");
                             $lockfileExists = 'false';
                           }
               }
   }
#---------------------------
if ($debug eq 'yes') { print "lockfile $PID\n"; }
unless (open(lockfile,">$lockfile")) {print "cant open $lockfile\n";exit;}
print lockfile "$PID\n";
#---------------------------
if ($debug eq 'yes') { print "$0 is starting on $host\n"; }
#----------------------------------------
$count = `cat $counterfile`;
$count++;
$rc = system("echo $count >$counterfile");
print "count = $count\n";
#----------------------------------------
# put your program here
#----------------------------------------
if ($debug eq 'yes') { print "run complete. Removing lock file\n"; }
$rc = system("rm $lockfile");
if ($debug eq 'yes') { print "rc $rc\n"; }
