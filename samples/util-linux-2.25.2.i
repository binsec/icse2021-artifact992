extern int printf(const char *format, ...);
unsigned int __builtin_bswap32 (unsigned int);
unsigned long long __builtin_bswap64 (unsigned long long);

# 26 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned int __u32;

# 30 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned long long __u64;

# 7 "/usr/include/i386-linux-gnu/asm/swab.h"
static __inline__ __u32 __arch_swab32(__u32 val)
{
 __asm__("bswapl %0" : "=r" (val) : "0" (val));
 return val;
}

# 14 "/usr/include/i386-linux-gnu/asm/swab.h"
static __inline__ __u64 __arch_swab64(__u64 val)
{

 union {
  struct {
   __u32 a;
   __u32 b;
  } s;
  __u64 u;
 } v;
 v.u = val;
 __asm__("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
     : "=r" (v.s.a), "=r" (v.s.b)
     : "0" (v.s.a), "1" (v.s.b));
 return v.u;




}

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

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 22 "tests/helpers/test_byteswap.c"
uint16_t ary16[] = {
 0x0001, 0x0100,
 0x1234, 0x3412,
 0xff00, 0x00ff,
 0x4000, 0x0040,
 0xfeff, 0xfffe,
 0x0000, 0x0000
 };

# 31 "tests/helpers/test_byteswap.c"
uint32_t ary32[] = {
 0x00000001, 0x01000000,
 0x80000000, 0x00000080,
 0x12345678, 0x78563412,
 0xffff0000, 0x0000ffff,
 0x00ff0000, 0x0000ff00,
 0xff000000, 0x000000ff,
 0x00000000, 0x00000000
 };

# 41 "tests/helpers/test_byteswap.c"
uint64_t ary64[] = {
 0x0000000000000001, 0x0100000000000000,
 0x8000000000000000, 0x0000000000000080,
 0x1234567812345678, 0x7856341278563412,
 0xffffffff00000000, 0x00000000ffffffff,
 0x00ff000000000000, 0x000000000000ff00,
 0xff00000000000000, 0x00000000000000ff,
 0x0000000000000000, 0x0000000000000000
 };

