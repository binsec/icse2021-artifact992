unsigned int __builtin_bswap32 (unsigned int);
void * __builtin___memcpy_chk (void *, const void *, unsigned int, unsigned int);
unsigned int __builtin_object_size (const void *, int);
void * __builtin___memset_chk (void *, int, unsigned int, unsigned int);

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 44 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}

# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

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

# 39 "addressing.h"
typedef struct {
  union {
    uint32_t in4;
    uint8_t in6[16];
  } addr;
  uint16_t family;
} IPAddr;

# 354 "util.c"
void
UTI_IPHostToNetwork(IPAddr *src, IPAddr *dest)
{
  /* Don't send uninitialized bytes over network */
  memset(dest, 0, sizeof (IPAddr));

  dest->family = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (src->family); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

  switch (src->family) {
    case 1:
      dest->addr.in4 = __bswap_32 (src->addr.in4);
      break;
    case 2:
      memcpy(dest->addr.in6, src->addr.in6, sizeof (dest->addr.in6));
      break;
  }
}

# 374 "util.c"
void
UTI_IPNetworkToHost(IPAddr *src, IPAddr *dest)
{
  dest->family = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (src->family); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

  switch (dest->family) {
    case 1:
      dest->addr.in4 = __bswap_32 (src->addr.in4);
      break;
    case 2:
      memcpy(dest->addr.in6, src->addr.in6, sizeof (dest->addr.in6));
      break;
  }
}

# 69 "/usr/include/assert.h"
extern void __assert_fail (const char *__assertion, const char *__file,
      unsigned int __line, const char *__function);

# 37 "/usr/include/stdint.h"
typedef short int int16_t;

# 38 "/usr/include/stdint.h"
typedef int int32_t;

# 98 "candm.h"
typedef struct {
  uint32_t tv_sec_high;
  uint32_t tv_sec_low;
  uint32_t tv_nsec;
} Timeval;

# 110 "candm.h"
typedef struct {
  int32_t f;
} Float;

# 118 "candm.h"
typedef struct {
  IPAddr mask;
  IPAddr address;
  int32_t EOR;
} REQ_Online;

# 124 "candm.h"
typedef struct {
  IPAddr mask;
  IPAddr address;
  int32_t EOR;
} REQ_Offline;

# 130 "candm.h"
typedef struct {
  IPAddr mask;
  IPAddr address;
  int32_t n_good_samples;
  int32_t n_total_samples;
  int32_t EOR;
} REQ_Burst;

# 138 "candm.h"
typedef struct {
  IPAddr address;
  int32_t new_minpoll;
  int32_t EOR;
} REQ_Modify_Minpoll;

# 144 "candm.h"
typedef struct {
  IPAddr address;
  int32_t new_maxpoll;
  int32_t EOR;
} REQ_Modify_Maxpoll;

# 150 "candm.h"
typedef struct {
  int32_t pad;
  int32_t EOR;
} REQ_Dump;

# 155 "candm.h"
typedef struct {
  IPAddr address;
  Float new_max_delay;
  int32_t EOR;
} REQ_Modify_Maxdelay;

# 161 "candm.h"
typedef struct {
  IPAddr address;
  Float new_max_delay_ratio;
  int32_t EOR;
} REQ_Modify_Maxdelayratio;

# 167 "candm.h"
typedef struct {
  IPAddr address;
  Float new_max_delay_dev_ratio;
  int32_t EOR;
} REQ_Modify_Maxdelaydevratio;

# 173 "candm.h"
typedef struct {
  IPAddr address;
  int32_t new_min_stratum;
  int32_t EOR;
} REQ_Modify_Minstratum;

# 179 "candm.h"
typedef struct {
  IPAddr address;
  int32_t new_poll_target;
  int32_t EOR;
} REQ_Modify_Polltarget;

# 185 "candm.h"
typedef struct {
  Float new_max_update_skew;
  int32_t EOR;
} REQ_Modify_Maxupdateskew;

# 190 "candm.h"
typedef struct {
  Timeval ts;
  int32_t EOR;
} REQ_Logon;

# 195 "candm.h"
typedef struct {
  Timeval ts;
  int32_t EOR;
} REQ_Settime;

# 200 "candm.h"
typedef struct {
  int32_t on_off;
  int32_t stratum;
  int32_t EOR;
} REQ_Local;

# 206 "candm.h"
typedef struct {
  int32_t option;
  int32_t EOR;
} REQ_Manual;

