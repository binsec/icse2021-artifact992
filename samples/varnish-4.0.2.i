# 50 "/usr/include/i386-linux-gnu/bits/errno.h"
extern int *__errno_location (void);

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

# 41 "../../include/vas.h"
enum vas_e {
 VAS_WRONG,
 VAS_MISSING,
 VAS_ASSERT,
 VAS_INCOMPLETE,
 VAS_VCL,
};

# 49 "../../include/vas.h"
typedef void vas_f(const char *, const char *, int, const char *, int,
    enum vas_e);

# 52 "../../include/vas.h"
extern vas_f *VAS_Fail;

# 165 "../../lib/libvarnish/vsa.c"
struct suckaddr {
 unsigned magic;

 union {
  struct sockaddr sa;
  struct sockaddr_in sa4;
  struct sockaddr_in6 sa6;
 };
};

# 326 "../../lib/libvarnish/vsa.c"
unsigned
VSA_Port(const struct suckaddr *sua)
{

 do { do { if (!((sua) != ((void *)0))) { VAS_Fail(__func__, "../../lib/libvarnish/vsa.c", 330, "(sua) != NULL", (*__errno_location ()), VAS_ASSERT); } } while (0); do { if (!((sua)->magic == 0x4b1e9335)) { VAS_Fail(__func__, "../../lib/libvarnish/vsa.c", 330, "(sua)->magic == 0x4b1e9335", (*__errno_location ()), VAS_ASSERT); } } while (0); } while (0);
 switch(sua->sa.sa_family) {
  case 2 /* IP protocol family.  */:
   return ((__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sua->sa4.sin_port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
  case 10 /* IP version 6.  */:
   return ((__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sua->sa6.sin6_port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
  default:
   return (0);
 }
}

