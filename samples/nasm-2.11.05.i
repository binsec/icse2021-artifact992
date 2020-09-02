# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 59 "ilog2.c"
int ilog2_32(uint32_t v)
{
    int n;

    __asm__("bsrl %1,%0 ; jnz 1f ; xorl %0,%0\n"
            "1:"
            : "=&r" (n)
            : "rm" (v));
    return n;
}

