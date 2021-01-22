# 51 "/usr/arm-linux-gnueabihf/include/stdint.h"
typedef unsigned int uint32_t;

# 58 "/usr/arm-linux-gnueabihf/include/stdint.h"
typedef unsigned long long int uint64_t;

# 31 "./libavutil/arm/timer.h"
static inline uint64_t read_time(void)
{
    unsigned cc;
    __asm__ volatile ("mrc p15, 0, %0, c9, c13, 0" : "=r"(cc));
    return cc;
}

# 33 "./libavcodec/mathops.h"
extern const uint32_t ff_inverse[257];

# 33 "./libavcodec/arm/mathops.h"
static inline __attribute__((const)) int MULH(int a, int b)
{
    int r;
    __asm__ ("smmul %0, %1, %2" : "=r"(r) : "r"(a), "r"(b));
    return r;
}

# 41 "./libavcodec/arm/mathops.h"
static __attribute__((always_inline)) inline __attribute__((const)) int FASTDIV(int a, int b)
{
    int r;
    __asm__ ("cmp     %2, #2               \n\t"
             "ldr     %0, [%3, %2, lsl #2] \n\t"
             "ite     le                   \n\t"
             "lsrle   %0, %1, #1           \n\t"
             "smmulgt %0, %0, %1           \n\t"
             : "=&r"(r) : "r"(a), "r"(b), "r"(ff_inverse) : "cc");
    return r;
}

# 75 "./libavcodec/arm/mathops.h"
static inline __attribute__((const)) int MUL16(int ra, int rb)
{
    int rt;
    __asm__ ("smulbb %0, %1, %2" : "=r"(rt) : "r"(ra), "r"(rb));
    return rt;
}

# 85 "./libavcodec/arm/mathops.h"
static inline __attribute__((const)) int mid_pred(int a, int b, int c)
{
    int m;
    __asm__ (
        "mov   %0, %2  \n\t"
        "cmp   %1, %2  \n\t"
        "itt   gt      \n\t"
        "movgt %0, %1  \n\t"
        "movgt %1, %2  \n\t"
        "cmp   %1, %3  \n\t"
        "it    le      \n\t"
        "movle %1, %3  \n\t"
        "cmp   %0, %1  \n\t"
        "it    gt      \n\t"
        "movgt %0, %1  \n\t"
        : "=&r"(m), "+r"(a)
        : "r"(b), "r"(c)
        : "cc");
    return m;
}

# 38 "/usr/arm-linux-gnueabihf/include/stdint.h"
typedef int int32_t;

# 43 "/usr/arm-linux-gnueabihf/include/stdint.h"
typedef long long int int64_t;

# 34 "./libavutil/arm/intmath.h"
static __attribute__((always_inline)) inline __attribute__((const)) int av_clip_uint8_arm(int a)
{
    int x;
    __asm__ ("usat %0, #8,  %1" : "=r"(x) : "r"(a));
    return x;
}

# 42 "./libavutil/arm/intmath.h"
static __attribute__((always_inline)) inline __attribute__((const)) int av_clip_int8_arm(int a)
{
    int x;
    __asm__ ("ssat %0, #8,  %1" : "=r"(x) : "r"(a));
    return x;
}

# 50 "./libavutil/arm/intmath.h"
static __attribute__((always_inline)) inline __attribute__((const)) int av_clip_uint16_arm(int a)
{
    int x;
    __asm__ ("usat %0, #16, %1" : "=r"(x) : "r"(a));
    return x;
}

# 58 "./libavutil/arm/intmath.h"
static __attribute__((always_inline)) inline __attribute__((const)) int av_clip_int16_arm(int a)
{
    int x;
    __asm__ ("ssat %0, #16, %1" : "=r"(x) : "r"(a));
    return x;
}

# 82 "./libavutil/arm/intmath.h"
static __attribute__((always_inline)) inline int av_sat_add32_arm(int a, int b)
{
    int r;
    __asm__ ("qadd %0, %1, %2" : "=r"(r) : "r"(a), "r"(b));
    return r;
}

