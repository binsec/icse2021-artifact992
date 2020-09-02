# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 31 "./libavutil/x86/timer.h"
static inline uint64_t read_time(void)
{
    uint32_t a, d;
    __asm__ volatile(



                     "rdtsc  \n\t"
                     : "=a" (a), "=d" (d));
    return ((uint64_t)d << 32) + a;
}

# 80 "./libavutil/cpu.h"
int av_get_cpu_flags(void);

# 37 "./libavutil/x86/emms.h"
static inline void emms_c(void)
{
/* Some inlined functions may also use mmx instructions regardless of
 * runtime cpuflags. With that in mind, we unconditionally empty the
 * mmx state if the target cpu chosen at configure time supports it.
 */

    if(av_get_cpu_flags() & 0x0001 /*|< standard MMX*/)

        __asm__ volatile ("emms" ::: "memory");
}

# 36 "/usr/include/stdint.h"
typedef signed char int8_t;

# 38 "/usr/include/stdint.h"
typedef int int32_t;

# 43 "/usr/include/stdint.h"
typedef long long int int64_t;

# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

# 35 "./libavcodec/x86/mathops.h"
static inline int MULL(int a, int b, unsigned shift)
{
    int rt, dummy;
    __asm__ (
        "imull %3               \n\t"
        "shrdl %4, %%edx, %%eax \n\t"
        :"=a"(rt), "=d"(dummy)
        :"a"(a), "rm"(b), "ci"((uint8_t)shift)
    );
    return rt;
}

# 48 "./libavcodec/x86/mathops.h"
static inline int MULH(int a, int b)
{
    int rt, dummy;
    __asm__ (
        "imull %3"
        :"=d"(rt), "=a"(dummy)
        :"a"(a), "rm"(b)
    );
    return rt;
}

# 60 "./libavcodec/x86/mathops.h"
static inline int64_t MUL64(int a, int b)
{
    int64_t rt;
    __asm__ (
        "imull %2"
        :"=A"(rt)
        :"a"(a), "rm"(b)
    );
    return rt;
}

# 76 "./libavcodec/x86/mathops.h"
static inline int mid_pred(int a, int b, int c)
{
    int i=b;
    __asm__ (
        "cmp    %2, %1 \n\t"
        "cmovg  %1, %0 \n\t"
        "cmovg  %2, %1 \n\t"
        "cmp    %3, %1 \n\t"
        "cmovl  %3, %1 \n\t"
        "cmp    %1, %0 \n\t"
        "cmovg  %1, %0 \n\t"
        :"+&r"(i), "+&r"(a)
        :"r"(b), "r"(c)
    );
    return i;
}

# 115 "./libavcodec/x86/mathops.h"
static inline int32_t NEG_SSR32( int32_t a, int8_t s){
    __asm__ ("sarl %1, %0\n\t"
         : "+r" (a)
         : "ic" ((uint8_t)(-s))
    );
    return a;
}

# 124 "./libavcodec/x86/mathops.h"
static inline uint32_t NEG_USR32(uint32_t a, int8_t s){
    __asm__ ("shrl %1, %0\n\t"
         : "+r" (a)
         : "ic" ((uint8_t)(-s))
    );
    return a;
}

# 108 "./libavutil/x86/intmath.h"
static inline double av_clipd_sse2(double a, double amin, double amax)
{



    __asm__ ("minsd %2, %0 \n\t"
             "maxsd %1, %0 \n\t"
             : "+&x"(a) : "xm"(amin), "xm"(amax));
    return a;
}

# 124 "./libavutil/x86/intmath.h"
static inline float av_clipf_sse(float a, float amin, float amax)
{



    __asm__ ("minss %2, %0 \n\t"
             "maxss %1, %0 \n\t"
             : "+&x"(a) : "xm"(amin), "xm"(amax));
    return a;
}

# 67 "./libavutil/x86/intreadwrite.h"
static inline void AV_COPY128(void *d, const void *s)
{
    struct v {uint64_t v[2];};

    __asm__("movaps   %1, %%xmm0  \n\t"
            "movaps   %%xmm0, %0  \n\t"
            : "=m"(*(struct v*)d)
            : "m" (*(const struct v*)s)
            : "xmm0");
}

# 69 "./libavutil/x86/intreadwrite.h"
struct v {uint64_t v[2];};

# 83 "./libavutil/x86/intreadwrite.h"
static inline void AV_ZERO128(void *d)
{
    struct v {uint64_t v[2];};

    __asm__("pxor %%xmm0, %%xmm0  \n\t"
            "movdqa   %%xmm0, %0  \n\t"
            : "=m"(*(struct v*)d)
            :: "xmm0");
}

# 125 "/usr/include/stdint.h"
typedef int intptr_t;

# 61 "./libavutil/x86/asm.h"
typedef int32_t x86_reg;

# 44 "libavcodec/x86/lossless_videoencdsp_init.c"
static void sub_median_pred_mmxext(uint8_t *dst, const uint8_t *src1,
                                   const uint8_t *src2, intptr_t w,
                                   int *left, int *left_top)
{
    x86_reg i = 0;
    uint8_t l, lt;

    __asm__ volatile (
        "movq  (%1, %0), %%mm0          \n\t" // LT
        "psllq $8, %%mm0                \n\t"
        "1:                             \n\t"
        "movq  (%1, %0), %%mm1          \n\t" // T
        "movq  -1(%2, %0), %%mm2        \n\t" // L
        "movq  (%2, %0), %%mm3          \n\t" // X
        "movq %%mm2, %%mm4              \n\t" // L
        "psubb %%mm0, %%mm2             \n\t"
        "paddb %%mm1, %%mm2             \n\t" // L + T - LT
        "movq %%mm4, %%mm5              \n\t" // L
        "pmaxub %%mm1, %%mm4            \n\t" // max(T, L)
        "pminub %%mm5, %%mm1            \n\t" // min(T, L)
        "pminub %%mm2, %%mm4            \n\t"
        "pmaxub %%mm1, %%mm4            \n\t"
        "psubb %%mm4, %%mm3             \n\t" // dst - pred
        "movq %%mm3, (%3, %0)           \n\t"
        "add $8, %0                     \n\t"
        "movq -1(%1, %0), %%mm0         \n\t" // LT
        "cmp %4, %0                     \n\t"
        " jb 1b                         \n\t"
        : "+r" (i)
        : "r" (src1), "r" (src2), "r" (dst), "r" ((x86_reg) w));

    l = *left;
    lt = *left_top;

    dst[0] = src2[0] - mid_pred(l, src1[0], (l + src1[0] - lt) & 0xFF);

    *left_top = src1[w - 1];
    *left = src2[w - 1];
}

# 147 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef int ptrdiff_t;

# 29 "libavcodec/x86/constants.h"
/* extern */ const uint64_t ff_pw_2 = {0x0002000200020002ULL};
/* extern */ const uint64_t ff_pw_4 = {0x0004000400040004ULL};
/* extern */ const uint64_t ff_pw_5 = {0x0005000500050005ULL};

# 33 "libavcodec/x86/rnd_template.c"
static void put_no_rnd_pixels8_xy2_mmx(uint8_t *block, const uint8_t *pixels,
                                  ptrdiff_t line_size, int h)
{
    __asm__ volatile ("pxor %%""mm7"", %%""mm7" ::);
    __asm__ volatile ( "pcmpeqd %%" "mm6" ", %%" "mm6" " \n\t" "psrlw $15, %%" "mm6" ::); // =2 for rnd  and  =1 for no_rnd version
    __asm__ volatile(
        "movq   (%1), %%mm0             \n\t"
        "movq   1(%1), %%mm4            \n\t"
        "movq   %%mm0, %%mm1            \n\t"
        "movq   %%mm4, %%mm5            \n\t"
        "punpcklbw %%mm7, %%mm0         \n\t"
        "punpcklbw %%mm7, %%mm4         \n\t"
        "punpckhbw %%mm7, %%mm1         \n\t"
        "punpckhbw %%mm7, %%mm5         \n\t"
        "paddusw %%mm0, %%mm4           \n\t"
        "paddusw %%mm1, %%mm5           \n\t"
        "xor    %%""eax"", %%""eax"" \n\t"
        "add    %3, %1                  \n\t"
        ".p2align 3                     \n\t"
        "1:                             \n\t"
        "movq   (%1, %%""eax""), %%mm0  \n\t"
        "movq   1(%1, %%""eax""), %%mm2 \n\t"
        "movq   %%mm0, %%mm1            \n\t"
        "movq   %%mm2, %%mm3            \n\t"
        "punpcklbw %%mm7, %%mm0         \n\t"
        "punpcklbw %%mm7, %%mm2         \n\t"
        "punpckhbw %%mm7, %%mm1         \n\t"
        "punpckhbw %%mm7, %%mm3         \n\t"
        "paddusw %%mm2, %%mm0           \n\t"
        "paddusw %%mm3, %%mm1           \n\t"
        "paddusw %%mm6, %%mm4           \n\t"
        "paddusw %%mm6, %%mm5           \n\t"
        "paddusw %%mm0, %%mm4           \n\t"
        "paddusw %%mm1, %%mm5           \n\t"
        "psrlw  $2, %%mm4               \n\t"
        "psrlw  $2, %%mm5               \n\t"
        "packuswb  %%mm5, %%mm4         \n\t"
        "movq   %%mm4, (%2, %%""eax"")  \n\t"
        "add    %3, %%""eax""           \n\t"

        "movq   (%1, %%""eax""), %%mm2  \n\t" // 0 <-> 2   1 <-> 3
        "movq   1(%1, %%""eax""), %%mm4 \n\t"
        "movq   %%mm2, %%mm3            \n\t"
        "movq   %%mm4, %%mm5            \n\t"
        "punpcklbw %%mm7, %%mm2         \n\t"
        "punpcklbw %%mm7, %%mm4         \n\t"
        "punpckhbw %%mm7, %%mm3         \n\t"
        "punpckhbw %%mm7, %%mm5         \n\t"
        "paddusw %%mm2, %%mm4           \n\t"
        "paddusw %%mm3, %%mm5           \n\t"
        "paddusw %%mm6, %%mm0           \n\t"
        "paddusw %%mm6, %%mm1           \n\t"
        "paddusw %%mm4, %%mm0           \n\t"
        "paddusw %%mm5, %%mm1           \n\t"
        "psrlw  $2, %%mm0               \n\t"
        "psrlw  $2, %%mm1               \n\t"
        "packuswb  %%mm1, %%mm0         \n\t"
        "movq   %%mm0, (%2, %%""eax"")  \n\t"
        "add    %3, %%""eax""        \n\t"

        "subl   $2, %0                  \n\t"
        "jnz    1b                      \n\t"
        :"+g"(h), "+S"(pixels)
        :"D"(block), "r"((x86_reg)line_size)
        :"eax", "memory");
}

# 102 "libavcodec/x86/rnd_template.c"
static void avg_no_rnd_pixels8_xy2_mmx(uint8_t *block, const uint8_t *pixels,
                                  ptrdiff_t line_size, int h)
{
    __asm__ volatile ("pxor %%""mm7"", %%""mm7" ::);
    __asm__ volatile ( "pcmpeqd %%" "mm6" ", %%" "mm6" " \n\t" "psrlw $15, %%" "mm6" ::); // =2 for rnd  and  =1 for no_rnd version
    __asm__ volatile(
        "movq   (%1), %%mm0             \n\t"
        "movq   1(%1), %%mm4            \n\t"
        "movq   %%mm0, %%mm1            \n\t"
        "movq   %%mm4, %%mm5            \n\t"
        "punpcklbw %%mm7, %%mm0         \n\t"
        "punpcklbw %%mm7, %%mm4         \n\t"
        "punpckhbw %%mm7, %%mm1         \n\t"
        "punpckhbw %%mm7, %%mm5         \n\t"
        "paddusw %%mm0, %%mm4           \n\t"
        "paddusw %%mm1, %%mm5           \n\t"
        "xor    %%""eax"", %%""eax"" \n\t"
        "add    %3, %1                  \n\t"
        ".p2align 3                     \n\t"
        "1:                             \n\t"
        "movq   (%1, %%""eax""), %%mm0  \n\t"
        "movq   1(%1, %%""eax""), %%mm2 \n\t"
        "movq   %%mm0, %%mm1            \n\t"
        "movq   %%mm2, %%mm3            \n\t"
        "punpcklbw %%mm7, %%mm0         \n\t"
        "punpcklbw %%mm7, %%mm2         \n\t"
        "punpckhbw %%mm7, %%mm1         \n\t"
        "punpckhbw %%mm7, %%mm3         \n\t"
        "paddusw %%mm2, %%mm0           \n\t"
        "paddusw %%mm3, %%mm1           \n\t"
        "paddusw %%mm6, %%mm4           \n\t"
        "paddusw %%mm6, %%mm5           \n\t"
        "paddusw %%mm0, %%mm4           \n\t"
        "paddusw %%mm1, %%mm5           \n\t"
        "psrlw  $2, %%mm4               \n\t"
        "psrlw  $2, %%mm5               \n\t"
                "movq   (%2, %%""eax""), %%mm3  \n\t"
        "packuswb  %%mm5, %%mm4         \n\t"
                "pcmpeqd %%mm2, %%mm2   \n\t"
                "paddb %%mm2, %%mm2     \n\t"
                "movq   ""%%mm3"", ""%%mm5""            \n\t" "por    ""%%mm4"", ""%%mm5""            \n\t" "pxor   ""%%mm3"", ""%%mm4""            \n\t" "pand  ""%%mm2"", ""%%mm4""            \n\t" "psrlq       $1, ""%%mm4""            \n\t" "psubb  ""%%mm4"", ""%%mm5""            \n\t"
                "movq   %%mm5, (%2, %%""eax"")  \n\t"
        "add    %3, %%""eax""        \n\t"

        "movq   (%1, %%""eax""), %%mm2  \n\t" // 0 <-> 2   1 <-> 3
        "movq   1(%1, %%""eax""), %%mm4 \n\t"
        "movq   %%mm2, %%mm3            \n\t"
        "movq   %%mm4, %%mm5            \n\t"
        "punpcklbw %%mm7, %%mm2         \n\t"
        "punpcklbw %%mm7, %%mm4         \n\t"
        "punpckhbw %%mm7, %%mm3         \n\t"
        "punpckhbw %%mm7, %%mm5         \n\t"
        "paddusw %%mm2, %%mm4           \n\t"
        "paddusw %%mm3, %%mm5           \n\t"
        "paddusw %%mm6, %%mm0           \n\t"
        "paddusw %%mm6, %%mm1           \n\t"
        "paddusw %%mm4, %%mm0           \n\t"
        "paddusw %%mm5, %%mm1           \n\t"
        "psrlw  $2, %%mm0               \n\t"
        "psrlw  $2, %%mm1               \n\t"
                "movq   (%2, %%""eax""), %%mm3  \n\t"
        "packuswb  %%mm1, %%mm0         \n\t"
                "pcmpeqd %%mm2, %%mm2   \n\t"
                "paddb %%mm2, %%mm2     \n\t"
                "movq   ""%%mm3"", ""%%mm1""            \n\t" "por    ""%%mm0"", ""%%mm1""            \n\t" "pxor   ""%%mm3"", ""%%mm0""            \n\t" "pand  ""%%mm2"", ""%%mm0""            \n\t" "psrlq       $1, ""%%mm0""            \n\t" "psubb  ""%%mm0"", ""%%mm1""            \n\t"
                "movq   %%mm1, (%2, %%""eax"")  \n\t"
        "add    %3, %%""eax""           \n\t"

        "subl   $2, %0                  \n\t"
        "jnz    1b                      \n\t"
        :"+g"(h), "+S"(pixels)
        :"D"(block), "r"((x86_reg)line_size)
        :"eax", "memory");
}

# 31 "libavcodec/x86/hpeldsp_rnd_template.c"
static void put_no_rnd_pixels8_x2_mmx(uint8_t *block, const uint8_t *pixels, ptrdiff_t line_size, int h)
{
    __asm__ volatile ( "pcmpeqd %%""mm6"", %%""mm6""   \n\t" "paddb   %%""mm6"", %%""mm6""   \n\t" ::);
    __asm__ volatile(
        "lea    (%3, %3), %%""eax""  \n\t"
        ".p2align 3                     \n\t"
        "1:                             \n\t"
        "movq   (%1), %%mm0             \n\t"
        "movq   1(%1), %%mm1            \n\t"
        "movq   (%1, %3), %%mm2         \n\t"
        "movq   1(%1, %3), %%mm3        \n\t"
        "movq  ""%%mm0"", ""%%mm4""             \n\t" "movq  ""%%mm2"", ""%%mm5""             \n\t" "pand  ""%%mm1"", ""%%mm4""             \n\t" "pand  ""%%mm3"", ""%%mm5""             \n\t" "pxor  ""%%mm0"", ""%%mm1""             \n\t" "pxor  ""%%mm2"", ""%%mm3""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm3""             \n\t" "paddb ""%%mm1"", ""%%mm4""             \n\t" "paddb ""%%mm3"", ""%%mm5""             \n\t"
        "movq   %%mm4, (%2)             \n\t"
        "movq   %%mm5, (%2, %3)         \n\t"
        "add    %%""eax"", %1        \n\t"
        "add    %%""eax"", %2        \n\t"
        "movq   (%1), %%mm0             \n\t"
        "movq   1(%1), %%mm1            \n\t"
        "movq   (%1, %3), %%mm2         \n\t"
        "movq   1(%1, %3), %%mm3        \n\t"
        "movq  ""%%mm0"", ""%%mm4""             \n\t" "movq  ""%%mm2"", ""%%mm5""             \n\t" "pand  ""%%mm1"", ""%%mm4""             \n\t" "pand  ""%%mm3"", ""%%mm5""             \n\t" "pxor  ""%%mm0"", ""%%mm1""             \n\t" "pxor  ""%%mm2"", ""%%mm3""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm3""             \n\t" "paddb ""%%mm1"", ""%%mm4""             \n\t" "paddb ""%%mm3"", ""%%mm5""             \n\t"
        "movq   %%mm4, (%2)             \n\t"
        "movq   %%mm5, (%2, %3)         \n\t"
        "add    %%""eax"", %1        \n\t"
        "add    %%""eax"", %2        \n\t"
        "subl   $4, %0                  \n\t"
        "jnz    1b                      \n\t"
        :"+g"(h), "+S"(pixels), "+D"(block)
        :"r"((x86_reg)line_size)
        :"eax", "memory");
}

# 63 "libavcodec/x86/hpeldsp_rnd_template.c"
static void put_no_rnd_pixels16_x2_mmx(uint8_t *block, const uint8_t *pixels, ptrdiff_t line_size, int h)
{
    __asm__ volatile ( "pcmpeqd %%""mm6"", %%""mm6""   \n\t" "paddb   %%""mm6"", %%""mm6""   \n\t" ::);
    __asm__ volatile(
        "lea    (%3, %3), %%""eax""  \n\t"
        ".p2align 3                     \n\t"
        "1:                             \n\t"
        "movq   (%1), %%mm0             \n\t"
        "movq   1(%1), %%mm1            \n\t"
        "movq   (%1, %3), %%mm2         \n\t"
        "movq   1(%1, %3), %%mm3        \n\t"
        "movq  ""%%mm0"", ""%%mm4""             \n\t" "movq  ""%%mm2"", ""%%mm5""             \n\t" "pand  ""%%mm1"", ""%%mm4""             \n\t" "pand  ""%%mm3"", ""%%mm5""             \n\t" "pxor  ""%%mm0"", ""%%mm1""             \n\t" "pxor  ""%%mm2"", ""%%mm3""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm3""             \n\t" "paddb ""%%mm1"", ""%%mm4""             \n\t" "paddb ""%%mm3"", ""%%mm5""             \n\t"
        "movq   %%mm4, (%2)             \n\t"
        "movq   %%mm5, (%2, %3)         \n\t"
        "movq   8(%1), %%mm0            \n\t"
        "movq   9(%1), %%mm1            \n\t"
        "movq   8(%1, %3), %%mm2        \n\t"
        "movq   9(%1, %3), %%mm3        \n\t"
        "movq  ""%%mm0"", ""%%mm4""             \n\t" "movq  ""%%mm2"", ""%%mm5""             \n\t" "pand  ""%%mm1"", ""%%mm4""             \n\t" "pand  ""%%mm3"", ""%%mm5""             \n\t" "pxor  ""%%mm0"", ""%%mm1""             \n\t" "pxor  ""%%mm2"", ""%%mm3""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm3""             \n\t" "paddb ""%%mm1"", ""%%mm4""             \n\t" "paddb ""%%mm3"", ""%%mm5""             \n\t"
        "movq   %%mm4, 8(%2)            \n\t"
        "movq   %%mm5, 8(%2, %3)        \n\t"
        "add    %%""eax"", %1        \n\t"
        "add    %%""eax"", %2        \n\t"
        "movq   (%1), %%mm0             \n\t"
        "movq   1(%1), %%mm1            \n\t"
        "movq   (%1, %3), %%mm2         \n\t"
        "movq   1(%1, %3), %%mm3        \n\t"
        "movq  ""%%mm0"", ""%%mm4""             \n\t" "movq  ""%%mm2"", ""%%mm5""             \n\t" "pand  ""%%mm1"", ""%%mm4""             \n\t" "pand  ""%%mm3"", ""%%mm5""             \n\t" "pxor  ""%%mm0"", ""%%mm1""             \n\t" "pxor  ""%%mm2"", ""%%mm3""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm3""             \n\t" "paddb ""%%mm1"", ""%%mm4""             \n\t" "paddb ""%%mm3"", ""%%mm5""             \n\t"
        "movq   %%mm4, (%2)             \n\t"
        "movq   %%mm5, (%2, %3)         \n\t"
        "movq   8(%1), %%mm0            \n\t"
        "movq   9(%1), %%mm1            \n\t"
        "movq   8(%1, %3), %%mm2        \n\t"
        "movq   9(%1, %3), %%mm3        \n\t"
        "movq  ""%%mm0"", ""%%mm4""             \n\t" "movq  ""%%mm2"", ""%%mm5""             \n\t" "pand  ""%%mm1"", ""%%mm4""             \n\t" "pand  ""%%mm3"", ""%%mm5""             \n\t" "pxor  ""%%mm0"", ""%%mm1""             \n\t" "pxor  ""%%mm2"", ""%%mm3""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm3""             \n\t" "paddb ""%%mm1"", ""%%mm4""             \n\t" "paddb ""%%mm3"", ""%%mm5""             \n\t"
        "movq   %%mm4, 8(%2)            \n\t"
        "movq   %%mm5, 8(%2, %3)        \n\t"
        "add    %%""eax"", %1        \n\t"
        "add    %%""eax"", %2        \n\t"
        "subl   $4, %0                  \n\t"
        "jnz    1b                      \n\t"
        :"+g"(h), "+S"(pixels), "+D"(block)
        :"r"((x86_reg)line_size)
        :"eax", "memory");
}

# 109 "libavcodec/x86/hpeldsp_rnd_template.c"
static void put_no_rnd_pixels8_y2_mmx(uint8_t *block, const uint8_t *pixels, ptrdiff_t line_size, int h)
{
    __asm__ volatile ( "pcmpeqd %%""mm6"", %%""mm6""   \n\t" "paddb   %%""mm6"", %%""mm6""   \n\t" ::);
    __asm__ volatile(
        "lea (%3, %3), %%""eax""     \n\t"
        "movq (%1), %%mm0               \n\t"
        ".p2align 3                     \n\t"
        "1:                             \n\t"
        "movq   (%1, %3), %%mm1         \n\t"
        "movq   (%1, %%""eax""),%%mm2\n\t"
        "movq  ""%%mm1"", ""%%mm4""             \n\t" "movq  ""%%mm2"", ""%%mm5""             \n\t" "pand  ""%%mm0"", ""%%mm4""             \n\t" "pand  ""%%mm1"", ""%%mm5""             \n\t" "pxor  ""%%mm1"", ""%%mm0""             \n\t" "pxor  ""%%mm2"", ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm0""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm0""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "paddb ""%%mm0"", ""%%mm4""             \n\t" "paddb ""%%mm1"", ""%%mm5""             \n\t"
        "movq   %%mm4, (%2)             \n\t"
        "movq   %%mm5, (%2, %3)         \n\t"
        "add    %%""eax"", %1        \n\t"
        "add    %%""eax"", %2        \n\t"
        "movq   (%1, %3), %%mm1         \n\t"
        "movq   (%1, %%""eax""),%%mm0\n\t"
        "movq  ""%%mm1"", ""%%mm4""             \n\t" "movq  ""%%mm0"", ""%%mm5""             \n\t" "pand  ""%%mm2"", ""%%mm4""             \n\t" "pand  ""%%mm1"", ""%%mm5""             \n\t" "pxor  ""%%mm1"", ""%%mm2""             \n\t" "pxor  ""%%mm0"", ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm2""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm2""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "paddb ""%%mm2"", ""%%mm4""             \n\t" "paddb ""%%mm1"", ""%%mm5""             \n\t"
        "movq   %%mm4, (%2)             \n\t"
        "movq   %%mm5, (%2, %3)         \n\t"
        "add    %%""eax"", %1        \n\t"
        "add    %%""eax"", %2        \n\t"
        "subl   $4, %0                  \n\t"
        "jnz    1b                      \n\t"
        :"+g"(h), "+S"(pixels), "+D"(block)
        :"r"((x86_reg)line_size)
        :"eax", "memory");
}

