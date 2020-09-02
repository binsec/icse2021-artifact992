# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 2131 "x_dnmalloc.c"
static int largebin_index(size_t sz) {

  unsigned long xx = sz >> 8;

  if (xx < 0x10000)
    {
      unsigned int m; /* bit position of highest set bit of m */

      /* On intel, use BSRL instruction to find highest bit */


      unsigned int x = (unsigned int) xx;

      __asm__("bsrl %1,%0\n\t"
       : "=r" (m)
       : "rm" (x));
# 2171 "x_dnmalloc.c"
      /* Use next 2 bits to create finer-granularity bins */
      return 32 + (m << 2) + ((sz >> (m + 6)) & 3);
    }
  else
    {
      return 96 -1;
    }
}

# 28 "/usr/include/i386-linux-gnu/bits/sockaddr.h"
typedef unsigned short int sa_family_t;

# 149 "/usr/include/i386-linux-gnu/bits/socket.h"
struct sockaddr
  {
    sa_family_t sa_family; /* Common data: address family and length.  */
    char sa_data[14]; /* Address data.  */
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

# 23 "./include/sh_ipvx.h"
struct sh_sockaddr {
  int ss_family;

  struct sockaddr_in sin;

  struct sockaddr_in6 sin6;

};

# 214 "x_sh_ipvx.c"
int sh_ipvx_set_port(struct sh_sockaddr * ss, int port)
{


  switch (ss->ss_family)
    {
    case 2 /* IP protocol family.  */:
      (ss->sin).sin_family = 2 /* IP protocol family.  */;
      (ss->sin).sin_port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
      break;
    case 10 /* IP version 6.  */:
      (ss->sin6).sin6_family = 10 /* IP version 6.  */;
      (ss->sin6).sin6_port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
      break;
    }
  return 0;





}

# 237 "x_sh_ipvx.c"
int sh_ipvx_get_port(struct sockaddr * sa, int sa_family)
{
  int port = 0;


  switch (sa_family)
    {
    case 2 /* IP protocol family.  */:
      port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (((struct sockaddr_in *)sa)->sin_port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
      break;
    case 10 /* IP version 6.  */:
      port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (((struct sockaddr_in6 *)sa)->sin6_port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
      break;
    }




  return port;
}

