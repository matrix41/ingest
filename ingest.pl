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


my @split_entry;
# Line 38 is the beginning of the data 
for ( my $j = 38; $j <= $#array; $j++ )
{
#  print $array[$j];
  @split_entry = split( /,/, $array[$j] );
#  print "$split_entry[0]  $split_entry[1]  $split_entry[2]  $split_entry[3]\n";
  # print "\nset heading off\n";
  # print "select OBJECTID, ALIASDIS\n";
  # print "from EXOP_LIT_ALIAS_TBL\n";
  # print "where EXOP_LIT_ALIAS_TBL.ALIASDIS like '%$split_entry[1] $split_entry[2]%';\n\n";

# $split_entry[1] : 47 UMa
# $split_entry[2] : c
# $split_entry[4] : plnorbper
# $split_entry[5] : plnorbpererr1 / plnorbpererr2 
# $split_entry[7] : plnrvamp 
# $split_entry[8] : plnrvamperr1 / plnrvamperr2 
# $split_entry[10] : plnorbeccen 
# $split_entry[11] : plnorbeccenerr1 / plnorbeccenerr2 
# $split_entry[13] : plnorblper 
# $split_entry[14] : plnorblpererr1 / plnorblpererr2 
# $split_entry[16] : plnorbtper 
# $split_entry[18] : plnorbtpererr1 / plnorbtpererr2 
# $split_entry[24] : plnmsinij 
# $split_entry[25] : plnmsinijerr1 / plnmsinijerr2 
# $split_entry[27] : plnorbsmax 
# $split_entry[28] : plnorbsmaxerr1 / plnorbsmaxerr2 
  print "$split_entry[1] $split_entry[2] $split_entry[4] $split_entry[5] $split_entry[7] $split_entry[8] $split_entry[10] $split_entry[11] $split_entry[13] $split_entry[14] $split_entry[16] $split_entry[18] $split_entry[24]$split_entry[25] $split_entry[27] $split_entry[28]\n"; 
}



# Create hash keys from the column headers 
my @splitarray = split(/,/, $array[36]); # Line 36 are the column headers 

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

