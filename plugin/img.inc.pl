######################################################################
# img.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: img.inc.pl,v 1.55 2006/09/29 09:11:32 papu Exp $
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

sub plugin_img_convert {
	my $argv = shift;
	my ($uri, $align, $alt) = split(/,/, $argv);
	$uri   = trim($uri);
	$align = trim($align);
	$alt = trim($alt);

	if ($align =~ /^(r|right)/i) {
		$align = 'right';
	} elsif ($align =~ /^(l|left)/i) {
		$align = 'left';
	} else {
		return '<div style="clear:both"></div>';
	}
	if ($uri =~ /^(http|https|ftp):/) {
		if ($uri =~ /\.(gif|png|jpeg|jpg)$/i) {
			return <<"EOD";
<div style="float:$align;padding:.5em 1.5em .5em 1.5em">
 <img src="$uri" alt="$alt" />
</div>
EOD
		}
	}
	return '';
}
1;
__END__

=head1 NAME

img.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #img(http://example.com/image.png)
 #img(http://example.com/image.jpg,right)
 #img(http://example.com/image.gif,l,AlternateText)
 #img(,c)

=head1 DESCRIPTION

Display Image File

=head1 USAGE

 #img(image_url,[alt],[l|left],[r|right],c)

=over 4

=item image_url

URL of a picture is specified.

=item left | l

Align to Left

=item right | r

Align to Right

=item c

Disable a surroundings lump of a text

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/img

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/img/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/img.inc.pl>

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
