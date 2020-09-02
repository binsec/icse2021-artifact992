# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 101 "/usr/include/SDL/SDL_stdinc.h"
typedef uint16_t Uint16;

# 103 "/usr/include/SDL/SDL_stdinc.h"
typedef uint32_t Uint32;

# 108 "/usr/include/SDL/SDL_stdinc.h"
typedef uint64_t Uint64;

# 75 "/usr/include/SDL/SDL_endian.h"
static __inline__ Uint16 SDL_Swap16(Uint16 x)
{
 __asm__("xchgb %b0,%h0" : "=q" (x) : "0" (x));
 return x;
}

# 108 "/usr/include/SDL/SDL_endian.h"
static __inline__ Uint32 SDL_Swap32(Uint32 x)
{
 __asm__("bswap %0" : "=r" (x) : "0" (x));
 return x;
}

# 144 "/usr/include/SDL/SDL_endian.h"
static __inline__ Uint64 SDL_Swap64(Uint64 x)
{
 union {
  struct { Uint32 a,b; } s;
  Uint64 u;
 } v;
 v.u = x;
 __asm__("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
         : "=r" (v.s.a), "=r" (v.s.b)
         : "0" (v.s.a), "1" (v.s.b));
 return v.u;
}

# 556 "/usr/include/i386-linux-gnu/bits/mathinline.h"
extern __inline void
 __sincos (double __x, double *__sinx, double *__cosx)
{
  register long double __cosr; register long double __sinr; register unsigned int __swtmp; __asm __volatile__ ("fsincos\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jz	1f\n\t" "fldpi\n\t" "fadd	%%st(0)\n\t" "fxch	%%st(1)\n\t" "2: fprem1\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jnz	2b\n\t" "fstp	%%st(1)\n\t" "fsincos\n\t" "1:" : "=t" (__cosr), "=u" (__sinr), "=a" (__swtmp) : "0" (__x)); *__sinx = __sinr; *__cosx = __cosr;
}

# 562 "/usr/include/i386-linux-gnu/bits/mathinline.h"
extern __inline void
 __sincosf (float __x, float *__sinx, float *__cosx)
{
  register long double __cosr; register long double __sinr; register unsigned int __swtmp; __asm __volatile__ ("fsincos\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jz	1f\n\t" "fldpi\n\t" "fadd	%%st(0)\n\t" "fxch	%%st(1)\n\t" "2: fprem1\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jnz	2b\n\t" "fstp	%%st(1)\n\t" "fsincos\n\t" "1:" : "=t" (__cosr), "=u" (__sinr), "=a" (__swtmp) : "0" (__x)); *__sinx = __sinr; *__cosx = __cosr;
}

# 568 "/usr/include/i386-linux-gnu/bits/mathinline.h"
extern __inline void
 __sincosl (long double __x, long double *__sinx, long double *__cosx)
{
  register long double __cosr; register long double __sinr; register unsigned int __swtmp; __asm __volatile__ ("fsincos\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jz	1f\n\t" "fldpi\n\t" "fadd	%%st(0)\n\t" "fxch	%%st(1)\n\t" "2: fprem1\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jnz	2b\n\t" "fstp	%%st(1)\n\t" "fsincos\n\t" "1:" : "=t" (__cosr), "=u" (__sinr), "=a" (__swtmp) : "0" (__x)); *__sinx = __sinr; *__cosx = __cosr;
}

