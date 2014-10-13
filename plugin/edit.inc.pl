######################################################################
# edit.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: edit.inc.pl,v 1.66 2006/09/29 09:11:32 papu Exp $
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
# Return:LF Code=Shift-JIS 1TAB=4Spaces
######################################################################

use strict;

sub plugin_edit_action {
	my ($page) = &unarmor_name(&armor_name($::form{mypage}));
	my $body;
	my $under;
	if($::form{under}) {
		$under=&unarmor_name($::form{under});
		$page="$under/" . &unarmor_name(&armor_name($::form{mypage}));
		$::form{mypage}=$page;
		$::form{refer}=$under;
	}
	if($page=~/\[\[\]\]/) {
		$body .= qq(<p><strong>$::resource{edit_plugin_cantchange}</strong></p>);
	} elsif (not &is_editable($page)) {
		$body .= qq(<p><strong>$::resource{edit_plugin_cantchange}</strong></p>);
	} elsif (&is_frozen($page)) {
		$body .= qq(<p><strong>$::resource{edit_plugin_cantchange}</strong></p>);
	} else {
		# 2005.11.2 pochi: 部分編集を可能に {
		my $pagemsg;
		if ($::form{mypart} =~ /^\d+$/ and $::form{mypart}) {
			my $mymsg = (&read_by_part($page))[$::form{mypart} - 1];
			$pagemsg = \$mymsg;
		} else {
			# original
			$pagemsg = \$::database{$page};
		}
		# }
		$body .= &plugin_edit_editform($$pagemsg,
			&get_info($page, $::info_ConflictChecker), admin=>0);
	}
	return ('msg'=>"$page\t$::resource{edit_plugin_title}", 'body'=>$body,'ispage'=>1);
}

my %auth;

sub plugin_edit_editform {
	my ($mymsg, $conflictchecker, %mode) = @_;
	my $frozen = &is_frozen($::form{mypage});
	my $body = '';

	if ($::extend_edit) {
		$::IN_HEAD.=qq(<script type="text/javascript" src="$::skin_url/instag.js"></script>\n);
	}

	my $edit = $mode{admin} ? 'adminedit' : 'edit';
	if($edit eq 'adminedit') {
		%auth=&authadminpassword("input",$::resource{admin_passwd_prompt_msg},"frozen");
	}
	if($::pukilike_edit > 1 && $::form{template} ne '') {
		$::form{mymsg}=&plugin_edit_editform_loadtemplate;
	}

	my $helplink=$::resource{$::form{mymsg} eq '' ? "edit_plugin_helplink" : "edit_plugin_helplink2"};
	if ($::form{mypreview}) {
		if ($::form{mymsg}) {
			unless ($mode{conflict}) {
				$body .= qq(<h3>$::resource{edit_plugin_previewtitle}</h3>\n);
				if($::edit_afterpreview eq 0) {
					$body .= qq($::resource{edit_plugin_previewnotice}\n);
					$body .= qq(<div class="preview">\n);
					$body .= &text_to_html($::form{mymsg}, toc=>1);
					$body .= qq(<hr class="full_hr" />);
				} else {
					$body .= qq($::resource{edit_plugin_previewnotice2}\n);
				}
				$body .= qq(</div>\n);
			}
		} else {
			$body .= qq($::resource{edit_plugin_previewempty});
		}
		$mymsg = $::form{mymsg};
	} elsif($::form{plugined} eq 1) {
		$mymsg = $::form{mymsg} . "\n";
	} elsif($mymsg eq '') {
		if($::form{mymsg} eq '' && $::new_refer ne '' && $::form{refer} ne '') {
			$mymsg =$::new_refer;
			$mymsg =~s/\$1/$::form{refer}/g;
			$mymsg = &htmlspecialchars($mymsg);
		} else {
			$mymsg = &htmlspecialchars($mymsg);
		}
	}
	my $escapedmypage = &htmlspecialchars($::form{mypage});
	$body.=&plugin_edit_extend_edit if ($::extend_edit);

	$body.=$::pukilike_edit >0
		? &plugin_edit_editform_pukilike($mymsg,$conflictchecker,$escapedmypage,$frozen,$edit,%mode)
		: &plugin_edit_editform_pyukiwiki($mymsg,$conflictchecker,$escapedmypage,$frozen,$edit,%mode);

	unless ($mode{conflict}) {
		if(&is_exist_page($::resource{rulepage})) {
			if($::pukilike_edit >0 && $::form{help} ne 'true' || $::form{mypreview} ne '') {
				$body.=<<EOM;
<ul>
<li>
<a title="$helplink" href="$::script?cmd=$::form{cmd}&amp;mypage=@{[&encode($::form{mypage})]}&amp;refer=@{[&encode($::form{refer})]}&amp;help=true">$helplink</a>
</li>
</ul>
EOM
			} else {
				if($::form{mypreview} eq '') {
					$body.=qq(<hr class="full_hr" />\n);
					$body .= &text_to_html($::database{$::resource{rulepage}}, toc=>0);
				}
			}
		}
	}

	if ($::form{mypreview} && $::edit_afterpreview eq 1) {
		if ($::form{mymsg}) {
			unless ($mode{conflict}) {
				$body .= qq(<hr class="full_hr" />);
				$body .= &text_to_html($::form{mymsg}, toc=>1);
			}
		}
	}
	return $body;
}

