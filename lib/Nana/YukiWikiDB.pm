######################################################################
# YukiWikiDB.pm - This is PyukiWiki, yet another Wiki clone.
# $Id: YukiWikiDB.pm,v 1.47 2006/09/29 09:11:32 papu Exp $
#
# "Nana::YukiWikiDB" version 0.3p $$
# Author: Hiroshi Yuki
# http://www.hyuki.com/
# Copyright (C) 2004-2006 by Nekyo.
# http://nekyo.hp.infoseek.co.jp/
# Copyright (C) 2005-2006 PyukiWiki Developers Team
# http://pyukiwiki.sourceforge.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sourceforge.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################

package Nana::YukiWikiDB;
$VERSION="0.3p";
use strict;
use Nana::File;

# Constructor
sub new {
	return shift->TIEHASH(@_);
}

# error									# debug
sub die {								# debug
	$::debug.="YukiWikiDB:$_[0]\n";		# debug
	return undef;						# debug
}										# debug

# tying
sub TIEHASH {
	my ($class, $dbname) = @_;
	my $self = {
		dir => $dbname,
		keys => [],
	};
	if (not -d $self->{dir}) {
		if (!mkdir($self->{dir}, 0777)) {
			return &die("mkdir $self->{dir} fail"); # debug
			return undef;
		}
	}
	return bless($self, $class);
}

# Store
sub STORE {
	my ($self, $key, $value) = @_;
	my $filename = &make_filename($self, $key);
#	&lock_store($filename, $value);
#	return $value;
	return Nana::File::lock_store($filename,$value);
}

# Fetch
sub FETCH {
	my ($self, $key) = @_;
	my $filename = &make_filename($self, $key);
#	my $value = &lock_fetch($filename);
#	return $value;
	return Nana::File::lock_fetch($filename);
}

# Exists
sub EXISTS {
	my ($self, $key) = @_;
	my $filename = &make_filename($self, $key);
	return -e($filename);
}

# Delete
sub DELETE {
	my ($self, $key) = @_;
	my $filename = &make_filename($self, $key);
	return Nana::File::lock_delete($filename);
	#unlink $filename;
	# return delete $self->{$key};
}

sub FIRSTKEY {
	my ($self) = @_;
	if(opendir(DIR, $self->{dir})) {
		my $funcp = $::functions{"undbmname"};
		@{$self->{keys}} = grep /\.txt$/, readdir(DIR);
		foreach my $name (@{$self->{keys}}) {
			$name =~ s/\.txt$//;
#			$name =~ s/[0-9A-F][0-9A-F]/pack("C", hex($&))/eg;	# debug
#			$name=&undbmname($name);
			$name=&$funcp($name);
		}
		closedir(DIR);
		return shift @{$self->{keys}};
	} else {											# debug
		return &die("FIRSTKEY: $self->{dir} fail"); 	# debug
	}
	return;
}

sub NEXTKEY {
	my ($self) = @_;
	return shift @{$self->{keys}};
}

sub make_filename {
	my ($self, $key) = @_;
#	my $enkey = '';		# change better code ? 	# debug
#	foreach my $ch (split(//, $key)) {			# debug
#		$enkey .= sprintf("%02X", ord($ch));	# debug
#	}											# debug
#	$key=~ s/(.)/unpack('H2', $1)/eg;			# debug
#	$key=~tr/a-f/A-F/;							# debug
#	$key=&dbmname($key);						# debug
#	my $funcp = $::functions{"dbmname"};		# debug
#	$key=&$funcp($key);							# debug
	$key =~ s/(.)/$::_dbmname_encode{$1}/g;

	return $self->{dir} . "/$key.txt";
}

#sub dbmname {									# debug
#	my $funcp = $::functions{"dbmname"};		# debug
#	return &$funcp(@_);							# debug
#}												# debug

#sub undbmname {								# debug
#	my $funcp = $::functions{"undbmname"};		# debug
#	return &$funcp(@_);							# debug
#}												# debug

1;
