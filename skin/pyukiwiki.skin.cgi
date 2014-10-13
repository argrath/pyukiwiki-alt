######################################################################
# pyukiwiki.skin.cgi - This is PyukiWiki, yet another Wiki clone.
# $Id: pyukiwiki.skin.cgi,v 1.40 2006/09/29 09:11:32 papu Exp $
#
# "PyukiWiki" version 0.1.7-rc3 $$
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
# Skin.ja:PyukiWiki標準
# Skin.en:PyukiWiki Default
######################################################################

use HTML::Template;

sub skin {
	my ($pagename, $body, $is_page, $bodyclass, $editable, $admineditable, $basehref, $lastmod) = @_;

	my($page,$message,$errmessage)=split(/\t/,$pagename);	
	my $cookedpage = &encode($page);
	my $cookedurl=&make_cookedurl($cookedpage);
	my $escapedpage = &htmlspecialchars($page);
	my $escapedpage_short=$escapedpage;
	$escapedpage_short=~s/^.*\///g if($::short_title eq 1);
	my $HelpPage = &encode($::resource{help});
	my $htmlbody;
	my ($title,$headerbody,$menubarbody,$footerbody,$notesbody);

	# CSSの設定
	if($::lang eq 'ja') {
		$csscharset=qq( charset="Shift_JIS");
	}
	if($::use_blosxom eq 1) {
		$::IN_HEAD.=<<EOD;
<link rel="stylesheet" href="$::skin_url/blosxom.css" type="text/css" media="screen"$csscharset />
EOD
	}

	# <title>タグの生成
	if($::wiki_title ne '') {
		$title="$::wiki_title - ";
	}

	if($page eq '') {
		$title_tag="$title$message";
	} else {
		$title_tag="$title$escapedpage @{[&htmlspecialchars(&get_subjectline($page))]}";
	}

	# MenuBar, :Header, :FooterのHTML生成
	if($is_page || $::allview eq 1) {
		$headerbody=&print_content($::database{$::Header}, $::form{mypage})
			if(&is_exist_page($::Header));
		$::pushedpage = $::form{mypage};	# push;
		$::form{mypage}=$::MenuBar;
		$menubarbody=&print_content($::database{$::MenuBar}, $::pushedpage)
			if(&is_exist_page($::MenuBar));
		$::form{mypage}=$::pushedpage;	# pop;
		$::pushedpage="";
		$footerbody=&print_content($::database{$::Footer}, $::form{mypage})
			if(&is_exist_page($::Footer));
	}

	# 注釈HTMLの生成
	if (@::notes) {
		$notesbody.= << "EOD";
<div id="note">
<hr class="note_hr" />
EOD
		my $cnt = 1;
		foreach my $note (@::notes) {
			$notesbody.= << "EOD";
<a id="notefoot_$cnt" href="@{[&make_cookedurl($::form{mypage})]}#notetext_$cnt" class="note_super">*$cnt</a>
@{[$::notesview ne 0 ? qq(<span class="small">) : '']}@{[$note]}@{[$::notesview ne 0 ? qq(</span>) : '']}
<br />
EOD
			$cnt++;
		}
		$notesbody.="</div>\n";
	}

	# HTML <head>〜</head> から、画像リンクまで
	$htmlbody=<<"EOD";
$::dtd
<title>$title_tag</title>
@{[$basehref eq '' ? '' : qq(<base href="$basehref" />)]}
<link rel="stylesheet" href="$::skin_url/$::skin{default_css}" type="text/css" media="screen"$csscharset />
<link rel="stylesheet" href="$::skin_url/$::skin{print_css}" type="text/css" media="print"$csscharset />
@{[$::AntiSpam ne "" ? '' : qq(<link rev="made" href="mailto:$::modifier_mail" />)]}
<link rel="top" href="$::script" />
<link rel="index" href="$::script?cmd=list" />
@{[$::use_SiteMap eq 1 ? qq(<link rel="contents" href="$::script?cmd=sitemap" />) : '']}
<link rel="search" href="$::script?cmd=search" />
<link rel="help" href="$::script?$HelpPage" />
<link rel="author" href="$::modifierlink" />
<meta name="description" content="$title$escapedpage @{[&htmlspecialchars(&get_subjectline($page))]}" />
<meta name="author" content="$::modifier" />
<meta name="copyright" content="$::modifier" />
<script type="text/javascript" src="$::skin_url/$::skin{common_js}"></script>
$::IN_HEAD</head>
<body class="$bodyclass">
<div id="container">
<div id="head">
<div id="header">
<a href="$::modifierlink"><img id="logo" src="$::logo_url" width="$::logo_width" height="$::logo_height" alt="$::logo_alt" title="$::logo_alt" /></a>
EOD

	# ページタイトル、メッセージの表示
	if($errmessage ne '') {
		$htmlbody.=<<EOD;
<h1 class="error">$errmessage</h1>
EOD
	} elsif($page ne '') {
		$htmlbody.=<<EOD;
<h1 class="title"><a
    title="$::resource{searchthispage}"
    href="$::script?cmd=search&amp;mymsg=$cookedpage">$escapedpage_short</a>@{[$message eq '' ? '' : "&nbsp;$message"]}</h1>
<span class="small">@{[&topicpath($page)]}</span>
EOD
	} else {
		$htmlbody.=<<EOD;
<h1 class="title">$message</h1>
EOD
	}

	# ナビゲータの表示
	$htmlbody.=<<EOD;
</div>
<div id="navigator">[ 
EOD
	my $flg=0;
	foreach $name (@::navi) {
		if($name eq '') {
			$htmlbody.=" ] &nbsp; [ " if($flg ne 0);
			$flg=0;
		} else {
			if($::navi{"$name\_name"} ne '') {
				$htmlbody .= " | " if($flg eq 1);
				$flg=1;
				$htmlbody.=<<EOD;
<a title="@{[$::navi{"$name\_title"} eq '' ? $::navi{"$name\_name"} : $::navi{"$name\_title"}]}" href="$::navi{"$name\_url"}">$::navi{"$name\_name"}</a>
EOD
			}
		}
	}
	$htmlbody.=<<EOD;
]
</div>
<hr class="full_hr" />
@{[ $::last_modified == 1
  ? qq(<div id="lastmodified">$::lastmod_prompt $lastmod</div>)
  : q()
]}
</div>
EOD

	# table定義
	$htmlbody.= <<"EOD";
<dfn></dfn>
<div id="content">
<table class="content_table" border="0" cellpadding="0" cellspacing="0">
@{[$headerbody ne '' ? qq(<tr><td@{[$menubarbody ne '' ? qq( colspan="2") : '']}>$headerbody</td></tr>) : '']}
  <tr>
EOD

	# MenuBarの表示
	if($menubarbody ne '') {
		$htmlbody.=<<"EOD";
    <td class="menubar" valign="top">
    <div id="menubar">
$menubarbody
    </div>
    </td>
EOD
	}

	# コンテンツの表示
	$htmlbody.= <<"EOD";
    <td class="body" valign="top">
      <div id="body">$body</div>@{[$::notesview eq 0 ? $notesbody : '']}
    </td>
  </tr>
@{[$::notesview eq 1 ? qq(<tr><td@{[$menubarbody ne '' ? qq( colspan="2") : '']}>$notesbody</td></tr>) : '']}
@{[$footerbody ne '' ? qq(<tr><td@{[$menubarbody ne '' ? qq( colspan="2") : '']}>$footerbody</td></tr>) : '']}
</table>
EOD

	# 注釈の表示（:Footerの下）
	$htmlbody.=$::notesview eq 2 ? $notesbody : '';

	# アイコン、lastmodified表示
	$htmlbody.= <<"EOD";
</div>
EOD
	my $t = HTML::Template->new(scalarref => &decodetmpl('skin/icon.ja.tmpl.html'));
	$t->param(toolbar => $::toolbar);
	if($::toolbar ne 0) {
		my (@loop) = ();
		foreach $name (@::navi) {
			if($name eq '') {
				my %x = (name => '');
				push @loop, \%x;
			} else {
				if(-f "$image_dir/$name.png") {
					if($::toolbar eq 2 || $::navi{"$name\_height"} ne '') {
						my $height=$::navi{$name . '_height'};
						if($height eq '') {$height = 20;}
						my $width=$::navi{$name . '_width'};
						if($width eq '') {$width =  20;}
						my $title = $::navi{$name . '_title'};
						if($title eq '') {$title = $::navi{$name . '_name'};}
						my %x = (
							title => $title,
							height => $height,
							width => $width,
							url => $::navi{$name . '_url'},
							image_url => $image_url,
							name => $name);
						push @loop, \%x;
					}
				}
			}
		}
		$t->param(loop => \@loop);
	}
	$htmlbody .= $t->output;
	$htmlbody.=<<EOD;
@{[ $::last_modified == 2
 ? qq(<div id="lastmodified">$::lastmod_prompt $lastmod</div>)
 : qq()
]}
<div id="footer">
EOD
	# footer
	$t = HTML::Template->new(scalarref => &decodetmpl('skin/footer.ja.tmpl.html'));
	$t->param(wiki_title => $::wiki_title,
			  basehref => $basehref,
			  modifier => $::modifier,
			  modifierlink => $::modifierlink,
			  version => $::version,
			  );
	$footerbody = $t->output;

	$footerbody= &text_to_html($footerbody);
	$footerbody=~s/(<p>|<\/p>)//g;
	$htmlbody.= $footerbody;

	$htmlbody.= <<"EOD";
@{[&convtime]}
</div>
</div>
</div>
</body>
</html>
EOD
	return $htmlbody;
}

sub decodetmpl
{
	open F, '<' . $_[0];
	my $s = '';
	while(<F>){
		s@\$::([a-z_]+)@<TMPL_VAR name="$1">@g;
		$s .= $_;
	}
	close F;
	return \$s;
}

1;
