# 357 "ltc/mycrypt.h"
static inline unsigned long ROL(unsigned long word, int i)
{
   __asm__("roll %%cl,%0"
      :"=r" (word)
      :"0" (word),"c" (i));
   return word;
}

# 365 "ltc/mycrypt.h"
static inline unsigned long ROR(unsigned long word, int i)
{
   __asm__("rorl %%cl,%0"
      :"=r" (word)
      :"0" (word),"c" (i));
   return word;
}

