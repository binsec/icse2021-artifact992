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

# 432 "configuration.cpp"
void host_get_cpuid (uint32_t t, uint32_t* eax, uint32_t* ebx, uint32_t* ecx, uint32_t* edx)
{
 asm ("pushl %%ebx\n\t"
      "movl %%esi, %%ebx\n\t"
      "cpuid\n\t"
      "movl %%ebx, %%esi\n\t"
      "popl %%ebx"
      : "=a" (*eax)
      , "=S" (*ebx)
      , "=c" (*ecx)
      , "=d" (*edx)
      : "a" (t)
      , "c" (0)
      , "S" (0)
      , "d" (0));
}

