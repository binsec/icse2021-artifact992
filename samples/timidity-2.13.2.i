unsigned int __builtin_object_size (const void *, int);

# 196 "/usr/include/i386-linux-gnu/sys/types.h"
typedef int int32_t;

# 89 "../timidity/sysdep.h"
typedef int32_t int32;

# 66 "../timidity/optcode.h"
static inline int32 imuldiv8(int32 a, int32 b)
{
    int32 result;
    __asm__("movl %1, %%eax\n\t"
     "movl %2, %%edx\n\t"
     "imull %%edx\n\t"
     "shr $8, %%eax\n\t"
     "shl $24, %%edx\n\t"
     "or %%edx, %%eax\n\t"
     "movl %%eax, %0\n\t"
     : "=g"(result)
     : "g"(a), "g"(b)
     : "eax", "edx");
    return result;
}

# 82 "../timidity/optcode.h"
static inline int32 imuldiv16(int32 a, int32 b)
{
    int32 result;
    __asm__("movl %1, %%eax\n\t"
     "movl %2, %%edx\n\t"
     "imull %%edx\n\t"
     "shr $16, %%eax\n\t"
     "shl $16, %%edx\n\t"
     "or %%edx, %%eax\n\t"
     "movl %%eax, %0\n\t"
     : "=g"(result)
     : "g"(a), "g"(b)
     : "eax", "edx");
    return result;
}

# 98 "../timidity/optcode.h"
static inline int32 imuldiv24(int32 a, int32 b)
{
    int32 result;
    __asm__("movl %1, %%eax\n\t"
     "movl %2, %%edx\n\t"
     "imull %%edx\n\t"
     "shr $24, %%eax\n\t"
     "shl $8, %%edx\n\t"
     "or %%edx, %%eax\n\t"
     "movl %%eax, %0\n\t"
     : "=g"(result)
     : "g"(a), "g"(b)
     : "eax", "edx");
    return result;
}

# 114 "../timidity/optcode.h"
static inline int32 imuldiv28(int32 a, int32 b)
{
    int32 result;
    __asm__("movl %1, %%eax\n\t"
     "movl %2, %%edx\n\t"
     "imull %%edx\n\t"
     "shr $28, %%eax\n\t"
     "shl $4, %%edx\n\t"
     "or %%edx, %%eax\n\t"
     "movl %%eax, %0\n\t"
     : "=g"(result)
     : "g"(a), "g"(b)
     : "eax", "edx");
    return result;
}

# 139 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __time_t;

# 141 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __suseconds_t;

# 846 "/usr/include/stdio.h"
extern void perror (const char *__s);

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

# 55 "gtk_p.c"
int fpip_in;

