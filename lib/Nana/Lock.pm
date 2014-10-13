######################################################################
# Lock.pm - This is PyukiWiki, yet another Wiki clone.
# $Id: Lock.pm,v 1.47 2006/09/29 09:11:32 papu Exp $
#
# "Nana::Lock" version 0.2 $$
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
# Return:LF Code=Shift-JIS 1TAB=4Spaces
######################################################################
#
# 大崎氏のrenameファイルロックに対して、以下の改良点があります。
# ・ディレクトリを使わない
#   全体ロックではなく、各ファイルでロック
#
# YukiWikiDBから、以下の改良点があります。
# ・lock関係を共通化できるように、ファイル読み書きをこのファイルへ
#
# from http://www.din.or.jp/~ohzaki/perl.htm#File_Lock
#
######################################################################

package	Nana::Lock;
use 5.005;
use strict;
use vars qw($VERSION);
$VERSION = '0.2';

$Nana::Lock::DEBUG=0;						# debug
# ↑１にするとロック関係のメッセージがでます# debug
# error										# debug
sub die {									# debug
	$::debug.="Nana::Lock:Error:$_[0]\n";	# debug
	return undef;							# debug
}											# debug
# message									# debug
sub msg {									# debug
	$::debug.="Nana:Lock:$_[0]\n"			# debug
		if($Nana::Lock::DEBUG eq 1);		# debug
}											# debug

$Nana::Lock::LOCK_SH=1;
$Nana::Lock::LOCK_EX=2;
$Nana::Lock::LOCK_NB=4;
$Nana::Lock::LOCK_DELETE=128;

# rename lock idea
# http://www.din.or.jp/~ohzaki/perl.htm#File_Lock
# ロックファイルの形式															# debug
# (元ファイル名で不要部分を除いたもの).(method).(pid).(time).lk					# debug
#       0 : ロックしない。省略時のデフォルト									# debug
#       1 : (LOCK_SH) 共有ロック，リトライあり									# debug
#       2 : (LOCK_EX) 排他ロック，リトライあり									# debug
#       5 : (LOCK_SH|LOCK_NB) 共有ロック，リトライなし							# debug
#       6 : (LOCK_EX|LOCK_NB) 排他ロック，リトライなし							# debug
#       8 : (LOCK_UN) 使わないこと。											# debug
#     128 : (LOCK_DELETE) ロックファイルの削除									# debug

