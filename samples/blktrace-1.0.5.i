unsigned int __builtin_bswap32 (unsigned int);
unsigned long long __builtin_bswap64 (unsigned long long);

# 47 "/usr/include/i386-linux-gnu/bits/types.h"
typedef unsigned long long int __uint64_t;

# 44 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}

# 108 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline __uint64_t
__bswap_64 (__uint64_t __bsx)
{
  return __builtin_bswap64 (__bsx);
}

# 23 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned short __u16;

# 26 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned int __u32;

# 30 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned long long __u64;

# 96 "../blktrace_api.h"
struct blk_io_trace {
 __u32 magic; /* MAGIC << 8 | version */
 __u32 sequence; /* event number */
 __u64 time; /* in nanoseconds */
 __u64 sector; /* disk offset */
 __u32 bytes; /* transfer length */
 __u32 action; /* what happened */
 __u32 pid; /* who did it */
 __u32 device; /* device identifier (dev_t) */
 __u32 cpu; /* on what cpu did it happen */
 __u16 error; /* completion error */
 __u16 pdu_len; /* length of data after this trace */
};

# 62 "../blktrace.h"
extern int data_is_native;

# 101 "../blktrace.h"
static inline void trace_to_cpu(struct blk_io_trace *t)
{
 if (data_is_native)
  return;

 t->magic = __bswap_32(t->magic);
 t->sequence = __bswap_32(t->sequence);
 t->time = __bswap_64(t->time);
 t->sector = __bswap_64(t->sector);
 t->bytes = __bswap_32(t->bytes);
 t->action = __bswap_32(t->action);
 t->pid = __bswap_32(t->pid);
 t->device = __bswap_32(t->device);
 t->cpu = __bswap_32(t->cpu);
 t->error = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (t->error); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 t->pdu_len = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (t->pdu_len); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 2143 "blkparse.c"
static inline __u16 get_pdulen(struct blk_io_trace *bit)
{
 if (data_is_native)
  return bit->pdu_len;

 return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (bit->pdu_len); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

