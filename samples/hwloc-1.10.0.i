# 15 "/vagrant/allpkg/hwloc-1.10.0/include/private/cpuid-x86.h"
static __inline__ int hwloc_have_x86_cpuid(void)
{
  int ret;
  unsigned tmp, tmp2;
  __asm__(
      "mov $0,%0\n\t" /* Not supported a priori */

      "pushfl   \n\t" /* Save flags */

      "pushfl   \n\t"
      "pop %1   \n\t" /* Get flags */
# 37 "/vagrant/allpkg/hwloc-1.10.0/include/private/cpuid-x86.h"
      "xor $0x00200000,%1\n\t" /* Try to toggle ID */ "mov %1,%2\n\t" /* Save expected value */ "push %1  \n\t" "popfl    \n\t" /* Try to toggle */ "pushfl   \n\t" "pop %1   \n\t" "cmp %1,%2\n\t" /* Compare with expected value */ "jnz Lhwloc1\n\t" /* Unexpected, failure */ /* Try to set/clear */
      "xor $0x00200000,%1\n\t" /* Try to toggle ID */ "mov %1,%2\n\t" /* Save expected value */ "push %1  \n\t" "popfl    \n\t" /* Try to toggle */ "pushfl   \n\t" "pop %1   \n\t" "cmp %1,%2\n\t" /* Compare with expected value */ "jnz Lhwloc1\n\t" /* Unexpected, failure */ /* Try to clear/set */

      "mov $1,%0\n\t" /* Passed the test! */

      "Lhwloc1: \n\t"
      "popfl    \n\t" /* Restore flags */

      : "=r" (ret), "=&r" (tmp), "=&r" (tmp2));
  return ret;
}

# 53 "/vagrant/allpkg/hwloc-1.10.0/include/private/cpuid-x86.h"
static __inline__ void hwloc_x86_cpuid(unsigned *eax, unsigned *ebx, unsigned *ecx, unsigned *edx)
{
# 63 "/vagrant/allpkg/hwloc-1.10.0/include/private/cpuid-x86.h"
  /* Note: gcc might want to use bx or the stack for %1 addressing, so we can't
   * use them :/ */
# 75 "/vagrant/allpkg/hwloc-1.10.0/include/private/cpuid-x86.h"
  unsigned long sav_ebx;
  __asm__(
  "mov %%ebx,%2\n\t"
  "cpuid\n\t"
  "xchg %2,%%ebx\n\t"
  "movl %k2,%1\n\t"
  : "+a" (*eax), "=m" (*ebx), "=&r"(sav_ebx),
    "+c" (*ecx), "=&d" (*edx));




}

