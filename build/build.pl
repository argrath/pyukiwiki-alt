#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id: build.pl,v 1.87 2006/09/29 09:11:31 papu Exp $

$DIR=$ARGV[0];
$TYPE=$ARGV[1];
$LF=$ARGV[2];

require 'build/text.pl';

$releasepatch="./releasepatch";

$binary_files='(\.(jpg|png|gif|dat|key|zip)$)|(^unicode\.pl|favicon\.ico$)';

$cvs_ignore='^3A|\.sum$|\.sign$|^cold|^line|^sfdev|74657374|setup.ini.cgi|\.bak$|\.lk$';
$common_ignore='\.sum$|\.sign$|^rss10page|^qrcode|^cold|^line|^Google|^sitemaps\.|^xrea|^unicode\.pl|^3A|74657374|^counter2|^popular2|^bookmark|^clipcopy|^exdate|^ad\.|^ad\_edit|setup.ini.cgi|\.bak$|\.lk$';
$release_ignore=$common_ignore . '|^debug\.inc\.pl|\.pod$|magic_compact\.txt|\.zip|\.src$';
$update_ignore=$common_ignore . '|^debug\.inc\.pl|\.pod$|magic_compact\.txt|\.zip$|\.src$|htaccess';
$compact_ignore='|^pcomment|^back|^hr|^navi|^setlinebreak|^yetlist|^slashpage|^qrcode|^lang\.|^topicpath|^setting|^debug|^Jcode\.pm|magic\.txt|\.en\.(js|css|cgi|txt)|^bugtrack|^(fr|no).*\.inc\.pl|^servererror|^server|^sitemap|^showrss|^perlpod|^Pod|^versionlist|^listfrozen|^admin\.inc\.pl|^urlhack|^punyurl|^opml|^HTTP|^OPML|^atom|^ATOM|^search\_fuzzy|^Search\.pm$';
$releasec_ignore=$common_ignore . $compact_ignore . '|^debug\.inc\.pl|\.pod$|magic\.txt|\.zip|\.src$';
$updatec_ignore=$common_ignore . $compact_ignore. '|^debug\.inc\.pl|\.pod$|magic\.txt|\.zip$|\.src$|htaccess';

$devel_ignore=$common_ignore . '|\.zip$';

@release_dirs=(
	"attach:nodata:0777:0644",
	"cache:nodata:0777:0644",
	"counter:nodata:0777:0644",
	"diff:nodata:0777:0644",
	"info::0777:666",
	"wiki::0777:0666",
	"image::0755:0644",
	"image/face::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/Jcode::0755:0644",
	"lib/Jcode/Unicode::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"lib/Digest::0755:0644",
	"lib/Digest/Perl::0755:0644",
	"lib/IDNA::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644"
);

@releasec_dirs=(
	"attach:nodata:0777:0644",
	"cache:nodata:0777:0644",
	"counter:nodata:0777:0644",
	"diff:nodata:0777:0644",
	"info::0777:666",
	"wiki::0777:0666",
	"image::0755:0644",
	"image/face::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644"
);

@update_dirs=(
	"image::0755:0644",
	"image/face::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/Jcode::0755:0644",
	"lib/Jcode/Unicode::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"lib/Digest::0755:0644",
	"lib/Digest/Perl::0755:0644",
	"lib/IDNA::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644",
);

@updatec_dirs=(
	"image::0755:0644",
	"image/face::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644",
);

@devel_dirs=(
	"attach:nodata:0777:0644",
	"build::0755:0644",
	"cache:nodata:0777:0644",
	"counter:nodata:0777:0644",
	"diff:nodata:0777:0644",
	"info::0777:666",
	"wiki::0777:0666",
	"image::0755:0644",
	"image/face::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/Jcode::0755:0644",
	"lib/Jcode/Unicode::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"lib/IDNA::0755:0644",
	"lib/Digest::0755:0644",
	"lib/Digest/Perl::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644",
	"releasepatch::0755:0644",
#	"releasepatch/attach:nodata:0777:0644",
#	"releasepatch/build::0755:0644",
#	"releasepatch/cache:nodata:0777:0644",
#	"releasepatch/counter:nodata:0777:0644",
#	"releasepatch/diff:nodata:0777:0644",
	"releasepatch/info::0777:666",
	"releasepatch/wiki::0777:0666",
#	"releasepatch/image::0755:0644",
#	"releasepatch/image/face::0755:0644",
#	"releasepatch/lib::0755:0644",
#	"releasepatch/lib/Algorithm::0755:0644",
#	"releasepatch/lib/Jcode::0755:0644",
#	"releasepatch/lib/Jcode/Unicode::0755:0644",
#	"releasepatch/lib/Nana::0755:0644",
#	"releasepatch/lib/Yuki::0755:0644",
#	"releasepatch/lib/Digest::0755:0644",
#	"releasepatch/plugin::0755:0644",
#	"releasepatch/resource::0755:0644",
#	"releasepatch/sample::0755:0644",
#	"releasepatch/skin::0755:0644"
);