# 211 "candm.h"
typedef struct {
  int32_t EOR;
} REQ_N_Sources;

# 215 "candm.h"
typedef struct {
  int32_t index;
  int32_t EOR;
} REQ_Source_Data;

# 220 "candm.h"
typedef struct {
  int32_t EOR;
} REQ_Rekey;

# 224 "candm.h"
typedef struct {
  IPAddr ip;
  int32_t subnet_bits;
  int32_t EOR;
} REQ_Allow_Deny;

# 230 "candm.h"
typedef struct {
  IPAddr ip;
  int32_t EOR;
} REQ_Ac_Check;

# 242 "candm.h"
typedef struct {
  IPAddr ip_addr;
  uint32_t port;
  int32_t minpoll;
  int32_t maxpoll;
  int32_t presend_minpoll;
  uint32_t authkey;
  Float max_delay;
  Float max_delay_ratio;
  uint32_t flags;
  int32_t EOR;
} REQ_NTP_Source;

# 255 "candm.h"
typedef struct {
  IPAddr ip_addr;
  int32_t EOR;
} REQ_Del_Source;

# 260 "candm.h"
typedef struct {
  int32_t EOR;
} REQ_WriteRtc;

# 264 "candm.h"
typedef struct {
  Float dfreq;
  int32_t EOR;
} REQ_Dfreq;

# 269 "candm.h"
typedef struct {
  int32_t sec;
  int32_t usec;
  int32_t EOR;
} REQ_Doffset;

# 275 "candm.h"
typedef struct {
  int32_t EOR;
} REQ_Tracking;

# 279 "candm.h"
typedef struct {
  uint32_t index;
  int32_t EOR;
} REQ_Sourcestats;

# 284 "candm.h"
typedef struct {
  int32_t EOR;
} REQ_RTCReport;

# 288 "candm.h"
typedef struct {
  int32_t EOR;
} REQ_TrimRTC;

# 292 "candm.h"
typedef struct {
  int32_t EOR;
} REQ_CycleLogs;

# 305 "candm.h"
typedef struct {
  uint32_t first_index;
  uint32_t n_indices;
  int32_t EOR;
} REQ_ClientAccessesByIndex;

# 311 "candm.h"
typedef struct {
  int32_t EOR;
} REQ_ManualList;

# 315 "candm.h"
typedef struct {
  int32_t index;
  int32_t EOR;
} REQ_ManualDelete;

# 320 "candm.h"
typedef struct {
  int32_t EOR;
} REQ_MakeStep;

# 324 "candm.h"
typedef struct {
  int32_t EOR;
} REQ_Activity;

# 328 "candm.h"
typedef struct {
  int32_t EOR;
} REQ_Reselect;

# 332 "candm.h"
typedef struct {
  Float distance;
  int32_t EOR;
} REQ_ReselectDistance;

# 384 "candm.h"
typedef struct {
  uint8_t version; /* Protocol version */
  uint8_t pkt_type; /* What sort of packet this is */
  uint8_t res1;
  uint8_t res2;
  uint16_t command; /* Which command is being issued */
  uint16_t attempt; /* How many resends the client has done
                             (count up from zero for same sequence
                             number) */
  uint32_t sequence; /* Client's sequence number */
  uint32_t utoken; /* Unique token per incarnation of daemon */
  uint32_t token; /* Command token (to prevent replay attack) */

  union {
    REQ_Online online;
    REQ_Offline offline;
    REQ_Burst burst;
    REQ_Modify_Minpoll modify_minpoll;
    REQ_Modify_Maxpoll modify_maxpoll;
    REQ_Dump dump;
    REQ_Modify_Maxdelay modify_maxdelay;
    REQ_Modify_Maxdelayratio modify_maxdelayratio;
    REQ_Modify_Maxdelaydevratio modify_maxdelaydevratio;
    REQ_Modify_Minstratum modify_minstratum;
    REQ_Modify_Polltarget modify_polltarget;
    REQ_Modify_Maxupdateskew modify_maxupdateskew;
    REQ_Logon logon;
    REQ_Settime settime;
    REQ_Local local;
    REQ_Manual manual;
    REQ_N_Sources n_sources;
    REQ_Source_Data source_data;
    REQ_Rekey rekey;
    REQ_Allow_Deny allow_deny;
    REQ_Ac_Check ac_check;
    REQ_NTP_Source ntp_source;
    REQ_Del_Source del_source;
    REQ_WriteRtc writertc;
    REQ_Dfreq dfreq;
    REQ_Doffset doffset;
    REQ_Tracking tracking;
    REQ_Sourcestats sourcestats;
    REQ_RTCReport rtcreport;
    REQ_TrimRTC trimrtc;
    REQ_CycleLogs cyclelogs;
    REQ_ClientAccessesByIndex client_accesses_by_index;
    REQ_ManualList manual_list;
    REQ_ManualDelete manual_delete;
    REQ_MakeStep make_step;
    REQ_Activity activity;
    REQ_Reselect reselect;
    REQ_ReselectDistance reselect_distance;
  } data; /* Command specific parameters */

  /* The following fields only set the maximum size of the packet.
     There are no holes between them and the actual data. */

  /* Padding used to prevent traffic amplification */
  uint8_t padding[396];

  /* Authentication data */
  uint8_t auth[64];

} CMD_Request;

