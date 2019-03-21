#!/usr/bin/perl -w

my $usage=<<EOF;
--------------------------------
Gblock -t=c seems have bug sometimes, I want to take the place.

Usage: perl $0 cds.align >cds.align.gb

				        		Du Kang 2019-3-21
--------------------------------
EOF
# about how to use the script

@ARGV or die $usage;

# read in sequence
open IN, $ARGV[0] or die $!;
while (<IN>) {
	chomp;
	if (/>/) {
		$name=$_;
	}else{
		$seq{$name}.=$_;
	}
}
close IN;

# tag the column that contains no gap
foreach $key (keys %seq){
	$i=-1;
	for $codon ($seq{$key} =~ /(...)/g) {
		$i++;
		$gap{$i}=1 if $codon=~/-/;
	}
	$codon_num=$i;
}

# keep the columns that contain no gaps
foreach $key (keys %seq){
	foreach $i (0..$codon_num){
		$out{$key}.=substr($seq{$key}, 3*$i, 3) if ! exists $gap{$i};
	}
}

# output
foreach $key (keys %seq){
	print "$key\n$out{$key}\n";
}

