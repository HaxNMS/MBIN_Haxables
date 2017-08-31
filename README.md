# MBIN_Haxables for No Man's Sky v1.34  
License: Public Domain  
Author: Gaticus Hax  


## BRIEF

A compilation of CheatEngine CheatTables for No Man's Sky that map the entire data blocks of the MBIN files.  
Each CheatTable can also automatically hook to RAM for realtime edits while the game is running.  
These are designed as a modding tool for NMS.

**These are for advanced users only. You should already know how to hex edit, how C-style data structures are
serialized in binary and how process memory works.**


## REQUIREMENTS  

You will need CheatEngine to use these files. These scripts and tables are built using v6.7.  
They should work with other, similar versions as well but YMMV.

- [CheatEngine](http://cheatengine.org/). 

You will also need No Man's Sky.

- [No Man's Sky](http://store.steampowered.com/app/275850/No_Mans_Sky/)
  
These tables will only work with the version of No Man's Sky that is noted at the top of this file.  


## DECRIPTION  


## USAGE

**WARNING**: _These cheat tables use a pretty simplistic method to locate the data in RAM by  
scanning for 'signature bytes'. These signature bytes come from the MBIN files themselves.  
If you modify those particular bytes, you will need to assign a new signature in the  
corresponding XXX-Signature.lua script. Most tables will use the first 32 bytes of data in  
the MBIN files (beyond the header), starting at offset 0x60._

