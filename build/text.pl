# release file perl script for pyukiwiki
# $Id: text.pl,v 1.42 2006/09/29 09:11:31 papu Exp $

use Jcode;

sub textinit {
	($fn,$pyukiversion,$mode)=@_;
	($sec, $min, $hour, $mday, $mon, $year,
		$wday, $yday, $isdst) = localtime;
	$year+=1900;

#############################################################
# ヘッダ

$text{YEAR}=$year;
$text{BASEHEAD1}=<<EOM;
\@\@FILENAME\@\@ - This is PyukiWiki, yet another Wiki clone.
# \$Id\$
EOM

$text{BASEHEAD2}=<<EOM;
Copyright (C) 2004-$year by Nekyo.
# \@\@NEKYO_URL\@\@
# Copyright (C) 2005-$year PyukiWiki Developers Team
# \@\@PYUKI_URL\@\@
# Based on YukiWiki \@\@YUKIWIKI_URL\@\@
# Powerd by PukiWiki \@\@PUKIWIKI_URL\@\@
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:\@\@CRLF\@\@ Code=\@\@CODE\@\@ 1TAB=4Spaces
EOM

$text{HEADER1}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_NEKYO}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@NEKYO\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@NANAMI\@\@ \@\@NANAMI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_YUKI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@YUKI\@\@ \@\@YUKI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_JUNICHI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@JUNICHI\@\@ \@\@JUNICHI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_YASIGANIMODOKI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@YASIGANIMODOKI\@\@
#         \@\@YASIGANIMODOKI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER3_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@MODULEVERSION\@\@
# Author: \@\@NANAMI\@\@
# \@\@NANAMI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER3_YUKI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@MODULEVERSION\@\@
# Author: \@\@YUKI\@\@
# \@\@YUKI_URL\@\@
# $text{BASEHEAD2}
EOM

#############################################################
# podのライセンス

$text{LICENSE_BASE}=<<EOM;
Copyright (C) 2005-$year by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.
EOM

$text{LICENSE}=<<EOM;
Copyright (C) 2004-$year by \@\@NEKYO\@\@.

\@\@LICENSE_BASE\@\@
EOM

$text{LICENSE_NEKYO}=$text{LICENSE};

$text{LICENSE_NANAMI}=<<EOM;
Copyright (C) 2005-$year by \@\@NANAMI\@\@.

\@\@LICENSE_BASE\@\@
EOM

$text{LICENSE_JUNICHI}=<<EOM;
Copyright (C) 2005-$year by \@\@JUNICHI\@\@.

\@\@LICENSE_BASE\@\@
EOM

$text{LICENSE_YASIGANIMODOKI}=<<EOM;
Copyright (C) 2004-$year by \@\@YASIGANIMODOKI\@\@.

\@\@LICENSE_BASE\@\@
EOM

$text{LICENSE_YUKI}=<<EOM;
Copyright (C) 2002-$year by \@\@YUKI\@\@.

\@\@LICENSE_BASE\@\@
EOM

#############################################################
# podのAUTHOR
$text{AUTHOR_PYUKI}=<<EOM;
=item PyukiWiki Developers Team

L<\@\@PYUKI_URL\@\@>
EOM

$text{AUTHOR_NEKYO}=<<EOM;
=item \@\@NEKYO\@\@

L<\@\@NEKYO_URL\@\@>
EOM

$text{AUTHOR_JUNICHI}=<<EOM;
=item \@\@JUNICHI\@\@

L<\@\@JUNICHI_URL\@\@>
EOM

$text{AUTHOR_NANAMI}=<<EOM;
=item \@\@NANAMI\@\@

L<\@\@NANAMI_URL\@\@> etc...
EOM

$text{AUTHOR_YASIGANIMODOKI}=<<EOM;
=item \@\@YASIGANIMODOKI\@\@

L<\@\@YASIGANIMODOKI_URL\@\@>
EOM


#############################################################
# AUHTOR LIST

$text{YUKI}='Hiroshi Yuki';
$text{YUKI_URL}='http://www.hyuki.com/';

$text{NEKYO}='Nekyo';
$text{NEKYO_URL}='http://nekyo.hp.infoseek.co.jp/';

