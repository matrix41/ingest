#! /usr/bin/perl 

use strict;
use warnings;
use feature qw(switch say); # need this for GIVEN-WHEN block
# use Tie::IxHash;
use func_ppar2;
# use bignum; # using this to try to fix my plnorbtpererr2 problem; it did not work 

#Define: 
my $inputfile = 'J_ApJ_646_505_table3-140624.csv';
my $outputfile = 'butler_table3a.txt';

my @kill_list;
push(@kill_list, "HD 142 b"); # 1 of 18 existing REFID=175 planets 
push(@kill_list, "HD 1237 b"); # 2 of 18 existing REFID=175 planets 
push(@kill_list, "HD 10647 b"); # 3 of 18 existing REFID=175 planets 
push(@kill_list, "HD 13445 b"); # 4 of 18 existing REFID=175 planets 
push(@kill_list, "79 Cet b"); # 5 of 18 existing REFID=175 planets 
push(@kill_list, "HD 83443 b"); # 6 of 18 existing REFID=175 planets 
push(@kill_list, "HD 102117 b"); # 7 of 18 existing REFID=175 planets 
push(@kill_list, "HD 107148 b"); # 8 of 18 existing REFID=175 planets 
push(@kill_list, "HD 108147 b"); # 9 of 18 existing REFID=175 planets 
push(@kill_list, "HD 111232 b"); # 10 of 18 existing REFID=175 planets 
push(@kill_list, "HD 114762 b"); # 11 of 18 existing REFID=175 planets 
push(@kill_list, "HD 114729 b"); # 12 of 18 existing REFID=175 planets 
push(@kill_list, "70 Vir b"); # 13 of 18 existing REFID=175 planets 
push(@kill_list, "HD 117207 b"); # 14 of 18 existing REFID=175 planets 
push(@kill_list, "HD 117618 b"); # 15 of 18 existing REFID=175 planets 
push(@kill_list, "HD 164922 b"); # 16 of 18 existing REFID=175 planets 
push(@kill_list, "16 Cyg B b"); # 17 of 18 existing REFID=175 planets 
push(@kill_list, "51 Peg b"); # 18 of 18 existing REFID=175 planets 
push(@kill_list, "HD 136118 b"); # brown dwarf 
push(@kill_list, "HD 137510 b"); # brown dwarf 
push(@kill_list, "HD 168746 b"); # Tracy recently updated this planet (formerly REFID=96) (7/8/14)
push(@kill_list, "HD 179949 b"); # Tracy recently updated this planet (formerly REFID=96) (7/8/14)
push(@kill_list, "HD 33636 b"); # already on the Removed Targets List
push(@kill_list, "HD 150706 b"); # Tracy will personally add/default this planet to DB (7/8/14)


#Declare new filehandle and associated it with filename
open (my $fh, '<', $inputfile) or die "\nCould not open file '$inputfile' $!\n";

my @array = <$fh>;

close ($fh);


# print @array;
# print $array[122]; # this will print Sequence #84


# print "$array[36]\n"; # this will print all the headers
# print "$array[37]\n"; # this will print all the metric units (m/s, deg, AU, ....)


open ( my $fh2, '>', $outputfile ) or die "\nCould not open file $outputfile $!\n";

