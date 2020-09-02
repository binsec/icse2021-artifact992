# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 195 "src/od-fs/../include/sysdeps.h"
typedef uint16_t uae_u16;

# 196 "src/od-fs/../include/sysdeps.h"
typedef uint32_t uae_u32;

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

# 9 "src/od-fs/machdep/x86/maccess.h"
static inline uae_u32 do_get_mem_long (uae_u32 *a)
{
    uae_u32 retval;

    __asm__ ("bswap %0" : "=r" (retval) : "0" (*a) : "cc");
    return retval;
}

# 17 "src/od-fs/machdep/x86/maccess.h"
static inline uae_u32 do_get_mem_word (uae_u16 *a)
{
    uae_u32 retval;




    __asm__ ("xorl %k0,%k0\n\tmovw %w1,%w0\n\trolw $8,%w0" : "=&r" (retval) : "m" (*a) : "cc");

    return retval;
}

# 31 "src/od-fs/machdep/x86/maccess.h"
static inline void do_put_mem_long (uae_u32 *a, uae_u32 v)
{
    __asm__ ("bswap %0" : "=r" (v) : "0" (v) : "cc");
    *a = v;
}

# 37 "src/od-fs/machdep/x86/maccess.h"
static inline void do_put_mem_word (uae_u16 *a, uae_u32 v)
{



    __asm__ ("rolw $8,%w0" : "=r" (v) : "0" (v) : "cc");

    *a = v;
}

# 26 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned int __u32;

# 30 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned long long __u64;

# 7 "/usr/include/i386-linux-gnu/asm/swab.h"
static __inline__ __u32 __arch_swab32(__u32 val)
{
 __asm__("bswapl %0" : "=r" (val) : "0" (val));
 return val;
}

# 14 "/usr/include/i386-linux-gnu/asm/swab.h"
static __inline__ __u64 __arch_swab64(__u64 val)
{

 union {
  struct {
   __u32 a;
   __u32 b;
  } s;
  __u64 u;
 } v;
 v.u = val;
 __asm__("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
     : "=r" (v.s.a), "=r" (v.s.b)
     : "0" (v.s.a), "1" (v.s.b));
 return v.u;




}