sub lock {
	my $timeout=5;
	my $trytime=2;

	my($fname,$method)=@_;
	# ディレクトリ、ファイル名、拡張子を分離									# debug
	my($d,$f,$e)=$fname=~/(.*)\/(.+)\.(.+)$/;
	# ファイル名から記号らしきものを除去(短くするため)							# debug
	$f=~s/[.%()[]:*,_]//g;
	# 初期ハンドルの作成														# debug
	my %lfh=(
		dir=>$d,
		basename=>$f,
		timeout=>$timeout,
		trytime=>($method & $Nana::Lock::LOCK_NB ? 0 : $trytime),
		fname=>$fname,
		method=>$method & 3,
		path=>"$d/$f.lk"
	);
	# ロックファイルの削除									# debug
	if($method eq $Nana::Lock::LOCK_DELETE) {
		return &lock_del(%lfh);
	}
	# methodがおかしい場合return							# debug
	if($lfh{method} eq 0) {									# debug
		&msg("lock error:$fname $lfh{method} - $method");	# debug
		return;												# debug
	}														# debug
	return if($lfh{method} eq 0);

	for(my $i=0; $i < $lfh{trytime}*10; $i++) {
		# ロックメソッド、プロセスID、現在時を入れる										# debug
		$lfh{current}=sprintf("%s/%s.%x.%x.%x.%d.lk"
			,$lfh{dir},$lfh{basename},$lfh{method},$$,time);
		# ロック、成功時は正常終了															# debug
		if(rename($lfh{path},$lfh{current})) {												# debug
			&msg(sprintf("%s:%s->%s"														# debug
				,($lfh{method} eq 1 ? 'LOCK_SH' : 'LOCK_EX'), $lfh{path},$lfh{current}));	# debug
			return \%lfh;																	# debug
		}																					# debug
		return \%lfh if(rename($lfh{path},$lfh{current}));

		# 過去のロックファイルを検索														# debug
		my @filelist=&lock_getdir(%lfh);
		my @locklist=();
		my $fcount=0;
		my $excount=0;
		my $shcount=0;
		foreach (@filelist) {
			if (/^$lfh{basename}\.(\d)\.(.+)\.(.+)\.lk$/) {
				push(@locklist,"$1\t$2\t$3");
				$fcount++;
				$shcount++ if($1 eq 1);
				$excount++ if($1 eq 2);
				&msg(sprintf("Found:%s.%s.%s.%s.lk(method=%d,all=%d,ex=%d,sh=%d)"			# debug
					,$lfh{basename},$1,$2,$3,$lfh{method},$fcount,$excount,$shcount));		# debug
			}
		}
		# ロックファイルが存在しなければ新規作成											# debug
		if($fcount eq 0) {
			&msg("Create $lfh{path}");														# debug
			open(LFHF,">$lfh{path}");# or return undef;
			close(LFHF);
			next;
		# 共有ロックの場合																	# debug
		} elsif($lfh{method} eq 1) {
			# 排他が存在しない場合															# debug
			&msg("SH Lock Check $lfh{basename}");											# debug
			if($shcount > 0 && $excount eq 0) {
				# １つチョイスして、リネームする											# debug
				foreach(@locklist) {
					my($method,$pid,$time)=split(/\t/,$_);
					my $orgf=sprintf("%s/%s.%x.%s.%s.lk"
						,$lfh{dir},$lfh{basename},$method,$pid,$time);
					&msg("new fn=$orgf");													# debug
					# 再ロック																# debug
					if(rename($orgf,$lfh{current})) {										# debug
						&msg(sprintf("%s:%s->%s"											# debug
							,"LOCK_SH",$orgf,$lfh{current}));								# debug
						return \%lfh;														# debug
					}																		# debug
					return \%lfh if(rename($orgf,$lfh{current}));
				}
			}
		}
		# 排他であるor異常時																# debug
		# 0.1秒のsleep、使えなければ1秒														# debug
		eval("select undef, undef, undef, 0.1;");
		if($@) {
			sleep 1;
			$i+=9;
			&msg("waiting 1sec count $i");													# debug
		} else {																			# debug
			&msg("waiting 0.1sec count $i");												# debug
		}
	}
	# 再試行終了																			# debug
	# 過去のロックファイルを検索															# debug
	my @filelist=&lock_getdir(%lfh);
	foreach (@filelist) {
		if (/^$lfh{basename}\.(\d)\.(.+)\.(.+)\.lk$/) {
			# タイムアウトしているのが存在したら											# debug
			if (time - hex($3) > $lfh{timeout}) {
				my $orgf=sprintf("%s/%s.%s.%s.%s.lk"
					,$lfh{dir},$lfh{basename},$1,$2,$3);
				if(rename($orgf,$lfh{current})) {											# debug
					&msg(sprintf("%s:%s->%s"												# debug
						,"FORCE_LOCK",$orgf,$lfh{current}));								# debug
					return \%lfh;															# debug
				}																			# debug
				return \%lfh if(rename($orgf,$lfh{current}));
			}
		}
	}
	&msg("lock:can't lock");																# debug
	return undef;
}

sub unlock {
	if(rename($_[0]->{current}, $_[0]->{path})) {											# debug
		&msg("LOCK_UN" . $_[0]->{current} . "->" . $_[0]->{path});							# debug
	}																						# debug
	rename($_[0]->{current}, $_[0]->{path});
}

sub lock_del {
	my(%lfh)=@_;
	unlink($lfh{path});
	&msg("LOCK_DELETE: $lfh{path}");							# debug
	my @filelist=&lock_getdir(%lfh);
	foreach (@filelist) {
		if (/^$lfh{basename}\.(\d)\.(.+)\.(.+)\.lk$/) {
			unlink($_);
			&msg("LOCK_DELETE: $_");							# debug
		}
	}
}

sub lock_getdir {
	my(%lfh)=@_;
	opendir(LOCKDIR, $lfh{dir});
	my @filelist = readdir(LOCKDIR);
	closedir(LOCKDIR);
	return @filelist;
}

1;
__END__
