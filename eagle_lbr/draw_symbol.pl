#!/usr/bin/perl -w
#
# This script takes in a partial eagle xml library file (symbols only)
# and generates an html file with a vector image of the symbol
#

use strict;
use XML::Simple;
use File::Slurp;
use Data::Dumper;

use eagle_draw;

if( $#ARGV < 0 )
{
  die("Usage: draw_symbol.pl library.lbr\n");
}

# Read in 'partial' XML eagle library
my $library_ref = XMLin($ARGV[0]);

my $symbol_ref = $library_ref->{symbol};

# Size of html canvas with the part
my $canvas_size = 480;

# If only one symbol is present, XML::Simple will not create a hash with the name
# so we need to access the content in a different way
if ( exists $symbol_ref->{name} ) {
  print "Error... Single symbol not yet supported. Go make more!\n";
} else {
  
  foreach my $symbol (sort keys %{$symbol_ref}) {
    my $output = "";
    
    # Initialize variables in the draw module
    draw_set_origin_from_xml(XMLout($symbol_ref->{$symbol}), $canvas_size);	 
    
    # Draw all of the wires
    $output = $output . draw_wires( $symbol_ref->{$symbol}->{wire} );        
    
    # Draw all of the pins
    foreach my $pin_name (sort keys %{$symbol_ref->{$symbol}->{pin}}) {
      $output = $output . draw_pin( $pin_name, $symbol_ref->{$symbol}->{pin}->{$pin_name}); 
    }    
    
    # Draw any text
    foreach my $text (@{$symbol_ref->{$symbol}->{text}}) {
      $output = $output . draw_text($text);                      
    }
    
    # Read in template html file
    my $template = read_file("part.template");
    
    # Replace template $variables$ with actual content
    $template =~ s/\$canvas_size\$/$canvas_size/gi;
    $template =~ s/\$canvas_name\$/paper/gi;
    $template =~ s/\$title\$/$symbol/gi;    
    $template =~ s/\$draw_area\$/$output/gi;    
    
    $symbol =~ s/\///gi;
    
    # Generate html file
    write_file("pages/$symbol.html", $template);
    
    # TODO Add to index and generate index.html
    
  }
    
}
