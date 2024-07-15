# Reais 
addi  x1, zero,  2; #  x1 =  0 +  2
addi  x2, zero,  6; #  x2 =  0 +  6
add   x3, x2  , x1; #  x3 = x2 + x1
sub   x4, x2  , x1; #  x4 = x2 - x1
mul   x5, x2  , x1; #  x5 = x2 * x1
div   x6, x2  , x1; #  x6 = x2 / x1
and   x7, x2  , x1; #  x7 = x2 && x1
or    x8, x2  , x1; #  x8 = x2 || x1
andi  x9, x2  , 63; #  x9 = x2 and x"3F"
sll  x10, x2  , x1; # x10 = x2 << x1
srl  x11, x2  , x1; # x11 = x2 >> x1
sw    x2,  0(zero); # memd(0) = x2
lw   x12,  0(zero); # x12 = memd(0)

# Complexos
addi  x1, zero,  196612; # x1 = 0 +  196612 = 196612 ou  3 + 4i
addi  x2, zero,  786437; # x2 = 0 +  786437 = 786437 ou 12 + 5i
divc x13,   x2,      x1; # 
