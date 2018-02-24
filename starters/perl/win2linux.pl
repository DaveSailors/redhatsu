#!/usr/bin/perl
$infile = $ARGV[0];
if ($infile eq '') 
   {
     print "no file specified\n";
     print "usage: $0 filepath\n";
     exit;
   }
$outfile = "/tmp/y.del";
unless (open(outfile,">$outfile")) {print "cant open $outfile\n";exit;}
unless (open(infile,"$infile")) {print "cant open $infile\n";exit;}
  {
       @line =<infile>;
    for ($i = 0; $i <= $#line; $i++)
     {
       print "->$line[$i]";
           $char1 = substr($line[$i],length($line[$i])-1,1);
           $char2 = substr($line[$i],length($line[$i])-2,1);
           $asci1 = ord($char1);
           $asci2 = ord($char2);
           print "asci = $asci2 - $asci1 \n";
           $outline = $line[$i];
           if ($asci2 eq '13')
             {
               print "hit on asci 10\n";
               $outline = substr($line[$i],0,length($line[$i])-2)."\n";
             }
        print outfile "$outline";
     }

  }
close(outfile);
$rc = system("cp $outfile $infile");