# 138 "libavcodec/x86/hpeldsp_rnd_template.c"
static void avg_no_rnd_pixels16_x2_mmx(uint8_t *block, const uint8_t *pixels, ptrdiff_t line_size, int h)
{
    __asm__ volatile ( "pcmpeqd %%""mm6"", %%""mm6""   \n\t" "paddb   %%""mm6"", %%""mm6""   \n\t" ::);
        __asm__ volatile(
            ".p2align 3                 \n\t"
            "1:                         \n\t"
            "movq  (%1), %%mm0          \n\t"
            "movq  1(%1), %%mm1         \n\t"
            "movq  (%2), %%mm3          \n\t"
            "movq   ""%%mm0"", ""%%mm2""            \n\t" "pand   ""%%mm1"", ""%%mm2""            \n\t" "pxor   ""%%mm0"", ""%%mm1""            \n\t" "pand  ""%%mm6"", ""%%mm1""            \n\t" "psrlq       $1, ""%%mm1""            \n\t" "paddb  ""%%mm1"", ""%%mm2""            \n\t"
            "movq   ""%%mm3"", ""%%mm0""            \n\t" "por    ""%%mm2"", ""%%mm0""            \n\t" "pxor   ""%%mm3"", ""%%mm2""            \n\t" "pand  ""%%mm6"", ""%%mm2""            \n\t" "psrlq       $1, ""%%mm2""            \n\t" "psubb  ""%%mm2"", ""%%mm0""            \n\t"
            "movq  %%mm0, (%2)          \n\t"
            "movq  8(%1), %%mm0         \n\t"
            "movq  9(%1), %%mm1         \n\t"
            "movq  8(%2), %%mm3         \n\t"
            "movq   ""%%mm0"", ""%%mm2""            \n\t" "pand   ""%%mm1"", ""%%mm2""            \n\t" "pxor   ""%%mm0"", ""%%mm1""            \n\t" "pand  ""%%mm6"", ""%%mm1""            \n\t" "psrlq       $1, ""%%mm1""            \n\t" "paddb  ""%%mm1"", ""%%mm2""            \n\t"
            "movq   ""%%mm3"", ""%%mm0""            \n\t" "por    ""%%mm2"", ""%%mm0""            \n\t" "pxor   ""%%mm3"", ""%%mm2""            \n\t" "pand  ""%%mm6"", ""%%mm2""            \n\t" "psrlq       $1, ""%%mm2""            \n\t" "psubb  ""%%mm2"", ""%%mm0""            \n\t"
            "movq  %%mm0, 8(%2)         \n\t"
            "add    %3, %1              \n\t"
            "add    %3, %2              \n\t"
            "subl   $1, %0              \n\t"
            "jnz    1b                  \n\t"
            :"+g"(h), "+S"(pixels), "+D"(block)
            :"r"((x86_reg)line_size)
            :"memory");
}

# 165 "libavcodec/x86/hpeldsp_rnd_template.c"
static void avg_no_rnd_pixels8_y2_mmx(uint8_t *block, const uint8_t *pixels, ptrdiff_t line_size, int h)
{
    __asm__ volatile ( "pcmpeqd %%""mm6"", %%""mm6""   \n\t" "paddb   %%""mm6"", %%""mm6""   \n\t" ::);
    __asm__ volatile(
        "lea    (%3, %3), %%""eax""  \n\t"
        "movq   (%1), %%mm0             \n\t"
        ".p2align 3                     \n\t"
        "1:                             \n\t"
        "movq   (%1, %3), %%mm1         \n\t"
        "movq   (%1, %%""eax""), %%mm2 \n\t"
        "movq  ""%%mm1"", ""%%mm4""             \n\t" "movq  ""%%mm2"", ""%%mm5""             \n\t" "pand  ""%%mm0"", ""%%mm4""             \n\t" "pand  ""%%mm1"", ""%%mm5""             \n\t" "pxor  ""%%mm1"", ""%%mm0""             \n\t" "pxor  ""%%mm2"", ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm0""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm0""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "paddb ""%%mm0"", ""%%mm4""             \n\t" "paddb ""%%mm1"", ""%%mm5""             \n\t"
        "movq   (%2), %%mm3             \n\t"
        "movq   ""%%mm3"", ""%%mm0""            \n\t" "por    ""%%mm4"", ""%%mm0""            \n\t" "pxor   ""%%mm3"", ""%%mm4""            \n\t" "pand  ""%%mm6"", ""%%mm4""            \n\t" "psrlq       $1, ""%%mm4""            \n\t" "psubb  ""%%mm4"", ""%%mm0""            \n\t"
        "movq   (%2, %3), %%mm3         \n\t"
        "movq   ""%%mm3"", ""%%mm1""            \n\t" "por    ""%%mm5"", ""%%mm1""            \n\t" "pxor   ""%%mm3"", ""%%mm5""            \n\t" "pand  ""%%mm6"", ""%%mm5""            \n\t" "psrlq       $1, ""%%mm5""            \n\t" "psubb  ""%%mm5"", ""%%mm1""            \n\t"
        "movq   %%mm0, (%2)             \n\t"
        "movq   %%mm1, (%2, %3)         \n\t"
        "add    %%""eax"", %1        \n\t"
        "add    %%""eax"", %2        \n\t"

        "movq   (%1, %3), %%mm1         \n\t"
        "movq   (%1, %%""eax""), %%mm0 \n\t"
        "movq  ""%%mm1"", ""%%mm4""             \n\t" "movq  ""%%mm0"", ""%%mm5""             \n\t" "pand  ""%%mm2"", ""%%mm4""             \n\t" "pand  ""%%mm1"", ""%%mm5""             \n\t" "pxor  ""%%mm1"", ""%%mm2""             \n\t" "pxor  ""%%mm0"", ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm2""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm2""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "paddb ""%%mm2"", ""%%mm4""             \n\t" "paddb ""%%mm1"", ""%%mm5""             \n\t"
        "movq   (%2), %%mm3             \n\t"
        "movq   ""%%mm3"", ""%%mm2""            \n\t" "por    ""%%mm4"", ""%%mm2""            \n\t" "pxor   ""%%mm3"", ""%%mm4""            \n\t" "pand  ""%%mm6"", ""%%mm4""            \n\t" "psrlq       $1, ""%%mm4""            \n\t" "psubb  ""%%mm4"", ""%%mm2""            \n\t"
        "movq   (%2, %3), %%mm3         \n\t"
        "movq   ""%%mm3"", ""%%mm1""            \n\t" "por    ""%%mm5"", ""%%mm1""            \n\t" "pxor   ""%%mm3"", ""%%mm5""            \n\t" "pand  ""%%mm6"", ""%%mm5""            \n\t" "psrlq       $1, ""%%mm5""            \n\t" "psubb  ""%%mm5"", ""%%mm1""            \n\t"
        "movq   %%mm2, (%2)             \n\t"
        "movq   %%mm1, (%2, %3)         \n\t"
        "add    %%""eax"", %1        \n\t"
        "add    %%""eax"", %2        \n\t"

        "subl   $4, %0                  \n\t"
        "jnz    1b                      \n\t"
        :"+g"(h), "+S"(pixels), "+D"(block)
        :"r"((x86_reg)line_size)
        :"eax", "memory");
}

# 31 "libavcodec/x86/hpeldsp_rnd_template.c"
static void put_pixels8_x2_mmx(uint8_t *block, const uint8_t *pixels, ptrdiff_t line_size, int h)
{
    __asm__ volatile ( "pcmpeqd %%""mm6"", %%""mm6""   \n\t" "paddb   %%""mm6"", %%""mm6""   \n\t" ::);
    __asm__ volatile(
        "lea    (%3, %3), %%""eax""  \n\t"
        ".p2align 3                     \n\t"
        "1:                             \n\t"
        "movq   (%1), %%mm0             \n\t"
        "movq   1(%1), %%mm1            \n\t"
        "movq   (%1, %3), %%mm2         \n\t"
        "movq   1(%1, %3), %%mm3        \n\t"
        "movq  ""%%mm0"", ""%%mm4""             \n\t" "movq  ""%%mm2"", ""%%mm5""             \n\t" "por   ""%%mm1"", ""%%mm4""             \n\t" "por   ""%%mm3"", ""%%mm5""             \n\t" "pxor  ""%%mm0"", ""%%mm1""             \n\t" "pxor  ""%%mm2"", ""%%mm3""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "psubb ""%%mm1"", ""%%mm4""             \n\t" "psubb ""%%mm3"", ""%%mm5""             \n\t"
        "movq   %%mm4, (%2)             \n\t"
        "movq   %%mm5, (%2, %3)         \n\t"
        "add    %%""eax"", %1        \n\t"
        "add    %%""eax"", %2        \n\t"
        "movq   (%1), %%mm0             \n\t"
        "movq   1(%1), %%mm1            \n\t"
        "movq   (%1, %3), %%mm2         \n\t"
        "movq   1(%1, %3), %%mm3        \n\t"
        "movq  ""%%mm0"", ""%%mm4""             \n\t" "movq  ""%%mm2"", ""%%mm5""             \n\t" "por   ""%%mm1"", ""%%mm4""             \n\t" "por   ""%%mm3"", ""%%mm5""             \n\t" "pxor  ""%%mm0"", ""%%mm1""             \n\t" "pxor  ""%%mm2"", ""%%mm3""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "psubb ""%%mm1"", ""%%mm4""             \n\t" "psubb ""%%mm3"", ""%%mm5""             \n\t"
        "movq   %%mm4, (%2)             \n\t"
        "movq   %%mm5, (%2, %3)         \n\t"
        "add    %%""eax"", %1        \n\t"
        "add    %%""eax"", %2        \n\t"
        "subl   $4, %0                  \n\t"
        "jnz    1b                      \n\t"
        :"+g"(h), "+S"(pixels), "+D"(block)
        :"r"((x86_reg)line_size)
        :"eax", "memory");
}

# 63 "libavcodec/x86/hpeldsp_rnd_template.c"
static void put_pixels16_x2_mmx(uint8_t *block, const uint8_t *pixels, ptrdiff_t line_size, int h)
{
    __asm__ volatile ( "pcmpeqd %%""mm6"", %%""mm6""   \n\t" "paddb   %%""mm6"", %%""mm6""   \n\t" ::);
    __asm__ volatile(
        "lea    (%3, %3), %%""eax""  \n\t"
        ".p2align 3                     \n\t"
        "1:                             \n\t"
        "movq   (%1), %%mm0             \n\t"
        "movq   1(%1), %%mm1            \n\t"
        "movq   (%1, %3), %%mm2         \n\t"
        "movq   1(%1, %3), %%mm3        \n\t"
        "movq  ""%%mm0"", ""%%mm4""             \n\t" "movq  ""%%mm2"", ""%%mm5""             \n\t" "por   ""%%mm1"", ""%%mm4""             \n\t" "por   ""%%mm3"", ""%%mm5""             \n\t" "pxor  ""%%mm0"", ""%%mm1""             \n\t" "pxor  ""%%mm2"", ""%%mm3""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "psubb ""%%mm1"", ""%%mm4""             \n\t" "psubb ""%%mm3"", ""%%mm5""             \n\t"
        "movq   %%mm4, (%2)             \n\t"
        "movq   %%mm5, (%2, %3)         \n\t"
        "movq   8(%1), %%mm0            \n\t"
        "movq   9(%1), %%mm1            \n\t"
        "movq   8(%1, %3), %%mm2        \n\t"
        "movq   9(%1, %3), %%mm3        \n\t"
        "movq  ""%%mm0"", ""%%mm4""             \n\t" "movq  ""%%mm2"", ""%%mm5""             \n\t" "por   ""%%mm1"", ""%%mm4""             \n\t" "por   ""%%mm3"", ""%%mm5""             \n\t" "pxor  ""%%mm0"", ""%%mm1""             \n\t" "pxor  ""%%mm2"", ""%%mm3""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "psubb ""%%mm1"", ""%%mm4""             \n\t" "psubb ""%%mm3"", ""%%mm5""             \n\t"
        "movq   %%mm4, 8(%2)            \n\t"
        "movq   %%mm5, 8(%2, %3)        \n\t"
        "add    %%""eax"", %1        \n\t"
        "add    %%""eax"", %2        \n\t"
        "movq   (%1), %%mm0             \n\t"
        "movq   1(%1), %%mm1            \n\t"
        "movq   (%1, %3), %%mm2         \n\t"
        "movq   1(%1, %3), %%mm3        \n\t"
        "movq  ""%%mm0"", ""%%mm4""             \n\t" "movq  ""%%mm2"", ""%%mm5""             \n\t" "por   ""%%mm1"", ""%%mm4""             \n\t" "por   ""%%mm3"", ""%%mm5""             \n\t" "pxor  ""%%mm0"", ""%%mm1""             \n\t" "pxor  ""%%mm2"", ""%%mm3""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "psubb ""%%mm1"", ""%%mm4""             \n\t" "psubb ""%%mm3"", ""%%mm5""             \n\t"
        "movq   %%mm4, (%2)             \n\t"
        "movq   %%mm5, (%2, %3)         \n\t"
        "movq   8(%1), %%mm0            \n\t"
        "movq   9(%1), %%mm1            \n\t"
        "movq   8(%1, %3), %%mm2        \n\t"
        "movq   9(%1, %3), %%mm3        \n\t"
        "movq  ""%%mm0"", ""%%mm4""             \n\t" "movq  ""%%mm2"", ""%%mm5""             \n\t" "por   ""%%mm1"", ""%%mm4""             \n\t" "por   ""%%mm3"", ""%%mm5""             \n\t" "pxor  ""%%mm0"", ""%%mm1""             \n\t" "pxor  ""%%mm2"", ""%%mm3""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm3""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "psubb ""%%mm1"", ""%%mm4""             \n\t" "psubb ""%%mm3"", ""%%mm5""             \n\t"
        "movq   %%mm4, 8(%2)            \n\t"
        "movq   %%mm5, 8(%2, %3)        \n\t"
        "add    %%""eax"", %1        \n\t"
        "add    %%""eax"", %2        \n\t"
        "subl   $4, %0                  \n\t"
        "jnz    1b                      \n\t"
        :"+g"(h), "+S"(pixels), "+D"(block)
        :"r"((x86_reg)line_size)
        :"eax", "memory");
}

# 109 "libavcodec/x86/hpeldsp_rnd_template.c"
static void put_pixels8_y2_mmx(uint8_t *block, const uint8_t *pixels, ptrdiff_t line_size, int h)
{
    __asm__ volatile ( "pcmpeqd %%""mm6"", %%""mm6""   \n\t" "paddb   %%""mm6"", %%""mm6""   \n\t" ::);
    __asm__ volatile(
        "lea (%3, %3), %%""eax""     \n\t"
        "movq (%1), %%mm0               \n\t"
        ".p2align 3                     \n\t"
        "1:                             \n\t"
        "movq   (%1, %3), %%mm1         \n\t"
        "movq   (%1, %%""eax""),%%mm2\n\t"
        "movq  ""%%mm1"", ""%%mm4""             \n\t" "movq  ""%%mm2"", ""%%mm5""             \n\t" "por   ""%%mm0"", ""%%mm4""             \n\t" "por   ""%%mm1"", ""%%mm5""             \n\t" "pxor  ""%%mm1"", ""%%mm0""             \n\t" "pxor  ""%%mm2"", ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm0""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm0""             \n\t" "psubb ""%%mm0"", ""%%mm4""             \n\t" "psubb ""%%mm1"", ""%%mm5""             \n\t"
        "movq   %%mm4, (%2)             \n\t"
        "movq   %%mm5, (%2, %3)         \n\t"
        "add    %%""eax"", %1        \n\t"
        "add    %%""eax"", %2        \n\t"
        "movq   (%1, %3), %%mm1         \n\t"
        "movq   (%1, %%""eax""),%%mm0\n\t"
        "movq  ""%%mm1"", ""%%mm4""             \n\t" "movq  ""%%mm0"", ""%%mm5""             \n\t" "por   ""%%mm2"", ""%%mm4""             \n\t" "por   ""%%mm1"", ""%%mm5""             \n\t" "pxor  ""%%mm1"", ""%%mm2""             \n\t" "pxor  ""%%mm0"", ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm2""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm2""             \n\t" "psubb ""%%mm2"", ""%%mm4""             \n\t" "psubb ""%%mm1"", ""%%mm5""             \n\t"
        "movq   %%mm4, (%2)             \n\t"
        "movq   %%mm5, (%2, %3)         \n\t"
        "add    %%""eax"", %1        \n\t"
        "add    %%""eax"", %2        \n\t"
        "subl   $4, %0                  \n\t"
        "jnz    1b                      \n\t"
        :"+g"(h), "+S"(pixels), "+D"(block)
        :"r"((x86_reg)line_size)
        :"eax", "memory");
}

# 138 "libavcodec/x86/hpeldsp_rnd_template.c"
static void avg_pixels16_x2_mmx(uint8_t *block, const uint8_t *pixels, ptrdiff_t line_size, int h)
{
    __asm__ volatile ( "pcmpeqd %%""mm6"", %%""mm6""   \n\t" "paddb   %%""mm6"", %%""mm6""   \n\t" ::);
        __asm__ volatile(
            ".p2align 3                 \n\t"
            "1:                         \n\t"
            "movq  (%1), %%mm0          \n\t"
            "movq  1(%1), %%mm1         \n\t"
            "movq  (%2), %%mm3          \n\t"
            "movq   ""%%mm0"", ""%%mm2""            \n\t" "por    ""%%mm1"", ""%%mm2""            \n\t" "pxor   ""%%mm0"", ""%%mm1""            \n\t" "pand  ""%%mm6"", ""%%mm1""            \n\t" "psrlq       $1, ""%%mm1""            \n\t" "psubb  ""%%mm1"", ""%%mm2""            \n\t"
            "movq   ""%%mm3"", ""%%mm0""            \n\t" "por    ""%%mm2"", ""%%mm0""            \n\t" "pxor   ""%%mm3"", ""%%mm2""            \n\t" "pand  ""%%mm6"", ""%%mm2""            \n\t" "psrlq       $1, ""%%mm2""            \n\t" "psubb  ""%%mm2"", ""%%mm0""            \n\t"
            "movq  %%mm0, (%2)          \n\t"
            "movq  8(%1), %%mm0         \n\t"
            "movq  9(%1), %%mm1         \n\t"
            "movq  8(%2), %%mm3         \n\t"
            "movq   ""%%mm0"", ""%%mm2""            \n\t" "por    ""%%mm1"", ""%%mm2""            \n\t" "pxor   ""%%mm0"", ""%%mm1""            \n\t" "pand  ""%%mm6"", ""%%mm1""            \n\t" "psrlq       $1, ""%%mm1""            \n\t" "psubb  ""%%mm1"", ""%%mm2""            \n\t"
            "movq   ""%%mm3"", ""%%mm0""            \n\t" "por    ""%%mm2"", ""%%mm0""            \n\t" "pxor   ""%%mm3"", ""%%mm2""            \n\t" "pand  ""%%mm6"", ""%%mm2""            \n\t" "psrlq       $1, ""%%mm2""            \n\t" "psubb  ""%%mm2"", ""%%mm0""            \n\t"
            "movq  %%mm0, 8(%2)         \n\t"
            "add    %3, %1              \n\t"
            "add    %3, %2              \n\t"
            "subl   $1, %0              \n\t"
            "jnz    1b                  \n\t"
            :"+g"(h), "+S"(pixels), "+D"(block)
            :"r"((x86_reg)line_size)
            :"memory");
}

# 165 "libavcodec/x86/hpeldsp_rnd_template.c"
static void avg_pixels8_y2_mmx(uint8_t *block, const uint8_t *pixels, ptrdiff_t line_size, int h)
{
    __asm__ volatile ( "pcmpeqd %%""mm6"", %%""mm6""   \n\t" "paddb   %%""mm6"", %%""mm6""   \n\t" ::);
    __asm__ volatile(
        "lea    (%3, %3), %%""eax""  \n\t"
        "movq   (%1), %%mm0             \n\t"
        ".p2align 3                     \n\t"
        "1:                             \n\t"
        "movq   (%1, %3), %%mm1         \n\t"
        "movq   (%1, %%""eax""), %%mm2 \n\t"
        "movq  ""%%mm1"", ""%%mm4""             \n\t" "movq  ""%%mm2"", ""%%mm5""             \n\t" "por   ""%%mm0"", ""%%mm4""             \n\t" "por   ""%%mm1"", ""%%mm5""             \n\t" "pxor  ""%%mm1"", ""%%mm0""             \n\t" "pxor  ""%%mm2"", ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm0""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm0""             \n\t" "psubb ""%%mm0"", ""%%mm4""             \n\t" "psubb ""%%mm1"", ""%%mm5""             \n\t"
        "movq   (%2), %%mm3             \n\t"
        "movq   ""%%mm3"", ""%%mm0""            \n\t" "por    ""%%mm4"", ""%%mm0""            \n\t" "pxor   ""%%mm3"", ""%%mm4""            \n\t" "pand  ""%%mm6"", ""%%mm4""            \n\t" "psrlq       $1, ""%%mm4""            \n\t" "psubb  ""%%mm4"", ""%%mm0""            \n\t"
        "movq   (%2, %3), %%mm3         \n\t"
        "movq   ""%%mm3"", ""%%mm1""            \n\t" "por    ""%%mm5"", ""%%mm1""            \n\t" "pxor   ""%%mm3"", ""%%mm5""            \n\t" "pand  ""%%mm6"", ""%%mm5""            \n\t" "psrlq       $1, ""%%mm5""            \n\t" "psubb  ""%%mm5"", ""%%mm1""            \n\t"
        "movq   %%mm0, (%2)             \n\t"
        "movq   %%mm1, (%2, %3)         \n\t"
        "add    %%""eax"", %1        \n\t"
        "add    %%""eax"", %2        \n\t"

        "movq   (%1, %3), %%mm1         \n\t"
        "movq   (%1, %%""eax""), %%mm0 \n\t"
        "movq  ""%%mm1"", ""%%mm4""             \n\t" "movq  ""%%mm0"", ""%%mm5""             \n\t" "por   ""%%mm2"", ""%%mm4""             \n\t" "por   ""%%mm1"", ""%%mm5""             \n\t" "pxor  ""%%mm1"", ""%%mm2""             \n\t" "pxor  ""%%mm0"", ""%%mm1""             \n\t" "pand    %%mm6, ""%%mm2""             \n\t" "pand    %%mm6, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm1""             \n\t" "psrlq      $1, ""%%mm2""             \n\t" "psubb ""%%mm2"", ""%%mm4""             \n\t" "psubb ""%%mm1"", ""%%mm5""             \n\t"
        "movq   (%2), %%mm3             \n\t"
        "movq   ""%%mm3"", ""%%mm2""            \n\t" "por    ""%%mm4"", ""%%mm2""            \n\t" "pxor   ""%%mm3"", ""%%mm4""            \n\t" "pand  ""%%mm6"", ""%%mm4""            \n\t" "psrlq       $1, ""%%mm4""            \n\t" "psubb  ""%%mm4"", ""%%mm2""            \n\t"
        "movq   (%2, %3), %%mm3         \n\t"
        "movq   ""%%mm3"", ""%%mm1""            \n\t" "por    ""%%mm5"", ""%%mm1""            \n\t" "pxor   ""%%mm3"", ""%%mm5""            \n\t" "pand  ""%%mm6"", ""%%mm5""            \n\t" "psrlq       $1, ""%%mm5""            \n\t" "psubb  ""%%mm5"", ""%%mm1""            \n\t"
        "movq   %%mm2, (%2)             \n\t"
        "movq   %%mm1, (%2, %3)         \n\t"
        "add    %%""eax"", %1        \n\t"
        "add    %%""eax"", %2        \n\t"

        "subl   $4, %0                  \n\t"
        "jnz    1b                      \n\t"
        :"+g"(h), "+S"(pixels), "+D"(block)
        :"r"((x86_reg)line_size)
        :"eax", "memory");
}

