#!/usr/bin/perl
####################################
##
## 08/23/2012 - dsailors - initial creation
##
## a script that will test the smtp connection to a messaging server and
## send an email alert if unable to connect.
##
##
####################################
$dist = "dsailors\@central.com,central\@directlineinc.com,support\@central.com";
#$dist = "dsailors\@central.com";
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
chop($host);
#-----------------------------
#$server = "10.31.111.54";
#$server = "sacmx01.cent.com";
$server = $ARGV[0];
$alertfile = "/tmp/smtp-ping.alertfile.$server.txt";
$alertctmax = '5';
if ($server eq '') {print "No server specified\n";exit;$server = "sacmx01.cent.com"; }
if (($server ne "10.31.111.54") &&($server ne "sacmx01.cent.com"))
  {
    print "$server not set to a known server. exiting..\n";
    $rc = system("echo \"bad server on $host\" | mailx dsailors\@central.com");
    exit;
  }
#-----------------------------
$binpath = "/root/bin";
$script = "mailck.bash";
#-----------------------------
$cmd = "$binpath/$script $server";
$cmd1 = "ping -c 3 $server";
$checkfor = 'ESMTP Symantec Messaging Gateway';
#$checkfor = 'xxxxxxx testing xxxxx ESMTP Symantec Messaging Gateway';
#-----------------------------
print "=========================================================================================\n";
print "$tstamp - $0 starting on $host\n";
print "$cmd\n";
@return = `$cmd`;
for ($i = 0; $i <= $#return; $i++)
  {
     chop($return[$i]);
     print "->$return[$i]\n";
     if (index($return[$i],$checkfor) > 0)
       {
         $smtpServer = 'Good';
       }
     @record = split(/[' ']+/,$return[$i]);
     #$program = $record[$i];
  }
if ($smtpServer ne 'Good')
  {
    print "The server is not up!!!\n";
    print "$cmd1\n";
    @return1 = `$cmd1`;
    $pingHitCt = '';
    $pingServer = 'null';
    for ($x = 0; $x <= $#return1; $x++)
      {
        chop($return1[$x]);
        print "$return1[$x]\n";
        if (index($return1[$x],'bytes from') > 0)
          {
            $pingHitCt++;
          }
      }
        print "$pingHitCt hits on ping\n";
        if ($pingHitCt > 0)
          {
             $pingServer = 'Succeeded';
          }
        if ($pingHitCt eq '')
          {
             $pingServer = 'Failed';
          }
    &alert;
  } else {  
            # success - The Server is UP! ----------
            print "The Server Is UP\n"; 
            unless (open(alertfile,">$alertfile")) {print "cant open $alertfile\n";exit;}
            print alertfile "0\n";
            close(alertfile);
         }
#-------- sub routines -------------
sub alert
  {
    print "------------ processing alerts -------------------\n";
    #------- Check to see if the alert count exceeds $alertctmax -------
    @return = `ls -al $alertfile 2>&1`;
    if (index($return[0],'No such file or directory') ge 0)
      { 
        print "no alert file\n";
        $alertct = 0;
        unless (open(alertfile,">$alertfile")) {print "cant open $alertfile\n";exit;}
        print alertfile "1\n";
        close(alertfile);
        print "Alert count set to 1 and alertfile created <----\n";
        exit;
      } 
    unless (open(alertfile,"$alertfile"))
       {
         print "ERROR ! cant open $alertfile, but file does exist\n";
         @error = `echo \"ERROR ! cant open $alertfile, but file does exist\" | mailx -s smtp-ping-error-sacitm02 dsailors\@central.com`;
         print "cant open $alertfile for output\n"; 
       }
        @alertin = <alertfile>;
        close(alertfile);
        chop($alertin[0]);
        print "alertct in = $alertin[0]\n";
        $alertct = $alertin[0] +1;
        unless (open(alertfile,">$alertfile")) {print "cant open $alertfile\n";exit;}
        print alertfile "$alertct\n";
        close(alertfile);
        print "new alert count = $alertct\n";
        if ($alertct < $alertctmax)
          {
            print "Alert count = $alertct\n";
            print "Thats not enought to send an alert\n";
            $rc = system("echo \"/root/bin/smtp-ping.pl >>/usr/local/syslog/smtp-ping.$server.log`date +\%y\%m\%d` 2>&1\" $server >/tmp/x.del;at now + 1 minutes -f /tmp/x.del");
            print "exiting ...\n";
            exit;
          }
    #-------
    $outfile = "/tmp/smtpalert.$PID.txt";
    print "triggering alerts\n";
    unless (open(outfile,">$outfile")) {print "cant open $outfile\n";exit;}
     {
       print outfile "To: $dist\n";
       print outfile "From: smtpalert\@central.com\n";
       print outfile "Subject: SMTP Alert for $server\n";
       print outfile "\n";
       print outfile "$datime SMTP Ping Alert!\n";
       print outfile "\n";
       print outfile "The Messaging server on $server is not responding to an SMTP ping.\n";
       print outfile "\n";
       print outfile "An attempt to do a UDP ping to the machine has $pingServer.\n";
       print outfile "\n";
       for ($x = 0; $x <= $#return1; $x++)
          {
            chop($return1[$x]);
            print outfile "$return1[$x]\n";
          }
       print outfile "\n";
       print outfile "This alert comes from $0 on $host .\n";
       print outfile "\n";
       close($outfile);
       $rc = system("cat $outfile | /usr/sbin/sendmail -t");
       $URL = "http://www.thewall.bz/cgi-bin/central/smtpalert.cgi?";
       $infile = $outfile;
       unless (open(infile,"$infile")) {print "cant open $infile\n";exit;}
       @line = <infile>;
       close(infile);
       chop($line[0]);
       $URL = $URL.$line[0];
       for ($z = 1; $z <= $#line; $z++)
         {
           chop($line[$z]);
           if ($line[$z] eq '') { $line[$z] = '-'; }
           $URL = "$URL~$line[$z]";
         }
       print "URL = $URL\n";
       sleep 1;
       $rc = system("wget -O /tmp/x.del \'$URL\'");
       $rc = system("/usr/sbin/sendmail -q");
       $rc = system("rm $outfile");
     }
  }
