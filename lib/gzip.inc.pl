######################################################################
# gzip.inc.cgi - This is PyukiWiki, yet another Wiki clone.
# $Id: gzip.inc.pl,v 1.59 2006/09/29 09:11:31 papu Exp $
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
# Return:LF Code=Shift-JIS 1TAB=4Spaces
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'gzip.inc.cgi'
######################################################################

#$::gzip_path="/bin/gzip";
#$::gzip_path="/usr/bin/gzip";
#$::gzip_path="/usr/bin/gzip -1 -f";

$gzip_command="gzip";

sub plugin_gzip_init {
	my $gzip_exec=1;
	# force init setting.inc.cgi
	&exec_explugin_sub("setting");

	if($::setting_cookie{gzip} ne '') {
		$gzip_exec=0 if($::setting_cookie{gzip}+0 eq 0);
	}
	if($gzip_exec eq 1) {
		# auto search too slow...
		if($::gzip_path eq '') {
			my $forceflag="";
			my $fastflag="";
			foreach(split(/:/,$ENV{PATH})) {
				if(-x "$_/$gzip_command") {
					$::gzip_path="$_/$gzip_command" ;
					if(open(PIPE,"$::gzip_path --help 2>&1|")) {
						foreach(<PIPE>) {
							$forceflag="--force" if(/(\-\-force)/);
							$fastflag="--fast" if(/(\-\-fast)/);
						}
						close(PIPE);
					}
				}
			}
			$gzip_path="$::gzip_path $fastflag $forceflag";
			$::debug.="gzip.inc.cgi: auto detect gzip path : \"$gzip_path\"\n";	# debug
		}
		if ($::gzip_path ne '') {
			if(($ENV{'HTTP_ACCEPT_ENCODING'}=~/gzip/)) {
				if($ENV{'HTTP_ACCEPT_ENCODING'}=~/x-gzip/) {
					$::gzip_header="Content-Encoding: x-gzip\n";
				} else {
					$::gzip_header="Content-Encoding: gzip\n";
				}
			}
		}
	}
	return('http_header'=>$::gzip_header,
		   'init'=>$::gzip_header eq '' ? 0 : 1,
		   'func'=>'content_output,convtime',
		   'content_output'=>\&content_output,
		   'convtime'=>\&convtime);
}

sub convtime {
	if ($::enable_convtime != 0) {
		return sprintf("Powered by Perl $] HTML convert time to %.3f sec.%s",
			((times)[0] - $::_conv_start), $::gzip_header ne '' ? " Compressed" : "");
	}
}

sub content_output {
	my ($http_header,$body)=@_;
	print $http_header;
	if ($::gzip_header ne '') {
		open(STDOUT,"| $::gzip_path");
	}
	$body=~s/\ \/>/>/g if(!$::is_xhtml);
	print $body;
	close(STDOUT);
}

1;
__DATA__
sub plugin_gzip_setup {
	return(
	'ja'=>'gzipˆ³k‚ð‚·‚é',
	'en'=>'Compress gzip',
	'use_cmd'=>'gzip',
	'setting_ja'=>'$::gzip_opts=ˆ³k—¦:-1,-5,-9/$::gzip_opts=Forceƒtƒ‰ƒO:,-f,-force';
	'setting_en'=>'$::gzip_opts=Compress Method:-1,-5,-9/$::gzip_opts=Force Flag:,-f,-force';
	'override'=>'content_output',
	'url'=>'http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/gzip/'
	);
__END__

=head1 NAME

gzip.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

gzip Compression plug-in

=head1 DESCRIPTION

It can be made to carry out on a server browsing comfortably, applying compression to the HTML contents outputted from PyukiWiki.

=head1 USAGE

rename to gzip.inc.cgi

=head1 SETTING

=head2 pyukiwiki.ini.cgi or gzip.inc.pl(cgi)

=over 4

=item $::gzip_path

The path of gzip is specified. A required path and a required command line are automatically searched with an initial state.

=back

=head1 WARNING

If a check of operation can be carried out, please be sure to specify the path of gzip. It is once in order to carry out automatic search.   gzip Load is applied in order to start a process.

=head1 OVERRIDE

content_output function was overrided.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/gzip

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/gzip/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/lib/gzip.inc.pl>

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