# 90 "./libavutil/arm/intmath.h"
static __attribute__((always_inline)) inline int av_sat_dadd32_arm(int a, int b)
{
    int r;
    __asm__ ("qdadd %0, %1, %2" : "=r"(r) : "r"(a), "r"(b));
    return r;
}

# 98 "./libavutil/arm/intmath.h"
static __attribute__((always_inline)) inline int av_sat_sub32_arm(int a, int b)
{
    int r;
    __asm__ ("qsub %0, %1, %2" : "=r"(r) : "r"(a), "r"(b));
    return r;
}

# 106 "./libavutil/arm/intmath.h"
static __attribute__((always_inline)) inline int av_sat_dsub32_arm(int a, int b)
{
    int r;
    __asm__ ("qdsub %0, %1, %2" : "=r"(r) : "r"(a), "r"(b));
    return r;
}

# 118 "./libavutil/arm/intmath.h"
static __attribute__((always_inline)) inline __attribute__((const)) int32_t av_clipl_int32_arm(int64_t a)
{
    int x, y;
    __asm__ ("adds   %1, %R2, %Q2, lsr #31  \n\t"
             "itet   ne                     \n\t"
             "mvnne  %1, #1<<31             \n\t"
             "moveq  %0, %Q2                \n\t"
             "eorne  %0, %1,  %R2, asr #31  \n\t"
             : "=r"(x), "=&r"(y) : "r"(a) : "cc");
    return x;
}

# 40 "./libavutil/arm/bswap.h"
static __attribute__((always_inline)) inline __attribute__((const)) unsigned av_bswap16(unsigned x)
{
    __asm__("rev16 %0, %0" : "+r"(x));
    return x;
}

# 37 "/usr/arm-linux-gnueabihf/include/stdint.h"
typedef short int int16_t;

# 29 "libavcodec/g722dsp.c"
static void g722_apply_qmf(const int16_t *prev_samples, int xout[2])
{
    xout[1] = MUL16(*prev_samples++, 3);
    xout[0] = MUL16(*prev_samples++, -11);

    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[1]) : "r"(*prev_samples++), "r"(-11));;
    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[0]) : "r"(*prev_samples++), "r"(53));;

    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[1]) : "r"(*prev_samples++), "r"(12));;
    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[0]) : "r"(*prev_samples++), "r"(-156));;

    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[1]) : "r"(*prev_samples++), "r"(32));;
    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[0]) : "r"(*prev_samples++), "r"(362));;

    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[1]) : "r"(*prev_samples++), "r"(-210));;
    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[0]) : "r"(*prev_samples++), "r"(-805));;

    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[1]) : "r"(*prev_samples++), "r"(951));;
    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[0]) : "r"(*prev_samples++), "r"(3876));;

    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[1]) : "r"(*prev_samples++), "r"(3876));;
    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[0]) : "r"(*prev_samples++), "r"(951));;

    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[1]) : "r"(*prev_samples++), "r"(-805));;
    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[0]) : "r"(*prev_samples++), "r"(-210));;

    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[1]) : "r"(*prev_samples++), "r"(362));;
    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[0]) : "r"(*prev_samples++), "r"(32));;

    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[1]) : "r"(*prev_samples++), "r"(-156));;
    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[0]) : "r"(*prev_samples++), "r"(12));;

    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[1]) : "r"(*prev_samples++), "r"(53));;
    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[0]) : "r"(*prev_samples++), "r"(-11));;

    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[1]) : "r"(*prev_samples++), "r"(-11));;
    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(xout[0]) : "r"(*prev_samples++), "r"(3));;
}

# 48 "/usr/arm-linux-gnueabihf/include/stdint.h"
typedef unsigned char uint8_t;

# 49 "/usr/arm-linux-gnueabihf/include/stdint.h"
typedef unsigned short int uint16_t;

