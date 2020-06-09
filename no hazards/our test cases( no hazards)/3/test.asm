# tested operations (push,pop,In,OUT,OR,and)
.org 0
2

.org 2
ldm R1,1
IN R2
nop
push R1
or R1,R2,R4
and R1,R2,R5
pop R3
out R4
