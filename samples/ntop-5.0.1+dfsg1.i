unsigned int __builtin_bswap32 (unsigned int);
void * __builtin___memcpy_chk (void *, const void *, unsigned int, unsigned int);
unsigned int __builtin_object_size (const void *, int);
void * __builtin___memset_chk (void *, int, unsigned int, unsigned int);
unsigned int __builtin_strlen (const char *);
int __builtin_strcmp (const char *, const char *);

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 30 "/usr/include/i386-linux-gnu/bits/types.h"
typedef unsigned char __u_char;

# 31 "/usr/include/i386-linux-gnu/bits/types.h"
typedef unsigned short int __u_short;

# 32 "/usr/include/i386-linux-gnu/bits/types.h"
typedef unsigned int __u_int;

# 33 "/usr/include/i386-linux-gnu/bits/types.h"
typedef unsigned long int __u_long;

# 55 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long long int __quad_t;

# 129 "/usr/include/i386-linux-gnu/bits/types.h"
typedef unsigned int __mode_t;

# 131 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __off_t;

# 132 "/usr/include/i386-linux-gnu/bits/types.h"
typedef __quad_t __off64_t;

# 139 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __time_t;

# 141 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __suseconds_t;

# 48 "/usr/include/stdio.h"
typedef struct _IO_FILE FILE;

# 154 "/usr/include/libio.h"
typedef void _IO_lock_t;

# 160 "/usr/include/libio.h"
struct _IO_marker {
  struct _IO_marker *_next;
  struct _IO_FILE *_sbuf;
  /* If _pos >= 0
 it points to _buf->Gbase()+_pos. FIXME comment */
  /* if _pos < 0, it points to _buf->eBptr()+_pos. FIXME comment */
  int _pos;
# 177 "/usr/include/libio.h" 3 4
};

# 245 "/usr/include/libio.h"
struct _IO_FILE {
  int _flags; /* High-order word is _IO_MAGIC; rest is flags. */


  /* The following pointers correspond to the C++ streambuf protocol. */
  /* Note:  Tk uses the _IO_read_ptr and _IO_read_end fields directly. */
  char* _IO_read_ptr; /* Current read pointer */
  char* _IO_read_end; /* End of get area. */
  char* _IO_read_base; /* Start of putback+get area. */
  char* _IO_write_base; /* Start of put area. */
  char* _IO_write_ptr; /* Current put pointer. */
  char* _IO_write_end; /* End of put area. */
  char* _IO_buf_base; /* Start of reserve area. */
  char* _IO_buf_end; /* End of reserve area. */
  /* The following fields are used to support backing up and undo. */
  char *_IO_save_base; /* Pointer to start of non-current get area. */
  char *_IO_backup_base; /* Pointer to first valid character of backup area */
  char *_IO_save_end; /* Pointer to end of non-current get area. */

  struct _IO_marker *_markers;

  struct _IO_FILE *_chain;

  int _fileno;



  int _flags2;

  __off_t _old_offset; /* This used to be _offset but it's too small.  */


  /* 1+column number of pbase(); 0 is unknown. */
  unsigned short _cur_column;
  signed char _vtable_offset;
  char _shortbuf[1];

  /*  char* _save_gptr;  char* _save_egptr; */

  _IO_lock_t *_lock;
# 293 "/usr/include/libio.h" 3 4
  __off64_t _offset;
# 302 "/usr/include/libio.h" 3 4
  void *__pad1;
  void *__pad2;
  void *__pad3;
  void *__pad4;
  size_t __pad5;

  int _mode;
  /* Make sure we don't get into trouble again.  */
  char _unused2[15 * sizeof (int) - 4 * sizeof (void *) - sizeof (size_t)];

};

# 90 "/usr/include/stdio.h"
typedef __off_t off_t;

# 44 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}

# 33 "/usr/include/i386-linux-gnu/sys/types.h"
typedef __u_char u_char;

# 34 "/usr/include/i386-linux-gnu/sys/types.h"
typedef __u_short u_short;

# 35 "/usr/include/i386-linux-gnu/sys/types.h"
typedef __u_int u_int;

# 36 "/usr/include/i386-linux-gnu/sys/types.h"
typedef __u_long u_long;

# 70 "/usr/include/i386-linux-gnu/sys/types.h"
typedef __mode_t mode_t;

# 75 "/usr/include/time.h"
typedef __time_t time_t;

# 194 "/usr/include/i386-linux-gnu/sys/types.h"
typedef int int8_t;

# 196 "/usr/include/i386-linux-gnu/sys/types.h"
typedef int int32_t;

# 200 "/usr/include/i386-linux-gnu/sys/types.h"
typedef unsigned int u_int8_t;

# 201 "/usr/include/i386-linux-gnu/sys/types.h"
typedef unsigned int u_int16_t;

# 202 "/usr/include/i386-linux-gnu/sys/types.h"
typedef unsigned int u_int32_t;

# 203 "/usr/include/i386-linux-gnu/sys/types.h"
typedef unsigned int u_int64_t;

# 30 "/usr/include/i386-linux-gnu/bits/time.h"
struct timeval
  {
    __time_t tv_sec; /* Seconds.  */
    __suseconds_t tv_usec; /* Microseconds.  */
  };

# 54 "/usr/include/i386-linux-gnu/sys/select.h"
typedef long int __fd_mask;

# 64 "/usr/include/i386-linux-gnu/sys/select.h"
typedef struct
  {
    /* XPG4.2 requires this member name.  Otherwise avoid the name
       from the global namespace.  */

    __fd_mask fds_bits[1024 / (8 * (int) sizeof (__fd_mask))];





  } fd_set;

# 60 "/usr/include/i386-linux-gnu/bits/pthreadtypes.h"
typedef unsigned long int pthread_t;

# 81 "/usr/include/i386-linux-gnu/bits/pthreadtypes.h"
typedef struct __pthread_internal_slist
{
  struct __pthread_internal_slist *__next;
} __pthread_slist_t;

# 90 "/usr/include/i386-linux-gnu/bits/pthreadtypes.h"
typedef union
{
  struct __pthread_mutex_s
  {
    int __lock;
    unsigned int __count;
    int __owner;



    /* KIND must stay at this position in the structure to maintain
       binary compatibility.  */
    int __kind;







    unsigned int __nusers;
    __extension__ union
    {
      struct
      {
 short __espins;
 short __elision;



      } d;
      __pthread_slist_t __list;
    };

  } __data;
  char __size[24];
  long int __align;
} pthread_mutex_t;

# 138 "/usr/include/i386-linux-gnu/bits/pthreadtypes.h"
typedef union
{
  struct
  {
    int __lock;
    unsigned int __futex;
    __extension__ unsigned long long int __total_seq;
    __extension__ unsigned long long int __wakeup_seq;
    __extension__ unsigned long long int __woken_seq;
    void *__mutex;
    unsigned int __nwaiters;
    unsigned int __broadcast_seq;
  } __data;
  char __size[48];
  __extension__ long long int __align;
} pthread_cond_t;

# 173 "/usr/include/i386-linux-gnu/bits/pthreadtypes.h"
typedef union
{
# 194 "/usr/include/i386-linux-gnu/bits/pthreadtypes.h" 3 4
  struct
  {
    int __lock;
    unsigned int __nr_readers;
    unsigned int __readers_wakeup;
    unsigned int __writer_wakeup;
    unsigned int __nr_readers_queued;
    unsigned int __nr_writers_queued;
    /* FLAGS must stay at this position in the structure to maintain
       binary compatibility.  */
    unsigned char __flags;
    unsigned char __shared;
    unsigned char __pad1;
    unsigned char __pad2;
    int __writer;
  } __data;

  char __size[32];
  long int __align;
} pthread_rwlock_t;

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

# 38 "/usr/include/net/ethernet.h"
struct ether_header
{
  u_int8_t ether_dhost[6 /* Octets in one ethernet addr	 */]; /* destination eth addr	*/
  u_int8_t ether_shost[6 /* Octets in one ethernet addr	 */]; /* source ether addr	*/
  u_int16_t ether_type; /* packet type ID field	*/
};

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

# 62 "/usr/include/GeoIP.h"
typedef struct GeoIPTag {
    FILE *GeoIPDatabase;
    char *file_path;
    unsigned char *cache;
    unsigned char *index_cache;
    unsigned int *databaseSegments;
    char databaseType;
    time_t mtime;
    int flags;
    off_t size;
    char record_length;
    int charset; /* 0 iso-8859-1 1 utf8 */
    int record_iter; /* used in GeoIP_next_record */
    int netmask; /* netmask of last lookup - set using depth in _GeoIP_seek_record */
    time_t last_mtime_check;
    off_t dyn_seg_size; /* currently only used by the cityconfidence database */
    unsigned int ext_flags; /* bit 0 teredo support enabled */
} GeoIP;

# 32 "/usr/include/GeoIPCity.h"
typedef struct GeoIPRecordTag {
    char *country_code;
    char *country_code3;
    char *country_name;
    char *region;
    char *city;
    char *postal_code;
    float latitude;
    float longitude;
    union {
        int metro_code; /* metro_code is a alias for dma_code */
        int dma_code;
    };
    int area_code;
    int charset;
    char *continent_code;
    int netmask;
} GeoIPRecord;

# 86 "/usr/include/pcap/bpf.h"
typedef u_int bpf_u_int32;

# 105 "/usr/include/pcap/bpf.h"
struct bpf_program {
 u_int bf_len;
 struct bpf_insn *bf_insns;
};

# 1459 "/usr/include/pcap/bpf.h"
struct bpf_insn {
 u_short code;
 u_char jt;
 u_char jf;
 bpf_u_int32 k;
};

# 79 "/usr/include/pcap/pcap.h"
typedef struct pcap pcap_t;

# 80 "/usr/include/pcap/pcap.h"
typedef struct pcap_dumper pcap_dumper_t;

# 81 "/usr/include/pcap/pcap.h"
typedef struct pcap_if pcap_if_t;

# 160 "/usr/include/pcap/pcap.h"
struct pcap_pkthdr {
 struct timeval ts; /* time stamp */
 bpf_u_int32 caplen; /* length of portion present */
 bpf_u_int32 len; /* length this packet (off wire) */
};

# 214 "/usr/include/pcap/pcap.h"
struct pcap_if {
 struct pcap_if *next;
 char *name; /* name to hand to "pcap_open_live()" */
 char *description; /* textual description of interface, or NULL */
 struct pcap_addr *addresses;
 bpf_u_int32 flags; /* PCAP_IF_ interface flags */
};

# 229 "/usr/include/pcap/pcap.h"
struct pcap_addr {
 struct pcap_addr *next;
 struct sockaddr *addr; /* address */
 struct sockaddr *netmask; /* netmask for that address */
 struct sockaddr *broadaddr; /* broadcast address for that address */
 struct sockaddr *dstaddr; /* P2P destination address for that address */
};

# 419 "/usr/include/pcap/pcap.h"
void pcap_dump(u_char *, const struct pcap_pkthdr *, const u_char *);

# 434 "/usr/include/pcap/pcap.h"
u_int bpf_filter(const struct bpf_insn *, const u_char *, u_int, u_int);

# 8 "countmin.h"
typedef struct CM_type{
  long long count;
  int depth;
  int width;
  int ** counts;
  unsigned int *hasha, *hashb;
} CM_type;

# 63 "/usr/include/gdbm.h"
typedef struct {int dummy[10];} *GDBM_FILE;

# 123 "globals-structtypes.h"
typedef struct ether80211q {
  u_int16_t vlanId;
  u_int16_t protoType;
} Ether80211q;

# 134 "globals-structtypes.h"
struct pppoe_tag {
  u_int16_t tag_type;
  u_int16_t tag_len;
  char tag_data;
};

# 140 "globals-structtypes.h"
struct pppoe_hdr {

  u_int8_t ver : 4;
  u_int8_t type : 4;




  u_int8_t code;
  u_int16_t sid;
  u_int16_t length;
  struct pppoe_tag tag;
};

# 159 "globals-structtypes.h"
typedef struct hostAddr {
  u_int hostFamily; /* AF_INET AF_INET6 */
  union {
    struct in_addr _hostIp4Address;
    struct in6_addr _hostIp6Address;
  } addr;
} HostAddr;

# 179 "globals-structtypes.h"
typedef struct _ethSerial {
  u_char ethAddress[6];
  u_int16_t vlanId;
} EthSerial;

# 184 "globals-structtypes.h"
typedef struct _ipSerial {
  HostAddr ipAddress;
  u_int16_t vlanId;
} IpSerial;

# 189 "globals-structtypes.h"
typedef struct hostSerial {
  u_int8_t serialType; /* 0 == empty */
  union {
    EthSerial ethSerial; /* hostSerial == SERIAL_MAC */
    IpSerial ipSerial; /* hostSerial == SERIAL_IPV4/SERIAL_IPV6 */
  } value;
} HostSerial;

# 197 "globals-structtypes.h"
typedef u_int32_t HostSerialIndex;

# 264 "globals-structtypes.h"
typedef struct portProtoMapper {
  u_int portProto; /* Port/proto to map */
  u_int mappedPortProto; /* Mapped port/proto */
  u_char dummyEntry; /* Set to 1 if this entry is dummy */
} PortProtoMapper;

# 270 "globals-structtypes.h"
typedef struct portProtoMapperHandler {
  u_short numElements; /* numIpPortsToHandle */
  int numSlots;/* numIpPortMapperSlots */
  PortProtoMapper *theMapper;
} PortProtoMapperHandler;

# 276 "globals-structtypes.h"
typedef struct protocolsList {
  char *protocolName;
  u_int16_t protocolId, protocolIdAlias; /* I know it's ugly however this
					    should be enough for most of
					    the situations
					 */
  struct protocolsList *next;
} ProtocolsList;

# 299 "globals-structtypes.h"
typedef struct conditionalVariable {
  pthread_mutex_t mutex;
  pthread_cond_t condvar;
  int predicate;
} ConditionalVariable;

