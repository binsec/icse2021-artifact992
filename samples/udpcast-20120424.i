void * __builtin___memcpy_chk (void *, const void *, unsigned int, unsigned int);
unsigned int __builtin_object_size (const void *, int);
void * __builtin___memset_chk (void *, int, unsigned int, unsigned int);

# 172 "/usr/include/i386-linux-gnu/bits/types.h"
typedef int __ssize_t;

# 189 "/usr/include/i386-linux-gnu/bits/types.h"
typedef unsigned int __socklen_t;

# 109 "/usr/include/i386-linux-gnu/sys/types.h"
typedef __ssize_t ssize_t;

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 54 "/usr/include/i386-linux-gnu/sys/select.h"
typedef long int __fd_mask;

# 64 "/usr/include/i386-linux-gnu/sys/select.h"
typedef struct
  {
    /* XPG4.2 requires this member name.  Otherwise avoid the name
       from the global namespace.  */




    __fd_mask __fds_bits[1024 / (8 * (int) sizeof (__fd_mask))];


  } fd_set;

# 24 "/usr/include/i386-linux-gnu/bits/select2.h"
extern long int __fdelt_chk (long int __d);

# 25 "/usr/include/i386-linux-gnu/bits/select2.h"
extern long int __fdelt_warn (long int __d);

# 274 "/usr/include/unistd.h"
typedef __socklen_t socklen_t;

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

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 28 "/usr/include/i386-linux-gnu/bits/sockaddr.h"
typedef unsigned short int sa_family_t;

# 149 "/usr/include/i386-linux-gnu/bits/socket.h"
struct sockaddr
  {
    sa_family_t sa_family; /* Common data: address family and length.  */
    char sa_data[14]; /* Address data.  */
  };

# 47 "/usr/include/i386-linux-gnu/bits/socket2.h"
extern ssize_t __recvfrom_chk (int __fd, void *__restrict __buf, size_t __n,
          size_t __buflen, int __flags,
          struct sockaddr *__restrict __addr,
          socklen_t *__restrict __addr_len);

# 51 "/usr/include/i386-linux-gnu/bits/socket2.h"
extern ssize_t __recvfrom_alias (int __fd, void *__restrict __buf, size_t __n, int __flags, struct sockaddr *__restrict __addr, socklen_t *__restrict __addr_len) __asm__ ("" "recvfrom");

# 55 "/usr/include/i386-linux-gnu/bits/socket2.h"
extern ssize_t __recvfrom_chk_warn (int __fd, void *__restrict __buf, size_t __n, size_t __buflen, int __flags, struct sockaddr *__restrict __addr, socklen_t *__restrict __addr_len) __asm__ ("" "__recvfrom_chk");

# 63 "/usr/include/i386-linux-gnu/bits/socket2.h"
extern __inline ssize_t
recvfrom (int __fd, void *__restrict __buf, size_t __n, int __flags,
   struct sockaddr *__restrict __addr, socklen_t *__restrict __addr_len)
{
  if (__builtin_object_size (__buf, 0) != (size_t) -1)
    {
      if (!__builtin_constant_p (__n))
 return __recvfrom_chk (__fd, __buf, __n, __builtin_object_size (__buf, 0), __flags,
          __addr, __addr_len);
      if (__n > __builtin_object_size (__buf, 0))
 return __recvfrom_chk_warn (__fd, __buf, __n, __builtin_object_size (__buf, 0), __flags,
        __addr, __addr_len);
    }
  return __recvfrom_alias (__fd, __buf, __n, __flags, __addr, __addr_len);
}

# 30 "/usr/include/netinet/in.h"
typedef uint32_t in_addr_t;

# 31 "/usr/include/netinet/in.h"
struct in_addr
  {
    in_addr_t s_addr;
  };

# 117 "/usr/include/netinet/in.h"
typedef uint16_t in_port_t;

# 237 "/usr/include/netinet/in.h"
struct sockaddr_in
  {
    sa_family_t sin_family;
    in_port_t sin_port; /* Port number.  */
    struct in_addr sin_addr; /* Internet address.  */

    /* Pad to size of `struct sockaddr'.  */
    unsigned char sin_zero[sizeof (struct sockaddr) -
      (sizeof (unsigned short int)) -
      sizeof (in_port_t) -
      sizeof (struct in_addr)];
  };

