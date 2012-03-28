#!/usr/bin/perl -w
#
# This file has functions for drawing parts of eagle symbols using the raphael
# perl module
#

package eagle_draw;
use List::Util qw(max min);
use Exporter;
use raphael;

@ISA = ('Exporter');
@EXPORT = qw(draw_text draw_wires draw_pin raphael_line raphael_rotate draw_set_origin_from_xml);

our $base_x;
our $base_y;
our $base_scale;

our %pin_length;
$pin_length{short} = 2.5;
$pin_length{middle} = 5;

sub draw_set_origin_from_xml {
  # Get all of the dimensions found in the xml
  my @matches = $_[0] =~ m/(?:x1|x2|y1|y2|x|y)=\"([+-]?[0-9.]+)\"/g;
  my $canvas_size = $_[1];
  
  # Get the largest and smalles dimesions found
  # Multiply by 1.5 to make the canvas slightly bigger than the part
  my $max = max(@matches)*1.5;
  my $min = min(@matches)*1.5;
  
  # Compute the center position (eagle choordinates can be negative)
  $base_x = (($max - $min)/2);
  $base_y = (($max - $min)/2);
  
  # Make sure we stretch out to fill the canvas
  $base_scale = $canvas_size / (2*$max);  
}

sub draw_text { 
  my $text = shift @_;

  # Draw Text 
  return raphael_text( (($text->{x} + $base_x) * $base_scale),
                  (($text->{y} + $base_y + $text->{size}/2) * $base_scale),
                  $text->{content},
                  ($text->{size} * $base_scale)) . ";\n";
}

sub draw_wires {
  my @path ;
  
  # Make a list of all the lines to use only one draw path command
  foreach my $wire (@{$_[0]}) {    
    unshift @path, "M" . ($wire->{x1} + $base_x) * $base_scale . " " . ($wire->{y1} + $base_y) * $base_scale . "L" . ($wire->{x2} + $base_x) * $base_scale . " " . ($wire->{y2} + $base_y) * $base_scale;
  }
  
  @path = reverse @path;
          
  return raphael_path( @path ) . ";\n";

}

sub draw_pin {

  (my $pin_name, my $pin) = @_;
  
  my $output = "";
  
  # Draw circle at the end of the pin
  # TODO: Make circle radius variable
  $output = $output . raphael_circle ((($pin->{x} + $base_x) * $base_scale), (($pin->{y} + $base_y) * $base_scale), 2) . ";\n";
  
  # Draw Pin Line
  $output = $output . raphael_line( (($pin->{x} + $base_x) * $base_scale),
                (($pin->{y} + $base_y) * $base_scale),
                (($pin->{x} + $pin_length{$pin->{length}} + $base_x) * $base_scale),
                (($pin->{y} + $base_y) * $base_scale));     
  
  # If the pin is 'rotated', do so
  if( exists $pin->{rot} ) {
    
    $pin->{rot} =~ m/([R|L])([0-9\.]+)/gi;

    my $angle = $2;
    if($1 eq 'L') {
      $angle = -$angle;
    }
    
    $output = $output . raphael_rotate( $angle, (($pin->{x} + $base_x) * $base_scale),
                    (($pin->{y} + $base_y) * $base_scale));
  }
  $output = $output . ";\n";
  
  #TODO Draw pin labels
  
  return $output;
  
}

1;
