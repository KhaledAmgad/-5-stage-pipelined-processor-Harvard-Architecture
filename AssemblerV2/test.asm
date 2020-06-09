#load 2 value from memory, call a function to swap them, return then write swapped values back
# tested operations (ldd,std,swap,call,ret)
.org 0
#start of code
A
#data memory
1
2
3
4

.org A
ldd R1,2
not R1
push R1
nop
pop R2
nop
nop
not R2
ldm R5,30
call R5
std R1,2
std R2,4

.org 30
swap R1,R2
RET

Not R1