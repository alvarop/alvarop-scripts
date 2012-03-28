#!/usr/bin/perl -w
#
# Generate the raphael (raphaeljs.com) javascript for various shapes
#

package raphael;
use Exporter;

@ISA = ('Exporter');
@EXPORT = qw(raphael_circle raphael_text raphael_path raphael_line raphael_rotate);

sub raphael_circle {
  (my $x, my $y, my $r) = @_;
  return "paper.circle($x, $y, $r)";
}

sub raphael_text {
  (my $x, my $y, my $text, my $size) = @_;
  return "paper.text($x, $y, \"$text\").attr({'text-anchor': 'start','font-family':'helvetica','font-size':'$size'})";
}

sub raphael_path {  
  return "paper.path(\"@_\")";
}

sub raphael_line {
  (my $x1, my $y1, my $x2, my $y2) = @_;
  return "paper.path(\"M$x1 $y1 L$x2 $y2\")";
}

sub raphael_rotate {
  (my $angle, my $x, my $y) = @_;
  return ".rotate($angle, $x, $y)";
}

1;