# 336 "globals-structtypes.h"
typedef struct pthreadMutex {
  u_int8_t isInitialized;
# 346 "globals-structtypes.h"
  pthread_rwlock_t mutex;

} PthreadMutex;

# 350 "globals-structtypes.h"
typedef struct packetInformation {
  unsigned short deviceId;
  struct pcap_pkthdr h;
  u_char p[8232];
} PacketInformation;

# 364 "globals-structtypes.h"
typedef unsigned long long Counter;

# 367 "globals-structtypes.h"
typedef struct trafficCounter {
  Counter value;
  u_char modified;
} TrafficCounter;

# 374 "globals-structtypes.h"
inline static void incrementTrafficCounter(TrafficCounter *ctr, Counter value) { if(value > 0) ctr->value += value, ctr->modified = 1; }

# 391 "globals-structtypes.h"
typedef struct packetStats {
  TrafficCounter upTo64, upTo128, upTo256;
  TrafficCounter upTo512, upTo1024, upTo1518;



  TrafficCounter above1518;

  TrafficCounter shortest, longest;
  TrafficCounter tooLong;
} PacketStats;

# 405 "globals-structtypes.h"
typedef struct ttlStats {
  TrafficCounter upTo32, upTo64, upTo96;
  TrafficCounter upTo128, upTo160, upTo192, upTo224, upTo255;
} TTLstats;

# 412 "globals-structtypes.h"
typedef struct simpleProtoTrafficInfo {
  TrafficCounter local, local2remote, remote, remote2local; /* Bytes */
  TrafficCounter totalFlows;
} SimpleProtoTrafficInfo;

# 419 "globals-structtypes.h"
typedef struct usageCounter {
  TrafficCounter value;
  HostSerialIndex peersSerials[8]; /* host serial */
} UsageCounter;

# 426 "globals-structtypes.h"
typedef struct routingCounter {
  TrafficCounter routedPkts, routedBytes;
} RoutingCounter;

# 433 "globals-structtypes.h"
typedef struct securityHostProbes {
  UsageCounter synPktsSent, rstPktsSent, rstAckPktsSent,
    synFinPktsSent, finPushUrgPktsSent, nullPktsSent;
  UsageCounter synPktsRcvd, rstPktsRcvd, rstAckPktsRcvd,
    synFinPktsRcvd, finPushUrgPktsRcvd, nullPktsRcvd;
  UsageCounter ackXmasFinSynNullScanSent, ackXmasFinSynNullScanRcvd;
  UsageCounter rejectedTCPConnSent, rejectedTCPConnRcvd;
  UsageCounter establishedTCPConnSent, establishedTCPConnRcvd;
  UsageCounter terminatedTCPConnServer, terminatedTCPConnClient;

  /* ********* */

  UsageCounter udpToClosedPortSent, udpToClosedPortRcvd;

  UsageCounter udpToDiagnosticPortSent, udpToDiagnosticPortRcvd,
    tcpToDiagnosticPortSent, tcpToDiagnosticPortRcvd;
  UsageCounter tinyFragmentSent, tinyFragmentRcvd;
  UsageCounter icmpFragmentSent, icmpFragmentRcvd;
  UsageCounter overlappingFragmentSent, overlappingFragmentRcvd;
  UsageCounter closedEmptyTCPConnSent, closedEmptyTCPConnRcvd;
  UsageCounter icmpPortUnreachSent, icmpPortUnreachRcvd;
  UsageCounter icmpHostNetUnreachSent, icmpHostNetUnreachRcvd;
  UsageCounter icmpProtocolUnreachSent, icmpProtocolUnreachRcvd;
  UsageCounter icmpAdminProhibitedSent, icmpAdminProhibitedRcvd;
  UsageCounter malformedPktsSent, malformedPktsRcvd;
} SecurityHostProbes;

# 461 "globals-structtypes.h"
typedef struct securityDeviceProbes {
  TrafficCounter synPkts, rstPkts, rstAckPkts,
    synFinPkts, finPushUrgPkts, nullPkts;
  TrafficCounter rejectedTCPConn;
  TrafficCounter establishedTCPConn;
  TrafficCounter terminatedTCPConn;
  TrafficCounter ackXmasFinSynNullScan;
  /* ********* */
  TrafficCounter udpToClosedPort;
  TrafficCounter udpToDiagnosticPort, tcpToDiagnosticPort;
  TrafficCounter tinyFragment;
  TrafficCounter icmpFragment;
  TrafficCounter overlappingFragment;
  TrafficCounter closedEmptyTCPConn;
  TrafficCounter malformedPkts;
  TrafficCounter icmpPortUnreach;
  TrafficCounter icmpHostNetUnreach;
  TrafficCounter icmpProtocolUnreach;
  TrafficCounter icmpAdminProhibited;
} SecurityDeviceProbes;

# 484 "globals-structtypes.h"
typedef struct sapType {
  u_char dsap, ssap;
} SapType;

# 490 "globals-structtypes.h"
typedef struct unknownProto {
  u_char protoType; /* 0=notUsed, 1=Ethernet, 2=SAP, 3=IP */
  union {
    u_int16_t ethType;
    SapType sapType;
    u_int16_t ipType;
  } proto;
} UnknownProto;

# 501 "globals-structtypes.h"
typedef struct nonIPTraffic {
  /* NetBIOS */
  char nbNodeType, *nbHostName, *nbAccountName, *nbDomainName, *nbDescr;

  /* Non IP */
  TrafficCounter stpSent, stpRcvd; /* Spanning Tree */
  TrafficCounter arp_rarpSent, arp_rarpRcvd;
  TrafficCounter arpReqPktsSent, arpReplyPktsSent, arpReplyPktsRcvd;
  TrafficCounter netbiosSent, netbiosRcvd;
  TrafficCounter otherSent, otherRcvd; /* Other traffic we cannot classify */
  UnknownProto *unknownProtoSent, *unknownProtoRcvd; /* List of MAX_NUM_UNKNOWN_PROTOS elements */
} NonIPTraffic;

# 516 "globals-structtypes.h"
typedef struct trafficDistribution {
  TrafficCounter lastCounterBytesSent, last24HoursBytesSent[25], lastDayBytesSent;
  TrafficCounter lastCounterBytesRcvd, last24HoursBytesRcvd[25], lastDayBytesRcvd;
} TrafficDistribution;

# 523 "globals-structtypes.h"
typedef struct portUsage {
  u_short port, clientUses, serverUses;
  HostSerialIndex clientUsesLastPeer, serverUsesLastPeer;
  TrafficCounter clientTraffic, serverTraffic;
  struct portUsage *next;
} PortUsage;

# 532 "globals-structtypes.h"
typedef struct hostTalker {
  HostSerialIndex hostSerial;
  float bps /* bytes/sec */;
} HostTalker;

# 547 "globals-structtypes.h"
typedef struct topTalkers {
  time_t when;
  HostTalker senders[5], receivers[5];
} TopTalkers;

# 554 "globals-structtypes.h"
typedef struct virtualHostList {
  char *virtualHostName;
  TrafficCounter bytesSent, bytesRcvd; /* ... by the virtual host */
  struct virtualHostList *next;
} VirtualHostList;

# 562 "globals-structtypes.h"
typedef struct userList {
  char *userName;
  fd_set userFlags;
  struct userList *next;
} UserList;

# 595 "globals-structtypes.h"
typedef struct serviceStats {
  TrafficCounter numLocalReqSent, numRemReqSent;
  TrafficCounter numPositiveReplSent, numNegativeReplSent;
  TrafficCounter numLocalReqRcvd, numRemReqRcvd;
  TrafficCounter numPositiveReplRcvd, numNegativeReplRcvd;
  time_t fastestMicrosecLocalReqMade, slowestMicrosecLocalReqMade;
  time_t fastestMicrosecLocalReqServed, slowestMicrosecLocalReqServed;
  time_t fastestMicrosecRemReqMade, slowestMicrosecRemReqMade;
  time_t fastestMicrosecRemReqServed, slowestMicrosecRemReqServed;
} ServiceStats;

# 608 "globals-structtypes.h"
typedef struct dhcpStats {
  struct in_addr dhcpServerIpAddress; /* DHCP server that assigned the address */
  struct in_addr previousIpAddress; /* Previous IP address is any */
  time_t assignTime; /* when the address was assigned */
  time_t renewalTime; /* when the address has to be renewed */
  time_t leaseTime; /* when the address lease will expire */
  TrafficCounter dhcpMsgSent[8 + 1], dhcpMsgRcvd[8 + 1];
} DHCPStats;

# 625 "globals-structtypes.h"
typedef struct icmpHostInfo {
  TrafficCounter icmpMsgSent[142 +1];
  TrafficCounter icmpMsgRcvd[142 +1];
  time_t lastUpdated;
} IcmpHostInfo;

# 633 "globals-structtypes.h"
typedef struct protocolInfo {
  /* HTTP */
  VirtualHostList *httpVirtualHosts;
  /* POP3/SMTP... */
  UserList *userList;

  ServiceStats *dnsStats, *httpStats;
  DHCPStats *dhcpStats;
} ProtocolInfo;

# 645 "globals-structtypes.h"
typedef struct shortProtoTrafficInfo {
  TrafficCounter sent, rcvd; /* Bytes */
} ShortProtoTrafficInfo;

# 662 "globals-structtypes.h"
typedef struct nonIpProtoTrafficInfo {
  u_int16_t protocolId;
  TrafficCounter sentBytes, rcvdBytes;
  TrafficCounter sentPkts, rcvdPkts;
  struct nonIpProtoTrafficInfo *next;
} NonIpProtoTrafficInfo;

# 671 "globals-structtypes.h"
typedef struct networkDelay {
  struct timeval last_update;
  u_long min_nw_delay, max_nw_delay;
  u_int num_samples;
  double total_delay;
  u_int16_t peer_port;
  HostSerialIndex last_peer;
} NetworkDelay;

# 682 "globals-structtypes.h"
typedef struct {
  Counter bytesSent, bytesRcvd;
} ProtoTraffic;

# 690 "globals-structtypes.h"
typedef struct hostTraffic {
  u_int8_t to_be_deleted; /* 1 = the host will be deleted in the next purge loop */
  u_short magic;
  u_int8_t l2Host; /* 1 = Ethernet, 0 = IP and above */
  u_int hostTrafficBucket; /* Index in the **hash_hostTraffic list */
  u_short refCount; /* Reference counter */
  HostSerial hostSerial;
  HostSerialIndex serialHostIndex; /* Stored in myGlobals.serialFile and valid until ntop restart */
  HostAddr hostIpAddress;
  u_int16_t vlanId; /* VLAN Id (-1 if not set) */
  u_int16_t ifId; /* Interface Id [e.g. for NetFlow] (-1 if not set) */
  u_int16_t hostAS; /* AS to which the host belongs to */
  char *hostASDescr; /* Description of the host AS */
  time_t firstSeen, lastSeen; /* time when this host has sent/rcvd some data  */
  u_char ethAddress[6];
  u_char lastEthAddress[6]; /* used for remote addresses */
  char ethAddressString[sizeof("00:00:00:00:00:00")];
  char hostNumIpAddress[20] /* xxx.xxx.xxx.xxx */, *dnsDomainValue, *dnsTLDValue;
  u_int8_t network_mask; /* IPv6 notation e.g. /24 */
  int8_t known_subnet_id; /* UNKNOWN_SUBNET_ID if the host does not belong to a known subnet */
  char *hwModel, *description, *community, *fingerprint;
  char hostResolvedName[128];
  short hostResolvedNameType;
  u_short minTTL, maxTTL; /* IP TTL (Time-To-Live) */
  struct timeval minLatency, maxLatency;
  GeoIPRecord *geo_ip;

  TrafficCounter greSent, greRcvd, grePktSent, grePktRcvd, lastGrePktSent, lastGrePktRcvd;
  TrafficCounter ipsecSent, ipsecRcvd, ipsecPktSent, ipsecPktRcvd, lastIpsecPktSent, lastIpsecPktRcvd;

  /* Sketches */
  CM_type *sent_to_matrix, *recv_from_matrix;

  NonIPTraffic *nonIPTraffic;
  NonIpProtoTrafficInfo *nonIpProtoTrafficInfos; /* Info about further non IP protos */

  fd_set flags;
  TrafficCounter pktsSent, pktsRcvd, pktsSentSession, pktsRcvdSession;
  TrafficCounter pktsDuplicatedAckSent, pktsDuplicatedAckRcvd;
  TrafficCounter pktsBroadcastSent, bytesBroadcastSent;
  TrafficCounter pktsMulticastSent, bytesMulticastSent;
  TrafficCounter pktsMulticastRcvd, bytesMulticastRcvd;
  TrafficCounter lastBytesSent, lastHourBytesSent;
  TrafficCounter bytesSent, bytesSentLoc, bytesSentRem, bytesSentSession;
  TrafficCounter lastBytesRcvd, lastHourBytesRcvd, bytesRcvd;
  TrafficCounter bytesRcvdLoc, bytesRcvdFromRem, bytesRcvdSession;
  float actualRcvdThpt, lastHourRcvdThpt, averageRcvdThpt, peakRcvdThpt;
  float actualSentThpt, lastHourSentThpt, averageSentThpt, peakSentThpt;
  float actualThpt, averageThpt /* REMOVE */, peakThpt;
  unsigned short actBandwidthUsage, actBandwidthUsageS, actBandwidthUsageR;
  TrafficDistribution *trafficDistribution;
  u_int32_t numHostSessions;

  /* Routing */
  RoutingCounter *routedTraffic;

  /* IP */
  PortUsage *portsUsage; /* 0...MAX_ASSIGNED_IP_PORTS */

  /* NetworkDelay Stats */
  NetworkDelay *clientDelay /* 0..MAX_NUM_NET_DELAY_STATS-1 */, *serverDelay /* 0 ..MAX_NUM_NET_DELAY_STATS-1 */;

  /* Don't change the recentl... to unsigned ! */
  int recentlyUsedClientPorts[5], recentlyUsedServerPorts[5];
  int otherIpPortsRcvd[5], otherIpPortsSent[5];
  TrafficCounter ipv4BytesSent, ipv4BytesRcvd, ipv6BytesSent, ipv6BytesRcvd;
  TrafficCounter tcpSentLoc, tcpSentRem, udpSentLoc, udpSentRem, icmpSent,icmp6Sent;
  TrafficCounter tcpRcvdLoc, tcpRcvdFromRem, udpRcvdLoc, udpRcvdFromRem, icmpRcvd, icmp6Rcvd;

  TrafficCounter tcpFragmentsSent, tcpFragmentsRcvd, udpFragmentsSent, udpFragmentsRcvd,
    icmpFragmentsSent, icmpFragmentsRcvd, icmp6FragmentsSent, icmp6FragmentsRcvd;

  /* Protocol decoders */
  ProtocolInfo *protocolInfo;

  /* Interesting Packets */
  SecurityHostProbes *secHostPkts;
  IcmpHostInfo *icmpInfo;

  ShortProtoTrafficInfo **ipProtosList; /* List of myGlobals.numIpProtosList entries */
  Counter totContactedSentPeers, totContactedRcvdPeers; /* # of different contacted peers */
  struct hostTraffic *next; /* pointer to the next element */

  UsageCounter contactedSentPeers; /* peers that talked with this host */
  UsageCounter contactedRcvdPeers; /* peers that talked with this host */

  struct {
    ProtoTraffic *traffic;
  } l7;
} HostTraffic;