$text{JUNICHI}='Junichi';
$text{JUNICHI_URL}='http://www.re-birth.com/';

if($fn=~/\.ja/) {
	$text{NANAMI}='ななみ';
	$text{YASIGANIMODOKI}='やしがにもどき';
} else {
	$text{NANAMI}='Nanami';
	$text{YASIGANIMODOKI}='YashiganiModoki';
}
$text{NANAMI_URL}='http://lineage.netgamers.jp/';

$text{YASIGANIMODOKI_URL}='http://hpcgi1.nifty.com/it2f/wikinger/pyukiwiki.cgi';

$text{PYUKI_URL}='http://pyukiwiki.sourceforge.jp/';
$text{YUKIWIKI_URL}='http://www.hyuki.com/yukiwiki/';
$text{PUKIWIKI_URL}='http://pukiwiki.sourceforge.jp/';

$text{BASEURL}='http://pyukiwiki.sourceforge.jp';
$text{CVSURL}='http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki';

$text{RECENTDATE}=&date("Y-m-d (D)");

#############################################################
#	($fn,$pyukiversion,$mode)=@_;

	$text{FILENAME}=$fn;
	$text{FILENAME}=~s/.*\///g;
	$text{CRLF}=$mode eq 'lf' ? 'LF' : 'CRLF';
	$text{PYUKIWIKIVERSION}=qq("PyukiWiki" version $pyukiversion \$\$);
	$VERSION="";
	$pkg="";
	$chkbuf="";
	open(R,"$fn");
	foreach(<R>) {
		$chkbuf.=$_;
		if(/^\$VERSION/) {
			eval  $_ ;
		}elsif(/^package\s?(.*?);/) {
			$pkg=$1;
		}
	}
	close(R);
	if($chkbuf=~/\$charset\: (.+)\$/) {
		$text{CODE}=$1;
	} else {
		($code)=Jcode::getcode($chkbuf);
		if($code eq 'sjis') {
			$text{CODE}="Shift-JIS";
		} elsif($code eq 'utf8') {
			$text{CODE}="UTF-8";
		} else {
			$text{CODE}="EUC-JP";
		}
	}
	if($VERSION ne '' && $pkg ne '') {
		$text{MODULEVERSION}=qq("$pkg" version $VERSION \$\$);
	} else {
		$text{MODULEVERSION}=$text{PYUKIWIKIVERSION};
	}
	foreach (keys %text) {
		$text{$_}=~s/\n$//g;
	}
}


