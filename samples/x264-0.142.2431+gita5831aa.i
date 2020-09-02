# 37 "/usr/include/stdint.h"
typedef short int int16_t;

# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 125 "/usr/include/stdint.h"
typedef int intptr_t;

# 270 "common/osdep.h"
static inline uint32_t endian_fix32( uint32_t x )
{
    __asm__("bswap %0":"+r"(x));
    return x;
}

# 348 "common/osdep.h"
static inline void x264_prefetch( void *p )
{
    __asm__ volatile( "prefetcht0 %0"::"m"(*(uint8_t*)p) );
}

# 152 "common/common.h"
typedef union { uint16_t i; uint8_t c[2]; } x264_union16_t;

# 153 "common/common.h"
typedef union { uint32_t i; uint16_t b[2]; uint8_t c[4]; } x264_union32_t;

# 154 "common/common.h"
typedef union { uint64_t i; uint32_t a[2]; uint16_t b[4]; uint8_t c[8]; } x264_union64_t;

# 45 "common/x86/util.h"
static inline void x264_median_mv_mmx2( int16_t *dst, int16_t *a, int16_t *b, int16_t *c )
{
    __asm__(
        "movd   %1,    %%mm0 \n"
        "movd   %2,    %%mm1 \n"
        "movq   %%mm0, %%mm3 \n"
        "movd   %3,    %%mm2 \n"
        "pmaxsw %%mm1, %%mm0 \n"
        "pminsw %%mm3, %%mm1 \n"
        "pminsw %%mm2, %%mm0 \n"
        "pmaxsw %%mm1, %%mm0 \n"
        "movd   %%mm0, %0    \n"
        :"=m"(*(x264_union32_t*)dst)
        :"m"((((x264_union32_t*)(a))->i)), "m"((((x264_union32_t*)(b))->i)), "m"((((x264_union32_t*)(c))->i))
    );
}

# 63 "common/x86/util.h"
static inline int x264_predictor_difference_mmx2( int16_t (*mvc)[2], intptr_t i_mvc )
{
    int sum;
    static const uint64_t pw_1 = 0x0001000100010001ULL;

    __asm__(
        "pxor    %%mm4, %%mm4 \n"
        "test    $1, %1       \n"
        "jnz 3f               \n"
        "movd    -8(%2,%1,4), %%mm0 \n"
        "movd    -4(%2,%1,4), %%mm3 \n"
        "psubw   %%mm3, %%mm0 \n"
        "jmp 2f               \n"
        "3:                   \n"
        "dec     %1           \n"
        "1:                   \n"
        "movq    -8(%2,%1,4), %%mm0 \n"
        "psubw   -4(%2,%1,4), %%mm0 \n"
        "2:                   \n"
        "sub     $2,    %1    \n"
        "pxor    %%mm2, %%mm2 \n"
        "psubw   %%mm0, %%mm2 \n"
        "pmaxsw  %%mm2, %%mm0 \n"
        "paddusw %%mm0, %%mm4 \n"
        "jg 1b                \n"
        "pmaddwd %4, %%mm4    \n"
        "pshufw $14, %%mm4, %%mm0 \n"
        "paddd   %%mm0, %%mm4 \n"
        "movd    %%mm4, %0    \n"
        :"=r"(sum), "+r"(i_mvc)
        :"r"(mvc), "m"((((x264_union64_t*)(mvc))->i)), "m"(pw_1)
    );
    return sum;
}

# 99 "common/x86/util.h"
static inline uint16_t x264_cabac_mvd_sum_mmx2(uint8_t *mvdleft, uint8_t *mvdtop)
{
    static const uint64_t pb_2 = 0x0202020202020202ULL;
    static const uint64_t pb_32 = 0x2020202020202020ULL;
    static const uint64_t pb_33 = 0x2121212121212121ULL;
    int amvd;
    __asm__(
        "movd         %1, %%mm0 \n"
        "movd         %2, %%mm1 \n"
        "paddusb   %%mm1, %%mm0 \n"
        "pminub       %5, %%mm0 \n"
        "pxor      %%mm2, %%mm2 \n"
        "movq      %%mm0, %%mm1 \n"
        "pcmpgtb      %3, %%mm0 \n"
        "pcmpgtb      %4, %%mm1 \n"
        "psubb     %%mm0, %%mm2 \n"
        "psubb     %%mm1, %%mm2 \n"
        "movd      %%mm2, %0    \n"
        :"=r"(amvd)
        :"m"((((x264_union16_t*)(mvdleft))->i)),"m"((((x264_union16_t*)(mvdtop))->i)),
         "m"(pb_2),"m"(pb_32),"m"(pb_33)
    );
    return amvd;
}

