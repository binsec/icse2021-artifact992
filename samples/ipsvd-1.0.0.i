# 257 "/usr/include/netdb.h"
struct servent
{
  char *s_name; /* Official service name.  */
  char **s_aliases; /* Alias list.  */
  int s_port; /* Port number.  */
  char *s_proto; /* Protocol to use.  */
};

# 290 "/usr/include/netdb.h"
extern struct servent *getservbyname (const char *__name, const char *__proto);

# 12 "scan.h"
extern unsigned int scan_ulong(const char *,unsigned long *);

# 6 "ipsvd_scan.c"
unsigned int ipsvd_scan_port(const char *s, const char *proto,
                             unsigned long *p) {
  struct servent *se;

  if (! *s) return(0);
  if ((se =getservbyname(s, proto))) {
    /* what is se->s_port, uint16 or uint32? */
    *p =(__extension__ ({ unsigned short int __v, __x = (unsigned short int) (se->s_port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    return(1);
  }
  if (s[scan_ulong(s, p)]) return(0);
  return(1);
}

