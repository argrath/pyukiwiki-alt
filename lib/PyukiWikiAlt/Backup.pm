package PyukiWikiAlt::Backup;
use strict;
use warnings;

my $maxpage = 10;
my $min_interval = 60;

my $splitter = '>>>>>>>>>>';

sub _make_filename {
    return sprintf 'backup/%s.gz', &::dbmname($_[0]);
}

# check whether enough interval between revisions
sub _is_suitable {
    my (@s) = stat($_[0]);
    return (time() - $s[9] > $min_interval);
}

sub _write {
    my ($fn, $list) = @_;

    open F, '| gzip -c > ' . $fn;
    foreach my $data (@$list) {
	my %x = %$data;
	printf F "%s %d\n%s", $splitter, $x{time}, $x{content};
    }
    close F;
}

sub _read {
    my ($fn) = @_;
    my $time = undef;
    my @ret;
    my $data = '';

    open F, 'gzip -cd < ' . $fn . '|' or return ();
    while(<F>){
	if(/^$splitter (\d+)/cg){
	    if(defined $time){
		my %x = (time => $time, content => $data);
		push @ret, \%x;
	    }
	    $time = $1;
	    $data = '';
	} else {
	    $data .= $_;
	}
    }
    
    close F;
    {
	my %x = (time => $time, content => $data);
	push @ret, \%x;
    }

    return @ret;
}

sub add {
    my ($page, $data) = @_;
    my @list;
    
    my $fn = _make_filename($page);
    
    if(-e $fn){
	if(!_is_suitable($fn)){ return; }
	
	if($data !~ /\n$/){
	    $data .= "\n";
	}
	
	(@list) = _read($fn);
	
	if($#list >= $maxpage){
	    shift @list;
	}
    } else {
	@list = ();
    }

    my %x = (time => time(), content => $data);
    push @list, \%x;

    _write($fn, \@list);

}

sub get_all {
	return _read(_make_filename($_[0]), $_[1]);
}

1;
