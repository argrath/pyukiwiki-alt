#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id: makesampleini.pl,v 1.27 2006/03/04 13:12:52 papu Exp $

@CHANGES=(
	'\$::useExPlugin = 1;	$::useExPlugin = 0;',
	'\$::usefacemark = 1;	$::usefacemark = 0;',
	'\$::use_popup = [0-3];	$::use_popup = 0;',
	'\$::allview = 1;	$::allview = 0;',
	'\$::recent_format="Y-m-d(lL) H:i:s";	$::recent_format="Y-m-d H:i:s";',
	'\$::extend_edit = 1;	$::extend_edit = 0;',
	'\$::pukilike_edit = [0-3];	$::pukilike_edit = 0;',
	'\$::edit_afterpreview=1;	$::edit_afterpreview=0;',
	'\#\$::new_refer	$::new_refer',
	'\$::new_dirnavi=1;	$::new_dirnavi=0;',
	'\$::usePukiWikiStyle=1;	$::usePukiWikiStyle=0;',
	'\$::nowikiname = 0;	$::nowikiname = 1;',
	'\$::automaillink = 1;	$::automaillink = 0;',
	'\$::file_uploads = 3;	$::file_uploads = 1;',
	'\$::use_FuzzySearch=1;	$::use_FuzzySearch=0;',
	'\$::write_location=1;	$::write_location=0;',
	'\$::write_location=1;	$::write_location=0;',
	'\$::partedit=1;	$::partedit=0;',
	'\$::toolbar=2;	$::toolbar=1;',
	'\$::useTopicPath=1;	$::useTopicPath=0;',
	'\$::use_Setting=1;	$::use_Setting=0;',
	'\$::use_SkinSel=1;	$::use_SkinSel=0;',
	'\$::auto_meta_maxkeyword=(\d*?);	$::auto_meta_maxkeyword=0;',
#	'^\x09#\s.*	',
#	'^#\$.*	'
);

open(R,"pyukiwiki.ini.cgi");
foreach $f(<R>) {
	foreach $r(@CHANGES) {
		($s,$e)=split(/\t/,$r);
		$f=~s!$s!$e!g;
	}
	print $f;
}
close(W);
close(R);
