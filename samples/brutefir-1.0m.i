unsigned int __builtin_bswap32 (unsigned int);

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 64 "bit.h"
static inline int
bit_bsf(uint32_t n)
{
    int r;
    __asm__ volatile ("bsfl %1,%0\n\t" : "=r" (r) : "g" (n));
    return r;
}

# 36 "/usr/include/stdint.h"
typedef signed char int8_t;

# 37 "/usr/include/stdint.h"
typedef short int int16_t;

# 38 "/usr/include/stdint.h"
typedef int int32_t;

# 43 "/usr/include/stdint.h"
typedef long long int int64_t;

# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 16 "defs.h"
typedef int bool_t;

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 55 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long long int __quad_t;

# 131 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __off_t;

# 132 "/usr/include/i386-linux-gnu/bits/types.h"
typedef __quad_t __off64_t;

# 44 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}

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

# 170 "/usr/include/stdio.h"
extern struct _IO_FILE *stderr;

# 38 "bfrun.h"
void
bf_exit(int status);

# 12 "numunion.h"
typedef union {
    float r32[2];
    double r64[1];
    int8_t i8[8];
    int16_t i16[4];
    int32_t i32[2];
    int64_t i64[1];
    uint8_t u8[8];
    uint16_t u16[4];
    uint32_t u32[2];
    uint64_t u64[1];
} numunion_t;

