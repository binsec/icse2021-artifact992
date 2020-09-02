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

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 31 "./elf.h"
typedef uint16_t Elf32_Half;

# 32 "./elf.h"
typedef uint16_t Elf64_Half;

# 35 "./elf.h"
typedef uint32_t Elf32_Word;

# 37 "./elf.h"
typedef uint32_t Elf64_Word;

# 828 "./elf.h"
typedef struct
{
  Elf32_Half vd_version; /* Version revision */
  Elf32_Half vd_flags; /* Version information */
  Elf32_Half vd_ndx; /* Version Index */
  Elf32_Half vd_cnt; /* Number of associated aux entries */
  Elf32_Word vd_hash; /* Version name hash value */
  Elf32_Word vd_aux; /* Offset in bytes to verdaux array */
  Elf32_Word vd_next; /* Offset in bytes to next verdef
					   entry */
} Elf32_Verdef;

# 840 "./elf.h"
typedef struct
{
  Elf64_Half vd_version; /* Version revision */
  Elf64_Half vd_flags; /* Version information */
  Elf64_Half vd_ndx; /* Version Index */
  Elf64_Half vd_cnt; /* Number of associated aux entries */
  Elf64_Word vd_hash; /* Version name hash value */
  Elf64_Word vd_aux; /* Offset in bytes to verdaux array */
  Elf64_Word vd_next; /* Offset in bytes to next verdef
					   entry */
} Elf64_Verdef;

# 870 "./elf.h"
typedef struct
{
  Elf32_Word vda_name; /* Version or dependency names */
  Elf32_Word vda_next; /* Offset in bytes to next verdaux
					   entry */
} Elf32_Verdaux;

# 877 "./elf.h"
typedef struct
{
  Elf64_Word vda_name; /* Version or dependency names */
  Elf64_Word vda_next; /* Offset in bytes to next verdaux
					   entry */
} Elf64_Verdaux;

# 887 "./elf.h"
typedef struct
{
  Elf32_Half vn_version; /* Version of structure */
  Elf32_Half vn_cnt; /* Number of associated aux entries */
  Elf32_Word vn_file; /* Offset of filename for this
					   dependency */
  Elf32_Word vn_aux; /* Offset in bytes to vernaux array */
  Elf32_Word vn_next; /* Offset in bytes to next verneed
					   entry */
} Elf32_Verneed;

# 898 "./elf.h"
typedef struct
{
  Elf64_Half vn_version; /* Version of structure */
  Elf64_Half vn_cnt; /* Number of associated aux entries */
  Elf64_Word vn_file; /* Offset of filename for this
					   dependency */
  Elf64_Word vn_aux; /* Offset in bytes to vernaux array */
  Elf64_Word vn_next; /* Offset in bytes to next verneed
					   entry */
} Elf64_Verneed;

# 917 "./elf.h"
typedef struct
{
  Elf32_Word vna_hash; /* Hash value of dependency name */
  Elf32_Half vna_flags; /* Dependency specific information */
  Elf32_Half vna_other; /* Unused */
  Elf32_Word vna_name; /* Dependency name string offset */
  Elf32_Word vna_next; /* Offset in bytes to next vernaux
					   entry */
} Elf32_Vernaux;

# 927 "./elf.h"
typedef struct
{
  Elf64_Word vna_hash; /* Hash value of dependency name */
  Elf64_Half vna_flags; /* Dependency specific information */
  Elf64_Half vna_other; /* Unused */
  Elf64_Word vna_name; /* Dependency name string offset */
  Elf64_Word vna_next; /* Offset in bytes to next vernaux
					   entry */
} Elf64_Vernaux;

# 93 "./gelf.h"
typedef Elf64_Verdef GElf_Verdef;

# 96 "./gelf.h"
typedef Elf64_Verdaux GElf_Verdaux;

# 99 "./gelf.h"
typedef Elf64_Verneed GElf_Verneed;

# 102 "./gelf.h"
typedef Elf64_Vernaux GElf_Vernaux;

# 32 "gelf_xlate.h"
static inline void Elf32_cvt_Addr1 (void *dest, const void *ptr) { switch (4) { case 2: (*(uint16_t *) dest = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((*(const uint16_t *) ptr)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))); break; case 4: (*(uint32_t *) dest = __bswap_32 ((*(const uint32_t *) ptr))); break; case 8: (*(uint64_t *) dest = __bswap_64 ((*(const uint64_t *) ptr))); break; default: abort (); } }

# 33 "gelf_xlate.h"
static inline void Elf32_cvt_Off1 (void *dest, const void *ptr) { switch (4) { case 2: (*(uint16_t *) dest = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((*(const uint16_t *) ptr)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))); break; case 4: (*(uint32_t *) dest = __bswap_32 ((*(const uint32_t *) ptr))); break; case 8: (*(uint64_t *) dest = __bswap_64 ((*(const uint64_t *) ptr))); break; default: abort (); } }

