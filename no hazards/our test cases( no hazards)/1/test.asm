# basic loop to add numbers from 1 to 5 and OUT them
# tested operations (ldm,add,inc,dec,jz,jmp,out)
.org 0
A

.org 2
out R3
nop
nop
.org A
ldm R6,16
nop
nop
ldm R1,5
nop
nop
ldm R5,2
nop
nop
ldm R2,1
nop
nop
add R3,R2,R3
nop
nop
inc R2
nop
nop
dec R1
nop
nop
jz R5
nop
nop
jmp R6
