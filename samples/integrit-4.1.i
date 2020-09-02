# 100 "./gnupg/types.h"
typedef unsigned int u32;

# 51 "./gnupg/bithelp.h"
static inline u32
rol( u32 x, int n)
{
 __asm__("roll %%cl,%0"
  :"=r" (x)
  :"0" (x),"c" (n));
 return x;
}