# 34 "gelf_xlate.h"
static inline void Elf32_cvt_Half1 (void *dest, const void *ptr) { switch (2) { case 2: (*(uint16_t *) dest = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((*(const uint16_t *) ptr)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))); break; case 4: (*(uint32_t *) dest = __bswap_32 ((*(const uint32_t *) ptr))); break; case 8: (*(uint64_t *) dest = __bswap_64 ((*(const uint64_t *) ptr))); break; default: abort (); } }

# 35 "gelf_xlate.h"
static inline void Elf32_cvt_Word1 (void *dest, const void *ptr) { switch (4) { case 2: (*(uint16_t *) dest = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((*(const uint16_t *) ptr)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))); break; case 4: (*(uint32_t *) dest = __bswap_32 ((*(const uint32_t *) ptr))); break; case 8: (*(uint64_t *) dest = __bswap_64 ((*(const uint64_t *) ptr))); break; default: abort (); } }

# 36 "gelf_xlate.h"
static inline void Elf32_cvt_Sword1 (void *dest, const void *ptr) { switch (4) { case 2: (*(uint16_t *) dest = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((*(const uint16_t *) ptr)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))); break; case 4: (*(uint32_t *) dest = __bswap_32 ((*(const uint32_t *) ptr))); break; case 8: (*(uint64_t *) dest = __bswap_64 ((*(const uint64_t *) ptr))); break; default: abort (); } }

# 37 "gelf_xlate.h"
static inline void Elf32_cvt_Xword1 (void *dest, const void *ptr) { switch (8) { case 2: (*(uint16_t *) dest = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((*(const uint16_t *) ptr)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))); break; case 4: (*(uint32_t *) dest = __bswap_32 ((*(const uint32_t *) ptr))); break; case 8: (*(uint64_t *) dest = __bswap_64 ((*(const uint64_t *) ptr))); break; default: abort (); } }

# 38 "gelf_xlate.h"
static inline void Elf32_cvt_Sxword1 (void *dest, const void *ptr) { switch (8) { case 2: (*(uint16_t *) dest = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((*(const uint16_t *) ptr)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))); break; case 4: (*(uint32_t *) dest = __bswap_32 ((*(const uint32_t *) ptr))); break; case 8: (*(uint64_t *) dest = __bswap_64 ((*(const uint64_t *) ptr))); break; default: abort (); } }

# 32 "gelf_xlate.h"
static inline void Elf64_cvt_Addr1 (void *dest, const void *ptr) { switch (8) { case 2: (*(uint16_t *) dest = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((*(const uint16_t *) ptr)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))); break; case 4: (*(uint32_t *) dest = __bswap_32 ((*(const uint32_t *) ptr))); break; case 8: (*(uint64_t *) dest = __bswap_64 ((*(const uint64_t *) ptr))); break; default: abort (); } }

# 33 "gelf_xlate.h"
static inline void Elf64_cvt_Off1 (void *dest, const void *ptr) { switch (8) { case 2: (*(uint16_t *) dest = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((*(const uint16_t *) ptr)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))); break; case 4: (*(uint32_t *) dest = __bswap_32 ((*(const uint32_t *) ptr))); break; case 8: (*(uint64_t *) dest = __bswap_64 ((*(const uint64_t *) ptr))); break; default: abort (); } }

# 34 "gelf_xlate.h"
static inline void Elf64_cvt_Half1 (void *dest, const void *ptr) { switch (2) { case 2: (*(uint16_t *) dest = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((*(const uint16_t *) ptr)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))); break; case 4: (*(uint32_t *) dest = __bswap_32 ((*(const uint32_t *) ptr))); break; case 8: (*(uint64_t *) dest = __bswap_64 ((*(const uint64_t *) ptr))); break; default: abort (); } }

# 35 "gelf_xlate.h"
static inline void Elf64_cvt_Word1 (void *dest, const void *ptr) { switch (4) { case 2: (*(uint16_t *) dest = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((*(const uint16_t *) ptr)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))); break; case 4: (*(uint32_t *) dest = __bswap_32 ((*(const uint32_t *) ptr))); break; case 8: (*(uint64_t *) dest = __bswap_64 ((*(const uint64_t *) ptr))); break; default: abort (); } }

# 36 "gelf_xlate.h"
static inline void Elf64_cvt_Sword1 (void *dest, const void *ptr) { switch (4) { case 2: (*(uint16_t *) dest = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((*(const uint16_t *) ptr)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))); break; case 4: (*(uint32_t *) dest = __bswap_32 ((*(const uint32_t *) ptr))); break; case 8: (*(uint64_t *) dest = __bswap_64 ((*(const uint64_t *) ptr))); break; default: abort (); } }

