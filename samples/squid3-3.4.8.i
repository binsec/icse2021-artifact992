unsigned int __builtin_bswap32 (unsigned int);
void * __builtin___memcpy_chk (void *, const void *, unsigned int, unsigned int);
unsigned int __builtin_object_size (const void *, int);
void * __builtin___memset_chk (void *, int, unsigned int, unsigned int);
char * __builtin_strchr (const char *, int);

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 44 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 24 "../compat/xalloc.h"
void *xmalloc(size_t sz);

# 39 "../compat/xalloc.h"
void free_const(const void *s);

# 52 "../compat/xalloc.h"
static inline void xfree(const void *p) { if (p) free_const(p); }

# 399 "/usr/include/string.h"
extern size_t strlen (const char *__s);

# 393 "/usr/include/i386-linux-gnu/bits/string2.h"
extern void *__rawmemchr (const void *__s, int __c);

# 22 "/usr/include/i386-linux-gnu/bits/string3.h"
extern void __warn_memset_zero_len (void);

# 47 "/usr/include/i386-linux-gnu/bits/string3.h"
extern __inline void *
 memcpy (void *__restrict __dest, const void *__restrict __src, size_t __len)

{
  return __builtin___memcpy_chk (__dest, __src, __len, __builtin_object_size (__dest, 0));
}

# 75 "/usr/include/i386-linux-gnu/bits/string3.h"
extern __inline void *
 memset (void *__dest, int __ch, size_t __len)
{
  if (__builtin_constant_p (__len) && __len == 0
      && (!__builtin_constant_p (__ch) || __ch != 0))
    {
      __warn_memset_zero_len ();
      return __dest;
    }
  return __builtin___memset_chk (__dest, __ch, __len, __builtin_object_size (__dest, 0));
}

# 21 "../compat/xstring.h"
char *xstrdup(const char *s);

# 69 "/usr/include/assert.h"
extern void __assert_fail (const char *__assertion, const char *__file,
      unsigned int __line, const char *__function);

# 58 "../include/rfc1035.h"
typedef struct _rfc1035_rr rfc1035_rr;

# 59 "../include/rfc1035.h"
struct _rfc1035_rr {
    char name[256];
    unsigned short type;
    unsigned short _class;
    unsigned int ttl;
    unsigned short rdlength;
    char *rdata;
};

# 68 "../include/rfc1035.h"
typedef struct _rfc1035_query rfc1035_query;

# 69 "../include/rfc1035.h"
struct _rfc1035_query {
    char name[256];
    unsigned short qtype;
    unsigned short qclass;
};

# 75 "../include/rfc1035.h"
typedef struct _rfc1035_message rfc1035_message;

# 76 "../include/rfc1035.h"
struct _rfc1035_message {
    unsigned short id;
    unsigned int qr:1;
    unsigned int opcode:4;
    unsigned int aa:1;
    unsigned int tc:1;
    unsigned int rd:1;
    unsigned int ra:1;
    unsigned int rcode:4;
    unsigned short qdcount;
    unsigned short ancount;
    unsigned short nscount;
    unsigned short arcount;
    rfc1035_query *query;
    rfc1035_rr *answer;
};

# 85 "rfc1035.c"
int
rfc1035HeaderPack(char *buf, size_t sz, rfc1035_message * hdr)
{
    int off = 0;
    unsigned short s;
    unsigned short t;
    ((sz >= 12) ? (void) (0) : __assert_fail ("sz >= 12", "rfc1035.c", 91, __PRETTY_FUNCTION__));
    s = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (hdr->id); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(buf + off, &s, sizeof(s));
    off += sizeof(s);
    t = 0;
    t |= hdr->qr << 15;
    t |= (hdr->opcode << 11);
    t |= (hdr->aa << 10);
    t |= (hdr->tc << 9);
    t |= (hdr->rd << 8);
    t |= (hdr->ra << 7);
    t |= hdr->rcode;
    s = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (t); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(buf + off, &s, sizeof(s));
    off += sizeof(s);
    s = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (hdr->qdcount); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(buf + off, &s, sizeof(s));
    off += sizeof(s);
    s = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (hdr->ancount); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(buf + off, &s, sizeof(s));
    off += sizeof(s);
    s = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (hdr->nscount); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(buf + off, &s, sizeof(s));
    off += sizeof(s);
    s = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (hdr->arcount); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(buf + off, &s, sizeof(s));
    off += sizeof(s);
    ((off == 12) ? (void) (0) : __assert_fail ("off == 12", "rfc1035.c", 118, __PRETTY_FUNCTION__));
    return off;
}

