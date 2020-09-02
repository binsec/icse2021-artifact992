# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 63 "util/ring.h"
typedef struct ring
{
    size_t buffer_size;
    size_t write_idx;
    size_t read_idx;
    size_t big_mask;
    size_t small_mask;
    char *buffer;
} ring_t;

# 61 "util/ring.c"
size_t ring_read_bytes_avail(ring_t *rbuf){
 asm volatile("lfence":::"memory");
 return ( (rbuf->write_idx - rbuf->read_idx) & rbuf->big_mask );
}

# 98 "util/ring.c"
size_t ring_advance_write_idx(ring_t *rbuf, size_t sz){
 asm volatile("sfence":::"memory");
 return rbuf->write_idx = (rbuf->write_idx + sz) & rbuf->big_mask;
}

# 127 "util/ring.c"
size_t ring_advance_read_idx(ring_t *rbuf, size_t sz){
 asm volatile("sfence":::"memory");
 return rbuf->read_idx = (rbuf->read_idx + sz) & rbuf->big_mask;
}

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 13 "util/uint.h"
typedef uint16_t u16;

# 21 "util/checksum.c"
inline u16 checksum_ip(const void *iph, unsigned ihl)
{
 unsigned sum;

 asm( "  movl (%1), %0\n"
  "  subl $4, %2\n"
  "  jbe 2f\n"
  "  addl 4(%1), %0\n"
  "  adcl 8(%1), %0\n"
  "  adcl 12(%1), %0\n"
  "1: adcl 16(%1), %0\n"
  "  lea 4(%1), %1\n"
  "  decl %2\n"
  "  jne  1b\n"
  "  adcl $0, %0\n"
  "  movl %0, %2\n"
  "  shrl $16, %0\n"
  "  addw %w2, %w0\n"
  "  adcl $0, %0\n"
  "  notl %0\n"
  "2:"
 /* Since the input registers which are loaded with iph and ihl
	   are modified, we must also specify them as outputs, or gcc
	   will assume they contain their original values. */
 : "=r" (sum), "=r" (iph), "=r" (ihl)
 : "1" (iph), "2" (ihl)
 : "memory");
 return (u16) sum;
}

