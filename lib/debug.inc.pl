######################################################################
# debug.inc.cgi - This is PyukiWiki, yet another Wiki clone.
# $Id: debug.inc.pl,v 1.58 2006/09/29 09:11:31 papu Exp $
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
# To use this plugin, rename to 'debug.inc.cgi'
# WARNING!: Internet Explorer Only...TT
######################################################################

sub plugin_debug_init {
	my $head=<<EOM;
<script  type="text/javascript"><!--
function Display(id,mode){
	if(document.all || document.getElementById){	//IE4, NN6 or later
		if(document.all){
			obj = document.all(id).style;
		}else if(document.getElementById){
			obj = document.getElementById(id).style;
		}
		if(mode == "view") {
			obj.display = "block";
		} else if(mode == "none") {
			obj.display = "none";
		} else if(obj.display == "block"){
			obj.display = "none";		//hidden
		}else if(obj.display == "none"){
			obj.display = "block";		//view
		}
	}
}
//--></script>
EOM
	return(
		'http_header'=>"X-PyukiWiki-Version: $::version Debug",
		'header'=>$head,
		'init'=>1,
		'func'=>'_db',
		'_db'=>\&_db
	);
}

sub _db {
	my ($pagebody)=@_;
	my $envs;
	my $forms;
	my $body;
	my $jsclose;

	foreach(keys %ENV) {
		$envs.="$_=$ENV{$_}\n";
	}
	foreach(keys %::form) {
		$forms.="$_=$::form{$_}\n";
	}
	push(@DB,"debug");
	push(@DB,"form");
	push(@DB,"http");
	push(@DB,"env");

	$DB{debug_msg}="Debug Messages(\$::debug)";
	$DB{debug_arg}=$::debug;
	$DB{form_msg}="Form Data";
	$DB{form_arg}=$forms;
	$DB{http_msg}="HTTP Header";
	$DB{http_arg}=$::HTTP_HEADER;
	$DB{env_msg}="Environment variable";
	$DB{env_arg}=$envs;

	$body=<<EOM;
<table width="100%"><form>
<tr><th class="style_th">
EOM
	foreach my $db1(@DB) {
		$jsclose.="Display('$db1','none');";
	}
	foreach my $db1(@DB) {
		$body.=<<EOM;
[<a href="javascript:$jsclose Display('$db1','view');">$DB{$db1 . '_msg'}</a>] 
EOM
	}
	$body.=<<EOM;
[<a href="javascript:$jsclose">X</a>]</th></tr>
EOM
	foreach my $db1(@DB) {
		$body.=<<EOM;
<tr><td class="style_td" style="display: none;" id="$db1" align="center"><textarea cols="100" rows="5">$DB{$db1 . '_arg'}</textarea></td></tr>
EOM
	}
	$body.=<<EOM;
</form></table>
EOM

	$pagebody=~s!<div id="navigator">!$body<div id="navigator">!g;
	return $pagebody;
}

1;
__DATA__
sub plugin_debug_setup {
	return(
	'en'=>'PyukiWiki Debug Plugin',
	'use_req'=>'',
	'use_opt'=>'',
	'use_cmd'=>'',
	'override'=>'_db',
	'url'=>'http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/debug/'
	);
__END__

=head1 NAME

debug.inc.pl - PyukiWiki Developpers Plugin

=head1 SYNOPSIS

Instant debugger for PyukiWiki

=head1 DESCRIPTION

value $::debug, the received form data, Cookie (un-mounting), a HTTP header, and a server environment variable are displayed on the page upper part.

=head1 USAGE

rename to debug.inc.cgi

=head1 OVERRIDE

_db function was overrided.

=head1 WARNING

Now, only Internet Explorer is supported.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/debug

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/debug/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/lib/debug.inc.pl>

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
