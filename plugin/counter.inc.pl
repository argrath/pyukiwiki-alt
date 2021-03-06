######################################################################
# counter.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: counter.inc.pl,v 1.65 2006/09/29 09:11:32 papu Exp $
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
# #counter
# &counter(arg);
#  total - 合計
#  today - 今日
#  yesterday - 昨日
#  数字 - 昨日からの指定した数字分の日数合計 ($::CountView=2 only)
#  week - 今週の合計 ($::CountView=2 only)
#  lastweek - 先週の合計 ($::CountView=2 only)
######################################################################

use strict;
use Nana::File;

%::counter_loaded;

sub plugin_counter_inline {
	my $arg = shift;
	my %counter = plugin_counter_get_count($::form{basepage} ne '' ? $::form{basepage} : $::form{mypage});
	return " " . &plugin_counter_selection($arg,%counter);
}

sub plugin_counter_selection {
	my($arg,%counter)=@_;

	my $count=0;
	if ($arg =~/(today|yesterday)/i) {
		$count = $counter{$arg};
	} elsif($arg+0>0 && $::CounterVersion eq 2) {
		for(my $i=1; $i<=$i; $i++) {
			$count+=$counter{&plugin_counter_getudate-$i};
		}
	} elsif($arg=~/week/ && $::CounterVersion eq 2) {
		for(my $i=0; $i<=($arg=~/last/ ? 6 : (localtime(time))[6]); $i++) {
			$count+=$counter{&plugin_counter_getudate-$i-($arg=~/last/ ? (localtime(time))[6]+1 : 0)};
		}
	} else {
		$count = $counter{'total'}
	}
	return $count;
}

sub plugin_counter_convert {
	my %counter = plugin_counter_get_count($::form{basepage} ne '' ? $::form{basepage} : $::form{mypage});
	return <<"EOD";
<div class="counter">
Counter: $counter{total},
today: $counter{today},
yesterday: $counter{yesterday}
</div>
EOD
}

my %default = (
	'total'     => 0,
	'date'      => '',
	'today'     => 0,
	'yesterday' => 0,
	'ip'        => ''
);

sub plugin_counter_get_count {
	my $page = shift;

	if (!&is_exist_page($page)) {
		return %default;
	}
	return &plugin_counter_do($page,"w");
}

sub plugin_counter_getudate {
	return int((time+&gettz*3600) / 86400);
}

sub plugin_counter_do {
	my($page,$rw)=@_;
	$rw="r" if($rw=~/[Rr]/);
	my %counter = %default;
	my $file = $::counter_dir . "/" . &encode($page) . $::counter_ext;
	my $hex=&dbmname($page);
	my ($mday, $mon, $year) = (localtime)[3..5];
	$year += 1900;
	$mon += 1;
	my %udate;
	$udate{today}=&plugin_counter_getudate;
	$udate{yesterday}=$udate{today}-1;
	$::CounterVersion=1 if($::CounterVersion+0 < 2);
	$::CounterDates=1000 if($::CounterDates > 1000);
	$::CounterDates=14 if($::CounterDates < 15);
	if($::CounterVersion eq 2) {
		$default{date}=$udate{today};
	} else {
		$default{date}="$year/$mon/$mday";
	}

	my @keys;
	@keys = sort keys(%default);
	my $modify = 0;

	my $buf;

	if(defined $::counter_loaded->{$hex}) {
		%counter=$::counter_loaded->{$hex};
	} else {
		my $counters=Nana::File::lock_fetch($file);
		my @tmp=split(/\n/,$counters);
		if($counters=~/date\t/) {
			$counter{version}=2;		# 詳細カウンタ
			foreach(@tmp) {
				chomp;
				my($localtime,$datecount)=split(/\t/,$_);
				$counter{$localtime} = $datecount;
			}
			$counter{today}=$counter{$udate{today}}+0;
			$counter{$udate{yesterday}}+=0;
			$counter{yesterday}=$counter{$udate{yesterday}};
		} else {
			my @loadkeys;
			if($tmp[1]=~/[.\/]/ && $tmp[0]=~/\//) {
				$counter{version}=1;	# 正常なカウンタ
				@loadkeys=@keys;
			} else {
				$counter{version}=0;	# 壊れたカウンタ
				@loadkeys=keys %default;
			}
			my $max=0;
			foreach(@loadkeys) {
				$buf=$counters;
				$buf=~s/\n.*//g;
				$counters=~s/^.*?\n//;
				chomp $buf;
				$counter{$_} = $buf;
				$max=$buf if($max<$buf+0 && $buf!~/[.\/]/);
			}
			$counter{total}=$max if($counter{version} eq 0);
			$counter{$udate{today}}=$counter{today}+0;
			$counter{$udate{yesterday}}+=0;
			$counter{yesterday}=$counter{$udate{yesterday}};
		}
		if ($counter{date} ne $default{date}) {
			$modify = 1;
			$counter{ip}=$ENV{REMOTE_ADDR};
			if($counter{version} eq 1) {
				my ($_mday, $_mon, $_year) = (localtime(time-86400))[3..5];
				my $_date = "@{[$_year+1900]}/@{[$_mon+1]}/$_mday";
				$counter{yesterday}=$counter{date} eq $_date ? $counter{today} : $default{yesterday};
			}
			$counter{today} = ($rw eq 'r' ? 0 : 1);
			$counter{date} = $default{date};
			$counter{total}++ if($rw ne 'r');
		} elsif ($counter{ip} ne $ENV{REMOTE_ADDR} || $::CounterHostCheck eq 0) {
			$::CounterHostCheck=1;
			$modify = 1;
			$counter{ip}        = $ENV{REMOTE_ADDR};
			$counter{today}++ if($rw ne 'r');
			$counter{total}++ if($rw ne 'r');
		}

		$counter{$udate{today}}=$counter{today}+0;
		$counter{$udate{yesterday}}=$counter{yesterday}+0;
		$::counter_loaded{$hex}=%counter;
	}

	if($modify eq 1 && $rw ne 'r' || $::CounterVersion ne $counter{version}) {
		$buf="";
		if($::CounterVersion eq 2) {
			$buf.="date\t$counter{date}\n";
			$buf.="ip\t$counter{ip}\n";
			$buf.="total\t$counter{total}\n";
			for(my $i=$udate{today}; $i>$udate{today}-$::CounterDates; $i--) {
				$buf.="$i\t@{[$counter{$i}+0]}\n";
			}
		} else {
			foreach my $keys(@keys) {
				$buf.="$counter{$keys}\n";
			}
		}
		Nana::File::lock_store($file,$buf);
	}
	$counter{total}+=0;
	close(FILE);
	return %counter;
}
1;
__END__

=head1 NAME

counter.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #counter
 &counter(total);
 &counter(today);
 &counter(yesterday);

=head1 DESCRIPTION

Access counter

=head1 USAGE

=over 4

=item #counter

View all counter value

=item &counter(total);

Total of counter, page reference is displayed.

=item &counter(today);

Count of page reference display, a part for today.

=item &counter(yesterday);

Count of page reference display, a part for yesterday.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/counter

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/counter/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/counter.inc.pl>

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
