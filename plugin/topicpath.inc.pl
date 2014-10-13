######################################################################
# topicpath.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: topicpath.inc.pl,v 1.29 2006/09/29 09:11:32 papu Exp $
#
# "PyukiWiki" version 0.1.7-rc3 $$
# Author: Junichi http://www.re-birth.com/
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
# オリジナルとの変更点
# ・$topicpath::ARROW, $topicpath::FRONTPAGE への代入を変更
# ・PukiWikiライクの表示設定を追加
# ・0.1.6用のURL処理に変更
######################################################################
# select or edit style
######################################################################
# Re-Birth Original
#$topicpath::AutoLoad=1					if(!defined($topicpath::AutoLoad));
#$topicpath::SEPARATOR = '/'			if(!defined($topicpath::SEPARATOR));
#$topicpath::FRONTMARK = ' ： '			if(!defined($topicpath::FRONTMARK));
#$topicpath::ARROW = ' &gt; '			if(!defined($topicpath::ARROW));
#$topicpath::FRONTPAGE = $::FrontPage	if(!defined($topicpath::FRONTPAGE));
#$topicpath::FRONTPAGENAME=$::FrontPage	if(!defined($topicpath::FRONTPAGENAME));
#$topicpath::PREFIX = '[ '				if(!defined($topicpath::PREFIX));
#$topicpath::SUFFIX = ' ]'				if(!defined($topicpath::SUFFIX));
######################################################################
# PukiWiki Like
$topicpath::AutoLoad=1					if(!defined($topicpath::AutoLoad));
$topicpath::SEPARATOR = '/'				if(!defined($topicpath::SEPARATOR));
$topicpath::FRONTMARK = ' /  '			if(!defined($topicpath::FRONTMARK));
$topicpath::ARROW = ' / '				if(!defined($topicpath::ARROW));
$topicpath::FRONTPAGE = $::FrontPage	if(!defined($topicpath::FRONTPAGE));
$topicpath::FRONTPAGENAME='Top'			if(!defined($topicpath::FRONTPAGENAME));
$topicpath::PREFIX = ''					if(!defined($topicpath::PREFIX));
$topicpath::SUFFIX = ''					if(!defined($topicpath::SUFFIX));
######################################################################

sub plugin_topicpath_inline {
	# wiki.cgiからの読み込みか判断する
	my($wikicgiflag,$page)=split(/,/, shift);
	return '' if(shift eq 1 && $topicpath::AutoLoad eq 0);

	my $mypage = $page eq '' ? $::form{mypage} : $page;

	if(!(&is_exist_page($mypage))) {
		return "";
	}

	my @path_array = split($topicpath::SEPARATOR,$mypage);

	# FrontPageのセット
	$topicpath::FRONTPAGEUrl = &createUrl($topicpath::FRONTPAGE, $topicpath::FRONTPAGE, $topicpath::FRONTPAGE, $topicpath::FRONTPAGENAME);

	if($mypage eq $topicpath::FRONTPAGE) {
		return $topicpath::PREFIX . $topicpath::FRONTPAGEUrl . $topicpath::SUFFIX;
	}

	$result = $topicpath::FRONTPAGEUrl . $topicpath::FRONTMARK;
	my $pathname = "";
	foreach $pagename (@path_array) {

		if($pathname ne "") {
			$pathname .= $topicpath::SEPARATOR . $pagename;
		}else{
			$pathname = $pagename;
		}

		$result .= &createUrl($pagename, $pathname, $topicpath::FRONTPAGE, $topicpath::FRONTPAGENAME);

		# 最後以外は矢印をつける
		if($pagename ne $path_array[$#path_array]){
			$result .= $topicpath::ARROW;
		}

	}
	return $topicpath::PREFIX . $result . $topicpath::SUFFIX;
}

# ex.
# $pagename : Page
# $pathname : Category/Page
sub createUrl() {
	my ($pagename,$pathname, $FRONTPAGE, $FRONTPAGENAME) = @_;

	if(&is_exist_page($pathname)) {
		return qq|<a href="@{[&make_cookedurl(&encode($pathname))]}">@{[&escape($pagename eq $FRONTPAGE ? $FRONTPAGENAME : $pagename)]}</a>|;
	} else {
		return qq|@{[&escape($pagename)]}<a href="$::script?cmd=edit&mypage=@{[&encode($pathname)]}">?</a>|;
	}
}

1;
__END__

=head1 NAME

topicpath.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 automatic required (not compact version) or
 in :Header etc ... &topicpath;
 or put of skin file
  require 'plugin/topicpath.inc.pl';
  &plugin_topicpath_inline;

=head1 DESCRIPTION

It is the so-called "crumbs list."

Page name   It indicates by the class by /(slash) pause, and links to each page.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/topicpath

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Admin/topicpath/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/topicpath.inc.pl>

=item Site manufacture/PyukiWiki/Plugin/topicpath

It is the correspondence version to 0.1.5.

L<http://www.re-birth.com/pyuki/wiki.cgi?%a5%b5%a5%a4%a5%c8%c0%a9%ba%ee%2fPyukiWiki%2f%a5%d7%a5%e9%a5%b0%a5%a4%a5%f3%2f%a5%d1%a5%f3%a4%af%a4%ba%a5%ea%a5%b9%a5%c8>

=back

=head1 AUTHOR

=over 4

=item Junichi

L<http://www.re-birth.com/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2006 by Junichi.

Copyright (C) 2005-2006 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
