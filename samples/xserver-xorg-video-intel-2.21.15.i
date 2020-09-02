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
  __asm__ ("xchg{l}\t{%%}ebx, %k1\n\t" "cpuid\n\t" "xchg{l}\t{%%}ebx, %k1\n\t" : "=a" (__eax), "=&r" (__ebx), "=c" (__ecx), "=d" (__edx) : "0" (__ext));

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

  __asm__ ("xchg{l}\t{%%}ebx, %k1\n\t" "cpuid\n\t" "xchg{l}\t{%%}ebx, %k1\n\t" : "=a" (*__eax), "=&r" (*__ebx), "=c" (*__ecx), "=d" (*__edx) : "0" (__level));
  return 1;
}

# 40 "../../../src/sna/sna_cpu.c"
unsigned sna_cpu_detect(void)
{
 unsigned max = __get_cpuid_max(0x0, ((void *)0));
 unsigned int eax, ebx, ecx, edx;
 unsigned features = 0;
 unsigned extra = 0;

 if (max >= 1) {
  __asm__ ("xchg{l}\t{%%}ebx, %k1\n\t" "cpuid\n\t" "xchg{l}\t{%%}ebx, %k1\n\t" : "=a" (eax), "=&r" (ebx), "=c" (ecx), "=d" (edx) : "0" (1));
  if (ecx & (1 << 0))
   features |= 0x8;

  if (ecx & (1 << 9))
   features |= 0x10;

  if (ecx & (1 << 19))
   features |= 0x20;

  if (ecx & (1 << 20))
   features |= 0x40;

  if (ecx & (1 << 27)) {
   unsigned int bv_eax, bv_ecx;
   __asm__ ("xgetbv" : "=a"(bv_eax), "=d"(bv_ecx) : "c" (0));
   if ((bv_eax & 6) == 6)
    extra |= 0x1;
  }

  if ((extra & 0x1) && (ecx & (1 << 28)))
   features |= 0x80;

  if (edx & (1 << 23))
   features |= 0x1;

  if (edx & (1 << 25))
   features |= 0x2;

  if (edx & (1 << 26))
   features |= 0x4;
 }

 if (max >= 7) {
  __asm__ ("xchg{l}\t{%%}ebx, %k1\n\t" "cpuid\n\t" "xchg{l}\t{%%}ebx, %k1\n\t" : "=a" (eax), "=&r" (ebx), "=c" (ecx), "=d" (edx) : "0" (7), "2" (0));
  if ((extra & 0x1) && (ebx & (1 << 5)))
   features |= 0x100;
 }

 return features;
}

# 586 "../../../src/sna/kgem.c"
inline static unsigned long __fls(unsigned long word)
{

 asm("bsr %1,%0"
     : "=r" (word)
     : "rm" (word));
 return word;
# 601 "../../../src/sna/kgem.c"
}

# 710 "../../../src/sna/kgem.c"
static unsigned
cpu_cache_size__cpuid4(void)
{
 /* Deterministic Cache Parmaeters (Function 04h)":
	 *    When EAX is initialized to a value of 4, the CPUID instruction
	 *    returns deterministic cache information in the EAX, EBX, ECX
	 *    and EDX registers.  This function requires ECX be initialized
	 *    with an index which indicates which cache to return information
	 *    about. The OS is expected to call this function (CPUID.4) with
	 *    ECX = 0, 1, 2, until EAX[4:0] == 0, indicating no more caches.
	 *    The order in which the caches are returned is not specified
	 *    and may change at Intel's discretion.
	 *
	 * Calculating the Cache Size in bytes:
	 *          = (Ways +1) * (Partitions +1) * (Line Size +1) * (Sets +1)
	 */

  unsigned int eax, ebx, ecx, edx;
  unsigned int llc_size = 0;
  int cnt = 0;

  if (__get_cpuid_max(0x0, ((void *)0)) < 4)
   return 0;

  do {
   unsigned associativity, line_partitions, line_size, sets;

   __asm__ ("xchg{l}\t{%%}ebx, %k1\n\t" "cpuid\n\t" "xchg{l}\t{%%}ebx, %k1\n\t" : "=a" (eax), "=&r" (ebx), "=c" (ecx), "=d" (edx) : "0" (4), "2" (cnt++));

   if ((eax & 0x1f) == 0)
    break;

   associativity = ((ebx >> 22) & 0x3ff) + 1;
   line_partitions = ((ebx >> 12) & 0x3ff) + 1;
   line_size = (ebx & 0xfff) + 1;
   sets = ecx + 1;

   llc_size = associativity * line_partitions * line_size * sets;
  } while (1);

  return llc_size;
}
