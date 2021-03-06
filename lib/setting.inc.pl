######################################################################
# setting.inc.cgi - This is PyukiWiki, yet another Wiki clone.
# $Id: setting.inc.pl,v 1.32 2006/09/29 09:11:31 papu Exp $
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
# This is extented plugin.
# To use this plugin, rename to 'setting.inc.cgi'
######################################################################

# Initlize

%::setting_cookie;
$::setting_cookie="PyukiWikiSetting_"
				. length($::basepath);
%::name_cookie;
$::name_cookie="PyukiWikiUserName_"
				. length($::basepath);

sub plugin_setting_init {
	&exec_explugin_sub("lang");
	if($::navi{"setting_url"} eq '') {
		push(@::addnavi,"setting:help");
		$::navi{"setting_url"}="$::script?cmd=setting&amp;refer=@{[&encode($::form{refer} eq '' ? $::form{mypage} : $::form{refer})]}";
		$::navi{"setting_name"}=$::resource{"settingbutton"};
		$::navi{"setting_type"}="plugin";
	}
	%::setting_cookie=();
	%::setting_cookie=&getcookie($::setting_cookie,%::setting_cookie);
	%::name_cookie=&getcookie($::name_cookie,%::name_cookie);
	if($::setting_cookie{savename} eq 0) {
		if($::name_cookie{myname} ne '') {
			$::name_cookie{myname}="";
			&setcookie($::name_cookie, -1, %::name_cookie);
		}
	}
	&plugin_setting_setting;
	return ('init'=>1);
}

sub plugin_setting_savename {
	my($name)=@_;
	$::name_cookie{myname}=$name;
	&setcookie($::name_cookie, 1, %::name_cookie);
}

sub plugin_setting_setting {
	if($::setting_cookie{style} ne '') {
		my $style=$::setting_cookie{style};
		if($style!~/\//) {
			my $push=$::skin_name;
			$::skin_name=$style;
			&skin_init;
			$::skin_name=$push;
		}
	}
	if($::setting_cookie{fontsize}+0 > 0) {
		$::IN_HEAD.=<<EOM
<style type="text/css"><!--
#body {
	font-size: @{[$::setting_cookie{fontsize} eq 1 ? '120' : '80']}%;
}
//--></style>
EOM
	}
}
1;
__DATA__
sub plugin_setting_setup {
	return(
	'ja'=>'cookieに対してWikiの表示設定をする',
	'en'=>'Setup of Wiki is carried out to cookie.',
	'url'=>'http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Admin/setting/'
	);
__END__

=head1 NAME

setting.inc.pl - PyukiWiki ExPlugin

=head1 SYNOPSIS

This is plugin/setting.inc.pl 's sub plugin, look plugin document.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/setting

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Admin/setting/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/lib/setting.inc.pl>

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/setting.inc.pl>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://lineage.netgamers.jp/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=head1 LICENSE

Copyright (C) 2005-2006 by Nanami.

Copyright (C) 2005-2006 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
