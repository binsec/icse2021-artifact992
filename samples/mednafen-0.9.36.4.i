unsigned int __builtin_strlen (const char *);
int __builtin_strcmp (const char *, const char *);

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 42 "../../include/mednafen/types.h"
typedef uint32_t uint32;

# 20 "../../include/mednafen/memory.h"
static inline void MDFN_FastU32MemsetM8(uint32 *array, uint32 value_32, unsigned int u32len)
{

 uint32 dummy_output0, dummy_output1;
# 33 "../../include/mednafen/memory.h"
 asm volatile(
        "cld\n\t"
        "rep stosl\n\t"
        : "=D" (dummy_output0), "=c" (dummy_output1)
        : "a" (value_32), "D" (array), "c" (u32len)
        : "cc", "memory");
# 51 "../../include/mednafen/memory.h"
 //printf("%08x %d\n", (int)(long long)array, u32len);
}

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

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

# 37 "/usr/include/stdint.h"
typedef short int int16_t;

# 38 "/usr/include/stdint.h"
typedef int int32_t;

# 36 "../../include/mednafen/types.h"
typedef int16_t int16;

# 37 "../../include/mednafen/types.h"
typedef int32_t int32;

# 269 "filter.cpp"
static inline void DoMAC_MMX(int16 *wave, int16 *coeffs, int32 count, int32 *accum_output)
{
 // Multiplies 16 coefficients at a time.
 int dummy;

/*
 MMX register usage:
	mm0: Temporary sample load and multiply register
	mm2: Temporary sample load and multiply register

	mm1: accumulator, 2 32-bit signed values
	mm3: accumulator, 2 32-bit signed values

	mm4: accumulator, 2 32-bit signed values
	mm5: accumulator, 2 32-bit signed values

	mm6: Temporary sample load and multiply register, temporary summation register
	mm7: Temporary sample load and multiply register

*/
 asm volatile(
"pxor %%mm1, %%mm1\n\t"
"pxor %%mm3, %%mm3\n\t"
"pxor %%mm4, %%mm4\n\t"
"pxor %%mm5, %%mm5\n\t"
"MMX_Loop:\n\t"

"movq (%%" "e" "di), %%mm0\n\t"
"pmaddwd (%%" "e" "si), %%mm0\n\t"

"movq 8(%%" "e" "di), %%mm2\n\t"
"psrad $1, %%mm0\n\t"
"pmaddwd 8(%%" "e" "si), %%mm2\n\t"

"movq 16(%%" "e" "di), %%mm6\n\t"
"psrad $1, %%mm2\n\t"
"pmaddwd 16(%%" "e" "si), %%mm6\n\t"

"movq 24(%%" "e" "di), %%mm7\n\t"
"psrad $1, %%mm6\n\t"
"pmaddwd 24(%%" "e" "si), %%mm7\n\t"

"paddd %%mm0, %%mm1\n\t"
"paddd %%mm2, %%mm3\n\t"
"psrad $1, %%mm7\n\t"
"paddd %%mm6, %%mm4\n\t"
"paddd %%mm7, %%mm5\n\t"

"add" "l" " $32, %%" "e" "si\n\t"
"add" "l" " $32, %%" "e" "di\n\t"
"subl $1, %%ecx\n\t"
"jnz MMX_Loop\n\t"

//

"psrad $" "3" ", %%mm1\n\t"
"psrad $" "3" ", %%mm3\n\t"
"psrad $" "3" ", %%mm4\n\t"
"psrad $" "3" ", %%mm5\n\t"


// Now, mm1, mm3, mm4, mm5 contain 8 32-bit sums that need to be added together.

"paddd %%mm5, %%mm3\n\t"
"paddd %%mm4, %%mm1\n\t"
"paddd %%mm3, %%mm1\n\t"
"movq %%mm1, %%mm6\n\t"
"psrlq $32, %%mm6\n\t"
"paddd %%mm6, %%mm1\n\t"

"psrad $15, %%mm1\n\t"
//"psrad $16, %%mm1\n\t"
"movd %%mm1, (%%" "e" "dx)\n\t"
 : "=D" (dummy), "=S" (dummy), "=c" (dummy)
 : "D" (wave), "S" (coeffs), "c" ((count + 0xF) >> 4), "d" (accum_output)
 : "cc", "memory"



    // gcc has a bug or weird design flaw or something in it that keeps this from working properly: , "st", "st(1)", "st(2)", "st(3)", "st(4)", "st(5)", "st(6)", "st(7)"

);
}

