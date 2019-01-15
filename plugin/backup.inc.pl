use strict;
use warnings;

my %action = (
    '' => \&plugin_backup_view,
    'diff' => \&plugin_backup_diff,
    'nowdiff' => \&plugin_backup_nowdiff,
    'source' => \&plugin_backup_source,
);

sub plugin_backup_list {
	require 'HTML/Template.pm';
	my (@list) = PyukiWikiAlt::Backup::get_all($::form{mypage});
	my $ret = '';
	my $c = 1;
	my $t = HTML::Template->new(filename => 'template/backup.ja.tmpl.html');
	my @loop = ();
	my $urlbase = $::script . '?cmd=backup&amp;mypage=' . $::form{mypage};
	foreach $b (@list) {
		my %x;
		$x{base} = $urlbase . '&amp;age=' . $c;
		$x{num} = $c++;
		$x{time} = localtime(${$b}{time});
		push @loop, \%x;
	}
	$t->param(list => \@loop);
	return ('msg' => $::form{mypage} . "\t" . 'のバックアップ一覧', 'body' => $t->output);
}

sub plugin_backup_view {
	require 'HTML/Template.pm';
	my (@list) = PyukiWikiAlt::Backup::get_all($::form{mypage});
	my $age = $::form{age};
	my $text = $list[$age - 1]{content};
	my $c = 1;
	my $t = HTML::Template->new(filename => 'template/backup_view.ja.tmpl.html');
	my @loop = ();
	my $urlbase = $::script . '?cmd=backup&amp;mypage=' . $::form{mypage};
	foreach $b (@list) {
		my %x;
		$x{base} = $urlbase . '&amp;age=' . $c;
		$x{time} = localtime(${$b}{time});
		$x{selected} = ($c == $age);
		$x{num} = $c++;
		push @loop, \%x;
	}
	$t->param(list => \@loop);

	return ('msg' => $::form{mypage} . "\t" . 'のバックアップ', 'body' =>$t->output . &text_to_html($text));
}

sub plugin_backup_source {
    require 'HTML/Template.pm';
    my $t = HTML::Template->new(filename => 'template/backup_source.ja.tmpl.html');

    my (@list) = PyukiWikiAlt::Backup::get_all($::form{mypage});
    $t->param(source => &htmlspecialchars(${$list[$::form{age} - 1]}{content}));

    return ('msg' => $::form{mypage} . "\t" . 'のバックアップ', 'body' => $t->output);
}

sub plugin_backup_diff {
    require 'HTML/Template.pm';
    &load_module('PyukiWikiAlt::Diff');
    &load_module('Yuki::DiffText');
    my $t = HTML::Template->new(filename => 'template/backup_nowdiff.ja.tmpl.html');
    my (@list) = PyukiWikiAlt::Backup::get_all($::form{mypage});
    my $idx = $::form{age} - 1;
    my @new = split(/\n/, ${$list[$idx]}{content});
    my @old;
    if($idx == 0){
	@old = ();
    } else {
	@old = split(/\n/, ${$list[$idx - 1]}{content});
    }

    $t->param(body =>
	PyukiWikiAlt::Diff::construct(Yuki::DiffText::difftext(\@old, \@new)));
    return ('msg' => $::form{mypage} . "\t" . 'のバックアップ', 'body' => $t->output);
}

sub plugin_backup_nowdiff {
    require 'HTML/Template.pm';
    &load_module('PyukiWikiAlt::Diff');
    &load_module('Yuki::DiffText');
    my $t = HTML::Template->new(filename => 'template/backup_nowdiff.ja.tmpl.html');
    my (@list) = PyukiWikiAlt::Backup::get_all($::form{mypage});
    my @old = split(/\n/, ${$list[$::form{age} - 1]}{content});
    my @new = split(/\n/, $::database{$::form{mypage}});

    $t->param(body =>
	PyukiWikiAlt::Diff::construct(Yuki::DiffText::difftext(\@old, \@new)));
    return ('msg' => $::form{mypage} . "\t" . 'のバックアップ', 'body' => $t->output);

}


sub plugin_backup_action {
	require 'PyukiWikiAlt/Backup.pm';
	if(!defined $::form{age}){
		return &plugin_backup_list();
	}
	my $act = $::form{action};
	if(!defined $act){
		$act = '';
	}
	my $exec = $action{$act};
	if(defined $exec){
		return &{$exec};
	}
}

1;
