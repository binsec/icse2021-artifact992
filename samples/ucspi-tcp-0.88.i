;

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

# 8 "sig.h"
extern int sig_pipe;

# 11 "sig.h"
extern void (*sig_defaulthandler)();

# 12 "sig.h"
extern void (*sig_ignorehandler)();

# 14 "sig.h"
extern void sig_catch(int,void (*)());

# 17 "subgetopt.h"
extern char *subgetoptarg;

# 18 "subgetopt.h"
extern int subgetoptind;

# 22 "subgetopt.h"
extern int subgetoptdone;

# 17 "sgetopt.h"
extern int sgetoptmine(int,char **,char *);

# 4 "uint16.h"
typedef unsigned short uint16;

# 14 "fmt.h"
extern unsigned int fmt_ulong(char *,unsigned long);

# 10 "scan.h"
extern unsigned int scan_ulong(char *,unsigned long *);

# 5 "str.h"
extern int str_diff(char *,char *);

# 4 "ip4.h"
extern unsigned int ip4_scan(char *,char *);

# 5 "ip4.h"
extern unsigned int ip4_fmt(char *,char *);

# 6 "socket.h"
extern int socket_tcp(void);

# 11 "socket.h"
extern int socket_bind4(int,char *,uint16);

# 17 "socket.h"
extern int socket_local4(int,char *,uint16 *);

# 18 "socket.h"
extern int socket_remote4(int,char *,uint16 *);

# 4 "fd.h"
extern int fd_copy(int,int);

# 5 "fd.h"
extern int fd_move(int,int);

# 6 "stralloc.h"
typedef struct stralloc { char *s; unsigned int len; unsigned int a; } stralloc;

# 10 "stralloc.h"
extern int stralloc_copy(stralloc *,stralloc *);

# 12 "stralloc.h"
extern int stralloc_copys(stralloc *,char *);

# 15 "stralloc.h"
extern int stralloc_catb(stralloc *,char *,unsigned int);

# 16 "stralloc.h"
extern int stralloc_append(stralloc *,char *);

# 4 "buffer.h"
typedef struct buffer {
  char *x;
  unsigned int p;
  unsigned int n;
  int fd;
  int (*op)();
} buffer;

# 54 "buffer.h"
extern buffer *buffer_2;

# 50 "/usr/include/i386-linux-gnu/bits/errno.h"
extern int *__errno_location (void);

# 12 "error.h"
extern int error_timeout;

# 4 "strerr.h"
struct strerr {
  struct strerr *who;
  char *x;
  char *y;
  char *z;
};

# 11 "strerr.h"
extern struct strerr strerr_sys;

# 15 "strerr.h"
extern void strerr_warn(char *,char *,char *,char *,char *,char *,struct strerr *);

# 16 "strerr.h"
extern void strerr_die(int,char *,char *,char *,char *,char *,char *,struct strerr *);

# 5 "pathexec.h"
extern int pathexec_env(char *,char *);

# 6 "pathexec.h"
extern void pathexec(char **);

# 6 "timeoutconn.h"
extern int timeoutconn(int,char *,uint16,unsigned int);

# 7 "remoteinfo.h"
extern int remoteinfo(stralloc *,char *,uint16,char *,uint16,unsigned int);

# 42 "dns.h"
extern void dns_random_init(char *);

# 74 "dns.h"
extern int dns_name4(stralloc *,char *);

# 82 "dns.h"
extern int dns_ip4_qualify(stralloc *,stralloc *,stralloc *);

# 27 "tcpclient.c"
void nomem(void)
{
  strerr_die((111),("tcpclient: fatal: "),("out of memory"),0,0,0,0,0);
}

# 31 "tcpclient.c"
void usage(void)
{
  strerr_die((100),("tcpclient: usage: tcpclient [ -hHrRdDqQv ] [ -i localip ] [ -p localport ] [ -T timeoutconn ] [ -l localname ] [ -t timeoutinfo ] host port program"),0,0,0,0,0,0)






                   ;
}

# 43 "tcpclient.c"
int verbosity = 1;