# 7 "raw2real.h"
static void
raw2realf(void *_realbuf,
              void *_rawbuf,
              int bytes,
              bool_t isfloat,
              int spacing,
              bool_t swap,
              int n_samples)
{
    numunion_t *realbuf, *rawbuf, sample;
    int n, i;

    realbuf = (numunion_t *)_realbuf;
    rawbuf = (numunion_t *)_rawbuf;
    if (isfloat) {



        switch (bytes) {
        case 4:
            if (swap) {
                for (n = i = 0; n < n_samples; n++, i += spacing) {
                    realbuf->u32[n] = __bswap_32 ((uint32_t)(rawbuf->u32[i]));
                }
            } else {
                for (n = i = 0; n < n_samples; n++, i += spacing) {
                    realbuf->r32[n] = rawbuf->r32[i];
                }
            }
            break;
        case 8:
            if (swap) {
                for (n = i = 0; n < n_samples; n++, i += spacing) {
                    sample.u64[0] = (((((uint64_t)(rawbuf->u64[i])) & 0xff00000000000000ULL) >> 56) | ((((uint64_t)(rawbuf->u64[i])) & 0x00ff000000000000ULL) >> 40) | ((((uint64_t)(rawbuf->u64[i])) & 0x0000ff0000000000ULL) >> 24) | ((((uint64_t)(rawbuf->u64[i])) & 0x000000ff00000000ULL) >> 8) | ((((uint64_t)(rawbuf->u64[i])) & 0x00000000ff000000ULL) << 8) | ((((uint64_t)(rawbuf->u64[i])) & 0x0000000000ff0000ULL) << 24) | ((((uint64_t)(rawbuf->u64[i])) & 0x000000000000ff00ULL) << 40) | ((((uint64_t)(rawbuf->u64[i])) & 0x00000000000000ffULL) << 56));
                    realbuf->r32[n] = (float)sample.r64[0];
                }
            } else {
                for (n = i = 0; n < n_samples; n++, i += spacing) {
                    realbuf->r32[n] = (float)rawbuf->r64[i];
                }
            }
            break;
        default:
            goto raw2real_invalid_byte_size;
        }
# 85 "raw2real.h"
        return;
    }

    sample.u64[0] = 0;
    switch (bytes) {
    case 1:
 for (n = i = 0; n < n_samples; n++, i += spacing) {
     realbuf->r32[n] = (float)rawbuf->i8[i];
 }
 break;
    case 2:
        if (swap) {
            for (n = i = 0; n < n_samples; n++, i += spacing) {
                realbuf->r32[n] = (float)((int16_t)(__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((uint16_t)(rawbuf->u16[i])); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
            }
        } else {
            for (n = i = 0; n < n_samples; n++, i += spacing) {
                realbuf->r32[n] = (float)rawbuf->i16[i];
            }
        }
 break;
    case 3:
 spacing = spacing * 3 - 3;
# 126 "raw2real.h"
        if (swap) {
            for (n = i = 0; n < n_samples; n++, i += spacing) {
                sample.u8[3] = rawbuf->u8[i++];
                sample.u8[2] = rawbuf->u8[i++];
                sample.u8[1] = rawbuf->u8[i++];
                realbuf->r32[n] = (float)(sample.i32[0] >> 8);
            }
        } else {
            for (n = i = 0; n < n_samples; n++, i += spacing) {
                sample.u8[1] = rawbuf->u8[i++];
                sample.u8[2] = rawbuf->u8[i++];
                sample.u8[3] = rawbuf->u8[i++];
                realbuf->r32[n] = (float)(sample.i32[0] >> 8);
            }
        }

 break;
    case 4:
        if (swap) {
            for (n = i = 0; n < n_samples; n++, i += spacing) {
                realbuf->r32[n] = (float)((int32_t)__bswap_32 ((uint32_t)(rawbuf->u32[i])));
            }
        } else {
            for (n = i = 0; n < n_samples; n++, i += spacing) {
                realbuf->r32[n] = (float)rawbuf->i32[i];
            }
        }
 break;
    default:
    raw2real_invalid_byte_size:
 fprintf(stderr, "Sample byte size %d is not supported.\n", bytes);
 bf_exit(1);
 break;
    }
}

# 7 "raw2real.h"
static void
raw2reald(void *_realbuf,
              void *_rawbuf,
              int bytes,
              bool_t isfloat,
              int spacing,
              bool_t swap,
              int n_samples)
{
    numunion_t *realbuf, *rawbuf, sample;
    int n, i;

    realbuf = (numunion_t *)_realbuf;
    rawbuf = (numunion_t *)_rawbuf;
    if (isfloat) {
# 55 "raw2real.h"
        switch (bytes) {
        case 4:
            if (swap) {
                for (n = i = 0; n < n_samples; n++, i += spacing) {
                    sample.u32[0] = __bswap_32 ((uint32_t)(rawbuf->u32[i]));
                    realbuf->r64[n] = (double)sample.r32[0];
                }
            } else {
                for (n = i = 0; n < n_samples; n++, i += spacing) {
                    realbuf->r64[n] = (double)rawbuf->r32[i];
                }
            }
            break;
        case 8:
            if (swap) {
                for (n = i = 0; n < n_samples; n++, i += spacing) {
                    realbuf->u64[n] = (((((uint64_t)(rawbuf->u64[i])) & 0xff00000000000000ULL) >> 56) | ((((uint64_t)(rawbuf->u64[i])) & 0x00ff000000000000ULL) >> 40) | ((((uint64_t)(rawbuf->u64[i])) & 0x0000ff0000000000ULL) >> 24) | ((((uint64_t)(rawbuf->u64[i])) & 0x000000ff00000000ULL) >> 8) | ((((uint64_t)(rawbuf->u64[i])) & 0x00000000ff000000ULL) << 8) | ((((uint64_t)(rawbuf->u64[i])) & 0x0000000000ff0000ULL) << 24) | ((((uint64_t)(rawbuf->u64[i])) & 0x000000000000ff00ULL) << 40) | ((((uint64_t)(rawbuf->u64[i])) & 0x00000000000000ffULL) << 56));
                }
            } else {
                for (n = i = 0; n < n_samples; n++, i += spacing) {
                    realbuf->r64[n] = rawbuf->r64[i];
                }
            }
            break;
        default:
            goto raw2real_invalid_byte_size;
        }



        return;
    }

    sample.u64[0] = 0;
    switch (bytes) {
    case 1:
 for (n = i = 0; n < n_samples; n++, i += spacing) {
     realbuf->r64[n] = (double)rawbuf->i8[i];
 }
 break;
    case 2:
        if (swap) {
            for (n = i = 0; n < n_samples; n++, i += spacing) {
                realbuf->r64[n] = (double)((int16_t)(__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((uint16_t)(rawbuf->u16[i])); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
            }
        } else {
            for (n = i = 0; n < n_samples; n++, i += spacing) {
                realbuf->r64[n] = (double)rawbuf->i16[i];
            }
        }
 break;
    case 3:
 spacing = spacing * 3 - 3;
# 126 "raw2real.h"
        if (swap) {
            for (n = i = 0; n < n_samples; n++, i += spacing) {
                sample.u8[3] = rawbuf->u8[i++];
                sample.u8[2] = rawbuf->u8[i++];
                sample.u8[1] = rawbuf->u8[i++];
                realbuf->r64[n] = (double)(sample.i32[0] >> 8);
            }
        } else {
            for (n = i = 0; n < n_samples; n++, i += spacing) {
                sample.u8[1] = rawbuf->u8[i++];
                sample.u8[2] = rawbuf->u8[i++];
                sample.u8[3] = rawbuf->u8[i++];
                realbuf->r64[n] = (double)(sample.i32[0] >> 8);
            }
        }

 break;
    case 4:
        if (swap) {
            for (n = i = 0; n < n_samples; n++, i += spacing) {
                realbuf->r64[n] = (double)((int32_t)__bswap_32 ((uint32_t)(rawbuf->u32[i])));
            }
        } else {
            for (n = i = 0; n < n_samples; n++, i += spacing) {
                realbuf->r64[n] = (double)rawbuf->i32[i];
            }
        }
 break;
    default:
    raw2real_invalid_byte_size:
 fprintf(stderr, "Sample byte size %d is not supported.\n", bytes);
 bf_exit(1);
 break;
    }
}