# 815 "globals-structtypes.h"
typedef struct serviceEntry {
  u_short port;
  char* name;
} ServiceEntry;

# 820 "globals-structtypes.h"
typedef struct portCounter {
  u_short port;
  Counter sent, rcvd;
} PortCounter;

# 826 "globals-structtypes.h"
typedef struct ipSession {
  u_short magic;
  u_int8_t proto; /* IPPROTO_TCP / IPPROTO_UDP...               */
  u_char isP2P; /* Set to 1 if this is a P2P session          */
  u_int8_t knownProtocolIdx; /* Mark this as a special protocol session    */
  HostTraffic* initiator; /* initiator address                          */
  HostAddr initiatorRealIp; /* Real IP address (if masqueraded and known) */
  u_short sport; /* initiator address (port)                   */
  HostTraffic *remotePeer; /* remote peer address                        */
  HostAddr remotePeerRealIp; /* Real IP address (if masqueraded and known) */
  char *virtualPeerName; /* Name of a virtual host (e.g. HTTP virtual host) */
  u_short dport; /* remote peer address (port)               */
  time_t firstSeen; /* time when the session has been initiated */
  time_t lastSeen; /* time when the session has been closed    */
  u_long pktSent, pktRcvd;
  TrafficCounter bytesSent; /* # bytes sent (initiator -> peer) [IP]    */
  TrafficCounter bytesRcvd; /* # bytes rcvd (peer -> initiator)[IP]     */
  TrafficCounter bytesProtoSent; /* # bytes sent (Protocol [e.g. HTTP])      */
  TrafficCounter bytesProtoRcvd; /* # bytes rcvd (Protocol [e.g. HTTP])      */
  u_int minWindow, maxWindow; /* TCP window size                          */
  struct timeval synTime, synAckTime, ackTime; /* Used to calcolate nw delay */
  struct timeval clientNwDelay, serverNwDelay; /* Network Delay/Latency         */
  u_short numFin; /* # FIN pkts rcvd                          */
  u_short numFinAcked; /* # ACK pkts rcvd                          */
  u_int32_t lastAckIdI2R; /* ID of the last ACK rcvd                  */
  u_int32_t lastAckIdR2I; /* ID of the last ACK rcvd                  */
  TrafficCounter bytesRetranI2R; /* # bytes retransmitted (due to duplicated ACKs) */
  TrafficCounter bytesRetranR2I; /* # bytes retransmitted (due to duplicated ACKs) */
  u_int32_t finId[4]; /* ACK ids we're waiting for                */
  u_long lastFlags; /* flags of the last TCP packet             */
  u_int32_t lastCSAck, lastSCAck; /* they store the last ACK ids C->S/S->C    */
  u_int32_t lastCSFin, lastSCFin; /* they store the last FIN ids C->S/S->C    */
  u_char lastInitiator2RemFlags[4]; /* TCP flags             */
  u_char lastRem2InitiatorFlags[4]; /* TCP flags             */
  u_char sessionState; /* actual session state                     */
  u_char passiveFtpSession; /* checked if this is a passive FTP session */
  u_char voipSession; /* checked if this is a VoIP session */
  char *session_info; /* Info about this session (if any) */
  struct ipSession *next;
  struct {
    u_int8_t proto_guessed;
    u_int16_t major_proto;
    struct ipoque_flow_struct *flow;
    struct ipoque_id_struct *src, *dst;
  } l7;
} IPSession;

# 875 "globals-structtypes.h"
typedef struct ntopIfaceAddrInet {
  struct in_addr ifAddr;
  struct in_addr network;
  struct in_addr netmask;
} NtopIfaceAddrInet;

# 881 "globals-structtypes.h"
typedef struct ntopIfaceAddrInet6 {
  struct in6_addr ifAddr;
  int prefixlen;
} NtopIfaceAddrInet6;

# 886 "globals-structtypes.h"
typedef struct ntopIfaceaddr{
  int family;
  struct ntopIfaceaddr *next;
  union {
    NtopIfaceAddrInet inet;
    NtopIfaceAddrInet6 inet6;
  } af;
} NtopIfaceAddr;

# 898 "globals-structtypes.h"
typedef enum {
  noAggregation = 0,
  portAggregation,
  hostAggregation,
  protocolAggregation,
  asAggregation
} AggregationType;

# 906 "globals-structtypes.h"
typedef enum {
  noDnsResolution = 0,
  dnsResolutionForLocalHostsOnly = 1,
  dnsResolutionForLocalRemoteOnly = 2,
  dnsResolutionForAll = 3
} DnsResolutionMode;

# 913 "globals-structtypes.h"
typedef struct probeInfo {
  struct in_addr probeAddr;
  u_int16_t probePort;
  u_int32_t pkts;
  u_int32_t lastSequenceNumber, lowestSequenceNumber, highestSequenceNumber, totNumFlows;
  u_int32_t lostFlows;
} ProbeInfo;

# 1076 "globals-structtypes.h"
typedef struct flow_ipfix_template_field {
  u_int16_t fieldType;
  u_int16_t fieldLen;
  u_int8_t isPenField;
} V9V10TemplateField;

# 1114 "globals-structtypes.h"
typedef struct flow_ver9_template {
  /* V9TemplateHeader */
  u_int16_t flowsetLen;
  /* V9TemplateDef */
  u_int16_t templateId;
  u_int16_t fieldCount;
} V9SimpleTemplate;

# 1137 "globals-structtypes.h"
typedef struct flowSetV9 {
  V9SimpleTemplate templateInfo;
  u_int16_t flowLen; /* Real flow length */
  V9V10TemplateField *fields;
  struct flowSetV9 *next;
} FlowSetV9;

# 1144 "globals-structtypes.h"
typedef struct interfaceStats {
  u_int32_t netflow_device_ip;
  u_int16_t netflow_device_port;
  u_short interface_id;
  char interface_name[32];
  TrafficCounter inBytes, outBytes, inPkts, outPkts;
  TrafficCounter selfBytes, selfPkts;
  struct interfaceStats *next;
} InterfaceStats;

# 1155 "globals-structtypes.h"
typedef struct astats {
  u_short as_id;
  time_t lastUpdate;
  Counter totPktsSinceLastRRDDump;
  TrafficCounter inBytes, outBytes, inPkts, outPkts;
  TrafficCounter selfBytes, selfPkts;
  struct astats *next;
} AsStats;

# 1164 "globals-structtypes.h"
typedef struct {
  u_int32_t address[4]; /* [0]=network, [1]=mask, [2]=broadcast, [3]=mask_v6 */
} NetworkStats;

# 1170 "globals-structtypes.h"
typedef struct optionTemplate {
  u_int16_t templateId;
  struct optionTemplate *next;
} OptionTemplate;

# 1175 "globals-structtypes.h"
typedef struct netFlowGlobals {
  u_char netFlowDebug;

  /* Flow Storage */
  char *dumpPath;
  u_short dumpInterval;
  time_t dumpFdCreationTime;
  FILE *dumpFd;

  /* Flow reception */
  AggregationType netFlowAggregation;
  int netFlowInSocket, netFlowDeviceId;



  u_short netFlowInPort;
  struct in_addr netFlowIfAddress, netFlowIfMask;
  char *netFlowWhiteList, *netFlowBlackList;
  u_long numNetFlowsPktsRcvd, numNetFlowsV5Rcvd;
  u_long numNetFlowsV1Rcvd, numNetFlowsV7Rcvd, numNetFlowsV9Rcvd, numNetFlowsProcessed;
  u_long numNetFlowsRcvd, lastNumNetFlowsRcvd;
  u_long totalNetFlowsTCPSize, totalNetFlowsUDPSize, totalNetFlowsICMPSize, totalNetFlowsOtherSize;
  u_long numNetFlowsTCPRcvd, numNetFlowsUDPRcvd, numNetFlowsICMPRcvd, numNetFlowsOtherRcvd;
  u_long numBadNetFlowsVersionsRcvd, numBadFlowPkts, numBadFlowBytes, numBadFlowReality;
  u_long numSrcNetFlowsEntryFailedBlackList, numSrcNetFlowsEntryFailedWhiteList,
    numSrcNetFlowsEntryAccepted,
    numDstNetFlowsEntryFailedBlackList, numDstNetFlowsEntryFailedWhiteList,
    numDstNetFlowsEntryAccepted;
  u_long numNetFlowsV9TemplRcvd, numNetFlowsV9BadTemplRcvd, numNetFlowsV9UnknTemplRcvd,
    numNetFlowsV9OptionFlowsRcvd;

  /* Stats */
  ProbeInfo probeList[16];
  InterfaceStats *ifStats;
  NetworkStats whiteNetworks[64], blackNetworks[64];
  u_short numWhiteNets, numBlackNets;
  u_int32_t flowProcessed;
  Counter flowProcessedBytes;
  HostTraffic *dummyHost;
  FlowSetV9 *templates;
  OptionTemplate *optionTemplates;

  pthread_t netFlowThread;
  int threadActive;
  PthreadMutex whiteblackListMutex, ifStatsMutex;
# 1228 "globals-structtypes.h"
} NetFlowGlobals;

# 1234 "globals-structtypes.h"
typedef struct ifCounters {
  u_int32_t ifIndex;
  u_int32_t ifType;
  u_int64_t ifSpeed;
  u_int32_t ifDirection; /* Derived from MAU MIB (RFC 2668)
				   0 = unknown, 1 = full-duplex,
				   2 = half-duplex, 3 = in, 4 = out */
  u_int32_t ifStatus; /* bit field with the following bits assigned:
				   bit 0 = ifAdminStatus (0 = down, 1 = up)
				   bit 1 = ifOperStatus (0 = down, 1 = up) */
  u_int64_t ifInOctets;
  u_int32_t ifInUcastPkts;
  u_int32_t ifInMulticastPkts;
  u_int32_t ifInBroadcastPkts;
  u_int32_t ifInDiscards;
  u_int32_t ifInErrors;
  u_int32_t ifInUnknownProtos;
  u_int64_t ifOutOctets;
  u_int32_t ifOutUcastPkts;
  u_int32_t ifOutMulticastPkts;
  u_int32_t ifOutBroadcastPkts;
  u_int32_t ifOutDiscards;
  u_int32_t ifOutErrors;
  u_int32_t ifPromiscuousMode;
  struct ifCounters *next;
} IfCounters;

# 1261 "globals-structtypes.h"
typedef struct sFlowGlobals {
  u_char sflowDebug;

  /* Flow reception */
  AggregationType sflowAggregation;
  int sflowInSocket, sflowDeviceId;
  u_char sflowAssumeFTP;
  u_short sflowInPort;
  struct in_addr sflowIfAddress, sflowIfMask;
  char *sflowWhiteList, *sflowBlackList;
  u_long numsFlowsPktsRcvd;
  u_long numsFlowsV2Rcvd, numsFlowsV4Rcvd, numsFlowsV5Rcvd, numsFlowsProcessed;
  u_long numsFlowsSamples, numsFlowCounterUpdates;
  u_long numBadsFlowsVersionsRcvd, numBadFlowReality;
  u_long numSrcsFlowsEntryFailedBlackList, numSrcsFlowsEntryFailedWhiteList,
    numSrcsFlowsEntryAccepted,
    numDstsFlowsEntryFailedBlackList, numDstsFlowsEntryFailedWhiteList,
    numDstsFlowsEntryAccepted;

  /* Stats */
  ProbeInfo probeList[16];
  NetworkStats whiteNetworks[64], blackNetworks[64];
  u_short numWhiteNets, numBlackNets;
  u_int32_t flowProcessed;
  Counter flowProcessedBytes;
  HostTraffic *dummyHost;

  pthread_t sflowThread;
  int threadActive;
  PthreadMutex whiteblackListMutex;

  u_long numSamplesReceived, initialPool, lastSample;
  u_int32_t flowSampleSeqNo, numSamplesToGo;
  IfCounters *ifCounters;
} SflowGlobals;

# 1299 "globals-structtypes.h"
typedef struct {
  u_int hostsno; /* # of valid entries in the following table */
  u_int actualHashSize;
  struct hostTraffic **hash_hostTraffic;
  u_short hashListMaxLookups;
} HostsHashInfo;

