#! /usr/bin/perl

use strict;
use warnings;
use feature qw(switch say); # need this for GIVEN-WHEN block
use Tie::IxHash;

#Define: 
my $inputfile  = 'SQL-query-results3.txt';
my $outputfile = 'SQL-query-results3fixed.txt';


#Declare new filehandle and associated it with filename
open ( my $fh,  '<', $inputfile) or die "\nCould not open file '$inputfile' $!\n";
open ( my $fh2, '>', $outputfile) or die "$!\n";

my @array = <$fh>;

# my $i = 0;
foreach ( @array )
{
#  print $_;
  (my $new = $_) =~ s/\s+\n//g;
  (my $newer = $new) =~ s/no rows selected\n*/no rows selected/g;
  print $fh2 "$newer";
#  my $newvar = $array[$i] =~ s/\h+/ /g;
#  my $newvar = $_ =~ s/\h+/ /g;
#  print $newvar;
#  $i += 1;
}

close ( $fh2 );
close ( $fh );
