# 97 "../../src/Glide64/DepthBufferRender.cpp"
__inline int idiv16(int x, int y) // (x << 16) / y
{
    //x = (((long long)x) << 16) / ((long long)y);
 /*   
  eax = x;
  ebx = y;
  edx = x;
  (x << 16) | ()
   */
# 117 "../../src/Glide64/DepthBufferRender.cpp"
    int reminder;
    asm ("idivl %[divisor]"
          : "=a" (x), "=d" (reminder)
          : [divisor] "g" (y), "d" (x >> 16), "a" (x << 16));



    return x;
}

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

# 556 "/usr/include/i386-linux-gnu/bits/mathinline.h"
extern __inline void
 __sincos (double __x, double *__sinx, double *__cosx) /* throw () */
{
  register long double __cosr; register long double __sinr; register unsigned int __swtmp; __asm __volatile__ ("fsincos\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jz	1f\n\t" "fldpi\n\t" "fadd	%%st(0)\n\t" "fxch	%%st(1)\n\t" "2: fprem1\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jnz	2b\n\t" "fstp	%%st(1)\n\t" "fsincos\n\t" "1:" : "=t" (__cosr), "=u" (__sinr), "=a" (__swtmp) : "0" (__x)); *__sinx = __sinr; *__cosx = __cosr;
}

# 562 "/usr/include/i386-linux-gnu/bits/mathinline.h"
extern __inline void
 __sincosf (float __x, float *__sinx, float *__cosx) /* throw () */
{
  register long double __cosr; register long double __sinr; register unsigned int __swtmp; __asm __volatile__ ("fsincos\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jz	1f\n\t" "fldpi\n\t" "fadd	%%st(0)\n\t" "fxch	%%st(1)\n\t" "2: fprem1\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jnz	2b\n\t" "fstp	%%st(1)\n\t" "fsincos\n\t" "1:" : "=t" (__cosr), "=u" (__sinr), "=a" (__swtmp) : "0" (__x)); *__sinx = __sinr; *__cosx = __cosr;
}

# 568 "/usr/include/i386-linux-gnu/bits/mathinline.h"
extern __inline void
 __sincosl (long double __x, long double *__sinx, long double *__cosx) /* throw () */
{
  register long double __cosr; register long double __sinr; register unsigned int __swtmp; __asm __volatile__ ("fsincos\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jz	1f\n\t" "fldpi\n\t" "fadd	%%st(0)\n\t" "fxch	%%st(1)\n\t" "2: fprem1\n\t" "fnstsw	%w2\n\t" "testl	$0x400, %2\n\t" "jnz	2b\n\t" "fstp	%%st(1)\n\t" "fsincos\n\t" "1:" : "=t" (__cosr), "=u" (__sinr), "=a" (__swtmp) : "0" (__x)); *__sinx = __sinr; *__cosx = __cosr;
}

