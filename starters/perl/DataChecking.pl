#!/usr/bin/perl

# get input

print "So what's your email address, anyway?\n";

$email =

;

chomp($email);

# match and display result

if($email =~

/^([a-zA-Z0-9])+([\.a-zA-Z0-9_-])*@([a-zA-Z0-9_-])+(\.[a-zA-Z0-9_-]+)+/) 

{

print("Ummmmm....that sounds good!\n");

} else 

{

print("Hey - who do you think you're kidding?\n");

}