# 51 "tests/helpers/test_byteswap.c"
int main(void)
{
 int i;
 int errors = 0;

 printf("Testing swab16\n");
 i=0;
 do {
  printf("swab16(0x%04""x"") = 0x%04""x""\n",
    ary16[i], (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (ary16[i]); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
  if ((__extension__ ({ unsigned short int __v, __x = (unsigned short int) (ary16[i]); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) != ary16[i+1]) {
   printf("Error!!!   %04""x"" != %04""x""\n",
          (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (ary16[i]); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })), ary16[i+1]);
   errors++;
  }
  if ((__extension__ ({ unsigned short int __v, __x = (unsigned short int) (ary16[i+1]); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) != ary16[i]) {
   printf("Error!!!   %04""x"" != %04""x""\n",
          (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (ary16[i+1]); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })), ary16[i]);
   errors++;
  }
  i += 2;
 } while (ary16[i] != 0);

 printf("Testing swab32\n");
 i = 0;
 do {
  printf("swab32(0x%08""x"") = 0x%08""x""\n",
    ary32[i], __bswap_32 (ary32[i]));
  if (__bswap_32 (ary32[i]) != ary32[i+1]) {
   printf("Error!!!   %04""x"" != %04""x""\n",
    __bswap_32 (ary32[i]), ary32[i+1]);
   errors++;
  }
  if (__bswap_32 (ary32[i+1]) != ary32[i]) {
   printf("Error!!!   %04""x"" != %04""x""\n",
          __bswap_32 (ary32[i+1]), ary32[i]);
   errors++;
  }
  i += 2;
 } while (ary32[i] != 0);

 printf("Testing swab64\n");
 i = 0;
 do {
  printf("swab64(0x%016""ll" "x"") = 0x%016""ll" "x""\n",
    ary64[i], __bswap_64 (ary64[i]));
  if (__bswap_64 (ary64[i]) != ary64[i+1]) {
   printf("Error!!!   %016""ll" "x"" != %016""ll" "x""\n",
    __bswap_64 (ary64[i]), ary64[i+1]);
   errors++;
  }
  if (__bswap_64 (ary64[i+1]) != ary64[i]) {
   printf("Error!!!   %016""ll" "x"" != %016""ll" "x""\n",
          __bswap_64 (ary64[i+1]), ary64[i]);
   errors++;
  }
  i += 2;
 } while (ary64[i] != 0);

 if (!errors)
  printf("No errors found in the byteswap implementation\n");

 return errors;
}

# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

# 50 "libfdisk/src/gpt.c"
struct gpt_guid {
 uint32_t time_low;
 uint16_t time_mid;
 uint16_t time_hi_and_version;
 uint8_t clock_seq_hi;
 uint8_t clock_seq_low;
 uint8_t node[6];
};

# 292 "libfdisk/src/gpt.c"
static void swap_efi_guid(struct gpt_guid *uid)
{
 uid->time_low = __bswap_32 (uid->time_low);
 uid->time_mid = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (uid->time_mid); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 uid->time_hi_and_version = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (uid->time_hi_and_version); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 23 "libblkid/src/superblocks/xfs.c"
struct xfs_super_block {
 uint32_t sb_magicnum; /* magic number == XFS_SB_MAGIC */
 uint32_t sb_blocksize; /* logical block size, bytes */
 uint64_t sb_dblocks; /* number of data blocks */
 uint64_t sb_rblocks; /* number of realtime blocks */
 uint64_t sb_rextents; /* number of realtime extents */
 unsigned char sb_uuid[16]; /* file system unique id */
 uint64_t sb_logstart; /* starting block of log if internal */
 uint64_t sb_rootino; /* root inode number */
 uint64_t sb_rbmino; /* bitmap inode for realtime extents */
 uint64_t sb_rsumino; /* summary inode for rt bitmap */
 uint32_t sb_rextsize; /* realtime extent size, blocks */
 uint32_t sb_agblocks; /* size of an allocation group */
 uint32_t sb_agcount; /* number of allocation groups */
 uint32_t sb_rbmblocks; /* number of rt bitmap blocks */
 uint32_t sb_logblocks; /* number of log blocks */

 uint16_t sb_versionnum; /* header version == XFS_SB_VERSION */
 uint16_t sb_sectsize; /* volume sector size, bytes */
 uint16_t sb_inodesize; /* inode size, bytes */
 uint16_t sb_inopblock; /* inodes per block */
 char sb_fname[12]; /* file system name */
 uint8_t sb_blocklog; /* log2 of sb_blocksize */
 uint8_t sb_sectlog; /* log2 of sb_sectsize */
 uint8_t sb_inodelog; /* log2 of sb_inodesize */
 uint8_t sb_inopblog; /* log2 of sb_inopblock */
 uint8_t sb_agblklog; /* log2 of sb_agblocks (rounded up) */
 uint8_t sb_rextslog; /* log2 of sb_rextents */
 uint8_t sb_inprogress; /* mkfs is in progress, don't mount */
 uint8_t sb_imax_pct; /* max % of fs for inode space */
     /* statistics */
 uint64_t sb_icount; /* allocated inodes */
 uint64_t sb_ifree; /* free inodes */
 uint64_t sb_fdblocks; /* free data blocks */
 uint64_t sb_frextents; /* free realtime extents */

 /* this is not all... but enough for libblkid */

};

# 87 "libblkid/src/superblocks/xfs.c"
static void sb_from_disk(struct xfs_super_block *from,
    struct xfs_super_block *to)
{

 to->sb_magicnum = ((uint32_t) __bswap_32 (from->sb_magicnum));
 to->sb_blocksize = ((uint32_t) __bswap_32 (from->sb_blocksize));
 to->sb_dblocks = ((uint64_t) __bswap_64 (from->sb_dblocks));
 to->sb_rblocks = ((uint64_t) __bswap_64 (from->sb_rblocks));
 to->sb_rextents = ((uint64_t) __bswap_64 (from->sb_rextents));
 to->sb_logstart = ((uint64_t) __bswap_64 (from->sb_logstart));
 to->sb_rootino = ((uint64_t) __bswap_64 (from->sb_rootino));
 to->sb_rbmino = ((uint64_t) __bswap_64 (from->sb_rbmino));
 to->sb_rsumino = ((uint64_t) __bswap_64 (from->sb_rsumino));
 to->sb_rextsize = ((uint32_t) __bswap_32 (from->sb_rextsize));
 to->sb_agblocks = ((uint32_t) __bswap_32 (from->sb_agblocks));
 to->sb_agcount = ((uint32_t) __bswap_32 (from->sb_agcount));
 to->sb_rbmblocks = ((uint32_t) __bswap_32 (from->sb_rbmblocks));
 to->sb_logblocks = ((uint32_t) __bswap_32 (from->sb_logblocks));
 to->sb_versionnum = ((uint16_t) (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (from->sb_versionnum); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
 to->sb_sectsize = ((uint16_t) (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (from->sb_sectsize); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
 to->sb_inodesize = ((uint16_t) (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (from->sb_inodesize); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
 to->sb_inopblock = ((uint16_t) (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (from->sb_inopblock); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
 to->sb_blocklog = from->sb_blocklog;
 to->sb_sectlog = from->sb_sectlog;
 to->sb_inodelog = from->sb_inodelog;
 to->sb_inopblog = from->sb_inopblog;
 to->sb_agblklog = from->sb_agblklog;
 to->sb_rextslog = from->sb_rextslog;
 to->sb_inprogress = from->sb_inprogress;
 to->sb_imax_pct = from->sb_imax_pct;
 to->sb_icount = ((uint64_t) __bswap_64 (from->sb_icount));
 to->sb_ifree = ((uint64_t) __bswap_64 (from->sb_ifree));
 to->sb_fdblocks = ((uint64_t) __bswap_64 (from->sb_fdblocks));
 to->sb_frextents = ((uint64_t) __bswap_64 (from->sb_frextents));
}

# 42 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline unsigned char
inb (unsigned short int __port)
{
  unsigned char _v;

  __asm__ __volatile__ ("inb %w1,%0":"=a" (_v):"Nd" (__port));
  return _v;
}

# 51 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline unsigned char
inb_p (unsigned short int __port)
{
  unsigned char _v;

  __asm__ __volatile__ ("inb %w1,%0\noutb %%al,$0x80":"=a" (_v):"Nd" (__port));
  return _v;
}

# 60 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline unsigned short int
inw (unsigned short int __port)
{
  unsigned short _v;

  __asm__ __volatile__ ("inw %w1,%0":"=a" (_v):"Nd" (__port));
  return _v;
}

# 69 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline unsigned short int
inw_p (unsigned short int __port)
{
  unsigned short int _v;

  __asm__ __volatile__ ("inw %w1,%0\noutb %%al,$0x80":"=a" (_v):"Nd" (__port));
  return _v;
}

# 78 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline unsigned int
inl (unsigned short int __port)
{
  unsigned int _v;

  __asm__ __volatile__ ("inl %w1,%0":"=a" (_v):"Nd" (__port));
  return _v;
}

# 87 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline unsigned int
inl_p (unsigned short int __port)
{
  unsigned int _v;
  __asm__ __volatile__ ("inl %w1,%0\noutb %%al,$0x80":"=a" (_v):"Nd" (__port));
  return _v;
}

# 95 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outb (unsigned char __value, unsigned short int __port)
{
  __asm__ __volatile__ ("outb %b0,%w1": :"a" (__value), "Nd" (__port));
}

# 101 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outb_p (unsigned char __value, unsigned short int __port)
{
  __asm__ __volatile__ ("outb %b0,%w1\noutb %%al,$0x80": :"a" (__value),
   "Nd" (__port));
}

# 108 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outw (unsigned short int __value, unsigned short int __port)
{
  __asm__ __volatile__ ("outw %w0,%w1": :"a" (__value), "Nd" (__port));

}

# 115 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outw_p (unsigned short int __value, unsigned short int __port)
{
  __asm__ __volatile__ ("outw %w0,%w1\noutb %%al,$0x80": :"a" (__value),
   "Nd" (__port));
}

# 122 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outl (unsigned int __value, unsigned short int __port)
{
  __asm__ __volatile__ ("outl %0,%w1": :"a" (__value), "Nd" (__port));
}

# 128 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outl_p (unsigned int __value, unsigned short int __port)
{
  __asm__ __volatile__ ("outl %0,%w1\noutb %%al,$0x80": :"a" (__value),
   "Nd" (__port));
}

# 135 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
insb (unsigned short int __port, void *__addr, unsigned long int __count)
{
  __asm__ __volatile__ ("cld ; rep ; insb":"=D" (__addr), "=c" (__count)
   :"d" (__port), "0" (__addr), "1" (__count));
}

# 142 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
insw (unsigned short int __port, void *__addr, unsigned long int __count)
{
  __asm__ __volatile__ ("cld ; rep ; insw":"=D" (__addr), "=c" (__count)
   :"d" (__port), "0" (__addr), "1" (__count));
}

# 149 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
insl (unsigned short int __port, void *__addr, unsigned long int __count)
{
  __asm__ __volatile__ ("cld ; rep ; insl":"=D" (__addr), "=c" (__count)
   :"d" (__port), "0" (__addr), "1" (__count));
}

# 156 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outsb (unsigned short int __port, const void *__addr,
       unsigned long int __count)
{
  __asm__ __volatile__ ("cld ; rep ; outsb":"=S" (__addr), "=c" (__count)
   :"d" (__port), "0" (__addr), "1" (__count));
}

# 164 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outsw (unsigned short int __port, const void *__addr,
       unsigned long int __count)
{
  __asm__ __volatile__ ("cld ; rep ; outsw":"=S" (__addr), "=c" (__count)
   :"d" (__port), "0" (__addr), "1" (__count));
}

# 172 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outsl (unsigned short int __port, const void *__addr,
       unsigned long int __count)
{
  __asm__ __volatile__ ("cld ; rep ; outsl":"=S" (__addr), "=c" (__count)
   :"d" (__port), "0" (__addr), "1" (__count));
}

# 542 "sys-utils/lscpu.c"
static inline void
cpuid(unsigned int op, unsigned int *eax, unsigned int *ebx,
    unsigned int *ecx, unsigned int *edx)
{
 __asm__(







  "cpuid;"
  : "=b" (*ebx),

    "=a" (*eax),
    "=c" (*ecx),
    "=d" (*edx)
  : "1" (op), "c"(0));
}

# 658 "sys-utils/lscpu.c"
static inline
void vmware_bdoor(uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx)
{
 __asm__(







  "inl (%%dx), %%eax;"
  : "=b" (*ebx),

    "=a" (*eax),
    "=c" (*ecx),
    "=d" (*edx)
  : "0" (0x564D5868),
    "1" (10),
    "2" (0x5658),
    "3" (0)
  : "memory");
}

