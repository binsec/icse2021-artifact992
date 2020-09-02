# 1461 "/usr/include/xorg/compiler.h"
static __inline__ void
outb(unsigned short port, unsigned char val)
{
    __asm__ __volatile__("out%B0 (%1)"::"a"(val), "d"(port));
}

# 1467 "/usr/include/xorg/compiler.h"
static __inline__ void
outw(unsigned short port, unsigned short val)
{
    __asm__ __volatile__("out%W0 (%1)"::"a"(val), "d"(port));
}

# 1473 "/usr/include/xorg/compiler.h"
static __inline__ void
outl(unsigned short port, unsigned int val)
{
    __asm__ __volatile__("out%L0 (%1)"::"a"(val), "d"(port));
}

# 1479 "/usr/include/xorg/compiler.h"
static __inline__ unsigned int
inb(unsigned short port)
{
    unsigned char ret;
    __asm__ __volatile__("in%B0 (%1)":"=a"(ret):"d"(port));

    return ret;
}

# 1488 "/usr/include/xorg/compiler.h"
static __inline__ unsigned int
inw(unsigned short port)
{
    unsigned short ret;
    __asm__ __volatile__("in%W0 (%1)":"=a"(ret):"d"(port));

    return ret;
}

# 1497 "/usr/include/xorg/compiler.h"
static __inline__ unsigned int
inl(unsigned short port)
{
    unsigned int ret;
    __asm__ __volatile__("in%L0 (%1)":"=a"(ret):"d"(port));

    return ret;
}

# 806 "../../src/radeon.h"
static __inline__ int
RADEONLog2(int val)
{
 int bits;

 __asm volatile("bsrl	%1, %0"
  : "=r" (bits)
  : "c" (val)
 );
 return bits;





}

