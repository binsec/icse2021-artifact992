void * __builtin___memcpy_chk (void *, const void *, unsigned int, unsigned int);
unsigned int __builtin_object_size (const void *, int);
void * __builtin___memset_chk (void *, int, unsigned int, unsigned int);

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

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

# 34 "/usr/include/arpa/inet.h"
extern in_addr_t inet_addr (const char *__cp);

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

# 140 "nsocket.c"
static int
CreateSocketAddress(struct sockaddr_in *sockaddrPtr, char *host, int port)
                                     /* Socket address */
                   /* Host.  NULL implies INADDR_ANY */
                 /* Port number */
{
    struct hostent *hostent; /* Host database entry */
    struct in_addr addr; /* For 64/32 bit madness */

    (void) memset((void *) sockaddrPtr, '\0', sizeof(struct sockaddr_in));
    sockaddrPtr->sin_family = 2 /* IP protocol family.  */;
    sockaddrPtr->sin_port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((unsigned short) (port & 0xFFFF)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    if (host == ((void *)0)) {
 addr.s_addr = ((in_addr_t) 0x00000000);
    } else {
        addr.s_addr = inet_addr(host);
        if (addr.s_addr == -1) {
            hostent = /* gethostbyname(host); */



     gethostbyname(host);

            if (hostent != ((void *)0)) {
                memcpy((void *) &addr,
                        (void *) hostent->h_addr_list[0],
                        (size_t) hostent->h_length);
            } else {

                (*__errno_location ()) = 113 /* No route to host */;





                return 0; /* error */
            }
        }
    }

    /*
     * NOTE: On 64 bit machines the assignment below is rumored to not
     * do the right thing. Please report errors related to this if you
     * observe incorrect behavior on 64 bit machines such as DEC Alphas.
     * Should we modify this code to do an explicit memcpy?
     */

    sockaddrPtr->sin_addr.s_addr = addr.s_addr;
    return 1; /* Success. */
}

