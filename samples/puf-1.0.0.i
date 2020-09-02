# 582 "puf.h"
static inline int
hash_shift(int num)
{
    int i;


    asm("xorl %0,%0\n\tbsr %1,%0" : "=r" (i) : "rm" (num));
    i -= 6 - 1;
    if (i < 0)
 i = 0;



    return i;
}