# 100 "/usr/include/netdb.h"
struct hostent
{
  char *h_name; /* Official name of host.  */
  char **h_aliases; /* Alias list.  */
  int h_addrtype; /* Host address type.  */
  int h_length; /* Length of address.  */
  char **h_addr_list; /* List of addresses from name server.  */



};

# 144 "/usr/include/netdb.h"
extern struct hostent *gethostbyname (const char *__name);

# 17 "log.h"
int udpc_flprintf(const char *fmt, ...);

# 19 "log.h"
int udpc_fatal(int code, const char *fmt, ...);

# 110 "socklib.h"
struct net_if {
    struct in_addr addr;
    struct in_addr bcast;
    const char *name;

    int index;

};

# 118 "socklib.h"
typedef struct net_if net_if_t;

# 120 "socklib.h"
typedef enum addr_type_t {
  ADDR_TYPE_UCAST,
  ADDR_TYPE_MCAST,
  ADDR_TYPE_BCAST
} addr_type_t;

# 169 "socklib.h"
char *udpc_getIpString(struct sockaddr_in *addr, char *buffer);

# 174 "socklib.c"
int udpc_makeSockAddr(char *hostname, short port, struct sockaddr_in *addr)
{
    struct hostent *host;

    memset ((char *) addr, 0, sizeof(struct sockaddr_in));
    if (hostname && *hostname) {
 char *inaddr;
 int len;

 host = gethostbyname(hostname);
 if (host == ((void *)0)) {
     udpc_fatal(1, "Unknown host %s\n", hostname);
 }

 inaddr = host->h_addr_list[0];
 len = host->h_length;
 memcpy((void *)&((struct sockaddr_in *)addr)->sin_addr, inaddr, len);
    }

    ((struct sockaddr_in *)addr)->sin_family = 2 /* IP protocol family.  */;
    ((struct sockaddr_in *)addr)->sin_port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    return 0;
}

# 219 "socklib.c"
static int initSockAddress(addr_type_t addr_type,
      net_if_t *net_if,
      in_addr_t ip,
      unsigned short port,
      struct sockaddr_in *addr) {
    memset ((char *) addr, 0, sizeof(struct sockaddr_in));
    addr->sin_family = 2 /* IP protocol family.  */;
    addr->sin_port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

    if(!net_if && addr_type != ADDR_TYPE_MCAST)
 udpc_fatal(1, "initSockAddr without ifname\n");

    switch(addr_type) {
    case ADDR_TYPE_UCAST:
 addr->sin_addr = net_if->addr;
 break;
    case ADDR_TYPE_BCAST:
 addr->sin_addr = net_if->bcast;
 break;
    case ADDR_TYPE_MCAST:
 addr->sin_addr.s_addr = ip;
 break;
    }
    return 0;
}

