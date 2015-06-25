import std.c.stdio;
import forth;			// Forth

export extern (C)  void dll_initForth() { 	initForth();  }

export  extern (C)  void dll_includedForth(char *nameFileForth) { 	includedForth(nameFileForth); }

export extern (Windows)  void dll_winitForth() { initForth(); }

export  extern (Windows)  void dll_wincludedForth(char *nameFileForth) { 	forth.dumpAdr(cast(pp)nameFileForth); }