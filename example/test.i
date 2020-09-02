typedef unsigned long long AO_double_t;
typedef unsigned int AO_t;

/* Returns nonzero if the comparison succeeded. */
/* Really requires at least a Pentium.          */
int
AO_compare_double_and_swap_double_full(volatile AO_double_t *addr,
                                       AO_t old_val1, AO_t old_val2,
                                       AO_t new_val1, AO_t new_val2)
{
  char result;
  /* If PIC is turned on, we can't use %ebx as it is reserved for the
     GOT pointer.  We can save and restore %ebx because GCC won't be
     using it for anything else (such as any of the m operands) */
  /* We use %edi (for new_val1) instead of a memory operand and swap    */
  /* instruction instead of push/pop because some GCC releases have     */
  /* a bug in processing memory operands (if address base is %esp) in   */
  /* the inline assembly after push.                                    */
  __asm__ __volatile__("xchg %%ebx,%6;" /* swap GOT ptr and new_val1 */
                       "lock; cmpxchg8b %0; setz %1;"
                       "xchg %%ebx,%6;" /* restore ebx and edi */
                       : "=m"(*addr), "=a"(result)
                       : "m"(*addr), "d" (old_val2), "a" (old_val1),
                         "c" (new_val2), "D" (new_val1) : "memory");
  return (int) result;
}