# 27 "./libavutil/intreadwrite.h"
typedef union {
    uint64_t u64;
    uint32_t u32[2];
    uint16_t u16[4];
    uint8_t u8 [8];
    double f64;
    float f32[2];
} __attribute__((may_alias)) av_alias64;

# 36 "./libavutil/intreadwrite.h"
typedef union {
    uint32_t u32;
    uint16_t u16[2];
    uint8_t u8 [4];
    float f32;
} __attribute__((may_alias)) av_alias32;

# 149 "/usr/lib/gcc-cross/arm-linux-gnueabihf/5/include/stddef.h"
typedef int ptrdiff_t;

# 116 "libavcodec/simple_idct_template.c"
static inline void idctRowCondDC_int16_8bit(int16_t *row, int extra_shift)

{
    unsigned a0, a1, a2, a3, b0, b1, b2, b3;

// TODO: Add DC-only support for int32_t input
# 139 "libavcodec/simple_idct_template.c"
    if (!((((const av_alias32*)(row+2))->u32) |
          (((const av_alias32*)(row+4))->u32) |
          (((const av_alias32*)(row+6))->u32) |
          row[1])) {
        uint32_t temp;
        if (3 - extra_shift >= 0) {
            temp = (row[0] * (1 << (3 - extra_shift))) & 0xffff;
        } else {
            temp = ((row[0] + (1<<(extra_shift - 3 -1))) >> (extra_shift - 3)) & 0xffff;
        }
        temp += temp * (1 << 16);
        (((av_alias32*)(row))->u32 = (temp));
        (((av_alias32*)(row+2))->u32 = (temp));
        (((av_alias32*)(row+4))->u32 = (temp));
        (((av_alias32*)(row+6))->u32 = (temp));
        return;
    }



    a0 = ((unsigned)16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/ * row[0]) + (1 << (11 + extra_shift - 1));
    a1 = a0;
    a2 = a0;
    a3 = a0;

    a0 += (unsigned)21407 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/ * row[2];
    a1 += (unsigned)8867 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/ * row[2];
    a2 -= (unsigned)8867 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/ * row[2];
    a3 -= (unsigned)21407 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/ * row[2];

    b0 = MUL16(22725 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/, row[1]);
    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b0) : "r"(19266 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(row[3]));;
    b1 = MUL16(19266 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/, row[1]);
    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b1) : "r"(-4520 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(row[3]));;
    b2 = MUL16(12873 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/, row[1]);
    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b2) : "r"(-22725 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(row[3]));;
    b3 = MUL16(4520 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/, row[1]);
    __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b3) : "r"(-12873 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(row[3]));;




    if ((((const av_alias64*)(row + 4))->u64)) {

        a0 += (unsigned) 16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*row[4] + (unsigned)8867 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*row[6];
        a1 += (unsigned)- 16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*row[4] - (unsigned)21407 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*row[6];
        a2 += (unsigned)- 16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*row[4] + (unsigned)21407 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*row[6];
        a3 += (unsigned) 16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*row[4] - (unsigned)8867 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*row[6];

        __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b0) : "r"(12873 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(row[5]));;
        __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b0) : "r"(4520 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(row[7]));;

        __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b1) : "r"(-22725 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(row[5]));;
        __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b1) : "r"(-12873 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(row[7]));;

        __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b2) : "r"(4520 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(row[5]));;
        __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b2) : "r"(19266 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(row[7]));;

        __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b3) : "r"(19266 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(row[5]));;
        __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b3) : "r"(-22725 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(row[7]));;
    }

    row[0] = (int)(a0 + b0) >> (11 + extra_shift);
    row[7] = (int)(a0 - b0) >> (11 + extra_shift);
    row[1] = (int)(a1 + b1) >> (11 + extra_shift);
    row[6] = (int)(a1 - b1) >> (11 + extra_shift);
    row[2] = (int)(a2 + b2) >> (11 + extra_shift);
    row[5] = (int)(a2 - b2) >> (11 + extra_shift);
    row[3] = (int)(a3 + b3) >> (11 + extra_shift);
    row[4] = (int)(a3 - b3) >> (11 + extra_shift);
}