# 44 "tcpclient.c"
int flagdelay = 1;

# 45 "tcpclient.c"
int flagremoteinfo = 1;

# 46 "tcpclient.c"
int flagremotehost = 1;

# 47 "tcpclient.c"
unsigned long itimeout = 26;

# 48 "tcpclient.c"
unsigned long ctimeout[2] = { 2, 58 };

# 50 "tcpclient.c"
char iplocal[4] = { 0,0,0,0 };

# 51 "tcpclient.c"
uint16 portlocal = 0;

# 52 "tcpclient.c"
char *forcelocal = 0;

# 54 "tcpclient.c"
char ipremote[4];

# 55 "tcpclient.c"
uint16 portremote;

# 57 "tcpclient.c"
char *hostname;

# 58 "tcpclient.c"
static stralloc addresses;

# 59 "tcpclient.c"
static stralloc moreaddresses;

# 61 "tcpclient.c"
static stralloc tmp;

# 62 "tcpclient.c"
static stralloc fqdn;

# 63 "tcpclient.c"
char strnum[40 /* enough space to hold 2^128 - 1 in decimal, plus \0 */];

# 64 "tcpclient.c"
char ipstr[20];

# 66 "tcpclient.c"
char seed[128];

# 68 "tcpclient.c"
main(int argc,char **argv)
{
  unsigned long u;
  int opt;
  char *x;
  int j;
  int s;
  int cloop;

  dns_random_init(seed);

  close(6);
  close(7);
  (sig_catch((sig_pipe),sig_ignorehandler));

  while ((opt = sgetoptmine(argc,argv,"dDvqQhHrRi:p:t:T:l:")) != subgetoptdone)
    switch(opt) {
      case 'd': flagdelay = 1; break;
      case 'D': flagdelay = 0; break;
      case 'v': verbosity = 2; break;
      case 'q': verbosity = 0; break;
      case 'Q': verbosity = 1; break;
      case 'l': forcelocal = subgetoptarg; break;
      case 'H': flagremotehost = 0; break;
      case 'h': flagremotehost = 1; break;
      case 'R': flagremoteinfo = 0; break;
      case 'r': flagremoteinfo = 1; break;
      case 't': scan_ulong(subgetoptarg,&itimeout); break;
      case 'T': j = scan_ulong(subgetoptarg,&ctimeout[0]);
  if (subgetoptarg[j] == '+') ++j;
  scan_ulong(subgetoptarg + j,&ctimeout[1]);
  break;
      case 'i': if (!ip4_scan(subgetoptarg,iplocal)) usage(); break;
      case 'p': scan_ulong(subgetoptarg,&u); portlocal = u; break;
      default: usage();
    }
  argv += subgetoptind;

  if (!verbosity)
    buffer_2->fd = -1;

  hostname = *argv;
  if (!hostname) usage();
  if ((!str_diff((hostname),("")))) hostname = "127.0.0.1";
  if ((!str_diff((hostname),("0")))) hostname = "127.0.0.1";

  x = *++argv;
  if (!x) usage();
  if (!x[scan_ulong(x,&u)])
    portremote = u;
  else {
    struct servent *se;
    se = getservbyname(x,"tcp");
    if (!se)
      strerr_die((111),("tcpclient: fatal: "),("unable to figure out port number for "),(x),0,0,0,0);
    portremote = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (se->s_port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    /* i continue to be amazed at the stupidity of the s_port interface */
  }

  if (!*++argv) usage();

  if (!stralloc_copys(&tmp,hostname)) nomem();
  if (dns_ip4_qualify(&addresses,&fqdn,&tmp) == -1)
    strerr_die((111),("tcpclient: fatal: "),("temporarily unable to figure out IP address for "),(hostname),(": "),0,0,&strerr_sys);
  if (addresses.len < 4)
    strerr_die((111),("tcpclient: fatal: "),("no IP address for "),(hostname),0,0,0,0);

  if (addresses.len == 4) {
    ctimeout[0] += ctimeout[1];
    ctimeout[1] = 0;
  }

  for (cloop = 0;cloop < 2;++cloop) {
    if (!stralloc_copys(&moreaddresses,"")) nomem();
    for (j = 0;j + 4 <= addresses.len;j += 4) {
      s = socket_tcp();
      if (s == -1)
        strerr_die((111),("tcpclient: fatal: "),("unable to create socket: "),0,0,0,0,&strerr_sys);
      if (socket_bind4(s,iplocal,portlocal) == -1)
        strerr_die((111),("tcpclient: fatal: "),("unable to bind socket: "),0,0,0,0,&strerr_sys);
      if (timeoutconn(s,addresses.s + j,portremote,ctimeout[cloop]) == 0)
        goto CONNECTED;
      close(s);
      if (!cloop && ctimeout[1] && ((*__errno_location ()) == error_timeout)) {
 if (!stralloc_catb(&moreaddresses,addresses.s + j,4)) nomem();
      }
      else {
        strnum[fmt_ulong(strnum,portremote)] = 0;
        ipstr[ip4_fmt(ipstr,addresses.s + j)] = 0;
        strerr_warn(("tcpclient: unable to connect to "),(ipstr),(" port "),(strnum),(": "),0,(&strerr_sys));
      }
    }
    if (!stralloc_copy(&addresses,&moreaddresses)) nomem();
  }

  _exit(111);



  CONNECTED:

  if (!flagdelay)
    socket_tcpnodelay(s); /* if it fails, bummer */

  if (!pathexec_env("PROTO","TCP")) nomem();

  if (socket_local4(s,iplocal,&portlocal) == -1)
    strerr_die((111),("tcpclient: fatal: "),("unable to get local address: "),0,0,0,0,&strerr_sys);

  strnum[fmt_ulong(strnum,portlocal)] = 0;
  if (!pathexec_env("TCPLOCALPORT",strnum)) nomem();
  ipstr[ip4_fmt(ipstr,iplocal)] = 0;
  if (!pathexec_env("TCPLOCALIP",ipstr)) nomem();

  x = forcelocal;
  if (!x)
    if (dns_name4(&tmp,iplocal) == 0) {
      if (!stralloc_append(&tmp,"")) nomem();
      x = tmp.s;
    }
  if (!pathexec_env("TCPLOCALHOST",x)) nomem();

  if (socket_remote4(s,ipremote,&portremote) == -1)
    strerr_die((111),("tcpclient: fatal: "),("unable to get remote address: "),0,0,0,0,&strerr_sys);

  strnum[fmt_ulong(strnum,portremote)] = 0;
  if (!pathexec_env("TCPREMOTEPORT",strnum)) nomem();
  ipstr[ip4_fmt(ipstr,ipremote)] = 0;
  if (!pathexec_env("TCPREMOTEIP",ipstr)) nomem();
  if (verbosity >= 2)
    strerr_warn(("tcpclient: connected to "),(ipstr),(" port "),(strnum),0,0,(0));

  x = 0;
  if (flagremotehost)
    if (dns_name4(&tmp,ipremote) == 0) {
      if (!stralloc_append(&tmp,"")) nomem();
      x = tmp.s;
    }
  if (!pathexec_env("TCPREMOTEHOST",x)) nomem();

  x = 0;
  if (flagremoteinfo)
    if (remoteinfo(&tmp,ipremote,portremote,iplocal,portlocal,itimeout) == 0) {
      if (!stralloc_append(&tmp,"")) nomem();
      x = tmp.s;
    }
  if (!pathexec_env("TCPREMOTEINFO",x)) nomem();

  if (fd_move(6,s) == -1)
    strerr_die((111),("tcpclient: fatal: "),("unable to set up descriptor 6: "),0,0,0,0,&strerr_sys);
  if (fd_copy(7,6) == -1)
    strerr_die((111),("tcpclient: fatal: "),("unable to set up descriptor 7: "),0,0,0,0,&strerr_sys);
  (sig_catch((sig_pipe),sig_defaulthandler));

  pathexec(argv);
  strerr_die((111),("tcpclient: fatal: "),("unable to run "),(*argv),(": "),0,0,&strerr_sys);
}

