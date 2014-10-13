######################################################################
# ref.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: ref.inc.pl,v 1.70 2006/09/29 09:11:32 papu Exp $
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
#*�ץ饰���� ref
#�ڡ�����ź�դ��줿�ե������Ÿ������
#URL��Ÿ������
#
#*Usage
# #ref(filename[,page][,parameters][,title])
#
#*�ѥ�᡼��
# -filename~
# ź�եե�����̾�����뤤��URL~
# '�ڡ���̾/ź�եե�����̾'����ꤹ��ȡ����Υڡ�����ź�եե�����򻲾Ȥ���
# -page~
# �ե������ź�դ����ڡ���̾(��ά��)~
# -�ѥ�᡼��
# --Left|Center|Right~
# ���ΰ��ֹ�碌
# --Wrap|Nowrap~
# �ơ��֥륿���ǰϤ�/�Ϥޤʤ�
# -Around~
# �ƥ����Ȥβ�����
# -noicon~
# ���������ɽ�����ʤ�
# -nolink~
# ���ե�����ؤΥ�󥯤�ĥ��ʤ�
# -noimg~
# ������Ÿ�����ʤ�
# -zoom~
# �Ĳ�����ݻ�����
# -999x999~
# �����������(��x�⤵)
# -999%~
# �����������(����Ψ)
# -����¾~
# img��alt/href��title�Ȥ��ƻ���~
# �ڡ���̾��ѥ�᡼���˸�����ʸ�������Ѥ���Ȥ��ϡ�
# #ref(hoge.png,,zoom)�Τ褦�˥����ȥ�����˥���ޤ�;ʬ�������
######################################################################

use strict;

$ref::file_icon = '<img src="'
	. $::image_url
	. '/file.png" width="20" height="20" alt="file" style="border-width:0px" />'
	if(!defined($ref::file_icon));

# default alignment
$ref::default_align = 'left' # 'left','center','right'
	if(!defined($ref::default_align));

# force wrap on default (nonuse)
#$ref::wrap_table = 0 # 1,0
#	if(!defined($ref::wrap_table));

# summary make small image (use Image::Magick)
$ref::summary=0
	if(!defined($ref::summary));

# link popup
$ref::popup=0		# 0:self, 1:popup
	if(!defined($ref::popup));

$ref::popup_regex=qq(do[ct]|ppt|pps|pot|xls|csv|mpp|md[baentwz]|vs[dstw]|pub|one|pdf|txt|[ch]p?p?|js|cgi|p[lm]|php?|rb|gif|jpe?g|png)
	if(!defined($ref::popup_regex));

# link popup of image
$ref::imagepopup=0	# 0:default, 1:JavaScript popup, 2:innerWindow popup
	if(!defined($ref::imagepopup));

# window.open parameters
$ref::wopen='toolbar=no,hotkeys=no,directories=no,scrollbars=no,resizable=yes,menubar=no,width=1,height=1'
	if(!defined($ref::wopen));

#######################################################################################