my %outbound_hash = ();
my $howmanyA;
my $howmanyB;
my $sigdig;

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
  if ( $split_entry[34] =~ /^Bu6$/ ) # get only those sources that are original work by Butler 
  {
# Step 2 of 3: this FOR loops checks whether the planet is in the kill list 
    for ( my $k = 0 ; $k <= $#kill_list ; $k++ )
    {
 #     print "kill_list: $kill_list[$k]\n";
      $reject = 1 if ( $planet_name =~ /$kill_list[$k]/ )
    }
# Step 3 of 3: after looping through the entire kill list in Step 2, generate 
# the .edm planet parameter file by a.) loading the hash $outbound_hash, and 
# b.) sending hash to subroutine make_edm.  
    if ( $reject == 0 ) # if $planet_name is not in the kill list, then print this planet 
    {
#      print "$j $split_entry[1] $split_entry[2] $split_entry[4] $split_entry[5] $split_entry[7] $split_entry[8] $split_entry[10] $split_entry[11] $split_entry[13] $split_entry[14] $split_entry[16] $split_entry[18] $split_entry[24]$split_entry[25] $split_entry[27] $split_entry[28] $split_entry[34]\n";
      print $fh2 "$split_entry[1] $split_entry[2] $split_entry[4] $split_entry[5] $split_entry[7] $split_entry[8] $split_entry[10] $split_entry[11] $split_entry[13] $split_entry[14] $split_entry[16] $split_entry[18] $split_entry[24]$split_entry[25] $split_entry[27] $split_entry[28] $split_entry[34]\n";
      $outbound_hash{'plnname'} = $split_entry[1]; 
      $outbound_hash{'plnletter'} = $split_entry[2];
      $outbound_hash{'plnorbper'} = $split_entry[4];
      $outbound_hash{'plnorbpererr1'} = $split_entry[5];
      $outbound_hash{'plnorbpererr2'} = -$split_entry[5];
      $outbound_hash{'plnrvamp'} = $split_entry[7];
      $outbound_hash{'plnrvamperr1'} = $split_entry[8];
      $outbound_hash{'plnrvamperr2'} = -$split_entry[8];
      $outbound_hash{'plnorbeccen'} = $split_entry[10];
      $outbound_hash{'plnorbeccenerr1'} = $split_entry[11];
      $outbound_hash{'plnorbeccenerr2'} = -$split_entry[11];
      $outbound_hash{'plnorblper'} = $split_entry[13];
      if ( length($split_entry[14]) > 0 )
      {
        $outbound_hash{'plnorblpererr1'} = $split_entry[14];
        $outbound_hash{'plnorblpererr2'} = -$split_entry[14];
      }
      $outbound_hash{'plnorbtper'} = $split_entry[16] + 2440000; # Julian day format
#      print "\n\nGI Joe1 $split_entry[18]\n\n";
#      print "\n\nGI Joe2 -$split_entry[18]\n\n";
      $outbound_hash{'plnorbtpererr1'} = $split_entry[18];
# Crazy Step 0 of 4: This line doesn't preserve trailing zeroes. 
#      $outbound_hash{'plnorbtpererr2'} = -$split_entry[18];

# Crazy Step 1 of 4: Calculate the length of decimal number. 
      $howmanyA = length($split_entry[18]);
#      print "howmanyA = $howmanyA\n\n";
# Crazy Step 2 of 4: Calculate the integer portion of decimal number. 
      $howmanyB = length(int($split_entry[18]));
#      print "howmanyB = $howmanyB\n\n";
# Crazy Step 3 of 4: Now subtract the length of integer portion from the original length.
#                    Also, subtract one more to account for the decimal place. 
      $sigdig = $howmanyA-$howmanyB-1;
#      print "sigdig = $sigdig\n\n";
# Crazy Step 4 of 4: Now use the computed length $sigdig to control the 
#                    number of significant digits. 
      $outbound_hash{'plnorbtpererr2'} = sprintf "%.${sigdig}f", -$split_entry[18];
#      printf "\n\nGI Joe3 $outbound_hash{'plnorbtpererr2'}\n\n";

# Note-to-self: I did not want to use the two lines below because I could 
# not use a fixed value in setting the significant digit
#      $outbound_hash{'plnorbtpererr1'} = sprintf "%.1f", $split_entry[18];
#      $outbound_hash{'plnorbtpererr2'} = sprintf "%.1f", -$split_entry[18];
      $outbound_hash{'plnmsinij'} = $split_entry[24];
      $outbound_hash{'plnmsinijerr1'} = $split_entry[25];
      $outbound_hash{'plnmsinijerr2'} = -$split_entry[25];
      $outbound_hash{'plnorbsmax'} = $split_entry[27];
      $outbound_hash{'plnorbsmaxerr1'} = $split_entry[28];
      $outbound_hash{'plnorbsmaxerr2'} = -$split_entry[28];

      $outbound_hash{'plnorbperlim'} = 0;
      $outbound_hash{'plnorbsmaxlim'} = 0;
      $outbound_hash{'plnorbtperlim'} = 0;
      $outbound_hash{'plnorbeccenlim'} = 0;
      $outbound_hash{'plnorblperlim'} = 0;
      $outbound_hash{'plnrvamplim'} = 0;
      $outbound_hash{'plnmsinilim'} = 0;
      $outbound_hash{'plnrefid'} = 175;
      $outbound_hash{'plnorbmethod'} = "RV";

  # Now pass outbound_hash to my subroutine make_edm
      make_edm( %outbound_hash );

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
  if ( $splitarray[$i] =~ /RV/ )
  {
    $butler_hash{RV} = undef;
  }
  else
  {
    $butler_hash{"$splitarray[$i]"} = undef;
  }
}

# this WHILE-loop prints the contents of the hash header 
while ( my ($key, $value) = each(%butler_hash) )
{
  if ( ! defined $butler_hash{$key} )
  {
    print "$key ==> undef\n";
  }
  else
  {
    print "$key ==> $value\n";
  }
}