# 33 "libavcodec/x86/rnd_template.c"
void ff_put_pixels8_xy2_mmx(uint8_t *block, const uint8_t *pixels,
                                  ptrdiff_t line_size, int h)
{
    __asm__ volatile ("pxor %%""mm7"", %%""mm7" ::);
    __asm__ volatile ("movq %0, %%""mm6"" \n\t" :: "m"(ff_pw_2)); // =2 for rnd  and  =1 for no_rnd version
    __asm__ volatile(
        "movq   (%1), %%mm0             \n\t"
        "movq   1(%1), %%mm4            \n\t"
        "movq   %%mm0, %%mm1            \n\t"
        "movq   %%mm4, %%mm5            \n\t"
        "punpcklbw %%mm7, %%mm0         \n\t"
        "punpcklbw %%mm7, %%mm4         \n\t"
        "punpckhbw %%mm7, %%mm1         \n\t"
        "punpckhbw %%mm7, %%mm5         \n\t"
        "paddusw %%mm0, %%mm4           \n\t"
        "paddusw %%mm1, %%mm5           \n\t"
        "xor    %%""eax"", %%""eax"" \n\t"
        "add    %3, %1                  \n\t"
        ".p2align 3                     \n\t"
        "1:                             \n\t"
        "movq   (%1, %%""eax""), %%mm0  \n\t"
        "movq   1(%1, %%""eax""), %%mm2 \n\t"
        "movq   %%mm0, %%mm1            \n\t"
        "movq   %%mm2, %%mm3            \n\t"
        "punpcklbw %%mm7, %%mm0         \n\t"
        "punpcklbw %%mm7, %%mm2         \n\t"
        "punpckhbw %%mm7, %%mm1         \n\t"
        "punpckhbw %%mm7, %%mm3         \n\t"
        "paddusw %%mm2, %%mm0           \n\t"
        "paddusw %%mm3, %%mm1           \n\t"
        "paddusw %%mm6, %%mm4           \n\t"
        "paddusw %%mm6, %%mm5           \n\t"
        "paddusw %%mm0, %%mm4           \n\t"
        "paddusw %%mm1, %%mm5           \n\t"
        "psrlw  $2, %%mm4               \n\t"
        "psrlw  $2, %%mm5               \n\t"
        "packuswb  %%mm5, %%mm4         \n\t"
        "movq   %%mm4, (%2, %%""eax"")  \n\t"
        "add    %3, %%""eax""           \n\t"

        "movq   (%1, %%""eax""), %%mm2  \n\t" // 0 <-> 2   1 <-> 3
        "movq   1(%1, %%""eax""), %%mm4 \n\t"
        "movq   %%mm2, %%mm3            \n\t"
        "movq   %%mm4, %%mm5            \n\t"
        "punpcklbw %%mm7, %%mm2         \n\t"
        "punpcklbw %%mm7, %%mm4         \n\t"
        "punpckhbw %%mm7, %%mm3         \n\t"
        "punpckhbw %%mm7, %%mm5         \n\t"
        "paddusw %%mm2, %%mm4           \n\t"
        "paddusw %%mm3, %%mm5           \n\t"
        "paddusw %%mm6, %%mm0           \n\t"
        "paddusw %%mm6, %%mm1           \n\t"
        "paddusw %%mm4, %%mm0           \n\t"
        "paddusw %%mm5, %%mm1           \n\t"
        "psrlw  $2, %%mm0               \n\t"
        "psrlw  $2, %%mm1               \n\t"
        "packuswb  %%mm1, %%mm0         \n\t"
        "movq   %%mm0, (%2, %%""eax"")  \n\t"
        "add    %3, %%""eax""        \n\t"

        "subl   $2, %0                  \n\t"
        "jnz    1b                      \n\t"
        :"+g"(h), "+S"(pixels)
        :"D"(block), "r"((x86_reg)line_size)
        :"eax", "memory");
}

# 102 "libavcodec/x86/rnd_template.c"
void ff_avg_pixels8_xy2_mmx(uint8_t *block, const uint8_t *pixels,
                                  ptrdiff_t line_size, int h)
{
    __asm__ volatile ("pxor %%""mm7"", %%""mm7" ::);
    __asm__ volatile ("movq %0, %%""mm6"" \n\t" :: "m"(ff_pw_2)); // =2 for rnd  and  =1 for no_rnd version
    __asm__ volatile(
        "movq   (%1), %%mm0             \n\t"
        "movq   1(%1), %%mm4            \n\t"
        "movq   %%mm0, %%mm1            \n\t"
        "movq   %%mm4, %%mm5            \n\t"
        "punpcklbw %%mm7, %%mm0         \n\t"
        "punpcklbw %%mm7, %%mm4         \n\t"
        "punpckhbw %%mm7, %%mm1         \n\t"
        "punpckhbw %%mm7, %%mm5         \n\t"
        "paddusw %%mm0, %%mm4           \n\t"
        "paddusw %%mm1, %%mm5           \n\t"
        "xor    %%""eax"", %%""eax"" \n\t"
        "add    %3, %1                  \n\t"
        ".p2align 3                     \n\t"
        "1:                             \n\t"
        "movq   (%1, %%""eax""), %%mm0  \n\t"
        "movq   1(%1, %%""eax""), %%mm2 \n\t"
        "movq   %%mm0, %%mm1            \n\t"
        "movq   %%mm2, %%mm3            \n\t"
        "punpcklbw %%mm7, %%mm0         \n\t"
        "punpcklbw %%mm7, %%mm2         \n\t"
        "punpckhbw %%mm7, %%mm1         \n\t"
        "punpckhbw %%mm7, %%mm3         \n\t"
        "paddusw %%mm2, %%mm0           \n\t"
        "paddusw %%mm3, %%mm1           \n\t"
        "paddusw %%mm6, %%mm4           \n\t"
        "paddusw %%mm6, %%mm5           \n\t"
        "paddusw %%mm0, %%mm4           \n\t"
        "paddusw %%mm1, %%mm5           \n\t"
        "psrlw  $2, %%mm4               \n\t"
        "psrlw  $2, %%mm5               \n\t"
                "movq   (%2, %%""eax""), %%mm3  \n\t"
        "packuswb  %%mm5, %%mm4         \n\t"
                "pcmpeqd %%mm2, %%mm2   \n\t"
                "paddb %%mm2, %%mm2     \n\t"
                "movq   ""%%mm3"", ""%%mm5""            \n\t" "por    ""%%mm4"", ""%%mm5""            \n\t" "pxor   ""%%mm3"", ""%%mm4""            \n\t" "pand  ""%%mm2"", ""%%mm4""            \n\t" "psrlq       $1, ""%%mm4""            \n\t" "psubb  ""%%mm4"", ""%%mm5""            \n\t"
                "movq   %%mm5, (%2, %%""eax"")  \n\t"
        "add    %3, %%""eax""        \n\t"

        "movq   (%1, %%""eax""), %%mm2  \n\t" // 0 <-> 2   1 <-> 3
        "movq   1(%1, %%""eax""), %%mm4 \n\t"
        "movq   %%mm2, %%mm3            \n\t"
        "movq   %%mm4, %%mm5            \n\t"
        "punpcklbw %%mm7, %%mm2         \n\t"
        "punpcklbw %%mm7, %%mm4         \n\t"
        "punpckhbw %%mm7, %%mm3         \n\t"
        "punpckhbw %%mm7, %%mm5         \n\t"
        "paddusw %%mm2, %%mm4           \n\t"
        "paddusw %%mm3, %%mm5           \n\t"
        "paddusw %%mm6, %%mm0           \n\t"
        "paddusw %%mm6, %%mm1           \n\t"
        "paddusw %%mm4, %%mm0           \n\t"
        "paddusw %%mm5, %%mm1           \n\t"
        "psrlw  $2, %%mm0               \n\t"
        "psrlw  $2, %%mm1               \n\t"
                "movq   (%2, %%""eax""), %%mm3  \n\t"
        "packuswb  %%mm1, %%mm0         \n\t"
                "pcmpeqd %%mm2, %%mm2   \n\t"
                "paddb %%mm2, %%mm2     \n\t"
                "movq   ""%%mm3"", ""%%mm1""            \n\t" "por    ""%%mm0"", ""%%mm1""            \n\t" "pxor   ""%%mm3"", ""%%mm0""            \n\t" "pand  ""%%mm2"", ""%%mm0""            \n\t" "psrlq       $1, ""%%mm0""            \n\t" "psubb  ""%%mm0"", ""%%mm1""            \n\t"
                "movq   %%mm1, (%2, %%""eax"")  \n\t"
        "add    %3, %%""eax""           \n\t"

        "subl   $2, %0                  \n\t"
        "jnz    1b                      \n\t"
        :"+g"(h), "+S"(pixels)
        :"D"(block), "r"((x86_reg)line_size)
        :"eax", "memory");
}

# 46 "/usr/local/share/frama-c/libc/stdint.h"
typedef unsigned short uint16_t;

# 58 "./libavutil/bswap.h"
static inline uint16_t av_bswap16(uint16_t x)
{
    x= (x>>8) | (x<<8);
    return x;
}

# 222 "./libavutil/intreadwrite.h"
union unaligned_16 { uint16_t l; };

# 94 "libavcodec/bytestream.h"
static inline unsigned int bytestream_get_be16(const uint8_t **b) { (*b) += 2; return av_bswap16((((const union unaligned_16 *) (*b - 2))->l)); }

# 85 "libavcodec/vp56.h"
typedef struct VP56RangeCoder {
    int high;
    int bits;

    const uint8_t *buffer;
    const uint8_t *end;
    unsigned int code_word;
} VP56RangeCoder;

# 227 "libavcodec/vp56.h"
extern const uint8_t ff_vp56_norm_shift[256];

# 230 "libavcodec/vp56.h"
static inline unsigned int vp56_rac_renorm(VP56RangeCoder *c)
{
    int shift = ff_vp56_norm_shift[c->high];
    int bits = c->bits;
    unsigned int code_word = c->code_word;

    c->high <<= shift;
    code_word <<= shift;
    bits += shift;
    if(bits >= 0 && c->buffer < c->end) {
        code_word |= bytestream_get_be16(&c->buffer) << bits;
        bits -= 16;
    }
    c->bits = bits;
    return code_word;
}

# 29 "libavcodec/x86/vp56_arith.h"
static inline int vp56_rac_get_prob(VP56RangeCoder *c, uint8_t prob)
{
    unsigned int code_word = vp56_rac_renorm(c);
    unsigned int low = 1 + (((c->high - 1) * prob) >> 8);
    unsigned int low_shift = low << 16;
    int bit = 0;
    c->code_word = code_word;

    __asm__(
        "subl  %4, %1      \n\t"
        "subl  %3, %2      \n\t"
        "setae %b0         \n\t"
        "cmovb %4, %1      \n\t"
        "cmovb %5, %2      \n\t"
        : "+q"(bit), "+&r"(c->high), "+&r"(c->code_word)
        : "r"(low_shift), "r"(low), "r"(code_word)
    );

    return bit;
}

# 43 "/usr/local/share/frama-c/libc/stdint.h"
typedef signed short int16_t;

# 59 "libavcodec/x86/fdct.c"
static const int16_t fdct_tg_all_16[24] = {
    13036,13036,13036,13036,13036,13036,13036,13036,
    27146,27146,27146,27146,27146,27146,27146,27146,
    -21746,-21746,-21746,-21746,-21746,-21746,-21746,-21746
};

# 65 "libavcodec/x86/fdct.c"
static const int16_t ocos_4_16[8] = {
    23170,23170,23170,23170,23170,23170,23170,23170
};

# 69 "libavcodec/x86/fdct.c"
static const int16_t fdct_one_corr[8] = { 1,1,1,1,1,1,1,1 };

# 71 "libavcodec/x86/fdct.c"
static const int32_t fdct_r_row[2] = {(1 << ((3 + 17 - 3)-1)), (1 << ((3 + 17 - 3)-1)) };

# 73 "libavcodec/x86/fdct.c"
static const struct
{
 const int32_t fdct_r_row_sse2[4];
} fdct_r_row_sse2 =
{{
 (1 << ((3 + 17 - 3)-1)), (1 << ((3 + 17 - 3)-1)), (1 << ((3 + 17 - 3)-1)), (1 << ((3 + 17 - 3)-1))
}};

# 156 "libavcodec/x86/fdct.c"
static const struct
{
 const int16_t tab_frw_01234567_sse2[256];
} tab_frw_01234567_sse2 =
{{
# 174 "libavcodec/x86/fdct.c"
16384, 16384, 22725, 19266, -8867, -21407, -22725, -12873, 16384, 16384, 12873, 4520, 21407, 8867, 19266, -4520, -16384, 16384, 4520, 19266, 8867, -21407, 4520, -12873, 16384, -16384, 12873, -22725, 21407, -8867, 19266, -22725,
# 190 "libavcodec/x86/fdct.c"
22725, 22725, 31521, 26722, -12299, -29692, -31521, -17855, 22725, 22725, 17855, 6270, 29692, 12299, 26722, -6270, -22725, 22725, 6270, 26722, 12299, -29692, 6270, -17855, 22725, -22725, 17855, -31521, 29692, -12299, 26722, -31521,
# 206 "libavcodec/x86/fdct.c"
21407, 21407, 29692, 25172, -11585, -27969, -29692, -16819, 21407, 21407, 16819, 5906, 27969, 11585, 25172, -5906, -21407, 21407, 5906, 25172, 11585, -27969, 5906, -16819, 21407, -21407, 16819, -29692, 27969, -11585, 25172, -29692,
# 222 "libavcodec/x86/fdct.c"
19266, 19266, 26722, 22654, -10426, -25172, -26722, -15137, 19266, 19266, 15137, 5315, 25172, 10426, 22654, -5315, -19266, 19266, 5315, 22654, 10426, -25172, 5315, -15137, 19266, -19266, 15137, -26722, 25172, -10426, 22654, -26722,
# 238 "libavcodec/x86/fdct.c"
16384, 16384, 22725, 19266, -8867, -21407, -22725, -12873, 16384, 16384, 12873, 4520, 21407, 8867, 19266, -4520, -16384, 16384, 4520, 19266, 8867, -21407, 4520, -12873, 16384, -16384, 12873, -22725, 21407, -8867, 19266, -22725,
# 254 "libavcodec/x86/fdct.c"
19266, 19266, 26722, 22654, -10426, -25172, -26722, -15137, 19266, 19266, 15137, 5315, 25172, 10426, 22654, -5315, -19266, 19266, 5315, 22654, 10426, -25172, 5315, -15137, 19266, -19266, 15137, -26722, 25172, -10426, 22654, -26722,
# 270 "libavcodec/x86/fdct.c"
21407, 21407, 29692, 25172, -11585, -27969, -29692, -16819, 21407, 21407, 16819, 5906, 27969, 11585, 25172, -5906, -21407, 21407, 5906, 25172, 11585, -27969, 5906, -16819, 21407, -21407, 16819, -29692, 27969, -11585, 25172, -29692,
# 286 "libavcodec/x86/fdct.c"
22725, 22725, 31521, 26722, -12299, -29692, -31521, -17855, 22725, 22725, 17855, 6270, 29692, 12299, 26722, -6270, -22725, 22725, 6270, 26722, 12299, -29692, 6270, -17855, 22725, -22725, 17855, -31521, 29692, -12299, 26722, -31521,
}};

# 375 "libavcodec/x86/fdct.c"
static inline void fdct_col_mmx(const int16_t *in, int16_t *out, int offset){ __asm__ volatile ( "movq""      16(%0),  %%""mm""0 \n\t" "movq""      96(%0),  %%""mm""1 \n\t" "movq""    %%""mm""0,  %%""mm""2 \n\t" "movq""      32(%0),  %%""mm""3 \n\t" "paddsw  %%""mm""1,  %%""mm""0 \n\t" "movq""      80(%0),  %%""mm""4 \n\t" "psllw  $""3"", %%""mm""0 \n\t" "movq""        (%0),  %%""mm""5 \n\t" "paddsw  %%""mm""3,  %%""mm""4 \n\t" "paddsw   112(%0),  %%""mm""5 \n\t" "psllw  $""3"", %%""mm""4 \n\t" "movq""    %%""mm""0,  %%""mm""6 \n\t" "psubsw  %%""mm""1,  %%""mm""2 \n\t" "movq""      16(%1),  %%""mm""1 \n\t" "psubsw  %%""mm""4,  %%""mm""0 \n\t" "movq""      48(%0),  %%""mm""7 \n\t" "pmulhw  %%""mm""0,  %%""mm""1 \n\t" "paddsw    64(%0),  %%""mm""7 \n\t" "psllw  $""3"", %%""mm""5 \n\t" "paddsw  %%""mm""4,  %%""mm""6 \n\t" "psllw  $""3"", %%""mm""7 \n\t" "movq""    %%""mm""5,  %%""mm""4 \n\t" "psubsw  %%""mm""7,  %%""mm""5 \n\t" "paddsw  %%""mm""5,  %%""mm""1 \n\t" "paddsw  %%""mm""7,  %%""mm""4 \n\t" "por         (%2),  %%""mm""1 \n\t" "psllw  $""3""+1, %%""mm""2 \n\t" "pmulhw    16(%1),  %%""mm""5 \n\t" "movq""    %%""mm""4,  %%""mm""7 \n\t" "psubsw    80(%0),  %%""mm""3 \n\t" "psubsw  %%""mm""6,  %%""mm""4 \n\t" "movq""    %%""mm""1,    32(%3) \n\t" "paddsw  %%""mm""6,  %%""mm""7 \n\t" "movq""      48(%0),  %%""mm""1 \n\t" "psllw  $""3""+1, %%""mm""3 \n\t" "psubsw    64(%0),  %%""mm""1 \n\t" "movq""    %%""mm""2,  %%""mm""6 \n\t" "movq""    %%""mm""4,    64(%3) \n\t" "paddsw  %%""mm""3,  %%""mm""2 \n\t" "pmulhw      (%4),  %%""mm""2 \n\t" "psubsw  %%""mm""3,  %%""mm""6 \n\t" "pmulhw      (%4),  %%""mm""6 \n\t" "psubsw  %%""mm""0,  %%""mm""5 \n\t" "por         (%2),  %%""mm""5 \n\t" "psllw  $""3"", %%""mm""1 \n\t" "por         (%2),  %%""mm""2 \n\t" "movq""    %%""mm""1,  %%""mm""4 \n\t" "movq""        (%0),  %%""mm""3 \n\t" "paddsw  %%""mm""6,  %%""mm""1 \n\t" "psubsw   112(%0),  %%""mm""3 \n\t" "psubsw  %%""mm""6,  %%""mm""4 \n\t" "movq""        (%1),  %%""mm""0 \n\t" "psllw  $""3"", %%""mm""3 \n\t" "movq""      32(%1),  %%""mm""6 \n\t" "pmulhw  %%""mm""1,  %%""mm""0 \n\t" "movq""    %%""mm""7,      (%3) \n\t" "pmulhw  %%""mm""4,  %%""mm""6 \n\t" "movq""    %%""mm""5,    96(%3) \n\t" "movq""    %%""mm""3,  %%""mm""7 \n\t" "movq""      32(%1),  %%""mm""5 \n\t" "psubsw  %%""mm""2,  %%""mm""7 \n\t" "paddsw  %%""mm""2,  %%""mm""3 \n\t" "pmulhw  %%""mm""7,  %%""mm""5 \n\t" "paddsw  %%""mm""3,  %%""mm""0 \n\t" "paddsw  %%""mm""4,  %%""mm""6 \n\t" "pmulhw      (%1),  %%""mm""3 \n\t" "por         (%2),  %%""mm""0 \n\t" "paddsw  %%""mm""7,  %%""mm""5 \n\t" "psubsw  %%""mm""6,  %%""mm""7 \n\t" "movq""    %%""mm""0,    16(%3) \n\t" "paddsw  %%""mm""4,  %%""mm""5 \n\t" "movq""    %%""mm""7,    48(%3) \n\t" "psubsw  %%""mm""1,  %%""mm""3 \n\t" "movq""    %%""mm""5,    80(%3) \n\t" "movq""    %%""mm""3,   112(%3) \n\t" : : "r" (in + offset), "r" (fdct_tg_all_16), "r" (fdct_one_corr), "r" (out + offset), "r" (ocos_4_16)); }

# 376 "libavcodec/x86/fdct.c"
static inline void fdct_col_sse2(const int16_t *in, int16_t *out, int offset){ __asm__ volatile ( "movdqa""      16(%0),  %%""xmm""0 \n\t" "movdqa""      96(%0),  %%""xmm""1 \n\t" "movdqa""    %%""xmm""0,  %%""xmm""2 \n\t" "movdqa""      32(%0),  %%""xmm""3 \n\t" "paddsw  %%""xmm""1,  %%""xmm""0 \n\t" "movdqa""      80(%0),  %%""xmm""4 \n\t" "psllw  $""3"", %%""xmm""0 \n\t" "movdqa""        (%0),  %%""xmm""5 \n\t" "paddsw  %%""xmm""3,  %%""xmm""4 \n\t" "paddsw   112(%0),  %%""xmm""5 \n\t" "psllw  $""3"", %%""xmm""4 \n\t" "movdqa""    %%""xmm""0,  %%""xmm""6 \n\t" "psubsw  %%""xmm""1,  %%""xmm""2 \n\t" "movdqa""      16(%1),  %%""xmm""1 \n\t" "psubsw  %%""xmm""4,  %%""xmm""0 \n\t" "movdqa""      48(%0),  %%""xmm""7 \n\t" "pmulhw  %%""xmm""0,  %%""xmm""1 \n\t" "paddsw    64(%0),  %%""xmm""7 \n\t" "psllw  $""3"", %%""xmm""5 \n\t" "paddsw  %%""xmm""4,  %%""xmm""6 \n\t" "psllw  $""3"", %%""xmm""7 \n\t" "movdqa""    %%""xmm""5,  %%""xmm""4 \n\t" "psubsw  %%""xmm""7,  %%""xmm""5 \n\t" "paddsw  %%""xmm""5,  %%""xmm""1 \n\t" "paddsw  %%""xmm""7,  %%""xmm""4 \n\t" "por         (%2),  %%""xmm""1 \n\t" "psllw  $""3""+1, %%""xmm""2 \n\t" "pmulhw    16(%1),  %%""xmm""5 \n\t" "movdqa""    %%""xmm""4,  %%""xmm""7 \n\t" "psubsw    80(%0),  %%""xmm""3 \n\t" "psubsw  %%""xmm""6,  %%""xmm""4 \n\t" "movdqa""    %%""xmm""1,    32(%3) \n\t" "paddsw  %%""xmm""6,  %%""xmm""7 \n\t" "movdqa""      48(%0),  %%""xmm""1 \n\t" "psllw  $""3""+1, %%""xmm""3 \n\t" "psubsw    64(%0),  %%""xmm""1 \n\t" "movdqa""    %%""xmm""2,  %%""xmm""6 \n\t" "movdqa""    %%""xmm""4,    64(%3) \n\t" "paddsw  %%""xmm""3,  %%""xmm""2 \n\t" "pmulhw      (%4),  %%""xmm""2 \n\t" "psubsw  %%""xmm""3,  %%""xmm""6 \n\t" "pmulhw      (%4),  %%""xmm""6 \n\t" "psubsw  %%""xmm""0,  %%""xmm""5 \n\t" "por         (%2),  %%""xmm""5 \n\t" "psllw  $""3"", %%""xmm""1 \n\t" "por         (%2),  %%""xmm""2 \n\t" "movdqa""    %%""xmm""1,  %%""xmm""4 \n\t" "movdqa""        (%0),  %%""xmm""3 \n\t" "paddsw  %%""xmm""6,  %%""xmm""1 \n\t" "psubsw   112(%0),  %%""xmm""3 \n\t" "psubsw  %%""xmm""6,  %%""xmm""4 \n\t" "movdqa""        (%1),  %%""xmm""0 \n\t" "psllw  $""3"", %%""xmm""3 \n\t" "movdqa""      32(%1),  %%""xmm""6 \n\t" "pmulhw  %%""xmm""1,  %%""xmm""0 \n\t" "movdqa""    %%""xmm""7,      (%3) \n\t" "pmulhw  %%""xmm""4,  %%""xmm""6 \n\t" "movdqa""    %%""xmm""5,    96(%3) \n\t" "movdqa""    %%""xmm""3,  %%""xmm""7 \n\t" "movdqa""      32(%1),  %%""xmm""5 \n\t" "psubsw  %%""xmm""2,  %%""xmm""7 \n\t" "paddsw  %%""xmm""2,  %%""xmm""3 \n\t" "pmulhw  %%""xmm""7,  %%""xmm""5 \n\t" "paddsw  %%""xmm""3,  %%""xmm""0 \n\t" "paddsw  %%""xmm""4,  %%""xmm""6 \n\t" "pmulhw      (%1),  %%""xmm""3 \n\t" "por         (%2),  %%""xmm""0 \n\t" "paddsw  %%""xmm""7,  %%""xmm""5 \n\t" "psubsw  %%""xmm""6,  %%""xmm""7 \n\t" "movdqa""    %%""xmm""0,    16(%3) \n\t" "paddsw  %%""xmm""4,  %%""xmm""5 \n\t" "movdqa""    %%""xmm""7,    48(%3) \n\t" "psubsw  %%""xmm""1,  %%""xmm""3 \n\t" "movdqa""    %%""xmm""5,    80(%3) \n\t" "movdqa""    %%""xmm""3,   112(%3) \n\t" : : "r" (in + offset), "r" (fdct_tg_all_16), "r" (fdct_one_corr), "r" (out + offset), "r" (ocos_4_16)); }