# 130 "rfc1035.c"
static int
rfc1035LabelPack(char *buf, size_t sz, const char *label)
{
    int off = 0;
    size_t len = label ? strlen(label) : 0;
    if (label)
        ((!(__extension__ (__builtin_constant_p ('.') && !__builtin_constant_p (label) && ('.') == '\0' ? (char *) __rawmemchr (label, '.') : __builtin_strchr (label, '.')))) ? (void) (0) : __assert_fail ("!(__extension__ (__builtin_constant_p ('.') && !__builtin_constant_p (label) && ('.') == '\\0' ? (char *) __rawmemchr (label, '.') : __builtin_strchr (label, '.')))", "rfc1035.c", 136, __PRETTY_FUNCTION__));
    if (len > 63)
        len = 63;
    ((sz >= len + 1) ? (void) (0) : __assert_fail ("sz >= len + 1", "rfc1035.c", 139, __PRETTY_FUNCTION__));
    *(buf + off) = (char) len;
    off++;
    memcpy(buf + off, label, len);
    off += len;
    return off;
}

# 155 "rfc1035.c"
static int
rfc1035NamePack(char *buf, size_t sz, const char *name)
{
    unsigned int off = 0;
    char *copy = xstrdup(name);
    char *t;
    /*
     * NOTE: use of strtok here makes names like foo....com valid.
     */
    for (t = strtok(copy, "."); t; t = strtok(((void *)0), "."))
        off += rfc1035LabelPack(buf + off, sz - off, t);
    xfree(copy);
    off += rfc1035LabelPack(buf + off, sz - off, ((void *)0));
    ((off <= sz) ? (void) (0) : __assert_fail ("off <= sz", "rfc1035.c", 168, __PRETTY_FUNCTION__));
    return off;
}

# 178 "rfc1035.c"
int
rfc1035QuestionPack(char *buf,
                    const size_t sz,
                    const char *name,
                    const unsigned short type,
                    const unsigned short _class)
{
    unsigned int off = 0;
    unsigned short s;
    off += rfc1035NamePack(buf + off, sz - off, name);
    s = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (type); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(buf + off, &s, sizeof(s));
    off += sizeof(s);
    s = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (_class); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(buf + off, &s, sizeof(s));
    off += sizeof(s);
    ((off <= sz) ? (void) (0) : __assert_fail ("off <= sz", "rfc1035.c", 194, __PRETTY_FUNCTION__));
    return off;
}

