void * __builtin___memcpy_chk (void *, const void *, unsigned int, unsigned int);
unsigned int __builtin_object_size (const void *, int);

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

# 237 "/usr/include/stdio.h"
extern int fclose (FILE *__stream);

# 57 "conftest.c"
int
main ()
{

     int op = 0x00000000, eax, edx;
     FILE *f;
      /* Opcodes for xgetbv */
      __asm__(".byte 0x0f, 0x01, 0xd0"
        : "=a" (eax), "=d" (edx)
        : "c" (op));
     f = fopen("conftest_xgetbv", "w"); if (!f) return 1;
     fprintf(f, "%x:%x\n", eax, edx);
     fclose(f);
     return 0;

  ;
  return 0;
}

# 47 "/usr/include/i386-linux-gnu/bits/string3.h"
extern __inline void *
 memcpy (void *__restrict __dest, const void *__restrict __src, size_t __len)

{
  return __builtin___memcpy_chk (__dest, __src, __len, __builtin_object_size (__dest, 0));
}

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 64 "gnubg-types.h"
typedef union _positionkey {
    unsigned int data[7];
} positionkey;

# 39 "cache.h"
typedef struct _cacheNodeDetail {
    positionkey key;
    int nEvalContext;
    float ar[6];
} cacheNodeDetail;

# 45 "cache.h"
typedef struct _cacheNode {
    cacheNodeDetail nd_primary;
    cacheNodeDetail nd_secondary;

    volatile int lock;

} cacheNode;

# 56 "cache.h"
typedef struct _cache {
    cacheNode *entries;

    unsigned int size;
    uint32_t hashMask;






} evalCache;

# 98 "cache.c"
extern uint32_t
GetHashKey(uint32_t hashMask, const cacheNodeDetail * e)
{
    uint32_t hash = (uint32_t) e->nEvalContext;
    int i;

    hash *= 0xcc9e2d51;
    hash = (hash << 15) | (hash >> (32 - 15));
    hash *= 0x1b873593;

    hash = (hash << 13) | (hash >> (32 - 13));
    hash = hash * 5 + 0xe6546b64;

    for (i = 0; i < 7; i++) {
        uint32_t k = e->key.data[i];

        k *= 0xcc9e2d51;
        k = (k << 15) | (k >> (32 - 15));
        k *= 0x1b873593;

        hash ^= k;
        hash = (hash << 13) | (hash >> (32 - 13));
        hash = hash * 5 + 0xe6546b64;
    }

    /* Real MurmurHash3 has a "hash ^= len" here,
     * but for us len is constant. Skip it */

    hash ^= hash >> 16;
    hash *= 0x85ebca6b;
    hash ^= hash >> 13;
    hash *= 0xc2b2ae35;
    hash ^= hash >> 16;

    return (hash & hashMask);
}

# 136 "cache.c"
uint32_t
CacheLookupWithLocking(evalCache * pc, const cacheNodeDetail * e, float *arOut, float *arCubeful)
{
    uint32_t const l = GetHashKey(pc->hashMask, e);





    while (__sync_lock_test_and_set(&(pc->entries[l].lock), 1)) while (pc->entries[l].lock) __asm volatile ("pause" ::: "memory");

    if (!(pc->entries[l].nd_primary.key.data[0]==e->key.data[0]&&pc->entries[l].nd_primary.key.data[1]==e->key.data[1]&&pc->entries[l].nd_primary.key.data[2]==e->key.data[2]&&pc->entries[l].nd_primary.key.data[3]==e->key.data[3]&&pc->entries[l].nd_primary.key.data[4]==e->key.data[4]&&pc->entries[l].nd_primary.key.data[5]==e->key.data[5]&&pc->entries[l].nd_primary.key.data[6]==e->key.data[6]) || pc->entries[l].nd_primary.nEvalContext != e->nEvalContext) { /* Not in primary slot */
        if (!(pc->entries[l].nd_secondary.key.data[0]==e->key.data[0]&&pc->entries[l].nd_secondary.key.data[1]==e->key.data[1]&&pc->entries[l].nd_secondary.key.data[2]==e->key.data[2]&&pc->entries[l].nd_secondary.key.data[3]==e->key.data[3]&&pc->entries[l].nd_secondary.key.data[4]==e->key.data[4]&&pc->entries[l].nd_secondary.key.data[5]==e->key.data[5]&&pc->entries[l].nd_secondary.key.data[6]==e->key.data[6]) || pc->entries[l].nd_secondary.nEvalContext != e->nEvalContext) { /* Cache miss */

            __sync_lock_release(&(pc->entries[l].lock));;

            return l;
        } else { /* Found in second slot, promote "hot" entry */
            cacheNodeDetail tmp = pc->entries[l].nd_primary;

            pc->entries[l].nd_primary = pc->entries[l].nd_secondary;
            pc->entries[l].nd_secondary = tmp;
        }
    }
    /* Cache hit */
    memcpy(arOut, pc->entries[l].nd_primary.ar, sizeof(float) * 5 /*NUM_OUTPUTS */ );
    if (arCubeful)
        *arCubeful = pc->entries[l].nd_primary.ar[5]; /* Cubeful equity stored in slot 5 */


    __sync_lock_release(&(pc->entries[l].lock));;






    return ((uint32_t)-1);
}

# 207 "cache.c"
void
CacheAddWithLocking(evalCache * pc, const cacheNodeDetail * e, uint32_t l)
{

    while (__sync_lock_test_and_set(&(pc->entries[l].lock), 1)) while (pc->entries[l].lock) __asm volatile ("pause" ::: "memory");


    pc->entries[l].nd_secondary = pc->entries[l].nd_primary;
    pc->entries[l].nd_primary = *e;


    __sync_lock_release(&(pc->entries[l].lock));;





}