# 165 "gtk_p.c"
int
gtk_pipe_read_ready(void)
{
    fd_set fds;
    int cnt;
    struct timeval timeout;

    do { int __d0, __d1; __asm__ __volatile__ ("cld; rep; " "stosl" : "=c" (__d0), "=D" (__d1) : "a" (0), "0" (sizeof (fd_set) / sizeof (__fd_mask)), "1" (&((&fds)->__fds_bits)[0]) : "memory"); } while (0);
    ((void) (((&fds)->__fds_bits)[__extension__ ({ long int __d = (fpip_in); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] |= ((__fd_mask) 1 << ((fpip_in) % (8 * (int) sizeof (__fd_mask))))));
    timeout.tv_sec = timeout.tv_usec = 0;
    if((cnt = select(fpip_in + 1, &fds, ((void *)0), ((void *)0), &timeout)) < 0)
    {
 perror("select");
 return -1;
    }

    return cnt > 0 && ((((&fds)->__fds_bits)[__extension__ ({ long int __d = (fpip_in); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] & ((__fd_mask) 1 << ((fpip_in) % (8 * (int) sizeof (__fd_mask))))) != 0) != 0;
}

# 609 "xaw_c.c"
static int pipe_in_fd;

# 636 "xaw_c.c"
static int a_pipe_ready(void) {
  fd_set fds;
  static struct timeval tv;
  int cnt;

  do { int __d0, __d1; __asm__ __volatile__ ("cld; rep; " "stosl" : "=c" (__d0), "=D" (__d1) : "a" (0), "0" (sizeof (fd_set) / sizeof (__fd_mask)), "1" (&((&fds)->__fds_bits)[0]) : "memory"); } while (0);
  ((void) (((&fds)->__fds_bits)[__extension__ ({ long int __d = (pipe_in_fd); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] |= ((__fd_mask) 1 << ((pipe_in_fd) % (8 * (int) sizeof (__fd_mask))))));
  tv.tv_sec=0;
  tv.tv_usec=0;
  if((cnt=select(pipe_in_fd+1,&fds,((void *)0),((void *)0),&tv))<0)
    return -1;
  return cnt > 0 && ((((&fds)->__fds_bits)[__extension__ ({ long int __d = (pipe_in_fd); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] & ((__fd_mask) 1 << ((pipe_in_fd) % (8 * (int) sizeof (__fd_mask))))) != 0) != 0;
}

# 494 "xskin_c.c"
static int xskin_pipe_ready(void) {

  fd_set fds;
  static struct timeval tv;
  int cnt;

  do { int __d0, __d1; __asm__ __volatile__ ("cld; rep; " "stosl" : "=c" (__d0), "=D" (__d1) : "a" (0), "0" (sizeof (fd_set) / sizeof (__fd_mask)), "1" (&((&fds)->__fds_bits)[0]) : "memory"); } while (0);
  ((void) (((&fds)->__fds_bits)[__extension__ ({ long int __d = (pipe_in_fd); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] |= ((__fd_mask) 1 << ((pipe_in_fd) % (8 * (int) sizeof (__fd_mask))))));
  tv.tv_sec=0;
  tv.tv_usec=0;
  if((cnt=select(pipe_in_fd+1,&fds,((void *)0),((void *)0),&tv))<0)
    return -1;
  return cnt > 0 && ((((&fds)->__fds_bits)[__extension__ ({ long int __d = (pipe_in_fd); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] & ((__fd_mask) 1 << ((pipe_in_fd) % (8 * (int) sizeof (__fd_mask))))) != 0) != 0;
}

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 55 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long long int __quad_t;

# 131 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __off_t;

# 132 "/usr/include/i386-linux-gnu/bits/types.h"
typedef __quad_t __off64_t;

# 48 "/usr/include/stdio.h"
typedef struct _IO_FILE FILE;

# 154 "/usr/include/libio.h"
typedef void _IO_lock_t;

# 160 "/usr/include/libio.h"
struct _IO_marker {
  struct _IO_marker *_next;
  struct _IO_FILE *_sbuf;
  /* If _pos >= 0
 it points to _buf->Gbase()+_pos. FIXME comment */
  /* if _pos < 0, it points to _buf->eBptr()+_pos. FIXME comment */
  int _pos;
# 177 "/usr/include/libio.h" 3 4
};

# 245 "/usr/include/libio.h"
struct _IO_FILE {
  int _flags; /* High-order word is _IO_MAGIC; rest is flags. */


  /* The following pointers correspond to the C++ streambuf protocol. */
  /* Note:  Tk uses the _IO_read_ptr and _IO_read_end fields directly. */
  char* _IO_read_ptr; /* Current read pointer */
  char* _IO_read_end; /* End of get area. */
  char* _IO_read_base; /* Start of putback+get area. */
  char* _IO_write_base; /* Start of put area. */
  char* _IO_write_ptr; /* Current put pointer. */
  char* _IO_write_end; /* End of put area. */
  char* _IO_buf_base; /* Start of reserve area. */
  char* _IO_buf_end; /* End of reserve area. */
  /* The following fields are used to support backing up and undo. */
  char *_IO_save_base; /* Pointer to start of non-current get area. */
  char *_IO_backup_base; /* Pointer to first valid character of backup area */
  char *_IO_save_end; /* Pointer to end of non-current get area. */

  struct _IO_marker *_markers;

  struct _IO_FILE *_chain;

  int _fileno;



  int _flags2;

  __off_t _old_offset; /* This used to be _offset but it's too small.  */


  /* 1+column number of pbase(); 0 is unknown. */
  unsigned short _cur_column;
  signed char _vtable_offset;
  char _shortbuf[1];

  /*  char* _save_gptr;  char* _save_egptr; */

  _IO_lock_t *_lock;
# 293 "/usr/include/libio.h" 3 4
  __off64_t _offset;
# 302 "/usr/include/libio.h" 3 4
  void *__pad1;
  void *__pad2;
  void *__pad3;
  void *__pad4;
  size_t __pad5;

  int _mode;
  /* Make sure we don't get into trouble again.  */
  char _unused2[15 * sizeof (int) - 4 * sizeof (void *) - sizeof (size_t)];

};

# 168 "/usr/include/stdio.h"
extern struct _IO_FILE *stdin;

# 759 "/usr/include/stdio.h"
extern void rewind (FILE *__stream);

# 241 "/usr/include/i386-linux-gnu/bits/stdio2.h"
extern char *__fgets_chk (char *__restrict __s, size_t __size, int __n,
     FILE *__restrict __stream);

# 243 "/usr/include/i386-linux-gnu/bits/stdio2.h"
extern char *__fgets_alias (char *__restrict __s, int __n, FILE *__restrict __stream) __asm__ ("" "fgets");

# 246 "/usr/include/i386-linux-gnu/bits/stdio2.h"
extern char *__fgets_chk_warn (char *__restrict __s, size_t __size, int __n, FILE *__restrict __stream) __asm__ ("" "__fgets_chk");

# 252 "/usr/include/i386-linux-gnu/bits/stdio2.h"
extern __inline char *
fgets (char *__restrict __s, int __n, FILE *__restrict __stream)
{
  if (__builtin_object_size (__s, 2 > 1) != (size_t) -1)
    {
      if (!__builtin_constant_p (__n) || __n <= 0)
 return __fgets_chk (__s, __builtin_object_size (__s, 2 > 1), __n, __stream);

      if ((size_t) __n > __builtin_object_size (__s, 2 > 1))
 return __fgets_chk_warn (__s, __builtin_object_size (__s, 2 > 1), __n, __stream);
    }
  return __fgets_alias (__s, __n, __stream);
}

# 816 "vt100_c.c"
static char *vt100_getline(void)
{
    static char cmd[80];
    fd_set fds;
    int cnt;
    struct timeval timeout;

    do { int __d0, __d1; __asm__ __volatile__ ("cld; rep; " "stosl" : "=c" (__d0), "=D" (__d1) : "a" (0), "0" (sizeof (fd_set) / sizeof (__fd_mask)), "1" (&((&fds)->__fds_bits)[0]) : "memory"); } while (0);
    ((void) (((&fds)->__fds_bits)[__extension__ ({ long int __d = (0); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] |= ((__fd_mask) 1 << ((0) % (8 * (int) sizeof (__fd_mask))))));
    timeout.tv_sec = timeout.tv_usec = 0;
    if((cnt = select(1, &fds, ((void *)0), ((void *)0), &timeout)) < 0)
    {
 perror("select");
 return ((void *)0);
    }

    if(cnt > 0 && ((((&fds)->__fds_bits)[__extension__ ({ long int __d = (0); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] & ((__fd_mask) 1 << ((0) % (8 * (int) sizeof (__fd_mask))))) != 0) != 0)
    {
 if(fgets(cmd, sizeof(cmd), stdin) == ((void *)0))
 {
     rewind(stdin);
     return ((void *)0);
 }
 return cmd;
    }

    return ((void *)0);
}