sub plugin_edit_editform_pukilike {
	my($mymsg,$conflictchecker,$escapedmypage,$frozen,$edit,%mode)=@_;
	my $loadlist;
	if(($::pukilike_edit eq 3 && $::form{template} eq '' && $::form{refercmd} eq 'new')
	 ||($::pukilike_edit eq 2 && $::form{template} eq '' )) {
		$loadlist=&plugin_edit_editform_loadlist($edit);
	}

	# 2005.11.2 pochi: 部分編集を可能に {
	my $partfield = '';
	if ($::form{mypart} =~ /^\d+$/ and $::form{mypart}) {
		$partfield = qq(<input type="hidden" name="mypart" value="$::form{mypart}">);
	}
	# }

	my $body = <<"EOD";
<form action="$::script" method="post" id="editform" name="editform">
  @{[ $mode{admin} ? "$auth{html}<br>" : ""]}
  <input type="hidden" name="myConflictChecker" value="$conflictchecker">
  <input type="hidden" name="mypage" value="$escapedmypage">
  <input type="hidden" name="refer" value="$::form{refer}">
  <input type="hidden" name="refercmd" value="$edit">
  $partfield
  $loadlist
  <textarea cols="$::cols" rows="$::rows" name="mymsg">@{[&htmlspecialchars($mymsg)]}</textarea><br />
@{[
  $mode{admin} ?
  qq(
  <input type="radio" name="myfrozen" value="1" @{[$frozen ? qq(checked="checked") : ""]}>$::resource{edit_plugin_frozenbutton}
  <input type="radio" name="myfrozen" value="0" @{[$frozen ? "" : qq(checked="checked")]}>$::resource{edit_plugin_notfrozenbutton}<br>)
  : ""
]}
@{[
  $mode{conflict} ? "" :
  qq(
    <input type="submit" name="mypreview_$edit" value="$::resource{edit_plugin_previewbutton}">
    <input type="submit" name="mypreview_write" value="@{[$::resource{edit_plugin_pukiwikisavebutton} eq '' ? $::resource{edit_plugin_savebutton} : $::resource{edit_plugin_pukiwikisavebutton}]}">
    <input type="checkbox" name="mytouch" value="on" checked="checked">$::resource{edit_plugin_touch}
    <input type="submit" name="mypreview_cancel" value="$::resource{edit_plugin_cancelbutton}">
  )
]}
</form>
EOD
	return $body;
}

sub plugin_edit_editform_loadtemplate {
	if(&is_readable($::form{template})) {
		return $::database{$::form{template}};
	}
	$::form{template}="";
	return '';
}

sub plugin_edit_editform_loadlist {
	my($edit)=@_;
	my @ALLLIST=();
	my @loadlist=();
	my $loadlist;
	# 全ページを一度スタック
	foreach my $pages (keys %::database) {
		push(@ALLLIST,$pages) if($pages!~/$::non_list/ && &is_readable($pages));
	}
	@ALLLIST=sort @ALLLIST;
	# 今のページの上層を優先にするための処理
	if($::form{refer} ne '') {
		my $refpage="/$::form{refer}";	# 意図的に先頭にスラッシュをつける
		while($refpage=~/\//) {
			my $pushpage=$refpage;
			$pushpage=~s/^\///g;
			if(&is_exist_page($pushpage)) {
				my $exist=0;
				foreach(@loadlist) {
					$exist=1 if($pushpage eq $_);
				}
				push(@loadlist,$pushpage) if($exist eq 0 && &is_readable($pushpage));
			}
			$refpage=~s/\/[^\/]+$//g;
		}
	}
	$loadlist=<<EOM;
<select name="template">
<option value="" selected>$::resource{edit_plugin_template}</option>
EOM
	# 上層リストの作成
	foreach(@loadlist) {
		$loadlist.=qq(<option value="$_">$_</option>\n);
	}
	foreach my $all(@ALLLIST) {
		my $exist=0;
		foreach(@loadlist) {
			$exist=1 if($all eq $_);
		}
		if($exist eq 0) {
			$loadlist.=qq(<option value="$all">$all</option>\n);
		}
	}
	$loadlist.=<<EOM;
</select>
<input type="submit" name="mypreview_$edit" value="$::resource{edit_plugin_load}">
<br />
EOM
	return $loadlist;
}