# 125 "common/x86/util.h"
static int inline x264_predictor_clip_mmx2( int16_t (*dst)[2], int16_t (*mvc)[2], int i_mvc, int16_t mv_limit[2][2], uint32_t pmv )
{
    static const uint32_t pd_32 = 0x20;
    intptr_t tmp = (intptr_t)mv_limit, mvc_max = i_mvc, i = 0;

    __asm__(
        "movq       (%2), %%mm5 \n"
        "movd         %6, %%mm3 \n"
        "psllw        $2, %%mm5 \n" // Convert to subpel
        "pshufw $0xEE, %%mm5, %%mm6 \n"
        "dec         %k3        \n"
        "jz 2f                  \n" // if( i_mvc == 1 ) {do the last iteration}
        "punpckldq %%mm3, %%mm3 \n"
        "punpckldq %%mm5, %%mm5 \n"
        "movd         %7, %%mm4 \n"
        "lea   (%0,%3,4), %3    \n"
        "1:                     \n"
        "movq       (%0), %%mm0 \n"
        "add          $8, %0    \n"
        "movq      %%mm3, %%mm1 \n"
        "pxor      %%mm2, %%mm2 \n"
        "pcmpeqd   %%mm0, %%mm1 \n" // mv == pmv
        "pcmpeqd   %%mm0, %%mm2 \n" // mv == 0
        "por       %%mm1, %%mm2 \n" // (mv == pmv || mv == 0) * -1
        "pmovmskb  %%mm2, %k2   \n" // (mv == pmv || mv == 0) * 0xf
        "pmaxsw    %%mm5, %%mm0 \n"
        "pminsw    %%mm6, %%mm0 \n"
        "pand      %%mm4, %%mm2 \n" // (mv0 == pmv || mv0 == 0) * 32
        "psrlq     %%mm2, %%mm0 \n" // drop mv0 if it's skipped
        "movq      %%mm0, (%5,%4,4) \n"
        "and         $24, %k2   \n"
        "add          $2, %4    \n"
        "add          $8, %k2   \n"
        "shr          $4, %k2   \n" // (4-val)>>1
        "sub          %2, %4    \n" // +1 for each valid motion vector
        "cmp          %3, %0    \n"
        "jl 1b                  \n"
        "jg 3f                  \n" // if( i == i_mvc - 1 ) {do the last iteration}

        /* Do the last iteration */
        "2:                     \n"
        "movd       (%0), %%mm0 \n"
        "pxor      %%mm2, %%mm2 \n"
        "pcmpeqd   %%mm0, %%mm3 \n"
        "pcmpeqd   %%mm0, %%mm2 \n"
        "por       %%mm3, %%mm2 \n"
        "pmovmskb  %%mm2, %k2   \n"
        "pmaxsw    %%mm5, %%mm0 \n"
        "pminsw    %%mm6, %%mm0 \n"
        "movd      %%mm0, (%5,%4,4) \n"
        "inc          %4        \n"
        "and          $1, %k2   \n"
        "sub          %2, %4    \n" // output += !(mv == pmv || mv == 0)
        "3:                     \n"
        :"+r"(mvc), "=m"((((x264_union64_t*)(dst))->i)), "+r"(tmp), "+r"(mvc_max), "+r"(i)
        :"r"(dst), "g"(pmv), "m"(pd_32), "m"((((x264_union64_t*)(mvc))->i))
    );
    return i;
}

