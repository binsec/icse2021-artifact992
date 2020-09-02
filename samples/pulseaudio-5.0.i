# 195 "/usr/include/i386-linux-gnu/sys/types.h"
typedef int int16_t;

# 196 "/usr/include/i386-linux-gnu/sys/types.h"
typedef int int32_t;

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 59 "pulsecore/sample-util.h"
static inline int32_t pa_mult_s16_volume(int16_t v, int32_t cv) {




    /* Multiplying the 32 bit volume factor with the
     * 16 bit sample might result in an 48 bit value. We
     * want to do without 64 bit integers and hence do
     * the multiplication independently for the HI and
     * LO part of the volume. */

    int32_t hi = cv >> 16;
    int32_t lo = cv & 0xFFFF;
    return ((v * lo) >> 16) + (v * hi);

}

# 91 "pulsecore/svolume_c.c"
static void pa_volume_s16re_c(int16_t *samples, const int32_t *volumes, unsigned channels, unsigned length) {
    unsigned channel;

    length /= sizeof(int16_t);

    for (channel = 0; length; length--) {
        int32_t t = pa_mult_s16_volume(((int16_t) (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((uint16_t) *samples); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))), volumes[channel]);

        t = __extension__ ({ __typeof__(t) _x = (t); __typeof__(-0x8000) _low = (-0x8000); __typeof__(0x7FFF) _high = (0x7FFF); ((__builtin_expect(!!(_x > _high),0)) ? _high : ((__builtin_expect(!!(_x < _low),0)) ? _low : _x)); });
        *samples++ = ((int16_t) (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((uint16_t) (int16_t) t); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));

        if ((__builtin_expect(!!(++channel >= channels),0)))
            channel = 0;
    }
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

