######################################################################
# showrss.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: showrss.inc.pl,v 1.70 2006/09/29 09:11:32 papu Exp $
#
# "PyukiWiki" version 0.1.7-rc3 $$
# Author: Nekyo
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
# Return:LF Code=Shift-JIS 1TAB=4Spaces
######################################################################

use strict;
#	use Socket;
#	use FileHandle;
use Nana::Cache;
use Time::Local;
use Nana::HTTP;

sub plugin_showrss_inline
{
	return &plugin_showrss_convert(shift);
}

sub plugin_showrss_convert {
	my ($rssuri,$tmplname,$usecache,$dateflag) = split(/,/, shift);
	return if($rssuri eq '');

	my $expire = $usecache * 3600;
	my $cachefile = &dbmname($rssuri);
	my $stream="";
	my $result;
	my $body = "";

	my $cache=new Nana::Cache (
		ext=>"showrss",
		files=>100,
		dir=>$::cache_dir,
		size=>100000,
		use=>($usecache eq '0' ? 0 : 1),
		expire=>($expire+0 <= 0 ? 3600 : $expire),
	);
#	$cache->check(
#		"$::plugin_dir/showrss.inc.pl",
#		"$::explugin_dir/Nana/Cache.pm"
#	);

	my $buf=$cache->read($cachefile,1);
	# rss10pageで生成されたページの場合
	if($rssuri!~/$::isurl/) {
		return &makebody($buf,$tmplname,$dateflag);
	}
	if($cache->read($cachefile) ne '') {
		return &makebody($buf,$tmplname,$dateflag);
	}
	my $pid;
	if($buf ne '') {
		$cache->write($cachefile,$buf);	# 一時的にキャッシュを再保持
		$pid=fork;
	}
	$result=0;

	unless(defined $pid) {
		# シングルタスク処理またはキャッシュが存在しないとき
		($result,$stream)=&plugin_showrss_sub($rssuri);
		$cache->write($cachefile,$stream) if($result eq 0);
		if($result ne 0) {
			return qq(#showrss: $stream : $rssuri);
		}
		return &makebody($stream,$tmplname,$dateflag);
	} else {
		if($pid) {
			# マルチタスクの親
			local $SIG{ALRM} = sub { die "time out" };
			eval {
				alerm(1);
				wait;
				alerm(0);
			};
			if ($@ =~ /time out/) {
				return &makebody($buf,$tmplname,$dateflag);
			} else {
				return &makebody($cache->read($cachefile,1),$tmplname,$dateflag);
			}
		} else {
			# マルチタスクの子
			close(STDOUT);
			($result,$stream)=&plugin_showrss_sub($rssuri);
			$cache->write($cachefile,$stream) if($result eq 0);
			exit;
		}
	}
}

sub makebody {
	my($stream,$tmplname,$dateflag)=@_;
	my $body;
	my %xml = &xmlParser($stream);
	my @title = split(/\n/,
		($xml{'rdf:RDF/item/title'} ne ""
		? $xml{'rdf:RDF/item/title'} : $xml{'rss/channel/item/title'}
		)
	);
	my @date = split(/\n/,
		($xml{'rdf:RDF/item/dc:date'} ne ""
		? $xml{'rdf:RDF/item/dc:date'} : $xml{'rss/channel/dc:date'}
		)
	);
	my @link = split(/\n/,
		($xml{'rdf:RDF/item/link'} ne ""
		? $xml{'rdf:RDF/item/link'} : $xml{'rss/channel/item/link'}
		)
	);

#	my @desc  = split(/\n/, $xml{'rdf:RDF/item/description'});

	my ($footer, $ll, $lr);

	if (lc $tmplname eq "menubar") {
		$body .=<<"EOD";
<div class="small">
<ul class="recent_list">
EOD
		$ll = "<li>";
		$lr = "</li>\n";
		$footer = "</ul>\n</div>\n";
	} elsif (lc $tmplname eq "recent") {
		$body .=<<"EOD";
<div class="small">
<string>$date[0]</strong>
<ul class="recent_list">
EOD
		$ll = "<li>";
		$lr = "</li>\n";
		$footer = "</ul>\n</div>\n";
	} elsif (lc $tmplname eq "body") {
		$body .=<<"EOD";
<div>
<ul class="recent_list">
EOD
		$ll = "<li>";
		$lr = "</li>\n";
		$footer = "</ul>\n</div>\n";
	} else {
		$ll = $footer = "";
		$lr = "<br />\n";
	}

	my $count = 0;
	my $dt;
	foreach (@title) {
		if($dateflag >= 2) {
			my $tm=$date[$count];
			if($tm ne '') {
				$tm=~/^(\d{4})\-(\d{1,2})\-(\d{1,2})T(\d{1,2})\:(\d{1,2})\:(\d{1,2})(?:\+)(\d{1,2})\:(\d{1,2})/;
				$tm=eval {Time::Local::timegm($6,$5,$4,$3,$2-1,$1-1900)-$7*3600-$8*60; };
				$dt=&date($::date_format . ($dateflag eq 3 ? " $::time_format" : ""),$tm) . " ";
				$dt=&date($::date_format . ($dateflag eq 3 ? " $::time_format" : ""),$tm) . " ";
			} else {
				$dt='';
			}
		}
		$body .=<<"EOD";
$ll@{[&make_link_url("ext",$link[$count],$dt . $title[$count])]}$lr
EOD
		$count++;
	}
	$body .= $footer;
	return $body;
}

sub plugin_showrss_sub {
	my($rssuri)=@_;
#	$rssuri =~ m!(http:)?(//)?([^:/]*)?(:([0-9]+)?)?(/.*)?!;
#	my $host = ($3 ne "") ? $3 : "localhost";
#	my $port = ($5 ne "") ? $5 : 80;
#	my $path = ($6 ne "") ? $6 : "/";
	my $code = 'utf8';

	my ($result, $stream);
#	($result, $stream) = &get_rss($host, $path, $port);
#	($result, $stream) = Nana::HTTP::get($rssuri);
	my $http=new Nana::HTTP('plugin'=>"showrss");
#	($result, $stream) = Nana::HTTP::get($rssuri);
	($result, $stream) = $http->get($rssuri);
	$stream=~s/[\xd\xa]//g;

	return($result, $stream) if ($result != 0); # $stream is errorcode.

	if($stream=~/encoding="[Ee][Uu][Cc]/) {
		$code="euc";
	} elsif($stream=~/encoding="[Ss][Hh][Ii][Ff][Tt]/) {
		$code="sjis";
	} else {
		$code="utf8";
	}
#	$stream = &Jcode::convert($stream, $::defaultcode, $code);
#	$stream = &replace($stream);
	$stream = &replace(&code_convert(\$stream,$::defaultcode, $code));
	return ($result,$stream);
}

#sub get_rss {
#	my ($host, $path, $port) = @_;
#	my (@log, $sock, $sockaddr, $ip, $data);
#	$sock = new FileHandle;
#	if ($host =~ /^(\d+).(\d+).(\d+).(\d+)$/) {
#		$ip = pack('C4', split(/\./, $host));
#	} else {
#	#	$ip = (gethostbyname($host))[4] || return (1, "Host Not Found.");
#		$ip = inet_aton($host) || return (1, "Host Not Found.");
#	}
#	$sockaddr = pack_sockaddr_in($port, $ip) || (2, "Can't Create Socket address.");
#	socket($sock, PF_INET, SOCK_STREAM, 0) || return (3, "Socket Error.");
#	connect($sock, $sockaddr) || return (4, "Can't connect Server.");
#	autoflush $sock(1);
#	print $sock "GET $path HTTP/1.1\r\nHost: $host\r\n\r\n";
#	@log = <$sock>;
#	sleep(1);
#	close($sock);
#	undef $data;
#	foreach (@log) {
#		s/[\xd\xa]//g;
#		$data .= $_;
#	}
#	return (0, $data);
#}

sub replace {
	my ($xmlStream) = @_;
	$xmlStream =~ s/<\?(.*)\?>//g;
	$xmlStream =~ s/<rdf:RDF(.*?)>/<rdf:RDF>/g;
	$xmlStream =~ s/<rss(.*?)>/<rss>/g;
	$xmlStream =~ s/<channel(.*?)>/<channel>/g;
	$xmlStream =~ s/<item(.*?)>/<item>/g;
	$xmlStream =~ s/<content:encoded>(.*?)<\/content:encoded>//g;
	$xmlStream =~ s/\ *\/>/\/>/g;
	$xmlStream =~ s/<([^<>\ ]*)\ ([^<>]*)\/>/<$1>$2<\/$1>/g;
	$xmlStream =~ s/<([^<>\/]*)\/>/<$1><\/$1>/g;
	$xmlStream =~ s/<!\[CDATA\[(.+)\]\]>/$1/g;
	return $xmlStream;
}

sub xmlParser {
	my ($stream) = @_;
	my ($i, $ch, $name, @node, $val, $key, %xml);
	my $flg = 0;	# 1:key / 0:value
	foreach $i (0..length $stream) {
		$ch = substr($stream, $i, 1);
		if ($ch eq '<') {
			$flg = 1;
			undef $name;
			foreach (@node) {
				$name .= "$_/";
			}
			chop $name;
			$val =~ s/<//g;
			$val =~ s/>//g;
			$xml{$name} .= "$val\n";
			undef $val;
		}
		if ($flg) {
			$key .= $ch;
		} else {
			$val .= $ch;
		}
		if ($ch eq '>') {
			$flg = 0;
			if ($key =~ /\//) {
				pop @node;
			} else {
				$key =~ s/<//g;
				$key =~ s/>//g;
				push @node, $key;
			}
			undef $key;
		}
	}
	return %xml;
}

1;
=head1 NAME

showrss.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #showrss(URL of rdf, [recent|body|menubar], time)

=head1 DESCRIPTION

Reading rdf and display.

Time specifies the effective time of cash per 1 hour. Specification of 0 does not use cash.

It is necessary to create a directory 'cache'. Use of Jcode.pm or Unicode::Japanese becomes indispensable.

=head1 USING

=over 4

=item [recent|body|menubar]

View format selection of 'recent', 'body' or 'menubar'

=item time

Update cycle of hour

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/showrss

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/showrss/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/showrss.inc.pl>

=back

=head1 AUTHOR

=over 4

=item Nekyo

L<http://nekyo.hp.infoseek.co.jp/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2004-2006 by Nekyo.

Copyright (C) 2005-2006 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