# 109 "/usr/include/i386-linux-gnu/bits/fenv.h"
extern int __feraiseexcept_renamed (int) /* throw () */ __asm__ ("" "feraiseexcept");

# 110 "/usr/include/i386-linux-gnu/bits/fenv.h"
extern __inline int
 feraiseexcept (int __excepts) /* throw () */
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

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 147 "/usr/include/string.h"
extern int strncmp (const char *__s1, const char *__s2, size_t __n);

# 399 "/usr/include/string.h"
extern size_t strlen (const char *__s);

# 60 "cputest/x86_cpu.h"
typedef int32_t x86_reg;

/*@ rustina_out_of_scope */
# 42 "cputest/x86_cpu.c"
int ff_get_cpu_flags_x86(void)
{
    int rval = 0;
    int eax, ebx, ecx, edx;
    int max_std_level, max_ext_level, std_caps=0, ext_caps=0;
    int family=0, model=0;
    union { int i[3]; char c[12]; } vendor;


    x86_reg a, c;
    __asm__ volatile (
        /* See if CPUID instruction is supported ... */
        /* ... Get copies of EFLAGS into eax and ecx */
        "pushfl\n\t"
        "pop %0\n\t"
        "mov %0, %1\n\t"

        /* ... Toggle the ID bit in one copy and store */
        /*     to the EFLAGS reg */
        "xor $0x200000, %0\n\t"
        "push %0\n\t"
        "popfl\n\t"

        /* ... Get the (hopefully modified) EFLAGS */
        "pushfl\n\t"
        "pop %0\n\t"
        : "=a" (a), "=c" (c)
        :
        : "cc"
        );

    if (a == c)
        return 0; /* CPUID not supported */


    __asm__ volatile ("mov %%""ebx"", %%""esi""\n\t" "cpuid\n\t" "xchg %%""ebx"", %%""esi" : "=a" (max_std_level), "=S" (vendor.i[0]), "=c" (vendor.i[2]), "=d" (vendor.i[1]) : "0" (0));;

    if(max_std_level >= 1){
        __asm__ volatile ("mov %%""ebx"", %%""esi""\n\t" "cpuid\n\t" "xchg %%""ebx"", %%""esi" : "=a" (eax), "=S" (ebx), "=c" (ecx), "=d" (std_caps) : "0" (1));;
        family = ((eax>>8)&0xf) + ((eax>>20)&0xff);
        model = ((eax>>4)&0xf) + ((eax>>12)&0xf0);

 // Mednafen addition(cmov):
 if (std_caps & (1<<15))
     rval |= 0x8000 /* CMOVcc support (Mednafen addition)*/;

        if (std_caps & (1<<23))
            rval |= 0x0001 /*|< standard MMX*/;
        if (std_caps & (1<<25))
            rval |= 0x0002 /*|< SSE integer functions or AMD MMX ext*/
//#if HAVE_SSE
                  | 0x0008 /*|< SSE functions*/;
        if (std_caps & (1<<26))
            rval |= 0x0010 /*|< PIV SSE2 functions*/;
        if (ecx & 1)
            rval |= 0x0040 /*|< Prescott SSE3 functions*/;
        if (ecx & 0x00000200 )
            rval |= 0x0080 /*|< Conroe SSSE3 functions*/;
        if (ecx & 0x00080000 )
            rval |= 0x0100 /*|< Penryn SSE4.1 functions*/;
        if (ecx & 0x00100000 )
            rval |= 0x0200 /*|< Nehalem SSE4.2 functions*/;
//#if HAVE_AVX
        /* Check OXSAVE and AVX bits */
        if ((ecx & 0x18000000) == 0x18000000) {
            /* Check for OS support */
            __asm__ (".byte 0x0f, 0x01, 0xd0" : "=a"(eax), "=d"(edx) : "c" (0));
            if ((eax & 0x6) == 0x6)
                rval |= 0x4000 /*|< AVX functions: requires OS support even if YMM registers aren't used*/;
        }
//#endif
//#endif
                  ;
    }

    __asm__ volatile ("mov %%""ebx"", %%""esi""\n\t" "cpuid\n\t" "xchg %%""ebx"", %%""esi" : "=a" (max_ext_level), "=S" (ebx), "=c" (ecx), "=d" (edx) : "0" (0x80000000));;

    if(max_ext_level >= 0x80000001){
        __asm__ volatile ("mov %%""ebx"", %%""esi""\n\t" "cpuid\n\t" "xchg %%""ebx"", %%""esi" : "=a" (eax), "=S" (ebx), "=c" (ecx), "=d" (ext_caps) : "0" (0x80000001));;
        if (ext_caps & (1<<31))
            rval |= 0x0004 /*|< AMD 3DNOW*/;
        if (ext_caps & (1<<30))
            rval |= 0x0020 /*|< AMD 3DNowExt*/;
        if (ext_caps & (1<<23))
            rval |= 0x0001 /*|< standard MMX*/;
        if (ext_caps & (1<<22))
            rval |= 0x0002 /*|< SSE integer functions or AMD MMX ext*/;

        /* Allow for selectively disabling SSE2 functions on AMD processors
           with SSE2 support but not SSE4a. This includes Athlon64, some
           Opteron, and some Sempron processors. MMX, SSE, or 3DNow! are faster
           than SSE2 often enough to utilize this special-case flag.
           CPUTEST_FLAG_SSE2 and CPUTEST_FLAG_SSE2SLOW are both set in this case
           so that SSE2 is used unless explicitly disabled by checking
           CPUTEST_FLAG_SSE2SLOW. */
        if (!(__extension__ (__builtin_constant_p (12) && ((__builtin_constant_p (vendor.c) && strlen (vendor.c) < ((size_t) (12))) || (__builtin_constant_p ("AuthenticAMD") && strlen ("AuthenticAMD") < ((size_t) (12)))) ? __extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (vendor.c) && __builtin_constant_p ("AuthenticAMD") && (__s1_len = __builtin_strlen (vendor.c), __s2_len = __builtin_strlen ("AuthenticAMD"), (!((size_t)(const void *)((vendor.c) + 1) - (size_t)(const void *)(vendor.c) == 1) || __s1_len >= 4) && (!((size_t)(const void *)(("AuthenticAMD") + 1) - (size_t)(const void *)("AuthenticAMD") == 1) || __s2_len >= 4)) ? __builtin_strcmp (vendor.c, "AuthenticAMD") : (__builtin_constant_p (vendor.c) && ((size_t)(const void *)((vendor.c) + 1) - (size_t)(const void *)(vendor.c) == 1) && (__s1_len = __builtin_strlen (vendor.c), __s1_len < 4) ? (__builtin_constant_p ("AuthenticAMD") && ((size_t)(const void *)(("AuthenticAMD") + 1) - (size_t)(const void *)("AuthenticAMD") == 1) ? __builtin_strcmp (vendor.c, "AuthenticAMD") : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) ("AuthenticAMD"); int __result = (((const unsigned char *) (const char *) (vendor.c))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (vendor.c))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (vendor.c))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (vendor.c))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p ("AuthenticAMD") && ((size_t)(const void *)(("AuthenticAMD") + 1) - (size_t)(const void *)("AuthenticAMD") == 1) && (__s2_len = __builtin_strlen ("AuthenticAMD"), __s2_len < 4) ? (__builtin_constant_p (vendor.c) && ((size_t)(const void *)((vendor.c) + 1) - (size_t)(const void *)(vendor.c) == 1) ? __builtin_strcmp (vendor.c, "AuthenticAMD") : (- (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (vendor.c); int __result = (((const unsigned char *) (const char *) ("AuthenticAMD"))[0] - __s2[0]); if (__s2_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) ("AuthenticAMD"))[1] - __s2[1]); if (__s2_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) ("AuthenticAMD"))[2] - __s2[2]); if (__s2_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) ("AuthenticAMD"))[3] - __s2[3]); } } __result; })))) : __builtin_strcmp (vendor.c, "AuthenticAMD")))); }) : strncmp (vendor.c, "AuthenticAMD", 12))) &&
            rval & 0x0010 /*|< PIV SSE2 functions*/ && !(ecx & 0x00000040)) {
            rval |= 0x40000000 /*|< SSE2 supported, but usually not faster*/;
        }
    }

    if (!(__extension__ (__builtin_constant_p (12) && ((__builtin_constant_p (vendor.c) && strlen (vendor.c) < ((size_t) (12))) || (__builtin_constant_p ("GenuineIntel") && strlen ("GenuineIntel") < ((size_t) (12)))) ? __extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (vendor.c) && __builtin_constant_p ("GenuineIntel") && (__s1_len = __builtin_strlen (vendor.c), __s2_len = __builtin_strlen ("GenuineIntel"), (!((size_t)(const void *)((vendor.c) + 1) - (size_t)(const void *)(vendor.c) == 1) || __s1_len >= 4) && (!((size_t)(const void *)(("GenuineIntel") + 1) - (size_t)(const void *)("GenuineIntel") == 1) || __s2_len >= 4)) ? __builtin_strcmp (vendor.c, "GenuineIntel") : (__builtin_constant_p (vendor.c) && ((size_t)(const void *)((vendor.c) + 1) - (size_t)(const void *)(vendor.c) == 1) && (__s1_len = __builtin_strlen (vendor.c), __s1_len < 4) ? (__builtin_constant_p ("GenuineIntel") && ((size_t)(const void *)(("GenuineIntel") + 1) - (size_t)(const void *)("GenuineIntel") == 1) ? __builtin_strcmp (vendor.c, "GenuineIntel") : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) ("GenuineIntel"); int __result = (((const unsigned char *) (const char *) (vendor.c))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (vendor.c))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (vendor.c))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (vendor.c))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p ("GenuineIntel") && ((size_t)(const void *)(("GenuineIntel") + 1) - (size_t)(const void *)("GenuineIntel") == 1) && (__s2_len = __builtin_strlen ("GenuineIntel"), __s2_len < 4) ? (__builtin_constant_p (vendor.c) && ((size_t)(const void *)((vendor.c) + 1) - (size_t)(const void *)(vendor.c) == 1) ? __builtin_strcmp (vendor.c, "GenuineIntel") : (- (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (vendor.c); int __result = (((const unsigned char *) (const char *) ("GenuineIntel"))[0] - __s2[0]); if (__s2_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) ("GenuineIntel"))[1] - __s2[1]); if (__s2_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) ("GenuineIntel"))[2] - __s2[2]); if (__s2_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) ("GenuineIntel"))[3] - __s2[3]); } } __result; })))) : __builtin_strcmp (vendor.c, "GenuineIntel")))); }) : strncmp (vendor.c, "GenuineIntel", 12)))) {
        if (family == 6 && (model == 9 || model == 13 || model == 14)) {
            /* 6/9 (pentium-m "banias"), 6/13 (pentium-m "dothan"), and 6/14 (core1 "yonah")
            * theoretically support sse2, but it's usually slower than mmx,
            * so let's just pretend they don't. CPUTEST_FLAG_SSE2 is disabled and
            * CPUTEST_FLAG_SSE2SLOW is enabled so that SSE2 is not used unless
            * explicitly enabled by checking CPUTEST_FLAG_SSE2SLOW. The same
            * situation applies for CPUTEST_FLAG_SSE3 and CPUTEST_FLAG_SSE3SLOW. */
            if (rval & 0x0010 /*|< PIV SSE2 functions*/) rval ^= 0x40000000 /*|< SSE2 supported, but usually not faster*/|0x0010 /*|< PIV SSE2 functions*/;
            if (rval & 0x0040 /*|< Prescott SSE3 functions*/) rval ^= 0x20000000 /*|< SSE3 supported, but usually not faster*/|0x0040 /*|< Prescott SSE3 functions*/;
        }
        /* The Atom processor has SSSE3 support, which is useful in many cases,
         * but sometimes the SSSE3 version is slower than the SSE2 equivalent
         * on the Atom, but is generally faster on other processors supporting
         * SSSE3. This flag allows for selectively disabling certain SSSE3
         * functions on the Atom. */
        if (family == 6 && model == 28)
            rval |= 0x10000000 /*|< Atom processor, some SSSE3 instructions are slower*/;
    }

    return rval;
}

