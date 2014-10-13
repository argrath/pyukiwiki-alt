######################################################################
# newpage.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: newpage.inc.pl,v 1.58 2006/09/29 09:11:32 papu Exp $
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

sub plugin_newpage_action {
	my %auth;
	my $body;
	my $upperlist;
	if($::newpage_auth eq 1) {
		%auth=&authadminpassword("input",$::resource{admin_passwd_prompt_msg},"frozen");
	}
	if($auth{authed} eq 1 && $::form{mypage} ne '') {
		if (1 == &exist_plugin('adminedit')) {
			if($::form{under} ne '') {
				$::form{mypage}="$::form{under}/$::form{mypage}";
			}
			$::form{cmd}="adminedit";
			return &plugin_adminedit_action;
		}
	}
	if($::new_dirnavi eq 1) {
		@ALLLIST=();
		@UPPERLIST=();
		# 全ページを一度スタック
		foreach my $pages (keys %::database) {
			push(@ALLLIST,$pages) if($pages!~/$::non_list/ && &is_readable($pages));
		}
		@ALLLIST=sort @ALLLIST;
		# 今のページの上層を優先にするための処理
		if($::form{refer} ne '') {
			my $refpage="/$::form{refer}";	# 意図的に先頭にスラッシュをつける
			while($refpage=~/\//) {
				my $pushpage=$refpage;
				$pushpage=~s/^\///g;
				if(&is_exist_page($pushpage)) {
					my $exist=0;
					foreach(@UPPERLIST) {
						$exist=1 if($pushpage eq $_);
					}
					push(@UPPERLIST,$pushpage) if($exist eq 0 && &is_readable($pushpage));
				}
				$refpage=~s/\/[^\/]+$//g;
			}
		}
		$upperlist=<<EOM;
$::resource{newpage_plugin_under}<select name="under">
<option value="">$::resource{newpage_plugin_none}</option>
EOM
		# 上層リストの作成
		foreach(@UPPERLIST) {
			$upperlist.=qq(<option value="$_"@{[$::form{under} eq $_ ? " selected" : ""]}>$_</option>\n);
		}
		foreach my $all(@ALLLIST) {
			my $exist=0;
			foreach(@UPPERLIST) {
				$exist=1 if($all eq $_);
			}
			if($exist eq 0) {
				$upperlist.=qq(<option value="$all"@{[$::form{under} eq $all ? " selected" : ""]}>$all</option>\n);
			}
		}
		$upperlist.=qq(</select>\n);
	}
	my $refercmd;
	$refercmd=qq(<input type="hidden" name="refercmd" value="new">)
		if($::pukilike_edit eq 3);
	$body =<<"EOD";
<form action="$::script" method="post">
    <input type="hidden" name="cmd" value="@{[$::newpage_auth eq 1 ? 'newpage' : 'edit']}">
    $::resource{newpage_plugin_msg}
    <input type="text" name="mypage" value="$::form{mypage}" size="20">
    <input type="hidden" name="refer" value="$::form{refer}">
    <input type="submit" value="$::resource{newpagebutton}"><br>
$upperlist<br />
$auth{html}
$refercmd
</form>
EOD
	return ('msg' => "\t$::resource{newpage_plugin_title}", 'body' => $body);
}
1;
__END__

=head1 NAME

newpage.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=newpage&refer=referpage

=head1 DESCRIPTION

Create new page.

The page name must be encoded.

=head1 SETTING

=head 2 pyukiwiki.ini.cgi

=over 4

=item $::new_refer

In create page, it's displayed a related page on initial value

It's not displayed that setting of null string.

=item $::new_dirnavi

Display of selection Upper layer page 1:use / 0:not use

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/newpage

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/newpage/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/newpage.inc.pl>

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
