# 97 "standard.h"
typedef unsigned int unsigned32;

# 61 "sha1.c"
static inline unsigned32
rol(int n, unsigned32 x)
{
 __asm__("roll %%cl,%0"
  :"=r" (x)
  :"0" (x),"c" (n));
 return x;
}