# 378 "libavcodec/x86/fdct.c"
static inline void fdct_row_sse2(const int16_t *in, int16_t *out)
{
    __asm__ volatile(
# 415 "libavcodec/x86/fdct.c"
        "movdqa    (%2), %%xmm6         \n\t"
        "movq      " "0" "(%0), %%xmm2      \n\t" "movq      " "0" "+8(%0), %%xmm0    \n\t" "movdqa    " "0" "+32(%1), %%xmm3   \n\t" "movdqa    " "0" "+48(%1), %%xmm7   \n\t" "movdqa    " "0" "(%1), %%xmm4      \n\t" "movdqa    " "0" "+16(%1), %%xmm5   \n\t"
        "movq      %%xmm2, %%xmm1       \n\t" "pshuflw   $27, %%xmm0, %%xmm0  \n\t" "paddsw    %%xmm0, %%xmm1       \n\t" "psubsw    %%xmm0, %%xmm2       \n\t" "punpckldq %%xmm2, %%xmm1       \n\t" "pshufd    $78, %%xmm1, %%xmm2  \n\t" "pmaddwd   %%xmm2, %%xmm3       \n\t" "pmaddwd   %%xmm1, %%xmm7       \n\t" "pmaddwd   %%xmm5, %%xmm2       \n\t" "pmaddwd   %%xmm4, %%xmm1       \n\t" "paddd     %%xmm7, %%xmm3       \n\t" "paddd     %%xmm2, %%xmm1       \n\t" "paddd     %%xmm6, %%xmm3       \n\t" "paddd     %%xmm6, %%xmm1       \n\t" "psrad     %3, %%xmm3           \n\t" "psrad     %3, %%xmm1           \n\t" "packssdw  %%xmm3, %%xmm1       \n\t" "movdqa    %%xmm1, " "0" "(%4)   \n\t"
        "movq      " "64" "(%0), %%xmm2      \n\t" "movq      " "64" "+8(%0), %%xmm0    \n\t" "movdqa    " "0" "+32(%1), %%xmm3   \n\t" "movdqa    " "0" "+48(%1), %%xmm7   \n\t"
        "movq      %%xmm2, %%xmm1       \n\t" "pshuflw   $27, %%xmm0, %%xmm0  \n\t" "paddsw    %%xmm0, %%xmm1       \n\t" "psubsw    %%xmm0, %%xmm2       \n\t" "punpckldq %%xmm2, %%xmm1       \n\t" "pshufd    $78, %%xmm1, %%xmm2  \n\t" "pmaddwd   %%xmm2, %%xmm3       \n\t" "pmaddwd   %%xmm1, %%xmm7       \n\t" "pmaddwd   %%xmm5, %%xmm2       \n\t" "pmaddwd   %%xmm4, %%xmm1       \n\t" "paddd     %%xmm7, %%xmm3       \n\t" "paddd     %%xmm2, %%xmm1       \n\t" "paddd     %%xmm6, %%xmm3       \n\t" "paddd     %%xmm6, %%xmm1       \n\t" "psrad     %3, %%xmm3           \n\t" "psrad     %3, %%xmm1           \n\t" "packssdw  %%xmm3, %%xmm1       \n\t" "movdqa    %%xmm1, " "64" "(%4)   \n\t"

        "movq      " "16" "(%0), %%xmm2      \n\t" "movq      " "16" "+8(%0), %%xmm0    \n\t" "movdqa    " "64" "+32(%1), %%xmm3   \n\t" "movdqa    " "64" "+48(%1), %%xmm7   \n\t" "movdqa    " "64" "(%1), %%xmm4      \n\t" "movdqa    " "64" "+16(%1), %%xmm5   \n\t"
        "movq      %%xmm2, %%xmm1       \n\t" "pshuflw   $27, %%xmm0, %%xmm0  \n\t" "paddsw    %%xmm0, %%xmm1       \n\t" "psubsw    %%xmm0, %%xmm2       \n\t" "punpckldq %%xmm2, %%xmm1       \n\t" "pshufd    $78, %%xmm1, %%xmm2  \n\t" "pmaddwd   %%xmm2, %%xmm3       \n\t" "pmaddwd   %%xmm1, %%xmm7       \n\t" "pmaddwd   %%xmm5, %%xmm2       \n\t" "pmaddwd   %%xmm4, %%xmm1       \n\t" "paddd     %%xmm7, %%xmm3       \n\t" "paddd     %%xmm2, %%xmm1       \n\t" "paddd     %%xmm6, %%xmm3       \n\t" "paddd     %%xmm6, %%xmm1       \n\t" "psrad     %3, %%xmm3           \n\t" "psrad     %3, %%xmm1           \n\t" "packssdw  %%xmm3, %%xmm1       \n\t" "movdqa    %%xmm1, " "16" "(%4)   \n\t"
        "movq      " "112" "(%0), %%xmm2      \n\t" "movq      " "112" "+8(%0), %%xmm0    \n\t" "movdqa    " "64" "+32(%1), %%xmm3   \n\t" "movdqa    " "64" "+48(%1), %%xmm7   \n\t"
        "movq      %%xmm2, %%xmm1       \n\t" "pshuflw   $27, %%xmm0, %%xmm0  \n\t" "paddsw    %%xmm0, %%xmm1       \n\t" "psubsw    %%xmm0, %%xmm2       \n\t" "punpckldq %%xmm2, %%xmm1       \n\t" "pshufd    $78, %%xmm1, %%xmm2  \n\t" "pmaddwd   %%xmm2, %%xmm3       \n\t" "pmaddwd   %%xmm1, %%xmm7       \n\t" "pmaddwd   %%xmm5, %%xmm2       \n\t" "pmaddwd   %%xmm4, %%xmm1       \n\t" "paddd     %%xmm7, %%xmm3       \n\t" "paddd     %%xmm2, %%xmm1       \n\t" "paddd     %%xmm6, %%xmm3       \n\t" "paddd     %%xmm6, %%xmm1       \n\t" "psrad     %3, %%xmm3           \n\t" "psrad     %3, %%xmm1           \n\t" "packssdw  %%xmm3, %%xmm1       \n\t" "movdqa    %%xmm1, " "112" "(%4)   \n\t"

        "movq      " "32" "(%0), %%xmm2      \n\t" "movq      " "32" "+8(%0), %%xmm0    \n\t" "movdqa    " "128" "+32(%1), %%xmm3   \n\t" "movdqa    " "128" "+48(%1), %%xmm7   \n\t" "movdqa    " "128" "(%1), %%xmm4      \n\t" "movdqa    " "128" "+16(%1), %%xmm5   \n\t"
        "movq      %%xmm2, %%xmm1       \n\t" "pshuflw   $27, %%xmm0, %%xmm0  \n\t" "paddsw    %%xmm0, %%xmm1       \n\t" "psubsw    %%xmm0, %%xmm2       \n\t" "punpckldq %%xmm2, %%xmm1       \n\t" "pshufd    $78, %%xmm1, %%xmm2  \n\t" "pmaddwd   %%xmm2, %%xmm3       \n\t" "pmaddwd   %%xmm1, %%xmm7       \n\t" "pmaddwd   %%xmm5, %%xmm2       \n\t" "pmaddwd   %%xmm4, %%xmm1       \n\t" "paddd     %%xmm7, %%xmm3       \n\t" "paddd     %%xmm2, %%xmm1       \n\t" "paddd     %%xmm6, %%xmm3       \n\t" "paddd     %%xmm6, %%xmm1       \n\t" "psrad     %3, %%xmm3           \n\t" "psrad     %3, %%xmm1           \n\t" "packssdw  %%xmm3, %%xmm1       \n\t" "movdqa    %%xmm1, " "32" "(%4)   \n\t"
        "movq      " "96" "(%0), %%xmm2      \n\t" "movq      " "96" "+8(%0), %%xmm0    \n\t" "movdqa    " "128" "+32(%1), %%xmm3   \n\t" "movdqa    " "128" "+48(%1), %%xmm7   \n\t"
        "movq      %%xmm2, %%xmm1       \n\t" "pshuflw   $27, %%xmm0, %%xmm0  \n\t" "paddsw    %%xmm0, %%xmm1       \n\t" "psubsw    %%xmm0, %%xmm2       \n\t" "punpckldq %%xmm2, %%xmm1       \n\t" "pshufd    $78, %%xmm1, %%xmm2  \n\t" "pmaddwd   %%xmm2, %%xmm3       \n\t" "pmaddwd   %%xmm1, %%xmm7       \n\t" "pmaddwd   %%xmm5, %%xmm2       \n\t" "pmaddwd   %%xmm4, %%xmm1       \n\t" "paddd     %%xmm7, %%xmm3       \n\t" "paddd     %%xmm2, %%xmm1       \n\t" "paddd     %%xmm6, %%xmm3       \n\t" "paddd     %%xmm6, %%xmm1       \n\t" "psrad     %3, %%xmm3           \n\t" "psrad     %3, %%xmm1           \n\t" "packssdw  %%xmm3, %%xmm1       \n\t" "movdqa    %%xmm1, " "96" "(%4)   \n\t"

        "movq      " "48" "(%0), %%xmm2      \n\t" "movq      " "48" "+8(%0), %%xmm0    \n\t" "movdqa    " "192" "+32(%1), %%xmm3   \n\t" "movdqa    " "192" "+48(%1), %%xmm7   \n\t" "movdqa    " "192" "(%1), %%xmm4      \n\t" "movdqa    " "192" "+16(%1), %%xmm5   \n\t"
        "movq      %%xmm2, %%xmm1       \n\t" "pshuflw   $27, %%xmm0, %%xmm0  \n\t" "paddsw    %%xmm0, %%xmm1       \n\t" "psubsw    %%xmm0, %%xmm2       \n\t" "punpckldq %%xmm2, %%xmm1       \n\t" "pshufd    $78, %%xmm1, %%xmm2  \n\t" "pmaddwd   %%xmm2, %%xmm3       \n\t" "pmaddwd   %%xmm1, %%xmm7       \n\t" "pmaddwd   %%xmm5, %%xmm2       \n\t" "pmaddwd   %%xmm4, %%xmm1       \n\t" "paddd     %%xmm7, %%xmm3       \n\t" "paddd     %%xmm2, %%xmm1       \n\t" "paddd     %%xmm6, %%xmm3       \n\t" "paddd     %%xmm6, %%xmm1       \n\t" "psrad     %3, %%xmm3           \n\t" "psrad     %3, %%xmm1           \n\t" "packssdw  %%xmm3, %%xmm1       \n\t" "movdqa    %%xmm1, " "48" "(%4)   \n\t"
        "movq      " "80" "(%0), %%xmm2      \n\t" "movq      " "80" "+8(%0), %%xmm0    \n\t" "movdqa    " "192" "+32(%1), %%xmm3   \n\t" "movdqa    " "192" "+48(%1), %%xmm7   \n\t"
        "movq      %%xmm2, %%xmm1       \n\t" "pshuflw   $27, %%xmm0, %%xmm0  \n\t" "paddsw    %%xmm0, %%xmm1       \n\t" "psubsw    %%xmm0, %%xmm2       \n\t" "punpckldq %%xmm2, %%xmm1       \n\t" "pshufd    $78, %%xmm1, %%xmm2  \n\t" "pmaddwd   %%xmm2, %%xmm3       \n\t" "pmaddwd   %%xmm1, %%xmm7       \n\t" "pmaddwd   %%xmm5, %%xmm2       \n\t" "pmaddwd   %%xmm4, %%xmm1       \n\t" "paddd     %%xmm7, %%xmm3       \n\t" "paddd     %%xmm2, %%xmm1       \n\t" "paddd     %%xmm6, %%xmm3       \n\t" "paddd     %%xmm6, %%xmm1       \n\t" "psrad     %3, %%xmm3           \n\t" "psrad     %3, %%xmm1           \n\t" "packssdw  %%xmm3, %%xmm1       \n\t" "movdqa    %%xmm1, " "80" "(%4)   \n\t"
        :
        : "r" (in), "r" (tab_frw_01234567_sse2.tab_frw_01234567_sse2),
          "r" (fdct_r_row_sse2.fdct_r_row_sse2), "i" ((3 + 17 - 3)), "r" (out)
          : "%xmm0", "%xmm1", "%xmm2", "%xmm3", "%xmm4", "%xmm5", "%xmm6", "%xmm7"

    );
}

# 443 "libavcodec/x86/fdct.c"
static inline void fdct_row_mmxext(const int16_t *in, int16_t *out,
                                             const int16_t *table)
{
    __asm__ volatile (
        "pshufw    $0x1B, 8(%0), %%mm5 \n\t"
        "movq       (%0), %%mm0 \n\t"
        "movq      %%mm0, %%mm1 \n\t"
        "paddsw    %%mm5, %%mm0 \n\t"
        "psubsw    %%mm5, %%mm1 \n\t"
        "movq      %%mm0, %%mm2 \n\t"
        "punpckldq %%mm1, %%mm0 \n\t"
        "punpckhdq %%mm1, %%mm2 \n\t"
        "movq       (%1), %%mm1 \n\t"
        "movq      8(%1), %%mm3 \n\t"
        "movq     16(%1), %%mm4 \n\t"
        "movq     24(%1), %%mm5 \n\t"
        "movq     32(%1), %%mm6 \n\t"
        "movq     40(%1), %%mm7 \n\t"
        "pmaddwd   %%mm0, %%mm1 \n\t"
        "pmaddwd   %%mm2, %%mm3 \n\t"
        "pmaddwd   %%mm0, %%mm4 \n\t"
        "pmaddwd   %%mm2, %%mm5 \n\t"
        "pmaddwd   %%mm0, %%mm6 \n\t"
        "pmaddwd   %%mm2, %%mm7 \n\t"
        "pmaddwd  48(%1), %%mm0 \n\t"
        "pmaddwd  56(%1), %%mm2 \n\t"
        "paddd     %%mm1, %%mm3 \n\t"
        "paddd     %%mm4, %%mm5 \n\t"
        "paddd     %%mm6, %%mm7 \n\t"
        "paddd     %%mm0, %%mm2 \n\t"
        "movq       (%2), %%mm0 \n\t"
        "paddd     %%mm0, %%mm3 \n\t"
        "paddd     %%mm0, %%mm5 \n\t"
        "paddd     %%mm0, %%mm7 \n\t"
        "paddd     %%mm0, %%mm2 \n\t"
        "psrad $""(3 + 17 - 3)"", %%mm3 \n\t"
        "psrad $""(3 + 17 - 3)"", %%mm5 \n\t"
        "psrad $""(3 + 17 - 3)"", %%mm7 \n\t"
        "psrad $""(3 + 17 - 3)"", %%mm2 \n\t"
        "packssdw  %%mm5, %%mm3 \n\t"
        "packssdw  %%mm2, %%mm7 \n\t"
        "movq      %%mm3,  (%3) \n\t"
        "movq      %%mm7, 8(%3) \n\t"
        :
        : "r" (in), "r" (table), "r" (fdct_r_row), "r" (out));
}

# 490 "libavcodec/x86/fdct.c"
static inline void fdct_row_mmx(const int16_t *in, int16_t *out, const int16_t *table)
{

    __asm__ volatile(
        "movd     12(%0), %%mm1 \n\t"
        "punpcklwd 8(%0), %%mm1 \n\t"
        "movq      %%mm1, %%mm2 \n\t"
        "psrlq     $0x20, %%mm1 \n\t"
        "movq      0(%0), %%mm0 \n\t"
        "punpcklwd %%mm2, %%mm1 \n\t"
        "movq      %%mm0, %%mm5 \n\t"
        "paddsw    %%mm1, %%mm0 \n\t"
        "psubsw    %%mm1, %%mm5 \n\t"
        "movq      %%mm0, %%mm2 \n\t"
        "punpckldq %%mm5, %%mm0 \n\t"
        "punpckhdq %%mm5, %%mm2 \n\t"
        "movq      0(%1), %%mm1 \n\t"
        "movq      8(%1), %%mm3 \n\t"
        "movq     16(%1), %%mm4 \n\t"
        "movq     24(%1), %%mm5 \n\t"
        "movq     32(%1), %%mm6 \n\t"
        "movq     40(%1), %%mm7 \n\t"
        "pmaddwd   %%mm0, %%mm1 \n\t"
        "pmaddwd   %%mm2, %%mm3 \n\t"
        "pmaddwd   %%mm0, %%mm4 \n\t"
        "pmaddwd   %%mm2, %%mm5 \n\t"
        "pmaddwd   %%mm0, %%mm6 \n\t"
        "pmaddwd   %%mm2, %%mm7 \n\t"
        "pmaddwd  48(%1), %%mm0 \n\t"
        "pmaddwd  56(%1), %%mm2 \n\t"
        "paddd     %%mm1, %%mm3 \n\t"
        "paddd     %%mm4, %%mm5 \n\t"
        "paddd     %%mm6, %%mm7 \n\t"
        "paddd     %%mm0, %%mm2 \n\t"
        "movq       (%2), %%mm0 \n\t"
        "paddd     %%mm0, %%mm3 \n\t"
        "paddd     %%mm0, %%mm5 \n\t"
        "paddd     %%mm0, %%mm7 \n\t"
        "paddd     %%mm0, %%mm2 \n\t"
        "psrad $""(3 + 17 - 3)"", %%mm3 \n\t"
        "psrad $""(3 + 17 - 3)"", %%mm5 \n\t"
        "psrad $""(3 + 17 - 3)"", %%mm7 \n\t"
        "psrad $""(3 + 17 - 3)"", %%mm2 \n\t"
        "packssdw  %%mm5, %%mm3 \n\t"
        "packssdw  %%mm2, %%mm7 \n\t"
        "movq      %%mm3, 0(%3) \n\t"
        "movq      %%mm7, 8(%3) \n\t"
        :
        : "r" (in), "r" (table), "r" (fdct_r_row), "r" (out));
}

# 47 "libavcodec/x86/mlpdsp_init.c"
extern char ff_mlp_firorder_8;

# 48 "libavcodec/x86/mlpdsp_init.c"
extern char ff_mlp_firorder_7;

# 49 "libavcodec/x86/mlpdsp_init.c"
extern char ff_mlp_firorder_6;

# 50 "libavcodec/x86/mlpdsp_init.c"
extern char ff_mlp_firorder_5;

# 51 "libavcodec/x86/mlpdsp_init.c"
extern char ff_mlp_firorder_4;

# 52 "libavcodec/x86/mlpdsp_init.c"
extern char ff_mlp_firorder_3;

# 53 "libavcodec/x86/mlpdsp_init.c"
extern char ff_mlp_firorder_2;

# 54 "libavcodec/x86/mlpdsp_init.c"
extern char ff_mlp_firorder_1;

# 55 "libavcodec/x86/mlpdsp_init.c"
extern char ff_mlp_firorder_0;

# 57 "libavcodec/x86/mlpdsp_init.c"
extern char ff_mlp_iirorder_4;

# 58 "libavcodec/x86/mlpdsp_init.c"
extern char ff_mlp_iirorder_3;

# 59 "libavcodec/x86/mlpdsp_init.c"
extern char ff_mlp_iirorder_2;

# 60 "libavcodec/x86/mlpdsp_init.c"
extern char ff_mlp_iirorder_1;

# 61 "libavcodec/x86/mlpdsp_init.c"
extern char ff_mlp_iirorder_0;

# 63 "libavcodec/x86/mlpdsp_init.c"
static const void * const firtable[9] = { &ff_mlp_firorder_0, &ff_mlp_firorder_1,
                                          &ff_mlp_firorder_2, &ff_mlp_firorder_3,
                                          &ff_mlp_firorder_4, &ff_mlp_firorder_5,
                                          &ff_mlp_firorder_6, &ff_mlp_firorder_7,
                                          &ff_mlp_firorder_8 };

# 68 "libavcodec/x86/mlpdsp_init.c"
static const void * const iirtable[5] = { &ff_mlp_iirorder_0, &ff_mlp_iirorder_1,
                                          &ff_mlp_iirorder_2, &ff_mlp_iirorder_3,
                                          &ff_mlp_iirorder_4 };

# 137 "/usr/include/SDL2/SDL_stdinc.h"
typedef uint16_t Uint16;

# 145 "/usr/include/SDL2/SDL_stdinc.h"
typedef uint32_t Uint32;

# 154 "/usr/include/SDL2/SDL_stdinc.h"
typedef uint64_t Uint64;

# 70 "/usr/include/SDL2/SDL_endian.h"
static __inline__ Uint16
SDL_Swap16(Uint16 x)
{
  __asm__("xchgb %b0,%h0": "=q"(x):"0"(x));
    return x;
}

# 108 "/usr/include/SDL2/SDL_endian.h"
static __inline__ Uint32
SDL_Swap32(Uint32 x)
{
  __asm__("bswap %0": "=r"(x):"0"(x));
    return x;
}

# 149 "/usr/include/SDL2/SDL_endian.h"
static __inline__ Uint64
SDL_Swap64(Uint64 x)
{
    union
    {
        struct
        {
            Uint32 a, b;
        } s;
        Uint64 u;
    } v;
    v.u = x;
  __asm__("bswapl %0 ; bswapl %1 ; xchgl %0,%1": "=r"(v.s.a), "=r"(v.s.b):"0"(v.s.a),
            "1"(v.s.
                b));
    return v.u;
}

# 29 "./libavutil/log.h"
typedef enum {
    AV_CLASS_CATEGORY_NA = 0,
    AV_CLASS_CATEGORY_INPUT,
    AV_CLASS_CATEGORY_OUTPUT,
    AV_CLASS_CATEGORY_MUXER,
    AV_CLASS_CATEGORY_DEMUXER,
    AV_CLASS_CATEGORY_ENCODER,
    AV_CLASS_CATEGORY_DECODER,
    AV_CLASS_CATEGORY_FILTER,
    AV_CLASS_CATEGORY_BITSTREAM_FILTER,
    AV_CLASS_CATEGORY_SWSCALER,
    AV_CLASS_CATEGORY_SWRESAMPLER,
    AV_CLASS_CATEGORY_DEVICE_VIDEO_OUTPUT = 40,
    AV_CLASS_CATEGORY_DEVICE_VIDEO_INPUT,
    AV_CLASS_CATEGORY_DEVICE_AUDIO_OUTPUT,
    AV_CLASS_CATEGORY_DEVICE_AUDIO_INPUT,
    AV_CLASS_CATEGORY_DEVICE_OUTPUT,
    AV_CLASS_CATEGORY_DEVICE_INPUT,
    AV_CLASS_CATEGORY_NB
}AVClassCategory;

# 60 "./libavutil/log.h"
struct AVOptionRanges;

# 67 "./libavutil/log.h"
typedef struct AVClass {




    const char* class_name;





    const char* (*item_name)(void* ctx);






    const struct AVOption *option;







    int version;





    int log_level_offset_offset;
# 108 "./libavutil/log.h"
    int parent_log_context_offset;




    void* (*child_next)(void *obj, void *prev);
# 123 "./libavutil/log.h"
    const struct AVClass* (*child_class_next)(const struct AVClass *prev);






    AVClassCategory category;





    AVClassCategory (*get_category)(void* ctx);





    int (*query_ranges)(struct AVOptionRanges **, void *obj, const char *key, int flags);
} AVClass;

# 60 "./libavutil/pixfmt.h"
enum AVPixelFormat {
    AV_PIX_FMT_NONE = -1,
    AV_PIX_FMT_YUV420P,
    AV_PIX_FMT_YUYV422,
    AV_PIX_FMT_RGB24,
    AV_PIX_FMT_BGR24,
    AV_PIX_FMT_YUV422P,
    AV_PIX_FMT_YUV444P,
    AV_PIX_FMT_YUV410P,
    AV_PIX_FMT_YUV411P,
    AV_PIX_FMT_GRAY8,
    AV_PIX_FMT_MONOWHITE,
    AV_PIX_FMT_MONOBLACK,
    AV_PIX_FMT_PAL8,
    AV_PIX_FMT_YUVJ420P,
    AV_PIX_FMT_YUVJ422P,
    AV_PIX_FMT_YUVJ444P,
    AV_PIX_FMT_UYVY422,
    AV_PIX_FMT_UYYVYY411,
    AV_PIX_FMT_BGR8,
    AV_PIX_FMT_BGR4,
    AV_PIX_FMT_BGR4_BYTE,
    AV_PIX_FMT_RGB8,
    AV_PIX_FMT_RGB4,
    AV_PIX_FMT_RGB4_BYTE,
    AV_PIX_FMT_NV12,
    AV_PIX_FMT_NV21,

    AV_PIX_FMT_ARGB,
    AV_PIX_FMT_RGBA,
    AV_PIX_FMT_ABGR,
    AV_PIX_FMT_BGRA,

    AV_PIX_FMT_GRAY16BE,
    AV_PIX_FMT_GRAY16LE,
    AV_PIX_FMT_YUV440P,
    AV_PIX_FMT_YUVJ440P,
    AV_PIX_FMT_YUVA420P,
    AV_PIX_FMT_RGB48BE,
    AV_PIX_FMT_RGB48LE,

    AV_PIX_FMT_RGB565BE,
    AV_PIX_FMT_RGB565LE,
    AV_PIX_FMT_RGB555BE,
    AV_PIX_FMT_RGB555LE,

    AV_PIX_FMT_BGR565BE,
    AV_PIX_FMT_BGR565LE,
    AV_PIX_FMT_BGR555BE,
    AV_PIX_FMT_BGR555LE,




    AV_PIX_FMT_VAAPI_MOCO,
    AV_PIX_FMT_VAAPI_IDCT,
    AV_PIX_FMT_VAAPI_VLD,

