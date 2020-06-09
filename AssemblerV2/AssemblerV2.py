# -*- coding: utf-8 -*-
"""
Created on Sun Apr 19 10:22:36 2020

@author: Kareem Omar
"""
import os
import numpy as np
import sys
def fix_length_16(assembledline: str) -> str: #append zeros on right of string to fill 16
    diff = 16 - len(assembledline)
    if(diff == 0):
        return assembledline
    fixed = ''
    for i in range (diff):
        fixed += '0'
    fixed= assembledline + fixed
    return fixed

def left_fix_length_20(assembledline: str) -> str: #append zeros on left of string to fill 16
   # assembledline.replace("0b", "", 1)
    diff = 20 - len(assembledline)
    if(diff == 0):
        return assembledline
    fixed = ''
    for i in range (diff):
        fixed += '0'
    fixed+= assembledline
    return fixed

OP_Codes = {'NOT':'000001',
            'INC':'000010',
            'DEC':'000011',
            'OUT':'000100',
            'IN':'000101',
            'SWAP':'000110',
            'ADD':'000111',
            'SUB':'001000',
            'AND':'001001',
            'OR':'001010',
            'PUSH':'001011',
            'POP':'001100',
            'JZ':'001101',
            'JMP':'001110',
            'CALL':'001111',
            'SHL':'010000',
            'SHR':'010001',
            'LDM':'010010',
            'IADD':'010011',
            'LDD':'010100',
            'STD':'010101',}

Registers = {'R0':'000',
            'R1':'001',
            'R2':'010',
            'R3':'011',
            'R4':'100',
            'R5':'101',
            'R6':'110',
            'R7':'111',}

OutputAssembledLines = {}
if (len(sys.argv)>1):
    readfile=(sys.argv[1])
else:
    readfile="Test.asm"


splitfilename,extension = readfile.split('.')
if (len(sys.argv)>2):
    outfile=(sys.argv[2])
else:
    outfile = "Out" + splitfilename + ".txt"


if os.path.isfile(readfile):
    try:
        os.remove(outfile)
    except:
        print("Error while deleting file ", outfile)
else:
    print("file not found or no file specified")
    sys.exit()

