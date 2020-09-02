unsigned int __builtin_object_size (const void *, int);

# 40 "/usr/include/ext2fs/ext2_types.h"
typedef unsigned short __u16;

# 76 "/usr/include/ext2fs/ext2_types.h"
typedef unsigned int __u32;

# 304 "/usr/include/ext2fs/bitops.h"
struct __dummy_h { unsigned long a[100]; };

# 308 "/usr/include/ext2fs/bitops.h"
extern __inline__ int ext2fs_set_bit(unsigned int nr, void * addr)
{
 int oldbit;

 addr = (void *) (((unsigned char *) addr) + (nr >> 3));
 __asm__ __volatile__("btsl %2,%1\n\tsbbl %0,%0"
  :"=r" (oldbit),"+m" ((*(struct __dummy_h *) addr))
  :"r" (nr & 7));
 return oldbit;
}

# 319 "/usr/include/ext2fs/bitops.h"
extern __inline__ int ext2fs_clear_bit(unsigned int nr, void * addr)
{
 int oldbit;

 addr = (void *) (((unsigned char *) addr) + (nr >> 3));
 __asm__ __volatile__("btrl %2,%1\n\tsbbl %0,%0"
  :"=r" (oldbit),"+m" ((*(struct __dummy_h *) addr))
  :"r" (nr & 7));
 return oldbit;
}

# 330 "/usr/include/ext2fs/bitops.h"
extern __inline__ int ext2fs_test_bit(unsigned int nr, const void * addr)
{
 int oldbit;

 addr = (const void *) (((const unsigned char *) addr) + (nr >> 3));
 __asm__ __volatile__("btl %2,%1\n\tsbbl %0,%0"
  :"=r" (oldbit)
  :"m" ((*(const struct __dummy_h *) addr)),"r" (nr & 7));
 return oldbit;
}

# 341 "/usr/include/ext2fs/bitops.h"
extern __inline__ __u32 ext2fs_swab32(__u32 val)
{



 __asm__("xchgb %b0,%h0\n\t" /* swap lower bytes	*/
  "rorl $16,%0\n\t" /* swap words		*/
  "xchgb %b0,%h0" /* swap higher bytes	*/
  :"=q" (val)
  : "0" (val));

 return val;
}

# 355 "/usr/include/ext2fs/bitops.h"
extern __inline__ __u16 ext2fs_swab16(__u16 val)
{
 __asm__("xchgb %b0,%h0" /* swap bytes		*/
  : "=q" (val)
  : "0" (val));
  return val;
}

# 139 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __time_t;

# 141 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __suseconds_t;

# 172 "/usr/include/i386-linux-gnu/bits/types.h"
typedef int __ssize_t;

# 109 "/usr/include/i386-linux-gnu/sys/types.h"
typedef __ssize_t ssize_t;

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 30 "/usr/include/i386-linux-gnu/bits/time.h"
struct timeval
  {
    __time_t tv_sec; /* Seconds.  */
    __suseconds_t tv_usec; /* Microseconds.  */
  };

# 54 "/usr/include/i386-linux-gnu/sys/select.h"
typedef long int __fd_mask;

# 64 "/usr/include/i386-linux-gnu/sys/select.h"
typedef struct
  {
    /* XPG4.2 requires this member name.  Otherwise avoid the name
       from the global namespace.  */




    __fd_mask __fds_bits[1024 / (8 * (int) sizeof (__fd_mask))];


  } fd_set;

# 24 "/usr/include/i386-linux-gnu/bits/select2.h"
extern long int __fdelt_chk (long int __d);

# 25 "/usr/include/i386-linux-gnu/bits/select2.h"
extern long int __fdelt_warn (long int __d);

# 23 "/usr/include/i386-linux-gnu/bits/unistd.h"
extern ssize_t __read_chk (int __fd, void *__buf, size_t __nbytes,
      size_t __buflen);

# 25 "/usr/include/i386-linux-gnu/bits/unistd.h"
extern ssize_t __read_alias (int __fd, void *__buf, size_t __nbytes) __asm__ ("" "read");

# 27 "/usr/include/i386-linux-gnu/bits/unistd.h"
extern ssize_t __read_chk_warn (int __fd, void *__buf, size_t __nbytes, size_t __buflen) __asm__ ("" "__read_chk");

# 33 "/usr/include/i386-linux-gnu/bits/unistd.h"
extern __inline ssize_t
read (int __fd, void *__buf, size_t __nbytes)
{
  if (__builtin_object_size (__buf, 0) != (size_t) -1)
    {
      if (!__builtin_constant_p (__nbytes))
 return __read_chk (__fd, __buf, __nbytes, __builtin_object_size (__buf, 0));

      if (__nbytes > __builtin_object_size (__buf, 0))
 return __read_chk_warn (__fd, __buf, __nbytes, __builtin_object_size (__buf, 0));
    }
  return __read_alias (__fd, __buf, __nbytes);
}

# 137 "../dump/dump.h"
void msg (const char *fmt, ...);

# 100 "dumprmt.c"
static const char *rmtpeer = 0;

# 114 "dumprmt.c"
static int errfd = -1;

# 117 "dumprmt.c"
extern int abortifconnerr;

# 134 "dumprmt.c"
static void
rmtconnaborted(int signo )
{
 msg("Lost connection to remote host.\n");
 if (errfd != -1) {
  fd_set r;
  struct timeval t;

  do { int __d0, __d1; __asm__ __volatile__ ("cld; rep; " "stosl" : "=c" (__d0), "=D" (__d1) : "a" (0), "0" (sizeof (fd_set) / sizeof (__fd_mask)), "1" (&((&r)->__fds_bits)[0]) : "memory"); } while (0);
  ((void) (((&r)->__fds_bits)[__extension__ ({ long int __d = (errfd); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] |= ((__fd_mask) 1 << ((errfd) % (8 * (int) sizeof (__fd_mask))))));
  t.tv_sec = 0;
  t.tv_usec = 0;
  if (select(errfd + 1, &r, ((void *)0), ((void *)0), &t)) {
   int i;
   char buf[2048];

   if ((i = read(errfd, buf, sizeof(buf) - 1)) > 0) {
    buf[i] = '\0';
    msg("on %s: %s%s", rmtpeer, buf,
     buf[i - 1] == '\n' ? "" : "\n");
   }
  }
 }
 if (abortifconnerr)
  exit(3 /* abort dump; don't attempt checkpointing */);
}

