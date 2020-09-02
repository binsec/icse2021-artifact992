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

# 54 "/usr/include/i386-linux-gnu/sys/select.h"
typedef long int __fd_mask;

# 64 "/usr/include/i386-linux-gnu/sys/select.h"
typedef struct
  {
    /* XPG4.2 requires this member name.  Otherwise avoid the name
       from the global namespace.  */

    __fd_mask fds_bits[1024 / (8 * (int) sizeof (__fd_mask))];





  } fd_set;

# 51 "select.c"
static fd_set select_readfds;

# 52 "select.c"
static fd_set select_writefds;

# 135 "select.c"
extern int rb_maxconnections;

# 136 "select.c"
int
rb_init_netio_select(void)
{
 if(rb_maxconnections > 1024)
  rb_maxconnections = 1024; /* override this */
 do { int __d0, __d1; __asm__ __volatile__ ("cld; rep; " "stosl" : "=c" (__d0), "=D" (__d1) : "a" (0), "0" (sizeof (fd_set) / sizeof (__fd_mask)), "1" (&((&select_readfds)->fds_bits)[0]) : "memory"); } while (0);
 do { int __d0, __d1; __asm__ __volatile__ ("cld; rep; " "stosl" : "=c" (__d0), "=D" (__d1) : "a" (0), "0" (sizeof (fd_set) / sizeof (__fd_mask)), "1" (&((&select_writefds)->fds_bits)[0]) : "memory"); } while (0);
 return 0;
}

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 201 "/usr/include/i386-linux-gnu/sys/types.h"
typedef unsigned int u_int16_t;

# 66 "/usr/include/string.h"
extern void *memset (void *__s, int __c, size_t __n);

# 38 "../include/reslib.h"
typedef struct
{
        unsigned id :16; /* query identification number */
# 55 "../include/reslib.h"
                        /* fields in third byte */
        unsigned rd :1; /* recursion desired */
        unsigned tc :1; /* truncated message */
        unsigned aa :1; /* authoritive answer */
        unsigned opcode :4; /* purpose of message */
        unsigned qr :1; /* response flag */
                        /* fields in fourth byte */
        unsigned rcode :4; /* response code */
        unsigned cd: 1; /* checking disabled by resolver */
        unsigned ad: 1; /* authentic data from named */
        unsigned unused :1; /* unused bits (MBZ as of 4.9.3a3) */
        unsigned ra :1; /* recursion available */

                        /* remaining bytes */
        unsigned qdcount :16; /* number of question entries */
        unsigned ancount :16; /* number of answer entries */
        unsigned nscount :16; /* number of authority entries */
        unsigned arcount :16; /* number of resource entries */
} HEADER;

# 125 "reslib.c"
static int irc_ns_name_compress(const char *src, unsigned char *dst, size_t dstsiz,
    const unsigned char **dnptrs, const unsigned char **lastdnptr);

# 478 "reslib.c"
static int
irc_dn_comp(const char *src, unsigned char *dst, int dstsiz,
            unsigned char **dnptrs, unsigned char **lastdnptr)
{
  return(irc_ns_name_compress(src, dst, (size_t)dstsiz,
                              (const unsigned char **)dnptrs,
                              (const unsigned char **)lastdnptr));
}

# 1137 "reslib.c"
int
irc_res_mkquery(
      const char *dname, /* domain name */
      int class, int type, /* class and type of query */
      unsigned char *buf, /* buffer to put query */
      int buflen) /* size of buffer */
{
 HEADER *hp;
 unsigned char *cp;
 int n;
 unsigned char *dnptrs[20], **dpp, **lastdnptr;

 /*
	 * Initialize header fields.
	 */
 if ((buf == ((void *)0)) || (buflen < 12))
  return (-1);
 memset(buf, 0, 12);
 hp = (HEADER *) buf;

 hp->id = 0;
 hp->opcode = 0;
 hp->rd = 1; /* recurse */
 hp->rcode = 0;
 cp = buf + 12;
 buflen -= 12;
 dpp = dnptrs;
 *dpp++ = buf;
 *dpp++ = ((void *)0);
 lastdnptr = dnptrs + sizeof dnptrs / sizeof dnptrs[0];

 if ((buflen -= 4) < 0)
   return (-1);
 if ((n = irc_dn_comp(dname, cp, buflen, dnptrs, lastdnptr)) < 0)
   return (-1);

 cp += n;
 buflen -= n;
 { u_int16_t t_s = (u_int16_t)(type); unsigned char *t_cp = (unsigned char *)(cp); *t_cp++ = t_s >> 8; *t_cp = t_s; (cp) += 2; };
 { u_int16_t t_s = (u_int16_t)(class); unsigned char *t_cp = (unsigned char *)(cp); *t_cp++ = t_s >> 8; *t_cp = t_s; (cp) += 2; };
 hp->qdcount = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (1); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

 return (cp - buf);
}

