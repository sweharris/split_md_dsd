#!/usr/bin/perl
use warnings;
use strict;

my %stardot=();
my %bbcmicro=();
my %skiplist=();
my $fh;

open($fh,"< compare_sites_skiplist")or die "Can not open skiplist: $!\n";
while(<$fh>)
{
  chomp;
  $skiplist{$_}=1;
}

print "Getting checksums of startdot tree\n";
open($fh,"md5sum RESULTS/*|") or die "Can not md5 stardot tree:$!\n";

while(<$fh>)
{
  chomp;
  my ($sum,$name)=split(/\s+/,$_,2);
  $name=~s!RESULTS/!!;
  if (defined($stardot{$sum}))
  {
    print "Woah, $stardot{$sum} and $name have same checksum!  Skipping $name\n";
  }
  else
  {
    $stardot{$sum}=$name;
  }
}

print "Getting checksums of bbcmicro tree\n";
open($fh,"md5sum BBCMicro/*/*.ssd|") or die "Can not md5 bbcmicro tree:$!\n";

while(<$fh>)
{
  chomp;
  my ($sum,$name)=split(/\s+/,$_,2);
  $name=~s!BBCMicro/!!;
  # We don't actually care if bbcmicro has duplicates (we know it does)
  # 'cos we just need to verify that every stardot disk is here, so one
  # matching file is enough
  $bbcmicro{$sum}=$name;
}

# Now we can compare the trees
foreach (keys %stardot)
{
  if (!defined($bbcmicro{$_}))
  {
    next if $skiplist{$stardot{$_}};
    print "Stardot disk $stardot{$_} with checksum $_ has no match on bbcmicro\n";
  }
}

# At this moment, bbcmicro has more than just the MB games, so it's not
# worth doing this check
#foreach (keys %bbcmicro)
#{
#  if (!defined($stardot{$_}))
#  {
#    print "BBCMicro disk $bbcmicro{$_} with checksum $_ has no match on stardot\n";
#  }
#}