# 209 "rfc1035.c"
int
rfc1035HeaderUnpack(const char *buf, size_t sz, unsigned int *off, rfc1035_message * h)
{
    unsigned short s;
    unsigned short t;
    ((*off == 0) ? (void) (0) : __assert_fail ("*off == 0", "rfc1035.c", 214, __PRETTY_FUNCTION__));
    /*
     * The header is 12 octets.  This is a bogus message if the size
     * is less than that.
     */
    if (sz < 12)
        return 1;
    memcpy(&s, buf + (*off), sizeof(s));
    (*off) += sizeof(s);
    h->id = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (s); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(&s, buf + (*off), sizeof(s));
    (*off) += sizeof(s);
    t = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (s); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    h->qr = (t >> 15) & 0x01;
    h->opcode = (t >> 11) & 0x0F;
    h->aa = (t >> 10) & 0x01;
    h->tc = (t >> 9) & 0x01;
    h->rd = (t >> 8) & 0x01;
    h->ra = (t >> 7) & 0x01;
    /*
     * We might want to check that the reserved 'Z' bits (6-4) are
     * all zero as per RFC 1035.  If not the message should be
     * rejected.
     * NO! RFCs say ignore inbound reserved, they may be used in future.
     *  NEW messages need to be set 0, thats all.
     */
    h->rcode = t & 0x0F;
    memcpy(&s, buf + (*off), sizeof(s));
    (*off) += sizeof(s);
    h->qdcount = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (s); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(&s, buf + (*off), sizeof(s));
    (*off) += sizeof(s);
    h->ancount = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (s); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(&s, buf + (*off), sizeof(s));
    (*off) += sizeof(s);
    h->nscount = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (s); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(&s, buf + (*off), sizeof(s));
    (*off) += sizeof(s);
    h->arcount = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (s); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    (((*off) == 12) ? (void) (0) : __assert_fail ("(*off) == 12", "rfc1035.c", 253, __PRETTY_FUNCTION__));
    return 0;
}

# 272 "rfc1035.c"
static int
rfc1035NameUnpack(const char *buf, size_t sz, unsigned int *off, unsigned short *rdlength, char *name, size_t ns, int rdepth)
{
    unsigned int no = 0;
    unsigned char c;
    size_t len;
    ((ns > 0) ? (void) (0) : __assert_fail ("ns > 0", "rfc1035.c", 278, __PRETTY_FUNCTION__));
    do {
        if ((*off) >= sz) {
            (void)0;
            return 1;
        }
        c = *(buf + (*off));
        if (c > 191) {
            /* blasted compression */
            unsigned short s;
            unsigned int ptr;
            if (rdepth > 64) { /* infinite pointer loop */
                (void)0;
                return 1;
            }
            memcpy(&s, buf + (*off), sizeof(s));
            s = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (s); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
            (*off) += sizeof(s);
            /* Sanity check */
            if ((*off) > sz) {
                (void)0;
                return 1;
            }
            ptr = s & 0x3FFF;
            /* Make sure the pointer is inside this message */
            if (ptr >= sz) {
                (void)0;
                return 1;
            }
            return rfc1035NameUnpack(buf, sz, &ptr, rdlength, name + no, ns - no, rdepth + 1);
        } else if (c > 63) {
            /*
             * "(The 10 and 01 combinations are reserved for future use.)"
             */
            (void)0;
            return 1;
        } else {
            (*off)++;
            len = (size_t) c;
            if (len == 0)
                break;
            if (len > (ns - no - 1)) { /* label won't fit */
                (void)0;
                return 1;
            }
            if ((*off) + len >= sz) { /* message is too short */
                (void)0;
                return 1;
            }
            memcpy(name + no, buf + (*off), len);
            (*off) += len;
            no += len;
            *(name + (no++)) = '.';
            if (rdlength)
                *rdlength += len + 1;
        }
    } while (c > 0 && no < ns);
    if (no)
        *(name + no - 1) = '\0';
    else
        *name = '\0';
    /* make sure we didn't allow someone to overflow the name buffer */
    ((no <= ns) ? (void) (0) : __assert_fail ("no <= ns", "rfc1035.c", 340, __PRETTY_FUNCTION__));
    return 0;
}

# 354 "rfc1035.c"
int
rfc1035RRPack(char *buf, const size_t sz, const rfc1035_rr * RR)
{
    unsigned int off;
    uint16_t s;
    uint32_t i;

    off = rfc1035NamePack(buf, sz, RR->name);

    /*
     * Make sure the remaining message has enough octets for the
     * rest of the RR fields.
     */
    if ((off + sizeof(s)*3 + sizeof(i) + RR->rdlength) > sz) {
        return 0;
    }
    s = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (RR->type); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(buf + off, &s, sizeof(s));
    off += sizeof(s);
    s = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (RR->_class); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(buf + off, &s, sizeof(s));
    off += sizeof(s);
    i = __bswap_32 (RR->ttl);
    memcpy(buf + off, &i, sizeof(i));
    off += sizeof(i);
    s = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (RR->rdlength); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(buf + off, &s, sizeof(s));
    off += sizeof(s);
    memcpy(buf + off, &(RR->rdata), RR->rdlength);
    off += RR->rdlength;
    ((off <= sz) ? (void) (0) : __assert_fail ("off <= sz", "rfc1035.c", 384, __PRETTY_FUNCTION__));
    return off;
}

