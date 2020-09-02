# 139 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __time_t;

# 175 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __syscall_slong_t;

# 120 "/usr/include/time.h"
struct timespec
  {
    __time_t tv_sec; /* Seconds.  */
    __syscall_slong_t tv_nsec; /* Nanoseconds.  */
  };

# 63 "/usr/include/sched.h"
extern int sched_yield (void);

# 334 "/usr/include/time.h"
extern int nanosleep (const struct timespec *__requested_time,
        struct timespec *__remaining);

# 35 "/usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp"
inline int atomic_exchange_and_add( int * pw, int dv )
{
    // int r = *pw;
    // *pw += dv;
    // return r;

    int r;

    __asm__ __volatile__
    (
        "lock\n\t"
        "xadd %1, %0":
        "=m"( *pw ), "=r"( r ): // outputs (%0, %1)
        "m"( *pw ), "1"( dv ): // inputs (%2, %3 == %1)
        "memory", "cc" // clobbers
    );

    return r;
}

# 55 "/usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp"
inline void atomic_increment( int * pw )
{
    //atomic_exchange_and_add( pw, 1 );

    __asm__
    (
        "lock\n\t"
        "incl %0":
        "=m"( *pw ): // output (%0)
        "m"( *pw ): // input (%1)
        "cc" // clobbers
    );
}

# 69 "/usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp"
inline int atomic_conditional_increment( int * pw )
{
    // int rv = *pw;
    // if( rv != 0 ) ++*pw;
    // return rv;

    int rv, tmp;

    __asm__
    (
        "movl %0, %%eax\n\t"
        "0:\n\t"
        "test %%eax, %%eax\n\t"
        "je 1f\n\t"
        "movl %%eax, %2\n\t"
        "incl %2\n\t"
        "lock\n\t"
        "cmpxchgl %2, %0\n\t"
        "jne 0b\n\t"
        "1:":
        "=m"( *pw ), "=&a"( rv ), "=&r"( tmp ): // outputs (%0, %1, %2)
        "m"( *pw ): // input (%3)
        "cc" // clobbers
    );

    return rv;
}

# 96 "/usr/include/boost/smart_ptr/detail/yield_k.hpp"
inline void yield( unsigned k )
{
    if( k < 4 )
    {
    }

    else if( k < 16 )
    {
        __asm__ __volatile__( "rep; nop" : : : "memory" );
    }

    else if( k < 32 || k & 1 )
    {
        sched_yield();
    }
    else
    {
        // g++ -Wextra warns on {} or {0}
        struct timespec rqtp = { 0, 0 };

        // POSIX says that timespec has tv_sec and tv_nsec
        // But it doesn't guarantee order or placement

        rqtp.tv_sec = 0;
        rqtp.tv_nsec = 1000;

        nanosleep( &rqtp, 0 );
    }
}

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 30 "/usr/include/atomic_ops/sysdeps/test_and_set_t_is_char.h"
typedef enum {AO_BYTE_TS_clear = 0, AO_BYTE_TS_set = 0xff} AO_BYTE_TS_val;

# 52 "/usr/include/atomic_ops/sysdeps/gcc/x86.h"
static __inline size_t
  AO_fetch_and_add_full (volatile size_t *p, size_t incr)
  {
    size_t result;

    __asm__ __volatile__ ("lock; xadd %0, %1" :
                        "=r" (result), "=m" (*p) : "0" (incr), "m" (*p)
                        : "memory");
    return result;
  }

# 65 "/usr/include/atomic_ops/sysdeps/gcc/x86.h"
static __inline unsigned char
AO_char_fetch_and_add_full (volatile unsigned char *p, unsigned char incr)
{
  unsigned char result;

  __asm__ __volatile__ ("lock; xaddb %0, %1" :
                        "=q" (result), "=m" (*p) : "0" (incr), "m" (*p)
                        : "memory");
  return result;
}

# 77 "/usr/include/atomic_ops/sysdeps/gcc/x86.h"
static __inline unsigned short
AO_short_fetch_and_add_full (volatile unsigned short *p, unsigned short incr)
{
  unsigned short result;

  __asm__ __volatile__ ("lock; xaddw %0, %1" :
                        "=r" (result), "=m" (*p) : "0" (incr), "m" (*p)
                        : "memory");
  return result;
}

# 91 "/usr/include/atomic_ops/sysdeps/gcc/x86.h"
static __inline void
  AO_and_full (volatile size_t *p, size_t value)
  {
    __asm__ __volatile__ ("lock; and %1, %0" :
                        "=m" (*p) : "r" (value), "m" (*p)
                        : "memory");
  }