# 37 "gelf_xlate.h"
static inline void Elf64_cvt_Xword1 (void *dest, const void *ptr) { switch (8) { case 2: (*(uint16_t *) dest = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((*(const uint16_t *) ptr)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))); break; case 4: (*(uint32_t *) dest = __bswap_32 ((*(const uint32_t *) ptr))); break; case 8: (*(uint64_t *) dest = __bswap_64 ((*(const uint64_t *) ptr))); break; default: abort (); } }

# 38 "gelf_xlate.h"
static inline void Elf64_cvt_Sxword1 (void *dest, const void *ptr) { switch (8) { case 2: (*(uint16_t *) dest = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((*(const uint16_t *) ptr)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))); break; case 4: (*(uint32_t *) dest = __bswap_32 ((*(const uint32_t *) ptr))); break; case 8: (*(uint64_t *) dest = __bswap_64 ((*(const uint64_t *) ptr))); break; default: abort (); } }

# 69 "/usr/include/assert.h"
extern void __assert_fail (const char *__assertion, const char *__file,
      unsigned int __line, const char *__function);

# 36 "version_xlate.h"
static void
elf_cvt_Verdef (void *dest, const void *src, size_t len, int encode)
{
  /* We have two different record types: ElfXX_Verndef and ElfXX_Verdaux.
     To recognize them we have to walk the data structure and convert
     them one after the other.  The ENCODE parameter specifies whether
     we are encoding or decoding.  When we are encoding we can immediately
     use the data in the buffer; if not, we have to decode the data before
     using it.  */
  size_t def_offset = 0;
  GElf_Verdef *ddest;
  GElf_Verdef *dsrc;

  /* We rely on the types being all the same size.  */
  ((sizeof (GElf_Verdef) == sizeof (Elf32_Verdef)) ? (void) (0) : __assert_fail ("sizeof (GElf_Verdef) == sizeof (Elf32_Verdef)", "version_xlate.h", 50, __PRETTY_FUNCTION__));
  ((sizeof (GElf_Verdaux) == sizeof (Elf32_Verdaux)) ? (void) (0) : __assert_fail ("sizeof (GElf_Verdaux) == sizeof (Elf32_Verdaux)", "version_xlate.h", 51, __PRETTY_FUNCTION__));
  ((sizeof (GElf_Verdef) == sizeof (Elf64_Verdef)) ? (void) (0) : __assert_fail ("sizeof (GElf_Verdef) == sizeof (Elf64_Verdef)", "version_xlate.h", 52, __PRETTY_FUNCTION__));
  ((sizeof (GElf_Verdaux) == sizeof (Elf64_Verdaux)) ? (void) (0) : __assert_fail ("sizeof (GElf_Verdaux) == sizeof (Elf64_Verdaux)", "version_xlate.h", 53, __PRETTY_FUNCTION__));

  if (len == 0)
    return;

  do
    {
      size_t aux_offset;
      GElf_Verdaux *asrc;

      /* Test for correct offset.  */
      if (def_offset + sizeof (GElf_Verdef) > len)
 return;

      /* Work the tree from the first record.  */
      ddest = (GElf_Verdef *) ((char *) dest + def_offset);
      dsrc = (GElf_Verdef *) ((char *) src + def_offset);

      /* Decode first if necessary.  */
      if (! encode)
 {
   ddest->vd_version = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dsrc->vd_version); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
   ddest->vd_flags = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dsrc->vd_flags); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
   ddest->vd_ndx = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dsrc->vd_ndx); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
   ddest->vd_cnt = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dsrc->vd_cnt); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
   ddest->vd_hash = __bswap_32 (dsrc->vd_hash);
   ddest->vd_aux = __bswap_32 (dsrc->vd_aux);
   ddest->vd_next = __bswap_32 (dsrc->vd_next);

   aux_offset = def_offset + ddest->vd_aux;
 }
      else
 aux_offset = def_offset + dsrc->vd_aux;

      /* Handle all the auxiliary records belonging to this definition.  */
      do
 {
   GElf_Verdaux *adest;

   /* Test for correct offset.  */
   if (aux_offset + sizeof (GElf_Verdaux) > len)
     return;

   adest = (GElf_Verdaux *) ((char *) dest + aux_offset);
   asrc = (GElf_Verdaux *) ((char *) src + aux_offset);

   if (encode)
     aux_offset += asrc->vda_next;

   adest->vda_name = __bswap_32 (asrc->vda_name);
   adest->vda_next = __bswap_32 (asrc->vda_next);

   if (! encode)
     aux_offset += adest->vda_next;
 }
      while (asrc->vda_next != 0);

      /* Encode now if necessary.  */
      if (encode)
 {
   def_offset += dsrc->vd_next;

   ddest->vd_version = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dsrc->vd_version); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
   ddest->vd_flags = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dsrc->vd_flags); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
   ddest->vd_ndx = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dsrc->vd_ndx); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
   ddest->vd_cnt = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dsrc->vd_cnt); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
   ddest->vd_hash = __bswap_32 (dsrc->vd_hash);
   ddest->vd_aux = __bswap_32 (dsrc->vd_aux);
   ddest->vd_next = __bswap_32 (dsrc->vd_next);
 }
      else
 def_offset += ddest->vd_next;
    }
  while (dsrc->vd_next != 0);
}

