# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 2387 "sysinfo.c"
static void Xen_Cpuid(uint32_t idx, uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx)
{
    asm(
           /* %ebx register need to be saved before usage and restored thereafter
            * for PIC-compliant code on i386 */

           "push %%ebx; cpuid; mov %%ebx,%1; pop %%ebx"



  : "=a"(*eax), "=r"(*ebx), "=c"(*ecx), "=d"(*edx):"0"(idx), "2"(0));
}

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 28 "/usr/include/i386-linux-gnu/bits/sockaddr.h"
typedef unsigned short int sa_family_t;

# 149 "/usr/include/i386-linux-gnu/bits/socket.h"
struct sockaddr
  {
    sa_family_t sa_family; /* Common data: address family and length.  */
    char sa_data[14]; /* Address data.  */
  };

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

# 61 "../libutils/misc_lib.h"
void __ProgrammingError(const char *file, int lineno, const char *format, ...);

# 66 "misc.c"
uint16_t sockaddr_port(const void *sa)
{
    int family = ((struct sockaddr *) sa)->sa_family;
    uint16_t port;

    switch (family)
    {
    case 2 /* IP protocol family.  */:
        port = ((struct sockaddr_in *) sa)->sin_port;
        break;







    default:
        __ProgrammingError("misc.c", 84, "sockaddr_port: address family was %d", family);
    }

    return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

