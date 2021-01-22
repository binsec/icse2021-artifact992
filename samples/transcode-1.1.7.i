unsigned int __builtin_strlen (const char *);
int __builtin_strcmp (const char *, const char *);

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

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 222 "accore.c"
static int cpuinfo_x86(void)
{
    uint32_t eax, ebx, ecx, edx;
    uint32_t cpuid_max, cpuid_ext_max; /* Maximum CPUID function numbers */
    union {
        char string[13];
        struct { uint32_t ebx, edx, ecx; } regs;
    } cpu_vendor; /* 12-byte CPU vendor string + trailing null */
    uint32_t cpuid_1D, cpuid_1C, cpuid_X1C, cpuid_X1D;
    int accel;

    /* First see if the CPUID instruction is even available.  We try to
     * toggle bit 21 (ID) of the flags register; if the bit changes, then
     * CPUID is available. */
    asm("pushfl""                  \n        pop "
             "%%eax""               \n        mov %%eax, %%edx        \n        xor $0x200000, %%eax    \n        push "


              "%%eax""              \n        "
         "popfl""                  \n        "
         "pushfl""                 \n        pop "
             "%%eax""               \n        xor %%edx, %%eax"

        : "=a" (eax) : : "edx");
    if (!eax)
        return 0;

    /* Determine the maximum function number available, and save the vendor
     * string */
    asm("mov ""%%ebx"", ""%%esi""; cpuid; xchg ""%%ebx"", ""%%esi" : "=a" (cpuid_max), "=S" (ebx), "=c" (ecx), "=d" (edx) : "a" (0));
    cpu_vendor.regs.ebx = ebx;
    cpu_vendor.regs.ecx = ecx;
    cpu_vendor.regs.edx = edx;
    cpu_vendor.string[12] = 0;
    cpuid_ext_max = 0; /* FIXME: how do early CPUs respond to 0x80000000? */
    asm("mov ""%%ebx"", ""%%esi""; cpuid; xchg ""%%ebx"", ""%%esi" : "=a" (cpuid_ext_max), "=S" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x80000000));

    /* Read available features */
    cpuid_1D = cpuid_1C = cpuid_X1C = cpuid_X1D = 0;
    if (cpuid_max >= 1)
        asm("mov ""%%ebx"", ""%%esi""; cpuid; xchg ""%%ebx"", ""%%esi" : "=a" (eax), "=S" (ebx), "=c" (cpuid_1C), "=d" (cpuid_1D) : "a" (1));
    if (cpuid_ext_max >= 0x80000001)
        asm("mov ""%%ebx"", ""%%esi""; cpuid; xchg ""%%ebx"", ""%%esi" : "=a" (eax), "=S" (ebx), "=c" (cpuid_X1C), "=d" (cpuid_X1D) : "a" (0x80000001));

    /* Convert to acceleration flags */



    accel = 0x0001 /* x86-32: standard assembly (no MMX) */;

    if (cpuid_1D & (1UL<<15))
        accel |= 0x0004 /* x86: CMOVcc instruction */;
    if (cpuid_1D & (1UL<<23))
        accel |= 0x0008 /* x86: MMX instructions */;
    if (cpuid_1D & (1UL<<25))
        accel |= 0x0080 /* x86: SSE instructions */;
    if (cpuid_1D & (1UL<<26))
        accel |= 0x0100 /* x86: SSE2 instructions */;
    if (cpuid_1C & (1UL<< 0))
        accel |= 0x0200 /* x86: SSE3 instructions */;
    if (cpuid_1C & (1UL<< 9))
        accel |= 0x0400 /* x86: SSSE3 instructions */;
    if (cpuid_1C & (1UL<<19))
        accel |= 0x0800 /* x86: SSE4.1 instructions */;
    if (cpuid_1C & (1UL<<20))
        accel |= 0x1000 /* x86: SSE4.2 instructions (Intel) */;
    if (__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (cpu_vendor.string) && __builtin_constant_p ("AuthenticAMD") && (__s1_len = __builtin_strlen (cpu_vendor.string), __s2_len = __builtin_strlen ("AuthenticAMD"), (!((size_t)(const void *)((cpu_vendor.string) + 1) - (size_t)(const void *)(cpu_vendor.string) == 1) || __s1_len >= 4) && (!((size_t)(const void *)(("AuthenticAMD") + 1) - (size_t)(const void *)("AuthenticAMD") == 1) || __s2_len >= 4)) ? __builtin_strcmp (cpu_vendor.string, "AuthenticAMD") : (__builtin_constant_p (cpu_vendor.string) && ((size_t)(const void *)((cpu_vendor.string) + 1) - (size_t)(const void *)(cpu_vendor.string) == 1) && (__s1_len = __builtin_strlen (cpu_vendor.string), __s1_len < 4) ? (__builtin_constant_p ("AuthenticAMD") && ((size_t)(const void *)(("AuthenticAMD") + 1) - (size_t)(const void *)("AuthenticAMD") == 1) ? __builtin_strcmp (cpu_vendor.string, "AuthenticAMD") : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) ("AuthenticAMD"); int __result = (((const unsigned char *) (const char *) (cpu_vendor.string))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (cpu_vendor.string))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (cpu_vendor.string))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (cpu_vendor.string))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p ("AuthenticAMD") && ((size_t)(const void *)(("AuthenticAMD") + 1) - (size_t)(const void *)("AuthenticAMD") == 1) && (__s2_len = __builtin_strlen ("AuthenticAMD"), __s2_len < 4) ? (__builtin_constant_p (cpu_vendor.string) && ((size_t)(const void *)((cpu_vendor.string) + 1) - (size_t)(const void *)(cpu_vendor.string) == 1) ? __builtin_strcmp (cpu_vendor.string, "AuthenticAMD") : (- (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (cpu_vendor.string); int __result = (((const unsigned char *) (const char *) ("AuthenticAMD"))[0] - __s2[0]); if (__s2_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) ("AuthenticAMD"))[1] - __s2[1]); if (__s2_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) ("AuthenticAMD"))[2] - __s2[2]); if (__s2_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) ("AuthenticAMD"))[3] - __s2[3]); } } __result; })))) : __builtin_strcmp (cpu_vendor.string, "AuthenticAMD")))); }) == 0) {
        if (cpuid_X1D & (1UL<<22) /* AMD only */)
            accel |= 0x0010 /* x86: MMX extended instructions (AMD) */;
        if (cpuid_X1D & (1UL<<31) /* AMD only */)
            accel |= 0x0020 /* x86: 3DNow! instructions (AMD) */;
        if (cpuid_X1D & (1UL<<30) /* AMD only */)
            accel |= 0x0040 /* x86: 3DNow! instructions (AMD) */;
        if (cpuid_X1C & (1UL<< 6) /* AMD only */)
            accel |= 0x2000 /* x86: SSE4a instructions (AMD) */;
        if (cpuid_X1C & (1UL<<11) /* AMD only */)
            accel |= 0x4000 /* x86: SSE5 instructions (AMD) */;
    } else if (__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (cpu_vendor.string) && __builtin_constant_p ("CyrixInstead") && (__s1_len = __builtin_strlen (cpu_vendor.string), __s2_len = __builtin_strlen ("CyrixInstead"), (!((size_t)(const void *)((cpu_vendor.string) + 1) - (size_t)(const void *)(cpu_vendor.string) == 1) || __s1_len >= 4) && (!((size_t)(const void *)(("CyrixInstead") + 1) - (size_t)(const void *)("CyrixInstead") == 1) || __s2_len >= 4)) ? __builtin_strcmp (cpu_vendor.string, "CyrixInstead") : (__builtin_constant_p (cpu_vendor.string) && ((size_t)(const void *)((cpu_vendor.string) + 1) - (size_t)(const void *)(cpu_vendor.string) == 1) && (__s1_len = __builtin_strlen (cpu_vendor.string), __s1_len < 4) ? (__builtin_constant_p ("CyrixInstead") && ((size_t)(const void *)(("CyrixInstead") + 1) - (size_t)(const void *)("CyrixInstead") == 1) ? __builtin_strcmp (cpu_vendor.string, "CyrixInstead") : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) ("CyrixInstead"); int __result = (((const unsigned char *) (const char *) (cpu_vendor.string))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (cpu_vendor.string))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (cpu_vendor.string))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (cpu_vendor.string))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p ("CyrixInstead") && ((size_t)(const void *)(("CyrixInstead") + 1) - (size_t)(const void *)("CyrixInstead") == 1) && (__s2_len = __builtin_strlen ("CyrixInstead"), __s2_len < 4) ? (__builtin_constant_p (cpu_vendor.string) && ((size_t)(const void *)((cpu_vendor.string) + 1) - (size_t)(const void *)(cpu_vendor.string) == 1) ? __builtin_strcmp (cpu_vendor.string, "CyrixInstead") : (- (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (cpu_vendor.string); int __result = (((const unsigned char *) (const char *) ("CyrixInstead"))[0] - __s2[0]); if (__s2_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) ("CyrixInstead"))[1] - __s2[1]); if (__s2_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) ("CyrixInstead"))[2] - __s2[2]); if (__s2_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) ("CyrixInstead"))[3] - __s2[3]); } } __result; })))) : __builtin_strcmp (cpu_vendor.string, "CyrixInstead")))); }) == 0) {
        if (cpuid_X1D & (1UL<<24) /* Cyrix only */)
            accel |= 0x0010 /* x86: MMX extended instructions (AMD) */;
    }

    /* And return */
    return accel;
}

# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

# 355 "img_rgb_packed.c"
static int rgba_swapall_x86(uint8_t **src, uint8_t **dest, int width, int height)
{
    asm("0: ""movl -4(""%%esi"",""%%ecx"",4), %%eax                                  \n        xchg %%ah, %%al                                                 \n        roll $16, %%eax                                                 \n        xchg %%ah, %%al                                                 \n        movl %%eax, -4(""%%edi"",""%%ecx"",4)""                                                 \n        subl $1, %%ecx                                                  \n        jnz 0b" : /* no outputs */ : "S" (src[0]), "D" (dest[0]), "c" (width*height) : "eax");
    return 1;
}

# 362 "img_rgb_packed.c"
static int rgba_swap02_x86(uint8_t **src, uint8_t **dest, int width, int height)
{
    asm("0: ""movw -4(""%%esi"",""%%ecx"",4), %%ax                                   \n        movw -2(""%%esi"",""%%ecx"",4), %%dx                                    \n        xchg %%dl, %%al                                                 \n        movw %%ax, -4(""%%edi"",""%%ecx"",4)                                    \n        movw %%dx, -2(""%%edi"",""%%ecx"",4)""                                             \n        subl $1, %%ecx                                                  \n        jnz 0b" : /* no outputs */ : "S" (src[0]), "D" (dest[0]), "c" (width*height) : "eax", "edx");
    return 1;
}

