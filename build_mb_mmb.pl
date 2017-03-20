#!/usr/bin/perl
use warnings;
use strict;

use lib '/home/sweh/misc/BBC/MMB_Utils';
use BeebUtils;

# The majority of these tools weren't designed to handle MMB in-memory
# images; they were designed to work with files.  Makes me wonder if
# I have my abstraction layer correct.  Ah well...
# These are repeated from BeebUtils
my $SecSize=256;
my $DiskTableSize=32*$SecSize;
my $MaxDisks = ($DiskTableSize/16)-1;  # slot 0 isn't a real disk
my $DiskSectors = 800 ; # Only size supported! 80track single density
my $DiskSize = $DiskSectors * $SecSize;

# What to call the menu disk
my $MENU_NAME="MB's Games";

# Create an in-memory MMB image
my $mmb=BeebUtils::blank_mmb();
my $disktable=substr($mmb,0,$DiskTableSize);

# This is used to help split the DSD into two SSD images so we can
# write them to the MMB
my $TRACK_SIZE=$SecSize*10;

# We start adding the images at image 10
my $img_number=10;

# Keep track of what games we've seen, where
my %Title;
my %Discs;

foreach my $dsd (<SRC/*.dsd>)
{
  print STDERR "Processing $dsd into slots $img_number and " . ($img_number+1) . "\n";

  my $disk_name=$dsd; $disk_name=~s!^.*/!!; $disk_name=~s!\.dsd$!!;

  # Load the DSD into memory
  my $src_image=BeebUtils::load_external_ssd($dsd,0);
  # Ensure the disk is big enough (MBs disks shouldn't suffer this, but...)
  $src_image .= "\0" x ($TRACK_SIZE*80*2);

  my ($disk0,$disk2);

  foreach my $track (0..79)
  {
    my $offset=$track*$TRACK_SIZE*2; # interleaved
    $disk0 .= substr($src_image,$offset,$TRACK_SIZE);
    $disk2 .= substr($src_image,$offset+$TRACK_SIZE,$TRACK_SIZE);
  }

  # So now $disk0 and $disk2 are SSD images.
  # We can add these to the MMB
  # There's no function in MMB_Utils.  Just blat over the image
  substr($mmb,BeebUtils::DiskPtr($img_number),$DiskSize)=$disk0;
  substr($mmb,BeebUtils::DiskPtr($img_number+1),$DiskSize)=$disk2;

  # Read the disk name from the catalog
  my %cat0=BeebUtils::read_cat(\$disk0);
  my $title=$cat0{""}{title};
  $title=ucfirst(lc($title));
  $Discs{$title}=$img_number;

  # Set the two image types to be RW
  BeebUtils::DeleteSlot($img_number,1,\$disktable);  # set's disk type to RW
  BeebUtils::DeleteSlot($img_number+1,1,\$disktable);  # set's disk type to RW

  # Set the image title for DCAT to be the disk name with a/b appended
  BeebUtils::ChangeDiskName($img_number,$disk_name . "a",\$disktable);
  BeebUtils::ChangeDiskName($img_number+1,$disk_name . "b",\$disktable);

  # Let's get the !BOOT
  my $boot=BeebUtils::ExtractFile(\$disk0,'$.!BOOT',%cat0);

  # This description of !BOOT is duplicated from split_mb_mmb
  # 
  # Now !BOOT is a BASIC program.  MB put this in a specific
  # format; there's the menu code and then some DATA statements
  # eg
  #   190REM"^A  ***** DRIVE 0 *****
  #   200DATAtitle,PROGRAM
  #   ...
  #   290REM"^A  ***** DRIVE 2 *****
  #   300DATAtitle,PROGRAM
  #   ...
  # end of BASIC
  # (where the ^A character is actually 0x81)
  # Rather than LISTing the !BOOT file, we use some knowledge of BASIC
  # binary format
  #  each line is 0x0D ## ## ## (there those three bytes make up line number
  #    and line length).
  #  We know a REM is 0xF4 and we know a DATA is 0xDC
  #  This makes a "search for data" a little simpler
  
  # Character tokens
  my $rem=chr(244);  my $data=chr(220);  my $end_prog=chr(255);  my $red=chr(129);

  my $drive=-1;
  while ($boot)
  {
    last if substr($boot,0,2) eq "\r$end_prog";
    die "Bad !BOOT - Bad Program\n" unless substr($boot,0,1) eq "\r";

    my $len=ord(substr($boot,3,1));
    my $line=substr($boot,4,$len-4);
    $boot=substr($boot,$len,-1);
    
    if ($line=~/^${rem}"${red}(.*DRIVE |DR\.)([02]) */)
    {
      $drive=$2;
      next;
    }

    next if $drive == -1;

    # Some lines may have whitespace at the end
    $line=~s/\s+$//;

    # This is a dummy line
    next if $line =~ /^${data}"?\*/;

    if ($line=~/^${data}(.*),(.*)$/)
    {
      my ($game,$file)=($1,$2);
      while (defined($Title{$game}))
      {
        print STDERR "$game ($disk_name) already exists on $Title{$game}{n}; adding a _ to the end\n";
        $game .= "_";
      }
      $Title{$game}{n}=$disk_name;
      $Title{$game}{i}=$img_number;
      $Title{$game}{d}=$drive;
      $Title{$game}{f}=$file;
    }
  }

  $img_number+=2;
  die "Too many disks!\n" if $img_number >= $MaxDisks;
}

# Now we need to build the menu disk.

# First we'll generate a Data file in Beeb INPUT# format for the
# names of each disk and the slot they are in
my $disk_slot="";
foreach (sort keys %Discs)
{
  # String format is <00><len><string_in_reverse>
  # Integer format is <40><b3><b2><b1><b0>
  $disk_slot .= "\0" . chr(length($_)) . reverse($_) .
                "\x40" . pack("N",$Discs{$_});
}

# Similarly, a list of games to disk and slot
# (title,slot,side,filename)
my $game_disk="";
foreach (sort keys %Title)
{
  $game_disk .= "\0" . chr(length($_)) . reverse(uc($_)) .
                "\x40" . pack("N",$Title{$_}{i}) .
                "\x40" . pack("N",$Title{$_}{d}) .
                "\0" . chr(length($Title{$_}{f})) . reverse($Title{$_}{f});

}
## OLD FORMAT TO BE *LOADED
## my $menu_data="";
## my @discs=sort keys %Discs;
## foreach (@discs)
## {
##   $menu_data .= "$_\r$Discs{$_}\r";
## }
## 
## $menu_data .= "!END_DATA!\r-1\r";

my $menu_disk=BeebUtils::blank_ssd();
BeebUtils::set_ssd_title(\$menu_disk,$MENU_NAME);
BeebUtils::opt4(\$menu_disk,3);

BeebUtils::add_content_to_ssd(\$menu_disk,'$.!BOOT',"CHAIN \"MENU\"\r",0,0,1);
BeebUtils::add_content_to_ssd(\$menu_disk,'$.Menu',`cat Menu`,0,0,1);
## BeebUtils::add_content_to_ssd(\$menu_disk,'$.DATA',$menu_data,0,0,1);
BeebUtils::add_content_to_ssd(\$menu_disk,'$.DSKDATA',$disk_slot,0,0,1);
BeebUtils::add_content_to_ssd(\$menu_disk,'$.GAMDATA',$game_disk,0,0,1);

# Save this to the MMB
substr($mmb,BeebUtils::DiskPtr(0),$DiskSize)=$menu_disk;
BeebUtils::DeleteSlot(0,1,\$disktable);  # set's disk type to RW
BeebUtils::ChangeDiskName(0,$MENU_NAME,\$disktable);

# Add the MMB table of contents to the MMB image
substr($mmb,0,$DiskTableSize)=$disktable;

# Cheat and write it out with write_ssd
BeebUtils::write_ssd(\$mmb,"BEEB.MMB");
