######################################################################
# stationary.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: stationary.inc.pl,v 1.13 2006/09/29 09:11:32 papu Exp $
#
# "PyukiWiki" version 0.1.7-rc3 $$
# Author: Nanami http://lineage.netgamers.jp/
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
# This is plugin sample
######################################################################

use strict;

#
# #stationary(arg, arg2, ...)
#
sub plugin_stationary_convert {
	# parameter parse
	my ($mymsg,$mypage) = split(/,/, shift);

	# my @args=split(/,/,shift);
	# my %option;
	# foreach(@args) {
	#   if(/^\-option\=(.+)/) {
	#     $option{option}=$1;
	#   } elsif(/^\-name\=(.+)/) {
	#     $option{name}=$1;
	#   }
	# }

	# my @args=split(/,/,shift);
	# my $page=shift @args;
	# my $opts;
	# foreach(@args) {
	#   $opts.="$_";
	# }

	# if loading perl module , use it
	#&load_module("Nana::HTTP");

	$mymsg=&escape($mymsg);
	$mymsg="No message" if($mymsg eq '');
	if(&is_exist_page($mypage)) {
		$mypage="Page not found";
	} else {
		$mypage=&get_subjectline($mypage);
	}
	my $body=<<EOM;
Message : $mymsg
SubjectLine : $mypage
EOM

	# HTTP Header insert
	$::HTTP_HEADER.=<<EOM;
X-PyukiWiki-Stationary:test
EOM

	return $body;
}

#
# &stationary(arg, arg2, ...);
#
sub plugin_stationary_inline {
	my ($mymsg,$mypage) = split(/,/, shift);

	$mymsg=&escape($mymsg);
	$mymsg="No message" if($mymsg eq '');
	if(&is_exist_page($mypage)) {
		$mypage="Page not found";
	} else {
		$mypage=&get_subjectline($mypage);
	}
	my $body=<<EOM;
Message : $mymsg
SubjectLine : $mypage
EOM
	# <head> - </head> insert
	$IN_HEAD.=<<EOM;
<meta name="test" content="test" />
EOM

	return $body;
}

#
# when same of inline and convert method, use it
#

# sub plugin_stationary_inline {
#	return &plugin_stationary_convert(@_);
# }

#
# ?cmd=stationary&mypage=arg&mymsg=arg2
#
sub plugin_stationary_action {
	my $mymsg=&encode($::form{mymsg});
	my $mypage=$::form{mypage};
	$mymsg="No message" if($mymsg eq '');

	if(!&is_exist_page($mypage)) {
							# vv error message 2tab of right
		return ('msg'=>"\t\tPage not found",
				'body'=>"Page not found : $mypage");
	} else {
		my $body=&get_subjectline($mypage);
		return ('msg'=>"$mypage\t$mymsg",
				'body'=>$body,
				'http_header'=>"X-PyukiWiki-Stationary:test\n",
				'header'=>qq(<meta name="test" content="test" />\n),
				);
	}
}

1;
__END__
