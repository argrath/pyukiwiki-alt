######################################################################
# new.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: new.inc.pl,v 1.57 2006/09/29 09:11:32 papu Exp $
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

$new::dates_short=1*24*60*60
	if(!defined($new::dates_short));
$new::dates_long=5*24*60*60
	if(!defined($new::dates_long));
$new::string_short=' <span class="new1">New!</span>'
	if(!defined($new::string_short));
$new::string_long=' <span class="new5">New</span>'
	if(!defined($new::string_long));

use Time::Local;

sub plugin_new_inline {
	my $date = shift;
	if ($date eq '') { return ''; }

	my $retval = $date;
	my ($mday, $mon, $year) = (localtime())[3..5];

#	my $now = &mktime(0, 0, 0, $mon + 1, $mday, $year + 1900);
	my $now=Time::Local::timelocal(0,0,0,$mday,$mon,$year);
	$date =~ /(\d+)-(\d+)-(\d+)/;
#	my $past = &mktime(0, 0, 0, $2, $3, $1);
	my $past=Time::Local::timelocal(0,0,0,$3,$2-1,$1-1900);
	if (($now - $past) <= $new::dates_short) {
		$retval .= $new::string_short;
	} elsif (($now - $past) <= $new::dates_long) {
		$retval .= $new::string_long;
	}
	return '<span class="comment_date">' . $retval . '</span>';
}

1;
__END__

=head1 NAME

new.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 &new{2006-01-01 (Sun) 00:00:00};

=head1 DESCRIPTION

When the specified contents are less than regular dates, it is displayed as New.

=head1 USAGE

 &new(date-format);

=head1 SETTING

=over 4

=item my $new::dates_short

Setup regular dates of print 'New!'

=item my $new::dates_long

Setup regular dates of print 'New'

=item my $new::string_short

Setting displayed text which time of setuped by $new::dates_short.

=item my $new::string_long

Setting displayed text which time of setuped by $new::dates_long.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/new

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/new/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/new.inc.pl>

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
