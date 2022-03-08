# Gable-STD-ASM-Library
## Standard Library for Intel 64-bit Assembly
This library provides some basic macros that can be used when writing 64-bit Intel Assembly. These macros deal with I/O as well as type conversions.
## Macros
- exit \<code\>
  - Exits the program
- print \<text\>
  - Prints a given text to the screen
- printline \<text\>
  - Prints a given text to the screen and moves to the next line
- printint \<qword\>
  - Prints the given qword integer to the screen
- newline
  - Prints a new-line character to the screen
- readline \<text\> \<length\>
  - Reads text from the screen into "text" variable of length "length"
- readint \<qword\>
  - Reads an integer from the screen into the given qword
- prompt \<prompt-text\> \<destination-bytes\> \<bytes-length\>
  - Prompts a user with text and saves input in destination variable
- promptint \<prompt-text\> \<destination-qword\>
  - Prompts a user with text and saves input in destination variable (qword integer)
- itoa \<text/destination\> \<qword/source\>
  - Converts integer to ascii
- atoi \<qword/destination\> \<text/source\>
  - Converts ascii to integer
- debug
  - Prints DEBUG to the screen
