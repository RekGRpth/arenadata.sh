#!/usr/bin/perl
#
# strip-gpdiff-ignored.pl - remove from expected .out files what gpdiff
# ignores anyway, in place.
#
# Usage: strip-gpdiff-ignored.pl [-n] [-i INIT_FILE]... FILE...
#
#   -n            dry run: print what would be removed, change nothing
#   -i INIT_FILE  init file(s) of the test; by default src/test/regress/init_file,
#                 plus src/test/isolation2/init_file_isolation2 for files
#                 under src/test/isolation2 (paths relative to the source
#                 tree found above FILE)
#
# Removed:
#   - lines starting with HINT:, CONTEXT:, GP_IGNORE: (gpdiff runs diff with
#     -I HINT: -I CONTEXT: -I GP_IGNORE:);
#   - lines matching a matchignore pattern of atmsort.pm or of the init files
#     (" Optimizer: ...", " Settings: ...", the DISTRIBUTED BY notices, ...);
#   - text that a matchsubs rule of atmsort.pm or of the init files deletes
#     (s/X//), e.g. "  (seg1 172.18.0.7:7003 pid=148631)" tails of ERRORs.
#
# Kept: continuation lines of multi-line CONTEXT messages and DETAIL lines,
# which gpdiff does not ignore.  Rerun the test afterwards.

use strict;
use warnings;
use Cwd qw(abs_path);
use File::Basename qw(dirname);
use Getopt::Long;

my $dry = 0;
my @inits;
GetOptions('n' => \$dry, 'i=s' => \@inits) or die "bad options\n";
die "usage: $0 [-n] [-i INIT_FILE]... FILE...\n" unless @ARGV;

# atmsort.pm's own rules (init_matchignores(), init_match_subs())
my @builtin_ignores = (
	'm/^NOTICE:  dropping a column that is part of the distribution policy/',
	'm/^NOTICE:  table has parent\, setting distribution columns to match parent table/',
	'm/^WARNING:  referential integrity \(.*\) constraints are not supported in Greengage Database/',
	'm/^NOTICE:  \w+ \".*\" does not exist\, skipping\s*$/',
);
my @builtin_subs = (['m/\s+\(seg.*pid.*\)/', 's/\s+\(seg.*pid.*\)//']);

sub compile
{
	my ($code, $where) = @_;
	my $fn = eval "sub { \$_[0] =~ $code }";
	die "bad rule in $where: $code: $@" unless $fn;
	return $fn;
}

sub compile_sub
{
	my ($code, $where) = @_;
	my $fn = eval "sub { my \$s = shift; \$s =~ $code; return \$s }";
	die "bad rule in $where: $code: $@" unless $fn;
	return $fn;
}

# matchignore patterns, and matchsubs that delete what they match
sub read_init_file
{
	my ($file, $ignores, $subs) = @_;
	my ($block, $pending_m) = ('', undef);

	open my $fh, '<', $file or die "$file: $!\n";
	while (my $line = <$fh>)
	{
		chomp $line;
		if ($line =~ /^--\s*start_(matchignore|matchsubs)/) { $block = $1; next; }
		if ($line =~ /^--\s*end_(matchignore|matchsubs)/) { $block = ''; next; }
		next if $block eq '' || $line =~ /^\s*(#.*)?$/;
		if ($block eq 'matchignore')
		{
			push @$ignores, compile($line, $file);
		}
		elsif ($line =~ /^\s*m/)
		{
			$pending_m = $line;
		}
		elsif ($line =~ /^\s*s(.)(?:\\.|(?!\1).)*\1\1[a-z]*\s*$/ && defined $pending_m)
		{
			push @$subs, [compile($pending_m, $file), compile_sub($line, $file)];
			$pending_m = undef;
		}
		else
		{
			$pending_m = undef;
		}
	}
	close $fh;
}

sub source_tree
{
	my $dir = dirname(abs_path(shift));
	while ($dir ne '/')
	{
		return $dir if -e "$dir/src/test/regress/atmsort.pm";
		$dir = dirname($dir);
	}
	die "no source tree above the file\n";
}

for my $file (@ARGV)
{
	my @ignores = map { compile($_, 'atmsort.pm') } @builtin_ignores;
	my @subs = map { [compile($_->[0], 'atmsort.pm'), compile_sub($_->[1], 'atmsort.pm')] } @builtin_subs;
	my @files = @inits;

	unless (@files)
	{
		my $top = source_tree($file);
		push @files, "$top/src/test/regress/init_file";
		push @files, "$top/src/test/isolation2/init_file_isolation2"
			if abs_path($file) =~ m{/src/test/isolation2/};
	}
	read_init_file($_, \@ignores, \@subs) for @files;

	open my $in, '<', $file or die "$file: $!\n";
	my @lines = <$in>;
	close $in;

	my ($nremoved, $ncut) = (0, 0);
	my @kept;
	for my $line (@lines)
	{
		my $nl = ($line =~ s/\n\z//) ? "\n" : '';

		if ($line =~ /^(?:HINT|CONTEXT|GP_IGNORE):/ || grep { $_->($line) } @ignores)
		{
			print "$file: removed: $line\n" if $dry || $ENV{VERBOSE};
			$nremoved++;
			next;
		}
		my $new = $line;
		for my $s (@subs)
		{
			$new = $s->[1]->($new) if $s->[0]->($new);
		}
		if ($new ne $line)
		{
			print "$file: cut: $line\n" if $dry || $ENV{VERBOSE};
			$ncut++;
		}
		push @kept, $new . $nl;
	}

	print "$file: $nremoved lines removed, $ncut lines cut\n";
	next if $dry || ($nremoved == 0 && $ncut == 0);
	open my $out, '>', $file or die "$file: $!\n";
	print $out @kept;
	close $out;
}
