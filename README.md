# split_md_dsd
Split Michael Brown's DSD Game disks into separate SSDs

This code is designed to work with the perl [MMB_Utils](https://github.com/sweharris/MMB_Utils) to split up Michael Brown's games disks, as posted to http://www.stardot.org.uk/forums/viewtopic.php?f=32&t=8270 and discussed at http://www.stardot.org.uk/forums/viewtopic.php?f=6&t=9563

On each disk image he has a !BOOT menu (a BASIC program with a *RUN wrapper) that lists each game and the program that needs to be CHAINed to start it.  He puts files on the image in a specific order.  So this program will take such an image, parse and split the DSD up into separate SSDs, one per game.

It's pretty limited use case, that's for sure!
