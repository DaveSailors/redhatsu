#!/usr/local/bin/perl
#
#-----------------------------------
# prompt user to continue
#
#-----------------------------------
#
while (($prompt ne "y") && ($prompt ne "n") && ($prompt ne "Y") && ($prompt ne "N"))
   {

     print "Do you want to continue with the build? [y or n] -> ";
     $prompt = <STDIN>;
     print "\n\n";
     chop($prompt);
     if (($prompt eq "n") || ($prompt eq "N"))
       {
          print "ALERT: - you entered $prompt\n";
          print "exiting with out doing anything...\n";
          exit;
       }
     if (($prompt ne "y") && ($prompt ne "n") && ($prompt ne "Y") && ($prompt ne "N"))
       {
          print "NOTE: - you entered $prompt\n";
          print "valid answers are y or n\n";
          print "\n\n";
       }
   }
