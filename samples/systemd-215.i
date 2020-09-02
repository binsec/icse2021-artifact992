unsigned int __builtin_object_size (const void *, int);
void * __builtin___memset_chk (void *, int, unsigned int, unsigned int);

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 36 "../src/shared/sparse-endian.h"
typedef uint16_t be16_t;

# 75 "../src/shared/sparse-endian.h"
static inline be16_t htobe16(uint16_t value) { return (be16_t ) (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (value); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); }

# 83 "../src/shared/sparse-endian.h"
static inline uint16_t be16toh(be16_t value) { return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((uint16_t )value); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); }

# 26 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned int __u32;

# 30 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned long long __u64;

# 7 "/usr/include/i386-linux-gnu/asm/swab.h"
static __inline__ __u32 __arch_swab32(__u32 val)
{
 __asm__("bswapl %0" : "=r" (val) : "0" (val));
 return val;
}

# 14 "/usr/include/i386-linux-gnu/asm/swab.h"
static __inline__ __u64 __arch_swab64(__u64 val)
{

 union {
  struct {
   __u32 a;
   __u32 b;
  } s;
  __u64 u;
 } v;
 v.u = val;
 __asm__("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
     : "=r" (v.s.a), "=r" (v.s.b)
     : "0" (v.s.a), "1" (v.s.b));
 return v.u;




}

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 200 "/usr/include/i386-linux-gnu/sys/types.h"
typedef unsigned int u_int8_t;

# 22 "/usr/include/i386-linux-gnu/bits/string3.h"
extern void __warn_memset_zero_len (void);

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

# 76 "../src/shared/log.h"
int log_meta(
                int level,
                const char*file,
                int line,
                const char *func,
                const char *format, ...);

# 130 "../src/shared/log.h"
void log_assert_failed(
                const char *text,
                const char *file,
                int line,
                const char *func);

# 54 "/usr/include/net/if_arp.h"
struct arphdr
  {
    unsigned short int ar_hrd; /* Format of hardware address.  */
    unsigned short int ar_pro; /* Format of protocol address.  */
    unsigned char ar_hln; /* Length of hardware address.  */
    unsigned char ar_pln; /* Length of protocol address.  */
    unsigned short int ar_op; /* ARP opcode (command).  */
# 69 "/usr/include/net/if_arp.h" 3 4
  };

# 71 "/usr/include/netinet/if_ether.h"
struct ether_arp {
 struct arphdr ea_hdr; /* fixed-size header */
 u_int8_t arp_sha[6 /* Octets in one ethernet addr	 */]; /* sender hardware address */
 u_int8_t arp_spa[4]; /* sender protocol address */
 u_int8_t arp_tha[6 /* Octets in one ethernet addr	 */]; /* target hardware address */
 u_int8_t arp_tpa[4]; /* target protocol address */
};

# 24 "../src/libsystemd-network/ipv4ll-packet.c"
void arp_packet_init(struct ether_arp *arp) {
        do { if ((__builtin_expect(!!(!(arp)),0))) log_assert_failed("arp", "../src/libsystemd-network/ipv4ll-packet.c", 25, __PRETTY_FUNCTION__); } while (0);

        (memset((arp), 0, (sizeof(struct ether_arp))));
        /* Header */
        arp->ea_hdr.ar_hrd = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (1 /* Ethernet 10/100Mbps.  */); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); /* HTYPE */
        arp->ea_hdr.ar_pro = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (0x0800 /* IP */); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); /* PTYPE */
        arp->ea_hdr.ar_hln = 6 /* Octets in one ethernet addr	 */; /* HLEN */
        arp->ea_hdr.ar_pln = sizeof arp->arp_spa; /* PLEN */
        arp->ea_hdr.ar_op = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (1 /* ARP request.  */); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); /* REQUEST */
}

# 53 "../src/libsystemd-network/ipv4ll-packet.c"
int arp_packet_verify_headers(struct ether_arp *arp) {
        do { if ((__builtin_expect(!!(!(arp)),0))) log_assert_failed("arp", "../src/libsystemd-network/ipv4ll-packet.c", 54, __PRETTY_FUNCTION__); } while (0);

        if (arp->ea_hdr.ar_hrd != (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (1 /* Ethernet 10/100Mbps.  */); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))) {
                log_meta(7 /* debug-level messages */, "../src/libsystemd-network/ipv4ll-packet.c", 57, __func__, "IPv4LL: " "ignoring packet: header is not ARPHRD_ETHER");
                return -22 /* Invalid argument */;
        }
        if (arp->ea_hdr.ar_pro != (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (0x0800 /* IP */); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))) {
                log_meta(7 /* debug-level messages */, "../src/libsystemd-network/ipv4ll-packet.c", 61, __func__, "IPv4LL: " "ignoring packet: protocol is not ETHERTYPE_IP");
                return -22 /* Invalid argument */;
        }
        if (arp->ea_hdr.ar_op != (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (1 /* ARP request.  */); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) &&
            arp->ea_hdr.ar_op != (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (2 /* ARP reply.  */); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))) {
                log_meta(7 /* debug-level messages */, "../src/libsystemd-network/ipv4ll-packet.c", 66, __func__, "IPv4LL: " "ignoring packet: operation is not ARPOP_REQUEST or ARPOP_REPLY");
                return -22 /* Invalid argument */;
        }

        return 0;
}