# 1308 "globals-structtypes.h"
typedef struct ntopInterface {
  char *name; /* Interface name (e.g. eth0) */
  char *uniqueIfName; /* Unique interface name used to save data on disk */
  char *humanFriendlyName; /* Human friendly name of the interface (needed under WinNT and above) */
  int flags; /* the status of the interface as viewed by ntop */

  u_int32_t addr; /* Internet address (four bytes notation) */
  char *ipdot; /* IP address (dot notation) */
  char *fqdn; /* FQDN (resolved for humans) */

  struct in_addr network; /* network number associated to this interface */
  struct in_addr netmask; /* netmask associated to this interface */
  u_int numHosts; /* # hosts of the subnet */
  struct in_addr ifAddr; /* network number associated to this interface */

  NtopIfaceAddr *v6Addrs;

  time_t started; /* time the interface was enabled to look at pkts */
  time_t firstpkt; /* time first packet was captured */
  time_t lastpkt; /* time last packet was captured */

  pcap_t *pcapPtr; /* LBNL pcap handler */
  pcap_dumper_t *pcapDumper; /* LBNL pcap dumper  - enabled using the 'l' flag */
  pcap_dumper_t *pcapErrDumper; /* LBNL pcap dumper - all suspicious packets are logged */
  pcap_dumper_t *pcapOtherDumper;/* LBNL pcap dumper - all "other" (unknown Ethernet and IP) packets are logged */

  char virtualDevice; /* set to 1 for virtual devices (e.g. eth0:1) */
  char activeDevice; /* Is the interface active (useful for virtual interfaces) */
  char dummyDevice; /* set to 1 for 'artificial' devices (e.g. sFlow-device) */
  u_int8_t hasVLANs; /* Have we seen 802.1q stuff */
  u_int32_t deviceSpeed; /* Device speed (0 if speed is unknown) */
  int snaplen; /* maximum # of bytes to capture foreach pkt */
                                 /* read timeout in milliseconds */
  int datalink; /* data-link encapsulation type (see DLT_* in net/bph.h) */
  u_short samplingRate; /* default = 1 */
  u_short droppedSamples; /* Number of packets dropped due to sampling, since the last processed pkt */
  u_short mtuSize, /* MTU and header, derived from DLT and table in globals-core.c */
    headerSize;

  char *filter; /* user defined filter expression (if any) */

  int fd; /* unique identifier (Unix file descriptor) */

  PthreadMutex asMutex, counterMutex;
  AsStats *asStats;

  /*
   * NPA - Network Packet Analyzer (main thread)
   */
  PthreadMutex packetQueueMutex;
  PthreadMutex packetProcessMutex;
  PacketInformation *packetQueue; /* [CONST_PACKET_QUEUE_LENGTH+1]; */
  u_int packetQueueLen, maxPacketQueueLen, packetQueueHead, packetQueueTail;
  ConditionalVariable queueCondvar;
  pthread_t dequeuePacketThreadId;

  /*
   * The packets section
   */
  TrafficCounter receivedPkts; /* # of pkts recevied by the application */
  TrafficCounter droppedPkts; /* # of pkts dropped by the application */
  TrafficCounter pcapDroppedPkts; /* # of pkts dropped by libpcap */
  TrafficCounter initialPcapDroppedPkts; /* # of pkts dropped by libpcap at startup */
  TrafficCounter ethernetPkts; /* # of Ethernet pkts captured by the application */
  TrafficCounter broadcastPkts; /* # of broadcast pkts captured by the application */
  TrafficCounter multicastPkts; /* # of multicast pkts captured by the application */
  TrafficCounter ipPkts; /* # of IP pkts captured by the application */

  /*
   * The bytes section
   */
  TrafficCounter ethernetBytes; /* # bytes captured */
  TrafficCounter ipv4Bytes;
  TrafficCounter fragmentedIpBytes;
  TrafficCounter tcpBytes;
  TrafficCounter udpBytes;
  TrafficCounter otherIpBytes;

  TrafficCounter icmpBytes;
  TrafficCounter stpBytes; /* Spanning Tree */
  TrafficCounter ipsecBytes;
  TrafficCounter netbiosBytes;
  TrafficCounter arpRarpBytes;
  TrafficCounter greBytes;
  TrafficCounter ipv6Bytes;
  TrafficCounter icmp6Bytes;
  TrafficCounter otherBytes;
  TrafficCounter *ipProtosList; /* List of myGlobals.numIpProtosList entries */

  PortCounter **ipPorts; /* [MAX_IP_PORT] */

  TrafficCounter lastMinEthernetBytes;
  TrafficCounter lastFiveMinsEthernetBytes;

  TrafficCounter lastMinEthernetPkts;
  TrafficCounter lastFiveMinsEthernetPkts;
  TrafficCounter lastNumEthernetPkts;

  TrafficCounter lastEthernetPkts;
  TrafficCounter lastTotalPkts;

  TrafficCounter lastBroadcastPkts;
  TrafficCounter lastMulticastPkts;

  TrafficCounter lastEthernetBytes;
  TrafficCounter lastIpBytes;
  TrafficCounter lastNonIpBytes;

  PacketStats rcvdPktStats; /* statistics from start of the run to time of call */
  TTLstats rcvdPktTTLStats;

  float peakThroughput, actualThpt, lastMinThpt, lastFiveMinsThpt;
  float peakPacketThroughput, actualPktsThpt, lastMinPktsThpt, lastFiveMinsPktsThpt;

  time_t lastThptUpdate, lastMinThptUpdate;
  time_t lastHourThptUpdate, lastFiveMinsThptUpdate;
  float throughput;
  float packetThroughput;

  unsigned long numThptSamples;
  TopTalkers last60MinTopTalkers[60], last24HoursTopTalkers[24];

  SimpleProtoTrafficInfo tcpGlobalTrafficStats, udpGlobalTrafficStats, icmpGlobalTrafficStats;
  SecurityDeviceProbes securityPkts;

  TrafficCounter numEstablishedTCPConnections; /* = # really established connections */

  pthread_t pcapDispatchThreadId;

  HostsHashInfo hosts;

  /* ************************** */

  IPSession **sessions;
  u_int numSessions, maxNumSessions;

  /* ************************** */

  NetFlowGlobals *netflowGlobals; /* NetFlow */
  SflowGlobals *sflowGlobals; /* sFlow */

  /* ********************* */

  struct {
    PthreadMutex l7Mutex;
    struct ipoque_detection_module_struct *l7handler;
    Counter *protoTraffic;
  } l7;
} NtopInterface;

# 1531 "globals-structtypes.h"
struct llc {
  u_char dsap;
  u_char ssap;
  union {
    u_char u_ctl;
    u_short is_ctl;
    struct {
      u_char snap_ui;
      u_char snap_pi[5];
    } snap;
    struct {
      u_char snap_ui;
      u_char snap_orgcode[3];
      u_char snap_ethertype[2];
    } snap_ether;
  } ctl;
};

# 1571 "globals-structtypes.h"
typedef void(*VoidFunct)(u_char /* 0=term plugin, 1=term ntop */);

# 1572 "globals-structtypes.h"
typedef int(*IntFunct)(void);

# 1573 "globals-structtypes.h"
typedef void(*PluginFunct)(u_char *_deviceId, const struct pcap_pkthdr *h, const u_char *p);

# 1574 "globals-structtypes.h"
typedef void(*PluginHTTPFunct)(char* url);

# 1575 "globals-structtypes.h"
typedef void(*PluginCreateDeleteFunct)(HostTraffic*, u_short, u_char);

# 1577 "globals-structtypes.h"
typedef struct extraPage {
  /* url and description of extra page (if any) for a plugin */
  char *icon;
  char *url;
  char *descr;
} ExtraPage;

# 1584 "globals-structtypes.h"
typedef enum {
  NoViewNoConfigure = 0,
  ViewOnly,
  ConfigureOnly,
  ViewConfigure
} PluginViewConfigure;

# 1591 "globals-structtypes.h"
typedef struct pluginInfo {
  /* Plugin Info */
  char *pluginNtopVersion; /* Version of ntop for which the plugin was compiled */
  char *pluginName; /* Short plugin name (e.g. icmpPlugin) */
  char *pluginDescr; /* Long plugin description */
  char *pluginVersion;
  char *pluginAuthor;
  char *pluginURLname; /* Set it to NULL if the plugin doesn't speak HTTP */
  char activeByDefault; /* Set it to 1 if this plugin is active by default */
  PluginViewConfigure viewConfigureFlag;
  char inactiveSetup; /* Set it to 1 if this plugin can be called inactive for setup */
  IntFunct startFunct;
  VoidFunct termFunct;
  PluginFunct pluginFunct; /* Initialize here all the plugin structs... */
  PluginHTTPFunct httpFunct; /* Set it to NULL if the plugin doesn't speak HTTP */
  PluginCreateDeleteFunct crtDltFunct; /* Called whenever a host is created/deleted */
  char* bpfFilter; /* BPF filter for selecting packets that
				will be routed to the plugin */
  char *pluginStatusMessage;
  ExtraPage *extraPages; /* other pages this responds to */
} PluginInfo;

# 1613 "globals-structtypes.h"
typedef struct pluginStatus {
  PluginInfo *pluginPtr;
  void *pluginMemoryPtr; /* ptr returned by dlopen() */
  char activePlugin;
} PluginStatus;

# 1620 "globals-structtypes.h"
typedef struct flowFilterList {
  char* flowName;
  struct bpf_program *fcode; /* compiled filter code one for each device  */
  struct flowFilterList *next; /* next element (linked list) */
  TrafficCounter bytes, packets;
  PluginStatus pluginStatus;
} FlowFilterList;

# 1665 "globals-structtypes.h"
typedef struct transactionTime {
  u_int16_t transactionId;
  struct timeval theTime;
} TransactionTime;

# 1680 "globals-structtypes.h"
typedef struct badGuysAddr {
  HostAddr addr;
  time_t lastBadAccess;
  u_int16_t count;
} BadGuysAddr;

# 1693 "globals-structtypes.h"
struct tokenRing_header {
  u_int8_t trn_ac; /* access control field */
  u_int8_t trn_fc; /* field control field  */
  u_int8_t trn_dhost[6]; /* destination host     */
  u_int8_t trn_shost[6]; /* source host          */
  u_int16_t trn_rcf; /* route control field  */
  u_int16_t trn_rseg[8]; /* routing registers    */
};

# 1702 "globals-structtypes.h"
struct tokenRing_llc {
  u_int8_t dsap; /* destination SAP   */
  u_int8_t ssap; /* source SAP        */
  u_int8_t llc; /* LLC control field */
  u_int8_t protid[3]; /* protocol id       */
  u_int16_t ethType; /* ethertype field   */
};

# 1712 "globals-structtypes.h"
typedef struct anyHeader {
  u_int16_t pktType;
  u_int16_t llcAddressType;
  u_int16_t llcAddressLen;
  u_char ethAddress[6];
  u_int16_t pad;
  u_int16_t protoType;
} AnyHeader;

# 1746 "globals-structtypes.h"
typedef struct islHeader {
  u_char dstEthAddress[6];
  u_char srcEthAddress[6];
  u_int16_t len;
  u_int8_t dap, ssap, control;
  u_char hsa[3];
  u_int16_t vlanId, idx, notUsed;
} IslHeader;

# 1775 "globals-structtypes.h"
typedef enum {
  showAllHosts = 0,
  showOnlyLocalHosts,
  showOnlyRemoteHosts
} HostsDisplayPolicy;

# 1783 "globals-structtypes.h"
typedef enum {
  showSentReceived = 0,
  showOnlySent,
  showOnlyReceived
} LocalityDisplayPolicy;

# 1821 "globals-structtypes.h"
typedef struct _userPref {
  char *accessLogFile; /* -a |--access-log-file */
  u_int8_t enablePacketDecoding; /* -b | --disable-decoders */
  u_int8_t stickyHosts; /* -c | --sticky-hosts */
  u_int8_t daemonMode; /* -d | --daemon */
  int maxNumLines; /* -e | --max-table-rows */
  u_int8_t trackOnlyLocalHosts; /* -g | --track-local-hosts */
  char *devices; /* -i | --interface */
  char *pcapLog; /* -l | --pcap-log */
  char *localAddresses; /* -m | --local-subnets */
  DnsResolutionMode numericFlag; /* -n | --numeric-ip-addresses */
  char *protoSpecs; /* -p | --protocols */
  u_int8_t enableSuspiciousPacketDump; /* -q | --create-suspicious-packets */
  int refreshRate; /* -r | --refresh-time */
  u_int8_t disablePromiscuousMode; /* -s | --no-promiscuous */
  int traceLevel; /* -t | --trace-level */
  char *mapperURL; /* -U | --disable-mapper */
  u_int maxNumHashEntries; /* -x */
  u_int maxNumSessions; /* -X */
  char *webAddr; /* -w | --http-serveraddress[:port] */
  int webPort;
  int ipv4or6; /* -6 -4 */
  u_int8_t enableSessionHandling; /* -z | --disable-sessions */

  char *currentFilterExpression; /* -B | --filter-expression */
  u_short samplingRate; /* -C | --sampling-rate */
  char domainName[64 /* max length of hostname */]; /* -D | --domain */
  char *flowSpecs; /* -F | --flow-spec */

  u_int8_t debugMode; /* -K | --enable-debug */

  int useSyslog; /* -L | --use-syslog*/


  u_int8_t mergeInterfaces; /* -M | --no-interface-merge */
  u_int8_t enableL7; /* Enable/disable l7 protocol pattern matching */
  char *pcapLogBasePath; /* -O | --pcap-file-path */ /* Added by Ola Lundqvist <opal@debian.org>. */






  u_int8_t w3c; /* --w3c '136' */

  char *P3Pcp; /* --p3p-cp '137' */
  char *P3Puri; /* --p3p-uri '138' */

  char *instance; /* --instance '140' */
  char *logo;
  u_int8_t disableStopcap; /* --disable-stopcap '142' */

  u_int8_t disableMutexExtraInfo; /* --disable-mutexextrainfo '145' */
  u_int8_t disablenDPI; /* --disable-ndpi '146' */
  u_int8_t disablePython; /* --disable-python '147' */
  u_int8_t skipVersionCheck; /* --skip-version-check '150' */
  char *knownSubnets; /* --known-subnets '151' */
} UserPref;

