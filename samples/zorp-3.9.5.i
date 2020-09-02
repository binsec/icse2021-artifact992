# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 40 "/usr/lib/i386-linux-gnu/glib-2.0/include/glibconfig.h"
typedef unsigned short guint16;

# 45 "/usr/lib/i386-linux-gnu/glib-2.0/include/glibconfig.h"
typedef unsigned int guint32;

# 46 "/usr/include/glib-2.0/glib/gtypes.h"
typedef char gchar;

# 49 "/usr/include/glib-2.0/glib/gtypes.h"
typedef int gint;

# 50 "/usr/include/glib-2.0/glib/gtypes.h"
typedef gint gboolean;

# 54 "/usr/include/glib-2.0/glib/gtypes.h"
typedef unsigned long gulong;

# 69 "/usr/include/glib-2.0/glib/giochannel.h"
typedef enum
{
  G_IO_STATUS_ERROR,
  G_IO_STATUS_NORMAL,
  G_IO_STATUS_EOF,
  G_IO_STATUS_AGAIN
} GIOStatus;

# 273 "/usr/include/glib-2.0/glib/gtestutils.h"
extern
void g_assertion_message_expr (const char *domain,
                                         const char *file,
                                         int line,
                                         const char *func,
                                         const char *expr);

# 152 "/usr/include/zorp/misc.h"
typedef struct _ZRefCount
{
  gint counter;
} ZRefCount;

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

# 44 "/usr/include/zorp/sockaddr.h"
typedef struct _ZSockAddrFuncs ZSockAddrFuncs;

# 51 "/usr/include/zorp/sockaddr.h"
typedef struct _ZSockAddr
{
  ZRefCount refcnt;
  guint32 flags;
  ZSockAddrFuncs *sa_funcs;
  int salen;
  struct sockaddr sa;
} ZSockAddr;

# 63 "/usr/include/zorp/sockaddr.h"
struct _ZSockAddrFuncs
{
  GIOStatus (*sa_bind_prepare) (int sock, ZSockAddr *self, guint32 sock_flags);
  GIOStatus (*sa_bind) (int sock, ZSockAddr *self, guint32 sock_flags);
  ZSockAddr *(*sa_clone) (ZSockAddr *self, gboolean wildcard_clone);
  gchar *(*sa_format) (ZSockAddr *self, /* format to text form */
       gchar *text,
       gulong n);
  void (*freefn) (ZSockAddr *self);
  gboolean (*sa_equal) (ZSockAddr *self, ZSockAddr *other);
};

# 96 "/usr/include/zorp/sockaddr.h"
static inline const struct sockaddr *
z_sockaddr_get_sa(ZSockAddr *self)
{
  return &self->sa;
}

# 104 "/usr/include/zorp/sockaddr.h"
gboolean z_sockaddr_inet_check(ZSockAddr *s);

# 106 "/usr/include/zorp/sockaddr.h"
static inline const struct sockaddr_in *
z_sockaddr_inet_get_sa(ZSockAddr *s)
{
  do { if (__builtin_expect (__extension__ ({ int _g_boolean_var_; if (z_sockaddr_inet_check(s)) _g_boolean_var_ = 1; else _g_boolean_var_ = 0; _g_boolean_var_; }), 1)) ; else g_assertion_message_expr (((gchar*) 0), "/usr/include/zorp/sockaddr.h", 109, ((const char*) (__func__)), "z_sockaddr_inet_check(s)"); } while (0);

  return (struct sockaddr_in *) z_sockaddr_get_sa(s);
}

# 114 "/usr/include/zorp/sockaddr.h"
gboolean z_sockaddr_inet6_check(ZSockAddr *s);

# 116 "/usr/include/zorp/sockaddr.h"
static inline const struct sockaddr_in6 *
z_sockaddr_inet6_get_sa(ZSockAddr *s)
{
  do { if (__builtin_expect (__extension__ ({ int _g_boolean_var_; if (z_sockaddr_inet6_check(s)) _g_boolean_var_ = 1; else _g_boolean_var_ = 0; _g_boolean_var_; }), 1)) ; else g_assertion_message_expr (((gchar*) 0), "/usr/include/zorp/sockaddr.h", 119, ((const char*) (__func__)), "z_sockaddr_inet6_check(s)"); } while (0);

  return (struct sockaddr_in6 *) z_sockaddr_get_sa(s);
}

# 176 "/usr/include/zorp/sockaddr.h"
static inline guint16
z_sockaddr_inet_get_port(ZSockAddr *s)
{
  do { if (__builtin_expect (__extension__ ({ int _g_boolean_var_; if (z_sockaddr_inet_check(s)) _g_boolean_var_ = 1; else _g_boolean_var_ = 0; _g_boolean_var_; }), 1)) ; else g_assertion_message_expr (((gchar*) 0), "/usr/include/zorp/sockaddr.h", 179, ((const char*) (__func__)), "z_sockaddr_inet_check(s)"); } while (0);

  return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (z_sockaddr_inet_get_sa(s)->sin_port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 191 "/usr/include/zorp/sockaddr.h"
static inline void
z_sockaddr_inet_set_port(ZSockAddr *s, guint16 port)
{
  do { if (__builtin_expect (__extension__ ({ int _g_boolean_var_; if (z_sockaddr_inet_check(s)) _g_boolean_var_ = 1; else _g_boolean_var_ = 0; _g_boolean_var_; }), 1)) ; else g_assertion_message_expr (((gchar*) 0), "/usr/include/zorp/sockaddr.h", 194, ((const char*) (__func__)), "z_sockaddr_inet_check(s)"); } while (0);

  ((struct sockaddr_in *) &s->sa)->sin_port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 207 "/usr/include/zorp/sockaddr.h"
static inline guint16
z_sockaddr_inet6_get_port(ZSockAddr *s)
{
  do { if (__builtin_expect (__extension__ ({ int _g_boolean_var_; if (z_sockaddr_inet6_check(s)) _g_boolean_var_ = 1; else _g_boolean_var_ = 0; _g_boolean_var_; }), 1)) ; else g_assertion_message_expr (((gchar*) 0), "/usr/include/zorp/sockaddr.h", 210, ((const char*) (__func__)), "z_sockaddr_inet6_check(s)"); } while (0);

  return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (z_sockaddr_inet6_get_sa(s)->sin6_port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 222 "/usr/include/zorp/sockaddr.h"
static inline void
z_sockaddr_inet6_set_port(ZSockAddr *s, guint16 port)
{
  do { if (__builtin_expect (__extension__ ({ int _g_boolean_var_; if (z_sockaddr_inet6_check(s)) _g_boolean_var_ = 1; else _g_boolean_var_ = 0; _g_boolean_var_; }), 1)) ; else g_assertion_message_expr (((gchar*) 0), "/usr/include/zorp/sockaddr.h", 225, ((const char*) (__func__)), "z_sockaddr_inet6_check(s)"); } while (0);

  ((struct sockaddr_in6 *) &s->sa)->sin6_port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

