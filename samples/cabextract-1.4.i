# 58 "./md5.h"
typedef unsigned int md5_uint32;

# 153 "./md5.h"
static inline md5_uint32
rol(md5_uint32 x, int n)
{
  __asm__("roll %%cl,%0"
   :"=r" (x)
   :"0" (x),"c" (n));
  return x;
}