# 1880 "globals-structtypes.h"
typedef struct ntopGlobals {
  /* How is ntop run? */

  char *program_name; /* The name the program was run with, stripped of any leading path */
  int basentoppid; /* Used for writing to /var/run/ntop.pid (or whatever) */

  int childntoppid; /* Zero unless we're in a child */


  char pidFileName[255 /* # chars in a file name */];


  char *startedAs; /* ACTUAL starting line, not the resolved one */

  int ntop_argc; /* # of command line arguments */
  char **ntop_argv; /* vector of command line arguments */

  /* search paths - set in globals-core.c from CFG_ constants set in ./configure */
  char **dataFileDirs;
  char **pluginDirs;
  char **configFileDirs;

  /* User-configurable parameters via the command line and the web page. */
  UserPref savedPref; /* this is what is saved */
  UserPref runningPref; /* this is what is currently used */

  char *effectiveUserName;
  int userId, groupId; /* 'u' */

  char *dbPath; /* 'P' */
  char *spoolPath; /* 'Q' */
  struct fileList *pcap_file_list; /* --pcap-file-list */
  /* Other flags (these could set via command line options one day) */

  HostsDisplayPolicy hostsDisplayPolicy;
  LocalityDisplayPolicy localityDisplayPolicy;
  int securityItemsLoaded;
  char *securityItems[64];

  /* Results flags - something we've learned */
  u_int8_t haveASN, haveVLANs;

  /* Physical and Logical network interfaces */
  pcap_if_t *allDevs; /* all devices available for pcap_open */
  u_short numDevices; /* total network interfaces */
  NtopInterface *device; /* pointer to the network interfaces table */

  /* Database */
  GDBM_FILE pwFile, prefsFile, macPrefixFile, fingerprintFile, serialFile, topTalkersFile, resolverCacheFile;

  /* the table of broadcast entries */
  HostTraffic *broadcastEntry;

  /* the table of other hosts entries */
  HostTraffic *otherHostEntry;

  /* Host serial */
  u_int32_t hostSerialCounter;

  /* Administrative */
  char *shortDomainName;

  BadGuysAddr weDontWantToTalkWithYou[3];


  /* Multi-thread related */
  unsigned short numThreads; /* # of running threads */

  pthread_t mainThreadId;

  /*
   * Purge database
   */
  pthread_t purgeDbThreadId;

  /*
   * HTS - Hash Purge
   */
  PthreadMutex purgeMutex;

  /*
   * HTS - Host Traffic Statistics
   */
  PthreadMutex hostsHashLockMutex;
  PthreadMutex hostsHashMutex[32*1024];
  volatile u_short hostsHashMutexNumLocks[32*1024];

  /* Host Serial */
  PthreadMutex serialLockMutex;

  /*
   * SIH - Scan Idle Hosts - optional
   */
  pthread_t scanIdleThreadId;

  /*
   * SFP - Scan Fingerprints
   */
  pthread_t scanFingerprintsThreadId;
  time_t nextFingerprintScan;


  /*
   * DNSAR - DNS Address Resolution - optional
   */
  PthreadMutex addressResolutionMutex;
  u_int numDequeueAddressThreads;
  pthread_t dequeueAddressThreadId[3];
  ConditionalVariable queueAddressCondvar;

  /*
   * Control mutexes
   */
  PthreadMutex gdbmMutex, portsMutex;
  PthreadMutex sessionsMutex[8];
  PthreadMutex purgePortsMutex;
  PthreadMutex securityItemsMutex;




  pthread_t handleWebConnectionsThreadId;

  /* SSL support */
# 2013 "globals-structtypes.h"
  /* ntop state - see flags in globals-defines.h */
  short ntopRunState;

  u_char resetHashNow; /* used for hash reset */

  /* Filter Chains */
  FlowFilterList *flowsList;

  /* Address Resolution */
  u_long dnsSniffCount,
    dnsSniffRequestCount,
    dnsSniffFailedCount,
    dnsSniffARPACount,
    dnsSniffStoredInCache;

  u_int addressQueuedCurrent, addressQueuedMax, addressUnresolvedDrops, resolvedAddresses, failedResolvedAddresses;





  /* Misc */
  char *separator; /* html separator */
  volatile unsigned long numHandledSIGPIPEerrors;
  u_short checkVersionStatus;
  time_t checkVersionStatusAgain;

  /* Purge */
  Counter numPurgedHosts, numTerminatedSessions;

  /* Time */
  int32_t thisZone; /* seconds offset from gmt to local time */
  time_t actTime, initialSniffTime, lastRefreshTime;
  struct timeval lastPktTime;

  /* Monitored Protocols */
  int numActServices; /* # of protocols being monitored (as stated by the protocol file) */
  ServiceEntry **udpSvc, **tcpSvc; /* the pointers to the tables of TCP/UDP Protocols to monitor */

  u_short numIpProtosToMonitor;
  char **ipTrafficProtosNames;

  /* Protocols */
  u_short numIpProtosList;
  ProtocolsList *ipProtosList;

  /* IP Ports */
  PortProtoMapperHandler ipPortMapper;

  /* Packet Capture */
  Counter receivedPackets, receivedPacketsProcessed, receivedPacketsQueued, receivedPacketsLostQ;

  TransactionTime transTimeHash[256];

  u_char dummyEthAddress[6];
  u_short *mtuSize, *headerSize;

  /* (Pseudo) Local Networks */
  NetworkStats localNetworks[64];
  u_short numLocalNetworks;

  /* All known Networks */
  NetworkStats subnetStats[128];
  u_short numKnownSubnets;





  u_char webInterfaceDisabled;
  int enableIdleHosts; /* Purging of idle hosts support enabled by default */
  int actualReportDeviceId;
  short columnSort, reportKind, sortFilter;
  int sock, newSock;




  int numChildren;

  /* rrd */
  char *rrdPath, *rrdVolatilePath;
  mode_t rrdDirectoryPermissions, rrdUmask;

  /* http.c */
  FILE *accessLogFd;
  unsigned long numHandledRequests[2];
  unsigned long numHandledBadrequests[2];
  unsigned long numSuccessfulRequests[2];
  unsigned long numUnsuccessfulInvalidrequests[2];
  unsigned long numUnsuccessfulInvalidmethod[2];
  unsigned long numUnsuccessfulInvalidversion[2];
  unsigned long numUnsuccessfulTimeout[2];
  unsigned long numUnsuccessfulNotfound[2];
  unsigned long numUnsuccessfulDenied[2];
  unsigned long numUnsuccessfulForbidden[2];
  unsigned long numSSIRequests,
                numBadSSIRequests,
                numHandledSSIRequests;
  u_short webServerRequestQueueLength;

  /* Hash table collisions - counted during use */
  int hashCollisionsLookup;

  /* Vendor lookup file */
  int numVendorLookupRead,
    numVendorLookupAdded,
    numVendorLookupAddedSpecial,
    numVendorLookupCalls,
    numVendorLookupSpecialCalls,
    numVendorLookupFound48bit,
    numVendorLookupFound24bit,
    numVendorLookupFoundMulticast,
    numVendorLookupFoundLAA;

  /* Memory usage */
  int piMem, ippmtmMem;

  /* LogView */
  char ** logView; /* vector of log messages */
  int logViewNext;
  PthreadMutex logViewMutex;

  int multipleVLANedHostCount;


  float queueBuffer[1024],
        processBuffer[1024];
  int queueBufferInit,
      queueBufferCount,
      processBufferInit,
      processBufferCount;
  float qmaxDelay, pmaxDelay;






  /* If the traffic is divided in cells (e.g. ATM, cell payload is 47 bytes) this is the cell lenght */
  u_int16_t cellLength;

  /* GeoIP */
  GeoIP *geo_ip_db, *geo_ip_asn_db;
  PthreadMutex geolocalizationMutex;

  /* Event Handling */
  u_int32_t event_mask;
  char *event_log;

  /* RRD */
  time_t rrdTime;

  /* Message display */
  u_char lowMemoryMsgShown;

  struct {
    u_short numSupportedProtocols;
    u_int16_t flow_struct_size, proto_size;
  } l7;
} NtopGlobals;

# 30 "globals-core.h"
extern NtopGlobals myGlobals;

# 62 "globals-core.h"
extern void _lowMemory(char *file, int line);

# 128 "globals-core.h"
extern void extend8021Qmtu(void);

# 156 "globals-core.h"
extern char* llcsap_string(u_char sap);

# 237 "globals-core.h"
extern void resetStats(int);

# 274 "globals-core.h"
extern void* ntop_safemalloc(unsigned int sz, char* file, int line);

# 471 "globals-core.h"
extern void updateThpt(int quickUpdate);

# 623 "globals-core.h"
extern int _accessMutex(PthreadMutex *mutexId, char* where, char* fileName, int fileLine);

# 626 "globals-core.h"
extern int _releaseMutex(PthreadMutex *mutexId, char* fileName, int fileLine);

# 675 "globals-core.h"
extern int getActualInterface(u_int);

# 684 "globals-core.h"
extern void traceEvent(int eventTraceLevel, char* file,
                       int line, char * format, ...);

# 804 "globals-core.h"
extern float timeval_subtract(struct timeval x, struct timeval y);

# 701 "pbuf.c"
static void flowsProcess(const struct pcap_pkthdr *h, const u_char *p, int deviceId) {
  FlowFilterList *list = myGlobals.flowsList;

  while(list != ((void *)0)) {







    if((list->pluginStatus.activePlugin) &&
       (list->fcode[deviceId].bf_insns != ((void *)0))) {
# 740 "pbuf.c"
      if(bpf_filter(list->fcode[deviceId].bf_insns, (u_char*)p, h->len, h->caplen)) {
        incrementTrafficCounter(&list->bytes, h->len);
        incrementTrafficCounter(&list->packets, 1);
        if(list->pluginStatus.pluginPtr != ((void *)0)) {
          void(*pluginFunct)(u_char*, const struct pcap_pkthdr*, const u_char*);

   pluginFunct = (void(*)(u_char *_deviceId, const struct pcap_pkthdr*,
     const u_char*))list->pluginStatus.pluginPtr->pluginFunct;
   pluginFunct((u_char*)&deviceId, h, p);
        }
      }
    }

    list = list->next;
  }
}

# 801 "pbuf.c"
void updateDevicePacketStats(u_int length, int actualDeviceId) {
  if(length <= 64) incrementTrafficCounter(&myGlobals.device[actualDeviceId].rcvdPktStats.upTo64, 1);
  else if(length <= 128) incrementTrafficCounter(&myGlobals.device[actualDeviceId].rcvdPktStats.upTo128, 1);
  else if(length <= 256) incrementTrafficCounter(&myGlobals.device[actualDeviceId].rcvdPktStats.upTo256, 1);
  else if(length <= 512) incrementTrafficCounter(&myGlobals.device[actualDeviceId].rcvdPktStats.upTo512, 1);
  else if(length <= 1024) incrementTrafficCounter(&myGlobals.device[actualDeviceId].rcvdPktStats.upTo1024, 1);
  else if(length <= 1518) incrementTrafficCounter(&myGlobals.device[actualDeviceId].rcvdPktStats.upTo1518, 1);






  else incrementTrafficCounter(&myGlobals.device[actualDeviceId].rcvdPktStats.above1518, 1);


  if((myGlobals.device[actualDeviceId].rcvdPktStats.shortest.value == 0)
     || (myGlobals.device[actualDeviceId].rcvdPktStats.shortest.value > length))
    myGlobals.device[actualDeviceId].rcvdPktStats.shortest.value = length;

  if(myGlobals.device[actualDeviceId].rcvdPktStats.longest.value < length)
    myGlobals.device[actualDeviceId].rcvdPktStats.longest.value = length;
}

# 827 "pbuf.c"
void dumpSuspiciousPacket(int actualDeviceId, const struct pcap_pkthdr *h, const u_char *p) {
  if((p == ((void *)0)) || (h == ((void *)0))) return;

  if(myGlobals.device[actualDeviceId].pcapErrDumper != ((void *)0)) {
    pcap_dump((u_char*)myGlobals.device[actualDeviceId].pcapErrDumper, h, p);
    traceEvent(3, "pbuf.c", 832, "Dumped %d bytes suspicious packet", h->caplen);
  }
}

