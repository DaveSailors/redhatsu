#!/usr/bin/perl
####################################
##
## 07/01/20 - dsailors - initial creation
##
## a script to check the space available on /opt/edi
##
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
$pctlim = '80';
$outfile = "/tmp/spacefc.$PID.$tstamp";
$report[0] = "$tstamp - $0 starting on $host";
$rptct++;
$header = `df -k | grep "Filesystem"`;
chop($header);
$rptct++;
$report[$rptct] = $header;
@return = `df -k`;
for ($i = 1; $i <= $#return; $i++)
  {
     chop($return[$i]);
     #print "$return[$i]\n";
     @record = split(/[" "]+/,$return[$i]);
     $alloc = $record[1];
     $free = $record[2];
     $used = ($alloc - $free); 
     #print "-> Alloc = $alloc - Free = $free - Used = $used\n";
     $path = $record[6];
     #chop($path);
     $pct = $record[3];
     $pct =~ s/%//g;
     if ($pct > $pctlim)
       {
          #print "-> $return[$i]\n";
          $rptct++;
          $report[$rptct] = $return[$i];
          $pathct++;
          $pathchk[$pathct] = $path;
          $usedct++;
          $usedchk[$usedct] = $used;
       }
  }
$rptct++;
for ($p = 1; $p <= $#pathchk; $p++)
  {
     $rptct++;
     $cmd = "cd $pathchk[$p]; du -sk * | sort -nr | head -12";
     $report[$rptct] = "$cmd";
     @return1 = `$cmd`;
     $drl = $return1[0];
     chop($drl);
     $drl =~ s/\t/ /g;
     @record1 = split(/[" "]+/,$drl);
     $dcctl = $record1[0];
     if (-d "$pathchk[$p]/$record1[1]")
        {
           $drillct++;
           #print "-------> $pathchk[$p]\n";
           $drill[$drillct] = "$pathchk[$p]/$record1[1]";
           $sizechk[$drillct] = $usedchk[$p];
           #print "---0 ------ seting size check to $sizechk[$drillct] ++++++++++  $drill[$drillct]\n";
           $returntype = 'Directory';
        } else { $returntype = 'not selected. not a directory';}
     chop($return1[0]);
     $rptct++;
     #$report[$rptct] = "  $return1[0] - $returntype";
     $report[$rptct] = "  $return1[0]";
     $returntype = 'not selected';
     for ($c = 1; $c <= $#return1; $c++)
        {
          chop($return1[$c]);
          $chkt = $return1[$c];
          $chkt =~ s/\t/ /g;
          @record2 = split(/[" "]+/,$chkt);
          #print "-x-> $dcctl -- $record2[0]\n";
          if (length($dcctl) eq length($record2[0]))
            {
              if (-d "$pathchk[$p]/$record2[1]")
                {
                  $drillct++;
                  $drill[$drillct] = "$pathchk[$p]/$record2[1]";
                  $sizechk[$drillct] = $usedchk[$drillct];
                  #print "---1 ------ seting size check to $sizechk[$drillct] ++++++++++  $drill[$drillct]\n";
                  $returntype = 'Directory';
                } else { $returntype = 'Not a Directory';}
            }
          $rptct++;
          #$report[$rptct] = "  $return1[$c] - $returntype";
          $report[$rptct] = "  $return1[$c]";
          $returntype = 'not selected';
        }
     $rptct++;
  }
$DrillSeed = $#drill+1;
for ($d = 1; $d <= $#drill; $d++)
  {
     #print "-$d-> $drill[$d]\n";
     $cmd = "cd $drill[$d]; du -sk * | sort -nr | head -12";
     $rptct++;
     $report[$rptct] = "$cmd";
     @return2 = `$cmd`;
     for ($rt = 0; $rt <= $#return2; $rt++)
        {
          chop($return2[$rt]);
          $chkt = $return2[$rt];
          $chkt =~ s/\t/ /g;
          @record3 = split(/[" "]+/,$chkt);
          $chkt =~ s/\t/ /g;
          @record3 = split(/[" "]+/,$chkt);
          #print "--+-- $sizechk[$d] --- $record3[0] -- $return2[$rt]\n";
          if (length($sizechk[$d]) eq length($record3[0]))
            {
              if (-d "$drill[$d]/$record3[1]")
                {
                  #print "hit2\n";
                  $drillct++;
                  $drill[$drillct] = "$drill[$d]/$record3[1]";
                  $sizechk[$drillct] = $sizechk[$d];
                  #print "----2 ----- seting size check to $sizechk[$d] +++++ $drill[$drillct]\n";
                  $returntype = 'Directory';
                } else { $returntype = 'Not a Directory';}
            }
          $rptct++;
          #$report[$rptct] = "  $return2[$rt] - $returntype";
          $report[$rptct] = "  $return2[$rt]";
          $returntype = 'not selected';
        }
     $rptct++;
  }
unless (open(outfile,">$outfile")) {print "cant open $outfile\n";exit;}
for ($x = 0; $x <= $#report; $x++)
  {
     print outfile "$report[$x]\n";
     #print "$report[$x]\n";
  }
close(outfile);
$rc = system("cat $outfile | mailx -s \"Space Check on $host\" dsailors\@central.com;rm $outfile");
