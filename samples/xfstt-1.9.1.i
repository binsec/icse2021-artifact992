# 61 "arch.h"
inline int muldiv(int a, int b, int c)
{
 int r;
 // 32Bit * 32Bit / 32Bit with intermediate 64Bit divisor
 __asm__("imull %2\n\tidiv %3, %0" :
  "=a"(r) : "0"(a), "d"(b), "g"(c));
 return r;
}

# 556 "/usr/include/i386-linux-gnu/bits/mathinline.h"
extern __inline void
 __sincos (double __x, double *__sinx, double *__cosx) /* throw () */
{
  register long double __cosr; register long double __sinr; register unsigned int __swtmp; __asm __volatile__ ("fsincos\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jz	1f\n\t" "fldpi\n\t" "fadd	%%st(0)\n\t" "fxch	%%st(1)\n\t" "2: fprem1\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jnz	2b\n\t" "fstp	%%st(1)\n\t" "fsincos\n\t" "1:" : "=t" (__cosr), "=u" (__sinr), "=a" (__swtmp) : "0" (__x)); *__sinx = __sinr; *__cosx = __cosr;
}

# 562 "/usr/include/i386-linux-gnu/bits/mathinline.h"
extern __inline void
 __sincosf (float __x, float *__sinx, float *__cosx) /* throw () */
{
  register long double __cosr; register long double __sinr; register unsigned int __swtmp; __asm __volatile__ ("fsincos\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jz	1f\n\t" "fldpi\n\t" "fadd	%%st(0)\n\t" "fxch	%%st(1)\n\t" "2: fprem1\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jnz	2b\n\t" "fstp	%%st(1)\n\t" "fsincos\n\t" "1:" : "=t" (__cosr), "=u" (__sinr), "=a" (__swtmp) : "0" (__x)); *__sinx = __sinr; *__cosx = __cosr;
}

# 568 "/usr/include/i386-linux-gnu/bits/mathinline.h"
extern __inline void
 __sincosl (long double __x, long double *__sinx, long double *__cosx) /* throw () */
{
  register long double __cosr; register long double __sinr; register unsigned int __swtmp; __asm __volatile__ ("fsincos\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jz	1f\n\t" "fldpi\n\t" "fadd	%%st(0)\n\t" "fxch	%%st(1)\n\t" "2: fprem1\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jnz	2b\n\t" "fstp	%%st(1)\n\t" "fsincos\n\t" "1:" : "=t" (__cosr), "=u" (__sinr), "=a" (__swtmp) : "0" (__x)); *__sinx = __sinr; *__cosx = __cosr;
}