# 854 "pbuf.c"
void processPacket(u_char *_deviceId,
     const struct pcap_pkthdr *h,
     const u_char *p) {
  struct ether_header ehdr;
  struct tokenRing_header *trp;
  u_int hlen, caplen = h->caplen;
  u_int headerDisplacement = 0, length = h->len;
  const u_char *orig_p = p, *p1;
  u_char *ether_src=((void *)0), *ether_dst=((void *)0);
  u_short eth_type=0;
  /* Token-Ring Strings */
  struct tokenRing_llc *trllc;
  int deviceId, actualDeviceId;
  u_int16_t vlanId=(u_int16_t)-1;
  static time_t lastUpdateThptTime = 0;

  AnyHeader *anyHeader;


  struct timeval pktStartOfProcessing,
    pktEndOfProcessing;
# 910 "pbuf.c"
  if(myGlobals.ntopRunState > 4)
    return;

  /*
    This allows me to fetch the time from
    the captured packet instead of calling
    time(NULL).
  */
  myGlobals.actTime = h->ts.tv_sec;

  deviceId = (int)((long)_deviceId);

  actualDeviceId = getActualInterface(deviceId);






  {
    float elapsed;
    gettimeofday(&pktStartOfProcessing, ((void *)0));
    elapsed = timeval_subtract(pktStartOfProcessing, h->ts);
    if(elapsed < 0) elapsed = 0;
    myGlobals.queueBuffer[++myGlobals.queueBufferCount & (1024 - 1)] = elapsed;
    if((myGlobals.device[actualDeviceId].ethernetPkts.value > 100) && (elapsed > myGlobals.qmaxDelay))
      myGlobals.qmaxDelay = elapsed;
  }
# 947 "pbuf.c"
  updateDevicePacketStats(length, actualDeviceId);

  incrementTrafficCounter(&myGlobals.device[actualDeviceId].ethernetPkts, 1);
  incrementTrafficCounter(&myGlobals.device[actualDeviceId].ethernetBytes, h->len);

  if(myGlobals.runningPref.mergeInterfaces && actualDeviceId != deviceId)
    incrementTrafficCounter(&myGlobals.device[deviceId].ethernetPkts, 1);

  if(myGlobals.device[actualDeviceId].pcapDumper != ((void *)0))
    pcap_dump((u_char*)myGlobals.device[actualDeviceId].pcapDumper, h, p);

  if((myGlobals.device[deviceId].mtuSize != 65355) &&
     (length > myGlobals.device[deviceId].mtuSize) ) {
    /* Sanity check */
    if(myGlobals.runningPref.enableSuspiciousPacketDump) {
      traceEvent(2, "pbuf.c", 962, "Packet # %u too long (len = %u)!",
   (unsigned int)myGlobals.device[deviceId].ethernetPkts.value,
   (unsigned int)length);
      dumpSuspiciousPacket(actualDeviceId, h, p);
    }

    /* Fix below courtesy of Andreas Pfaller <apfaller@yahoo.com.au> */
    length = myGlobals.device[deviceId].mtuSize;
    incrementTrafficCounter(&myGlobals.device[actualDeviceId].rcvdPktStats.tooLong, 1);
  }





  /* Note: The code below starts by assuming that if we haven't captured at
   * least an Ethernet frame header's worth of bytes we drop the packet.
   * This might be a bad assumption - why aren't we using the DLT_ derived fields?
   * e.g.: hlen = myGlobals.device[deviceId].headerSize;
   * Also, we probably should account for these runt packets - both count the
   * # of packets and the associated # of bytes.
   */

  hlen = (u_int)((myGlobals.device[deviceId].datalink == 0 /* BSD loopback encapsulation */) ? 4 : sizeof(struct ether_header));

  if(!myGlobals.initialSniffTime && (myGlobals.pcap_file_list != ((void *)0))) {
    myGlobals.initialSniffTime = h->ts.tv_sec;
    myGlobals.device[deviceId].lastThptUpdate = myGlobals.device[deviceId].lastMinThptUpdate =
      myGlobals.device[deviceId].lastHourThptUpdate = myGlobals.device[deviceId].lastFiveMinsThptUpdate = myGlobals.initialSniffTime;
  }

  memcpy(&myGlobals.lastPktTime, &h->ts, sizeof(myGlobals.lastPktTime));

  if(caplen >= hlen) {
    HostTraffic *srcHost = ((void *)0), *dstHost = ((void *)0);

    memcpy(&ehdr, p, sizeof(struct ether_header));

    switch(myGlobals.device[deviceId].datalink) {

    case 113 /* Linux 'any' device */: /* Linux 'any' device */
      anyHeader = (AnyHeader*)p;
      length -= sizeof(AnyHeader); /* don't count nullhdr */
      eth_type = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (anyHeader->protoType); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));






      ether_src = ether_dst = myGlobals.dummyEthAddress;
      processIpPkt(p+sizeof(AnyHeader), h, p, sizeof(struct ether_header), length,
     ether_src, ether_dst, actualDeviceId, vlanId);
      break;


    case 0 /* BSD loopback encapsulation */: /* loopaback interface */
      /*
	Support for ethernet headerless interfaces (e.g. lo0)
	Courtesy of Martin Kammerhofer <dada@sbox.tu-graz.ac.at>
      */

      length -= 4; /* don't count nullhdr */

      /* All this crap is due to the old little/big endian story... */
      if(((p[0] == 0) && (p[1] == 0) && (p[2] == 8) && (p[3] == 0))
  || ((p[0] == 2) && (p[1] == 0) && (p[2] == 0) && (p[3] == 0)) /* OSX */)
 eth_type = 0x0800 /* IP */;
      else if(((p[0] == 0) && (p[1] == 0) && (p[2] == 0x86) && (p[3] == 0xdd))
       || ((p[0] == 0x1E) && (p[1] == 0) && (p[2] == 0) && (p[3] == 0)) /* OSX */)
 eth_type = 0x86DD;
      else {
 // traceEvent(CONST_TRACE_INFO, "[%d][%d][%d][%d]", p[0], p[1], p[2], p[3]);
      }
      ether_src = ether_dst = myGlobals.dummyEthAddress;
      break;

    case 9 /* Point-to-point Protocol */:
      headerDisplacement = 4;
      /*
	PPP is like RAW IP. The only difference is that PPP
	has a header that's not present in RAW IP.

	IMPORTANT: DO NOT PUT A break BELOW this comment
      */

    case 12 /* raw IP */: /* RAW IP (no ethernet header) */
      length -= headerDisplacement; /* don't count PPP header */
      ether_src = ether_dst = ((void *)0);
      processIpPkt(p+headerDisplacement, h, p, sizeof(struct ether_header),
     length, ((void *)0), ((void *)0), actualDeviceId, vlanId);
      break;

    case 6 /* 802.5 Token Ring */: /* Token Ring */
      trp = (struct tokenRing_header*)p;
      ether_src = (u_char*)trp->trn_shost, ether_dst = (u_char*)trp->trn_dhost;

      hlen = sizeof(struct tokenRing_header) - 18;

      if(trp->trn_shost[0] & 0x80) /* Source Routed Packet */
 hlen += (((__extension__ ({ unsigned short int __v, __x = (unsigned short int) (trp->trn_rcf); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) & 0x1f00) >> 8);

      length -= hlen, caplen -= hlen;

      p += hlen;
      trllc = (struct tokenRing_llc *)p;

      if(trllc->dsap == 0xAA && trllc->ssap == 0xAA)
 hlen = sizeof(struct tokenRing_llc);
      else
 hlen = sizeof(struct tokenRing_llc) - 5;

      length -= hlen, caplen -= hlen;

      p += hlen;

      if(hlen == sizeof(struct tokenRing_llc))
 eth_type = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (trllc->ethType); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
      else
 eth_type = 0;
      break;

    default:
      eth_type = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (ehdr.ether_type); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
      /*
	NOTE:
	eth_type is a 32 bit integer (eg. 0x0800). If the first
	byte is NOT null (08 in the example below) then this is
	a Ethernet II frame, otherwise is a IEEE 802.3 Ethernet
	frame.
      */
      ether_src = ((&ehdr)->ether_shost), ether_dst = ((&ehdr)->ether_dhost);

      if(eth_type == 0x8100) /* VLAN */ {
 Ether80211q qType;

 memcpy(&qType, p+sizeof(struct ether_header), sizeof(Ether80211q));
 vlanId = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (qType.vlanId); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) & 0xFFF;



 eth_type = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (qType.protoType); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 hlen += 4; /* Skip the 802.1q header */

        if(myGlobals.device[deviceId].hasVLANs != 1) {
          myGlobals.device[deviceId].hasVLANs = 1;
          myGlobals.haveVLANs = 1;

          traceEvent(4, "pbuf.c", 1110,
                     "Device %s(%d) MTU adjusted for 802.1q VLAN",
                     myGlobals.device[deviceId].name,
                     deviceId);
          extend8021Qmtu();
          myGlobals.device[deviceId].rcvdPktStats.tooLong.value = 0l;

        }
      } else if(eth_type == 0x8847 /* MPLS protocol */) /* MPLS */ {
 char bos; /* bottom_of_stack */
 u_char mplsLabels[10][3];
 int numMplsLabels = 0;

 memset(mplsLabels, 0, sizeof(mplsLabels));
 bos = 0;
 while(bos == 0) {
   memcpy(&mplsLabels[numMplsLabels], p+hlen, 3);

   bos = (mplsLabels[numMplsLabels][2] & 0x1), hlen += 4, numMplsLabels++;
   if((hlen > caplen) || (numMplsLabels >= 10))
     return; /* bad packet */
 }

 eth_type = 0x0800 /* IP */;
      } else if((ether_dst[0] == 0x01) && (ether_dst[1] == 0x00)
  && (ether_dst[2] == 0x0C) && (ether_dst[3] == 0x00)
  && (ether_dst[4] == 0x00) && (ether_dst[5] == 0x00)) {
 /*
	  Cisco InterSwitch Link (ISL) Protocol

	  This is basically the Cisco proprietary VLAN tagging (vs. the standard 802.1q)
	  http://www.cisco.com/univercd/cc/td/doc/product/lan/trsrb/frames.htm
	*/
 IslHeader islHdr;

 memcpy(&islHdr, p, sizeof(IslHeader));
 vlanId = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (islHdr.vlanId); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 hlen = sizeof(IslHeader); /* Skip the ISL header */
 memcpy(&ehdr, p+hlen, sizeof(struct ether_header));
 hlen += (u_int)sizeof(struct ether_header);
 ether_src = ((&ehdr)->ether_shost), ether_dst = ((&ehdr)->ether_dhost);
 eth_type = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (ehdr.ether_type); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
      }
    } /* switch(myGlobals.device[deviceId].datalink) */

    if((myGlobals.device[deviceId].datalink != 9 /* Point-to-point Protocol */)
       && (myGlobals.device[deviceId].datalink != 12 /* raw IP */)
       && (myGlobals.device[deviceId].datalink != 113 /* Linux 'any' device */)) {
      if((myGlobals.device[deviceId].datalink == 6 /* 802.5 Token Ring */) && (eth_type < 1500 /* Max. octets in payload	 */)) {
 TrafficCounter ctr;

 trp = (struct tokenRing_header*)orig_p;
 ether_src = (u_char*)trp->trn_shost, ether_dst = (u_char*)trp->trn_dhost;
 srcHost = _lookupHost(((void *)0), ether_src, vlanId, 0, 0, actualDeviceId, "pbuf.c", 1163, h, p);
 if(srcHost == ((void *)0)) {
   /* Sanity check */
   _lowMemory("pbuf.c", 1166);
   return;
 } else {
   _lockHostsHashMutex(srcHost, "processPacket-src-2", "pbuf.c", 1169);
 }

 dstHost = _lookupHost(((void *)0), ether_dst, vlanId, 0, 0, actualDeviceId, "pbuf.c", 1172, h, p);
 if(dstHost == ((void *)0)) {
   /* Sanity check */
   _lowMemory("pbuf.c", 1175);
   _unlockHostsHashMutex(srcHost, "pbuf.c", 1176);
   return;
 } else {
   _lockHostsHashMutex(dstHost, "processPacket-dst-2", "pbuf.c", 1179);
 }

 if(vlanId != (u_int16_t)-1) { srcHost->vlanId = vlanId; dstHost->vlanId = vlanId; }

 { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1184);; if(srcHost->nonIPTraffic == ((void *)0)) srcHost->nonIPTraffic = ntop_safecalloc((size_t)sizeof(NonIPTraffic), (size_t)1, (char*)"pbuf.c", (int)1184); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1184);; };
 { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1185);; if(dstHost->nonIPTraffic == ((void *)0)) dstHost->nonIPTraffic = ntop_safecalloc((size_t)sizeof(NonIPTraffic), (size_t)1, (char*)"pbuf.c", (int)1185); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1185);; };
 if((srcHost->nonIPTraffic == ((void *)0)) || (dstHost->nonIPTraffic == ((void *)0))) return;

 { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1188);; incrementTrafficCounter(&srcHost->nonIPTraffic->otherSent, length); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1188);; };
 { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1189);; incrementTrafficCounter(&dstHost->nonIPTraffic->otherRcvd, length); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1189);; };
 incrementUnknownProto(srcHost, 0 /* sent */, eth_type /* eth */, 0 /* dsap */, 0 /* ssap */, 0 /* ip */);
 incrementUnknownProto(dstHost, 1 /* rcvd */, eth_type /* eth */, 0 /* dsap */, 0 /* ssap */, 0 /* ip */);

 ctr.value = length;

 /*
	  Even if this is probably not IP the hostIpAddress field is
	  fine because it is not used in this special case and I need
	  a placeholder here.
	*/
 updatePacketCount(srcHost, dstHost, ctr, 1, actualDeviceId);
      } else if((myGlobals.device[deviceId].datalink != 6 /* 802.5 Token Ring */)
  && (eth_type <= 1500 /* Max. octets in payload	 */) && (length > 3)) {
 /* The code below has been taken from tcpdump */
 u_char sap_type;
 struct llc llcHeader;
 char etherbuf[sizeof("00:00:00:00:00:00")];

 if((ether_dst != ((void *)0))
    && (__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (etheraddr_string(ether_dst, etherbuf)) && __builtin_constant_p ("FF:FF:FF:FF:FF:FF") && (__s1_len = __builtin_strlen (etheraddr_string(ether_dst, etherbuf)), __s2_len = __builtin_strlen ("FF:FF:FF:FF:FF:FF"), (!((size_t)(const void *)((etheraddr_string(ether_dst, etherbuf)) + 1) - (size_t)(const void *)(etheraddr_string(ether_dst, etherbuf)) == 1) || __s1_len >= 4) && (!((size_t)(const void *)(("FF:FF:FF:FF:FF:FF") + 1) - (size_t)(const void *)("FF:FF:FF:FF:FF:FF") == 1) || __s2_len >= 4)) ? __builtin_strcmp (etheraddr_string(ether_dst, etherbuf), "FF:FF:FF:FF:FF:FF") : (__builtin_constant_p (etheraddr_string(ether_dst, etherbuf)) && ((size_t)(const void *)((etheraddr_string(ether_dst, etherbuf)) + 1) - (size_t)(const void *)(etheraddr_string(ether_dst, etherbuf)) == 1) && (__s1_len = __builtin_strlen (etheraddr_string(ether_dst, etherbuf)), __s1_len < 4) ? (__builtin_constant_p ("FF:FF:FF:FF:FF:FF") && ((size_t)(const void *)(("FF:FF:FF:FF:FF:FF") + 1) - (size_t)(const void *)("FF:FF:FF:FF:FF:FF") == 1) ? __builtin_strcmp (etheraddr_string(ether_dst, etherbuf), "FF:FF:FF:FF:FF:FF") : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) ("FF:FF:FF:FF:FF:FF"); int __result = (((const unsigned char *) (const char *) (etheraddr_string(ether_dst, etherbuf)))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (etheraddr_string(ether_dst, etherbuf)))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (etheraddr_string(ether_dst, etherbuf)))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (etheraddr_string(ether_dst, etherbuf)))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p ("FF:FF:FF:FF:FF:FF") && ((size_t)(const void *)(("FF:FF:FF:FF:FF:FF") + 1) - (size_t)(const void *)("FF:FF:FF:FF:FF:FF") == 1) && (__s2_len = __builtin_strlen ("FF:FF:FF:FF:FF:FF"), __s2_len < 4) ? (__builtin_constant_p (etheraddr_string(ether_dst, etherbuf)) && ((size_t)(const void *)((etheraddr_string(ether_dst, etherbuf)) + 1) - (size_t)(const void *)(etheraddr_string(ether_dst, etherbuf)) == 1) ? __builtin_strcmp (etheraddr_string(ether_dst, etherbuf), "FF:FF:FF:FF:FF:FF") : (- (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (etheraddr_string(ether_dst, etherbuf)); int __result = (((const unsigned char *) (const char *) ("FF:FF:FF:FF:FF:FF"))[0] - __s2[0]); if (__s2_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) ("FF:FF:FF:FF:FF:FF"))[1] - __s2[1]); if (__s2_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) ("FF:FF:FF:FF:FF:FF"))[2] - __s2[2]); if (__s2_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) ("FF:FF:FF:FF:FF:FF"))[3] - __s2[3]); } } __result; })))) : __builtin_strcmp (etheraddr_string(ether_dst, etherbuf), "FF:FF:FF:FF:FF:FF")))); }) == 0)
    && (p[sizeof(struct ether_header)] == 0xff)
    && (p[sizeof(struct ether_header)+1] == 0xff)
    && (p[sizeof(struct ether_header)+4] == 0x0)) {
   srcHost = _lookupHost(((void *)0), ether_src, vlanId, 0, 0, actualDeviceId, "pbuf.c", 1213, h, p);
   if(srcHost == ((void *)0)) {
     /* Sanity check */
     _lowMemory("pbuf.c", 1216);
     return;
   } else {
     _lockHostsHashMutex(srcHost, "processPacket-src-3", "pbuf.c", 1219);
   }

   dstHost = _lookupHost(((void *)0), ether_dst, vlanId, 0, 0, actualDeviceId, "pbuf.c", 1222, h, p);
   if(dstHost == ((void *)0)) {
     /* Sanity check */
     _lowMemory("pbuf.c", 1225);
     _unlockHostsHashMutex(srcHost, "pbuf.c", 1226);
     return;
   } else {
     _lockHostsHashMutex(dstHost, "processPacket-dst-3", "pbuf.c", 1229);
   }

   if(vlanId != (u_int16_t)-1) { srcHost->vlanId = vlanId; dstHost->vlanId = vlanId; }

   { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1234);; if(srcHost->nonIPTraffic == ((void *)0)) srcHost->nonIPTraffic = ntop_safecalloc((size_t)sizeof(NonIPTraffic), (size_t)1, (char*)"pbuf.c", (int)1234); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1234);; };
   { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1235);; if(dstHost->nonIPTraffic == ((void *)0)) dstHost->nonIPTraffic = ntop_safecalloc((size_t)sizeof(NonIPTraffic), (size_t)1, (char*)"pbuf.c", (int)1235); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1235);; };
   if((srcHost->nonIPTraffic == ((void *)0)) || (dstHost->nonIPTraffic == ((void *)0))) return;
 } else {
   /* MAC addresses are meaningful here */
   srcHost = _lookupHost(((void *)0), ether_src, vlanId, 0, 0, actualDeviceId, "pbuf.c", 1239, h, p);
   dstHost = _lookupHost(((void *)0), ether_dst, vlanId, 0, 0, actualDeviceId, "pbuf.c", 1240, h, p);

   if((srcHost == ((void *)0)) || (dstHost == ((void *)0))) return;

   { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1244);; if(srcHost->nonIPTraffic == ((void *)0)) srcHost->nonIPTraffic = ntop_safecalloc((size_t)sizeof(NonIPTraffic), (size_t)1, (char*)"pbuf.c", (int)1244); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1244);; };
   { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1245);; if(dstHost->nonIPTraffic == ((void *)0)) dstHost->nonIPTraffic = ntop_safecalloc((size_t)sizeof(NonIPTraffic), (size_t)1, (char*)"pbuf.c", (int)1245); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1245);; };
   if((srcHost->nonIPTraffic == ((void *)0)) || (dstHost->nonIPTraffic == ((void *)0))) return;

   if((srcHost != ((void *)0)) && (dstHost != ((void *)0))) {
     TrafficCounter ctr;
     int llcLen;

     _lockHostsHashMutex(srcHost, "processPacket-src-4", "pbuf.c", 1252);
     _lockHostsHashMutex(dstHost, "processPacket-dst-4", "pbuf.c", 1253);
     if(vlanId != (u_int16_t)-1) { srcHost->vlanId = vlanId; dstHost->vlanId = vlanId; }
     p1 = (u_char*)(p+hlen);

     /* Watch out for possible alignment problems */
     llcLen = (int)((length) < (sizeof(llcHeader)) ? (length) : (sizeof(llcHeader)));
     memcpy(&llcHeader, (char*)p1, llcLen);

     sap_type = llcHeader.ssap & ~1;
     llcsap_string(sap_type);

     if((sap_type == 0xAA /* SNAP */)
        && (llcHeader.ctl.snap_ether.snap_orgcode[0] == 0x0)
        && (llcHeader.ctl.snap_ether.snap_orgcode[1] == 0x0)
        && (llcHeader.ctl.snap_ether.snap_orgcode[2] == 0xc) /* 0x00000C = Cisco */
        && (llcHeader.ctl.snap_ether.snap_ethertype[0] == 0x20)
        && (llcHeader.ctl.snap_ether.snap_ethertype[1] == 0x00) /* 0x2000 Cisco Discovery Protocol */
        ) {
       u_char *cdp;
       int cdp_idx = 0;

       cdp = (u_char*)(p+hlen+llcLen);

       if(cdp[cdp_idx] == 0x02) {
  /* CDP v2 */
  struct cdp_element {
    u_int16_t cdp_type;
    u_int16_t cdp_len;
    // u_char cdp_content[255];
  };

  cdp_idx = 4;
  while((cdp_idx+sizeof(struct cdp_element)) < (length-(hlen+llcLen))) {
    struct cdp_element element;

      memcpy(&element, &cdp[cdp_idx], sizeof(struct cdp_element));

    cdp_idx += (int)sizeof(struct cdp_element);
    element.cdp_len = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (element.cdp_len); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    element.cdp_type = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (element.cdp_type); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    if(element.cdp_len == 0) break; /* Sanity check */

    switch(element.cdp_type) {
    case 0x0001: /* Device Id */
      if((srcHost->hostResolvedName[0] == '\0')
         || (__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (srcHost->hostResolvedName) && __builtin_constant_p (srcHost->hostNumIpAddress) && (__s1_len = __builtin_strlen (srcHost->hostResolvedName), __s2_len = __builtin_strlen (srcHost->hostNumIpAddress), (!((size_t)(const void *)((srcHost->hostResolvedName) + 1) - (size_t)(const void *)(srcHost->hostResolvedName) == 1) || __s1_len >= 4) && (!((size_t)(const void *)((srcHost->hostNumIpAddress) + 1) - (size_t)(const void *)(srcHost->hostNumIpAddress) == 1) || __s2_len >= 4)) ? __builtin_strcmp (srcHost->hostResolvedName, srcHost->hostNumIpAddress) : (__builtin_constant_p (srcHost->hostResolvedName) && ((size_t)(const void *)((srcHost->hostResolvedName) + 1) - (size_t)(const void *)(srcHost->hostResolvedName) == 1) && (__s1_len = __builtin_strlen (srcHost->hostResolvedName), __s1_len < 4) ? (__builtin_constant_p (srcHost->hostNumIpAddress) && ((size_t)(const void *)((srcHost->hostNumIpAddress) + 1) - (size_t)(const void *)(srcHost->hostNumIpAddress) == 1) ? __builtin_strcmp (srcHost->hostResolvedName, srcHost->hostNumIpAddress) : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (srcHost->hostNumIpAddress); int __result = (((const unsigned char *) (const char *) (srcHost->hostResolvedName))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (srcHost->hostResolvedName))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (srcHost->hostResolvedName))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (srcHost->hostResolvedName))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p (srcHost->hostNumIpAddress) && ((size_t)(const void *)((srcHost->hostNumIpAddress) + 1) - (size_t)(const void *)(srcHost->hostNumIpAddress) == 1) && (__s2_len = __builtin_strlen (srcHost->hostNumIpAddress), __s2_len < 4) ? (__builtin_constant_p (srcHost->hostResolvedName) && ((size_t)(const void *)((srcHost->hostResolvedName) + 1) - (size_t)(const void *)(srcHost->hostResolvedName) == 1) ? __builtin_strcmp (srcHost->hostResolvedName, srcHost->hostNumIpAddress) : (- (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (srcHost->hostResolvedName); int __result = (((const unsigned char *) (const char *) (srcHost->hostNumIpAddress))[0] - __s2[0]); if (__s2_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (srcHost->hostNumIpAddress))[1] - __s2[1]); if (__s2_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (srcHost->hostNumIpAddress))[2] - __s2[2]); if (__s2_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (srcHost->hostNumIpAddress))[3] - __s2[3]); } } __result; })))) : __builtin_strcmp (srcHost->hostResolvedName, srcHost->hostNumIpAddress)))); }))) {
        u_short tmpStrLen = ((element.cdp_len-4) < (128 -1) ? (element.cdp_len-4) : (128 -1));
        strncpy(srcHost->hostResolvedName, (char*)&cdp[cdp_idx], tmpStrLen);
        srcHost->hostResolvedName[tmpStrLen] = '\0';
      }
      break;
    case 0x0002: /* Addresses */
      break;
    case 0x0003: /* Port Id */
      break;
    case 0x0004: /* Capabilities */
      break;
    case 0x0005: /* Sw Version */
      if(srcHost->description == ((void *)0)) {
        char *tmpStr;
        u_short tmpStrLen = ((element.cdp_len-4) < (255) ? (element.cdp_len-4) : (255))+1;

        tmpStr = (char*)ntop_safemalloc((unsigned int)tmpStrLen, (char*)"pbuf.c", (int)1315);
        memcpy(tmpStr, &cdp[cdp_idx], tmpStrLen-2);
        tmpStr[tmpStrLen-1] = '\0';
        srcHost->description = tmpStr;
      }
      break;
    case 0x0006: /* Platform */
      if(srcHost->fingerprint == ((void *)0)) {
        char *tmpStr;
        u_short tmpStrLen = ((element.cdp_len-4) < (64) ? (element.cdp_len-4) : (64))+2;

        tmpStr = (char*)ntop_safemalloc((unsigned int)tmpStrLen, (char*)"pbuf.c", (int)1326);
        tmpStr[0] = ':';
        memcpy(&tmpStr[1], &cdp[cdp_idx], tmpStrLen-2);
        tmpStr[tmpStrLen-1] = '\0';
        srcHost->fingerprint = tmpStr;
        srcHost->hwModel = ntop_safestrdup(&tmpStr[1], (char*)"pbuf.c", (int)1331);
      }
      break;
    case 0x0008: /* Cluster Management */
      break;
    case 0x0009: /* VTP Management Domain */
      break;
    }

    cdp_idx += (int)(element.cdp_len-sizeof(struct cdp_element));
  }


  if(srcHost->fingerprint == ((void *)0))
    srcHost->fingerprint = ntop_safestrdup(":Cisco", (char*)"pbuf.c", (int)1345); /* Default */
       }
     }

     if(sap_type != 0x42 /* !STP */) {
       addNonIpTrafficInfo(srcHost, sap_type, length, 0 /* sent */);
       addNonIpTrafficInfo(dstHost, sap_type, length, 1 /* rcvd */);
     }

     if(sap_type == 0x42 /* STP */) {
       /* Spanning Tree */

       { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1357);; incrementTrafficCounter(&srcHost->nonIPTraffic->stpSent, length); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1357);; };
       { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1358);; incrementTrafficCounter(&dstHost->nonIPTraffic->stpRcvd, length); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1358);; };
       setHostFlag(19, srcHost);
       incrementTrafficCounter(&myGlobals.device[actualDeviceId].stpBytes, length);
     } else if((llcHeader.ssap == 0xf0) && (llcHeader.dsap == 0xf0)) {
       /* Netbios */
       { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1363);; incrementTrafficCounter(&srcHost->nonIPTraffic->netbiosSent, length); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1363);; };
       { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1364);; incrementTrafficCounter(&dstHost->nonIPTraffic->netbiosRcvd, length); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1364);; };
       incrementTrafficCounter(&myGlobals.device[actualDeviceId].netbiosBytes, length);
     } else if(sap_type == 0xAA /* SNAP */) {
       u_int16_t snapType;

       p1 = (u_char*)(p1+sizeof(llcHeader));
       memcpy(&snapType, p1, sizeof(snapType));

       snapType = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (snapType); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
       /*
		See section
		"ETHERNET NUMBERS OF INTEREST" in RFC 1060

		http://www.faqs.org/rfcs/rfc1060.html
	      */
       if((llcHeader.ctl.snap_ether.snap_orgcode[0] == 0x0)
   && (llcHeader.ctl.snap_ether.snap_orgcode[1] == 0x0)
   && (llcHeader.ctl.snap_ether.snap_orgcode[2] == 0x0C) /* Cisco */) {
  /* NOTE:
		   If llcHeader.ctl.snap_ether.snap_ethertype[0] == 0x20
		   && llcHeader.ctl.snap_ether.snap_ethertype[1] == 0x0
		   this is Cisco Discovery Protocol
		*/

  setHostFlag(6 /* used as a gateway */, srcHost);
       }

       { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1391);; incrementTrafficCounter(&srcHost->nonIPTraffic->otherSent, length); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1391);; };
       { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1392);; incrementTrafficCounter(&dstHost->nonIPTraffic->otherRcvd, length); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1392);; };
       incrementTrafficCounter(&myGlobals.device[actualDeviceId].otherBytes, length);

       incrementUnknownProto(srcHost, 0 /* sent */, 0 /* eth */, llcHeader.dsap /* dsap */,
        llcHeader.ssap /* ssap */, 0 /* ip */);
       incrementUnknownProto(dstHost, 1 /* rcvd */, 0 /* eth */, llcHeader.dsap /* dsap */,
        llcHeader.ssap /* ssap */, 0 /* ip */);
     } else {
       /* Unknown Protocol */
# 1409 "pbuf.c"
       incrementTrafficCounter(&myGlobals.device[actualDeviceId].otherBytes, length);
       incrementUnknownProto(srcHost, 0 /* sent */, 0 /* eth */, llcHeader.dsap /* dsap */,
        llcHeader.ssap /* ssap */, 0 /* ip */);
       incrementUnknownProto(dstHost, 1 /* rcvd */, 0 /* eth */, llcHeader.dsap /* dsap */,
        llcHeader.ssap /* ssap */, 0 /* ip */);
     }

     ctr.value = length;
     /*
	      Even if this is not IP the hostIpAddress field is
	      fine because it is not used in this special case and I need
	      a placeholder here.
	    */
     updatePacketCount(srcHost, dstHost, ctr, 1, actualDeviceId);
   }
 }
      } else if((eth_type == 0x0800 /* IP */) || (eth_type == 0x86DD)) {
 TrafficCounter ctr;

 srcHost = _lookupHost(((void *)0), ether_src, vlanId, 0, 0, actualDeviceId, "pbuf.c", 1428, h, p);
 dstHost = _lookupHost(((void *)0), ether_dst, vlanId, 0, 0, actualDeviceId, "pbuf.c", 1429, h, p);

 if((srcHost == ((void *)0)) || (dstHost == ((void *)0))) {
   /* Sanity check */
   _lowMemory("pbuf.c", 1433);
   return;
 }

 _lockHostsHashMutex(srcHost, "processPacket-src-6", "pbuf.c", 1437); _lockHostsHashMutex(dstHost, "processPacket-dst-ip", "pbuf.c", 1437);
 { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1438);; incrementTrafficCounter(&srcHost->pktsSent, 1); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1438);; }; { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1438);; incrementTrafficCounter(&srcHost->bytesSent, h->len); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1438);; };
 { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1439);; incrementTrafficCounter(&dstHost->pktsRcvd, 1); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1439);; }; { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1439);; incrementTrafficCounter(&dstHost->bytesRcvd, h->len); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1439);; };

 ctr.value = h->len;
 updatePacketCount(srcHost, dstHost, ctr, 1, actualDeviceId);

 if((myGlobals.device[deviceId].datalink == 6 /* 802.5 Token Ring */) && (eth_type > 1500 /* Max. octets in payload	 */)) {
   processIpPkt(p, h, orig_p, hlen, length, ether_src, ether_dst, actualDeviceId, vlanId);
 } else {
   processIpPkt(p+hlen, h, orig_p, hlen, length, ether_src, ether_dst, actualDeviceId, vlanId);
 }
      } else if(eth_type == 0x8864) /* PPPOE */ {
        /* PPPoE - Courtesy of Andreas Pfaller Feb20032
         *   This strips the PPPoE encapsulation for traffic transiting the network.
         */
        struct pppoe_hdr *pppoe_hdr=(struct pppoe_hdr *) (p+hlen);
        int protocol=(__extension__ ({ unsigned short int __v, __x = (unsigned short int) (*((int *) (p+hlen+6))); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

        if(pppoe_hdr->ver==1 && pppoe_hdr->type==1 && pppoe_hdr->code==0 &&
    protocol==0x0021) {
          hlen+=8; /* length of pppoe header */
   processIpPkt(p+hlen, h, orig_p, hlen, length, ((void *)0), ((void *)0), actualDeviceId, vlanId);
        }
      } else {
   /* MAC addresses are meaningful here */
   struct ether_arp arpHdr;
   HostAddr addr;
   TrafficCounter ctr;

   if(length > hlen)
     length -= hlen;
   else
     length = 0;

   srcHost = _lookupHost(((void *)0), ether_src, vlanId, 0, 0, actualDeviceId, "pbuf.c", 1472, h, p);
   if(srcHost == ((void *)0)) {
     /* Sanity check */
     _lowMemory("pbuf.c", 1475);
     return;
   } else {
     _lockHostsHashMutex(srcHost, "processPacket-src-5", "pbuf.c", 1478);
     { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1479);; if(srcHost->nonIPTraffic == ((void *)0)) srcHost->nonIPTraffic = ntop_safecalloc((size_t)sizeof(NonIPTraffic), (size_t)1, (char*)"pbuf.c", (int)1479); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1479);; };
     if(srcHost->nonIPTraffic == ((void *)0)) {
       _unlockHostsHashMutex(srcHost, "pbuf.c", 1481);
       return;
     }
   }

   dstHost = _lookupHost(((void *)0), ether_dst, vlanId, 0, 0, actualDeviceId, "pbuf.c", 1486, h, p);
   if(dstHost == ((void *)0)) {
     /* Sanity check */
     _lowMemory("pbuf.c", 1489);
     _unlockHostsHashMutex(srcHost, "pbuf.c", 1490);
     return;
   } else {
     /* traceEvent(CONST_TRACE_INFO, "lockHostsHashMutex()"); */
     _lockHostsHashMutex(dstHost, "processPacket-src-5", "pbuf.c", 1494);
     { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1495);; if(dstHost->nonIPTraffic == ((void *)0)) dstHost->nonIPTraffic = ntop_safecalloc((size_t)sizeof(NonIPTraffic), (size_t)1, (char*)"pbuf.c", (int)1495); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1495);; };
     if(dstHost->nonIPTraffic == ((void *)0)) {
       _unlockHostsHashMutex(srcHost, "pbuf.c", 1497), _unlockHostsHashMutex(dstHost, "pbuf.c", 1497);
       return;
     }
   }

   if(vlanId != (u_int16_t)-1) { srcHost->vlanId = vlanId; dstHost->vlanId = vlanId; }

   switch(eth_type) {
   case 0x0806 /* Address resolution */: /* ARP - Address resolution Protocol */
     memcpy(&arpHdr, p+hlen, sizeof(arpHdr));

     hlen += (u_int)sizeof(arpHdr);

     if(((u_short)(__extension__ ({ unsigned short int __v, __x = (unsigned short int) (*(u_short *)(&arpHdr.ea_hdr.ar_pro)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))) == 0x0800 /* IP */) {
       int arpOp = ((u_short)(__extension__ ({ unsigned short int __v, __x = (unsigned short int) (*(u_short *)(&arpHdr.ea_hdr.ar_op)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));

       switch(arpOp) {
       case 2 /* ARP reply.  */: /* ARP REPLY */
  addr.hostFamily = 2 /* IP protocol family.  */;
  memcpy(&addr.addr._hostIp4Address.s_addr, &arpHdr.arp_tpa, sizeof(struct in_addr));
  addr.addr._hostIp4Address.s_addr = __bswap_32 (addr.addr._hostIp4Address.s_addr);
  _unlockHostsHashMutex(srcHost, "pbuf.c", 1518), _unlockHostsHashMutex(dstHost, "pbuf.c", 1518);

  dstHost = _lookupHost(&addr, (u_char*)&arpHdr.arp_tha, vlanId, 0, 0, actualDeviceId, "pbuf.c", 1520, h, p);
  memcpy(&addr.addr._hostIp4Address.s_addr, &arpHdr.arp_spa, sizeof(struct in_addr));
  addr.addr._hostIp4Address.s_addr = __bswap_32 (addr.addr._hostIp4Address.s_addr);
  if(dstHost != ((void *)0)) {
    _lockHostsHashMutex(dstHost, "processPacket-dst-6", "pbuf.c", 1524);
    { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1525);; if(dstHost->nonIPTraffic == ((void *)0)) dstHost->nonIPTraffic = ntop_safecalloc((size_t)sizeof(NonIPTraffic), (size_t)1, (char*)"pbuf.c", (int)1525); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1525);; };
    { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1526);; incrementTrafficCounter(&dstHost->nonIPTraffic->arpReplyPktsRcvd, 1); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1526);; };
  }

  srcHost = _lookupHost(&addr, (u_char*)&arpHdr.arp_sha, vlanId, 0, 0, actualDeviceId, "pbuf.c", 1529, h, p);
  if(srcHost != ((void *)0)) {
    _lockHostsHashMutex(srcHost, "processPacket-src-6", "pbuf.c", 1531);
    { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1532);; if(srcHost->nonIPTraffic == ((void *)0)) srcHost->nonIPTraffic = ntop_safecalloc((size_t)sizeof(NonIPTraffic), (size_t)1, (char*)"pbuf.c", (int)1532); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1532);; };
    { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1533);; incrementTrafficCounter(&srcHost->nonIPTraffic->arpReplyPktsSent, 1); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1533);; };
  }
       }
     }
     /* DO NOT ADD A break ABOVE ! */

   case 0x8035 /* Reverse ARP */: /* Reverse ARP */
     if(srcHost != ((void *)0)) {
       { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1541);; incrementTrafficCounter(&srcHost->nonIPTraffic->arp_rarpSent, length); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1541);; };
     }

     if(dstHost != ((void *)0)) {

       { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1546);; incrementTrafficCounter(&dstHost->nonIPTraffic->arp_rarpRcvd, length); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1546);; };
     }
     incrementTrafficCounter(&myGlobals.device[actualDeviceId].arpRarpBytes, length);
     break;

   case 0x86DD:
     processIpPkt(p+hlen, h, orig_p, hlen, length, ether_src, ether_dst, actualDeviceId, vlanId);
     { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1553);; incrementTrafficCounter(&srcHost->ipv6BytesSent, length); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1553);; };
     { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1554);; incrementTrafficCounter(&dstHost->ipv6BytesRcvd, length); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1554);; };
     incrementTrafficCounter(&myGlobals.device[actualDeviceId].ipv6Bytes, length);
     break;

   default:






     { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1565);; incrementTrafficCounter(&srcHost->nonIPTraffic->otherSent, length); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1565);; };
     { _accessMutex(&myGlobals.device[actualDeviceId].counterMutex, "quickLock", "pbuf.c", 1566);; incrementTrafficCounter(&dstHost->nonIPTraffic->otherRcvd, length); _releaseMutex(&myGlobals.device[actualDeviceId].counterMutex, "pbuf.c", 1566);; };
     incrementTrafficCounter(&myGlobals.device[actualDeviceId].otherBytes, length);
     incrementUnknownProto(srcHost, 0 /* sent */, eth_type /* eth */, 0 /* dsap */,
      0 /* ssap */, 0 /* ip */);
     incrementUnknownProto(dstHost, 1 /* rcvd */, eth_type /* eth */, 0 /* dsap */,
      0 /* ssap */, 0 /* ip */);
     break;
   }

   ctr.value = length;
   /*
	    Even if this is not IP the hostIpAddress field is
	    fine because it is not used in this special case and I need
	    a placeholder here.
	  */
   if(srcHost && dstHost)
     updatePacketCount(srcHost, dstHost, ctr, 1, actualDeviceId);
 }
    }

    if(srcHost) _unlockHostsHashMutex(srcHost, "pbuf.c", 1586);
    if(dstHost) _unlockHostsHashMutex(dstHost, "pbuf.c", 1587);
  } else {
    /*  count runts somehow? */
  }

  if(myGlobals.flowsList != ((void *)0)) /* Handle flows last */
    flowsProcess(h, p, deviceId);



  {
    float elapsed;
    gettimeofday(&pktEndOfProcessing, ((void *)0));
    elapsed = timeval_subtract(pktEndOfProcessing, pktStartOfProcessing);
    myGlobals.processBuffer[++myGlobals.processBufferCount & (1024 - 1)] = elapsed;
    if(elapsed > myGlobals.pmaxDelay)
      myGlobals.pmaxDelay = elapsed;
  }


  if(myGlobals.pcap_file_list != ((void *)0)) {
    if(myGlobals.actTime > (lastUpdateThptTime + 30)) {
      updateThpt(1);
      lastUpdateThptTime = myGlobals.actTime;
    }
  }

  if(myGlobals.resetHashNow == 1) {
    int i;

    traceEvent(3, "pbuf.c", 1617, "Resetting stats on user request...");
    for(i=0; i<myGlobals.numDevices; i++) resetStats(i);
    traceEvent(3, "pbuf.c", 1619, "User requested stats reset complete");
    myGlobals.resetHashNow = 0;
  }
}

# 1278 "pbuf.c"
struct cdp_element {
    u_int16_t cdp_type;
    u_int16_t cdp_len;
    // u_char cdp_content[255];
  };

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

