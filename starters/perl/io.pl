#!/usr/bin/perl
$infile = "x.del";
$outfile = "y.del";
unless (open(outfile,">$outfile")) {print "cant open $outfile\n";exit;}
unless (open(infile,"$infile")) {print "cant open $infile\n";exit;}
  {
       $line =<infile>;
       while ($line ne "")
        {
          print "$line\n";
          print outfile ("$line\n");
          $line =<infile>;

        }
  }

