# 189 "/usr/include/i386-linux-gnu/bits/types.h"
typedef unsigned int __socklen_t;

# 274 "/usr/include/unistd.h"
typedef __socklen_t socklen_t;

# 28 "/usr/include/i386-linux-gnu/bits/sockaddr.h"
typedef unsigned short int sa_family_t;

# 149 "/usr/include/i386-linux-gnu/bits/socket.h"
struct sockaddr
  {
    sa_family_t sa_family; /* Common data: address family and length.  */
    char sa_data[14]; /* Address data.  */
  };

# 127 "/usr/include/i386-linux-gnu/sys/socket.h"
extern int getsockname (int __fd, struct sockaddr *__restrict __addr,
   socklen_t *__restrict __len);

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

# 34 "ssh/dmtcp_ssh.cpp"
static int getport(int fd)
{
  struct sockaddr_in addr;
  socklen_t addrlen = sizeof(addr);
  if (getsockname(fd, (struct sockaddr *)&addr, &addrlen) == -1) {
    return -1;
  }
  return (int)(__extension__ ({ unsigned short int __v, __x = (unsigned short int) (addr.sin_port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

/*@ rustina_out_of_scope */
# 97 "threadlist.cpp"
static void save_sp(void **sp)
{

  asm volatile ("mov %%esp,%0"
  : "=g" (*sp)
                : : "memory");







}