sub plugin_ref_action {
	if($::form{mode} eq "image") {
		my $mime;
		my $file  = "$::upload_dir/" . &dbmname($::form{page}) . '_' . &dbmname($::form{name});
		if($::form{name}=~/\.[Pp][Nn][Gg]$/) {
			$mime="image/png";
		} elsif($::form{name}=~/\.[Gg][Ii][Ff]$/) {
			$mime="image/gif";
		} elsif($::form{name}=~/\.[Jj][Pp][Ee]?[Gg]$/) {
			$mime="image/jpeg";
		} else {
			&content_output(&http_header("Content-type: text/html",$::HTTP_HEADER)
				, qq(<html><body>image type error:$::form{name}</body></html>));
			exit;
		}
		&load_module("Image::Magick");
		my $iq = Image::Magick->new;
		my $ik = $iq->Read($file);
		my ($width,$height,$filesize) = $iq->Get('width','height','filesize');
		my $img;
		if($::form{width} eq $width && $::form{height} eq $height) {
			open(R,$file);
			binmode(R);
			read(R,$img,$filesize);
			close(R);
		} else {
			my $cachef="$::cache_dir/" . &dbmname("$::form{attach}$::form{width}$::form{height}$ENV{REMOTE_ADDR}$ENV{PID}$ENV{PPID}") . ".refMagick";
			$ik = $iq->Scale(geometry=>"$::form{width}x$::form{height}");
			$ik = $iq->Write(filename=>"$cachef");
			open(R,$cachef);
			binmode(R);
			read(R,$img,-s $cachef);
			close(R);
			unlink($cachef);
		}
		print &http_header(
			"Content-type: $mime\n",
			"Accept-Ranges: bytes\n",
			sprintf("Content-Length: %d\n"
				,length($img)),
			sprintf("Last-Modified: %s GMT\n"
				, &date("D, j M Y G:i:S",(stat($file))[9],"gmtime")));
		print $img;
		exit;
	} elsif($::form{mode}="popup") {
		if($::form{page} ne '' && $::form{name} ne '' && $::form{height} ne '' && $::form{width} ne '') {
			my $url = "$::upload_url/" . &dbmname($::form{page}) . '_' . &dbmname($::form{name});
			my $body=<<EOM;
$::dtd
<title>$::form{name}</title>
<script type="text/javascript"><!--
function loadchk() {
	if(document.pi.complete) {
		window.status="";
		self.resizeTo($::form{width}+10,$::form{height}+80);
		view.style.display="block";
	} else {
		window.status="Loading...";
		window.setTimeout("loadchk();",100);
	}
}
function imgsize(v){
	var w=$::form{width}*v;
	var h=$::form{height}*v;
	document.pi.height=h;
	document.pi.width=w;	
	self.resizeTo(w+10,h+80);
}
//self.focus();
window.setTimeout("loadchk();",100);
//--></script>
<style type="text/css"><!--
*,img{
	margin: 0px;
	padding: 0px;
}
//--></style>
</head>
<body>
<div align="center" id="view" style="display:none;">
<table>
<tr><td>
<form action="#">
<select name="size" onchange="imgsize(this.value);">
<option value="0.25">25%</option>
<option value="0.5">50%</option>
<option value="1" selected>100%</option>
<option value="1.5">150%</option>
<option value="2">200%</option>
</select>
</form>
</td>
<td>
<form action="#">
<input type="button" value="$::resource{closebutton}" onclick="self.close();">
</form>
</td>
</tr>
</table>
<img src="$url" name="pi" alt="$::form{page}&#13;&#10;$::form{name}\" title=\"$::form{page}&#13;&#10;$::form{name}" height="$::form{height}" width="$::form{width}" onclick="self.close();" /><br />
</div>
</body>
</html>
EOM
			&content_output(&http_header("Content-type: text/html; charset=$::charset",$::HTTP_HEADER),$body);
		} else {
			&content_output(&http_header("Content-type: text/html",$::HTTP_HEADER)
				, qq(<html><body>access deined</body></html>));
		}
		exit:
	}
}

sub plugin_ref_inline {
	my ($args) = @_;
	my @args = split(/,/, $args);
	return 'no argument(s).' if (@args < 1);	#���顼�����å�
	my %params = &plugin_ref_body($args, $::form{mypage});
	return ($params{_error}) ? $params{_error} : $params{_body};
}

sub plugin_ref_convert {
	my ($args) = @_;
	my @args = split(/,/, $args);
	return '<p>no argument(s).</p>' if (@args < 1);	#���顼�����å�
	my %params = &plugin_ref_body($args, $::form{mypage});

	# div�����
	my $style;
	if ($params{around}) {
		$style = ($params{_align} eq 'right') ? 'float:right' : 'float:left';
	} else {
		$style = "text-align:$params{_align}";
	}
	return "<div class=\"img_margin\" style=\"$style\">$params{_body}</div>\n";
}

