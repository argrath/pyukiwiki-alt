######################################################################
# lookup.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: lookup.inc.pl,v 1.59 2006/09/29 09:11:32 papu Exp $
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
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################

use strict;

sub plugin_lookup_convert {
	my @args = split(/,/, shift);
#	if (@args < 2) { return ''; }
	my $iwn = &htmlspecialchars(&trim($args[0]));
	my $btn = &htmlspecialchars(&trim($args[1]));

	$btn="LookUp" if($btn eq '');	# v0.1.6
	my $default = '';
	if (@args > 2) {
		$default = &htmlspecialchars(trim($args[2]));
	}
	my $s_page = &htmlspecialchars($::form{mypage});
	my $popup_allow=$::setting_cookie{popup} ne '' ? $::setting_cookie{popup}
					: $::use_popup ? 1 : 0;
	my $ret;
	if($::is_xhtml) {
		$ret=<<EOD;
 <div>
  <form action="$::script" method="post"@{[$popup_allow eq 1 ? qq(onsubmit="this.target='_blank'") : '']}>
EOD
	} else {
		$ret=<<EOD;
 <div>
  <form action="$::script" method="post"@{[$popup_allow eq 1 ? ' target="_blank"' : '']}>
EOD
	}
	$ret.=<<EOD;
  <input type="hidden" name="cmd" value="lookup" />
  <input type="hidden" name="inter" value="$iwn" />
  $iwn:
  <input type="text" name="page" size="30" value="$default" />
  <input type="submit" value="$btn" />
 </div>
</form>
EOD
	return $ret;
}

sub plugin_lookup_action {
	my $text = &decode($::form{page});	# 入力テキスト
	$::form{inter}=~tr/A-Z/a-z/;
	my ($code, $uri) = %{$::interwiki2{$::form{inter}}};
	if ($uri) {	# pukiコンパチ
		if ($uri =~ /\$1/) {
			$uri =~ s/\$1/&interwiki_convert($code, $text)/e;
		} else {
			$uri .= &interwiki_convert($code, $text);
		}
	} else {	# yukiコンパチ
		$uri = $::interwiki{$::form{inter}};
		if ($uri) {
			$uri =~ s/\b(utf8|euc|sjis|ykwk|yw|asis)\(\$1\)/&interwiki_convert($1, $text)/e;
		}
	}
	if ($uri) {
		$uri=~s|&amp;|&|g;
		$uri=~s|&amp;|&|g;
		print &http_header("Status: 302","Location: $uri\n\n");
		exit;
	}
	return "";
}
1;
__END__

=head1 NAME

lookup.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #lookup(google,Search Google)
 #lookup(pyukiwiki,PyukiWiki,Download)

=head1 DESCRIPTION

Display on the position, input area and button.
If arbitrary character strings are inputted and a button is pushed, it will move to URL generated from InterWikiName and an input value.

The text input column and a button are displayed on the described position. If arbitrary character strings are inputted and a button is pushed, it will move to URL generated from InterWikiName and an input value. A query is transmitted to a search engine or this enables it to access the archive which corresponds only by typing a number etc. A picture is displayed.
At lookup use, query transmitted to search engine or type number to access the archive etc.

=head1 USAGE

 #lookup(InterWikiName, [button name], [initial value])

=over 4

=item InterWikiName

One of the values set as InterWikiName is specified.

=item button name

Setting caption of button displayed. Default value is 'LookUp'.

=item initial value

It enters to specify an initial value. 
When abbreviation, an empty text.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/lookup

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/lookup/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/lookup.inc.pl>

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
