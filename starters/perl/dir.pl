#!/usr/bin/perl
$dir="/var";
print "Contents of $dir Directory\n";
unless (opendir(HOMEDIR,"$dir")) {print "Unable to open directory $dir\n";}
 while ($filename = readdir(HOMEDIR))
  {
    print "$filename\n";
  }