# 496 "candm.h"
typedef struct {
  int32_t EOR;
} RPY_Null;

# 500 "candm.h"
typedef struct {
  uint32_t n_sources;
  int32_t EOR;
} RPY_N_Sources;

# 519 "candm.h"
typedef struct {
  IPAddr ip_addr;
  int16_t poll;
  uint16_t stratum;
  uint16_t state;
  uint16_t mode;
  uint16_t flags;
  uint16_t reachability;
  uint32_t since_sample;
  Float orig_latest_meas;
  Float latest_meas;
  Float latest_meas_err;
  int32_t EOR;
} RPY_Source_Data;

# 534 "candm.h"
typedef struct {
  uint32_t ref_id;
  IPAddr ip_addr;
  uint16_t stratum;
  uint16_t leap_status;
  Timeval ref_time;
  Float current_correction;
  Float last_offset;
  Float rms_offset;
  Float freq_ppm;
  Float resid_freq_ppm;
  Float skew_ppm;
  Float root_delay;
  Float root_dispersion;
  Float last_update_interval;
  int32_t EOR;
} RPY_Tracking;

# 552 "candm.h"
typedef struct {
  uint32_t ref_id;
  IPAddr ip_addr;
  uint32_t n_samples;
  uint32_t n_runs;
  uint32_t span_seconds;
  Float sd;
  Float resid_freq_ppm;
  Float skew_ppm;
  Float est_offset;
  Float est_offset_err;
  int32_t EOR;
} RPY_Sourcestats;

# 566 "candm.h"
typedef struct {
  Timeval ref_time;
  uint16_t n_samples;
  uint16_t n_runs;
  uint32_t span_seconds;
  Float rtc_seconds_fast;
  Float rtc_gain_rate_ppm;
  int32_t EOR;
} RPY_Rtc;

# 576 "candm.h"
typedef struct {
  uint32_t centiseconds;
  Float dfreq_ppm;
  Float new_afreq_ppm;
  int32_t EOR;
} RPY_ManualTimestamp;

# 589 "candm.h"
typedef struct {
  IPAddr ip;
  uint32_t client_hits;
  uint32_t peer_hits;
  uint32_t cmd_hits_auth;
  uint32_t cmd_hits_normal;
  uint32_t cmd_hits_bad;
  uint32_t last_ntp_hit_ago;
  uint32_t last_cmd_hit_ago;
} RPY_ClientAccesses_Client;

# 600 "candm.h"
typedef struct {
  uint32_t n_indices; /* how many indices there are in the server's table */
  uint32_t next_index; /* the index 1 beyond those processed on this call */
  uint32_t n_clients; /* the number of valid entries in the following array */
  RPY_ClientAccesses_Client clients[8];
  int32_t EOR;
} RPY_ClientAccessesByIndex;

# 610 "candm.h"
typedef struct {
  Timeval when;
  Float slewed_offset;
  Float orig_offset;
  Float residual;
} RPY_ManualListSample;

# 617 "candm.h"
typedef struct {
  uint32_t n_samples;
  RPY_ManualListSample samples[16];
  int32_t EOR;
} RPY_ManualList;

# 623 "candm.h"
typedef struct {
  int32_t online;
  int32_t offline;
  int32_t burst_online;
  int32_t burst_offline;
  int32_t unresolved;
  int32_t EOR;
} RPY_Activity;