    AV_PIX_FMT_VAAPI = AV_PIX_FMT_VAAPI_VLD,
# 127 "./libavutil/pixfmt.h"
    AV_PIX_FMT_YUV420P16LE,
    AV_PIX_FMT_YUV420P16BE,
    AV_PIX_FMT_YUV422P16LE,
    AV_PIX_FMT_YUV422P16BE,
    AV_PIX_FMT_YUV444P16LE,
    AV_PIX_FMT_YUV444P16BE,
    AV_PIX_FMT_DXVA2_VLD,

    AV_PIX_FMT_RGB444LE,
    AV_PIX_FMT_RGB444BE,
    AV_PIX_FMT_BGR444LE,
    AV_PIX_FMT_BGR444BE,
    AV_PIX_FMT_YA8,

    AV_PIX_FMT_Y400A = AV_PIX_FMT_YA8,
    AV_PIX_FMT_GRAY8A= AV_PIX_FMT_YA8,

    AV_PIX_FMT_BGR48BE,
    AV_PIX_FMT_BGR48LE,






    AV_PIX_FMT_YUV420P9BE,
    AV_PIX_FMT_YUV420P9LE,
    AV_PIX_FMT_YUV420P10BE,
    AV_PIX_FMT_YUV420P10LE,
    AV_PIX_FMT_YUV422P10BE,
    AV_PIX_FMT_YUV422P10LE,
    AV_PIX_FMT_YUV444P9BE,
    AV_PIX_FMT_YUV444P9LE,
    AV_PIX_FMT_YUV444P10BE,
    AV_PIX_FMT_YUV444P10LE,
    AV_PIX_FMT_YUV422P9BE,
    AV_PIX_FMT_YUV422P9LE,
    AV_PIX_FMT_GBRP,
    AV_PIX_FMT_GBR24P = AV_PIX_FMT_GBRP,
    AV_PIX_FMT_GBRP9BE,
    AV_PIX_FMT_GBRP9LE,
    AV_PIX_FMT_GBRP10BE,
    AV_PIX_FMT_GBRP10LE,
    AV_PIX_FMT_GBRP16BE,
    AV_PIX_FMT_GBRP16LE,
    AV_PIX_FMT_YUVA422P,
    AV_PIX_FMT_YUVA444P,
    AV_PIX_FMT_YUVA420P9BE,
    AV_PIX_FMT_YUVA420P9LE,
    AV_PIX_FMT_YUVA422P9BE,
    AV_PIX_FMT_YUVA422P9LE,
    AV_PIX_FMT_YUVA444P9BE,
    AV_PIX_FMT_YUVA444P9LE,
    AV_PIX_FMT_YUVA420P10BE,
    AV_PIX_FMT_YUVA420P10LE,
    AV_PIX_FMT_YUVA422P10BE,
    AV_PIX_FMT_YUVA422P10LE,
    AV_PIX_FMT_YUVA444P10BE,
    AV_PIX_FMT_YUVA444P10LE,
    AV_PIX_FMT_YUVA420P16BE,
    AV_PIX_FMT_YUVA420P16LE,
    AV_PIX_FMT_YUVA422P16BE,
    AV_PIX_FMT_YUVA422P16LE,
    AV_PIX_FMT_YUVA444P16BE,
    AV_PIX_FMT_YUVA444P16LE,

    AV_PIX_FMT_VDPAU,

    AV_PIX_FMT_XYZ12LE,
    AV_PIX_FMT_XYZ12BE,
    AV_PIX_FMT_NV16,
    AV_PIX_FMT_NV20LE,
    AV_PIX_FMT_NV20BE,

    AV_PIX_FMT_RGBA64BE,
    AV_PIX_FMT_RGBA64LE,
    AV_PIX_FMT_BGRA64BE,
    AV_PIX_FMT_BGRA64LE,

    AV_PIX_FMT_YVYU422,

    AV_PIX_FMT_YA16BE,
    AV_PIX_FMT_YA16LE,

    AV_PIX_FMT_GBRAP,
    AV_PIX_FMT_GBRAP16BE,
    AV_PIX_FMT_GBRAP16LE,




    AV_PIX_FMT_QSV,




    AV_PIX_FMT_MMAL,

    AV_PIX_FMT_D3D11VA_VLD,





    AV_PIX_FMT_CUDA,

    AV_PIX_FMT_0RGB,
    AV_PIX_FMT_RGB0,
    AV_PIX_FMT_0BGR,
    AV_PIX_FMT_BGR0,

    AV_PIX_FMT_YUV420P12BE,
    AV_PIX_FMT_YUV420P12LE,
    AV_PIX_FMT_YUV420P14BE,
    AV_PIX_FMT_YUV420P14LE,
    AV_PIX_FMT_YUV422P12BE,
    AV_PIX_FMT_YUV422P12LE,
    AV_PIX_FMT_YUV422P14BE,
    AV_PIX_FMT_YUV422P14LE,
    AV_PIX_FMT_YUV444P12BE,
    AV_PIX_FMT_YUV444P12LE,
    AV_PIX_FMT_YUV444P14BE,
    AV_PIX_FMT_YUV444P14LE,
    AV_PIX_FMT_GBRP12BE,
    AV_PIX_FMT_GBRP12LE,
    AV_PIX_FMT_GBRP14BE,
    AV_PIX_FMT_GBRP14LE,
    AV_PIX_FMT_YUVJ411P,

    AV_PIX_FMT_BAYER_BGGR8,
    AV_PIX_FMT_BAYER_RGGB8,
    AV_PIX_FMT_BAYER_GBRG8,
    AV_PIX_FMT_BAYER_GRBG8,
    AV_PIX_FMT_BAYER_BGGR16LE,
    AV_PIX_FMT_BAYER_BGGR16BE,
    AV_PIX_FMT_BAYER_RGGB16LE,
    AV_PIX_FMT_BAYER_RGGB16BE,
    AV_PIX_FMT_BAYER_GBRG16LE,
    AV_PIX_FMT_BAYER_GBRG16BE,
    AV_PIX_FMT_BAYER_GRBG16LE,
    AV_PIX_FMT_BAYER_GRBG16BE,

    AV_PIX_FMT_XVMC,

    AV_PIX_FMT_YUV440P10LE,
    AV_PIX_FMT_YUV440P10BE,
    AV_PIX_FMT_YUV440P12LE,
    AV_PIX_FMT_YUV440P12BE,
    AV_PIX_FMT_AYUV64LE,
    AV_PIX_FMT_AYUV64BE,

    AV_PIX_FMT_VIDEOTOOLBOX,

    AV_PIX_FMT_P010LE,
    AV_PIX_FMT_P010BE,

    AV_PIX_FMT_GBRAP12BE,
    AV_PIX_FMT_GBRAP12LE,

    AV_PIX_FMT_GBRAP10BE,
    AV_PIX_FMT_GBRAP10LE,

    AV_PIX_FMT_MEDIACODEC,

    AV_PIX_FMT_GRAY12BE,
    AV_PIX_FMT_GRAY12LE,
    AV_PIX_FMT_GRAY10BE,
    AV_PIX_FMT_GRAY10LE,

    AV_PIX_FMT_P016LE,
    AV_PIX_FMT_P016BE,
# 309 "./libavutil/pixfmt.h"
    AV_PIX_FMT_D3D11,

    AV_PIX_FMT_GRAY9BE,
    AV_PIX_FMT_GRAY9LE,

    AV_PIX_FMT_GBRPF32BE,
    AV_PIX_FMT_GBRPF32LE,
    AV_PIX_FMT_GBRAPF32BE,
    AV_PIX_FMT_GBRAPF32LE,






    AV_PIX_FMT_DRM_PRIME,






    AV_PIX_FMT_OPENCL,

    AV_PIX_FMT_NB
};

# 65 "./libswscale/swscale_internal.h"
typedef enum SwsDither {
    SWS_DITHER_NONE = 0,
    SWS_DITHER_AUTO,
    SWS_DITHER_BAYER,
    SWS_DITHER_ED,
    SWS_DITHER_A_DITHER,
    SWS_DITHER_X_DITHER,
    NB_SWS_DITHER,
} SwsDither;

# 75 "./libswscale/swscale_internal.h"
typedef enum SwsAlphaBlend {
    SWS_ALPHA_BLEND_NONE = 0,
    SWS_ALPHA_BLEND_UNIFORM,
    SWS_ALPHA_BLEND_CHECKERBOARD,
    SWS_ALPHA_BLEND_NB,
} SwsAlphaBlend;

# 82 "./libswscale/swscale_internal.h"
typedef int (*SwsFunc)(struct SwsContext *context, const uint8_t *src[],
                       int srcStride[], int srcSliceY, int srcSliceH,
                       uint8_t *dst[], int dstStride[]);

# 98 "./libswscale/swscale_internal.h"
typedef void (*yuv2planar1_fn)(const int16_t *src, uint8_t *dest, int dstW,
                               const uint8_t *dither, int offset);

# 114 "./libswscale/swscale_internal.h"
typedef void (*yuv2planarX_fn)(const int16_t *filter, int filterSize,
                               const int16_t **src, uint8_t *dest, int dstW,
                               const uint8_t *dither, int offset);

# 133 "./libswscale/swscale_internal.h"
typedef void (*yuv2interleavedX_fn)(struct SwsContext *c,
                                    const int16_t *chrFilter,
                                    int chrFilterSize,
                                    const int16_t **chrUSrc,
                                    const int16_t **chrVSrc,
                                    uint8_t *dest, int dstW);

# 169 "./libswscale/swscale_internal.h"
typedef void (*yuv2packed1_fn)(struct SwsContext *c, const int16_t *lumSrc,
                               const int16_t *chrUSrc[2],
                               const int16_t *chrVSrc[2],
                               const int16_t *alpSrc, uint8_t *dest,
                               int dstW, int uvalpha, int y);

# 202 "./libswscale/swscale_internal.h"
typedef void (*yuv2packed2_fn)(struct SwsContext *c, const int16_t *lumSrc[2],
                               const int16_t *chrUSrc[2],
                               const int16_t *chrVSrc[2],
                               const int16_t *alpSrc[2],
                               uint8_t *dest,
                               int dstW, int yalpha, int uvalpha, int y);

# 234 "./libswscale/swscale_internal.h"
typedef void (*yuv2packedX_fn)(struct SwsContext *c, const int16_t *lumFilter,
                               const int16_t **lumSrc, int lumFilterSize,
                               const int16_t *chrFilter,
                               const int16_t **chrUSrc,
                               const int16_t **chrVSrc, int chrFilterSize,
                               const int16_t **alpSrc, uint8_t *dest,
                               int dstW, int y);

# 268 "./libswscale/swscale_internal.h"
typedef void (*yuv2anyX_fn)(struct SwsContext *c, const int16_t *lumFilter,
                            const int16_t **lumSrc, int lumFilterSize,
                            const int16_t *chrFilter,
                            const int16_t **chrUSrc,
                            const int16_t **chrVSrc, int chrFilterSize,
                            const int16_t **alpSrc, uint8_t **dest,
                            int dstW, int y);

# 280 "./libswscale/swscale_internal.h"
typedef struct SwsContext {



    const AVClass *av_class;





    SwsFunc swscale;
    int srcW;
    int srcH;
    int dstH;
    int chrSrcW;
    int chrSrcH;
    int chrDstW;
    int chrDstH;
    int lumXInc, chrXInc;
    int lumYInc, chrYInc;
    enum AVPixelFormat dstFormat;
    enum AVPixelFormat srcFormat;
    int dstFormatBpp;
    int srcFormatBpp;
    int dstBpc, srcBpc;
    int chrSrcHSubSample;
    int chrSrcVSubSample;
    int chrDstHSubSample;
    int chrDstVSubSample;
    int vChrDrop;
    int sliceDir;
    double param[2];





    struct SwsContext *cascaded_context[3];
    int cascaded_tmpStride[4];
    uint8_t *cascaded_tmp[4];
    int cascaded1_tmpStride[4];
    uint8_t *cascaded1_tmp[4];
    int cascaded_mainindex;

    double gamma_value;
    int gamma_flag;
    int is_internal_gamma;
    uint16_t *gamma;
    uint16_t *inv_gamma;

    int numDesc;
    int descIndex[2];
    int numSlice;
    struct SwsSlice *slice;
    struct SwsFilterDescriptor *desc;

    uint32_t pal_yuv[256];
    uint32_t pal_rgb[256];
# 349 "./libswscale/swscale_internal.h"
    int lastInLumBuf;
    int lastInChrBuf;
    int lumBufIndex;
    int chrBufIndex;


    uint8_t *formatConvBuffer;
    int needAlpha;
# 372 "./libswscale/swscale_internal.h"
    int16_t *hLumFilter;
    int16_t *hChrFilter;
    int16_t *vLumFilter;
    int16_t *vChrFilter;
    int32_t *hLumFilterPos;
    int32_t *hChrFilterPos;
    int32_t *vLumFilterPos;
    int32_t *vChrFilterPos;
    int hLumFilterSize;
    int hChrFilterSize;
    int vLumFilterSize;
    int vChrFilterSize;


    int lumMmxextFilterCodeSize;
    int chrMmxextFilterCodeSize;
    uint8_t *lumMmxextFilterCode;
    uint8_t *chrMmxextFilterCode;

    int canMMXEXTBeUsed;
    int warned_unuseable_bilinear;

    int dstY;
    int flags;
    void *yuvTable;


    int table_gV[256 + 2*512];
    uint8_t *table_rV[256 + 2*512];
    uint8_t *table_gU[256 + 2*512];
    uint8_t *table_bU[256 + 2*512];
    int32_t input_rgb2yuv_table[16+40*4];
# 415 "./libswscale/swscale_internal.h"
    int *dither_error[4];


    int contrast, brightness, saturation;
    int srcColorspaceTable[4];
    int dstColorspaceTable[4];
    int srcRange;
    int dstRange;
    int src0Alpha;
    int dst0Alpha;
    int srcXYZ;
    int dstXYZ;
    int src_h_chr_pos;
    int dst_h_chr_pos;
    int src_v_chr_pos;
    int dst_v_chr_pos;
    int yuv2rgb_y_offset;
    int yuv2rgb_y_coeff;
    int yuv2rgb_v2r_coeff;
    int yuv2rgb_v2g_coeff;
    int yuv2rgb_u2g_coeff;
    int yuv2rgb_u2b_coeff;
# 464 "./libswscale/swscale_internal.h"
    uint64_t redDither;
    uint64_t greenDither;
    uint64_t blueDither;

    uint64_t yCoeff;
    uint64_t vrCoeff;
    uint64_t ubCoeff;
    uint64_t vgCoeff;
    uint64_t ugCoeff;
    uint64_t yOffset;
    uint64_t uOffset;
    uint64_t vOffset;
    int32_t lumMmxFilter[4 * 256];
    int32_t chrMmxFilter[4 * 256];
    int dstW;
    uint64_t esp;
    uint64_t vRounder;
    uint64_t u_temp;
    uint64_t v_temp;
    uint64_t y_temp;
    int32_t alpMmxFilter[4 * 256];



    ptrdiff_t uv_off;
    ptrdiff_t uv_offx2;
    uint16_t dither16[8];
    uint32_t dither32[8];

    const uint8_t *chrDither8, *lumDither8;
# 506 "./libswscale/swscale_internal.h"
    int use_mmx_vfilter;




    int16_t *xyzgamma;
    int16_t *rgbgamma;
    int16_t *xyzgammainv;
    int16_t *rgbgammainv;
    int16_t xyz2rgb_matrix[3][4];
    int16_t rgb2xyz_matrix[3][4];


    yuv2planar1_fn yuv2plane1;
    yuv2planarX_fn yuv2planeX;
    yuv2interleavedX_fn yuv2nv12cX;
    yuv2packed1_fn yuv2packed1;
    yuv2packed2_fn yuv2packed2;
    yuv2packedX_fn yuv2packedX;
    yuv2anyX_fn yuv2anyX;


    void (*lumToYV12)(uint8_t *dst, const uint8_t *src, const uint8_t *src2, const uint8_t *src3,
                      int width, uint32_t *pal);

    void (*alpToYV12)(uint8_t *dst, const uint8_t *src, const uint8_t *src2, const uint8_t *src3,
                      int width, uint32_t *pal);

    void (*chrToYV12)(uint8_t *dstU, uint8_t *dstV,
                      const uint8_t *src1, const uint8_t *src2, const uint8_t *src3,
                      int width, uint32_t *pal);






    void (*readLumPlanar)(uint8_t *dst, const uint8_t *src[4], int width, int32_t *rgb2yuv);
    void (*readChrPlanar)(uint8_t *dstU, uint8_t *dstV, const uint8_t *src[4],
                          int width, int32_t *rgb2yuv);
    void (*readAlpPlanar)(uint8_t *dst, const uint8_t *src[4], int width, int32_t *rgb2yuv);
# 568 "./libswscale/swscale_internal.h"
    void (*hyscale_fast)(struct SwsContext *c,
                         int16_t *dst, int dstWidth,
                         const uint8_t *src, int srcW, int xInc);
    void (*hcscale_fast)(struct SwsContext *c,
                         int16_t *dst1, int16_t *dst2, int dstWidth,
                         const uint8_t *src1, const uint8_t *src2,
                         int srcW, int xInc);
# 608 "./libswscale/swscale_internal.h"
    void (*hyScale)(struct SwsContext *c, int16_t *dst, int dstW,
                    const uint8_t *src, const int16_t *filter,
                    const int32_t *filterPos, int filterSize);
    void (*hcScale)(struct SwsContext *c, int16_t *dst, int dstW,
                    const uint8_t *src, const int16_t *filter,
                    const int32_t *filterPos, int filterSize);



    void (*lumConvertRange)(int16_t *dst, int width);

    void (*chrConvertRange)(int16_t *dst1, int16_t *dst2, int width);

    int needs_hcscale;

    SwsDither dither;

    SwsAlphaBlend alphablend;
} SwsContext;

# 803 "./libswscale/swscale_internal.h"
extern const uint64_t ff_dither4[2];

# 804 "./libswscale/swscale_internal.h"
extern const uint64_t ff_dither8[2];

# 900 "./libswscale/swscale_internal.h"
typedef struct SwsPlane
{
    int available_lines;
    int sliceY;
    int sliceH;
    uint8_t **line;
    uint8_t **tmp;
} SwsPlane;

# 45 "libswscale/x86/yuv2rgb.c"
/* static */ const uint64_t mmx_00ffw = 0x00ff00ff00ff00ffULL;

# 46 "libswscale/x86/yuv2rgb.c"
/* static */ const uint64_t mmx_redmask = 0xf8f8f8f8f8f8f8f8ULL;

# 48 "libswscale/x86/yuv2rgb.c"
/* static */ const uint64_t pb_e0 = 0xe0e0e0e0e0e0e0e0ULL;

# 50 "libswscale/x86/yuv2rgb.c"
/* static */ const uint64_t pb_03 = 0x0303030303030303ULL;

# 51 "libswscale/x86/yuv2rgb.c"
/* static */ const uint64_t pb_07 = 0x0707070707070707ULL;

# 274 "libswscale/x86/yuv2rgb_template.c"
/* static */ const int16_t mask1101[4] = {-1,-1, 0,-1};

# 275 "libswscale/x86/yuv2rgb_template.c"
/* static */ const int16_t mask0010[4] = { 0, 0,-1, 0};

# 276 "libswscale/x86/yuv2rgb_template.c"
/* static */ const int16_t mask0110[4] = { 0,-1,-1, 0};

# 277 "libswscale/x86/yuv2rgb_template.c"
/* static */ const int16_t mask1001[4] = {-1, 0, 0,-1};

# 278 "libswscale/x86/yuv2rgb_template.c"
/* static */ const int16_t mask0100[4] = { 0,-1, 0, 0};

# 201 "libswscale/x86/yuv2rgb_template.c"
/* static inline */ int yuv420_rgb15_mmx(SwsContext *c, const uint8_t *src[],
                                       int srcStride[],
                                       int srcSliceY, int srcSliceH,
                                       uint8_t *dst[], int dstStride[])
{
    int y, h_size, vshift;

    h_size = (c->dstW + 7) & ~7; if (h_size * 2 > ((dstStride[0]) >= 0 ? (dstStride[0]) : (-(dstStride[0])))) h_size -= 8; vshift = c->srcFormat != AV_PIX_FMT_YUV422P; __asm__ volatile ("pxor %%mm4, %%mm4\n\t":::); for (y = 0; y < srcSliceH; y++) { uint8_t *image = dst[0] + (y + srcSliceY) * dstStride[0]; const uint8_t *py = src[0] + y * srcStride[0]; const uint8_t *pu = src[1] + (y >> vshift) * srcStride[1]; const uint8_t *pv = src[2] + (y >> vshift) * srcStride[2]; x86_reg index = -h_size / 2;


        c->blueDither = ff_dither8[y & 1];
        c->greenDither = ff_dither8[y & 1];
        c->redDither = ff_dither8[(y + 1) & 1];


        __asm__ volatile ( "movq (%5, %0, 2), %%mm6\n\t" "movd    (%2, %0), %%mm0\n\t" "movd    (%3, %0), %%mm1\n\t" "1: \n\t"
        "movq      %%mm6, %%mm7\n\t" "punpcklbw %%mm4, %%mm0\n\t" "punpcklbw %%mm4, %%mm1\n\t" "pand     """ "mmx_00ffw"", %%mm6\n\t" "psrlw     $8,    %%mm7\n\t" "psllw     $3,    %%mm0\n\t" "psllw     $3,    %%mm1\n\t" "psllw     $3,    %%mm6\n\t" "psllw     $3,    %%mm7\n\t" "psubsw   ""9*8""(%4), %%mm0\n\t" "psubsw   ""10*8""(%4), %%mm1\n\t" "psubw    ""8*8""(%4), %%mm6\n\t" "psubw    ""8*8""(%4), %%mm7\n\t" "movq      %%mm0, %%mm2\n\t" "movq      %%mm1, %%mm3\n\t" "pmulhw   ""7*8""(%4), %%mm2\n\t" "pmulhw   ""6*8""(%4), %%mm3\n\t" "pmulhw   ""3*8"" (%4), %%mm6\n\t" "pmulhw   ""3*8"" (%4), %%mm7\n\t" "pmulhw   ""5*8""(%4), %%mm0\n\t" "pmulhw   ""4*8""(%4), %%mm1\n\t" "paddsw    %%mm3, %%mm2\n\t" "movq      %%mm7, %%mm3\n\t" "movq      %%mm7, %%mm5\n\t" "paddsw    %%mm0, %%mm3\n\t" "paddsw    %%mm1, %%mm5\n\t" "paddsw    %%mm2, %%mm7\n\t" "paddsw    %%mm6, %%mm0\n\t" "paddsw    %%mm6, %%mm1\n\t" "paddsw    %%mm6, %%mm2\n\t"
        "packuswb  %%mm1, %%mm0\n\t" "packuswb  %%mm5, %%mm3\n\t" "packuswb  %%mm2, %%mm2\n\t" "movq      %%mm0, %%mm1\n\n" "packuswb  %%mm7, %%mm7\n\t" "punpcklbw %%mm3, %%mm0\n\t" "punpckhbw %%mm3, %%mm1\n\t" "punpcklbw %%mm7, %%mm2\n\t"

        "paddusb ""2*8""(%4),  %%mm0\n\t" "paddusb ""1*8""(%4), %%mm2\n\t" "paddusb ""0*8""(%4),   %%mm1\n\t"

        "pand      """ "mmx_redmask"", %%mm0\n\t" "pand      """ "mmx_redmask"", %%mm1\n\t" "movq      %%mm2,     %%mm3\n\t" "psllw   $""3-1"", %%mm2\n\t" "psrlw   $""5+1"", %%mm3\n\t" "psrlw     $3,        %%mm0\n\t" "psrlw  $1,  %%mm1\n\t" "pand """ "pb_e0"", %%mm2\n\t" "pand """ "pb_03"", %%mm3\n\t" "por       %%mm2,     %%mm0\n\t" "por       %%mm3,     %%mm1\n\t" "movq      %%mm0,     %%mm2\n\t" "punpcklbw %%mm1,     %%mm0\n\t" "punpckhbw %%mm1,     %%mm2\n\t" "movq" "   %%mm0,      (%1)\n\t" "movq" "   %%mm2,     8(%1)\n\t"

    "movq 8 (%5, %0, 2), %%mm6\n\t" "movd 4 (%3, %0),    %%mm1\n\t" "movd 4 (%2, %0),    %%mm0\n\t" "add $""2 * 8"", %1\n\t" "add  $4, %0\n\t" "js   1b\n\t"
    : "+r" (index), "+r" (image) : "r" (pu - index), "r" (pv - index), "r"(&c->redDither), "r" (py - 2*index) : "memory" ); }
    __asm__ volatile (" # nop""\n\t" "emms    \n\t"); return srcSliceH;
}