# 369 "img_rgb_packed.c"
static int rgba_swap13_x86(uint8_t **src, uint8_t **dest, int width, int height)
{
    asm("0: ""movw -4(""%%esi"",""%%ecx"",4), %%ax                                   \n        movw -2(""%%esi"",""%%ecx"",4), %%dx                                    \n        xchg %%dh, %%ah                                                 \n        movw %%ax, -4(""%%edi"",""%%ecx"",4)                                    \n        movw %%dx, -2(""%%edi"",""%%ecx"",4)""                                             \n        subl $1, %%ecx                                                  \n        jnz 0b" : /* no outputs */ : "S" (src[0]), "D" (dest[0]), "c" (width*height) : "eax", "edx");
    return 1;
}

# 376 "img_rgb_packed.c"
static int rgba_alpha30_x86(uint8_t **src, uint8_t **dest, int width, int height)
{
    asm("0: ""movl -4(""%%esi"",""%%ecx"",4), %%eax                                  \n        roll $8, %%eax                                                  \n        movl %%eax, -4(""%%edi"",""%%ecx"",4)""                                                 \n        subl $1, %%ecx                                                  \n        jnz 0b" : /* no outputs */ : "S" (src[0]), "D" (dest[0]), "c" (width*height) : "eax");
    return 1;
}

# 383 "img_rgb_packed.c"
static int rgba_alpha03_x86(uint8_t **src, uint8_t **dest, int width, int height)
{
    asm("0: ""movl -4(""%%esi"",""%%ecx"",4), %%eax                                  \n        rorl $8, %%eax                                                  \n        movl %%eax, -4(""%%edi"",""%%ecx"",4)""                                                 \n        subl $1, %%ecx                                                  \n        jnz 0b" : /* no outputs */ : "S" (src[0]), "D" (dest[0]), "c" (width*height) : "eax");
    return 1;
}

# 93 "img_yuv_packed.c"
static int yuv16_swap16_x86(uint8_t **src, uint8_t **dest, int width, int height)
{
    asm("0: ""movl -4(""%%esi"",""%%ecx"",4), %%eax                                  \n        movl %%eax, %%edx                                               \n        shll $8, %%eax                                                  \n        andl $0xFF00FF00, %%eax                                         \n        shrl $8, %%edx                                                  \n        andl $0x00FF00FF, %%edx                                         \n        orl %%edx, %%eax                                                \n        movl %%eax, -4(""%%edi"",""%%ecx"",4)""                                              \n        subl $1, %%ecx                                                  \n        jnz 0b" : /* no outputs */ : "S" (src[0]), "D" (dest[0]), "c" (width*height/2) : "eax", "edx");
    if (width*height % 1)
        ((uint16_t *)(dest[0]))[width*height-1] =
            src[0][width*height*2-2]<<8 | src[0][width*height*2-1];
    return 1;
}