# 632 "candm.h"
typedef struct {
  uint8_t version;
  uint8_t pkt_type;
  uint8_t res1;
  uint8_t res2;
  uint16_t command; /* Which command is being replied to */
  uint16_t reply; /* Which format of reply this is */
  uint16_t status; /* Status of command processing */
  uint16_t pad1; /* Padding for compatibility and 4 byte alignment */
  uint16_t pad2;
  uint16_t pad3;
  uint32_t sequence; /* Echo of client's sequence number */
  uint32_t utoken; /* Unique token per incarnation of daemon */
  uint32_t token; /* New command token (only if command was successfully
                          authenticated) */
  union {
    RPY_Null null;
    RPY_N_Sources n_sources;
    RPY_Source_Data source_data;
    RPY_ManualTimestamp manual_timestamp;
    RPY_Tracking tracking;
    RPY_Sourcestats sourcestats;
    RPY_Rtc rtc;
    RPY_ClientAccessesByIndex client_accesses_by_index;
    RPY_ManualList manual_list;
    RPY_Activity activity;
  } data; /* Reply specific parameters */

  /* authentication of the packet, there is no hole after the actual data
     from the data union, this field only sets the maximum auth size */
  uint8_t auth[64];

} CMD_Reply;

# 38 "pktlength.c"
static int
command_unpadded_length(CMD_Request *r)
{
  int type;
  type = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (r->command); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  if (type < 0 || type >= 50) {
    return 0;
  } else {
    switch (type) {

      case 0:
        return __builtin_offsetof (CMD_Request, data);
      case 1:
        return __builtin_offsetof (CMD_Request, data.online.EOR);
      case 2:
        return __builtin_offsetof (CMD_Request, data.offline.EOR);
      case 3:
        return __builtin_offsetof (CMD_Request, data.burst.EOR);
      case 4:
        return __builtin_offsetof (CMD_Request, data.modify_minpoll.EOR);
      case 5:
        return __builtin_offsetof (CMD_Request, data.modify_maxpoll.EOR);
      case 6:
        return __builtin_offsetof (CMD_Request, data.dump.EOR);
      case 7:
        return __builtin_offsetof (CMD_Request, data.modify_maxdelay.EOR);
      case 8:
        return __builtin_offsetof (CMD_Request, data.modify_maxdelayratio.EOR);
      case 47:
        return __builtin_offsetof (CMD_Request, data.modify_maxdelaydevratio.EOR);
      case 9:
        return __builtin_offsetof (CMD_Request, data.modify_maxupdateskew.EOR);
      case 10 :
        return __builtin_offsetof (CMD_Request, data.logon.EOR);
      case 11 :
        return __builtin_offsetof (CMD_Request, data.settime.EOR);
      case 12 :
        return __builtin_offsetof (CMD_Request, data.local.EOR);
      case 13 :
        return __builtin_offsetof (CMD_Request, data.manual.EOR);
      case 14 :
        return __builtin_offsetof (CMD_Request, data.n_sources.EOR);
      case 15 :
        return __builtin_offsetof (CMD_Request, data.source_data.EOR);
      case 16 :
        return __builtin_offsetof (CMD_Request, data.rekey.EOR);
      case 17 :
        return __builtin_offsetof (CMD_Request, data.allow_deny.EOR);
      case 18 :
        return __builtin_offsetof (CMD_Request, data.allow_deny.EOR);
      case 19 :
        return __builtin_offsetof (CMD_Request, data.allow_deny.EOR);
      case 20 :
        return __builtin_offsetof (CMD_Request, data.allow_deny.EOR);
      case 21 :
        return __builtin_offsetof (CMD_Request, data.allow_deny.EOR);
      case 22 :
        return __builtin_offsetof (CMD_Request, data.allow_deny.EOR);
      case 23 :
        return __builtin_offsetof (CMD_Request, data.allow_deny.EOR);
      case 24 :
        return __builtin_offsetof (CMD_Request, data.allow_deny.EOR);
      case 25 :
        return __builtin_offsetof (CMD_Request, data.ac_check.EOR);
      case 26 :
        return __builtin_offsetof (CMD_Request, data.ac_check.EOR);
      case 27 :
        return __builtin_offsetof (CMD_Request, data.ntp_source.EOR);
      case 28 :
        return __builtin_offsetof (CMD_Request, data.ntp_source.EOR);
      case 29 :
        return __builtin_offsetof (CMD_Request, data.del_source.EOR);
      case 30 :
        return __builtin_offsetof (CMD_Request, data.writertc.EOR);
      case 31 :
        return __builtin_offsetof (CMD_Request, data.dfreq.EOR);
      case 32 :
        return __builtin_offsetof (CMD_Request, data.doffset.EOR);
      case 33 :
        return __builtin_offsetof (CMD_Request, data.tracking.EOR);
      case 34 :
        return __builtin_offsetof (CMD_Request, data.sourcestats.EOR);
      case 35 :
        return __builtin_offsetof (CMD_Request, data.rtcreport.EOR);
      case 36 :
        return __builtin_offsetof (CMD_Request, data.trimrtc.EOR);
      case 37 :
        return __builtin_offsetof (CMD_Request, data.cyclelogs.EOR);
      case 38 :
      case 39:
        /* No longer supported */
        return 0;
      case 40:
        return __builtin_offsetof (CMD_Request, data.client_accesses_by_index.EOR);
      case 41:
        return __builtin_offsetof (CMD_Request, data.manual_list.EOR);
      case 42:
        return __builtin_offsetof (CMD_Request, data.manual_delete.EOR);
      case 43:
        return __builtin_offsetof (CMD_Request, data.make_step.EOR);
      case 44:
        return __builtin_offsetof (CMD_Request, data.activity.EOR);
      case 48:
        return __builtin_offsetof (CMD_Request, data.reselect.EOR);
      case 49:
        return __builtin_offsetof (CMD_Request, data.reselect_distance.EOR);
      case 45:
        return __builtin_offsetof (CMD_Request, data.modify_minstratum.EOR);
      case 46:
        return __builtin_offsetof (CMD_Request, data.modify_polltarget.EOR);
      default:
        /* If we fall through the switch, it most likely means we've forgotten to implement a new case */
        ((0) ? (void) (0) : __assert_fail ("0", "pktlength.c", 150, __PRETTY_FUNCTION__));
    }
  }

  /* Catch-all case */
  return 0;

}