# 264 "libavcodec/simple_idct_template.c"
static inline void idctSparseColPut_int16_8bit(uint8_t *dest, ptrdiff_t line_size,
                                          int16_t *col)
{
    unsigned a0, a1, a2, a3, b0, b1, b2, b3;

    do { a0 = (unsigned)16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/ * (col[8*0] + ((1<<(20 -1))/16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/)); a1 = a0; a2 = a0; a3 = a0; a0 += (unsigned) 21407 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*2]; a1 += (unsigned) 8867 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*2]; a2 += (unsigned)-8867 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*2]; a3 += (unsigned)-21407 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*2]; b0 = MUL16(22725 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/, col[8*1]); b1 = MUL16(19266 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/, col[8*1]); b2 = MUL16(12873 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/, col[8*1]); b3 = MUL16(4520 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/, col[8*1]); __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b0) : "r"(19266 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*3]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b1) : "r"(-4520 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*3]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b2) : "r"(-22725 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*3]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b3) : "r"(-12873 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*3]));; if (col[8*4]) { a0 += (unsigned) 16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*4]; a1 += (unsigned)-16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*4]; a2 += (unsigned)-16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*4]; a3 += (unsigned) 16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*4]; } if (col[8*5]) { __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b0) : "r"(12873 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*5]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b1) : "r"(-22725 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*5]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b2) : "r"(4520 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*5]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b3) : "r"(19266 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*5]));; } if (col[8*6]) { a0 += (unsigned) 8867 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*6]; a1 += (unsigned)-21407 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*6]; a2 += (unsigned) 21407 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*6]; a3 += (unsigned)-8867 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*6]; } if (col[8*7]) { __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b0) : "r"(4520 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*7]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b1) : "r"(-12873 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*7]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b2) : "r"(19266 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*7]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b3) : "r"(-22725 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*7]));; } } while (0);

    dest[0] = av_clip_uint8_arm((int)(a0 + b0) >> 20);
    dest += line_size;
    dest[0] = av_clip_uint8_arm((int)(a1 + b1) >> 20);
    dest += line_size;
    dest[0] = av_clip_uint8_arm((int)(a2 + b2) >> 20);
    dest += line_size;
    dest[0] = av_clip_uint8_arm((int)(a3 + b3) >> 20);
    dest += line_size;
    dest[0] = av_clip_uint8_arm((int)(a3 - b3) >> 20);
    dest += line_size;
    dest[0] = av_clip_uint8_arm((int)(a2 - b2) >> 20);
    dest += line_size;
    dest[0] = av_clip_uint8_arm((int)(a1 - b1) >> 20);
    dest += line_size;
    dest[0] = av_clip_uint8_arm((int)(a0 - b0) >> 20);
}