# 102 "img_yuv_packed.c"
static int yuv16_swapuv_x86(uint8_t **src, uint8_t **dest, int width, int height)
{
    asm("0: ""movw -4(""%%esi"",""%%ecx"",4), %%ax                                   \n        movw -2(""%%esi"",""%%ecx"",4), %%dx                                    \n        xchg %%dh, %%ah                                                 \n        movw %%ax, -4(""%%edi"",""%%ecx"",4)                                    \n        movw %%dx, -2(""%%edi"",""%%ecx"",4)""                                             \n        subl $1, %%ecx                                                  \n        jnz 0b" : /* no outputs */ : "S" (src[0]), "D" (dest[0]), "c" (width*height/2) : "eax", "edx");
    return 1;
}

# 108 "img_yuv_packed.c"
static int uyvy_yvyu_x86(uint8_t **src, uint8_t **dest, int width, int height)
{
    asm("0: ""movl -4(""%%esi"",""%%ecx"",4), %%eax                                  \n        rorl $8, %%eax                                                  \n        movl %%eax, -4(""%%edi"",""%%ecx"",4)""                                                 \n        subl $1, %%ecx                                                  \n        jnz 0b" : /* no outputs */ : "S" (src[0]), "D" (dest[0]), "c" (width*height/2) : "eax");
    if (width*height % 1)
        ((uint16_t *)(dest[0]))[width*height-1] =
            src[0][width*height*2-2]<<8 | src[0][width*height*2-1];
    return 1;
}

# 117 "img_yuv_packed.c"
static int yvyu_uyvy_x86(uint8_t **src, uint8_t **dest, int width, int height)
{
    asm("0: ""movl -4(""%%esi"",""%%ecx"",4), %%eax                                  \n        roll $8, %%eax                                                  \n        movl %%eax, -4(""%%edi"",""%%ecx"",4)""                                                 \n        subl $1, %%ecx                                                  \n        jnz 0b" : /* no outputs */ : "S" (src[0]), "D" (dest[0]), "c" (width*height/2) : "eax");
    if (width*height % 1)
        ((uint16_t *)(dest[0]))[width*height-1] =
            src[0][width*height*2-2]<<8 | src[0][width*height*2-1];
    return 1;
}

# 264 "/usr/include/freetype2/config/ftconfig.h"
typedef signed int FT_Int32;

# 449 "/usr/include/freetype2/config/ftconfig.h"
static __inline__ FT_Int32
  FT_MulFix_i386( FT_Int32 a,
                  FT_Int32 b )
  {
    register FT_Int32 result;


    __asm__ __volatile__ (
      "imul  %%edx\n"
      "movl  %%edx, %%ecx\n"
      "sarl  $31, %%ecx\n"
      "addl  $0x8000, %%ecx\n"
      "addl  %%ecx, %%eax\n"
      "adcl  $0, %%edx\n"
      "shrl  $16, %%eax\n"
      "shll  $16, %%edx\n"
      "addl  %%edx, %%eax\n"
      : "=a"(result), "=d"(b)
      : "a"(a), "d"(b)
      : "%ecx", "cc" );
    return result;
  }

# 72 "load_font.c"
static inline uint16_t ByteSwap16(uint16_t x)
{
  __asm("xchgb %b0,%h0" :
        "=q" (x) :
        "0" (x));
    return x;
}

# 81 "load_font.c"
static inline uint32_t ByteSwap32(uint32_t x)
{




 __asm("xchgb	%b0,%h0\n"
      "	rorl	$16,%0\n"
      "	xchgb	%b0,%h0":
      "=q" (x) :

      "0" (x));
  return x;
}

# 97 "load_font.c"
static inline uint64_t ByteSwap64(uint64_t x)
{






  register union { __extension__ uint64_t __ll;
          uint32_t __l[2]; } __x;
  asm("xchgl	%0,%1":
      "=r"(__x.__l[0]),"=r"(__x.__l[1]):
      "0"(ByteSwap32((uint32_t)x)),"1"(ByteSwap32((uint32_t)(x>>32))));
  return __x.__ll;

}

