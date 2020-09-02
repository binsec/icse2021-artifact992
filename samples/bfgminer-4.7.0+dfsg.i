unsigned int __builtin_bswap32 (unsigned int);
unsigned long long __builtin_bswap64 (unsigned long long);

# 47 "/usr/include/i386-linux-gnu/bits/types.h"
typedef unsigned long long int __uint64_t;

# 44 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}

# 108 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline __uint64_t
__bswap_64 (__uint64_t __bsx)
{
  return __builtin_bswap64 (__bsx);
}

# 153 "conftest.c"
int
main ()
{

    (void) (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (0); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    (void) __bswap_32 (0);
    (void) __bswap_64 (0);

  ;
  return 0;
}

