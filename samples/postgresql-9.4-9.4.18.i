unsigned int __builtin_bswap32 (unsigned int);
void __builtin_unreachable (void);

# 44 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}

# 244 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/include/c.h"
typedef unsigned short uint16;

# 245 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/include/c.h"
typedef unsigned int uint32;

# 276 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/include/utils/elog.h"
extern void elog_start(const char *filename, int lineno, const char *funcname);

# 277 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/include/utils/elog.h"
extern void
elog_finish(int elevel, const char *fmt,...);

# 35 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/include/lib/stringinfo.h"
typedef struct StringInfoData
{
 char *data;
 int len;
 int maxlen;
 int cursor;
} StringInfoData;

# 43 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/include/lib/stringinfo.h"
typedef StringInfoData *StringInfo;

# 148 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/include/lib/stringinfo.h"
extern void appendBinaryStringInfo(StringInfo str,
        const char *data, int datalen);

# 44 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/include/libpq/pqformat.h"
extern void pq_copymsgbytes(StringInfo msg, char *buf, int datalen);

# 234 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/backend/libpq/pqformat.c"
void
pq_sendint(StringInfo buf, int i, int b)
{
 unsigned char n8;
 uint16 n16;
 uint32 n32;

 switch (b)
 {
  case 1:
   n8 = (unsigned char) i;
   appendBinaryStringInfo(buf, (char *) &n8, 1);
   break;
  case 2:
   n16 = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((uint16) i); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
   appendBinaryStringInfo(buf, (char *) &n16, 2);
   break;
  case 4:
   n32 = __bswap_32 ((uint32) i);
   appendBinaryStringInfo(buf, (char *) &n32, 4);
   break;
  default:
   do { elog_start("/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/backend/libpq/pqformat.c", 256, __func__); elog_finish(20 /* user error - abort transaction; return to
								 * known state */
# 256 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/backend/libpq/pqformat.c"
   , "unsupported integer size %d", b); if (__builtin_constant_p(20 /* user error - abort transaction; return to
								 * known state */
# 256 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/backend/libpq/pqformat.c"
   ) && (20 /* user error - abort transaction; return to
								 * known state */
# 256 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/backend/libpq/pqformat.c"
   ) >= 20 /* user error - abort transaction; return to
								 * known state */
# 256 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/backend/libpq/pqformat.c"
   ) __builtin_unreachable(); } while(0);
   break;
 }
}

# 446 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/backend/libpq/pqformat.c"
unsigned int
pq_getmsgint(StringInfo msg, int b)
{
 unsigned int result;
 unsigned char n8;
 uint16 n16;
 uint32 n32;

 switch (b)
 {
  case 1:
   pq_copymsgbytes(msg, (char *) &n8, 1);
   result = n8;
   break;
  case 2:
   pq_copymsgbytes(msg, (char *) &n16, 2);
   result = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (n16); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
   break;
  case 4:
   pq_copymsgbytes(msg, (char *) &n32, 4);
   result = __bswap_32 (n32);
   break;
  default:
   do { elog_start("/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/backend/libpq/pqformat.c", 469, __func__); elog_finish(20 /* user error - abort transaction; return to
								 * known state */
# 469 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/backend/libpq/pqformat.c"
   , "unsupported integer size %d", b); if (__builtin_constant_p(20 /* user error - abort transaction; return to
								 * known state */
# 469 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/backend/libpq/pqformat.c"
   ) && (20 /* user error - abort transaction; return to
								 * known state */
# 469 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/backend/libpq/pqformat.c"
   ) >= 20 /* user error - abort transaction; return to
								 * known state */
# 469 "/vagrant/allpkg/postgresql-9.4-9.4.18/build/../src/backend/libpq/pqformat.c"
   ) __builtin_unreachable(); } while(0);
   result = 0; /* keep compiler quiet */
   break;
 }
 return result;
}

# 23 "/usr/include/python3.4m/pyatomic.h"
typedef enum _Py_memory_order {
    _Py_memory_order_relaxed,
    _Py_memory_order_acquire,
    _Py_memory_order_release,
    _Py_memory_order_acq_rel,
    _Py_memory_order_seq_cst
} _Py_memory_order;

# 50 "/usr/include/python3.4m/pyatomic.h"
static __inline__ void
_Py_atomic_thread_fence(_Py_memory_order order)
{
    if (order != _Py_memory_order_relaxed)
        __asm__ volatile("mfence":::"memory");
}