# 182 "pktlength.c"
int
PKL_CommandPaddingLength(CMD_Request *r)
{
  int type;

  if (r->version < 6)
    return 0;

  type = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (r->command); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

  if (type < 0 || type >= 50)
    return 0;

  switch (type) {
    case 0:
      return ((__builtin_offsetof (CMD_Request, data)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data)) : 0);
    case 1:
      return ((__builtin_offsetof (CMD_Request, data.online.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.online.EOR)) : 0);
    case 2:
      return ((__builtin_offsetof (CMD_Request, data.offline.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.offline.EOR)) : 0);
    case 3:
      return ((__builtin_offsetof (CMD_Request, data.burst.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.burst.EOR)) : 0);
    case 4:
      return ((__builtin_offsetof (CMD_Request, data.modify_minpoll.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.modify_minpoll.EOR)) : 0);
    case 5:
      return ((__builtin_offsetof (CMD_Request, data.modify_maxpoll.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.modify_maxpoll.EOR)) : 0);
    case 6:
      return ((__builtin_offsetof (CMD_Request, data.dump.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.dump.EOR)) : 0);
    case 7:
      return ((__builtin_offsetof (CMD_Request, data.modify_maxdelay.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.modify_maxdelay.EOR)) : 0);
    case 8:
      return ((__builtin_offsetof (CMD_Request, data.modify_maxdelayratio.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.modify_maxdelayratio.EOR)) : 0);
    case 47:
      return ((__builtin_offsetof (CMD_Request, data.modify_maxdelaydevratio.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.modify_maxdelaydevratio.EOR)) : 0);
    case 9:
      return ((__builtin_offsetof (CMD_Request, data.modify_maxupdateskew.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.modify_maxupdateskew.EOR)) : 0);
    case 10:
      return ((__builtin_offsetof (CMD_Request, data.logon.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.logon.EOR)) : 0);
    case 11:
      return ((__builtin_offsetof (CMD_Request, data.settime.EOR)) < (__builtin_offsetof (CMD_Reply, data.manual_timestamp.EOR)) ? (__builtin_offsetof (CMD_Reply, data.manual_timestamp.EOR)) - (__builtin_offsetof (CMD_Request, data.settime.EOR)) : 0);
    case 12:
      return ((__builtin_offsetof (CMD_Request, data.local.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.local.EOR)) : 0);
    case 13:
      return ((__builtin_offsetof (CMD_Request, data.manual.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.manual.EOR)) : 0);
    case 14:
      return ((__builtin_offsetof (CMD_Request, data.n_sources.EOR)) < (__builtin_offsetof (CMD_Reply, data.n_sources.EOR)) ? (__builtin_offsetof (CMD_Reply, data.n_sources.EOR)) - (__builtin_offsetof (CMD_Request, data.n_sources.EOR)) : 0);
    case 15:
      return ((__builtin_offsetof (CMD_Request, data.source_data.EOR)) < (__builtin_offsetof (CMD_Reply, data.source_data.EOR)) ? (__builtin_offsetof (CMD_Reply, data.source_data.EOR)) - (__builtin_offsetof (CMD_Request, data.source_data.EOR)) : 0);
    case 16:
      return ((__builtin_offsetof (CMD_Request, data.rekey.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.rekey.EOR)) : 0);
    case 17:
      return ((__builtin_offsetof (CMD_Request, data.allow_deny.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.allow_deny.EOR)) : 0);
    case 18:
      return ((__builtin_offsetof (CMD_Request, data.allow_deny.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.allow_deny.EOR)) : 0);
    case 19:
      return ((__builtin_offsetof (CMD_Request, data.allow_deny.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.allow_deny.EOR)) : 0);
    case 20:
      return ((__builtin_offsetof (CMD_Request, data.allow_deny.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.allow_deny.EOR)) : 0);
    case 21:
      return ((__builtin_offsetof (CMD_Request, data.allow_deny.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.allow_deny.EOR)) : 0);
    case 22:
      return ((__builtin_offsetof (CMD_Request, data.allow_deny.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.allow_deny.EOR)) : 0);
    case 23:
      return ((__builtin_offsetof (CMD_Request, data.allow_deny.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.allow_deny.EOR)) : 0);
    case 24:
      return ((__builtin_offsetof (CMD_Request, data.allow_deny.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.allow_deny.EOR)) : 0);
    case 25:
      return ((__builtin_offsetof (CMD_Request, data.ac_check.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.ac_check.EOR)) : 0);
    case 26:
      return ((__builtin_offsetof (CMD_Request, data.ac_check.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.ac_check.EOR)) : 0);
    case 27:
      return ((__builtin_offsetof (CMD_Request, data.ntp_source.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.ntp_source.EOR)) : 0);
    case 28:
      return ((__builtin_offsetof (CMD_Request, data.ntp_source.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.ntp_source.EOR)) : 0);
    case 29:
      return ((__builtin_offsetof (CMD_Request, data.del_source.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.del_source.EOR)) : 0);
    case 30:
      return ((__builtin_offsetof (CMD_Request, data.writertc.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.writertc.EOR)) : 0);
    case 31:
      return ((__builtin_offsetof (CMD_Request, data.dfreq.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.dfreq.EOR)) : 0);
    case 32:
      return ((__builtin_offsetof (CMD_Request, data.doffset.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.doffset.EOR)) : 0);
    case 33:
      return ((__builtin_offsetof (CMD_Request, data.tracking.EOR)) < (__builtin_offsetof (CMD_Reply, data.tracking.EOR)) ? (__builtin_offsetof (CMD_Reply, data.tracking.EOR)) - (__builtin_offsetof (CMD_Request, data.tracking.EOR)) : 0);
    case 34:
      return ((__builtin_offsetof (CMD_Request, data.sourcestats.EOR)) < (__builtin_offsetof (CMD_Reply, data.sourcestats.EOR)) ? (__builtin_offsetof (CMD_Reply, data.sourcestats.EOR)) - (__builtin_offsetof (CMD_Request, data.sourcestats.EOR)) : 0);
    case 35:
      return ((__builtin_offsetof (CMD_Request, data.rtcreport.EOR)) < (__builtin_offsetof (CMD_Reply, data.rtc.EOR)) ? (__builtin_offsetof (CMD_Reply, data.rtc.EOR)) - (__builtin_offsetof (CMD_Request, data.rtcreport.EOR)) : 0);
    case 36:
      return ((__builtin_offsetof (CMD_Request, data.trimrtc.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.trimrtc.EOR)) : 0);
    case 37:
      return ((__builtin_offsetof (CMD_Request, data.cyclelogs.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.cyclelogs.EOR)) : 0);
    case 38:
    case 39:
      /* No longer supported */
      return 0;
    case 40:
      return ((__builtin_offsetof (CMD_Request, data.client_accesses_by_index.EOR)) < (__builtin_offsetof (CMD_Reply, data.client_accesses_by_index.EOR)) ? (__builtin_offsetof (CMD_Reply, data.client_accesses_by_index.EOR)) - (__builtin_offsetof (CMD_Request, data.client_accesses_by_index.EOR)) : 0);
    case 41:
      return ((__builtin_offsetof (CMD_Request, data.manual_list.EOR)) < (__builtin_offsetof (CMD_Reply, data.manual_list.EOR)) ? (__builtin_offsetof (CMD_Reply, data.manual_list.EOR)) - (__builtin_offsetof (CMD_Request, data.manual_list.EOR)) : 0);
    case 42:
      return ((__builtin_offsetof (CMD_Request, data.manual_delete.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.manual_delete.EOR)) : 0);
    case 43:
      return ((__builtin_offsetof (CMD_Request, data.make_step.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.make_step.EOR)) : 0);
    case 44:
      return ((__builtin_offsetof (CMD_Request, data.activity.EOR)) < (__builtin_offsetof (CMD_Reply, data.activity.EOR)) ? (__builtin_offsetof (CMD_Reply, data.activity.EOR)) - (__builtin_offsetof (CMD_Request, data.activity.EOR)) : 0);
    case 48:
      return ((__builtin_offsetof (CMD_Request, data.reselect.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.reselect.EOR)) : 0);
    case 49:
      return ((__builtin_offsetof (CMD_Request, data.reselect_distance.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.reselect_distance.EOR)) : 0);
    case 45:
      return ((__builtin_offsetof (CMD_Request, data.modify_minstratum.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.modify_minstratum.EOR)) : 0);
    case 46:
      return ((__builtin_offsetof (CMD_Request, data.modify_polltarget.EOR)) < (__builtin_offsetof (CMD_Reply, data.null.EOR)) ? (__builtin_offsetof (CMD_Reply, data.null.EOR)) - (__builtin_offsetof (CMD_Request, data.modify_polltarget.EOR)) : 0);
    default:
      /* If we fall through the switch, it most likely means we've forgotten to implement a new case */
      ((0) ? (void) (0) : __assert_fail ("0", "pktlength.c", 298, __PRETTY_FUNCTION__));
      return 0;
  }
}

