######################################################################
# OPML.pm - This is PyukiWiki, yet another Wiki clone.
# $Id: OPML.pm,v 1.31 2006/09/29 09:11:32 papu Exp $
#
# "Nana::OPML" version 0.1 $$
# Author: Nanami
# http://lineage.netgamers.jp/
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

package Nana::OPML;
use strict;
use vars qw($VERSION);

$VERSION = '0.1';

# The constructor.
sub new {
	my ($class, %hash) = @_;
	my $self = {
		version => $hash{version},
		encoding => $hash{encoding},
		channel => { },
		items => [ ],
	};
	return bless $self, $class;
}

# Setting channel.
sub channel {
	my ($self, %hash) = @_;
	foreach (keys %hash) {
		$self->{channel}->{$_} = $hash{$_};
	}
	return $self->{channel};
}

# Adding item.
sub add_item {
	my ($self, %hash) = @_;
	push(@{$self->{items}}, \%hash);
	return $self->{items};
}

sub as_string {
	my ($self) = @_;
	my $nest=0;
	my $doc = <<"EOD";
<?xml version="1.0" encoding="$self->{encoding}"?>
<opml version="1.0">
<head>
	<title>$self->{channel}->{title}</title>
</head>
<body>
EOD
	foreach(@{$self->{items}}) {
		$_->{link}=~s/[\r\n]//g;
		$_->{title}=~s/[\r\n]//g;
		$_->{xmlurl}=~s/[\r\n]//g;
		if($_->{xmlurl} eq '') {
			$doc.=qq(</outline>\n) if($nest eq 1);
			$doc.=qq(<outline text="$_->{title}" title="$_->{title}">\n);
			$nest=1;
		} else {
			$doc.=qq(<outline htmlUrl="$_->{link}" text="$_->{title}" title="$_->{title}" type="@{[$_->{type} eq '' ? 'rss' : $_->{type}]}" xmlUrl="$_->{xmlurl}" />\n);
		}
	}
	$doc.=qq(</outline>\n) if($nest eq 1);
	$doc.=<<EOD;
</body>
</opml>
EOD
	return $doc;
}

1;
__END__

=head1 NAME

Nana::OPML - The smallest module to generate OPML 1.0. 

=head1 SYNOPSIS

    use strict;
    use Nana::OPML;
 
    my $opml = new Nana::OPML(
        version => '1.0',
        encoding => 'Shift_JIS'
    );
 
    $opml->channel(
        title => "Site Title",
    );
 
    $opml->add_item(
        title => "Item Title",
        link => "http://url.of.your/item.html",
        xmlurl => "http://url.of.your/rss.xml",
        type => "rss",
    );
 
    $opml->add_item(
        title => "category name",
    );
 
    $opml->add_item(
        title => "Item Title",
        link => "http://url.of.your/item.html",
        xmlurl => "http://url.of.your/rss.xml",
        type => "rss",
    );
 
    print $opml->as_string;

=head1 DESCRIPTION

Nana::OPML is the smallest OPML 1.0 generator.
This module helps you to create the minimum document of OPML 1.0.

=head1 METHODS

=over 4

=item new Nana::OPML (version => $version, encoding => $encoding)

Constructor for Nana::OPML.
It returns a reference to a Nana::OPML object.
B<version> must be 1.0.
B<encoding> will be inserted output document as a XML encoding.
This module does not convert to this encoding.

=item add_item (title => $title, link => $link, xmlurl => $xmlurl, type => "[rss or atom]"..etc)

Adds an item to the Nana::OPML object.

=item as_string

Returns the OPML string.

=item channel (title => $title)

Channel information of OPML.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/lib/Nana/OPML.pm>

=item L<Yuki::RSS>

It is the transplant from Yuki::RSS.

Hiroshi Yuki L<http://www.hyuki.com/>

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
