# split_md_dsd
Split Michael Brown's DSD Game disks into separate SSDs

This code is designed to work with the perl [MMB_Utils](https://github.com/sweharris/MMB_Utils) to split up Michael Brown's games disks, as posted to http://www.stardot.org.uk/forums/viewtopic.php?f=32&t=8270 and discussed at http://www.stardot.org.uk/forums/viewtopic.php?f=6&t=9563

On each disk image he has a !BOOT menu (a BASIC program with a *RUN wrapper) that lists each game and the program that needs to be CHAINed to start it.  He puts files on the image in a specific order.  So this program will take such an image, parse and split the DSD up into separate SSDs, one per game.

This program takes some options:

    -v (verbose)
    -vv (very verbose)
    -R (where to put the results; defaults to RESULTS)
    -S (where to find the source DSDs; defaults to SRC)
    ..filelist..  (if not specified then process everything in SRC/*.dsd)

e.g.

    split_mb_dsd.pl -S mysrc -R myres
    split_mb_dsd.pl -R tst SRC/Disc023.dsd


# build_mb_mmb.pl
Convert Michael Brown's disks and create an MMB image of it.  Each DSD
will be split into SSDs and inserted starting at slot 10 (so disk1 side 1
would be at 10, side 2 at 11).

A simple menu disk is created, with the `Menu` program added and data
files appended.

These are pretty limited use case, that's for sure!

# Menu
The menu program added to disk 0 from `build_mb_mmb.pl`

# Menu.src
ASCII source code to generate `Menu`