# 296 "socklib.c"
int udpc_doReceive(int s, void *message, size_t len,
       struct sockaddr_in *from, int portBase) {
    socklen_t slen;
    int r;
    unsigned short port;
    char ipBuffer[16];

    slen = sizeof(*from);



    r = recvfrom(s, message, len, 0, (struct sockaddr *)from, &slen);
    if (r < 0)
 return r;
    port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (from->sin_port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    if(port != (portBase) && port != ((portBase)+1)) {
 udpc_flprintf("Bad message from port %s.%d\n",
        udpc_getIpString(from, ipBuffer),
        (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (((struct sockaddr_in *)from)->sin_port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
 return -1;
    }
/*    flprintf("recv: %08x %d\n", *(int*) message, r);*/
    return r;
}

# 981 "socklib.c"
unsigned short udpc_getPort(struct sockaddr_in *addr) {
    return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (((struct sockaddr_in *) addr)->sin_port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 985 "socklib.c"
void udpc_setPort(struct sockaddr_in *addr, unsigned short port) {
    ((struct sockaddr_in *) addr)->sin_port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 1074 "socklib.c"
int udpc_prepareForSelect(int *socks, int nr, fd_set *read_set) {
    int i;
    int maxFd;
    do { int __d0, __d1; __asm__ __volatile__ ("cld; rep; " "stosl" : "=c" (__d0), "=D" (__d1) : "a" (0), "0" (sizeof (fd_set) / sizeof (__fd_mask)), "1" (&((read_set)->__fds_bits)[0]) : "memory"); } while (0);
    maxFd=-1;
    for(i=0; i<nr; i++) {
 if(socks[i] == -1)
     continue;
 ((void) (((read_set)->__fds_bits)[__extension__ ({ long int __d = (socks[i]); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] |= ((__fd_mask) 1 << ((socks[i]) % (8 * (int) sizeof (__fd_mask))))));
 if(socks[i] > maxFd)
     maxFd = socks[i];
    }
    return maxFd;
}

# 104 "fec.c"
typedef unsigned char gf;

# 173 "fec.c"
static gf gf_mul_table[(((1 << 8 /* code over GF(2**GF_BITS) - change to suit */) - 1) /* powers of \alpha */ + 1)*(((1 << 8 /* code over GF(2**GF_BITS) - change to suit */) - 1) /* powers of \alpha */ + 1)];

# 300 "fec.c"
static void
slow_addmul1(gf *dst1, gf *src1, gf c, int sz)
{
    register gf * __gf_mulc_ ;
    register gf *dst = dst1, *src = src1 ;
    gf *lim = &dst[sz - 16 /* 1, 4, 8, 16 */ + 1] ;

    __gf_mulc_ = &gf_mul_table[(c)<<8] ;


    for (; dst < lim ; dst += 16 /* 1, 4, 8, 16 */, src += 16 /* 1, 4, 8, 16 */ ) {
 dst[0] ^= __gf_mulc_[src[0]];
 dst[1] ^= __gf_mulc_[src[1]];
 dst[2] ^= __gf_mulc_[src[2]];
 dst[3] ^= __gf_mulc_[src[3]];

 dst[4] ^= __gf_mulc_[src[4]];
 dst[5] ^= __gf_mulc_[src[5]];
 dst[6] ^= __gf_mulc_[src[6]];
 dst[7] ^= __gf_mulc_[src[7]];


 dst[8] ^= __gf_mulc_[src[8]];
 dst[9] ^= __gf_mulc_[src[9]];
 dst[10] ^= __gf_mulc_[src[10]];
 dst[11] ^= __gf_mulc_[src[11]];
 dst[12] ^= __gf_mulc_[src[12]];
 dst[13] ^= __gf_mulc_[src[13]];
 dst[14] ^= __gf_mulc_[src[14]];
 dst[15] ^= __gf_mulc_[src[15]];

    }

    lim += 16 /* 1, 4, 8, 16 */ - 1 ;
    for (; dst < lim; dst++, src++ ) /* final components */
 *dst ^= __gf_mulc_[*src];
}

# 342 "fec.c"
static void
addmul1(gf *dst1, gf *src1, gf c, int sz)
{
    register gf * __gf_mulc_ ;

    __gf_mulc_ = &gf_mul_table[(c)<<8] ;

    if(((unsigned long)dst1 % 8) ||
       ((unsigned long)src1 % 8) ||
       (sz % 8)) {
 slow_addmul1(dst1, src1, c, sz);
 return;
    }

    asm volatile("xorl %%eax,%%eax;\n"
   "	xorl %%edx,%%edx;\n"
   ".align 32;\n"
   "1:"
   "	addl  $8, %%edi;\n"

   "	movb  (%%esi), %%al;\n"
   "	movb 4(%%esi), %%dl;\n"
   "	movb  (%%ebx,%%eax), %%al;\n"
   "	movb  (%%ebx,%%edx), %%dl;\n"
   "	xorb  %%al,  (%%edi);\n"
   "	xorb  %%dl, 4(%%edi);\n"

   "	movb 1(%%esi), %%al;\n"
   "	movb 5(%%esi), %%dl;\n"
   "	movb  (%%ebx,%%eax), %%al;\n"
   "	movb  (%%ebx,%%edx), %%dl;\n"
   "	xorb  %%al, 1(%%edi);\n"
   "	xorb  %%dl, 5(%%edi);\n"

   "	movb 2(%%esi), %%al;\n"
   "	movb 6(%%esi), %%dl;\n"
   "	movb  (%%ebx,%%eax), %%al;\n"
   "	movb  (%%ebx,%%edx), %%dl;\n"
   "	xorb  %%al, 2(%%edi);\n"
   "	xorb  %%dl, 6(%%edi);\n"

   "	movb 3(%%esi), %%al;\n"
   "	movb 7(%%esi), %%dl;\n"
   "	addl  $8, %%esi;\n"
   "	movb  (%%ebx,%%eax), %%al;\n"
   "	movb  (%%ebx,%%edx), %%dl;\n"
   "	xorb  %%al, 3(%%edi);\n"
   "	xorb  %%dl, 7(%%edi);\n"

   "	cmpl  %%ecx, %%esi;\n"
   "	jb 1b;"
   : :

   "b" (__gf_mulc_),
   "D" (dst1-8),
   "S" (src1),
   "c" (sz+src1) :
   "memory", "eax", "edx"
 );
}

# 426 "fec.c"
static void
slow_mul1(gf *dst1, gf *src1, gf c, int sz)
{
    register gf * __gf_mulc_ ;
    register gf *dst = dst1, *src = src1 ;
    gf *lim = &dst[sz - 16 /* 1, 4, 8, 16 */ + 1] ;

    __gf_mulc_ = &gf_mul_table[(c)<<8] ;


    for (; dst < lim ; dst += 16 /* 1, 4, 8, 16 */, src += 16 /* 1, 4, 8, 16 */ ) {
 dst[0] = __gf_mulc_[src[0]];
 dst[1] = __gf_mulc_[src[1]];
 dst[2] = __gf_mulc_[src[2]];
 dst[3] = __gf_mulc_[src[3]];

 dst[4] = __gf_mulc_[src[4]];
 dst[5] = __gf_mulc_[src[5]];
 dst[6] = __gf_mulc_[src[6]];
 dst[7] = __gf_mulc_[src[7]];


 dst[8] = __gf_mulc_[src[8]];
 dst[9] = __gf_mulc_[src[9]];
 dst[10] = __gf_mulc_[src[10]];
 dst[11] = __gf_mulc_[src[11]];
 dst[12] = __gf_mulc_[src[12]];
 dst[13] = __gf_mulc_[src[13]];
 dst[14] = __gf_mulc_[src[14]];
 dst[15] = __gf_mulc_[src[15]];

    }

    lim += 16 /* 1, 4, 8, 16 */ - 1 ;
    for (; dst < lim; dst++, src++ ) /* final components */
 *dst = __gf_mulc_[*src];
}

# 465 "fec.c"
static void
mul1(gf *dst1, gf *src1, gf c, int sz)
{
    register gf * __gf_mulc_ ;

    __gf_mulc_ = &gf_mul_table[(c)<<8] ;

    if(((unsigned long)dst1 % 8) ||
       ((unsigned long)src1 % 8) ||
       (sz % 8)) {
 slow_mul1(dst1, src1, c, sz);
 return;
    }

    asm volatile("pushl %%eax;\n"
   "pushl %%edx;\n"
   "xorl %%eax,%%eax;\n"
   "	xorl %%edx,%%edx;\n"
   "1:"
   "	addl  $8, %%edi;\n"

   "	movb  (%%esi), %%al;\n"
   "	movb 4(%%esi), %%dl;\n"
   "	movb  (%%ebx,%%eax), %%al;\n"
   "	movb  (%%ebx,%%edx), %%dl;\n"
   "	movb  %%al,  (%%edi);\n"
   "	movb  %%dl, 4(%%edi);\n"

   "	movb 1(%%esi), %%al;\n"
   "	movb 5(%%esi), %%dl;\n"
   "	movb  (%%ebx,%%eax), %%al;\n"
   "	movb  (%%ebx,%%edx), %%dl;\n"
   "	movb  %%al, 1(%%edi);\n"
   "	movb  %%dl, 5(%%edi);\n"

   "	movb 2(%%esi), %%al;\n"
   "	movb 6(%%esi), %%dl;\n"
   "	movb  (%%ebx,%%eax), %%al;\n"
   "	movb  (%%ebx,%%edx), %%dl;\n"
   "	movb  %%al, 2(%%edi);\n"
   "	movb  %%dl, 6(%%edi);\n"

   "	movb 3(%%esi), %%al;\n"
   "	movb 7(%%esi), %%dl;\n"
   "	addl  $8, %%esi;\n"
   "	movb  (%%ebx,%%eax), %%al;\n"
   "	movb  (%%ebx,%%edx), %%dl;\n"
   "	movb  %%al, 3(%%edi);\n"
   "	movb  %%dl, 7(%%edi);\n"

   "	cmpl  %%ecx, %%esi;\n"
   "	jb 1b;\n"
   "	popl %%edx;\n"
   "	popl %%eax;"
   : :

   "b" (__gf_mulc_),
   "D" (dst1-8),
   "S" (src1),
   "c" (sz+src1) :
   "memory", "eax", "edx"
 );
}

