#! /usr/bin/perl 

use strict;
use warnings;
use feature qw(switch say); # need this for GIVEN-WHEN block
use Tie::IxHash;

#Define: 
my $inputfile = 'J_ApJ_646_505_table3-140624.csv';
my $outputfile = 'butler_table3a.txt';
my @kill_list = ("HD 142 b", "HD 1237 b", "HD 10647 b", "HD 13445 b", "79 Cet b", "HD 83443 b", 
                 "HD 102117 b", "HD 107148 b", "HD 108147 b", "HD 111232 b", "HD 114762 b", 
                 "HD 114729 b", "70 Vir b", "HD 117207 b", "HD 117618 b", "HD 164922 b", 
                 "16 Cyg B b", "51 Peg b");

#Declare new filehandle and associated it with filename
open (my $fh, '<', $inputfile) or die "\nCould not open file '$inputfile' $!\n";

my @array = <$fh>;

close ($fh);


# print @array;
# print $array[122]; # this will print Sequence #84


# print "$array[36]\n"; # this will print all the headers
# print "$array[37]\n"; # this will print all the metric units (m/s, deg, AU, ....)


open ( my $fh2, '>', $outputfile ) or die "\nCould not open file $outputfile $!\n";

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
  my $reject = 0; #initialize reject variable: "0" = keep | "1" = reject 
  my $planet_name = "$split_entry[1]"." "."$split_entry[2]";
#  print "My planet name is $planet_name\n";


# Step 1 of 3: this IF block only considers original research done by Butler 2006 
# Step 2 of 3: this FOR loops checks whether the planet is in the kill list 
  if ( $split_entry[34] =~ /^Bu6$/ ) # get only those sources that are original work by Butler 
  {
    for ( my $k = 0 ; $k <= $#kill_list ; $k++ )
    {
 #     print "kill_list: $kill_list[$k]\n";
      $reject = 1 if ( $planet_name =~ /$kill_list[$k]/ )
    }
    if ( $reject == 0 ) # if $planet_name is not in the kill list, then print this planet 
    {
      print $fh2 "$split_entry[1] $split_entry[2] $split_entry[4] $split_entry[5] $split_entry[7] $split_entry[8] $split_entry[10] $split_entry[11] $split_entry[13] $split_entry[14] $split_entry[16] $split_entry[18] $split_entry[24]$split_entry[25] $split_entry[27] $split_entry[28] $split_entry[34]\n";
    }
  } # end IF block Bu6
} # end FOR loop array

close ($fh2);

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