sub getimagesize {
	my ($imgfile, $datafile) = @_;
	my $width  = 0;
	my $height = 0;
	my ($data, $m, $c, $l);

	if (!$datafile) {
		$datafile = $imgfile;
	}

	if ($imgfile =~ /\.jpe?g$/i) {
		open(FILE, "$datafile") || return (0, 0);
		binmode FILE;
		read(FILE, $data, 2);
		while (1) { # read Exif Blocks
			read(FILE, $data, 4);
			($m, $c, $l) = unpack("a a n", $data);
			if ($m ne "\xFF") {
				$width = $height = 0;
				last;
			} elsif ((ord($c) >= 0xC0) && (ord($c) <= 0xC3)) {
				read(FILE, $data, 5);
				($height, $width) = unpack("xnn", $data);
				last;
			} else {
				read(FILE, $data, ($l - 2));
			}
		}
		close(FILE);
	} elsif ($imgfile =~ /\.gif$/i) {
		open(FILE, "$datafile") || return (0,0);
		binmode(FILE);
		sysread(FILE, $data, 10);
		close(FILE);
		$data = substr($data, -4) if ($data =~ /^GIF/);

		$width  = unpack("v", substr($data, 0, 2));
		$height = unpack("v", substr($data, 2, 2));
	} elsif ($imgfile =~ /\.png$/i) {
		open(FILE, "$datafile") || return (0,0);
		binmode(FILE);
		read(FILE, $data, 24);
		close(FILE);

		$width  = unpack("N", substr($data, 16, 20));
		$height = unpack("N", substr($data, 20, 24));
	}
	return ($width, $height);
}

