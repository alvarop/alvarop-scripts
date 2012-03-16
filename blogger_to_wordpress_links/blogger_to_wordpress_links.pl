#!/bin/perl -w

# Table of contents html file from blogger
my $blogger_toc_file = "toc.html";

# Exported wordpress xml file
my $wordpress_export_file = "wpexport.xml";

my %blogger_links;

# Import blogger permanent links
open(IN_FILE, "<$blogger_toc_file");

while(<IN_FILE>)
{
	while( m/<tr><td class="toc-entry-col1"><a href="http:\/\/blog.alvarop.com\/([0-9]{4}\/[0-9]{2}\/[A-Za-z0-9\-\_]*).html"/g )
	{
		$blogger_links{$1} = "";		
	}
}

close(IN_FILE);

our @unmatched_links;

# Import blogger permanent links
open(IN_FILE, "<$wordpress_export_file");

while(<IN_FILE>)
{
	while( m/<link>http:\/\/alvarop.com\/([0-9]{4}\/[0-9]{2}\/[A-Za-z0-9\-\_]*)\/<\/link>/g )
	{
		our $wp_link = $1;
		our $match = 0;
		foreach $key (keys %blogger_links) {
			if( $key =~ m/$wp_link/g ) {
				$blogger_links{$key} = $wp_link;
				$match = 1;
			}
		}
		
		if( !$match )
		{			
			unshift @unmatched_links, $1;
		}
		
	}
}

close(IN_FILE);

my $count = 0;

foreach $key (sort keys %blogger_links) {
     print "$key.html,$blogger_links{$key}\n";	
}


print "\n\nUnmatched links:\n,";
$, = "\n,";
print @unmatched_links;