# 130 "version_xlate.h"
static void
elf_cvt_Verneed (void *dest, const void *src, size_t len, int encode)
{
  /* We have two different record types: ElfXX_Verndef and ElfXX_Verdaux.
     To recognize them we have to walk the data structure and convert
     them one after the other.  The ENCODE parameter specifies whether
     we are encoding or decoding.  When we are encoding we can immediately
     use the data in the buffer; if not, we have to decode the data before
     using it.  */
  size_t need_offset = 0;
  GElf_Verneed *ndest;
  GElf_Verneed *nsrc;

  /* We rely on the types being all the same size.  */
  ((sizeof (GElf_Verneed) == sizeof (Elf32_Verneed)) ? (void) (0) : __assert_fail ("sizeof (GElf_Verneed) == sizeof (Elf32_Verneed)", "version_xlate.h", 144, __PRETTY_FUNCTION__));
  ((sizeof (GElf_Vernaux) == sizeof (Elf32_Vernaux)) ? (void) (0) : __assert_fail ("sizeof (GElf_Vernaux) == sizeof (Elf32_Vernaux)", "version_xlate.h", 145, __PRETTY_FUNCTION__));
  ((sizeof (GElf_Verneed) == sizeof (Elf64_Verneed)) ? (void) (0) : __assert_fail ("sizeof (GElf_Verneed) == sizeof (Elf64_Verneed)", "version_xlate.h", 146, __PRETTY_FUNCTION__));
  ((sizeof (GElf_Vernaux) == sizeof (Elf64_Vernaux)) ? (void) (0) : __assert_fail ("sizeof (GElf_Vernaux) == sizeof (Elf64_Vernaux)", "version_xlate.h", 147, __PRETTY_FUNCTION__));

  if (len == 0)
    return;

  do
    {
      size_t aux_offset;
      GElf_Vernaux *asrc;

      /* Test for correct offset.  */
      if (need_offset + sizeof (GElf_Verneed) > len)
 return;

      /* Work the tree from the first record.  */
      ndest = (GElf_Verneed *) ((char *) dest + need_offset);
      nsrc = (GElf_Verneed *) ((char *) src + need_offset);

      /* Decode first if necessary.  */
      if (! encode)
 {
   ndest->vn_version = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (nsrc->vn_version); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
   ndest->vn_cnt = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (nsrc->vn_cnt); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
   ndest->vn_file = __bswap_32 (nsrc->vn_file);
   ndest->vn_aux = __bswap_32 (nsrc->vn_aux);
   ndest->vn_next = __bswap_32 (nsrc->vn_next);

   aux_offset = need_offset + ndest->vn_aux;
 }
      else
 aux_offset = need_offset + nsrc->vn_aux;

      /* Handle all the auxiliary records belonging to this requirement.  */
      do
 {
   GElf_Vernaux *adest;

   /* Test for correct offset.  */
   if (aux_offset + sizeof (GElf_Vernaux) > len)
     return;

   adest = (GElf_Vernaux *) ((char *) dest + aux_offset);
   asrc = (GElf_Vernaux *) ((char *) src + aux_offset);

   if (encode)
     aux_offset += asrc->vna_next;

   adest->vna_hash = __bswap_32 (asrc->vna_hash);
   adest->vna_flags = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (asrc->vna_flags); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
   adest->vna_other = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (asrc->vna_other); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
   adest->vna_name = __bswap_32 (asrc->vna_name);
   adest->vna_next = __bswap_32 (asrc->vna_next);

   if (! encode)
     aux_offset += adest->vna_next;
 }
      while (asrc->vna_next != 0);

      /* Encode now if necessary.  */
      if (encode)
 {
   need_offset += nsrc->vn_next;

   ndest->vn_version = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (nsrc->vn_version); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
   ndest->vn_cnt = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (nsrc->vn_cnt); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
   ndest->vn_file = __bswap_32 (nsrc->vn_file);
   ndest->vn_aux = __bswap_32 (nsrc->vn_aux);
   ndest->vn_next = __bswap_32 (nsrc->vn_next);
 }
      else
 need_offset += ndest->vn_next;
    }
  while (nsrc->vn_next != 0);
}

