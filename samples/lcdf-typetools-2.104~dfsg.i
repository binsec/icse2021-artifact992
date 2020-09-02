unsigned int __builtin_bswap32 (unsigned int);

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 52 "md5.c"
static inline uint32_t
rol( uint32_t x, int n)
{
 __asm__("roll %%cl,%0"
  :"=r" (x)
  :"0" (x),"c" (n));
 return x;
}

# 44 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}

# 65 "conftest.cpp"
int
main ()
{
(void) (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (0x0020); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })), (void) __bswap_32 (0x03040020);
  ;
  return 0;
}