# 187 "common/x86/util.h"
static int inline x264_predictor_roundclip_mmx2( int16_t (*dst)[2], int16_t (*mvc)[2], int i_mvc, int16_t mv_limit[2][2], uint32_t pmv )
{
    static const uint64_t pw_2 = 0x0002000200020002ULL;
    static const uint32_t pd_32 = 0x20;
    intptr_t tmp = (intptr_t)mv_limit, mvc_max = i_mvc, i = 0;

    __asm__(
        "movq       (%2), %%mm5 \n"
        "movq         %6, %%mm7 \n"
        "movd         %7, %%mm3 \n"
        "pshufw $0xEE, %%mm5, %%mm6 \n"
        "dec         %k3        \n"
        "jz 2f                  \n"
        "punpckldq %%mm3, %%mm3 \n"
        "punpckldq %%mm5, %%mm5 \n"
        "movd         %8, %%mm4 \n"
        "lea   (%0,%3,4), %3    \n"
        "1:                     \n"
        "movq       (%0), %%mm0 \n"
        "add          $8, %0    \n"
        "paddw     %%mm7, %%mm0 \n"
        "psraw        $2, %%mm0 \n"
        "movq      %%mm3, %%mm1 \n"
        "pxor      %%mm2, %%mm2 \n"
        "pcmpeqd   %%mm0, %%mm1 \n"
        "pcmpeqd   %%mm0, %%mm2 \n"
        "por       %%mm1, %%mm2 \n"
        "pmovmskb  %%mm2, %k2   \n"
        "pmaxsw    %%mm5, %%mm0 \n"
        "pminsw    %%mm6, %%mm0 \n"
        "pand      %%mm4, %%mm2 \n"
        "psrlq     %%mm2, %%mm0 \n"
        "movq      %%mm0, (%5,%4,4) \n"
        "and         $24, %k2   \n"
        "add          $2, %4    \n"
        "add          $8, %k2   \n"
        "shr          $4, %k2   \n"
        "sub          %2, %4    \n"
        "cmp          %3, %0    \n"
        "jl 1b                  \n"
        "jg 3f                  \n"

        /* Do the last iteration */
        "2:                     \n"
        "movd       (%0), %%mm0 \n"
        "paddw     %%mm7, %%mm0 \n"
        "psraw        $2, %%mm0 \n"
        "pxor      %%mm2, %%mm2 \n"
        "pcmpeqd   %%mm0, %%mm3 \n"
        "pcmpeqd   %%mm0, %%mm2 \n"
        "por       %%mm3, %%mm2 \n"
        "pmovmskb  %%mm2, %k2   \n"
        "pmaxsw    %%mm5, %%mm0 \n"
        "pminsw    %%mm6, %%mm0 \n"
        "movd      %%mm0, (%5,%4,4) \n"
        "inc          %4        \n"
        "and          $1, %k2   \n"
        "sub          %2, %4    \n"
        "3:                     \n"
        :"+r"(mvc), "=m"((((x264_union64_t*)(dst))->i)), "+r"(tmp), "+r"(mvc_max), "+r"(i)
        :"r"(dst), "m"(pw_2), "g"(pmv), "m"(pd_32), "m"((((x264_union64_t*)(mvc))->i))
    );
    return i;
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

# 36 "/usr/include/stdint.h"
typedef signed char int8_t;

# 176 "./common/common.h"
typedef uint8_t pixel;

# 121 "./common/predict.h"
void x264_predict_16x16_p_c ( pixel *src );

# 55 "common/x86/predict.h"
void x264_predict_16x16_p_core_sse2( pixel *src, int i00, int b, int c );

# 56 "common/x86/predict.h"
void x264_predict_16x16_p_core_avx( pixel *src, int i00, int b, int c );

# 57 "common/x86/predict.h"
void x264_predict_16x16_p_core_avx2( pixel *src, int i00, int b, int c );

# 73 "common/x86/predict.h"
void x264_predict_8x8c_p_core_sse2( pixel *src, int i00, int b, int c );

# 74 "common/x86/predict.h"
void x264_predict_8x8c_p_core_avx ( pixel *src, int i00, int b, int c );

# 75 "common/x86/predict.h"
void x264_predict_8x8c_p_core_avx2( pixel *src, int i00, int b, int c );

# 71 "common/x86/predict-c.c"
static const int8_t pb_12345678[8] = {1,2,3,4,5,6,7,8};

# 72 "common/x86/predict-c.c"
static const int8_t pb_m87654321[8] = {-8,-7,-6,-5,-4,-3,-2,-1};

# 73 "common/x86/predict-c.c"
static const int8_t pb_m32101234[8] = {-3,-2,-1,0,1,2,3,4};

# 175 "common/x86/predict-c.c"
static void x264_predict_16x16_p_ssse3( pixel *src ){ int H, V; __asm__ ( "movq           %1, %%mm1 \n" "movq           %2, %%mm0 \n" "palignr $7,    %3, %%mm1 \n" "pmaddubsw      %4, %%mm0 \n" "pmaddubsw      %5, %%mm1 \n" "paddw       %%mm1, %%mm0 \n" "pshufw $14, %%mm0, %%mm1 \n" "paddw       %%mm1, %%mm0 \n" "pshufw  $1, %%mm0, %%mm1 \n" "paddw       %%mm1, %%mm0 \n" "movd        %%mm0, %0    \n" "movswl        %w0, %0    \n" :"=r"(H) :"m"(src[-32]), "m"(src[-32 +8]), "m"(src[-32 -8]), "m"(*pb_12345678), "m"(*pb_m87654321) ); V = 8 * ( src[15*32 -1] - src[-1*32 -1] ) + 7 * ( src[14*32 -1] - src[ 0*32 -1] ) + 6 * ( src[13*32 -1] - src[ 1*32 -1] ) + 5 * ( src[12*32 -1] - src[ 2*32 -1] ) + 4 * ( src[11*32 -1] - src[ 3*32 -1] ) + 3 * ( src[10*32 -1] - src[ 4*32 -1] ) + 2 * ( src[ 9*32 -1] - src[ 5*32 -1] ) + 1 * ( src[ 8*32 -1] - src[ 6*32 -1] ); int a = 16 * ( src[15*32 -1] + src[15 - 32] ); int b = ( 5 * H + 32 ) >> 6; int c = ( 5 * V + 32 ) >> 6; int i00 = a - b * 7 - c * 7 + 16; /* b*15 + c*15 can overflow: it's easier to just branch away in this rare case
rare case
     * than to try to consider it in the asm. */
# 175 "common/x86/predict-c.c"
 if( 8 > 8 && (i00 > 0x7fff || abs(b) > 1092 || abs(c) > 1092) ) x264_predict_16x16_p_c( src ); else x264_predict_16x16_p_core_sse2( src, i00, b, c );}

# 177 "common/x86/predict-c.c"
static void x264_predict_16x16_p_avx( pixel *src ){ int H, V; __asm__ ( "movq           %1, %%mm1 \n" "movq           %2, %%mm0 \n" "palignr $7,    %3, %%mm1 \n" "pmaddubsw      %4, %%mm0 \n" "pmaddubsw      %5, %%mm1 \n" "paddw       %%mm1, %%mm0 \n" "pshufw $14, %%mm0, %%mm1 \n" "paddw       %%mm1, %%mm0 \n" "pshufw  $1, %%mm0, %%mm1 \n" "paddw       %%mm1, %%mm0 \n" "movd        %%mm0, %0    \n" "movswl        %w0, %0    \n" :"=r"(H) :"m"(src[-32]), "m"(src[-32 +8]), "m"(src[-32 -8]), "m"(*pb_12345678), "m"(*pb_m87654321) ); V = 8 * ( src[15*32 -1] - src[-1*32 -1] ) + 7 * ( src[14*32 -1] - src[ 0*32 -1] ) + 6 * ( src[13*32 -1] - src[ 1*32 -1] ) + 5 * ( src[12*32 -1] - src[ 2*32 -1] ) + 4 * ( src[11*32 -1] - src[ 3*32 -1] ) + 3 * ( src[10*32 -1] - src[ 4*32 -1] ) + 2 * ( src[ 9*32 -1] - src[ 5*32 -1] ) + 1 * ( src[ 8*32 -1] - src[ 6*32 -1] ); int a = 16 * ( src[15*32 -1] + src[15 - 32] ); int b = ( 5 * H + 32 ) >> 6; int c = ( 5 * V + 32 ) >> 6; int i00 = a - b * 7 - c * 7 + 16; /* b*15 + c*15 can overflow: it's easier to just branch away in this rare case
rare case
     * than to try to consider it in the asm. */
# 177 "common/x86/predict-c.c"
 if( 8 > 8 && (i00 > 0x7fff || abs(b) > 1092 || abs(c) > 1092) ) x264_predict_16x16_p_c( src ); else x264_predict_16x16_p_core_avx( src, i00, b, c );}

# 179 "common/x86/predict-c.c"
static void x264_predict_16x16_p_avx2( pixel *src ){ int H, V; __asm__ ( "movq           %1, %%mm1 \n" "movq           %2, %%mm0 \n" "palignr $7,    %3, %%mm1 \n" "pmaddubsw      %4, %%mm0 \n" "pmaddubsw      %5, %%mm1 \n" "paddw       %%mm1, %%mm0 \n" "pshufw $14, %%mm0, %%mm1 \n" "paddw       %%mm1, %%mm0 \n" "pshufw  $1, %%mm0, %%mm1 \n" "paddw       %%mm1, %%mm0 \n" "movd        %%mm0, %0    \n" "movswl        %w0, %0    \n" :"=r"(H) :"m"(src[-32]), "m"(src[-32 +8]), "m"(src[-32 -8]), "m"(*pb_12345678), "m"(*pb_m87654321) ); V = 8 * ( src[15*32 -1] - src[-1*32 -1] ) + 7 * ( src[14*32 -1] - src[ 0*32 -1] ) + 6 * ( src[13*32 -1] - src[ 1*32 -1] ) + 5 * ( src[12*32 -1] - src[ 2*32 -1] ) + 4 * ( src[11*32 -1] - src[ 3*32 -1] ) + 3 * ( src[10*32 -1] - src[ 4*32 -1] ) + 2 * ( src[ 9*32 -1] - src[ 5*32 -1] ) + 1 * ( src[ 8*32 -1] - src[ 6*32 -1] ); int a = 16 * ( src[15*32 -1] + src[15 - 32] ); int b = ( 5 * H + 32 ) >> 6; int c = ( 5 * V + 32 ) >> 6; int i00 = a - b * 7 - c * 7 + 16; /* b*15 + c*15 can overflow: it's easier to just branch away in this rare case
rare case
     * than to try to consider it in the asm. */
# 179 "common/x86/predict-c.c"
 if( 8 > 8 && (i00 > 0x7fff || abs(b) > 1092 || abs(c) > 1092) ) x264_predict_16x16_p_c( src ); else x264_predict_16x16_p_core_avx2( src, i00, b, c );}

# 304 "common/x86/predict-c.c"
static void x264_predict_8x8c_p_ssse3( pixel *src ){ int H, V; __asm__ ( "movq           %1, %%mm0 \n" "pmaddubsw      %2, %%mm0 \n" "pshufw $14, %%mm0, %%mm1 \n" "paddw       %%mm1, %%mm0 \n" "pshufw  $1, %%mm0, %%mm1 \n" "paddw       %%mm1, %%mm0 \n" "movd        %%mm0, %0    \n" "movswl        %w0, %0    \n" :"=r"(H) :"m"(src[-32]), "m"(*pb_m32101234) ); V = 1 * ( src[4*32 -1] - src[ 2*32 -1] ) + 2 * ( src[5*32 -1] - src[ 1*32 -1] ) + 3 * ( src[6*32 -1] - src[ 0*32 -1] ) + 4 * ( src[7*32 -1] - src[-1*32 -1] ); H += -4 * src[-1*32 -1]; int a = 16 * ( src[7*32 -1] + src[7 - 32] ); int b = ( 17 * H + 16 ) >> 5; int c = ( 17 * V + 16 ) >> 5; int i00 = a -3*b -3*c + 16; x264_predict_8x8c_p_core_sse2( src, i00, b, c );}

# 307 "common/x86/predict-c.c"
static void x264_predict_8x8c_p_avx( pixel *src ){ int H, V; __asm__ ( "movq           %1, %%mm0 \n" "pmaddubsw      %2, %%mm0 \n" "pshufw $14, %%mm0, %%mm1 \n" "paddw       %%mm1, %%mm0 \n" "pshufw  $1, %%mm0, %%mm1 \n" "paddw       %%mm1, %%mm0 \n" "movd        %%mm0, %0    \n" "movswl        %w0, %0    \n" :"=r"(H) :"m"(src[-32]), "m"(*pb_m32101234) ); V = 1 * ( src[4*32 -1] - src[ 2*32 -1] ) + 2 * ( src[5*32 -1] - src[ 1*32 -1] ) + 3 * ( src[6*32 -1] - src[ 0*32 -1] ) + 4 * ( src[7*32 -1] - src[-1*32 -1] ); H += -4 * src[-1*32 -1]; int a = 16 * ( src[7*32 -1] + src[7 - 32] ); int b = ( 17 * H + 16 ) >> 5; int c = ( 17 * V + 16 ) >> 5; int i00 = a -3*b -3*c + 16; x264_predict_8x8c_p_core_avx( src, i00, b, c );}

# 308 "common/x86/predict-c.c"
static void x264_predict_8x8c_p_avx2( pixel *src ){ int H, V; __asm__ ( "movq           %1, %%mm0 \n" "pmaddubsw      %2, %%mm0 \n" "pshufw $14, %%mm0, %%mm1 \n" "paddw       %%mm1, %%mm0 \n" "pshufw  $1, %%mm0, %%mm1 \n" "paddw       %%mm1, %%mm0 \n" "movd        %%mm0, %0    \n" "movswl        %w0, %0    \n" :"=r"(H) :"m"(src[-32]), "m"(*pb_m32101234) ); V = 1 * ( src[4*32 -1] - src[ 2*32 -1] ) + 2 * ( src[5*32 -1] - src[ 1*32 -1] ) + 3 * ( src[6*32 -1] - src[ 0*32 -1] ) + 4 * ( src[7*32 -1] - src[-1*32 -1] ); H += -4 * src[-1*32 -1]; int a = 16 * ( src[7*32 -1] + src[7 - 32] ); int b = ( 17 * H + 16 ) >> 5; int c = ( 17 * V + 16 ) >> 5; int i00 = a -3*b -3*c + 16; x264_predict_8x8c_p_core_avx2( src, i00, b, c );}