sub plugin_edit_editform_pyukiwiki {
	my($mymsg,$conflictchecker,$escapedmypage,$frozen,$edit,%mode)=@_;
	# 2005.11.2 pochi: 部分編集を可能に {
	my $partfield = '';
	if ($::form{mypart} =~ /^\d+$/ and $::form{mypart}) {
		$partfield = qq(<input type="hidden" name="mypart" value="$::form{mypart}">);
	}
	# }
	my 	$body= <<"EOD";
<form action="$::script" method="post" id="editform" name="editform">
  @{[ $mode{admin} ? "$auth{html}<br>" : ""]}
  <input type="hidden" name="myConflictChecker" value="$conflictchecker">
  <input type="hidden" name="mypage" value="$escapedmypage">
  <input type="hidden" name="refer" value="$::form{refer}">
  <input type="hidden" name="refercmd" value="$edit">
  $partfield
  <textarea cols="$::cols" rows="$::rows" name="mymsg">@{[&htmlspecialchars($mymsg)]}</textarea><br />
@{[
  $mode{admin} ?
  qq(
  <input type="radio" name="myfrozen" value="1" @{[$frozen ? qq(checked="checked") : ""]}>$::resource{edit_plugin_frozenbutton}
  <input type="radio" name="myfrozen" value="0" @{[$frozen ? "" : qq(checked="checked")]}>$::resource{edit_plugin_notfrozenbutton}<br>)
  : ""
]}
@{[
  $mode{conflict} ? "" :
  qq(
    <input type="checkbox" name="mytouch" value="on" checked="checked">$::resource{edit_plugin_touch}<br>
    <input type="submit" name="mypreview_$edit" value="$::resource{edit_plugin_previewbutton}">
    <input type="submit" name="mypreview_write" value="$::resource{edit_plugin_savebutton}"><br>
  )
]}
</form>
EOD
	return $body;
}

sub plugin_edit_extend_edit {
	my $body;
	$body = <<"EOD";
<div>
<a href="javascript:insTag('\\'\\'','\\'\\'','bold');"><b>B</b></a>
<a href="javascript:insTag('\\'\\'\\'','\\'\\'\\'','italic');"><i>I</i></a>
<a href="javascript:insTag('%%%','%%%','underline');"><u>U</u></a>
<a href="javascript:insTag('%%','%%','delline');"><del>D</del></a>
<a href="javascript:insTag('\\n-','','list');">
<img src="$::image_url/list_ex.png" alt="list" border="0" vspace="0"
  hspace="1"></a>
<a href="javascript:insTag('\\n+','','list');">
<img src="$::image_url/numbered.png" alt="list" border="0" vspace="0"
  hspace="1"></a>
<a href="javascript:insTag('\\nCENTER:','\\n','centering');">
<img src="$::image_url/center.png" alt="center" border="0" vspace="0"
  hspace="1"></a>
<a href="javascript:insTag('\\nLEFT:','\\n','left');">
<img src="$::image_url/left_just.png" alt="left" border="0" vspace="0"
  hspace="1"></a>
<a href="javascript:insTag('\\nRIGHT:','\\n','right');">
<img src="$::image_url/right_just.png" alt="right" border="0" vspace="0"
  hspace="1"></a>
<a href="javascript:insTag('\\n*','','title');"><b>H</b></a>
<a href="javascript:insTag('[[',']]','wikipage');">[[]]</a>
<a href="javascript:insTag('','~\\n','');">&lt;br&gt;</a>
<a href="javascript:insTag('\\n----\\n','','');"><b>--</b></a>
</div>
EOD
	return $body;
}

1;
__END__

=head1 NAME

edit.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=edit&mypage=pagename&refer=referpage&under=upper-layer-page

=head1 DESCRIPTION

Edit page.

The page name must be encoded.

=head1 SETTING

=head 2 pyukiwiki.ini.cgi

=over 4

=item $::cols

Columns of text area

=item $::rows

Lines of text area

=item $::extend_edit

Extended Edit (JavaScript) 1:use / 0:not use

=item $::pukilike_edit

PukiWiki like edit screen

0: PyukiWiki Original

1: PukiWiki Like

2: PukiWiki Like with load template

3: PukiWiki Like with load template on create page

=item $::edit_afterpreview

Position of preview screen 0:On an edit screen / 1:Under an edit screen

=item $::new_refer

For newpage plugin, 

In create page, it's displayed a related page on initial value

It's not displayed that setting of null string.

=item $::new_dirnavi

For newpage plugin, 

Display of selection Upper layer page 1:use / 0:not use

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/edit

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/edit/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/edit.inc.pl>

=item YukiWiki

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
