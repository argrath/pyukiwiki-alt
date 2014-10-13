######################################################################
# pagenavi.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: pagenavi.inc.pl,v 1.56 2006/09/29 09:11:32 papu Exp $
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

sub plugin_pagenavi_convert {
	my ($args) = @_;
	my @args = split(/,/, $args);
	my $tmp;
	my $body;

	foreach(@args) {
		if(/\//) {
			$tmp="";
			my @pages=split(/\//,$_);
			foreach(@pages) {
				my($name,$alias)=split(/>/,$_);
				$alias=$name if($alias eq '');
				$tmp.=$alias;
				$body.=qq([[$name>$tmp]]/);
				$tmp.='/';
			}
			$body=~s/\/$//g;
		} else {
			$body.=$_;
		}
	}

	$body=&text_to_html($body);
	return $body;
}

1;
__END__

=head1 NAME

pagenavi.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #pagenavi(string, string, string...)

=head1 DESCRIPTION

The near number of visiters referred to now is displayed.

=head1 USAGE

=over 4

=item Makes link from upper layer to this page

 PyukiWiki/Glossary>Yougo/About PyukiWiki>PyukiWiki

It's write, convert to ...

 [[PyukiWiki]]/[[Glossary>PyukiWiki/Yougo]]/[[About PyukiWiki>PyukiWiki/Yougo/PyukiWiki]]

=item Others

Others are described by the usual Wiki grammar. After combining all parameters, it is changed into HTML with a text_to_html function.

=item Example

 #pagenavi(*,PyukiWiki/PyukiWiki Download>Download,!)
 #pagenavi(-Reference:,TOP>FrontPage/Glossary>Yougo>PyukiWiki)

=item Convenient usage

As a template of newpage.inc.pl, edit.inc.pl,
it is setting $::new_refer of pyukiwiki.ini.cgi.
It is convenient if you set it as a variable.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/pagenavi

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/pagenavi/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/pagenavi.inc.pl>

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
