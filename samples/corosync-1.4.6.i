void * __builtin___memcpy_chk (void *, const void *, unsigned int, unsigned int);
unsigned int __builtin_object_size (const void *, int);
void * __builtin___memset_chk (void *, int, unsigned int, unsigned int);

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

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
#define s6_addr __in6_u.__u6_addr8

#define s6_addr16 __in6_u.__u6_addr16
#define s6_addr32 __in6_u.__u6_addr32

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

# 61 "../include/corosync/totem/totemip.h"
struct totem_ip_address
{
 unsigned int nodeid;
 unsigned short family;
 unsigned char addr[(sizeof(struct in6_addr))];
};

# 241 "totemip.c"
int totemip_totemip_to_sockaddr_convert(struct totem_ip_address *ip_addr,
     uint16_t port, struct sockaddr_storage *saddr, int *addrlen)
{
 int ret = -1;

 if (ip_addr->family == 2 /* IP protocol family.  */) {
  struct sockaddr_in *sin = (struct sockaddr_in *)saddr;

  memset(sin, 0, sizeof(struct sockaddr_in));



  sin->sin_family = ip_addr->family;
  sin->sin_port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  memcpy(&sin->sin_addr, ip_addr->addr, sizeof(struct in_addr));
  *addrlen = sizeof(struct sockaddr_in);
  ret = 0;
 }

 if (ip_addr->family == 10 /* IP version 6.  */) {
  struct sockaddr_in6 *sin = (struct sockaddr_in6 *)saddr;

  memset(sin, 0, sizeof(struct sockaddr_in6));



  sin->sin6_family = ip_addr->family;
  sin->sin6_port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  sin->sin6_scope_id = 2;
  memcpy(&sin->sin6_addr, ip_addr->addr, sizeof(struct in6_addr));

  *addrlen = sizeof(struct sockaddr_in6);
  ret = 0;
 }

 return ret;
}

# 232 "crypto.c"
static inline unsigned long ROL(unsigned long word, int i)
{
   __asm__("roll %%cl,%0"
      :"=r" (word)
      :"0" (word),"c" (i));
   return word;
}

# 240 "crypto.c"
static inline unsigned long ROR(unsigned long word, int i)
{
   __asm__("rorl %%cl,%0"
      :"=r" (word)
      :"0" (word),"c" (i));
   return word;
}

