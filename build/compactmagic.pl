#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id: compactmagic.pl,v 1.19 2006/03/04 13:12:52 papu Exp $

$header="#----------------------------------------------------------------------\n";
$output=0;
$chk=0;
$title=0;
$file=$ARGV[0];
$opt=$ARGV[1];
if(open(R,$file)) {
	foreach $f (<R>) {
		chomp $f;
		if($f=~/^\#\-\-\-\-/) {
			$output=0;
			$chk++;
			next;
		} elsif($chk > 0) {
			$chk++;
			$chk=0 if($chk > 2);
			$output=&check($f);
			if($output eq 1) {
				print "$header";
				print "$f\n";
				$chk=0;
				$title=1;
			}
			next;
		}
		if($output eq 1) {
			if($f=~/^#.+/) {
				next if($title eq 0);
			} elsif($f=~/^#\s*$/) {
				next;
			} else {
				$title=0;
			}
			next if($f=~/^\s*$/);
			$f=~s/\s\s+/\t/g;
			print "$f\n";
		}
	}
	close(R);
}

sub check {
	$_=lc shift;
	$ret=0;
	$ret=1 if(/archive/);
	$ret=1 if(/jpeg/);
	$ret=1 if(/images/);
	$ret=1 if(/compress\:/);
	if($opt ne 'compact') {
		$ret=1 if(/cabinet/);
		$ret=1 if(/msdos/);
		$ret=1 if(/rtf/);
		$ret=1 if(/animation/);
		$ret=1 if(/macintosh/);
		$ret=1 if(/commands/);
		$ret=1 if(/mail*news/);
		$ret=1 if(/rpm/);
		$ret=1 if(/perl/);
		$ret=1 if(/flash/);
		$ret=1 if(/pdf/);
		$ret=1 if(/sgml|html|hypertext/);
		$ret=1 if(/mime/);
		$ret=1 if(/uuencode/);
		$ret=1 if(/audio/);
		$ret=1 if(/riff/);
		$ret=1 if(/program/);
		$ret=1 if(/pgp/);
		$ret=1 if(/python/);
	}
	$ret=0 if(/sccs/);
	$ret=1 if(/\$id.*exp/);
	$ret=0 if(!/^#/);
	return $ret;
}

