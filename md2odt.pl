#!/usr/bin/perl
use strict;
use warnings;

# ============= parameters =============

if (@ARGV == 0) {
	die("please specify Markdown input file");
}

my $infile=$ARGV[0];
my $outfile="output";

my $outfile_xml="odt_gen/content.xml";
my $header="header.xml";

my $wd="/home/bz/Dropbox/scripts/markdown-footnote";

# ============= do =============

my $in_a_list=0;
my $footnote_counter=1;

open IN, "<$infile";
open OUT, ">$wd/$outfile_xml";

print OUT `cat $wd/$header`;

while (<IN>) {
	chomp;
	
	if (/^## /) {
		my $header=$';
		print OUT "<text:h text:style-name=\"Heading_20_2\" text:outline-level=\"2\">$header</text:h>\n";

		# exit list mode, if necessary

		if ($in_a_list == 1) {
			$in_a_list=0;
			print OUT "</text:list>\n";
		}
	} elsif (/^\- /) {
		my $listitem=$';

		# make sure to enter list mode
		
		if ($in_a_list == 0) {
			$in_a_list=1;
			print OUT "<text:list xml:id=\"list4193433235\" text:style-name=\"L1\">\n";
		}

		print OUT "<text:list-item>\n<text:p text:style-name=\"P3\">\n";
		
		# bold, italics
		
		$listitem =~ s/_(.*?)_/<text:span text:style-name="Emphasis">$1<\/text:span>/g;
		$listitem =~ s/\*\*(.*?)\*\*/<text:span text:style-name="Strong_20_Emphasis">$1<\/text:span>/g;
		
		# footnotes
		
		my $listitem_from=$listitem;
		my $listitem_to="";
		
		while ($listitem_from =~ /\^\[(.*?)\]/g) {
			my $footnote_text=$1;
			
			my $elotte=$`;
			my $utana=$';
			
			# span's around all tags
			$footnote_text=~s/<(.*?)>/<\/text:span><$1><text:span text:style-name="T1">/g;
			
			$listitem_to.=$elotte;
			$listitem_to.="<text:note text:id=\"ftn$footnote_counter\" text:note-class=\"footnote\">\n".
				"<text:note-citation>$footnote_counter</text:note-citation>\n".
				"<text:note-body><text:p text:style-name=\"P1\">\n".
				"<text:span text:style-name=\"T1\">\n$footnote_text\n".
				"</text:span>\n".
				"</text:p></text:note-body>\n".
				"</text:note>\n";
			
			$listitem_from=$utana;
		}

		$listitem_to.=$listitem_from;
		
		print OUT "$listitem_to</text:p>\n</text:list-item>\n";
		#print OUT "$listitem</text:p>\n</text:list-item>\n";

	} else {
		# exit list mode, if necessary

		if ($in_a_list == 1) {
			$in_a_list=0;
			print OUT "</text:list>\n";
		}
	}
}

# exit list mode, if necessary

if ($in_a_list == 1) {
	$in_a_list=0;
	print OUT "</text:list>\n";
}

close IN;

print OUT "</office:text>".
	"</office:body>".
	"</office:document-content>";
close OUT;

# ============= create ODT, PDF =============

`cd $wd/odt_gen && zip -r $outfile *`;
`mv $wd/odt_gen/$outfile.zip $outfile.odt`;
`libreoffice6.4 --headless --convert-to pdf $outfile.odt`;

print "$outfile.odt, $outfile.pdf created.\n";