@cvs_dirs=@devel_dirs;

@release_files=(
	".htaccess:0644",
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"favicon.ico:0644",
	"README.txt:0644",
);

@releasec_files=(
	".htaccess:0644",
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"favicon.ico:0644",
	"README.txt:0644",
);

@update_files=(
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"README.txt:0644",
);

@updatec_files=(
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"README.txt:0644",
);

@devel_files=(
	".htaccess:0644",
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"favicon.ico:0644",
	"Makefile:0644",
	"README.txt:0644",
	"DEVEL.txt:0644",
);

@cvs_files=@devel_files;

if($TYPE eq 'release') {
	@dirs=@release_dirs;
	@files=@release_files;
	$ignore=$release_ignore;
	$checktimestamp=0;
	$debug=0;
	$podcut=1;
	$commentcut=1;
	$touchonly=0;
}elsif($TYPE eq 'compact') {
	@dirs=@releasec_dirs;
	@files=@releasec_files;
	$ignore=$releasec_ignore;
	$checktimestamp=0;
	$debug=0;
	$podcut=1;
	$commentcut=1;
	$touchonly=0;
} elsif($TYPE eq 'update') {
	@dirs=@update_dirs;
	@files=@update_files;
	$ignore=$update_ignore;
	$checktimestamp=0;
	$debug=0;
	$podcut=1;
	$commentcut=1;
	$touchonly=0;
} elsif($TYPE eq 'updatecompact') {
	@dirs=@updatec_dirs;
	@files=@updatec_files;
	$ignore=$updatec_ignore;
	$checktimestamp=0;
	$debug=0;
	$podcut=1;
	$commentcut=1;
	$touchonly=0;
} elsif($TYPE eq 'devel') {
	@dirs=@devel_dirs;
	@files=@devel_files;
	$ignore=$devel_ignore;
	$checktimestamp=0;
	$debug=1;
	$podcut=0;
	$commentcut=0;
	$touchonly=0;
} elsif($TYPE eq 'cvs') {
	@dirs=@cvs_dirs;
	@files=@cvs_files;
	$ignore=$cvs_ignore;
	$checktimestamp=1;
	$debug=1;
	$podcut=0;
	$commentcut=0;
	$touchonly=0;
} elsif($TYPE eq 'touch') {
	@dirs=@devel_dirs;
	@files=@devel_files;
	$ignore=$devel_ignore;
	$touchonly=1;
	$podcut=0;
	$commentcut=0;
	$debug=0;
} else {
	print STDERR "$0:Type not defined\n";
	exit 1;
}
unless($LF eq 'lf' || $LF eq 'crlf') {
	print STDERR  "$0:LF type not defined\n";
	exit 1;
}
unless(-d $DIR) {
	print STDERR  "$0:$DIR is not directory\n";
	exit 1;
}

open(R,"lib/wiki.cgi");
foreach(<R>) {
	if(/^\$\:\:version/) {
		eval  $_ ;
	}
}
close(R);

&copyfile($DIR,$LF);

sub copyfile {
	my($temp,$filemode)=@_;
	foreach(@dirs) {
		($dir,$_mode,$dir_chmod,$file_chmod)=split(/:/,$_);
		&mkdir("$temp/$dir",$dir_chmod);
		opendir(DIR,"$dir");
		while($file=readdir(DIR)) {
			next if($file=~/CVS/);
			if(! (-d "$dir/$file")) {
				if($_mode eq 'nodata') {
					next if(!($file eq 'index.html' || $file eq '.htaccess'));
				}
				next if($file=~/$ignore/);
				if($file=~/$binary_files/) {
					&copybin($file_chmod,"$dir/$file","$temp/$dir/$file");
				}else{
					if($file=~/\.inc\.cgi$/) {
						$file2=$file;
						$file2=~s/cgi$/pl/g;
					} else {
						$file2=$file;
					}
					&copyascii($file_chmod,"$dir/$file","$temp/$dir/$file2",$filemode);
				}
			}
		}
		closedir(DIR);
	}
	foreach(@files) {
		($file,$file_chmod)=split(/:/,$_);
		&copyascii($file_chmod,$file,"$temp/$file",$filemode);
	}
}


