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
print $array[122]; # this will print Sequence #84
print "\n";