sub plugin_ref_body {
	my ($args) = @_;
	my @args = split(/,/, $args);
	my $name = &trim(shift(@args));
	my $page;

#	my %params = {
#		'left'   => 0,	# ����
#		'center' => 0,	# �����
#		'right'  => 0,	# ����
#		'wrap'   => 0,	# TABLE�ǰϤ�
#		'nowrap' => 0,	# TABLE�ǰϤޤʤ�
#		'around' => 0,	# ������
#		'noicon' => 0,	# ���������ɽ�����ʤ�
#		'nolink' => 0,	# ���ե�����ؤΥ�󥯤�ĥ��ʤ�
#		'noimg'  => 0,	# ������Ÿ�����ʤ�
#		'zoom'   => 0,	# �Ĳ�����ݻ�����
#		'_size'  => 0,	# (���������ꤢ��)
#		'_w'     => 0,	# (��)
#		'_h'     => 0,	# (�⤵)
#		'_%'     => 0,	# (����Ψ)
#		'_args'  => '',
#		'_done'  => 0,
#		'_error' => ''
#	};

	my (%params, $_title, $_backup);
	foreach (@args) {
		$_backup = $_;
		$_ = &trim($_);
		if (/^([0-9]+)x([0-9]+)$/i) { # size pixcel
			$params{_size} = 1;
			$params{_w} = $1;
			$params{_h} = $2;
		} elsif (/^([0-9.]+)%$/i) { # size %
			$params{_par} = $1;
		} elsif (/(left|center|right|wrap|nowrap|around|noicon|nolink|noimg|zoom)/i) { # align
			$params{lc $_} = 1;
		} else {
			if (!$page and &is_exist_page($_)) {
				$page = $_;
			} else {
				$_title = $_backup;
			}
		}
	}

	my ($url, $url2, $urlr, $title, $is_image, $info);
	my $width  = 0;
	my $height = 0;
	my $_width;
	my $_height;
	my $target;
	my $class;
	my $popupmode=0;

	if ($name =~ /^$::isurl/o) {	#URL
		$url = $url2 = &htmlspecialchars($name);
		$title = &htmlspecialchars(($name =~ '/([^\/]+)$/') ? $1 : $url);
		$is_image = (!$params{noimg} and $name =~ /\.$::image_extention$/oi);
		$target='';
		$class="url";
	} else {	# ź�եե�����
		if (!-d "$::upload_dir/") {
			$params{_error} = 'no $::upload_dir.';
			return %params;
		}
		# �ڡ�������Υ����å�
		$page = $::form{mypage} if (!$page);
		if ($name =~ /^(.+)\/([^\/]+)$/) {
			$1 .= '/' if ($1 eq '.' or $1 eq '..');
			$page = get_fullname($1, $page);
			$name = $2;
		}
		$title = &htmlspecialchars($name);
		my $file  = "$::upload_dir/" . &dbmname($page) . '_' . &dbmname($name);
		my $file2 = "$::upload_url/" . &dbmname($page) . '_' . &dbmname($name);
		if (!-e $file) {
			$params{_error} = 'file not found.' . $file;
			return %params;
		}
		$is_image = (!$params{noimg} and $name =~ /\.$::image_extention$/oi);

		$url = "$::script?cmd=attach&amp;pcmd=open"
			. "&amp;file=@{[&encode($name)]}&amp;mypage=@{[&encode($page)]}&amp;refer=@{[&encode($page)]}";
		$urlr= "$::basehref?cmd=attach&amp;pcmd=open"
			. "&amp;file=@{[&encode($name)]}&amp;mypage=@{[&encode($page)]}&amp;refer=@{[&encode($page)]}";
		if ($is_image) {
			($width, $height) = getimagesize($name, $file);
			$_width=$width;
			$_height=$height;
			$url2 = $url;
			$url = $file2;
		} else {
			my ($sec, $min, $hour, $day, $mon, $year) = localtime((stat($file))[10]);
			$info = sprintf("%d/%02d/%02d %02d:%02d:%02d %01.1fK",
				$year + 1900, $mon + 1, $day, $hour, $min, $sec,
				(-s $file) / 1000
			);
		}
		my $tmp=lc $name;
		$target=($name=~/\.$ref::popup_regex$/oi) ? 1 : 0;
		if($is_image) {
			$class="image";
			$popupmode=$ref::imagepopup;
		} else {
			$class="attach";
		}
	}

	# ����������Ĵ��
	if ($is_image) {
		# ���ꤵ�줿����������Ѥ���
		if ($params{_size}) {
			if ($width == 0 and $height == 0) {
				$width  = $params{_w};
				$height = $params{_h};
			} elsif ($params{zoom}) {
				my $_w = $params{_w} ? $width  / $params{_w} : 0;
				my $_h = $params{_h} ? $height / $params{_h} : 0;
				my $zoom = ($_w > $_h) ? $_w : $_h;
				if ($zoom != 0) {
					$width  = ($width  / $zoom);
					$height = ($height / $zoom);
				}
			} else {
				$width  = $params{_w} ? $params{_w} : $width;
				$height = $params{_h} ? $params{_h} : $height;
			}
		}
		if ($params{_par}) {
			$width  = ($width  * $params{_par} / 100);
			$height = ($height * $params{_par} / 100);
		}
		if ($width and $height) {
			$info = "width=\"$width\" height=\"$height\" ";
		}
	}

	#���饤�����Ƚ��
	if ($params{right}) {
		$params{_align} = 'right';
	} elsif ($params{left}) {
		$params{_align} = 'left';
	} elsif ($params{center}) {
		$params{_align} = 'center';
	} else {
		$params{_align} = $ref::default_align;
	}

	$title = $_title if ($_title);

	# �ե��������Ƚ��
	if ($is_image) {	# ����
		my $_url;
		if($ref::summary eq 1 && ($_width > $width || $_height > $height) && $url2) {
			$_url=qq(<img src="$::script?cmd=ref&amp;mode=image&amp;page=@{[&encode($page)]}&amp;name=@{[&encode($name)]}&amp;width=$width&amp;height=$height">);
		} else {
			$_url = "<img src=\"$url\" alt=\"$title\" title=\"$title\" $info />";
		}
		my $onclick;
		if (!$params{nolink} and $url2) {
			if($popupmode eq 1) {
				my $tmp;
				$tmp=&make_link_target($urlr,$class,"_target" . $onclick,$title,$target);
				if($tmp=~/\_target/) {
					$onclick=qq(window.open('$::basehref?cmd=ref&amp;mode=popup&amp;page=@{[&encode($::form{mypage})]}&amp;name=@{[&encode($name)]}&amp;width=$_width&amp;height=$_height','_target','$ref::wopen');return false;);
					$tmp = qq(<a href="$url" class="$class" title="$title" onclick="$onclick" onkeypress="$onclick">);
				}
				$_url = $tmp . "$_url</a>"
			} elsif($popupmode eq 2) {
				$onclick=qq(imagePop(event, '$url', $_width, $_height);return false;);
				my $style="cursor:pointer;";
				$_url = qq(<a href="$url" class="$class" title="$title" onclick="$onclick" onkeypress="$onclick" style="$style">)
					. "$_url</a>";
			} else {
				$_url = &make_link_target($urlr,$class,"_target" . $onclick,$title,$target)
					. "$_url</a>";
			}
		}
		$params{_body} = $_url;
	} else {	# �̾�ե�����
		my $icon = $params{noicon} ? '' : $ref::file_icon;
		$params{_body} = &make_link_target($url,$class,"_target",$info,$target)
			. "$icon$title</a>\n";
	}
	return %params;

#	if ($is_image) {	# ����
#		my $_url = "<img src=\"$url\" alt=\"$title\" title=\"$title\" $info/>";
#		if (!$params{nolink} and $url2) {
#			$_url = "<a $target href=\"$url2\" title=\"$title\">$_url</a>";
#		}
#		$params{_body} = $_url;
#	} else {	# �̾�ե�����
#		my $icon = $params{noicon} ? '' : $ref::file_icon;
#		$params{_body} = "<a href=\"$url\" title=\"$info\">$icon$title</a>\n";
#	}
#	return %params;
}