# 424 "OwlResampler.cpp"
static inline void DoMAC_SSE(float *wave, float *coeffs, int32 count, int32 *accum_output)
{
 // Multiplies 16 coefficients at a time.
 int dummy;

 //printf("%f\n", adj);
/*
	?di = wave pointer
	?si = coeffs pointer
	ecx = count / 16
	edx = 32-bit int output pointer


*/
 // Will read 16 bytes of input waveform past end.
 asm volatile(
"xorps %%xmm3, %%xmm3\n\t" // For a loop optimization

"xorps %%xmm4, %%xmm4\n\t"
"xorps %%xmm5, %%xmm5\n\t"
"xorps %%xmm6, %%xmm6\n\t"
"xorps %%xmm7, %%xmm7\n\t"

"movups  0(%%" "e" "di), %%xmm0\n\t"
"SSE_Loop:\n\t"

"movups 16(%%" "e" "di), %%xmm1\n\t"
"mulps   0(%%" "e" "si), %%xmm0\n\t"
"addps  %%xmm3, %%xmm7\n\t"

"movups 32(%%" "e" "di), %%xmm2\n\t"
"mulps  16(%%" "e" "si), %%xmm1\n\t"
"addps  %%xmm0, %%xmm4\n\t"

"movups 48(%%" "e" "di), %%xmm3\n\t"
"mulps  32(%%" "e" "si), %%xmm2\n\t"
"addps  %%xmm1, %%xmm5\n\t"

"movups 64(%%" "e" "di), %%xmm0\n\t"
"mulps  48(%%" "e" "si), %%xmm3\n\t"
"addps  %%xmm2, %%xmm6\n\t"

"add" "l" " $64, %%" "e" "si\n\t"
"add" "l" " $64, %%" "e" "di\n\t"
"subl $1, %%ecx\n\t"
"jnz SSE_Loop\n\t"

"addps  %%xmm3, %%xmm7\n\t" // For a loop optimization

//
// Add the four summation xmm regs together into one xmm register, xmm7
//
"addps  %%xmm4, %%xmm5\n\t"
"addps  %%xmm6, %%xmm7\n\t"
"addps  %%xmm5, %%xmm7\n\t"

//
// Now for the "fun" horizontal addition...
//
//
"movaps %%xmm7, %%xmm4\n\t"
// (3 * 2^0) + (2 * 2^2) + (1 * 2^4) + (0 * 2^6) = 27
"shufps $27, %%xmm7, %%xmm4\n\t"
"addps  %%xmm4, %%xmm7\n\t"

// At this point, xmm7:
// (3 + 0), (2 + 1), (1 + 2), (0 + 3)
//
// (1 * 2^0) + (0 * 2^2) = 1
"movaps %%xmm7, %%xmm4\n\t"
"shufps $1, %%xmm7, %%xmm4\n\t"
"addss %%xmm4, %%xmm7\n\t" // No sense in doing packed addition here.

"cvtss2si %%xmm7, %%ecx\n\t"
"movl %%ecx, (%%" "e" "dx)\n\t"
 : "=D" (dummy), "=S" (dummy), "=c" (dummy)
 : "D" (wave), "S" (coeffs), "c" (count >> 4), "d" (accum_output)



 : "cc", "memory"

);
}
