#!/usr/bin/perl
$infile = "x.del";
$outfile = "y.del";
unless (open(outfile,">$outfile")) {print "cant open $outfile\n";exit;}
unless (open(infile,"$infile")) {print "cant open $infile\n";exit;}
  {
       @line =<infile>;
    for ($i = 0; $i <= $#line; $i++)
     {
       print "$line[$i]";
       print outfile "$line[$i]";
     }

  }

