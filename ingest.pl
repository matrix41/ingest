#! /usr/bin/perl 

use strict;
use warnings;
use feature qw(switch say); # need this for GIVEN-WHEN block

#Define: 
my $inputfile = 'J_ApJ_646_505_table3-140624.csv';


#Declare new filehandle and associated it with filename
open (my $fh, '<', $inputfile) or die "\nCould not open file '$inputfile' $!\n";

my @array = <$fh>;

close ($fh);


# print @array;
# print $array[122]; # this will print Sequence #84
# print $array[36]; # this will print all the headers
print $array[36];
print "\n";
my @splitarray = split(/,/, $array[36]);

for ( my $i = 0; $i <= $#splitarray; $i++ ) 
{
  print "Index $i ==> $splitarray[$i]\n";

}


# print "$splitarray[1]\n";
# print "$splitarray[2]\n";
# print "$splitarray[3]\n";
# print "$splitarray[4]\n";
# print "$splitarray[5]\n";
# print "$splitarray[6]\n";