# 229 "libswscale/x86/yuv2rgb_template.c"
static inline int yuv420_rgb16_mmx(SwsContext *c, const uint8_t *src[],
                                       int srcStride[],
                                       int srcSliceY, int srcSliceH,
                                       uint8_t *dst[], int dstStride[])
{
    int y, h_size, vshift;

    h_size = (c->dstW + 7) & ~7; if (h_size * 2 > ((dstStride[0]) >= 0 ? (dstStride[0]) : (-(dstStride[0])))) h_size -= 8; vshift = c->srcFormat != AV_PIX_FMT_YUV422P; __asm__ volatile ("pxor %%mm4, %%mm4\n\t":::); for (y = 0; y < srcSliceH; y++) { uint8_t *image = dst[0] + (y + srcSliceY) * dstStride[0]; const uint8_t *py = src[0] + y * srcStride[0]; const uint8_t *pu = src[1] + (y >> vshift) * srcStride[1]; const uint8_t *pv = src[2] + (y >> vshift) * srcStride[2]; x86_reg index = -h_size / 2;


        c->blueDither = ff_dither8[y & 1];
        c->greenDither = ff_dither4[y & 1];
        c->redDither = ff_dither8[(y + 1) & 1];


        __asm__ volatile ( "movq (%5, %0, 2), %%mm6\n\t" "movd    (%2, %0), %%mm0\n\t" "movd    (%3, %0), %%mm1\n\t" "1: \n\t"
        "movq      %%mm6, %%mm7\n\t" "punpcklbw %%mm4, %%mm0\n\t" "punpcklbw %%mm4, %%mm1\n\t" "pand     """ "mmx_00ffw"", %%mm6\n\t" "psrlw     $8,    %%mm7\n\t" "psllw     $3,    %%mm0\n\t" "psllw     $3,    %%mm1\n\t" "psllw     $3,    %%mm6\n\t" "psllw     $3,    %%mm7\n\t" "psubsw   ""9*8""(%4), %%mm0\n\t" "psubsw   ""10*8""(%4), %%mm1\n\t" "psubw    ""8*8""(%4), %%mm6\n\t" "psubw    ""8*8""(%4), %%mm7\n\t" "movq      %%mm0, %%mm2\n\t" "movq      %%mm1, %%mm3\n\t" "pmulhw   ""7*8""(%4), %%mm2\n\t" "pmulhw   ""6*8""(%4), %%mm3\n\t" "pmulhw   ""3*8"" (%4), %%mm6\n\t" "pmulhw   ""3*8"" (%4), %%mm7\n\t" "pmulhw   ""5*8""(%4), %%mm0\n\t" "pmulhw   ""4*8""(%4), %%mm1\n\t" "paddsw    %%mm3, %%mm2\n\t" "movq      %%mm7, %%mm3\n\t" "movq      %%mm7, %%mm5\n\t" "paddsw    %%mm0, %%mm3\n\t" "paddsw    %%mm1, %%mm5\n\t" "paddsw    %%mm2, %%mm7\n\t" "paddsw    %%mm6, %%mm0\n\t" "paddsw    %%mm6, %%mm1\n\t" "paddsw    %%mm6, %%mm2\n\t"
        "packuswb  %%mm1, %%mm0\n\t" "packuswb  %%mm5, %%mm3\n\t" "packuswb  %%mm2, %%mm2\n\t" "movq      %%mm0, %%mm1\n\n" "packuswb  %%mm7, %%mm7\n\t" "punpcklbw %%mm3, %%mm0\n\t" "punpckhbw %%mm3, %%mm1\n\t" "punpcklbw %%mm7, %%mm2\n\t"

        "paddusb ""2*8""(%4),  %%mm0\n\t" "paddusb ""1*8""(%4), %%mm2\n\t" "paddusb ""0*8""(%4),   %%mm1\n\t"

        "pand      """ "mmx_redmask"", %%mm0\n\t" "pand      """ "mmx_redmask"", %%mm1\n\t" "movq      %%mm2,     %%mm3\n\t" "psllw   $""3-0"", %%mm2\n\t" "psrlw   $""5+0"", %%mm3\n\t" "psrlw     $3,        %%mm0\n\t" "pand """ "pb_e0"", %%mm2\n\t" "pand """ "pb_07"", %%mm3\n\t" "por       %%mm2,     %%mm0\n\t" "por       %%mm3,     %%mm1\n\t" "movq      %%mm0,     %%mm2\n\t" "punpcklbw %%mm1,     %%mm0\n\t" "punpckhbw %%mm1,     %%mm2\n\t" "movq" "   %%mm0,      (%1)\n\t" "movq" "   %%mm2,     8(%1)\n\t"

    "movq 8 (%5, %0, 2), %%mm6\n\t" "movd 4 (%3, %0),    %%mm1\n\t" "movd 4 (%2, %0),    %%mm0\n\t" "add $""2 * 8"", %1\n\t" "add  $4, %0\n\t" "js   1b\n\t"
    : "+r" (index), "+r" (image) : "r" (pu - index), "r" (pv - index), "r"(&c->redDither), "r" (py - 2*index) : "memory" ); }
    __asm__ volatile (" # nop""\n\t" "emms    \n\t"); return srcSliceH;
}

# 319 "libswscale/x86/yuv2rgb_template.c"
static inline int yuv420_rgb24_mmx(SwsContext *c, const uint8_t *src[],
                                       int srcStride[],
                                       int srcSliceY, int srcSliceH,
                                       uint8_t *dst[], int dstStride[])
{
    int y, h_size, vshift;

    h_size = (c->dstW + 7) & ~7; if (h_size * 3 > ((dstStride[0]) >= 0 ? (dstStride[0]) : (-(dstStride[0])))) h_size -= 8; vshift = c->srcFormat != AV_PIX_FMT_YUV422P; __asm__ volatile ("pxor %%mm4, %%mm4\n\t":::); for (y = 0; y < srcSliceH; y++) { uint8_t *image = dst[0] + (y + srcSliceY) * dstStride[0]; const uint8_t *py = src[0] + y * srcStride[0]; const uint8_t *pu = src[1] + (y >> vshift) * srcStride[1]; const uint8_t *pv = src[2] + (y >> vshift) * srcStride[2]; x86_reg index = -h_size / 2;

        __asm__ volatile ( "movq (%5, %0, 2), %%mm6\n\t" "movd    (%2, %0), %%mm0\n\t" "movd    (%3, %0), %%mm1\n\t" "1: \n\t"
        "movq      %%mm6, %%mm7\n\t" "punpcklbw %%mm4, %%mm0\n\t" "punpcklbw %%mm4, %%mm1\n\t" "pand     """ "mmx_00ffw"", %%mm6\n\t" "psrlw     $8,    %%mm7\n\t" "psllw     $3,    %%mm0\n\t" "psllw     $3,    %%mm1\n\t" "psllw     $3,    %%mm6\n\t" "psllw     $3,    %%mm7\n\t" "psubsw   ""9*8""(%4), %%mm0\n\t" "psubsw   ""10*8""(%4), %%mm1\n\t" "psubw    ""8*8""(%4), %%mm6\n\t" "psubw    ""8*8""(%4), %%mm7\n\t" "movq      %%mm0, %%mm2\n\t" "movq      %%mm1, %%mm3\n\t" "pmulhw   ""7*8""(%4), %%mm2\n\t" "pmulhw   ""6*8""(%4), %%mm3\n\t" "pmulhw   ""3*8"" (%4), %%mm6\n\t" "pmulhw   ""3*8"" (%4), %%mm7\n\t" "pmulhw   ""5*8""(%4), %%mm0\n\t" "pmulhw   ""4*8""(%4), %%mm1\n\t" "paddsw    %%mm3, %%mm2\n\t" "movq      %%mm7, %%mm3\n\t" "movq      %%mm7, %%mm5\n\t" "paddsw    %%mm0, %%mm3\n\t" "paddsw    %%mm1, %%mm5\n\t" "paddsw    %%mm2, %%mm7\n\t" "paddsw    %%mm6, %%mm0\n\t" "paddsw    %%mm6, %%mm1\n\t" "paddsw    %%mm6, %%mm2\n\t"
        "packuswb  %%mm3,      %%mm0 \n" "packuswb  %%mm5,      %%mm1 \n" "packuswb  %%mm7,      %%mm2 \n" "movq      %%mm""1"",  %%mm3 \n" "movq      %%mm""0"", %%mm6 \n" "psrlq     $32,        %%mm""1"" \n" "punpcklbw %%mm2,      %%mm3 \n" "punpcklbw %%mm""1"",  %%mm6 \n" "movq      %%mm3,      %%mm5 \n" "punpckhbw %%mm""0"", %%mm2 \n" "punpcklwd %%mm6,      %%mm3 \n" "punpckhwd %%mm6,      %%mm5 \n" "movd      %%mm3,       (%1) \n" "movd      %%mm2,      4(%1) \n" "psrlq     $32,        %%mm3 \n" "psrlq     $16,        %%mm2 \n" "movd      %%mm3,      6(%1) \n" "movd      %%mm2,     10(%1) \n" "psrlq     $16,        %%mm2 \n" "movd      %%mm5,     12(%1) \n" "movd      %%mm2,     16(%1) \n" "psrlq     $32,        %%mm5 \n" "movd      %%mm2,     20(%1) \n" "movd      %%mm5,     18(%1) \n"

    "movq 8 (%5, %0, 2), %%mm6\n\t" "movd 4 (%3, %0),    %%mm1\n\t" "movd 4 (%2, %0),    %%mm0\n\t" "add $""3 * 8"", %1\n\t" "add  $4, %0\n\t" "js   1b\n\t"
    : "+r" (index), "+r" (image) : "r" (pu - index), "r" (pv - index), "r"(&c->redDither), "r" (py - 2*index) : "memory" ); }
    __asm__ volatile (" # nop""\n\t" "emms    \n\t"); return srcSliceH;
}

# 337 "libswscale/x86/yuv2rgb_template.c"
static inline int yuv420_bgr24_mmx(SwsContext *c, const uint8_t *src[],
                                       int srcStride[],
                                       int srcSliceY, int srcSliceH,
                                       uint8_t *dst[], int dstStride[])
{
    int y, h_size, vshift;

    h_size = (c->dstW + 7) & ~7; if (h_size * 3 > ((dstStride[0]) >= 0 ? (dstStride[0]) : (-(dstStride[0])))) h_size -= 8; vshift = c->srcFormat != AV_PIX_FMT_YUV422P; __asm__ volatile ("pxor %%mm4, %%mm4\n\t":::); for (y = 0; y < srcSliceH; y++) { uint8_t *image = dst[0] + (y + srcSliceY) * dstStride[0]; const uint8_t *py = src[0] + y * srcStride[0]; const uint8_t *pu = src[1] + (y >> vshift) * srcStride[1]; const uint8_t *pv = src[2] + (y >> vshift) * srcStride[2]; x86_reg index = -h_size / 2;

        __asm__ volatile ( "movq (%5, %0, 2), %%mm6\n\t" "movd    (%2, %0), %%mm0\n\t" "movd    (%3, %0), %%mm1\n\t" "1: \n\t"
        "movq      %%mm6, %%mm7\n\t" "punpcklbw %%mm4, %%mm0\n\t" "punpcklbw %%mm4, %%mm1\n\t" "pand     """ "mmx_00ffw"", %%mm6\n\t" "psrlw     $8,    %%mm7\n\t" "psllw     $3,    %%mm0\n\t" "psllw     $3,    %%mm1\n\t" "psllw     $3,    %%mm6\n\t" "psllw     $3,    %%mm7\n\t" "psubsw   ""9*8""(%4), %%mm0\n\t" "psubsw   ""10*8""(%4), %%mm1\n\t" "psubw    ""8*8""(%4), %%mm6\n\t" "psubw    ""8*8""(%4), %%mm7\n\t" "movq      %%mm0, %%mm2\n\t" "movq      %%mm1, %%mm3\n\t" "pmulhw   ""7*8""(%4), %%mm2\n\t" "pmulhw   ""6*8""(%4), %%mm3\n\t" "pmulhw   ""3*8"" (%4), %%mm6\n\t" "pmulhw   ""3*8"" (%4), %%mm7\n\t" "pmulhw   ""5*8""(%4), %%mm0\n\t" "pmulhw   ""4*8""(%4), %%mm1\n\t" "paddsw    %%mm3, %%mm2\n\t" "movq      %%mm7, %%mm3\n\t" "movq      %%mm7, %%mm5\n\t" "paddsw    %%mm0, %%mm3\n\t" "paddsw    %%mm1, %%mm5\n\t" "paddsw    %%mm2, %%mm7\n\t" "paddsw    %%mm6, %%mm0\n\t" "paddsw    %%mm6, %%mm1\n\t" "paddsw    %%mm6, %%mm2\n\t"
        "packuswb  %%mm3,      %%mm0 \n" "packuswb  %%mm5,      %%mm1 \n" "packuswb  %%mm7,      %%mm2 \n" "movq      %%mm""0"",  %%mm3 \n" "movq      %%mm""1"", %%mm6 \n" "psrlq     $32,        %%mm""0"" \n" "punpcklbw %%mm2,      %%mm3 \n" "punpcklbw %%mm""0"",  %%mm6 \n" "movq      %%mm3,      %%mm5 \n" "punpckhbw %%mm""1"", %%mm2 \n" "punpcklwd %%mm6,      %%mm3 \n" "punpckhwd %%mm6,      %%mm5 \n" "movd      %%mm3,       (%1) \n" "movd      %%mm2,      4(%1) \n" "psrlq     $32,        %%mm3 \n" "psrlq     $16,        %%mm2 \n" "movd      %%mm3,      6(%1) \n" "movd      %%mm2,     10(%1) \n" "psrlq     $16,        %%mm2 \n" "movd      %%mm5,     12(%1) \n" "movd      %%mm2,     16(%1) \n" "psrlq     $32,        %%mm5 \n" "movd      %%mm2,     20(%1) \n" "movd      %%mm5,     18(%1) \n"

    "movq 8 (%5, %0, 2), %%mm6\n\t" "movd 4 (%3, %0),    %%mm1\n\t" "movd 4 (%2, %0),    %%mm0\n\t" "add $""3 * 8"", %1\n\t" "add  $4, %0\n\t" "js   1b\n\t"
    : "+r" (index), "+r" (image) : "r" (pu - index), "r" (pv - index), "r"(&c->redDither), "r" (py - 2*index) : "memory" ); }
    __asm__ volatile (" # nop""\n\t" "emms    \n\t"); return srcSliceH;
}

# 381 "libswscale/x86/yuv2rgb_template.c"
static inline int yuv420_rgb32_mmx(SwsContext *c, const uint8_t *src[],
                                       int srcStride[],
                                       int srcSliceY, int srcSliceH,
                                       uint8_t *dst[], int dstStride[])
{
    int y, h_size, vshift;

    h_size = (c->dstW + 7) & ~7; if (h_size * 4 > ((dstStride[0]) >= 0 ? (dstStride[0]) : (-(dstStride[0])))) h_size -= 8; vshift = c->srcFormat != AV_PIX_FMT_YUV422P; __asm__ volatile ("pxor %%mm4, %%mm4\n\t":::); for (y = 0; y < srcSliceH; y++) { uint8_t *image = dst[0] + (y + srcSliceY) * dstStride[0]; const uint8_t *py = src[0] + y * srcStride[0]; const uint8_t *pu = src[1] + (y >> vshift) * srcStride[1]; const uint8_t *pv = src[2] + (y >> vshift) * srcStride[2]; x86_reg index = -h_size / 2;

        __asm__ volatile ( "movq (%5, %0, 2), %%mm6\n\t" "movd    (%2, %0), %%mm0\n\t" "movd    (%3, %0), %%mm1\n\t" "1: \n\t"
        "movq      %%mm6, %%mm7\n\t" "punpcklbw %%mm4, %%mm0\n\t" "punpcklbw %%mm4, %%mm1\n\t" "pand     """ "mmx_00ffw"", %%mm6\n\t" "psrlw     $8,    %%mm7\n\t" "psllw     $3,    %%mm0\n\t" "psllw     $3,    %%mm1\n\t" "psllw     $3,    %%mm6\n\t" "psllw     $3,    %%mm7\n\t" "psubsw   ""9*8""(%4), %%mm0\n\t" "psubsw   ""10*8""(%4), %%mm1\n\t" "psubw    ""8*8""(%4), %%mm6\n\t" "psubw    ""8*8""(%4), %%mm7\n\t" "movq      %%mm0, %%mm2\n\t" "movq      %%mm1, %%mm3\n\t" "pmulhw   ""7*8""(%4), %%mm2\n\t" "pmulhw   ""6*8""(%4), %%mm3\n\t" "pmulhw   ""3*8"" (%4), %%mm6\n\t" "pmulhw   ""3*8"" (%4), %%mm7\n\t" "pmulhw   ""5*8""(%4), %%mm0\n\t" "pmulhw   ""4*8""(%4), %%mm1\n\t" "paddsw    %%mm3, %%mm2\n\t" "movq      %%mm7, %%mm3\n\t" "movq      %%mm7, %%mm5\n\t" "paddsw    %%mm0, %%mm3\n\t" "paddsw    %%mm1, %%mm5\n\t" "paddsw    %%mm2, %%mm7\n\t" "paddsw    %%mm6, %%mm0\n\t" "paddsw    %%mm6, %%mm1\n\t" "paddsw    %%mm6, %%mm2\n\t"
        "packuswb  %%mm1, %%mm0\n\t" "packuswb  %%mm5, %%mm3\n\t" "packuswb  %%mm2, %%mm2\n\t" "movq      %%mm0, %%mm1\n\n" "packuswb  %%mm7, %%mm7\n\t" "punpcklbw %%mm3, %%mm0\n\t" "punpckhbw %%mm3, %%mm1\n\t" "punpcklbw %%mm7, %%mm2\n\t"
        "pcmpeqd   %%mm""3"", %%mm""3""\n\t"
        "movq      %%mm""0"",  %%mm5\n\t" "movq      %%mm""1"",   %%mm6\n\t" "punpckhbw %%mm""2"", %%mm5\n\t" "punpcklbw %%mm""2"", %%mm""0""\n\t" "punpckhbw %%mm""3"", %%mm6\n\t" "punpcklbw %%mm""3"", %%mm""1""\n\t" "movq      %%mm""0"",  %%mm""2""\n\t" "movq      %%mm5,       %%mm""3""\n\t" "punpcklwd %%mm""1"",   %%mm""0""\n\t" "punpckhwd %%mm""1"",   %%mm""2""\n\t" "punpcklwd %%mm6,       %%mm5\n\t" "punpckhwd %%mm6,       %%mm""3""\n\t" "movq" "   %%mm""0"",   0(%1)\n\t" "movq" "   %%mm""2"",  8(%1)\n\t" "movq" "   %%mm5,       16(%1)\n\t" "movq" "   %%mm""3"", 24(%1)\n\t"

    "movq 8 (%5, %0, 2), %%mm6\n\t" "movd 4 (%3, %0),    %%mm1\n\t" "movd 4 (%2, %0),    %%mm0\n\t" "add $""4 * 8"", %1\n\t" "add  $4, %0\n\t" "js   1b\n\t"
    : "+r" (index), "+r" (image) : "r" (pu - index), "r" (pv - index), "r"(&c->redDither), "r" (py - 2*index) : "memory" ); }
    __asm__ volatile (" # nop""\n\t" "emms    \n\t"); return srcSliceH;
}

# 319 "libswscale/x86/yuv2rgb_template.c"
static inline int yuv420_rgb24_mmxext(SwsContext *c, const uint8_t *src[],
                                       int srcStride[],
                                       int srcSliceY, int srcSliceH,
                                       uint8_t *dst[], int dstStride[])
{
    int y, h_size, vshift;

    h_size = (c->dstW + 7) & ~7; if (h_size * 3 > ((dstStride[0]) >= 0 ? (dstStride[0]) : (-(dstStride[0])))) h_size -= 8; vshift = c->srcFormat != AV_PIX_FMT_YUV422P; __asm__ volatile ("pxor %%mm4, %%mm4\n\t":::); for (y = 0; y < srcSliceH; y++) { uint8_t *image = dst[0] + (y + srcSliceY) * dstStride[0]; const uint8_t *py = src[0] + y * srcStride[0]; const uint8_t *pu = src[1] + (y >> vshift) * srcStride[1]; const uint8_t *pv = src[2] + (y >> vshift) * srcStride[2]; x86_reg index = -h_size / 2;

        __asm__ volatile ( "movq (%5, %0, 2), %%mm6\n\t" "movd    (%2, %0), %%mm0\n\t" "movd    (%3, %0), %%mm1\n\t" "1: \n\t"
        "movq      %%mm6, %%mm7\n\t" "punpcklbw %%mm4, %%mm0\n\t" "punpcklbw %%mm4, %%mm1\n\t" "pand     """ "mmx_00ffw"", %%mm6\n\t" "psrlw     $8,    %%mm7\n\t" "psllw     $3,    %%mm0\n\t" "psllw     $3,    %%mm1\n\t" "psllw     $3,    %%mm6\n\t" "psllw     $3,    %%mm7\n\t" "psubsw   ""9*8""(%4), %%mm0\n\t" "psubsw   ""10*8""(%4), %%mm1\n\t" "psubw    ""8*8""(%4), %%mm6\n\t" "psubw    ""8*8""(%4), %%mm7\n\t" "movq      %%mm0, %%mm2\n\t" "movq      %%mm1, %%mm3\n\t" "pmulhw   ""7*8""(%4), %%mm2\n\t" "pmulhw   ""6*8""(%4), %%mm3\n\t" "pmulhw   ""3*8"" (%4), %%mm6\n\t" "pmulhw   ""3*8"" (%4), %%mm7\n\t" "pmulhw   ""5*8""(%4), %%mm0\n\t" "pmulhw   ""4*8""(%4), %%mm1\n\t" "paddsw    %%mm3, %%mm2\n\t" "movq      %%mm7, %%mm3\n\t" "movq      %%mm7, %%mm5\n\t" "paddsw    %%mm0, %%mm3\n\t" "paddsw    %%mm1, %%mm5\n\t" "paddsw    %%mm2, %%mm7\n\t" "paddsw    %%mm6, %%mm0\n\t" "paddsw    %%mm6, %%mm1\n\t" "paddsw    %%mm6, %%mm2\n\t"
        "packuswb  %%mm3,      %%mm0 \n" "packuswb  %%mm5,      %%mm1 \n" "packuswb  %%mm7,      %%mm2 \n" "movq      %%mm""1"",  %%mm3 \n" "movq      %%mm""0"", %%mm6 \n" "psrlq     $32,        %%mm""1"" \n" "punpcklbw %%mm2,      %%mm3 \n" "punpcklbw %%mm""1"",  %%mm6 \n" "movq      %%mm3,      %%mm5 \n" "punpckhbw %%mm""0"", %%mm2 \n" "punpcklwd %%mm6,      %%mm3 \n" "punpckhwd %%mm6,      %%mm5 \n" "pshufw    $0xc6,  %%mm2, %%mm1 \n" "pshufw    $0x84,  %%mm3, %%mm6 \n" "pshufw    $0x38,  %%mm5, %%mm7 \n" "pand """ "mask1101"", %%mm6 \n" "movq      %%mm1,         %%mm0 \n" "pand """ "mask0110"", %%mm7 \n" "movq      %%mm1,         %%mm2 \n" "pand """ "mask0100"", %%mm1 \n" "psrlq       $48,         %%mm3 \n" "pand """ "mask0010"", %%mm0 \n" "psllq       $32,         %%mm5 \n" "pand """ "mask1001"", %%mm2 \n" "por       %%mm3,         %%mm1 \n" "por       %%mm6,         %%mm0 \n" "por       %%mm5,         %%mm1 \n" "por       %%mm7,         %%mm2 \n" "movntq""    %%mm0,          (%1) \n" "movntq""    %%mm1,         8(%1) \n" "movntq""    %%mm2,        16(%1) \n"

    "movq 8 (%5, %0, 2), %%mm6\n\t" "movd 4 (%3, %0),    %%mm1\n\t" "movd 4 (%2, %0),    %%mm0\n\t" "add $""3 * 8"", %1\n\t" "add  $4, %0\n\t" "js   1b\n\t"
    : "+r" (index), "+r" (image) : "r" (pu - index), "r" (pv - index), "r"(&c->redDither), "r" (py - 2*index) : "memory" ); }
    __asm__ volatile ("sfence""\n\t" "emms    \n\t"); return srcSliceH;
}

