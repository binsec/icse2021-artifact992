# 195 "/usr/include/i386-linux-gnu/sys/types.h"
typedef int int16_t;

# 196 "/usr/include/i386-linux-gnu/sys/types.h"
typedef int int32_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 157 "/usr/include/spandsp/fast_convert.h"
static __inline__ long int lfastrint(double x)
    {
        long int retval;

        __asm__ __volatile__
        (
            "fistpl %0"
            : "=m" (retval)
            : "t" (x)
            : "st"
        );

        return retval;
    }

# 172 "/usr/include/spandsp/fast_convert.h"
static __inline__ long int lfastrintf(float x)
    {
        long int retval;

        __asm__ __volatile__
        (
            "fistpl %0"
            : "=m" (retval)
            : "t" (x)
            : "st"
        );
        return retval;
    }

# 45 "/usr/include/spandsp/bit_operations.h"
static __inline__ int top_bit(unsigned int bits)
{

    int res;

    __asm__ (" xorl %[res],%[res];\n"
             " decl %[res];\n"
             " bsrl %[bits],%[res]\n"
             : [res] "=&r" (res)
             : [bits] "rm" (bits));
    return res;
# 138 "/usr/include/spandsp/bit_operations.h" 3 4
}

# 144 "/usr/include/spandsp/bit_operations.h"
static __inline__ int bottom_bit(unsigned int bits)
{
    int res;


    __asm__ (" xorl %[res],%[res];\n"
             " decl %[res];\n"
             " bsfl %[bits],%[res]\n"
             : [res] "=&r" (res)
             : [bits] "rm" (bits));
    return res;
# 186 "/usr/include/spandsp/bit_operations.h" 3 4
}

# 46 "/usr/include/spandsp/timing.h"
static __inline__ uint64_t rdtscll(void)
{
    uint64_t now;

    __asm__ __volatile__(" rdtsc\n" : "=A" (now));
    return now;
}

# 177 "/usr/include/spandsp/saturated.h"
static __inline__ int16_t saturated_add16(int16_t a, int16_t b)
{

    __asm__ __volatile__(
        " addw %2,%0;\n"
        " jno 0f;\n"
        " movw $0x7fff,%0;\n"
        " adcw $0,%0;\n"
        "0:"
        : "=r" (a)
        : "0" (a), "ir" (b)
        : "cc"
    );
    return a;
# 203 "/usr/include/spandsp/saturated.h" 3 4
}

# 206 "/usr/include/spandsp/saturated.h"
static __inline__ int32_t saturated_add32(int32_t a, int32_t b)
{

    __asm__ __volatile__(
        " addl %2,%0;\n"
        " jno 0f;\n"
        " movl $0x7fffffff,%0;\n"
        " adcl $0,%0;\n"
        "0:"
        : "=r" (a)
        : "0" (a), "ir" (b)
        : "cc"
    );
    return a;
# 240 "/usr/include/spandsp/saturated.h" 3 4
}

# 243 "/usr/include/spandsp/saturated.h"
static __inline__ int16_t saturated_sub16(int16_t a, int16_t b)
{

    __asm__ __volatile__(
        " subw %2,%0;\n"
        " jno 0f;\n"
        " movw $0x8000,%0;\n"
        " sbbw $0,%0;\n"
        "0:"
        : "=r" (a)
        : "0" (a), "ir" (b)
        : "cc"
    );
    return a;
# 269 "/usr/include/spandsp/saturated.h" 3 4
}

# 272 "/usr/include/spandsp/saturated.h"
static __inline__ int32_t saturated_sub32(int32_t a, int32_t b)
{

    __asm__ __volatile__(
        " subl %2,%0;\n"
        " jno 0f;\n"
        " movl $0x80000000,%0;\n"
        " sbbl $0,%0;\n"
        "0:"
        : "=r" (a)
        : "0" (a), "ir" (b)
        : "cc"
    );
    return a;
# 306 "/usr/include/spandsp/saturated.h" 3 4
}

# 38 "/usr/lib/i386-linux-gnu/glib-2.0/include/glibconfig.h"
typedef unsigned char guint8;

# 40 "/usr/lib/i386-linux-gnu/glib-2.0/include/glibconfig.h"
typedef unsigned short guint16;

# 127 "/usr/include/gstreamer-1.0/gst/gstutils.h"
static inline guint16 __gst_fast_read_swap16(const guint8 *v) {
  return ((__extension__ ({ guint16 __v, __x = ((guint16) (*(const guint16*)(v))); if (__builtin_constant_p (__x)) __v = ((guint16) ( (guint16) ((guint16) (__x) >> 8) | (guint16) ((guint16) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
}

