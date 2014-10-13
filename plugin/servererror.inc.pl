######################################################################
# servererror.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: servererror.inc.pl,v 1.57 2006/09/29 09:11:32 papu Exp $
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

sub plugin_servererror_action {
	my $redirect_status;
	if($::form{test}+0 > 0) { # debug
		$ENV{REDIRECT_STATUS}=$::form{test}; # debug
		$ENV{REDIRECT_URL}=$ENV{REQUEST_URI}; # debug
		$ENV{REDIRECT_REQUEST_METHOD}=$ENV{REQUEST_METHOD}; # debug
	} # debug
	$redirect_status=$ENV{REDIRECT_STATUS};
	if($redirect_status + 0 < 400) {
		$ENV{REDIRECT_STATUS}=500;
		$ENV{REDIRECT_URL}=$ENV{REQUEST_URI};
		$ENV{REDIRECT_REQUEST_METHOD}=$ENV{REQUEST_METHOD};
	}
	if($::resource{"servererror_plugin_" . $ENV{REDIRECT_STATUS} . "_header"} eq '') {
		$redirect_status=999;
	} else {
		$redirect_status=$ENV{REDIRECT_STATUS};
	}
	my $rfcmsg;
	my $rfcurl;
	my $commonmsg;

	if($ENV{HTTP_REFERER} eq '') {
		$ENV{HTTP_REFERER}=$::script;
	}

	if($::resource{'servererror_plugin_' . $redirect_status . '_rfc'} ne '') {
		$rfcurl=$::resource{servererror_plugin_rfcurl};
		$rfcurl=~s/\$1/$::resource{'servererror_plugin_' . $redirect_status . '_rfc'}/gex;
		$rfcmsg=$::resource{servererror_plugin_rfcmsg};
		$rfcmsg=~s/\$1/$::resource{'servererror_plugin_' . $redirect_status . '_rfc'}/gex;
		$rfcmsg=~s/\$2/$rfcurl/g;
	}

	$commonmsg=&plugin_servererror_msg("commonmsg");
	if($::modifier_mail eq '') {
		$commonmsg=~s/\$1//g;
	} else {
		$ENV{modifier_mail}=$::modifier_mail;
		$commonmsg=~s/\$1/&plugin_servererror_msg("modifier_mail");/gex;
	}

	my $host = "$ENV{'HTTP_HOST'}";
	if (($ENV{'https'} =~ /on/i) || ($ENV{'SERVER_PORT'} eq '443')) {
		$host = 'https://' . $host;
	} else {
		$host = 'http://' . $host;
		$host .= ":$ENV{'SERVER_PORT'}" if ($ENV{'SERVER_PORT'} ne '80');
	}

	if($ENV{REDIRECT_ERROR_NOTES} ne '') {
		$ENV{REDIRECT_ERROR_NOTES}=~s/<[Bb][Rr](.*?)/>\n/g;
		$ENV{REDIRECT_ERROR_NOTES}=~s/\n/~\n>>>/g;
		$notes=">>$::resource{servererror_plugin_errormessage}~\n>>>"
			. $ENV{REDIRECT_ERROR_NOTES};
	}

	$body=<<EOM;
*$::resource{"servererror_plugin_" . $redirect_status . "_title"}
>@{[&plugin_servererror_msg("$redirect_status" . "_msg")]} 

>$commonmsg

$notes

@{[$rfcmsg ne '' ? ">>$rfcmsg" : '']}
----
&size(20){''Error $ENV{REDIRECT_STATUS}''};~
>'''[[$ENV{HTTP_HOST}>FrontPage]]'''~
>'''@{[&get_now]}'''~
>'''$ENV{SERVER_SOFTWARE} on Perl $]'''~
>'''$ENV{REDIRECT_REQUEST_METHOD} $host$ENV{REDIRECT_URL}'''~
>'''from $ENV{REMOTE_ADDR}'''
EOM

	$body=&text_to_html($body,0);
	my $http_header.=qq(Status: $ENV{REDIRECT_STATUS} $::resource{"servererror_plugin_" . $redirect_status . "_header"}\n);
	return ('msg' => "\t$ENV{REDIRECT_STATUS} $::resource{'servererror_plugin_' . $redirect_status . '_header'}", 'body' => $body, 'http_header' => $http_header, 'notviewmenu' => 1);
}

sub plugin_servererror_msg {
	my ($msg)=@_;
	my $text;

	$text=$::resource{"servererror_plugin_$msg"};
	$text=~s/\\n/~\n/g;
	$text=~s/\$ENV\{(.*?)\}/$ENV{$1}/g;
	return $text;
}
1;
__END__

=head1 NAME

servererror.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

In written to /.htaccess

 ErrorDocument 400 /index.cgi?cmd=servererror
 ErrorDocument 401 /index.cgi?cmd=servererror
 ErrorDocument 402 /index.cgi?cmd=servererror
 ErrorDocument 403 /index.cgi?cmd=servererror
 ErrorDocument 404 /index.cgi?cmd=servererror
 ErrorDocument 500 /index.cgi?cmd=servererror

etc...

=head1 DESCRIPTION

Instead of the error message from Web servers, such as Apache, custom-made error message is displayed by PyukiWiki.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/servererror

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Admin/servererror/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/servererror.inc.pl>

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