# 398 "rfc1035.c"
static int
rfc1035RRUnpack(const char *buf, size_t sz, unsigned int *off, rfc1035_rr * RR)
{
    unsigned short s;
    unsigned int i;
    unsigned short rdlength;
    unsigned int rdata_off;
    if (rfc1035NameUnpack(buf, sz, off, ((void *)0), RR->name, 256, 0)) {
        (void)0;
        memset(RR, '\0', sizeof(*RR));
        return 1;
    }
    /*
     * Make sure the remaining message has enough octets for the
     * rest of the RR fields.
     */
    if ((*off) + 10 > sz) {
        (void)0;
        memset(RR, '\0', sizeof(*RR));
        return 1;
    }
    memcpy(&s, buf + (*off), sizeof(s));
    (*off) += sizeof(s);
    RR->type = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (s); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(&s, buf + (*off), sizeof(s));
    (*off) += sizeof(s);
    RR->_class = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (s); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(&i, buf + (*off), sizeof(i));
    (*off) += sizeof(i);
    RR->ttl = __bswap_32 (i);
    memcpy(&s, buf + (*off), sizeof(s));
    (*off) += sizeof(s);
    rdlength = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (s); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    if ((*off) + rdlength > sz) {
        /*
         * We got a truncated packet.  'dnscache' truncates UDP
         * replies at 512 octets, as per RFC 1035.
         */
        (void)0;
        memset(RR, '\0', sizeof(*RR));
        return 1;
    }
    RR->rdlength = rdlength;
    switch (RR->type) {



    case 12:
        RR->rdata = (char*)xmalloc(256);
        rdata_off = *off;
        RR->rdlength = 0; /* Filled in by rfc1035NameUnpack */
        if (rfc1035NameUnpack(buf, sz, &rdata_off, &RR->rdlength, RR->rdata, 256, 0)) {
            (void)0;
            return 1;
        }
        if (rdata_off > ((*off) + rdlength)) {
            /*
             * This probably doesn't happen for valid packets, but
             * I want to make sure that NameUnpack doesn't go beyond
             * the RDATA area.
             */
            (void)0;
            xfree(RR->rdata);
            memset(RR, '\0', sizeof(*RR));
            return 1;
        }
        break;
    case 1:
    default:
        RR->rdata = (char*)xmalloc(rdlength);
        memcpy(RR->rdata, buf + (*off), rdlength);
        break;
    }
    (*off) += rdlength;
    (((*off) <= sz) ? (void) (0) : __assert_fail ("(*off) <= sz", "rfc1035.c", 472, __PRETTY_FUNCTION__));
    return 0;
}

# 539 "rfc1035.c"
static int
rfc1035QueryUnpack(const char *buf, size_t sz, unsigned int *off, rfc1035_query * query)
{
    unsigned short s;
    if (rfc1035NameUnpack(buf, sz, off, ((void *)0), query->name, 256, 0)) {
        (void)0;
        memset(query, '\0', sizeof(*query));
        return 1;
    }
    if (*off + 4 > sz) {
        (void)0;
        memset(query, '\0', sizeof(*query));
        return 1;
    }
    memcpy(&s, buf + *off, 2);
    *off += 2;
    query->qtype = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (s); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(&s, buf + *off, 2);
    *off += 2;
    query->qclass = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (s); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    return 0;
}

# 771 "rfc1035.c"
void
rfc1035SetQueryID(char *buf, unsigned short qid)
{
    unsigned short s = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (qid); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    memcpy(buf, &s, sizeof(s));
}

