# MBIN_Haxables for No Man's Sky v1.34  
License: Public Domain  
Author: Gaticus Hax  


## BRIEF

A compilation of CheatEngine CheatTables for No Man's Sky that map the entire data blocks of the MBIN files.  
Each CheatTable can also automatically hook to RAM for realtime edits while the game is running.  
These are designed mainly as a modding tool and for reverse-engineering NMS although they can also be used for a super-charged trainer.  

THESE ARE FOR ADVANCED USERS ONLY. YOU SHOULD ALREADY KNOW HOW TO HEX EDIT, HOW C-STYLE DATA STRUCTURES ARE  
SERIALIZED AND STORED IN BINARY AND HOW PROCESS MEMORY WORKS. 


## REQUIREMENTS  

You will need CheatEngine to use these files. These scripts and tables are built using v6.7.  
I expect they should work with other, similar versions as well but YMMV.

- [CheatEngine](http://cheatengine.org/). 

You will also need No Man's Sky.

- [No Man's Sky](http://store.steampowered.com/app/275850/No_Mans_Sky/)
  
These tables will only work with the version of No Man's Sky that is noted at the top of this file.  
Most of the tables should continue to work with future patches, depending on what gets changed.
Some of these tables should also work for previous versions of NMS.


## DECRIPTION  


## USAGE

*WARNING*: These cheat tables use a pretty simplistic method to locate the data in RAM by  
scanning for 'signature bytes'. These signature bytes come from the MBIN files themselves.  
If you modify those particular bytes, you will need to assign a new signature in the  
corresponding *-Signature.lua script. Most tables will use the first 32 bytes of data in  
the MBIN files (beyond the header), starting at offset 0x60. 

