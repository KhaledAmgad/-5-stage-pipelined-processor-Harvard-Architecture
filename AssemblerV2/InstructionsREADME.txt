Assembler for 5-stage pipelined processor
CMP 2021 SEM TEAM 10
Khalid Amgad
Marc Nagui
Sherif Essam
Kareem Omar

op codes are included in the design

the program can run with:-
a) 2 parameters: input file and outputfile
b) 1 parameter: input file (will generate an output file based on the input file name)
c) no parameters: the program will expect an input file with the name "test.asm" in its directory

the output is generated as txt file containing RAM data line by line starting from zero

the program can ignore empty lines, lines with spaces and lines starting with # symbol

the program can handle comments in the same line as instructions

variables in input file (not addresses) will take 2 lines places in RAM (under the data section)

instructions of use:
* run the .py file with parameters numbers from 0 to 2 according the parameter part mentioned above.

note:
the output binary will need to be manually copied into the RAM of the CPU (RAM 4GB.vhd)