# 305 "pktlength.c"
int
PKL_ReplyLength(CMD_Reply *r)
{
  int type;
  type = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (r->reply); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  /* Note that reply type codes start from 1, not 0 */
  if (type < 1 || type >= 13) {
    return 0;
  } else {
    switch (type) {
      case 1:
        return __builtin_offsetof (CMD_Reply, data.null.EOR);
      case 2:
        return __builtin_offsetof (CMD_Reply, data.n_sources.EOR);
      case 3:
        return __builtin_offsetof (CMD_Reply, data.source_data.EOR);
      case 4:
        return __builtin_offsetof (CMD_Reply, data.manual_timestamp.EOR);
      case 5:
        return __builtin_offsetof (CMD_Reply, data.tracking.EOR);
      case 6:
        return __builtin_offsetof (CMD_Reply, data.sourcestats.EOR);
      case 7:
        return __builtin_offsetof (CMD_Reply, data.rtc.EOR);
      case 8 :
      case 9:
        /* No longer supported */
        return 0;
      case 10:
        {
          unsigned long nc = __bswap_32 (r->data.client_accesses_by_index.n_clients);
          if (r->status == (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (0); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))) {
            if (nc > 8)
              return 0;
            return (__builtin_offsetof (CMD_Reply, data.client_accesses_by_index.clients) +
                    nc * sizeof(RPY_ClientAccesses_Client));
          } else {
            return __builtin_offsetof (CMD_Reply, data);
          }
        }
      case 11:
        {
          unsigned long ns = __bswap_32 (r->data.manual_list.n_samples);
          if (ns > 16)
            return 0;
          if (r->status == (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (0); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))) {
            return (__builtin_offsetof (CMD_Reply, data.manual_list.samples) +
                    ns * sizeof(RPY_ManualListSample));
          } else {
            return __builtin_offsetof (CMD_Reply, data);
          }
        }
      case 12:
        return __builtin_offsetof (CMD_Reply, data.activity.EOR);

      default:
        ((0) ? (void) (0) : __assert_fail ("0", "pktlength.c", 361, __PRETTY_FUNCTION__));
    }
  }

  return 0;
}