# 100 "/usr/include/atomic_ops/sysdeps/gcc/x86.h"
static __inline void
  AO_or_full (volatile size_t *p, size_t value)
  {
    __asm__ __volatile__ ("lock; or %1, %0" :
                        "=m" (*p) : "r" (value), "m" (*p)
                        : "memory");
  }

# 109 "/usr/include/atomic_ops/sysdeps/gcc/x86.h"
static __inline void
  AO_xor_full (volatile size_t *p, size_t value)
  {
    __asm__ __volatile__ ("lock; xor %1, %0" :
                        "=m" (*p) : "r" (value), "m" (*p)
                        : "memory");
  }

# 123 "/usr/include/atomic_ops/sysdeps/gcc/x86.h"
static __inline AO_BYTE_TS_val
AO_test_and_set_full(volatile unsigned char *addr)
{
  unsigned char oldval;
  /* Note: the "xchg" instruction does not need a "lock" prefix */
  __asm__ __volatile__ ("xchgb %0, %1"
                        : "=q" (oldval), "=m" (*addr)
                        : "0" ((unsigned char)0xff), "m" (*addr)
                        : "memory");
  return (AO_BYTE_TS_val)oldval;
}

# 138 "/usr/include/atomic_ops/sysdeps/gcc/x86.h"
static __inline int
  AO_compare_and_swap_full(volatile size_t *addr, size_t old, size_t new_val)
  {







      char result;
      __asm__ __volatile__ ("lock; cmpxchg %3, %0; setz %1"
                        : "=m" (*addr), "=a" (result)
                        : "m" (*addr), "r" (new_val), "a" (old)
                        : "memory");
      return (int)result;

  }

# 159 "/usr/include/atomic_ops/sysdeps/gcc/x86.h"
static __inline size_t
AO_fetch_compare_and_swap_full(volatile size_t *addr, size_t old_val,
                               size_t new_val)
{




    size_t fetched_val;
    __asm__ __volatile__ ("lock; cmpxchg %3, %4"
                        : "=a" (fetched_val), "=m" (*addr)
                        : "a" (old_val), "r" (new_val), "m" (*addr)
                        : "memory");
    return fetched_val;

}

# 38 "/usr/include/atomic_ops/sysdeps/standard_ao_double_t.h"
typedef unsigned long long double_ptr_storage;

# 42 "/usr/include/atomic_ops/sysdeps/standard_ao_double_t.h"
typedef union {
    struct { size_t AO_v1; size_t AO_v2; } AO_parts;
        /* Note that AO_v1 corresponds to the low or the high part of   */
        /* AO_whole depending on the machine endianness.                */
    double_ptr_storage AO_whole;
        /* AO_whole is now (starting from v7.3alpha3) the 2nd element   */
        /* of this union to make AO_DOUBLE_T_INITIALIZER portable       */
        /* (because __m128 definition could vary from a primitive type  */
        /* to a structure or array/vector).                             */
} AO_double_t;

# 188 "/usr/include/atomic_ops/sysdeps/gcc/x86.h"
static __inline int
  AO_compare_double_and_swap_double_full(volatile AO_double_t *addr,
                                         size_t old_val1, size_t old_val2,
                                         size_t new_val1, size_t new_val2)
  {
    char result;

      size_t saved_ebx;

      /* If PIC is turned on, we cannot use ebx as it is reserved for the */
      /* GOT pointer.  We should save and restore ebx.  The proposed      */
      /* solution is not so efficient as the older alternatives using     */
      /* push ebx or edi as new_val1 (w/o clobbering edi and temporary    */
      /* local variable usage) but it is more portable (it works even if  */
      /* ebx is not used as GOT pointer, and it works for the buggy GCC   */
      /* releases that incorrectly evaluate memory operands offset in the */
      /* inline assembly after push).                                     */

        __asm__ __volatile__("mov %%ebx, %2\n\t" /* save ebx */
                             "lea %0, %%edi\n\t" /* in case addr is in ebx */
                             "mov %7, %%ebx\n\t" /* load new_val1 */
                             "lock; cmpxchg8b (%%edi)\n\t"
                             "mov %2, %%ebx\n\t" /* restore ebx */
                             "setz %1"
                        : "=m" (*addr), "=a" (result), "=m" (saved_ebx)
                        : "m" (*addr), "d" (old_val2), "a" (old_val1),
                          "c" (new_val2), "m" (new_val1)
                        : "%edi", "memory");
# 244 "/usr/include/atomic_ops/sysdeps/gcc/x86.h" 3 4
    return (int) result;
  }