sub shell {
	my($shell)=@_;
	open(PIPE,"$shell|");
	foreach(<PIPE>) {
		chomp;
	}
	close(PIPE);
}

sub copyascii {
	my($chmod,$old,$new,$filemode)=@_;
	if($touchonly eq 1) {
		&shell("touch $old");
		return;
	}
	return if((stat($old))[9]<(stat($new))[9] && $checktimestamp eq 1);

	print "copy $old $new($chmod ascii)\n";
	&textinit($old,$::version,$filemode);
	if(-r "$releasepatch/$old") {
		open(R,"$releasepatch/$old");
	} else {
		open(R,"$old");
	}
	open(W,">$new");
	my $cut=0;
	foreach(<R>) {
		chomp;
		$cut=1 if(/^\=(head|lang)/);
		if(/^\=cut/) {
			$cut=0;
			next if($podcut eq 1);
		}
		next if($cut eq 1 && $podcut eq 1);
		next if(/nanami\=true/);
		next if(/\#\s{0,3}nanami/);
		next if(/^#\t/ && $commentcut eq 1 && $old!~/\.ini/);

		if(!/\#\s{0,3}debug/ || $debug eq 1) {
			s/\t+#.*$//g if($commentcut eq 1 && $old!~/\.ini/);
			$ii=0;
			$s=$_;
			while($s=~/\@\@(.+?)\@\@/) {
				$rep=$1;
				$s=~s/\@\@$rep\@\@/$text{$rep}/g;
				if($filemode eq 'crlf') {
					$s=~s/\x0D\x0A|\x0D|\x0A/\r\n/g;
				} else {
					$s=~s/\x0D\x0A|\x0D|\x0A/\n/g;
				}
				last if($ii++>10);
			}
			if(!($file=~/\.txt$/ && $s=~/test/) || $debug eq 1) {
				chomp $s;
				$s=&email($s);
				if($filemode eq 'crlf') {
					print W "$s\r\n";
				} else {
					print W "$s\n";
				}
			}
		}
	}
	close(W);
	close(R);
	chmod(oct($chmod),"$new");
}

sub copybin {
	my($chmod,$old,$new)=@_;

	if($touchonly eq 1) {
		&shell("touch $old");
		return;
	}
	return if((stat($old))[9]<(stat($new))[9] && $checktimestamp eq 1);

	print "copy $old $new ($chmod bin)\n";
	$old="$releasepatch/$old"if(-r "$releasepatch/$old");
	&shell("cp $old $new");
	chmod(oct($chmod),"$new");
}

sub mkdir {
	my($dir,$chmod)=@_;
	unless(-d "$dir") {
		print "mkdir $dir ($chmod)\n";
		mkdir($dir);
		chmod(oct($chmod),"$dir");
	}
}


sub email {
	my($s)=@_;
$esc         = '\\\\';               $Period      = '\.';
$space       = '\040';
$OpenBR      = '\[';                 $CloseBR     = '\]';
$NonASCII    = '\x80-\xff';          $ctrl        = '\000-\037';
$CRlist      = '\n\015';
$qtext       = qq/[^$esc$NonASCII$CRlist\"]/;
$dtext       = qq/[^$esc$NonASCII$CRlist$OpenBR$CloseBR]/;
$quoted_pair = qq<${esc}[^$NonASCII]>;
$atom_char   = qq/[^($space)<>\@,;:\".$esc$OpenBR$CloseBR$ctrl$NonASCII]/;
$atom        = qq<$atom_char+(?!$atom_char)>;
$quoted_str  = qq<\"$qtext*(?:$quoted_pair$qtext*)*\">;
$word        = qq<(?:$atom|$quoted_str)>;
$domain_ref  = $atom;
$domain_lit  = qq<$OpenBR(?:$dtext|$quoted_pair)*$CloseBR>;
$sub_domain  = qq<(?:$domain_ref|$domain_lit)>;
$domain      = qq<$sub_domain(?:$Period$sub_domain)+>;
$local_part  = qq<$word(?:$Period$word)*>;
$addr_spec   = qq<$local_part\@$domain>;
$mail_regex  = $addr_spec;

	$s=~s!<($mail_regex)>!&emailsub($1)!gex;
	$s=~s!($mail_regex)!&emailsub($1)!gex;
	return $s;
}

sub emailsub {
	my($ss)=@_;
	$ss=~s/\@/ \(at\) /g;
	$ss=~s/\./ \(dot\) /g;
	return "<$ss>";
}
