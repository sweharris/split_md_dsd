There are 4 commands you need to run, in order, to generate the results

  $ ./get_all_zips 
     This downloads all the ZIP files from Stardot and puts them in ZIPS

  $ ./unzip_all 
     The extracts the dsds and then the ssds, the results are in RESULTS 

  $ ./get_bbcmicro
     This generates the archive, downloads the zip file, extracts it.
     Remember: bbcmicro caches the zip file so running this too frequently
     won't show updates

  $ ./compare_sites.pl
     Compares the two site's SSD images


Example (with a lot of lines stripped out)
    
    $ ./get_all_zips 
    Using https://www.stardot.org.uk/forums/viewtopic.php?f=32&t=8270
    
    
    Getting Page 001
    ...
    Getting Page 002
    ...
    Getting Page 019
    -rw-r--r-- 1 sweh sweh 78934 Nov 25 12:44 page019
    Searching for next page
    Using https://www.stardot.org.uk/forums/viewtopic.php?f=32&t=9049
    
    
    Getting Page 020
    ...
    Getting Page 021
    -rw-r--r-- 1 sweh sweh 58101 Nov 25 12:44 page021
    Searching for next page
    No more pages
    
    Searching for zip files for Disc
    -rw-r--r-- 1 sweh sweh 146249 Aug 31  2018 Disc001.zip
    -rw-r--r-- 1 sweh sweh 146912 Sep 17  2018 Disc002.zip
    ...
    -rw-r--r-- 1 sweh sweh 53327 Nov 21 07:42 Disc140.zip
    Searching for zip files for AltD
    -rw-r--r-- 1 sweh sweh 136585 Oct 15  2018 AltD001.zip
    -rw-r--r-- 1 sweh sweh 171592 Oct 15  2018 AltD002.zip
    ...
    -rw-r--r-- 1 sweh sweh 177287 Jun 24 12:55 AltD011.zip
    Searching for zip files for Orig
    -rw-r--r-- 1 sweh sweh 175534 Oct 15  2018 Orig001.zip
    
    $ ls ZIPS
    AltD001.zip  Disc016.zip  Disc042.zip  Disc068.zip  Disc094.zip    Disc120.zip
    AltD002.zip  Disc017.zip  Disc043.zip  Disc069.zip  Disc095.zip    Disc121.zip
    ....
    
    $ ./unzip_all 
    Archive:  ../ZIPS/AltD001.zip
      inflating: AltD001.dsd             
    Archive:  ../ZIPS/AltD002.zip
      inflating: AltD002.dsd             
    ...
    Archive:  ../ZIPS/Disc140.zip
      inflating: Disc140.dsd             
    Archive:  ../ZIPS/Orig001.zip
      inflating: Orig001.dsd             
    Processing SRC/AltD001.dsd
    Processing SRC/AltD002.dsd
    ...
    Processing SRC/Disc140.dsd
    Processing SRC/Orig001.dsd
    
    $ ls RESULTS
    Disc001-BananaMan.ssd
    Disc001-BugBlaster.ssd
    Disc001-CylonAttackAFSTD.ssd
    ...
    DiscO01-ScrambleRocketRaid.ssd
    DiscO01-SpacePanicMonsters.ssd
    DiscO01-ZaxxonFortress.ssd
    
    $ ./get_bbcmicro
    Requesting archive build - may take a few minutes
    
    <!DOCTYPE html>
    <html>
     <head>
     <meta charset="utf-8">
     <meta name="robots" content="noindex">
    </head>
    <body>
    <p>
    Using cached file<br/><a href='tmp/BBCMicroFiles.zip'>All files(zip)</a><br><a href='tmp/BBCMicroScShots.zip'>All screenshots(zip)</a><br></p></body></html>
    Downloading Zip file
    --2019-11-25 12:46:58--  http://bbcmicro.co.uk/tmp/BBCMicroFiles.zip
    Resolving bbcmicro.co.uk (bbcmicro.co.uk)... 82.148.225.178
    Connecting to bbcmicro.co.uk (bbcmicro.co.uk)|82.148.225.178|:80... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 39589543 (38M) [application/zip]
    Saving to: 'BBCMicroFiles.zip'
    
    2019-11-25 12:47:02 (12.7 MB/s) - 'BBCMicroFiles.zip' saved [39589543/39589543]
    
    
    Extracting contents
    Archive:  BBCMicroFiles.zip
      inflating: 0/10MinuteGame-2973.ssd  
      inflating: 0/180Darts-145.ssd      
      inflating: 0/1984-937.ssd          
    ...
      inflating: Z/Zoo-2262.ssd          
      inflating: Z/ZorakkTheConqueror-270.ssd  
      inflating: Z/ZuyderZee-1548.ssd    
      inflating: readme.html             
      inflating: index.html              
    
    $ ./compare_sites.pl
    Getting checksums of startdot tree
    Getting checksums of bbcmicro tree
    Stardot disk Disc140-Jog.ssd with checksum 57c14edaad40985683d4cbcc47e70589 has no match on bbcmicro
    Stardot disk Disc066-CircusGamesD.ssd with checksum 52e5f2ef3ae55d5c7ac6a6596cb4896b has no match on bbcmicro
    Stardot disk Disc023-ManicMechanic.ssd with checksum baf282f3c4c910463ef46507c31d2037 has no match on bbcmicro
    Stardot disk Disc139-Deathmaze.ssd with checksum 01df75bc83682123f31537a0ababe168 has no match on bbcmicro
    Stardot disk Disc118-767AdvancedFlightSimulator.ssd with checksum 9deef0782cd2a57d8c059f9cea74027d has no match on bbcmicro
    Stardot disk Disc072-PushTheBale.ssd with checksum 1ad2dc2d5d656d9b415e462d184fd422 has no match on bbcmicro
    Stardot disk Disc120-Midway.ssd with checksum 1b282c6927f44352a6da578b17edac7a has no match on bbcmicro
    Stardot disk Disc029-ImogenP.ssd with checksum bf31df8d34d842a7789e260c27723245 has no match on bbcmicro
    Stardot disk Disc097-DungeonAdventureSTT.ssd with checksum 3ab5140bcc7d99850c67b6bb6a70e299 has no match on bbcmicro
    Stardot disk Disc019-YieArKungFu.ssd with checksum 9c04619c3acc9392c7d7aa23c0ec81a7 has no match on bbcmicro

