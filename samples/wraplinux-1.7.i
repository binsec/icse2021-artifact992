# 46 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stdint-gcc.h"
typedef unsigned char uint8_t;

# 52 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stdint-gcc.h"
typedef unsigned int uint32_t;

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 38 "./reloc/reloc.h"
static inline void memset(void *dst, int c, size_t len)
{
 uint32_t ecx = len >> 2;

 asm volatile("rep; stosl; "
       "movl %3,%%ecx; "
       "rep; stosb"
       : "+D" (dst), "+c" (ecx)
       : "a" ((uint8_t)c*0x01010101), "bdS" (len & 3)
       : "memory");
}

