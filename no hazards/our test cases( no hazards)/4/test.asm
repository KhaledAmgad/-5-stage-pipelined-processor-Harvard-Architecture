# tested operations (shl,shr,iadd)
.org 0
B

.org B
iadd R0,R0,4
nop
nop
nop
shr R0,1
nop
nop
nop
add R0,R1,R1
nop
nop
nop
shl R1,2
nop
nop
nop
sub R1,R0,R1
nop
nop
nop
not R0
nop
nop
not R1

.org 2
C
E
A