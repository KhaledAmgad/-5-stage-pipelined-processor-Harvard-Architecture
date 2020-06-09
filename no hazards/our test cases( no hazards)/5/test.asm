# tested operations (shl,shr,iadd)
.org 0
2

.org 2
ldm R0,2
ldm R2,4FFF
nop
shr R0,2
nop
nop
shr R0,2
shl R2,12
nop
nop
shl R2,2



