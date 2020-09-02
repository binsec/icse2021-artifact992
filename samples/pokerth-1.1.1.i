# 139 "/usr/include/bits/types.h"
typedef long int __time_t;

# 175 "/usr/include/bits/types.h"
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

# 109 "/usr/include/bits/fenv.h"
extern int __feraiseexcept_renamed (int) /* throw () */ __asm__ ("" "feraiseexcept");

# 110 "/usr/include/bits/fenv.h"
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

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 53 "/usr/include/boost/asio/detail/gcc_x86_fenced_block.hpp"
static int barrier()
  {
    int r = 0, m = 1;
    __asm__ __volatile__ (
        "xchgl %0, %1" :
        "=r"(r), "=m"(m) :
        "0"(1), "m"(m) :
        "memory", "cc");
    return r;
  }

# 309 "/usr/include/boost/asio/detail/socket_types.hpp"
typedef uint16_t u_short_type;

# 3344 "/usr/include/boost/asio/detail/impl/socket_ops.ipp"
u_short_type network_to_host_short(u_short_type value)
{






  return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (value); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

}

# 3356 "/usr/include/boost/asio/detail/impl/socket_ops.ipp"
u_short_type host_to_network_short(u_short_type value)
{







  return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (value); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

}