1;
__END__

=head1 NAME

ref.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #ref(filename[,page][,parameters][,title])

=head1 DESCRIPTION

Display attached to page, URL deployment.

=head1 USAGE

=over 4

 #ref(filename[,page][,parameters][,title])

=item filename or URL

Attached file name or URL

Refer to the attached file of the page for specification of page name or attached file name.
When specifying URL, Require at end of string to be '.gif' or '.jpg', '.png'.
When URL to specify is a CGI script, please addtion URL of string, '&.png'.


=item page

The page name which attached the file.

=item left center right

Horizontal position.

=item warp nowarp

It surrounds by <table> tag / Not surrounds.

=item around

text arround.

=item noicon

No display file icon

=item nolink

Not link to former attached file.

=item noimg

A picture is not displayed. Only link.

=item zoom

An aspect ratio is held.

=item '999x999'

Specify size (width x height)

=item '999%'

Specify size (Expansion percent)

=item other string

Specify title of <img> tag or <a href> tag.

=back

When using the character string which is visible to a page name or a parameter,
put comma under sample follows.

 #ref(hoge.png,,zoom)

=head1 SETTING

=over 4

=item $ref::default_align

The position of a default picture is specified. left, center, or right

=item $ref::summary

When it displays by #ref and picture size is reduced by Image::Magick   It is setting 1.

A picture is not displayed unless Image::Magick exists.

=item $ref::popup

Popup of a link in an attached file, setup 1.

=item $ref::popup_regex

The extension for popup is specified with a regular expression.

=item $ref::imagepopup

The popup to an attachment picture file is specified as follows.
 0 Default Popup
 1 Popup using window.open of JavaScript in which display size specification is possible
 2 It pops up in the center of the same browser screen (it will close, if the picture is clicked).

=item $ref::wopen

$ref::imagepopup=1 At the time,  The parameter of window.open is specified.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/ref

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/ref/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/ref.inc.pl>

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