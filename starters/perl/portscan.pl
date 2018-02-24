#!/usr/bin/perl
####################################
##
## - A simple port scan. 
##
## 10/18/2012 - dsailors - initial creation
##
##
## set the values below for the IP address and range
##
####################################
#-----------------------------
#  Specify a class C address xxx.xx.xxx (it must be only 3 numbers between dots)
$segment = '10.31.31';

#  Specify a port
$port = '80';

#  Specify a starting point for the last octet
$starting = "0";

#  Specify an ending point for the last octet
$ending = "10";

#  Specify $quiet = 'yes' to return just IP addresses that hit
#$quiet = 'no';
$quiet = 'yes';

#-----------------------------
$year=`date +%Y`; chop($year);
$month=`date +%m`;chop($month);
$day=`date +%d`;  chop($day);
$hour=`date +%H`; chop($hour);
$min=`date +%M`;  chop($min);
$sec=`date +%S`;  chop($sec);
$tstamp = "$year.$month.$day.$hour.$min.$sec";
#-----------------------------
$host=`hostname`;
$PID=$$;
chop($host);
if ($quiet ne 'yes')
  {
    print "$tstamp - $0 starting on $host\n";
  }
$work = "/root/work/portscan-$PID";
$rc = system("mkdir -p $work");
#for ($i = 0; $i <= 254; $i++)
for ($i = $starting; $i <= $ending; $i++)
   {
     $cmd = "telnet $segment.$i $port >>$work/$segment.$i &";
     if ($quiet ne 'yes')
       {
          print "$cmd\n";
       }
     $rc = system("$cmd");
     sleep 5;
     $return = `ps -ef | grep \"telnet $segment.$i\" | grep -v grep`;
     if ($quiet ne 'yes')
       {
          print "ips resulted in = $return\n";
       }
     if ($return ne '')
       {
         @record = split(/[' ']+/,$return);
         if ($quiet ne 'yes')
           {
             print "$record[1]\n";
           }
         $rc = system("kill -9 $record[1]");
         $return = `ps -ef | grep \"telnet $segment.$i\" | grep -v grep`;
         if ($quiet ne 'yes')
           {
              print "$return\n";
           }
       } else { 
                if ($quiet ne 'yes')
                  {
                     print "telnet ended already\n"; }
                  }
   }
if ($quiet ne 'yes')
   {
     print "\n\n IP Addresses That Hit on Port $port for segment $segment\n";
   }
@return1 = `grep Escape $work/*`;
for ($y = 0; $y <= $#return1; $y++)
   {
      chop($return1[$y]);
      @record2 = split(/[':']+/,$return1[$y]);
      @record3 = split(/['\/']+/,$record2[0]);
      print "$record3[$#record3]\n";
   }

