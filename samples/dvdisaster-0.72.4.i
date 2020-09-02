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

/*@ rustina_out_of_scope */
# 210 "/usr/lib/gcc/i586-linux-gnu/4.9/include/cpuid.h"
static __inline unsigned int
__get_cpuid_max (unsigned int __ext, unsigned int *__sig)
{
  unsigned int __eax, __ebx, __ecx, __edx;


  /* See if we can use cpuid.  On AMD64 we always can.  */

  __asm__ ("pushf{l|d}\n\t"
    "pushf{l|d}\n\t"
    "pop{l}\t%0\n\t"
    "mov{l}\t{%0, %1|%1, %0}\n\t"
    "xor{l}\t{%2, %0|%0, %2}\n\t"
    "push{l}\t%0\n\t"
    "popf{l|d}\n\t"
    "pushf{l|d}\n\t"
    "pop{l}\t%0\n\t"
    "popf{l|d}\n\t"
    : "=&r" (__eax), "=&r" (__ebx)
    : "i" (0x00200000));
# 247 "/usr/lib/gcc/i586-linux-gnu/4.9/include/cpuid.h" 3 4
  if (!((__eax ^ __ebx) & 0x00200000))
    return 0;


  /* Host supports cpuid.  Return highest supported cpuid input value.  */
  __asm__ ("cpuid\n\t" : "=a" (__eax), "=b" (__ebx), "=c" (__ecx), "=d" (__edx) : "0" (__ext));

  if (__sig)
    *__sig = __ebx;

  return __eax;
}

# 265 "/usr/lib/gcc/i586-linux-gnu/4.9/include/cpuid.h"
static __inline int
__get_cpuid (unsigned int __level,
      unsigned int *__eax, unsigned int *__ebx,
      unsigned int *__ecx, unsigned int *__edx)
{
  unsigned int __ext = __level & 0x80000000;

  if (__get_cpuid_max (__ext, 0) < __level)
    return 0;

  __asm__ ("cpuid\n\t" : "=a" (*__eax), "=b" (*__ebx), "=c" (*__ecx), "=d" (*__edx) : "0" (__level));
  return 1;
}
