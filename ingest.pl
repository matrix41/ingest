#! /usr/bin/perl 

use strict;
use warnings;
use feature qw(switch say); # need this for GIVEN-WHEN block
use Tie::IxHash;

#Define: 
my $inputfile = 'J_ApJ_646_505_table3-140624.csv';


#Declare new filehandle and associated it with filename
open (my $fh, '<', $inputfile) or die "\nCould not open file '$inputfile' $!\n";

my @array = <$fh>;

close ($fh);


# print @array;
# print $array[122]; # this will print Sequence #84


# print "$array[36]\n"; # this will print all the headers
# print "$array[37]\n"; # this will print all the metric units (m/s, deg, AU, ....)


# Create hash keys from the column headers 
my @splitarray = split(/,/, $array[36]);

# OLD
# my %butler_hash = ();
# NEW
tie my %butler_hash, "Tie::IxHash" or die "could not tie %hash";


my $temp;
for ( my $i = 0; $i <= $#splitarray; $i++ ) 
{

#  print "Index $i ==> $splitarray[$i]||||||\n"; # output splitarray contents

# NOTE-TO-SELF: I wrote the following IF block below because the 
# last key value -- RV -- has this weird return character in it 
# that fucks up my hash keys and produces unexpected results.  
# This kluge addresses the problem.  (7/3/2014)
  if ( $splitarray[$i] =~ /RV/ ) {
    $butler_hash{RV} = undef;
  } else {
    $butler_hash{"$splitarray[$i]"} = undef;
  }
}

# this WHILE-loop prints the contents of the hash header 
while ( my ($key, $value) = each(%butler_hash) ) {
    if ( ! defined $butler_hash{$key} ) {
        print "$key ==> undef\n";
    } else {
        print "$key ==> $value\n";
    }
}

# print "$splitarray[1]\n";
# print "$splitarray[2]\n";
# print "$splitarray[3]\n";
# print "$splitarray[4]\n";
# print "$splitarray[5]\n";
# print "$splitarray[6]\n";

