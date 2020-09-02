# 264 "ebtree/ebtree.h"
static inline int flsnz(int x)
{
 int r;
 __asm__("bsrl %1,%0\n"
         : "=r" (r) : "rm" (x));
 return r+1;
}

# 272 "ebtree/ebtree.h"
static inline int flsnz8(unsigned char x)
{
 int r;
 __asm__("movzbl %%al, %%eax\n"
  "bsrl %%eax,%0\n"
         : "=r" (r) : "a" (x));
 return r+1;
}

# 28 "/usr/include/i386-linux-gnu/bits/sockaddr.h"
typedef unsigned short int sa_family_t;

# 149 "/usr/include/i386-linux-gnu/bits/socket.h"
struct sockaddr
  {
    sa_family_t sa_family; /* Common data: address family and length.  */
    char sa_data[14]; /* Address data.  */
  };

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

# 30 "/usr/include/netinet/in.h"
typedef uint32_t in_addr_t;

# 31 "/usr/include/netinet/in.h"
struct in_addr
  {
    in_addr_t s_addr;
  };

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

# 252 "/usr/include/netinet/in.h"
struct sockaddr_in6
  {
    sa_family_t sin6_family;
    in_port_t sin6_port; /* Transport layer port # */
    uint32_t sin6_flowinfo; /* IPv6 flow information */
    struct in6_addr sin6_addr; /* IPv6 address */
    uint32_t sin6_scope_id; /* IPv6 scope-id */
  };

# 555 "include/common/standard.h"
static inline unsigned int div64_32(unsigned long long o1, unsigned int o2)
{
 unsigned int result;

 asm("divl %2"
     : "=a" (result)
     : "A"(o1), "rm"(o2));



 return result;
}

# 704 "include/common/standard.h"
static inline int get_host_port(struct sockaddr_storage *addr)
{
 switch (addr->ss_family) {
 case 2 /* IP protocol family.  */:
  return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (((struct sockaddr_in *)addr)->sin_port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 case 10 /* IP version 6.  */:
  return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (((struct sockaddr_in6 *)addr)->sin6_port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 }
 return 0;
}

# 742 "include/common/standard.h"
static inline int set_host_port(struct sockaddr_storage *addr, int port)
{
 switch (addr->ss_family) {
 case 2 /* IP protocol family.  */:
  ((struct sockaddr_in *)addr)->sin_port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 case 10 /* IP version 6.  */:
  ((struct sockaddr_in6 *)addr)->sin6_port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 }
 return 0;
}

