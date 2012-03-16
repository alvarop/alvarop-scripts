#!/bin/perl -w

# Generate .htaccess mod_rewrite file from csv
# csv has source(old blogger url) on the first column and destination(new wordpress url) on the right

my $url = "http://alvarop.com/";

print "RewriteEngine  on\n";

$/ = "\r\n";

while(<>)
{
	chomp;
	@line = split /,/, $_;
	$line[0] =~ s/\//\\\//g;
	print "RewriteRule $line[0] $url$line[1] [R]\n";
}