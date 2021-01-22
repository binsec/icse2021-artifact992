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

# 33 "cpu_accel.c"
static uint32_t arch_accel (uint32_t accel)
{
    if (accel & (2 | 4))
 accel |= 1;

    if (accel & (8 | 16))
 accel |= 4;

    if (accel & (16))
 accel |= 8;


    if (accel & 0x80000000) {
 uint32_t eax, ebx, ecx, edx;
 int AMD;
# 73 "cpu_accel.c"
 __asm__ ("pushf\n\t"
   "pushf\n\t"
   "pop %0\n\t"
   "movl %0,%1\n\t"
   "xorl $0x200000,%0\n\t"
   "push %0\n\t"
   "popf\n\t"
   "pushf\n\t"
   "pop %0\n\t"
   "popf"
   : "=r" (eax),
   "=r" (ebx)
   :
   : "cc");

 if (eax == ebx) /* no cpuid */
     return accel;


 __asm__ ("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x00000000) : "cc");
 if (!eax) /* vendor string only */
     return accel;

 AMD = (ebx == 0x68747541 && ecx == 0x444d4163 && edx == 0x69746e65);

 __asm__ ("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x00000001) : "cc");
 if (! (edx & 0x00800000)) /* no MMX */
     return accel;

 accel |= 1;
 if (edx & 0x02000000) /* SSE - identical to AMD MMX ext. */
     accel |= 4;

 if (edx & 0x04000000) /* SSE2 */
     accel |= 8;

 if (ecx & 0x00000001) /* SSE3 */
     accel |= 16;

 __asm__ ("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x80000000) : "cc");
 if (eax < 0x80000001) /* no extended capabilities */
     return accel;

 __asm__ ("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x80000001) : "cc");

 if (edx & 0x80000000)
     accel |= 2;

 if (AMD && (edx & 0x00400000)) /* AMD MMX extensions */
     accel |= 4;
    }


    return accel;
}