sub date {
	my ($format, $tm, $gmtime) = @_;
	my %weekday;
	my $weekday_lang;
	my $ampm_lang;
	my %ampm;

	# yday:0-365 $isdst Summertime:1/not:0
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = 
		$gmtime ne '' && @_ > 2
			? ($tm+0 > 0 ? gmtime($tm) : gmtime(time))
			: ($tm+0 > 0 ? localtime($tm) : localtime(time));

	$year += 1900;
	my $hr12=$hour=>12 ? $hour-12:$hour;

	# am / pm strings
	$ampm{en}=$hour>11 ? 'pm' : 'am';
	$ampm{ja}=$hour>11 ? '午後' : '午前';

	# weekday strings
	$weekday{en} = ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')[$wday];
	$weekday{en}{length}=3;
	$weekday{ja} = ('日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日')[$wday];
	$weekday{ja}{length}=2;

	$weekday_lang=$weekday{$::lang} eq '' ? 'en' : $::lang;
	$ampm_lang=$ampm{$::lang} eq '' ? 'en' : $::lang;

	# RFC 822 (only this)
	if($format=~/r/) {
		return &date("D, j M Y H:i:s O",$tm,$gmtime);
	}
	# gmtime & インターネット時間
	if($format=~/[OZB]/) {
		my $gmt=&gettz;
		$format =~ s/O/sprintf("%+03d:00", $gmt)/ge;	# GMT Time
		$format =~ s/Z/sprintf("%d", $gmt*3600)/ge;		# GMT Time secs...
		my $swatch=(($tm-$gmt+90000)/86400*1000)%1000;	# GMT +1:00にして、１日を1000beatにする
														# 日本時間の場合、AM08:00=000
		$format =~ s/B/sprintf("%03d", int($swatch))/ge;# internet time
	}

	# UNIX time
	$format=~s/U/sprintf("%u",$tm)/ge;	# unix time

	$format=~s/lL/\x2\x13/g;	# lL:escape 日-土
	$format=~s/DL/\x2\x14/g;	# DL:escape 日曜日-土曜日
	$format=~s/l/\x2\x11/g;		# l:escape Sunday-Saturday
	$format=~s/D/\x2\x12/g;		# D:escape Sun-Sat
	$format=~s/aL/\x1\x13/g;	# aL:escape 午前 or 午後
	$format=~s/AL/\x1\x14/g;	# AL:escape ↑の大文字
	$format=~s/a/\x1\x11/g;		# a:escape am pm
	$format=~s/A/\x1\x12/g;		# A:escape AM PM
	$format=~s/M/\x3\x11/g;		# M:escape Jan-Dec
	$format=~s/F/\x3\x12/g;		# F:escape January-December

	# うるう年、この月の日数
	if($format=~/[Lt]/) {
		my $uru=($year % 4 == 0 and ($year % 400 == 0 or $year % 100 != 0)) ? 1 : 0;
		$format=~s/L/$uru/ge;
		$format=~s/t/(31, $uru ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)[$mon]/ge;
	}

	# year
	$format =~ s/Y/$year/ge;	# Y:4char ex)1999 or 2003
	$year = $year % 100;
	$year = "0" . $year if ($year < 10);
	$format =~ s/y/$year/ge;	# y:2char ex)99 or 03

	# month
	my $month = ('January','February','March','April','May','June','July','August','September','October','November','December')[$mon];
	$mon++;									# mon is 0 to 11 add 1
	$format =~ s/n/$mon/ge;					# n:1-12
	$mon = "0" . $mon if ($mon < 10);
	$format =~ s/m/$mon/ge;					# m:01-12


	# day
	$format =~ s/j/$mday/ge;				# j:1-31
	$mday = "0" . $mday if ($mday < 10);
	$format =~ s/d/$mday/ge;				# d:01-31

	# hour
	$format =~ s/g/$hr12/ge;				# g:1-12
	$format =~ s/G/$hour/ge;				# G:0-23
	$hr12 = "0" . $hr12 if ($hr12 < 10);
	$hour = "0" . $hour if ($hour < 10);
	$format =~ s/h/$hr12/ge;				# h:01-12
	$format =~ s/H/$hour/ge;				# H:00-23

	# minutes
	$format =~ s/k/$min/ge;					# k:0-59
	$min = "0" . $min if ($min < 10);
	$format =~ s/i/$min/ge;					# i:00-59

	# second
	$format =~ s/S/$sec/ge;					# S:0-59
	$sec = "0" . $sec if ($sec < 10);
	$format =~ s/s/$sec/ge;					# s:00-59

	$format =~ s/w/$wday/ge;				# w:0(Sunday)-6(Saturday)


	$format =~ s/I/$isdst/ge;	# I(Upper i):1 Summertime/0:Not

	$format =~ s/\x1\x11/$ampm{en}/ge;			# a:am or pm
	$format =~ s/\x1\x12/uc $ampm{en}/ge;		# A:AM or PM
	$format =~ s/\x1\x13/$ampm{$ampm_lang}/ge;	# A:午前 or 午後
	$format =~ s/\x1\x14/uc $ampm{$ampm_lang}/ge;# ↑の大文字

	$format =~ s/\x2\x11/$weekday{en}/ge;		# l(lower L):Sunday-Saturday
	$format =~ s/\x2\x12/substr($weekday{en},0,$weekday{en}{length})/ge;	# D:Mon-Sun
	$format =~ s/\x2\x13/substr($weekday{$weekday_lang},0,$weekday{$weekday_lang}{length})/ge;	# D:Mon-Sun
	$format =~ s/\x2\x14/$weekday{$weekday_lang}/ge;

	$format =~ s/\x3\x11/substr($month,0,3)/ge;	# M:Jan-Dec
	$format =~ s/\x3\x12/$month/ge;				# F:January-December

	$format =~ s/z/$yday/ge;	# z:days/year 0-366
	return $format;

	# moved date format document to plugin/date.inc.pl or date.inc.pl.ja.pod
}

1;
