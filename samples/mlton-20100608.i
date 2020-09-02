# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

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

# 46 "./ml-types.h"
typedef uint16_t Word16_t;

# 21 "basis/Net/Net.c"
Word16_t Net_htons (Word16_t w) {
  Word16_t r = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (w); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  if ((! (0 == 0)))
    printf ("%""x"" = Net_htonl (%""x"")\n", r, w);
  return r;
}

# 28 "basis/Net/Net.c"
Word16_t Net_ntohs (Word16_t w) {
  Word16_t r = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (w); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  if ((! (0 == 0)))
    printf ("%""x"" = Net_ntohl (%""x"")\n", r, w);
  return r;
}

