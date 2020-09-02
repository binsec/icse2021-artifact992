void * __builtin___memcpy_chk (void *, const void *, unsigned int, unsigned int);
unsigned int __builtin_object_size (const void *, int);
void * __builtin___memset_chk (void *, int, unsigned int, unsigned int);

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 483 "/usr/include/stdlib.h"
extern void free (void *__ptr);

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

# 28 "/usr/include/i386-linux-gnu/bits/sockaddr.h"
typedef unsigned short int sa_family_t;

# 162 "/usr/include/i386-linux-gnu/bits/socket.h"
struct sockaddr_storage
  {
    sa_family_t ss_family; /* Address family, etc.  */
    unsigned long int __ss_align; /* Force desired alignment.  */
    char __ss_padding[(128 - (2 * sizeof (unsigned long int)))];
  };

# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 117 "/usr/include/netinet/in.h"
typedef uint16_t in_port_t;

# 209 "/usr/include/netinet/in.h"
struct in6_addr
  {
    union
      {
 uint8_t __u6_addr8[16];

 uint16_t __u6_addr16[8];
 uint32_t __u6_addr32[4];

      } __in6_u;





  };

# 252 "/usr/include/netinet/in.h"
struct sockaddr_in6
  {
    sa_family_t sin6_family;
    in_port_t sin6_port; /* Transport layer port # */
    uint32_t sin6_flowinfo; /* IPv6 flow information */
    struct in6_addr sin6_addr; /* IPv6 address */
    uint32_t sin6_scope_id; /* IPv6 scope-id */
  };

# 28 "rfc1035mxlist.h"
struct rfc1035_mxlist {
 struct rfc1035_mxlist *next;
 int protocol;

 struct sockaddr_storage address;



 int priority; /* -1 for plain old A records */
 char *hostname;
 };

# 28 "rfc1035mxlist.c"
static int addrecord(struct rfc1035_mxlist **list, const char *mxname,
 int mxpreference,


 struct in6_addr *in,



 int port
 )
{

struct sockaddr_in6 sin;



struct rfc1035_mxlist *p;

 if ((p=(struct rfc1035_mxlist *)malloc(sizeof(struct rfc1035_mxlist)))
  == 0 || (p->hostname=malloc(strlen(mxname)+1)) == 0)
 {
  if (p) free ( (char *)p);
  return (-1);
 }

 memset(&sin, 0, sizeof(sin));


 sin.sin6_family=10 /* IP version 6.  */;
 sin.sin6_addr= *in;
 sin.sin6_port=(__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 p->protocol=10 /* IP version 6.  */;







 while ( *list && (*list)->priority < mxpreference )
  list= &(*list)->next;

 p->next=*list;
 *list=p;
 p->priority=mxpreference;
 strcpy(p->hostname, mxname);
 memcpy(&p->address, &sin, sizeof(sin));
 return (0);
}