# 288 "libavcodec/simple_idct_template.c"
static inline void idctSparseColAdd_int16_8bit(uint8_t *dest, ptrdiff_t line_size,
                                          int16_t *col)
{
    int a0, a1, a2, a3, b0, b1, b2, b3;

    do { a0 = (unsigned)16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/ * (col[8*0] + ((1<<(20 -1))/16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/)); a1 = a0; a2 = a0; a3 = a0; a0 += (unsigned) 21407 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*2]; a1 += (unsigned) 8867 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*2]; a2 += (unsigned)-8867 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*2]; a3 += (unsigned)-21407 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*2]; b0 = MUL16(22725 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/, col[8*1]); b1 = MUL16(19266 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/, col[8*1]); b2 = MUL16(12873 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/, col[8*1]); b3 = MUL16(4520 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/, col[8*1]); __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b0) : "r"(19266 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*3]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b1) : "r"(-4520 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*3]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b2) : "r"(-22725 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*3]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b3) : "r"(-12873 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*3]));; if (col[8*4]) { a0 += (unsigned) 16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*4]; a1 += (unsigned)-16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*4]; a2 += (unsigned)-16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*4]; a3 += (unsigned) 16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*4]; } if (col[8*5]) { __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b0) : "r"(12873 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*5]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b1) : "r"(-22725 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*5]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b2) : "r"(4520 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*5]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b3) : "r"(19266 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*5]));; } if (col[8*6]) { a0 += (unsigned) 8867 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*6]; a1 += (unsigned)-21407 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*6]; a2 += (unsigned) 21407 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*6]; a3 += (unsigned)-8867 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*6]; } if (col[8*7]) { __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b0) : "r"(4520 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*7]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b1) : "r"(-12873 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*7]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b2) : "r"(19266 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*7]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b3) : "r"(-22725 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*7]));; } } while (0);

    dest[0] = av_clip_uint8_arm(dest[0] + ((a0 + b0) >> 20));
    dest += line_size;
    dest[0] = av_clip_uint8_arm(dest[0] + ((a1 + b1) >> 20));
    dest += line_size;
    dest[0] = av_clip_uint8_arm(dest[0] + ((a2 + b2) >> 20));
    dest += line_size;
    dest[0] = av_clip_uint8_arm(dest[0] + ((a3 + b3) >> 20));
    dest += line_size;
    dest[0] = av_clip_uint8_arm(dest[0] + ((a3 - b3) >> 20));
    dest += line_size;
    dest[0] = av_clip_uint8_arm(dest[0] + ((a2 - b2) >> 20));
    dest += line_size;
    dest[0] = av_clip_uint8_arm(dest[0] + ((a1 - b1) >> 20));
    dest += line_size;
    dest[0] = av_clip_uint8_arm(dest[0] + ((a0 - b0) >> 20));
}

# 312 "libavcodec/simple_idct_template.c"
static inline void idctSparseCol_int16_8bit(int16_t *col)

{
    int a0, a1, a2, a3, b0, b1, b2, b3;

    do { a0 = (unsigned)16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/ * (col[8*0] + ((1<<(20 -1))/16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/)); a1 = a0; a2 = a0; a3 = a0; a0 += (unsigned) 21407 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*2]; a1 += (unsigned) 8867 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*2]; a2 += (unsigned)-8867 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*2]; a3 += (unsigned)-21407 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*2]; b0 = MUL16(22725 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/, col[8*1]); b1 = MUL16(19266 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/, col[8*1]); b2 = MUL16(12873 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/, col[8*1]); b3 = MUL16(4520 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/, col[8*1]); __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b0) : "r"(19266 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*3]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b1) : "r"(-4520 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*3]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b2) : "r"(-22725 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*3]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b3) : "r"(-12873 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*3]));; if (col[8*4]) { a0 += (unsigned) 16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*4]; a1 += (unsigned)-16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*4]; a2 += (unsigned)-16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*4]; a3 += (unsigned) 16383 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*4]; } if (col[8*5]) { __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b0) : "r"(12873 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*5]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b1) : "r"(-22725 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*5]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b2) : "r"(4520 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*5]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b3) : "r"(19266 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*5]));; } if (col[8*6]) { a0 += (unsigned) 8867 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*6]; a1 += (unsigned)-21407 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*6]; a2 += (unsigned) 21407 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*6]; a3 += (unsigned)-8867 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/*col[8*6]; } if (col[8*7]) { __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b0) : "r"(4520 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*7]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b1) : "r"(-12873 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*7]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b2) : "r"(19266 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*7]));; __asm__ ("smlabb %0, %1, %2, %0" : "+r"(b3) : "r"(-22725 /*cos(i*M_PI/16)*sqrt(2)*(1<<14) + 0.5*/), "r"(col[8*7]));; } } while (0);

    col[0 ] = ((a0 + b0) >> 20);
    col[8 ] = ((a1 + b1) >> 20);
    col[16] = ((a2 + b2) >> 20);
    col[24] = ((a3 + b3) >> 20);
    col[32] = ((a3 - b3) >> 20);
    col[40] = ((a2 - b2) >> 20);
    col[48] = ((a1 - b1) >> 20);
    col[56] = ((a0 - b0) >> 20);
}
