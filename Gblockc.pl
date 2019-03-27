#!/usr/bin/perl -w

my $usage=<<EOF;
--------------------------------
Gblock -t=c seems have bug sometimes, I want to take the place.

Usage: perl $0 cds.align >cds.align.gb

				        		Du Kang 2019-3-21

v2. 
	I give out a table file "n2o.pos" revealing the corresponding between sites positon id after and before gap-removing.
								2019-3-27

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

# tag the column that contains gap
foreach $key (keys %seq){
	$i=-1;
	for $codon ($seq{$key} =~ /(...)/g) {
		$i++;
		$gap{$i}=1 if $codon=~/-|tga|tag|taa/i;	# I swich stop codon to a gap
	}
	$codon_num=$i;
}

# keep the columns that contain no gaps and report the corresponding between site id after and before gap-removing
open TAB, ">>n2o.pos" or die "ERROR: $ARGV[0] says $!";
foreach $key (keys %seq){
	print TAB "$key\n";
	undef $oldpos;
	undef $newpos;
	foreach $i (0..$codon_num){
		$out{$key}.=substr($seq{$key}, 3*$i, 3) if ! exists $gap{$i};
			# keep the columns that contain no gaps

		$flag= substr($seq{$key}, 3*$i, 3) !~ /-|tga|tag|taa/i ? 1 : 0;

		$oldpos=0 if $flag==1 and !defined $oldpos;
		$oldpos++ if $flag==1;
			# get the old position id of the site

		$newpos=0 if $flag==1  and !defined $oldpos and ! exists $gap{$i};
		$newpos++ if $flag==1 and ! exists $gap{$i};
			# get the new position id of the site

		print TAB "#$newpos\t$oldpos\n" if ! exists $gap{$i} and defined $newpos;
	}
}
close TAB;

# output
foreach $key (keys %seq){
	defined $out{$key}? print "$key\n$out{$key}\n" : die "Warning: with gaps removed, $ARGV[0] have no alignment column left!!\n";
}