# 337 "libswscale/x86/yuv2rgb_template.c"
static inline int yuv420_bgr24_mmxext(SwsContext *c, const uint8_t *src[],
                                       int srcStride[],
                                       int srcSliceY, int srcSliceH,
                                       uint8_t *dst[], int dstStride[])
{
    int y, h_size, vshift;

    h_size = (c->dstW + 7) & ~7; if (h_size * 3 > ((dstStride[0]) >= 0 ? (dstStride[0]) : (-(dstStride[0])))) h_size -= 8; vshift = c->srcFormat != AV_PIX_FMT_YUV422P; __asm__ volatile ("pxor %%mm4, %%mm4\n\t":::); for (y = 0; y < srcSliceH; y++) { uint8_t *image = dst[0] + (y + srcSliceY) * dstStride[0]; const uint8_t *py = src[0] + y * srcStride[0]; const uint8_t *pu = src[1] + (y >> vshift) * srcStride[1]; const uint8_t *pv = src[2] + (y >> vshift) * srcStride[2]; x86_reg index = -h_size / 2;

        __asm__ volatile ( "movq (%5, %0, 2), %%mm6\n\t" "movd    (%2, %0), %%mm0\n\t" "movd    (%3, %0), %%mm1\n\t" "1: \n\t"
        "movq      %%mm6, %%mm7\n\t" "punpcklbw %%mm4, %%mm0\n\t" "punpcklbw %%mm4, %%mm1\n\t" "pand     """ "mmx_00ffw"", %%mm6\n\t" "psrlw     $8,    %%mm7\n\t" "psllw     $3,    %%mm0\n\t" "psllw     $3,    %%mm1\n\t" "psllw     $3,    %%mm6\n\t" "psllw     $3,    %%mm7\n\t" "psubsw   ""9*8""(%4), %%mm0\n\t" "psubsw   ""10*8""(%4), %%mm1\n\t" "psubw    ""8*8""(%4), %%mm6\n\t" "psubw    ""8*8""(%4), %%mm7\n\t" "movq      %%mm0, %%mm2\n\t" "movq      %%mm1, %%mm3\n\t" "pmulhw   ""7*8""(%4), %%mm2\n\t" "pmulhw   ""6*8""(%4), %%mm3\n\t" "pmulhw   ""3*8"" (%4), %%mm6\n\t" "pmulhw   ""3*8"" (%4), %%mm7\n\t" "pmulhw   ""5*8""(%4), %%mm0\n\t" "pmulhw   ""4*8""(%4), %%mm1\n\t" "paddsw    %%mm3, %%mm2\n\t" "movq      %%mm7, %%mm3\n\t" "movq      %%mm7, %%mm5\n\t" "paddsw    %%mm0, %%mm3\n\t" "paddsw    %%mm1, %%mm5\n\t" "paddsw    %%mm2, %%mm7\n\t" "paddsw    %%mm6, %%mm0\n\t" "paddsw    %%mm6, %%mm1\n\t" "paddsw    %%mm6, %%mm2\n\t"
        "packuswb  %%mm3,      %%mm0 \n" "packuswb  %%mm5,      %%mm1 \n" "packuswb  %%mm7,      %%mm2 \n" "movq      %%mm""0"",  %%mm3 \n" "movq      %%mm""1"", %%mm6 \n" "psrlq     $32,        %%mm""0"" \n" "punpcklbw %%mm2,      %%mm3 \n" "punpcklbw %%mm""0"",  %%mm6 \n" "movq      %%mm3,      %%mm5 \n" "punpckhbw %%mm""1"", %%mm2 \n" "punpcklwd %%mm6,      %%mm3 \n" "punpckhwd %%mm6,      %%mm5 \n" "pshufw    $0xc6,  %%mm2, %%mm1 \n" "pshufw    $0x84,  %%mm3, %%mm6 \n" "pshufw    $0x38,  %%mm5, %%mm7 \n" "pand """ "mask1101"", %%mm6 \n" "movq      %%mm1,         %%mm0 \n" "pand """ "mask0110"", %%mm7 \n" "movq      %%mm1,         %%mm2 \n" "pand """ "mask0100"", %%mm1 \n" "psrlq       $48,         %%mm3 \n" "pand """ "mask0010"", %%mm0 \n" "psllq       $32,         %%mm5 \n" "pand """ "mask1001"", %%mm2 \n" "por       %%mm3,         %%mm1 \n" "por       %%mm6,         %%mm0 \n" "por       %%mm5,         %%mm1 \n" "por       %%mm7,         %%mm2 \n" "movntq""    %%mm0,          (%1) \n" "movntq""    %%mm1,         8(%1) \n" "movntq""    %%mm2,        16(%1) \n"

    "movq 8 (%5, %0, 2), %%mm6\n\t" "movd 4 (%3, %0),    %%mm1\n\t" "movd 4 (%2, %0),    %%mm0\n\t" "add $""3 * 8"", %1\n\t" "add  $4, %0\n\t" "js   1b\n\t"
    : "+r" (index), "+r" (image) : "r" (pu - index), "r" (pv - index), "r"(&c->redDither), "r" (py - 2*index) : "memory" ); }
    __asm__ volatile ("sfence""\n\t" "emms    \n\t"); return srcSliceH;
}

# 234 "libavutil/log.h"
void av_log(void *avcl, int level, const char *fmt, ...);

# 149 "libavutil/utils.c"
void av_assert0_fpu(void) {

    uint16_t state[14];
     __asm__ volatile (
        "fstenv %0 \n\t"
        : "+m" (state)
        :
        : "memory"
    );
    do { if (!((state[4] & 3) == 3)) { av_log(((void*)0), 0, "Assertion %s failed at %s:%d\n", "(state[4] & 3) == 3", "libavutil/utils.c", 158); abort(); } } while (0);

}

# 35 "libavcodec/x86/mpegvideoenc_qns_template.c"
static int try_8x8basis_mmx(int16_t rem[64], int16_t weight[64], int16_t basis[64], int scale)
{
    x86_reg i=0;

    ((void)0);
    scale<<= 16 + 1 - 16 + 6;

    __asm__ volatile ( "pcmpeqd %%" "mm6" ", %%" "mm6" " \n\t" "psrlw $15, %%" "mm6" ::);
    __asm__ volatile(
        "pxor %%mm7, %%mm7              \n\t"
        "movd  %4, %%mm5                \n\t"
        "punpcklwd %%mm5, %%mm5         \n\t"
        "punpcklwd %%mm5, %%mm5         \n\t"
        ".p2align 4                     \n\t"
        "1:                             \n\t"
        "movq  (%1, %0), %%mm0          \n\t"
        "movq  8(%1, %0), %%mm1         \n\t"
        "pmulhw " "%%mm5" ", " "%%mm0" "              \n\t" "pmulhw " "%%mm5" ", " "%%mm1" "              \n\t" "paddw  " "%%mm6" ", " "%%mm0" "              \n\t" "paddw  " "%%mm6" ", " "%%mm1" "              \n\t" "psraw      $1, " "%%mm0" "              \n\t" "psraw      $1, " "%%mm1" "              \n\t"
        "paddw (%2, %0), %%mm0          \n\t"
        "paddw 8(%2, %0), %%mm1         \n\t"
        "psraw $6, %%mm0                \n\t"
        "psraw $6, %%mm1                \n\t"
        "pmullw (%3, %0), %%mm0         \n\t"
        "pmullw 8(%3, %0), %%mm1        \n\t"
        "pmaddwd %%mm0, %%mm0           \n\t"
        "pmaddwd %%mm1, %%mm1           \n\t"
        "paddd %%mm1, %%mm0             \n\t"
        "psrld $4, %%mm0                \n\t"
        "paddd %%mm0, %%mm7             \n\t"
        "add $16, %0                    \n\t"
        "cmp $128, %0                   \n\t"
        " jb 1b                         \n\t"
        "movq  " "%%mm7" ", " "%%mm6" "               \n\t" "psrlq    $32, " "%%mm7" "               \n\t" "paddd " "%%mm6" ", " "%%mm7" "               \n\t"
        "psrld $2, %%mm7                \n\t"
        "movd %%mm7, %0                 \n\t"

        : "+r" (i)
        : "r"(basis), "r"(rem), "r"(weight), "g"(scale)
    );
    return i;
}

# 77 "libavcodec/x86/mpegvideoenc_qns_template.c"
static void add_8x8basis_mmx(int16_t rem[64], int16_t basis[64], int scale)
{
    x86_reg i=0;

    if(((scale) >= 0 ? (scale) : (-(scale))) < (512 >> (1>0 ? 1 : 0))){
        scale<<= 16 + 1 - 16 + 6;
        __asm__ volatile ( "pcmpeqd %%" "mm6" ", %%" "mm6" " \n\t" "psrlw $15, %%" "mm6" ::);
        __asm__ volatile(
                "movd  %3, %%mm5        \n\t"
                "punpcklwd %%mm5, %%mm5 \n\t"
                "punpcklwd %%mm5, %%mm5 \n\t"
                ".p2align 4             \n\t"
                "1:                     \n\t"
                "movq  (%1, %0), %%mm0  \n\t"
                "movq  8(%1, %0), %%mm1 \n\t"
                "pmulhw " "%%mm5" ", " "%%mm0" "              \n\t" "pmulhw " "%%mm5" ", " "%%mm1" "              \n\t" "paddw  " "%%mm6" ", " "%%mm0" "              \n\t" "paddw  " "%%mm6" ", " "%%mm1" "              \n\t" "psraw      $1, " "%%mm0" "              \n\t" "psraw      $1, " "%%mm1" "              \n\t"
                "paddw (%2, %0), %%mm0  \n\t"
                "paddw 8(%2, %0), %%mm1 \n\t"
                "movq %%mm0, (%2, %0)   \n\t"
                "movq %%mm1, 8(%2, %0)  \n\t"
                "add $16, %0            \n\t"
                "cmp $128, %0           \n\t"
                " jb 1b                 \n\t"

                : "+r" (i)
                : "r"(basis), "r"(rem), "g"(scale)
        );
    }else{
        for(i=0; i<8*8; i++){
            rem[i] += (basis[i]*scale + (1<<(16 - 6 -1)))>>(16 - 6);
        }
    }
}

# 35 "libavcodec/x86/mpegvideoenc_qns_template.c"
static int try_8x8basis_3dnow(int16_t rem[64], int16_t weight[64], int16_t basis[64], int scale)
{
    x86_reg i=0;

    ((void)0);
    scale<<= 16 + 0 - 16 + 6;

    ;
    __asm__ volatile(
        "pxor %%mm7, %%mm7              \n\t"
        "movd  %4, %%mm5                \n\t"
        "punpcklwd %%mm5, %%mm5         \n\t"
        "punpcklwd %%mm5, %%mm5         \n\t"
        ".p2align 4                     \n\t"
        "1:                             \n\t"
        "movq  (%1, %0), %%mm0          \n\t"
        "movq  8(%1, %0), %%mm1         \n\t"
        "pmulhrw " "%%mm5" ", " "%%mm0" "             \n\t" "pmulhrw " "%%mm5" ", " "%%mm1" "             \n\t"
        "paddw (%2, %0), %%mm0          \n\t"
        "paddw 8(%2, %0), %%mm1         \n\t"
        "psraw $6, %%mm0                \n\t"
        "psraw $6, %%mm1                \n\t"
        "pmullw (%3, %0), %%mm0         \n\t"
        "pmullw 8(%3, %0), %%mm1        \n\t"
        "pmaddwd %%mm0, %%mm0           \n\t"
        "pmaddwd %%mm1, %%mm1           \n\t"
        "paddd %%mm1, %%mm0             \n\t"
        "psrld $4, %%mm0                \n\t"
        "paddd %%mm0, %%mm7             \n\t"
        "add $16, %0                    \n\t"
        "cmp $128, %0                   \n\t"
        " jb 1b                         \n\t"
        "movq  " "%%mm7" ", " "%%mm6" "               \n\t" "psrlq    $32, " "%%mm7" "               \n\t" "paddd " "%%mm6" ", " "%%mm7" "               \n\t"
        "psrld $2, %%mm7                \n\t"
        "movd %%mm7, %0                 \n\t"

        : "+r" (i)
        : "r"(basis), "r"(rem), "r"(weight), "g"(scale)
    );
    return i;
}

# 77 "libavcodec/x86/mpegvideoenc_qns_template.c"
static void add_8x8basis_3dnow(int16_t rem[64], int16_t basis[64], int scale)
{
    x86_reg i=0;

    if(((scale) >= 0 ? (scale) : (-(scale))) < (512 >> (0>0 ? 0 : 0))){
        scale<<= 16 + 0 - 16 + 6;
        ;
        __asm__ volatile(
                "movd  %3, %%mm5        \n\t"
                "punpcklwd %%mm5, %%mm5 \n\t"
                "punpcklwd %%mm5, %%mm5 \n\t"
                ".p2align 4             \n\t"
                "1:                     \n\t"
                "movq  (%1, %0), %%mm0  \n\t"
                "movq  8(%1, %0), %%mm1 \n\t"
                "pmulhrw " "%%mm5" ", " "%%mm0" "             \n\t" "pmulhrw " "%%mm5" ", " "%%mm1" "             \n\t"
                "paddw (%2, %0), %%mm0  \n\t"
                "paddw 8(%2, %0), %%mm1 \n\t"
                "movq %%mm0, (%2, %0)   \n\t"
                "movq %%mm1, 8(%2, %0)  \n\t"
                "add $16, %0            \n\t"
                "cmp $128, %0           \n\t"
                " jb 1b                 \n\t"

                : "+r" (i)
                : "r"(basis), "r"(rem), "g"(scale)
        );
    }else{
        for(i=0; i<8*8; i++){
            rem[i] += (basis[i]*scale + (1<<(16 - 6 -1)))>>(16 - 6);
        }
    }
}

# 35 "libavcodec/x86/mpegvideoenc_qns_template.c"
static int try_8x8basis_ssse3(int16_t rem[64], int16_t weight[64], int16_t basis[64], int scale)
{
    x86_reg i=0;

    ((void)0);
    scale<<= 16 + -1 - 16 + 6;

    ;
    __asm__ volatile(
        "pxor %%mm7, %%mm7              \n\t"
        "movd  %4, %%mm5                \n\t"
        "punpcklwd %%mm5, %%mm5         \n\t"
        "punpcklwd %%mm5, %%mm5         \n\t"
        ".p2align 4                     \n\t"
        "1:                             \n\t"
        "movq  (%1, %0), %%mm0          \n\t"
        "movq  8(%1, %0), %%mm1         \n\t"
        "pmulhrsw " "%%mm5" ", " "%%mm0" "            \n\t" "pmulhrsw " "%%mm5" ", " "%%mm1" "            \n\t"
        "paddw (%2, %0), %%mm0          \n\t"
        "paddw 8(%2, %0), %%mm1         \n\t"
        "psraw $6, %%mm0                \n\t"
        "psraw $6, %%mm1                \n\t"
        "pmullw (%3, %0), %%mm0         \n\t"
        "pmullw 8(%3, %0), %%mm1        \n\t"
        "pmaddwd %%mm0, %%mm0           \n\t"
        "pmaddwd %%mm1, %%mm1           \n\t"
        "paddd %%mm1, %%mm0             \n\t"
        "psrld $4, %%mm0                \n\t"
        "paddd %%mm0, %%mm7             \n\t"
        "add $16, %0                    \n\t"
        "cmp $128, %0                   \n\t"
        " jb 1b                         \n\t"
        "pshufw $0x0E, " "%%mm7" ", " "%%mm6" "       \n\t" "paddd " "%%mm6" ", " "%%mm7" "               \n\t"
        "psrld $2, %%mm7                \n\t"
        "movd %%mm7, %0                 \n\t"

        : "+r" (i)
        : "r"(basis), "r"(rem), "r"(weight), "g"(scale)
    );
    return i;
}

# 77 "libavcodec/x86/mpegvideoenc_qns_template.c"
static void add_8x8basis_ssse3(int16_t rem[64], int16_t basis[64], int scale)
{
    x86_reg i=0;

    if(((scale) >= 0 ? (scale) : (-(scale))) < (512 >> (-1>0 ? -1 : 0))){
        scale<<= 16 + -1 - 16 + 6;
        ;
        __asm__ volatile(
                "movd  %3, %%mm5        \n\t"
                "punpcklwd %%mm5, %%mm5 \n\t"
                "punpcklwd %%mm5, %%mm5 \n\t"
                ".p2align 4             \n\t"
                "1:                     \n\t"
                "movq  (%1, %0), %%mm0  \n\t"
                "movq  8(%1, %0), %%mm1 \n\t"
                "pmulhrsw " "%%mm5" ", " "%%mm0" "            \n\t" "pmulhrsw " "%%mm5" ", " "%%mm1" "            \n\t"
                "paddw (%2, %0), %%mm0  \n\t"
                "paddw 8(%2, %0), %%mm1 \n\t"
                "movq %%mm0, (%2, %0)   \n\t"
                "movq %%mm1, 8(%2, %0)  \n\t"
                "add $16, %0            \n\t"
                "cmp $128, %0           \n\t"
                " jb 1b                 \n\t"

                : "+r" (i)
                : "r"(basis), "r"(rem), "g"(scale)
        );
    }else{
        for(i=0; i<8*8; i++){
            rem[i] += (basis[i]*scale + (1<<(16 - 6 -1)))>>(16 - 6);
        }
    }
}

# 103 "libavcodec/x86/mpegvideoencdsp_init.c"
static void draw_edges_mmx(uint8_t *buf, int wrap, int width, int height,
                           int w, int h, int sides)
{
    uint8_t *ptr, *last_line;
    int i;

    last_line = buf + (height - 1) * wrap;

    ptr = buf;
    if (w == 8) {
        __asm__ volatile (
            "1:                             \n\t"
            "movd            (%0), %%mm0    \n\t"
            "punpcklbw      %%mm0, %%mm0    \n\t"
            "punpcklwd      %%mm0, %%mm0    \n\t"
            "punpckldq      %%mm0, %%mm0    \n\t"
            "movq           %%mm0, -8(%0)   \n\t"
            "movq      -8(%0, %2), %%mm1    \n\t"
            "punpckhbw      %%mm1, %%mm1    \n\t"
            "punpckhwd      %%mm1, %%mm1    \n\t"
            "punpckhdq      %%mm1, %%mm1    \n\t"
            "movq           %%mm1, (%0, %2) \n\t"
            "add               %1, %0       \n\t"
            "cmp               %3, %0       \n\t"
            "jb                1b           \n\t"
            : "+r" (ptr)
            : "r" ((x86_reg) wrap), "r" ((x86_reg) width),
              "r" (ptr + wrap * height));
    } else if (w == 16) {
        __asm__ volatile (
            "1:                                 \n\t"
            "movd            (%0), %%mm0        \n\t"
            "punpcklbw      %%mm0, %%mm0        \n\t"
            "punpcklwd      %%mm0, %%mm0        \n\t"
            "punpckldq      %%mm0, %%mm0        \n\t"
            "movq           %%mm0, -8(%0)       \n\t"
            "movq           %%mm0, -16(%0)      \n\t"
            "movq      -8(%0, %2), %%mm1        \n\t"
            "punpckhbw      %%mm1, %%mm1        \n\t"
            "punpckhwd      %%mm1, %%mm1        \n\t"
            "punpckhdq      %%mm1, %%mm1        \n\t"
            "movq           %%mm1,  (%0, %2)    \n\t"
            "movq           %%mm1, 8(%0, %2)    \n\t"
            "add               %1, %0           \n\t"
            "cmp               %3, %0           \n\t"
            "jb                1b               \n\t"
            : "+r"(ptr)
            : "r"((x86_reg)wrap), "r"((x86_reg)width), "r"(ptr + wrap * height)
            );
    } else {
        ((void)0);
        __asm__ volatile (
            "1:                             \n\t"
            "movd            (%0), %%mm0    \n\t"
            "punpcklbw      %%mm0, %%mm0    \n\t"
            "punpcklwd      %%mm0, %%mm0    \n\t"
            "movd           %%mm0, -4(%0)   \n\t"
            "movd      -4(%0, %2), %%mm1    \n\t"
            "punpcklbw      %%mm1, %%mm1    \n\t"
            "punpckhwd      %%mm1, %%mm1    \n\t"
            "punpckhdq      %%mm1, %%mm1    \n\t"
            "movd           %%mm1, (%0, %2) \n\t"
            "add               %1, %0       \n\t"
            "cmp               %3, %0       \n\t"
            "jb                1b           \n\t"
            : "+r" (ptr)
            : "r" ((x86_reg) wrap), "r" ((x86_reg) width),
              "r" (ptr + wrap * height));
    }


    if (sides & 1) {
        for (i = 0; i < h; i += 4) {
            ptr = buf - (i + 1) * wrap - w;
            __asm__ volatile (
                "1:                             \n\t"
                "movq (%1, %0), %%mm0           \n\t"
                "movq    %%mm0, (%0)            \n\t"
                "movq    %%mm0, (%0, %2)        \n\t"
                "movq    %%mm0, (%0, %2, 2)     \n\t"
                "movq    %%mm0, (%0, %3)        \n\t"
                "add        $8, %0              \n\t"
                "cmp        %4, %0              \n\t"
                "jb         1b                  \n\t"
                : "+r" (ptr)
                : "r" ((x86_reg) buf - (x86_reg) ptr - w),
                  "r" ((x86_reg) - wrap), "r" ((x86_reg) - wrap * 3),
                  "r" (ptr + width + 2 * w));
        }
    }

    if (sides & 2) {
        for (i = 0; i < h; i += 4) {
            ptr = last_line + (i + 1) * wrap - w;
            __asm__ volatile (
                "1:                             \n\t"
                "movq (%1, %0), %%mm0           \n\t"
                "movq    %%mm0, (%0)            \n\t"
                "movq    %%mm0, (%0, %2)        \n\t"
                "movq    %%mm0, (%0, %2, 2)     \n\t"
                "movq    %%mm0, (%0, %3)        \n\t"
                "add        $8, %0              \n\t"
                "cmp        %4, %0              \n\t"
                "jb         1b                  \n\t"
                : "+r" (ptr)
                : "r" ((x86_reg) last_line - (x86_reg) ptr - w),
                  "r" ((x86_reg) wrap), "r" ((x86_reg) wrap * 3),
                  "r" (ptr + width + 2 * w));
        }
    }
}

# 28 "/usr/include/i386-linux-gnu/bits/sockaddr.h"
typedef unsigned short int sa_family_t;

# 149 "/usr/include/i386-linux-gnu/bits/socket.h"
struct sockaddr
  {
    sa_family_t sa_family; /* Common data: address family and length.  */
    char sa_data[14]; /* Address data.  */
  };

# 162 "/usr/include/i386-linux-gnu/bits/socket.h"
struct sockaddr_storage
  {
    sa_family_t ss_family; /* Address family, etc.  */
    unsigned long int __ss_align; /* Force desired alignment.  */
    char __ss_padding[(128 - (2 * sizeof (unsigned long int)))];
  };

# 30 "/usr/include/netinet/in.h"
typedef uint32_t in_addr_t;

# 31 "/usr/include/netinet/in.h"
struct in_addr
  {
    in_addr_t s_addr;
  };

# 117 "/usr/include/netinet/in.h"
typedef uint16_t in_port_t;

# 209 "/usr/include/netinet/in.h"
struct in6_addr
  {
    union
      {
 uint8_t __u6_addr8[16];




      } __in6_u;





  };

# 237 "/usr/include/netinet/in.h"
struct sockaddr_in
  {
    sa_family_t sin_family;
    in_port_t sin_port; /* Port number.  */
    struct in_addr sin_addr; /* Internet address.  */

    /* Pad to size of `struct sockaddr'.  */
    unsigned char sin_zero[sizeof (struct sockaddr) -
      (sizeof (unsigned short int)) -
      sizeof (in_port_t) -
      sizeof (struct in_addr)];
  };

# 252 "/usr/include/netinet/in.h"
struct sockaddr_in6
  {
    sa_family_t sin6_family;
    in_port_t sin6_port; /* Transport layer port # */
    uint32_t sin6_flowinfo; /* IPv6 flow information */
    struct in6_addr sin6_addr; /* IPv6 address */
    uint32_t sin6_scope_id; /* IPv6 scope-id */
  };

