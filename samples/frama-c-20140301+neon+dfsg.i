# 93 "/usr/lib/ocaml/caml/config.h"
typedef long intnat;

# 58 "/usr/lib/ocaml/caml/mlvalues.h"
typedef intnat value;

# 109 "/usr/include/i386-linux-gnu/bits/fenv.h"
extern int __feraiseexcept_renamed (int) __asm__ ("" "feraiseexcept");

# 110 "/usr/include/i386-linux-gnu/bits/fenv.h"
extern __inline int
 feraiseexcept (int __excepts)
{
  if (__builtin_constant_p (__excepts)
      && (__excepts & ~(0x01 | 0x04)) == 0)
    {
      if ((0x01 & __excepts) != 0)
 {
   /* One example of an invalid operation is 0.0 / 0.0.  */
   float __f = 0.0;




   __asm__ __volatile__ ("fdiv %%st, %%st(0); fwait"
    : "=t" (__f) : "0" (__f));

   (void) &__f;
 }
      if ((0x04 & __excepts) != 0)
 {
   float __f = 1.0;
   float __g = 0.0;




   __asm__ __volatile__ ("fdivp %%st, %%st(1); fwait"
    : "=t" (__f) : "0" (__f), "u" (__g) : "st(1)");

   (void) &__f;
 }

      return 0;
    }

  return __feraiseexcept_renamed (__excepts);
}

# 72 "src/buckx/buckx_c.c"
value getperfcount1024(value dum)
{
  unsigned long l,h,acc;
  __asm__ volatile ("rdtsc" : "=a" (l), "=d" (h));;
  acc = (l >> 10) | (h << 22);
  return (acc | 1);
}

# 80 "src/buckx/buckx_c.c"
value getperfcount(value dum)
{
  unsigned long l, h;
  __asm__ volatile ("rdtsc" : "=a" (l), "=d" (h));;
  (void) h;
  return (l | 1);
}

