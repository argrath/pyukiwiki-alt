######################################################################
# link.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: link.pl,v 1.58 2006/09/29 09:11:32 papu Exp $
#
# "PyukiWiki" version 0.1.7-rc3 $$
# Author: Hiroshi Yuki http://www.hyuki.com/
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

package link;

sub plugin_inline {
	my ($escaped_argument) = @_;
	my ($caption, $url,$target) = split(/,/, $escaped_argument);
	if ($url =~ /^(mailto|http|https|ftp):/) {
		return &make_link_url("link",$url,$caption,@{[$::use_autoimg && $caption=~/\.$::image_extention$/o ? $caption : ""]},$target);
#		return qq(<a href="$url">$caption</a>);
	} elsif($url=~/(?:[Mm][Aa][Ii][Ll][Tt][Oo]:($::ismail))|($::ismail)/) {
		return &make_link_mail($url,@{[$::use_autoimg && $caption=~/\.$::image_extention$/o ? &make_link_image($caption,"Mail") : $caption]});
	} else {
		return qq(&link($escaped_argument));
	}
}

sub plugin_usage {
	return {
		name => 'link',
		version => '1.1',
		author => 'Hiroshi Yuki http://www.hyuki.com/',
		syntax => '&link(caption,url)',
		description => 'Create link with given caption..',
		example => "Please visit &link(Hiroshi Yuki,http://www.hyuki.com/).",
	};
}

sub make_link_url {
	my $funcp = $::functions{"make_link_url"};
	return &$funcp(@_);
}
sub make_link_mail {
	my $funcp = $::functions{"make_link_mail"};
	return &$funcp(@_);
}
sub make_link_image {
	my $funcp = $::functions{"make_link_image"};
	return &$funcp(@_);
}

1;
__END__

=head1 NAME

link.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 &link(Hiroshi Yuki,http://www.hyuki.com/[,_blank|_top|frame name]);
 &link(Mail,mail (at) example (dot) com);
 &link(Mail,mail (at) example (dot) com?cc=cc (at) example (dot) com&bcc=bcc (at) example (dot) com);

=head1 DESCRIPTION

This plagin is link web page or mail link.

It is not influenced by the internal purser of PyukiWiki.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/link

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/link/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/link.pl>

=back

=head1 AUTHOR

=over 4



=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2002-2006 by Hiroshi Yuki.

Copyright (C) 2005-2006 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
