######################################################################
# setting.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: setting.inc.pl,v 1.30 2006/09/29 09:11:32 papu Exp $
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
# cookie設定用プラグイン
# 設定はリソースファイルにします。
# ExPlugin setting.inc.cgi、$::write_location=1を有効にする必要があります
######################################################################

sub plugin_setting_action {
	my $body;
	return if($::setting_cookie eq '' || $::write_location eq 0);

	if($::form{submit} ne '') {
		my @http_headers=();
		push(@http_headers, "Status: 302");
		if($::form{refer} ne '') {
			push(@http_headers, "Location: $::basehref?@{[&encode($::form{refer})]}");
		} else {
			push(@http_headers, "Location: $::basehref?cmd=setting");
		}
		foreach(keys %::form) {
			if(/^_(.*)/) {
				my $setting=$1;
				my $opt=$::resource{"plugin_setting_" . $setting . "_list"};
				if($opt=~/^sub/) {
					$opt=~s/^sub//g;
					@optlist=eval $opt;
					$::debug.=$@;
				} else {
					foreach my $list(split(/,/,$opt)) {
						push(@optlist,$list);
					}
				}
				my $flg=0;
				foreach(@optlist) {
					my($v,$n)=split(/:/,$_);
					$flg=1 if($v eq $::form{"_" . $setting});
				}
				if($flg eq 0) {
					$body.="err:$setting<br>";
				} else {
					$::setting_cookie{$setting}=$::form{"_" . $setting};
				}
			}
		}
		&setcookie($::setting_cookie, 1, %::setting_cookie);
		print &http_header(
			@http_headers,
			$::HTTP_HEADER
			);
		close(STDOUT);
		exit;
	}
	$body.=<<EOM;
<h3>$::resource{plugin_setting_title}</h3>
<form action="$::script" method="POST">
<input type="hidden" name="cmd" value="setting">
<input type="hidden" name="refer" value="$::form{refer}">
<table>
EOM
	foreach my $setting(split(/,/,$::resource{plugin_setting_list})) {
		my $opts;
		my @optlist=();
		my $check=$::resource{"plugin_setting_" . $setting . "_check"};
		if($check=~/^sub/) {
			$check=~s/^sub//g;
			$check=eval $check;
			$::debug.=$@;
		} elsif($check eq '') {
			$check=1;
		}
		if($check eq 1) {
			my $opt=$::resource{"plugin_setting_" . $setting . "_list"};
			if($opt=~/^sub/) {
				$opt=~s/^sub//g;
				@optlist=eval $opt;
				$::debug.=$@;
			} else {
				foreach my $list(split(/,/,$opt)) {
					push(@optlist,$list);
				}
			}
			my $default=$::resource{"plugin_setting_" . $setting . "_default"};
			if($default=~/^sub/) {
				$default=~s/^sub//g;
				$default=eval $default;
				$::debug.=$@;
			}
			foreach(@optlist) {
				my $checked;
				my $name;
				my $value;
				if(/:/) {
					($value,$name)=split(/:/,$_);
				} else {
					$name=$_;
					$value=$_;
				}
				if($::setting_cookie{$setting} ne '') {
					$checked=" checked" if($value eq $::setting_cookie{$setting});
				} else {
					$checked=" checked" if($value eq $default);
				}
				$opts.=<<EOM;
<input type="radio" name="_$setting" value="$value"$checked>$name
EOM
			}
			$body.=<<EOM;
<tr><td>$::resource{"plugin_setting_" . $setting}</td><td>$opts</td></tr>
EOM
		}
	}
	$body.=<<EOM;
<tr><td>&nbsp;</td><td><input type="submit" name="submit" value="$::resource{plugin_setting_button}"></td></tr>
</table>
</form>
EOM

	return('msg'=>"\t$::resource{plugin_setting_title}", 'body'=>$body);
}

1;
__END__

=head1 NAME

setting.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=setting
 rename lib/setting.inc.pl to lib/setting.inc.cgi

=head1 DESCRIPTION

A user's personal environment setup and it saves at cookie.

=head1 SETTING

=head1 設定

=head2 pyukiwiki.ini.cgi

=over 4

=item $::use_Setting

Enable menu of setting link.

=item $::cookie_expire

Setting save cookie expire.

=item $::cookie_refresh

Setting save cookie refresh time.

=item $::write_location=1

It cannot be used unless Location movement is effective.

=back

=head2 resource/setting.(lang).txt

=over 4

=item plugin_setting_(itemname)

Specify setting item name.

=item plugin_setting_(itemname)_check

It specifies whether this setup can be performed. To the beginning   When there is a character string called sub, it is after it.   perl A script is performed.

1: Enable, 0:Disabled.

When not carrying out this setup, enable setuped.

=item plugin_setting_(itemname)_list

Edit setting values list.

Exmple... "value:name,value:name" ...

To the beginning   When there is a character string called sub, it is after it. Perl script is performed and the array of the return value is specified as a list.

=item plugin_setting_(itemname)_default

Setting default value.

To the beginning   When there is a character string called sub, it is after it. Perl script is performed and the return value is specified as a default value.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/setting

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Admin/setting/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/setting.inc.pl>

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/lib/setting.inc.pl>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://lineage.netgamers.jp/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2006 by Nanami.

Copyright (C) 2005-2006 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
