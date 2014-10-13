######################################################################
# popular.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: popular.inc.pl,v 1.52 2006/09/29 09:11:32 papu Exp $
#
# "PyukiWiki" version 0.1.7-rc3 $$
# Author: YashiganiModoki
#         http://hpcgi1.nifty.com/it2f/wikinger/pyukiwiki.cgi
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
# ��Բ������̤ΰ١��������Ȥ�Ƥ��ޤ��󤬡��ص��ξ��
# v0.1.6�б��Ǥ����ۤ��뤳�ȤȤ��ޤ�����
# ����¾��������ǽ���夷�Ƥ��ޤ���
# PyukiWiki Developer Term
######################################################################
# �Ȥ���
#
# #popular(10(���),FrontPage|MenuBar,[total/today/yesterday...])
#
# �������ɽ��������
# �����оݥڡ������оݳ��Υڡ���������ɽ���ǵ��Ҥ���
# ��total/today/yesterday�������оݤ�������������������������������
#   $::CountView=2�Ǥ���С��ʲ�����ѤǤ��ޤ���
#   week - �����ι��
#   lastweek - �轵�ι��
# �ʤ���popurar����Ѥ���ȡ���ưŪ��popular.inc.pl�����󥯥롼��
# ����ޤ���
######################################################################

use strict;
use Nana::Cache;

# ����å����ݻ�����(20ʬ)
$popular::cache_expire=20*60
	if(!defined($popular::cache_expire));

sub plugin_popular_convert {
	my $argv = shift;
	my ($limit, $ignore_page, $flag) = split(/,/, $argv);

	return qq(<div class="error">counter.inc.pl can't require</div>)
		if (&exist_plugin("counter") ne 1);

	if ($limit+0 < 1) {$limit = 10;}
	if ($ignore_page eq '') {$ignore_page = '^FrontPage$|MenuBar$';}
	if ($::non_list  ne '') {$ignore_page .= "|$::non_list";}

	$flag=lc $flag;
	$flag="total" if($flag eq '');

	my $cache=new Nana::Cache (
		ext=>"popular",
		files=>100,
		dir=>$::cache_dir,
		size=>100000,
		use=>1,
		expire=>$popular::cache_expire,
	);

	$cache->check(
		"$::plugin_dir/popular.inc.pl",
		"$::plugin_dir/popular.inc.pl",
		"$::res_dir/popular.$::lang.txt",
		"$::explugin_dir/Nana/Cache.pm"
	);
	my $exist_urlhack=-r "$::explugin_dir/urlhack.inc.cgi";
	my $cachefile=&dbmname("$limit-$ignore_page-$flag-$::lang-$exist_urlhack");

	my $out=$cache->read($cachefile);
	my $count = 0;
	if($out eq '') {
		my @populars;
		foreach my $page (sort keys %::database) {
			next if !&is_exist_page($page);
			next if $page =~ /^($::RecentChanges)$/;
			next if $page =~ /($ignore_page)/;
			next unless(&is_readable($page));

			my $cnt=&plugin_counter_selection($flag,&plugin_counter_do($page,"r"));
#			push @populars, sprintf("%10d\t%s",$cnt,$page)
#				if($cnt > 0);
			push @populars, sprintf("%d\t%s",$cnt,$page)
				if($cnt > 0);
		}
		foreach my $key (sort { $b<=>$a } @populars) {
			last if ($count >= $limit);
			my ($cnt,$page)=split(/\t/,$key);
			$out .= "<li>" . &make_link(&armor_name($page)) . "<span class=\"popular\">($cnt)</span></li>\n";
			$count++;
		}
		if ($out) {
			$out =  '<ul class="popular_list">' . $out . '</ul>';
		}

		if ($::resource{"popular_plugin_$flag\_frame"}) {
			$out=sprintf $::resource{"popular_plugin_$flag\_frame"}, $count, $out;
		}
		$cache->write($cachefile,$out);
	}
	return $out;
}

1;
__END__

=head1 NAME

popular.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #popular(20,FrontPage|MenuBar,today)

=head1 DESCRIPTION

A popular page is displayed in a list.

It corresponds to v0.1.6 and popular.inc.pl by which Mr. YASIganiModoki was created is improved.

=head1 USAGE

 #popular(max view pages, regex of disable view page[,total|today|yesterday])

=over 4

=item max view pages

Cases to display of number. Default is 10.

=item regex of disable view page

The list of pages which are not displayed is set up with a regular expression.

=item total|today|yesterday

The display of all accesses, today's display, and yesterday's display are set up. Default is all accesses.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/popular

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/popular/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/popular.inc.pl>

=item PyukiWiki/Plugin/popular

for 0.1.5 or minor

L<http://hpcgi1.nifty.com/it2f/wikinger/pyukiwiki.cgi?PyukiWiki%2f%a5%d7%a5%e9%a5%b0%a5%a4%a5%f3%2fpopular>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://lineage.netgamers.jp/> etc...

=item YashiganiModoki

L<http://hpcgi1.nifty.com/it2f/wikinger/pyukiwiki.cgi>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2004-2006 by YashiganiModoki.

Copyright (C) 2005-2006 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut