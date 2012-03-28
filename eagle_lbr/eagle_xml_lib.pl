#!/usr/bin/perl -w

use strict;
use XML::Simple;

use Data::Dumper;

if( $#ARGV < 0 )
{
  die("Usage: eagle_xml_lib.pl library.lbr\n");
}

my $library_ref = XMLin($ARGV[0]);

print "--Available packages--\n";

my $package_ref = $library_ref->{drawing}->{library}->{packages}->{package};

# If only one package is present, XML::Simple will not create a hash with the name
# so we need to access the content in a different way
if ( exists $package_ref->{name} ) {
  my $description = $package_ref->{description};
    
  # Get rid of newlines
  $description =~ s/[\n|\r]//gi;
  
  print "$package_ref->{name} - $description\n";
} else {
  # Print all packages and descriptions
  foreach my $package (sort keys %{$package_ref}) {
    # Get the description for the specified package
	  my $description = $package_ref->{$package}->{description};
    
    # Make sure we don't get uninitialized errors (probably better to ignore up top)
    if ( ! $description )
    {
      $description = "";
    }
    
    # Get rid of newlines
	  $description =~ s/[\n|\r]//gi;
	  
	  # Get rid of some html tags
	  $description =~ s/<[A-Za-z\/\s]*>//gi;
	
    print "$package - $description\n";
  }
}

print "\n--Available symbols--\n";

my $symbol_ref = $library_ref->{drawing}->{library}->{symbols}->{symbol};

# If only one symbol is present, XML::Simple will not create a hash with the name
# so we need to access the content in a different way
if ( exists $symbol_ref->{name} ) {
  print "$symbol_ref->{name}\n";
} else {
  # Print all symbols
  foreach my $symbol (sort keys %{$symbol_ref}) {   
	
    print "$symbol\n";
    
  }
}

print "\n--Available Devices--\n";

my $deviceset_ref = $library_ref->{drawing}->{library}->{devicesets}->{deviceset};

# If only one device-set is present, XML::Simple will not create a hash with the name
# so we need to access the content in a different way
if ( exists $deviceset_ref->{name} ) {
  
  print "$deviceset_ref->{name}\n";
  
  if( exists $deviceset_ref->{devices}->{device}->{name} ) {
      print "\t$deviceset_ref->{devices}->{device}->{name} - $deviceset_ref->{devices}->{device}->{package}\n";
    } else {
      foreach my $device (sort keys %{$deviceset_ref->{devices}->{device}}) {
        print "\t$device - $deviceset_ref->{devices}->{device}->{$device}->{package}\n"
      }
    }
} else {
  # Print all device-sets
  foreach my $deviceset (sort keys %{$deviceset_ref}) {   
	
    print "$deviceset:\n";

    if( exists $deviceset_ref->{$deviceset}->{devices}->{device}->{name} ) {
      print "\t$deviceset_ref->{$deviceset}->{devices}->{device}->{name} - $deviceset_ref->{$deviceset}->{devices}->{device}->{package}\n";
    } else {
      foreach my $device (sort keys %{$deviceset_ref->{$deviceset}->{devices}->{device}}) {
        print "\t$device - $deviceset_ref->{$deviceset}->{devices}->{device}->{$device}->{package}\n"
      }
    }
  }
}