count=0        
for line in list(open(readfile)):   
    line=line.strip()
    # inline comments handling start
    try:
        if(line[0] != '#'):
            line,comment = line.split("#")
            #print("found inline comment: " + comment)
            line=line.strip()
    except:
        None
        #inline comments handling end
    try:
        line=int(line,16)
        line ='{0:032b}'.format(np.uint32(line))
        OutputAssembledLines[count] = line[16:]
        count +=1
        OutputAssembledLines[count] = line[:16]
        count +=1
        continue
    except :
        if (not line) or (line in ['\n', '\r\n']) or line.upper()[0] == '#': # empty spaces, empty lines and comments check
            continue
        elif line.upper()[0] == '.':
            ORGcommand,addressVal = line.split(" ")
            count=int(addressVal,16)
            continue
        
        elif line.upper() == "NOP" or line.upper() == "RET":
            if line.upper() == "NOP":
                OutputAssembledLines[count] = "0000000000000000"
            else:
                OutputAssembledLines[count] = "1000000000000000"
            count +=1
            continue
        try:
            instruction_name,operands = line.split(" ",1)
            instruction_name = instruction_name.strip()
            operands=operands.strip()
            instruction_name = instruction_name.upper()
        except:
            if line.strip().isdigit():
                continue
            print("invalid line: " + line)
            continue
        if (instruction_name == "NOT" or instruction_name == "INC" or instruction_name == "DEC"):
            tempStr = OP_Codes[instruction_name]+Registers[operands]+Registers[operands]
            OutputAssembledLines[count] = fix_length_16(tempStr)
            count +=1
            continue
        elif (instruction_name == "IN" or instruction_name == "POP" ):
            tempStr = OP_Codes[instruction_name]+Registers[operands]
            OutputAssembledLines[count] = fix_length_16(tempStr)
            count +=1
            continue
        elif (instruction_name == "OUT" or instruction_name == "PUSH" or instruction_name == "JZ" or instruction_name == "JMP" or instruction_name == "CALL"):
            tempStr = OP_Codes[instruction_name]+"000"+Registers[operands]
            OutputAssembledLines[count] = fix_length_16(tempStr)
            count +=1
            continue
        elif (instruction_name == "SWAP"):
            Rsrc,Rdst = operands.split(',')
            Rsrc = Rsrc.strip()
            Rdst = Rdst.strip()
            tempStr = OP_Codes[instruction_name]+Registers[Rdst]+Registers[Rdst]+Registers[Rsrc]
            OutputAssembledLines[count] = fix_length_16(tempStr)
            count +=1
            continue
        elif (instruction_name == "AND" or instruction_name == "ADD" or instruction_name == "SUB" or instruction_name == "OR"):
            Rsrc1,Rsrc2,Rdst = operands.split(',',2)
            Rsrc1=Rsrc1.strip()
            Rsrc2=Rsrc2.strip()
            Rdst=Rdst.strip()
            tempStr = OP_Codes[instruction_name]+Registers[Rdst]+Registers[Rsrc1]+Registers[Rsrc2]
            OutputAssembledLines[count] = fix_length_16(tempStr)
            count +=1
            continue
        elif (instruction_name == "LDD"):
            Rdst,EA = operands.split(',')
            Rdst=Rdst.strip()
            EA = EA.strip()
            EA = bin(int(EA,16))[2:]
            EA = left_fix_length_20(EA)
            tempStr = OP_Codes[instruction_name]+Registers[Rdst] +'000'+ EA[0:4]
            OutputAssembledLines[count] = tempStr
            count +=1
            OutputAssembledLines[count] = EA[4:]
            count +=1
            continue
        elif (instruction_name == "STD"):
            Rsrc,EA = operands.split(',')
            Rsrc=Rsrc.strip()
            EA = EA.strip()
            EA = bin(int(EA,16))[2:]
            EA = left_fix_length_20(EA)
            tempStr = OP_Codes[instruction_name]+'000'+Registers[Rsrc] + EA[0:4]
            OutputAssembledLines[count] = tempStr
            count +=1
            OutputAssembledLines[count] = EA[4:]
            count +=1
            continue
        elif (instruction_name == "SHL" or instruction_name == "SHR"):
            Rsrc,Imm = operands.split(',')
            Rsrc=Rsrc.strip()
            Imm=Imm.strip()
            Imm = int(Imm,16)
            Imm = '{0:016b}'.format(np.uint16(Imm))
            tempStr =OP_Codes[instruction_name]+Registers[Rsrc]+Registers[Rsrc]+Imm[0:4]
            OutputAssembledLines[count] = tempStr
            count +=1
            OutputAssembledLines[count] = Imm[4:]+"0000"
            count +=1
            continue
        elif (instruction_name == "LDM"):
            Rsrc,Imm = operands.split(',')
            Rsrc=Rsrc.strip()
            Imm=Imm.strip()
            Imm = int(Imm,16)
            Imm = '{0:016b}'.format(np.uint16(Imm))
            tempStr =OP_Codes[instruction_name]+Registers[Rsrc]+'000'+Imm[0:4]
            OutputAssembledLines[count] = tempStr
            count +=1
            OutputAssembledLines[count] = Imm[4:]+"0000"
            count +=1
            continue
        elif (instruction_name == "IADD"):
            Rsrc,Rdst,Imm = operands.split(',',2)
            Rsrc=Rsrc.strip()
            Rdst=Rdst.strip()
            Imm=Imm.strip()
            Imm = int(Imm,16)
            Imm = '{0:016b}'.format(np.uint16(Imm))
            tempStr =OP_Codes[instruction_name]+Registers[Rdst]+Registers[Rsrc]+Imm[0:4]
            OutputAssembledLines[count] = tempStr
            count +=1
            OutputAssembledLines[count] = Imm[4:]+"0000"
            count +=1
            continue
try:
    out = open(outfile, "w")
    maxval= max(OutputAssembledLines,key=int)+1 # to include final value
    for i in range(maxval):
        if i in OutputAssembledLines.keys():
            out.write("\""+str(OutputAssembledLines[i])+"\""+","+"\n")
        else:
            out.write("\""+"0000000000000000"+"\""+","+"\n") # fill out empty spaces in memory
    out.close()
except:
    print("something went wrong during file write!")
    out.close()