# 168 "libavformat/rtpproto.c"
static int get_port(const struct sockaddr_storage *ss)
{
    if (ss->ss_family == 2 /* IP protocol family.  */)
        return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (((const struct sockaddr_in *)ss)->sin_port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

    if (ss->ss_family == 10 /* IP version 6.  */)
        return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (((const struct sockaddr_in6 *)ss)->sin6_port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

    return 0;
}

# 179 "libavformat/rtpproto.c"
static void set_port(struct sockaddr_storage *ss, int port)
{
    if (ss->ss_family == 2 /* IP protocol family.  */)
        ((struct sockaddr_in *)ss)->sin_port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

    else if (ss->ss_family == 10 /* IP version 6.  */)
        ((struct sockaddr_in6 *)ss)->sin6_port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

}

# 67 "libavcodec/x86/mpegaudiodsp.c"
static void apply_window(const float *buf, const float *win1,
                         const float *win2, float *sum1, float *sum2, int len)
{
    x86_reg count = - 4*len;
    const float *win1a = win1+len;
    const float *win2a = win2+len;
    const float *bufa = buf+len;
    float *sum1a = sum1+len;
    float *sum2a = sum2+len;
# 86 "libavcodec/x86/mpegaudiodsp.c"
    __asm__ volatile(
            "1:                                   \n\t"
            "xorps       %%xmm0, %%xmm0           \n\t"
            "xorps       %%xmm4, %%xmm4           \n\t"

            "movaps " "0" "(%1,%0), %%xmm1           \n\t" "movaps " "0" "(%3,%0), %%xmm2           \n\t" "mulps         %%xmm2, %%xmm1           \n\t" "subps         %%xmm1, %%xmm0           \n\t" "mulps  " "0" "(%2,%0), %%xmm2           \n\t" "subps         %%xmm2, %%xmm4           \n\t"
            "movaps " "256" "(%1,%0), %%xmm1           \n\t" "movaps " "256" "(%3,%0), %%xmm2           \n\t" "mulps         %%xmm2, %%xmm1           \n\t" "subps         %%xmm1, %%xmm0           \n\t" "mulps  " "64" "(%2,%0), %%xmm2           \n\t" "subps         %%xmm2, %%xmm4           \n\t"
            "movaps " "512" "(%1,%0), %%xmm1           \n\t" "movaps " "512" "(%3,%0), %%xmm2           \n\t" "mulps         %%xmm2, %%xmm1           \n\t" "subps         %%xmm1, %%xmm0           \n\t" "mulps  " "128" "(%2,%0), %%xmm2           \n\t" "subps         %%xmm2, %%xmm4           \n\t"
            "movaps " "768" "(%1,%0), %%xmm1           \n\t" "movaps " "768" "(%3,%0), %%xmm2           \n\t" "mulps         %%xmm2, %%xmm1           \n\t" "subps         %%xmm1, %%xmm0           \n\t" "mulps  " "192" "(%2,%0), %%xmm2           \n\t" "subps         %%xmm2, %%xmm4           \n\t"
            "movaps " "1024" "(%1,%0), %%xmm1           \n\t" "movaps " "1024" "(%3,%0), %%xmm2           \n\t" "mulps         %%xmm2, %%xmm1           \n\t" "subps         %%xmm1, %%xmm0           \n\t" "mulps  " "256" "(%2,%0), %%xmm2           \n\t" "subps         %%xmm2, %%xmm4           \n\t"
            "movaps " "1280" "(%1,%0), %%xmm1           \n\t" "movaps " "1280" "(%3,%0), %%xmm2           \n\t" "mulps         %%xmm2, %%xmm1           \n\t" "subps         %%xmm1, %%xmm0           \n\t" "mulps  " "320" "(%2,%0), %%xmm2           \n\t" "subps         %%xmm2, %%xmm4           \n\t"
            "movaps " "1536" "(%1,%0), %%xmm1           \n\t" "movaps " "1536" "(%3,%0), %%xmm2           \n\t" "mulps         %%xmm2, %%xmm1           \n\t" "subps         %%xmm1, %%xmm0           \n\t" "mulps  " "384" "(%2,%0), %%xmm2           \n\t" "subps         %%xmm2, %%xmm4           \n\t"
            "movaps " "1792" "(%1,%0), %%xmm1           \n\t" "movaps " "1792" "(%3,%0), %%xmm2           \n\t" "mulps         %%xmm2, %%xmm1           \n\t" "subps         %%xmm1, %%xmm0           \n\t" "mulps  " "448" "(%2,%0), %%xmm2           \n\t" "subps         %%xmm2, %%xmm4           \n\t"

            "movaps      %%xmm0, (%4,%0)          \n\t"
            "movaps      %%xmm4, (%5,%0)          \n\t"
            "add            $16,  %0              \n\t"
            "jl              1b                   \n\t"
            :"+&r"(count)
            :"r"(win1a), "r"(win2a), "r"(bufa), "r"(sum1a), "r"(sum2a)
            );


}

# 111 "libavcodec/x86/mpegaudiodsp.c"
static void apply_window_mp3(float *in, float *win, int *unused, float *out,
                             ptrdiff_t incr)
{
    float la_suma [17] ; float (*suma) = la_suma;
    float la_sumb [17] ; float (*sumb) = la_sumb;
    float la_sumc [17] ; float (*sumc) = la_sumc;
    float la_sumd [17] ; float (*sumd) = la_sumd;

    float sum;

    /* copy to avoid wrap */
    __asm__ volatile(
            "movaps    0(%0), %%xmm0   \n\t"
            "movaps   16(%0), %%xmm1   \n\t"
            "movaps   32(%0), %%xmm2   \n\t"
            "movaps   48(%0), %%xmm3   \n\t"
            "movaps   %%xmm0,   0(%1) \n\t"
            "movaps   %%xmm1,  16(%1) \n\t"
            "movaps   %%xmm2,  32(%1) \n\t"
            "movaps   %%xmm3,  48(%1) \n\t"
            "movaps   64(%0), %%xmm0   \n\t"
            "movaps   80(%0), %%xmm1   \n\t"
            "movaps   96(%0), %%xmm2   \n\t"
            "movaps  112(%0), %%xmm3   \n\t"
            "movaps   %%xmm0,  64(%1) \n\t"
            "movaps   %%xmm1,  80(%1) \n\t"
            "movaps   %%xmm2,  96(%1) \n\t"
            "movaps   %%xmm3, 112(%1) \n\t"
            ::"r"(in), "r"(in+512)
            :"memory"
            );

    apply_window(in + 16, win , win + 512, suma, sumc, 16);
    apply_window(in + 32, win + 48, win + 640, sumb, sumd, 16);

    { suma[0]+=((win + 32)[0 * 64])*((in + 48)[0 * 64]); suma[0]+=((win + 32)[1 * 64])*((in + 48)[1 * 64]); suma[0]+=((win + 32)[2 * 64])*((in + 48)[2 * 64]); suma[0]+=((win + 32)[3 * 64])*((in + 48)[3 * 64]); suma[0]+=((win + 32)[4 * 64])*((in + 48)[4 * 64]); suma[0]+=((win + 32)[5 * 64])*((in + 48)[5 * 64]); suma[0]+=((win + 32)[6 * 64])*((in + 48)[6 * 64]); suma[0]+=((win + 32)[7 * 64])*((in + 48)[7 * 64]); };

    sumc[ 0] = 0;
    sumb[16] = 0;
    sumd[16] = 0;
# 163 "libavcodec/x86/mpegaudiodsp.c"
    if (incr == 1) {
        __asm__ volatile(
            "movups " "52" "(%4),       %%xmm0          \n\t" "shufps         $0x1b,       %%xmm0, %%xmm0  \n\t" "subps  " "0" "(%1),       %%xmm0          \n\t" "movaps        %%xmm0," "0" "(%0)          \n\t" "movups " "4" "(%3),       %%xmm0          \n\t" "shufps         $0x1b,       %%xmm0, %%xmm0  \n\t" "addps  " "48" "(%2),       %%xmm0          \n\t" "movaps        %%xmm0," "112" "(%0)          \n\t"
            "movups " "36" "(%4),       %%xmm0          \n\t" "shufps         $0x1b,       %%xmm0, %%xmm0  \n\t" "subps  " "16" "(%1),       %%xmm0          \n\t" "movaps        %%xmm0," "16" "(%0)          \n\t" "movups " "20" "(%3),       %%xmm0          \n\t" "shufps         $0x1b,       %%xmm0, %%xmm0  \n\t" "addps  " "32" "(%2),       %%xmm0          \n\t" "movaps        %%xmm0," "96" "(%0)          \n\t"
            "movups " "20" "(%4),       %%xmm0          \n\t" "shufps         $0x1b,       %%xmm0, %%xmm0  \n\t" "subps  " "32" "(%1),       %%xmm0          \n\t" "movaps        %%xmm0," "32" "(%0)          \n\t" "movups " "36" "(%3),       %%xmm0          \n\t" "shufps         $0x1b,       %%xmm0, %%xmm0  \n\t" "addps  " "16" "(%2),       %%xmm0          \n\t" "movaps        %%xmm0," "80" "(%0)          \n\t"
            "movups " "4" "(%4),       %%xmm0          \n\t" "shufps         $0x1b,       %%xmm0, %%xmm0  \n\t" "subps  " "48" "(%1),       %%xmm0          \n\t" "movaps        %%xmm0," "48" "(%0)          \n\t" "movups " "52" "(%3),       %%xmm0          \n\t" "shufps         $0x1b,       %%xmm0, %%xmm0  \n\t" "addps  " "0" "(%2),       %%xmm0          \n\t" "movaps        %%xmm0," "64" "(%0)          \n\t"

            :"+&r"(out)
            :"r"(&suma[0]), "r"(&sumb[0]), "r"(&sumc[0]), "r"(&sumd[0])
            :"memory"
            );
        out += 16*incr;
    } else {
        int j;
        float *out2 = out + 32 * incr;
        out[0 ] = -suma[ 0];
        out += incr;
        out2 -= incr;
        for(j=1;j<16;j++) {
            *out = -suma[ j] + sumd[16-j];
            *out2 = sumb[16-j] + sumc[ j];
            out += incr;
            out2 -= incr;
        }
    }

    sum = 0;
    { sum-=((win + 16 + 32)[0 * 64])*((in + 32)[0 * 64]); sum-=((win + 16 + 32)[1 * 64])*((in + 32)[1 * 64]); sum-=((win + 16 + 32)[2 * 64])*((in + 32)[2 * 64]); sum-=((win + 16 + 32)[3 * 64])*((in + 32)[3 * 64]); sum-=((win + 16 + 32)[4 * 64])*((in + 32)[4 * 64]); sum-=((win + 16 + 32)[5 * 64])*((in + 32)[5 * 64]); sum-=((win + 16 + 32)[6 * 64])*((in + 32)[6 * 64]); sum-=((win + 16 + 32)[7 * 64])*((in + 32)[7 * 64]); };
    *out = sum;
}

# 29 "libavcodec/x86/lpc.c"
/* extern */ const double pd_1[2] = { 1.0, 1.0};

# 30 "libavcodec/x86/lpc.c"
/* extern */ const double pd_2[2] = { 2.0, 2.0};

# 34 "libavcodec/x86/lpc.c"
static void lpc_apply_welch_window_sse2(const int32_t *data, int len,
                                        double *w_data)
{
    double c = 2.0 / (len-1.0);
    int n2 = len>>1;
    x86_reg i = -n2*sizeof(int32_t);
    x86_reg j = n2*sizeof(int32_t);
    __asm__ volatile(
        "movsd   %4,     %%xmm7                \n\t"
        "movapd  """ "pd_1"", %%xmm6        \n\t"
        "movapd  """ "pd_2"", %%xmm5        \n\t"
        "movlhps %%xmm7, %%xmm7                \n\t"
        "subpd   %%xmm5, %%xmm7                \n\t"
        "addsd   %%xmm6, %%xmm7                \n\t"
        "test    $1,     %5                    \n\t"
        "jz      2f                            \n\t"
# 68 "libavcodec/x86/lpc.c"
        "1:                                    \n\t" "movapd   %%xmm7,  %%xmm1              \n\t" "mulpd    %%xmm1,  %%xmm1              \n\t" "movapd   %%xmm6,  %%xmm0              \n\t" "subpd    %%xmm1,  %%xmm0              \n\t" "pshufd   $0x4e,   %%xmm0, %%xmm1      \n\t" "cvtpi2pd (%3,%0), %%xmm2              \n\t" "cvtpi2pd ""-1""*4(%3,%1), %%xmm3   \n\t" "mulpd    %%xmm0,  %%xmm2              \n\t" "mulpd    %%xmm1,  %%xmm3              \n\t" "movapd   %%xmm2, (%2,%0,2)            \n\t" "movupd""    %%xmm3, ""-1""*8(%2,%1,2) \n\t" "subpd    %%xmm5,  %%xmm7              \n\t" "sub      $8,      %1                  \n\t" "add      $8,      %0                  \n\t" "jl 1b                                 \n\t"
        "jmp 3f                                \n\t"
        "2:                                    \n\t"
        "1:                                    \n\t" "movapd   %%xmm7,  %%xmm1              \n\t" "mulpd    %%xmm1,  %%xmm1              \n\t" "movapd   %%xmm6,  %%xmm0              \n\t" "subpd    %%xmm1,  %%xmm0              \n\t" "pshufd   $0x4e,   %%xmm0, %%xmm1      \n\t" "cvtpi2pd (%3,%0), %%xmm2              \n\t" "cvtpi2pd ""-2""*4(%3,%1), %%xmm3   \n\t" "mulpd    %%xmm0,  %%xmm2              \n\t" "mulpd    %%xmm1,  %%xmm3              \n\t" "movapd   %%xmm2, (%2,%0,2)            \n\t" "movapd""    %%xmm3, ""-2""*8(%2,%1,2) \n\t" "subpd    %%xmm5,  %%xmm7              \n\t" "sub      $8,      %1                  \n\t" "add      $8,      %0                  \n\t" "jl 1b                                 \n\t"
        "3:                                    \n\t"
        :"+&r"(i), "+&r"(j)
        :"r"(w_data+n2), "r"(data+n2), "m"(c), "r"(len)



    );

}

# 82 "libavcodec/x86/lpc.c"
static void lpc_compute_autocorr_sse2(const double *data, int len, int lag,
                                      double *autoc)
{
    int j;

    if((x86_reg)data & 15)
        data++;

    for(j=0; j<lag; j+=2){
        x86_reg i = -len*sizeof(double);
        if(j == lag-2) {
            __asm__ volatile(
                "movsd    """ "pd_1"", %%xmm0    \n\t"
                "movsd    """ "pd_1"", %%xmm1    \n\t"
                "movsd    """ "pd_1"", %%xmm2    \n\t"
                "1:                                 \n\t"
                "movapd   (%2,%0), %%xmm3           \n\t"
                "movupd -8(%3,%0), %%xmm4           \n\t"
                "movapd   (%3,%0), %%xmm5           \n\t"
                "mulpd     %%xmm3, %%xmm4           \n\t"
                "mulpd     %%xmm3, %%xmm5           \n\t"
                "mulpd -16(%3,%0), %%xmm3           \n\t"
                "addpd     %%xmm4, %%xmm1           \n\t"
                "addpd     %%xmm5, %%xmm0           \n\t"
                "addpd     %%xmm3, %%xmm2           \n\t"
                "add       $16,    %0               \n\t"
                "jl 1b                              \n\t"
                "movhlps   %%xmm0, %%xmm3           \n\t"
                "movhlps   %%xmm1, %%xmm4           \n\t"
                "movhlps   %%xmm2, %%xmm5           \n\t"
                "addsd     %%xmm3, %%xmm0           \n\t"
                "addsd     %%xmm4, %%xmm1           \n\t"
                "addsd     %%xmm5, %%xmm2           \n\t"
                "movsd     %%xmm0,   (%1)           \n\t"
                "movsd     %%xmm1,  8(%1)           \n\t"
                "movsd     %%xmm2, 16(%1)           \n\t"
                :"+&r"(i)
                :"r"(autoc+j), "r"(data+len), "r"(data+len-j)

                :"memory"
            );
        } else {
            __asm__ volatile(
                "movsd    """ "pd_1"", %%xmm0    \n\t"
                "movsd    """ "pd_1"", %%xmm1    \n\t"
                "1:                                 \n\t"
                "movapd   (%3,%0), %%xmm3           \n\t"
                "movupd -8(%4,%0), %%xmm4           \n\t"
                "mulpd     %%xmm3, %%xmm4           \n\t"
                "mulpd    (%4,%0), %%xmm3           \n\t"
                "addpd     %%xmm4, %%xmm1           \n\t"
                "addpd     %%xmm3, %%xmm0           \n\t"
                "add       $16,    %0               \n\t"
                "jl 1b                              \n\t"
                "movhlps   %%xmm0, %%xmm3           \n\t"
                "movhlps   %%xmm1, %%xmm4           \n\t"
                "addsd     %%xmm3, %%xmm0           \n\t"
                "addsd     %%xmm4, %%xmm1           \n\t"
                "movsd     %%xmm0, %1               \n\t"
                "movsd     %%xmm1, %2               \n\t"
                :"+&r"(i), "=m"(autoc[j]), "=m"(autoc[j+1])
                :"r"(data+len), "r"(data+len-j)

            );
        }
    }
}

# 401 "libavcodec/x86/cavsdsp.c"
static void put_cavs_qpel8_h_mmxext(uint8_t *dst, const uint8_t *src, ptrdiff_t dstStride, ptrdiff_t srcStride){ int h=8; __asm__ volatile( "pxor %%mm7, %%mm7          \n\t" "movq """ "ff_pw_5"", %%mm6\n\t" "1:                         \n\t" "movq    (%0), %%mm0        \n\t" "movq   1(%0), %%mm2        \n\t" "movq %%mm0, %%mm1          \n\t" "movq %%mm2, %%mm3          \n\t" "punpcklbw %%mm7, %%mm0     \n\t" "punpckhbw %%mm7, %%mm1     \n\t" "punpcklbw %%mm7, %%mm2     \n\t" "punpckhbw %%mm7, %%mm3     \n\t" "paddw %%mm2, %%mm0         \n\t" "paddw %%mm3, %%mm1         \n\t" "pmullw %%mm6, %%mm0        \n\t" "pmullw %%mm6, %%mm1        \n\t" "movq   -1(%0), %%mm2       \n\t" "movq    2(%0), %%mm4       \n\t" "movq %%mm2, %%mm3          \n\t" "movq %%mm4, %%mm5          \n\t" "punpcklbw %%mm7, %%mm2     \n\t" "punpckhbw %%mm7, %%mm3     \n\t" "punpcklbw %%mm7, %%mm4     \n\t" "punpckhbw %%mm7, %%mm5     \n\t" "paddw %%mm4, %%mm2         \n\t" "paddw %%mm3, %%mm5         \n\t" "psubw %%mm2, %%mm0         \n\t" "psubw %%mm5, %%mm1         \n\t" "movq """ "ff_pw_4"", %%mm5\n\t" "paddw %%mm5, %%mm0         \n\t" "paddw %%mm5, %%mm1         \n\t" "psraw $3, %%mm0            \n\t" "psraw $3, %%mm1            \n\t" "packuswb %%mm1, %%mm0      \n\t" "mov" "q" " " "%%mm0" ", " "(%1)" "    \n\t" "add %3, %0                 \n\t" "add %4, %1                 \n\t" "decl %2                    \n\t" " jnz 1b                    \n\t" : "+a"(src), "+c"(dst), "+m"(h) : "d"((x86_reg)srcStride), "S"((x86_reg)dstStride) : "memory" );}

# 402 "libavcodec/x86/cavsdsp.c"
static void avg_cavs_qpel8_h_mmxext(uint8_t *dst, const uint8_t *src, ptrdiff_t dstStride, ptrdiff_t srcStride){ int h=8; __asm__ volatile( "pxor %%mm7, %%mm7          \n\t" "movq """ "ff_pw_5"", %%mm6\n\t" "1:                         \n\t" "movq    (%0), %%mm0        \n\t" "movq   1(%0), %%mm2        \n\t" "movq %%mm0, %%mm1          \n\t" "movq %%mm2, %%mm3          \n\t" "punpcklbw %%mm7, %%mm0     \n\t" "punpckhbw %%mm7, %%mm1     \n\t" "punpcklbw %%mm7, %%mm2     \n\t" "punpckhbw %%mm7, %%mm3     \n\t" "paddw %%mm2, %%mm0         \n\t" "paddw %%mm3, %%mm1         \n\t" "pmullw %%mm6, %%mm0        \n\t" "pmullw %%mm6, %%mm1        \n\t" "movq   -1(%0), %%mm2       \n\t" "movq    2(%0), %%mm4       \n\t" "movq %%mm2, %%mm3          \n\t" "movq %%mm4, %%mm5          \n\t" "punpcklbw %%mm7, %%mm2     \n\t" "punpckhbw %%mm7, %%mm3     \n\t" "punpcklbw %%mm7, %%mm4     \n\t" "punpckhbw %%mm7, %%mm5     \n\t" "paddw %%mm4, %%mm2         \n\t" "paddw %%mm3, %%mm5         \n\t" "psubw %%mm2, %%mm0         \n\t" "psubw %%mm5, %%mm1         \n\t" "movq """ "ff_pw_4"", %%mm5\n\t" "paddw %%mm5, %%mm0         \n\t" "paddw %%mm5, %%mm1         \n\t" "psraw $3, %%mm0            \n\t" "psraw $3, %%mm1            \n\t" "packuswb %%mm1, %%mm0      \n\t" "mov" "q" " " "(%1)" ", " "%%mm5" "   \n\t""pavgb " "%%mm5" ", " "%%mm0" "          \n\t""mov" "q" " " "%%mm0" ", " "(%1)" "      \n\t" "add %3, %0                 \n\t" "add %4, %1                 \n\t" "decl %2                    \n\t" " jnz 1b                    \n\t" : "+a"(src), "+c"(dst), "+m"(h) : "d"((x86_reg)srcStride), "S"((x86_reg)dstStride) : "memory" );}

# 411 "libavcodec/x86/cavsdsp.c"
static void put_cavs_qpel8_h_3dnow(uint8_t *dst, const uint8_t *src, ptrdiff_t dstStride, ptrdiff_t srcStride){ int h=8; __asm__ volatile( "pxor %%mm7, %%mm7          \n\t" "movq """ "ff_pw_5"", %%mm6\n\t" "1:                         \n\t" "movq    (%0), %%mm0        \n\t" "movq   1(%0), %%mm2        \n\t" "movq %%mm0, %%mm1          \n\t" "movq %%mm2, %%mm3          \n\t" "punpcklbw %%mm7, %%mm0     \n\t" "punpckhbw %%mm7, %%mm1     \n\t" "punpcklbw %%mm7, %%mm2     \n\t" "punpckhbw %%mm7, %%mm3     \n\t" "paddw %%mm2, %%mm0         \n\t" "paddw %%mm3, %%mm1         \n\t" "pmullw %%mm6, %%mm0        \n\t" "pmullw %%mm6, %%mm1        \n\t" "movq   -1(%0), %%mm2       \n\t" "movq    2(%0), %%mm4       \n\t" "movq %%mm2, %%mm3          \n\t" "movq %%mm4, %%mm5          \n\t" "punpcklbw %%mm7, %%mm2     \n\t" "punpckhbw %%mm7, %%mm3     \n\t" "punpcklbw %%mm7, %%mm4     \n\t" "punpckhbw %%mm7, %%mm5     \n\t" "paddw %%mm4, %%mm2         \n\t" "paddw %%mm3, %%mm5         \n\t" "psubw %%mm2, %%mm0         \n\t" "psubw %%mm5, %%mm1         \n\t" "movq """ "ff_pw_4"", %%mm5\n\t" "paddw %%mm5, %%mm0         \n\t" "paddw %%mm5, %%mm1         \n\t" "psraw $3, %%mm0            \n\t" "psraw $3, %%mm1            \n\t" "packuswb %%mm1, %%mm0      \n\t" "mov" "q" " " "%%mm0" ", " "(%1)" "    \n\t" "add %3, %0                 \n\t" "add %4, %1                 \n\t" "decl %2                    \n\t" " jnz 1b                    \n\t" : "+a"(src), "+c"(dst), "+m"(h) : "d"((x86_reg)srcStride), "S"((x86_reg)dstStride) : "memory" );}

# 412 "libavcodec/x86/cavsdsp.c"
static void avg_cavs_qpel8_h_3dnow(uint8_t *dst, const uint8_t *src, ptrdiff_t dstStride, ptrdiff_t srcStride){ int h=8; __asm__ volatile( "pxor %%mm7, %%mm7          \n\t" "movq """ "ff_pw_5"", %%mm6\n\t" "1:                         \n\t" "movq    (%0), %%mm0        \n\t" "movq   1(%0), %%mm2        \n\t" "movq %%mm0, %%mm1          \n\t" "movq %%mm2, %%mm3          \n\t" "punpcklbw %%mm7, %%mm0     \n\t" "punpckhbw %%mm7, %%mm1     \n\t" "punpcklbw %%mm7, %%mm2     \n\t" "punpckhbw %%mm7, %%mm3     \n\t" "paddw %%mm2, %%mm0         \n\t" "paddw %%mm3, %%mm1         \n\t" "pmullw %%mm6, %%mm0        \n\t" "pmullw %%mm6, %%mm1        \n\t" "movq   -1(%0), %%mm2       \n\t" "movq    2(%0), %%mm4       \n\t" "movq %%mm2, %%mm3          \n\t" "movq %%mm4, %%mm5          \n\t" "punpcklbw %%mm7, %%mm2     \n\t" "punpckhbw %%mm7, %%mm3     \n\t" "punpcklbw %%mm7, %%mm4     \n\t" "punpckhbw %%mm7, %%mm5     \n\t" "paddw %%mm4, %%mm2         \n\t" "paddw %%mm3, %%mm5         \n\t" "psubw %%mm2, %%mm0         \n\t" "psubw %%mm5, %%mm1         \n\t" "movq """ "ff_pw_4"", %%mm5\n\t" "paddw %%mm5, %%mm0         \n\t" "paddw %%mm5, %%mm1         \n\t" "psraw $3, %%mm0            \n\t" "psraw $3, %%mm1            \n\t" "packuswb %%mm1, %%mm0      \n\t" "mov" "q" " " "(%1)" ", " "%%mm5" "   \n\t""pavgusb " "%%mm5" ", " "%%mm0" "        \n\t""mov" "q" " " "%%mm0" ", " "(%1)" "      \n\t" "add %3, %0                 \n\t" "add %4, %1                 \n\t" "decl %2                    \n\t" " jnz 1b                    \n\t" : "+a"(src), "+c"(dst), "+m"(h) : "d"((x86_reg)srcStride), "S"((x86_reg)dstStride) : "memory" );}
