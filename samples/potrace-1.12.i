# 27 "bitops.h"
static inline unsigned int lobit(unsigned int x) {
  unsigned int res;
  asm ("bsf	%1,%0\n\t"
       "jnz	0f\n\t"
       "movl	$32,%0\n"
       "0:"
       : "=r" (res)
       : "r" (x)
       : "cc");
  return res;
}

# 39 "bitops.h"
static inline unsigned int hibit(unsigned int x) {
  unsigned int res;

  asm ("bsr	%1,%0\n\t"
       "jnz	0f\n\t"
       "movl	$-1,%0\n"
       "0:"
       : "=r" (res)
       : "r" (x)
       : "cc");
  return res+1;
}

# 28 "conftest.c"
int
main ()
{
int x;
  asm("bsf %1,%0\njnz 0f\nmovl 2,%0\n0:":"=r"(x):"r"(x));
  return x; /* need this so that -O2 does not optimize the asm away */

  ;
  return 0;
}

