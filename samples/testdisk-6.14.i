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

