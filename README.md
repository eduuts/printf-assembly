# printf-assembly
As mentioned before, theprintfsubroutine is just a subroutine like any other.  To prove this,you will write your own simplified version ofprintfin this assignment.Exercise:Write a simplifiedprintfsubroutine that takes a variable amount of arguments.  The first ar-gument for your subroutine is the format string.  The rest of the arguments are printed insteadof the placeholders (also called format specifiers) in the format string.  How those arguments areprinted depends on the corresponding format specifiers.  Yourprintffunction has to support anynumber of format specifiers in the format string.  Any format specifier after that may be printedwithout modification.Unlike the realprintf, your version only has to understand the format specifiers listed below.If a format specifier is not recognized, it should be printed without modification.  Give yourprintffunction a different name (e.g.myprintf) to avoid confusion with the realprintffunction in theC library.  Please note that for this exercise you are not allowed to use theprintffunction orany other C library function.  This means you will have to use system calls for the actual printing.Your function must follow the proper x8664 calling conventions.Supported format specifiers:%dPrint a signed integer in decimal.  The corresponding parameter is a 64 bit signed integer.%uPrint  an  unsigned  integer  in  decimal.   The  corresponding  parameter  is  a  64  bit  unsignedinteger.%sPrint a null terminated string.  No format specifiers should be parsed in this string.  Thecorresponding parameter is the address of first character of the string.%%Print a percent sign.  This format specifier takes no argument.Example:Suppose you have the following format string:My name is %s.  I think I’ll get a %u for my exam.  What does %r do?  And %%?Also  suppose  you  have  the  additional  arguments  “Piet”  and  10.   Then  your  subroutine  shouldoutput:My name is Piet.  I think I’ll get a 10 for my exam.  What does %r do?  And %?
