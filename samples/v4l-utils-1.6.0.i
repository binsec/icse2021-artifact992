unsigned int __builtin_bswap32 (unsigned int);
void * __builtin___memcpy_chk (void *, const void *, unsigned int, unsigned int);
unsigned int __builtin_object_size (const void *, int);
char * strerror (int);

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

# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 172 "/usr/include/i386-linux-gnu/bits/types.h"
typedef int __ssize_t;

# 220 "/usr/include/unistd.h"
typedef __ssize_t ssize_t;

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 93 "../../lib/include/libdvbv5/header.h"
struct dvb_table_header {
 uint8_t table_id;
 union {
  uint16_t bitfield;
  struct {
   uint16_t section_length:12;
   uint8_t one:2;
   uint8_t zero:1;
   uint8_t syntax:1;
  } ;
 } ;
 uint16_t id; /* TS ID */
 uint8_t current_next:1;
 uint8_t version:5;
 uint8_t one2:2;

 uint8_t section_id; /* section_number */
 uint8_t last_section; /* last_section_number */
};

# 125 "../../lib/include/libdvbv5/header.h"
void dvb_table_header_init (struct dvb_table_header *header);

# 102 "../../lib/include/libdvbv5/vct.h"
struct atsc_table_vct_channel {
 uint16_t __short_name[7];

 union {
  uint32_t bitfield1;
  struct {
   uint32_t modulation_mode:8;
   uint32_t minor_channel_number:10;
   uint32_t major_channel_number:10;
   uint32_t reserved1:4;
  } ;
 } ;

 uint32_t carrier_frequency;
 uint16_t channel_tsid;
 uint16_t program_number;
 union {
  uint16_t bitfield2;
  struct {
   uint16_t service_type:6;
   uint16_t reserved2:3;
   uint16_t hide_guide:1;
   uint16_t out_of_band:1; /* CVCT only */
   uint16_t path_select:1; /* CVCT only */
   uint16_t hidden:1;
   uint16_t access_controlled:1;
   uint16_t ETM_location:2;

  } ;
 } ;

 uint16_t source_id;
 union {
  uint16_t bitfield3;
  struct {
   uint16_t descriptors_length:10;
   uint16_t reserved3:6;
  } ;
 } ;

 /*
	 * Everything after atsc_table_vct_channel::descriptor (including it)
	 * won't be bit-mapped to the data parsed from the MPEG TS. So,
	 * metadata are added there
	 */
 struct dvb_desc *descriptor;
 struct atsc_table_vct_channel *next;

 /* The channel_short_name is converted to locale charset by vct.c */

 char short_name[32];
};

# 169 "../../lib/include/libdvbv5/vct.h"
struct atsc_table_vct {
 struct dvb_table_header header;
 uint8_t protocol_version;

 uint8_t num_channels_in_section;

 struct atsc_table_vct_channel *channel;
 struct dvb_desc *descriptor;
};

# 188 "../../lib/include/libdvbv5/vct.h"
union atsc_table_vct_descriptor_length {
 uint16_t bitfield;
 struct {
  uint16_t descriptor_length:10;
  uint16_t reserved:6;
 } ;
};

# 44 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}

# 118 "../../lib/include/libdvbv5/descriptors.h"
struct dvb_desc {
 uint8_t type;
 uint8_t length;
 struct dvb_desc *next;

 uint8_t data[];
};

# 182 "../../lib/include/libdvbv5/descriptors.h"
int dvb_desc_parse(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
      uint16_t buflen, struct dvb_desc **head_desc);

# 47 "/usr/include/i386-linux-gnu/bits/string3.h"
extern __inline void *
 memcpy (void *__restrict __dest, const void *__restrict __src, size_t __len)

{
  return __builtin___memcpy_chk (__dest, __src, __len, __builtin_object_size (__dest, 0));
}

# 31 "../../lib/include/libdvbv5/dvb-frontend.h"
typedef enum fe_type {
 FE_QPSK,
 FE_QAM,
 FE_OFDM,
 FE_ATSC
} fe_type_t;

# 39 "../../lib/include/libdvbv5/dvb-frontend.h"
typedef enum fe_caps {
 FE_IS_STUPID = 0,
 FE_CAN_INVERSION_AUTO = 0x1,
 FE_CAN_FEC_1_2 = 0x2,
 FE_CAN_FEC_2_3 = 0x4,
 FE_CAN_FEC_3_4 = 0x8,
 FE_CAN_FEC_4_5 = 0x10,
 FE_CAN_FEC_5_6 = 0x20,
 FE_CAN_FEC_6_7 = 0x40,
 FE_CAN_FEC_7_8 = 0x80,
 FE_CAN_FEC_8_9 = 0x100,
 FE_CAN_FEC_AUTO = 0x200,
 FE_CAN_QPSK = 0x400,
 FE_CAN_QAM_16 = 0x800,
 FE_CAN_QAM_32 = 0x1000,
 FE_CAN_QAM_64 = 0x2000,
 FE_CAN_QAM_128 = 0x4000,
 FE_CAN_QAM_256 = 0x8000,
 FE_CAN_QAM_AUTO = 0x10000,
 FE_CAN_TRANSMISSION_MODE_AUTO = 0x20000,
 FE_CAN_BANDWIDTH_AUTO = 0x40000,
 FE_CAN_GUARD_INTERVAL_AUTO = 0x80000,
 FE_CAN_HIERARCHY_AUTO = 0x100000,
 FE_CAN_8VSB = 0x200000,
 FE_CAN_16VSB = 0x400000,
 FE_HAS_EXTENDED_CAPS = 0x800000, /* We need more bitspace for newer APIs, indicate this. */
 FE_CAN_MULTISTREAM = 0x4000000, /* frontend supports multistream filtering */
 FE_CAN_TURBO_FEC = 0x8000000, /* frontend supports "turbo fec modulation" */
 FE_CAN_2G_MODULATION = 0x10000000, /* frontend supports "2nd generation modulation" (DVB-S2) */
 FE_NEEDS_BENDING = 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
 FE_CAN_RECOVER = 0x40000000, /* frontend can recover from a cable unplug automatically */
 FE_CAN_MUTE_TS = 0x80000000 /* frontend can stop spurious TS data output */
} fe_caps_t;

# 74 "../../lib/include/libdvbv5/dvb-frontend.h"
struct dvb_frontend_info {
 char name[128];
 fe_type_t type; /* DEPRECATED. Use DTV_ENUM_DELSYS instead */
 __u32 frequency_min;
 __u32 frequency_max;
 __u32 frequency_stepsize;
 __u32 frequency_tolerance;
 __u32 symbol_rate_min;
 __u32 symbol_rate_max;
 __u32 symbol_rate_tolerance; /* ppm */
 __u32 notifier_delay; /* DEPRECATED */
 fe_caps_t caps;
};

# 393 "../../lib/include/libdvbv5/dvb-frontend.h"
typedef enum fe_delivery_system {
 SYS_UNDEFINED,
 SYS_DVBC_ANNEX_A,
 SYS_DVBC_ANNEX_B,
 SYS_DVBT,
 SYS_DSS,
 SYS_DVBS,
 SYS_DVBS2,
 SYS_DVBH,
 SYS_ISDBT,
 SYS_ISDBS,
 SYS_ISDBC,
 SYS_ATSC,
 SYS_ATSCMH,
 SYS_DTMB,
 SYS_CMMB,
 SYS_DAB,
 SYS_DVBT2,
 SYS_TURBO,
 SYS_DVBC_ANNEX_C,
} fe_delivery_system_t;

# 47 "../../lib/include/libdvbv5/dvb-sat.h"
struct dvbsat_freqrange {
 unsigned low, high;
};

# 74 "../../lib/include/libdvbv5/dvb-sat.h"
struct dvb_sat_lnb {
 const char *name;
 const char *alias;
 unsigned lowfreq, highfreq;

 unsigned rangeswitch;

 struct dvbsat_freqrange freqrange[2];
};

# 45 "../../lib/include/libdvbv5/dvb-log.h"
typedef void (*dvb_logfunc)(int level, const char *fmt, ...);

# 118 "../../lib/include/libdvbv5/dvb-fe.h"
struct dvb_v5_fe_parms {
 /* Information visible to the client - don't override those values */
 struct dvb_frontend_info info;
 uint32_t version;
 int has_v5_stats;
 fe_delivery_system_t current_sys;
 int num_systems;
 fe_delivery_system_t systems[20];
 int legacy_fe;

 /* The values below are specified by the library client */

 /* Flags from the client to the library */
 int abort;

 /* Linear Amplifier settings */
 int lna;

 /* Satellite settings */
 const struct dvb_sat_lnb *lnb;
 int sat_number;
 unsigned freq_bpf;
 unsigned diseqc_wait;

 /* Function to write DVB logs */
 unsigned verbose;
 dvb_logfunc logfunc;

 /* Charsets to be used by the conversion utilities */
 char *default_charset;
 char *output_charset;
};

# 26 "./parse_string.h"
void dvb_iconv_to_charset(struct dvb_v5_fe_parms *parms,
     char *dest,
     size_t destlen,
     const unsigned char *src,
     size_t len,
     char *type, char *output_charset);

# 27 "tables/vct.c"
ssize_t atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
   ssize_t buflen, struct atsc_table_vct **table)
{
 const uint8_t *p = buf, *endbuf = buf + buflen;
 struct atsc_table_vct *vct;
 struct atsc_table_vct_channel **head;
 size_t size;
 int i, n;

 size = __builtin_offsetof (struct atsc_table_vct, channel);
 if (p + size > endbuf) {
  do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - p, size); } while (0)
                       ;
  return -1;
 }

 if (buf[0] != 0xc8 && buf[0] != 0xc9) {
  do { parms->logfunc(3 /* error conditions */, "%s: invalid marker 0x%02x, sould be 0x%02x or 0x%02x", __func__, buf[0], 0xc8, 0xc9); } while (0)
                                                       ;
  return -2;
 }

 if (!*table) {
  *table = calloc(sizeof(struct atsc_table_vct), 1);
  if (!*table) {
   do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
   return -3;
  }
 }
 vct = *table;
 memcpy(vct, p, size);
 p += size;
 dvb_table_header_init(&vct->header);

 /* find end of curent list */
 head = &vct->channel;
 while (*head != ((void *)0))
  head = &(*head)->next;

 size = __builtin_offsetof (struct atsc_table_vct_channel, descriptor);
 for (n = 0; n < vct->num_channels_in_section; n++) {
  struct atsc_table_vct_channel *channel;

  if (p + size > endbuf) {
   do { parms->logfunc(3 /* error conditions */, "%s: channel table is missing %d elements", __func__, vct->num_channels_in_section - n + 1); } while (0)
                                                      ;
   vct->num_channels_in_section = n;
   break;
  }

  channel = malloc(sizeof(struct atsc_table_vct_channel));
  if (!channel) {
   do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
   return -4;
  }

  memcpy(channel, p, size);
  p += size;

  /* Fix endiannes of the copied fields */
  for (i = 0; i < (sizeof(channel->__short_name)/sizeof((channel->__short_name)[0])); i++)
   do { channel->__short_name[i] = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (channel->__short_name[i]); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

  do { channel->carrier_frequency = __bswap_32 (channel->carrier_frequency); } while (0);
  do { channel->channel_tsid = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (channel->channel_tsid); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  do { channel->program_number = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (channel->program_number); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  do { channel->bitfield1 = __bswap_32 (channel->bitfield1); } while (0);
  do { channel->bitfield2 = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (channel->bitfield2); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  do { channel->source_id = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (channel->source_id); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  do { channel->bitfield3 = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (channel->bitfield3); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

  /* Short name is always UTF-16 */
  dvb_iconv_to_charset(parms, channel->short_name,
         sizeof(channel->short_name),
         (const unsigned char *)channel->__short_name,
         sizeof(channel->__short_name),
         "UTF-16",
         parms->output_charset);

  /* Fill descriptors */

  channel->descriptor = ((void *)0);
  channel->next = ((void *)0);

  *head = channel;
  head = &(*head)->next;

  if (endbuf - p < channel->descriptors_length) {
   do { parms->logfunc(3 /* error conditions */, "%s: short read %d/%zd bytes", __func__, channel->descriptors_length, endbuf - p); } while (0)
                                               ;
   return -5;
  }

  /* get the descriptors for each program */
  if (dvb_desc_parse(parms, p, channel->descriptors_length,
          &channel->descriptor) != 0) {
   return -6;
  }

  p += channel->descriptors_length;
 }

 /* Get extra descriptors */
 size = sizeof(union atsc_table_vct_descriptor_length);
 while (p + size <= endbuf) {
  union atsc_table_vct_descriptor_length *d = (void *)p;
  do { d->descriptor_length = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (d->descriptor_length); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  p += size;
  if (endbuf - p < d->descriptor_length) {
   do { parms->logfunc(3 /* error conditions */, "%s: short read %d/%zd bytes", __func__, d->descriptor_length, endbuf - p); } while (0)
                                        ;
   return -7;
  }
  if (dvb_desc_parse(parms, p, d->descriptor_length,
          &vct->descriptor) != 0) {
   return -8;
  }
 }
 if (endbuf - p)
  do { parms->logfunc(4 /* warning conditions */, "%s: %zu spurious bytes at the end", __func__, endbuf - p); } while (0)
                           ;
 return p - buf;
}

# 54 "../../lib/include/libdvbv5/desc_ca_identifier.h"
struct dvb_desc_ca_identifier {
 uint8_t type;
 uint8_t length;
 struct dvb_desc *next;

 uint8_t caid_count;
 uint16_t *caids;

};

# 25 "descriptors/desc_ca_identifier.c"
int dvb_desc_ca_identifier_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
{
 struct dvb_desc_ca_identifier *d = (struct dvb_desc_ca_identifier *) desc;
 int i;

 d->caid_count = d->length >> 1; /* FIXME: warn if odd */
 d->caids = malloc(d->length);
 if (!d->caids) {
  do { parms->logfunc(3 /* error conditions */, "dvb_desc_ca_identifier_init: out of memory"); } while (0);
  return -1;
 }
 for (i = 0; i < d->caid_count; i++) {
  d->caids[i] = ((uint16_t *) buf)[i];
  do { d->caids[i] = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (d->caids[i]); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
 }
 return 0;
}

# 57 "../../lib/include/libdvbv5/desc_ca.h"
struct dvb_desc_ca {
 uint8_t type;
 uint8_t length;
 struct dvb_desc *next;

 uint16_t ca_id;
 union {
  uint16_t bitfield1;
  struct {
   uint16_t ca_pid:13;
   uint16_t reserved:3;
  } ;
 } ;

 uint8_t *privdata;
 uint8_t privdata_len;
};

# 25 "descriptors/desc_ca.c"
int dvb_desc_ca_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
{
 size_t size = __builtin_offsetof (struct dvb_desc_ca, privdata) - __builtin_offsetof (struct dvb_desc_ca, ca_id);
 struct dvb_desc_ca *d = (struct dvb_desc_ca *) desc;

 memcpy(((uint8_t *) d ) + sizeof(struct dvb_desc), buf, size);
 do { d->ca_id = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (d->ca_id); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
 do { d->bitfield1 = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (d->bitfield1); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

 if (d->length > size) {
  size = d->length - size;
  d->privdata = malloc(size);
  if (!d->privdata)
   return -1;
  d->privdata_len = size;
  memcpy(d->privdata, buf + 4, size);
 } else {
  d->privdata = ((void *)0);
  d->privdata_len = 0;
 }
 /*dvb_hexdump(parms, "desc ca ", buf, desc->length);*/
 /*dvb_desc_ca_print(parms, desc);*/
 return 0;
}

# 57 "../../lib/include/libdvbv5/desc_logical_channel.h"
struct dvb_desc_logical_channel_number {
 uint16_t service_id;
 union {
  uint16_t bitfield;
  struct {
   uint16_t logical_channel_number:10;
   uint16_t reserved:5;
   uint16_t visible_service_flag:1;
  } ;
 } ;
};

# 79 "../../lib/include/libdvbv5/desc_logical_channel.h"
struct dvb_desc_logical_channel {
 uint8_t type;
 uint8_t length;
 struct dvb_desc *next;

 struct dvb_desc_logical_channel_number *lcn;
};

# 28 "descriptors/desc_logical_channel.c"
int dvb_desc_logical_channel_init(struct dvb_v5_fe_parms *parms,
         const uint8_t *buf, struct dvb_desc *desc)
{
 struct dvb_desc_logical_channel *d = (void *)desc;
 unsigned char *p = (unsigned char *)buf;
 size_t len;
 int i;

 d->lcn = malloc(d->length);
 if (!d->lcn) {
  do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
  return -1;
 }

 memcpy(d->lcn, p, d->length);

 len = d->length / sizeof(d->lcn);

 for (i = 0; i < len; i++) {
  do { d->lcn[i].service_id = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (d->lcn[i].service_id); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  do { d->lcn[i].bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (d->lcn[i].bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
 }
 return 0;
}

# 80 "../../lib/include/libdvbv5/nit.h"
union dvb_table_nit_transport_header {
 uint16_t bitfield;
 struct {
  uint16_t transport_length:12;
  uint16_t reserved:4;
 } ;
};

# 110 "../../lib/include/libdvbv5/nit.h"
struct dvb_table_nit_transport {
 uint16_t transport_id;
 uint16_t network_id;
 union {
  uint16_t bitfield;
  struct {
   uint16_t desc_length:12;
   uint16_t reserved:4;
  } ;
 } ;
 struct dvb_desc *descriptor;
 struct dvb_table_nit_transport *next;
};

# 144 "../../lib/include/libdvbv5/nit.h"
struct dvb_table_nit {
 struct dvb_table_header header;
 union {
  uint16_t bitfield;
  struct {
   uint16_t desc_length:12;
   uint16_t reserved:4;
  } ;
 } ;
 struct dvb_desc *descriptor;
 struct dvb_table_nit_transport *transport;
};

# 25 "tables/nit.c"
ssize_t dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
   ssize_t buflen, struct dvb_table_nit **table)
{
 const uint8_t *p = buf, *endbuf = buf + buflen;
 struct dvb_table_nit *nit;
 struct dvb_table_nit_transport **head;
 struct dvb_desc **head_desc;
 size_t size;

 size = __builtin_offsetof (struct dvb_table_nit, descriptor);
 if (p + size > endbuf) {
  do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - p, size); } while (0)
                       ;
  return -1;
 }

 if (buf[0] != 0x40) {
  do { parms->logfunc(3 /* error conditions */, "%s: invalid marker 0x%02x, sould be 0x%02x", __func__, buf[0], 0x40); } while (0)
                                    ;
  return -2;
 }

 if (!*table) {
  *table = calloc(sizeof(struct dvb_table_nit), 1);
  if (!*table) {
   do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
   return -3;
  }
 }
 nit = *table;
 memcpy(nit, p, size);
 p += size;
 dvb_table_header_init(&nit->header);

 do { nit->bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (nit->bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

 /* find end of current lists */
 head_desc = &nit->descriptor;
 while (*head_desc != ((void *)0))
  head_desc = &(*head_desc)->next;
 head = &nit->transport;
 while (*head != ((void *)0))
  head = &(*head)->next;

 size = nit->desc_length;
 if (p + size > endbuf) {
  do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - p, size); } while (0)
                       ;
  return -4;
 }
 if (dvb_desc_parse(parms, p, size, head_desc) != 0) {
  return -5;
 }
 p += size;

 size = sizeof(union dvb_table_nit_transport_header);
 if (p + size > endbuf) {
  do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - p, size); } while (0)
                       ;
  return -6;
 }
 p += size;

 size = __builtin_offsetof (struct dvb_table_nit_transport, descriptor);
 while (p + size <= endbuf) {
  struct dvb_table_nit_transport *transport;

  transport = malloc(sizeof(struct dvb_table_nit_transport));
  if (!transport) {
   do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
   return -7;
  }
  memcpy(transport, p, size);
  p += size;

  do { transport->transport_id = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (transport->transport_id); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  do { transport->network_id = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (transport->network_id); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  do { transport->bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (transport->bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  transport->descriptor = ((void *)0);
  transport->next = ((void *)0);

  *head = transport;
  head = &(*head)->next;

  /* parse the descriptors */
  if (transport->desc_length > 0) {
   uint16_t desc_length = transport->desc_length;
   if (p + desc_length > endbuf) {
    do { parms->logfunc(4 /* warning conditions */, "%s: decsriptors short read %zd/%d bytes", __func__, endbuf - p, desc_length); } while (0)
                                ;
    desc_length = endbuf - p;
   }
   if (dvb_desc_parse(parms, p, desc_length,
           &transport->descriptor) != 0) {
    return -8;
   }
   p += desc_length;
  }
 }
 if (endbuf - p)
  do { parms->logfunc(4 /* warning conditions */, "%s: %zu spurious bytes at the end", __func__, endbuf - p); } while (0)
                           ;
 return p - buf;
}

# 162 "../../lib/include/libdvbv5/pmt.h"
struct dvb_table_pmt_stream {
 uint8_t type;
 union {
  uint16_t bitfield;
  struct {
   uint16_t elementary_pid:13;
   uint16_t reserved:3;
  } ;
 } ;
 union {
  uint16_t bitfield2;
  struct {
   uint16_t desc_length:10;
   uint16_t zero:2;
   uint16_t reserved2:4;
  } ;
 } ;
 struct dvb_desc *descriptor;
 struct dvb_table_pmt_stream *next;
};

# 204 "../../lib/include/libdvbv5/pmt.h"
struct dvb_table_pmt {
 struct dvb_table_header header;
 union {
  uint16_t bitfield;
  struct {
   uint16_t pcr_pid:13;
   uint16_t reserved2:3;
  } ;
 } ;

 union {
  uint16_t bitfield2;
  struct {
   uint16_t desc_length:10;
   uint16_t zero3:2;
   uint16_t reserved3:4;
  } ;
 } ;
 struct dvb_desc *descriptor;
 struct dvb_table_pmt_stream *stream;
};

# 28 "tables/pmt.c"
ssize_t dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
   ssize_t buflen, struct dvb_table_pmt **table)
{
 const uint8_t *p = buf, *endbuf = buf + buflen;
 struct dvb_table_pmt *pmt;
 struct dvb_table_pmt_stream **head;
 struct dvb_desc **head_desc;
 size_t size;

 size = __builtin_offsetof (struct dvb_table_pmt, descriptor);
 if (p + size > endbuf) {
  do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - p, size); } while (0)
                       ;
  return -1;
 }

 if (buf[0] != 0x02) {
  do { parms->logfunc(3 /* error conditions */, "%s: invalid marker 0x%02x, sould be 0x%02x", __func__, buf[0], 0x02); } while (0)
                                    ;
  return -2;
 }

 if (!*table) {
  *table = calloc(sizeof(struct dvb_table_pmt), 1);
  if (!*table) {
   do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
   return -3;
  }
 }
 pmt = *table;
 memcpy(pmt, p, size);
 p += size;
 dvb_table_header_init(&pmt->header);
 do { pmt->bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (pmt->bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
 do { pmt->bitfield2 = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (pmt->bitfield2); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

 /* find end of current list */
 head = &pmt->stream;
 while (*head != ((void *)0))
  head = &(*head)->next;
 head_desc = &pmt->descriptor;
 while (*head_desc != ((void *)0))
  head_desc = &(*head_desc)->next;

 size = pmt->header.section_length + 3 - 4; /* plus header, minus CRC */
 if (buf + size > endbuf) {
  do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - buf, size); } while (0)
                         ;
  return -4;
 }
 endbuf = buf + size;

 /* parse the descriptors */
 if (pmt->desc_length > 0 ) {
  uint16_t desc_length = pmt->desc_length;
  if (p + desc_length > endbuf) {
   do { parms->logfunc(4 /* warning conditions */, "%s: decsriptors short read %d/%zd bytes", __func__, desc_length, endbuf - p); } while (0)
                               ;
   desc_length = endbuf - p;
  }
  if (dvb_desc_parse(parms, p, desc_length,
          head_desc) != 0) {
   return -4;
  }
  p += desc_length;
 }

 /* get the stream entries */
 size = __builtin_offsetof (struct dvb_table_pmt_stream, descriptor);
 while (p + size <= endbuf) {
  struct dvb_table_pmt_stream *stream;

  stream = malloc(sizeof(struct dvb_table_pmt_stream));
  if (!stream) {
   do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
   return -5;
  }
  memcpy(stream, p, size);
  p += size;

  do { stream->bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (stream->bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  do { stream->bitfield2 = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (stream->bitfield2); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  stream->descriptor = ((void *)0);
  stream->next = ((void *)0);

  *head = stream;
  head = &(*head)->next;

  /* parse the descriptors */
  if (stream->desc_length > 0) {
   uint16_t desc_length = stream->desc_length;
   if (p + desc_length > endbuf) {
    do { parms->logfunc(4 /* warning conditions */, "%s: decsriptors short read %zd/%d bytes", __func__, endbuf - p, desc_length); } while (0)
                                ;
    desc_length = endbuf - p;
   }
   if (dvb_desc_parse(parms, p, desc_length,
           &stream->descriptor) != 0) {
    return -6;
   }
   p += desc_length;
  }
 }
 if (p < endbuf)
  do { parms->logfunc(4 /* warning conditions */, "%s: %zu spurious bytes at the end", __func__, endbuf - p); } while (0)
                           ;

 return p - buf;
}

# 78 "../../lib/include/libdvbv5/pat.h"
struct dvb_table_pat_program {
 uint16_t service_id;
 union {
  uint16_t bitfield;
  struct {
   uint16_t pid:13;
   uint8_t reserved:3;
  } ;
 } ;
 struct dvb_table_pat_program *next;
};

# 109 "../../lib/include/libdvbv5/pat.h"
struct dvb_table_pat {
 struct dvb_table_header header;
 uint16_t programs;
 struct dvb_table_pat_program *program;
};

# 483 "/usr/include/stdlib.h"
extern void free (void *__ptr);

# 26 "tables/pat.c"
ssize_t dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
   ssize_t buflen, struct dvb_table_pat **table)
{
 const uint8_t *p = buf, *endbuf = buf + buflen;
 struct dvb_table_pat *pat;
 struct dvb_table_pat_program **head;
 size_t size;

 size = __builtin_offsetof (struct dvb_table_pat, programs);
 if (p + size > endbuf) {
  do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - p, size); } while (0)
                       ;
  return -1;
 }

 if (buf[0] != 0x00) {
  do { parms->logfunc(3 /* error conditions */, "%s: invalid marker 0x%02x, sould be 0x%02x", __func__, buf[0], 0x00); } while (0)
                                    ;
  return -2;
 }

 if (!*table) {
  *table = calloc(sizeof(struct dvb_table_pat), 1);
  if (!*table) {
   do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
   return -3;
  }
 }
 pat = *table;
 memcpy(pat, buf, size);
 p += size;
 dvb_table_header_init(&pat->header);

 /* find end of current list */
 head = &pat->program;
 while (*head != ((void *)0))
  head = &(*head)->next;

 size = pat->header.section_length + 3 - 4; /* plus header, minus CRC */
 if (buf + size > endbuf) {
  do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - buf, size); } while (0)
                         ;
  return -4;
 }
 endbuf = buf + size;

 size = __builtin_offsetof (struct dvb_table_pat_program, next);
 while (p + size <= endbuf) {
  struct dvb_table_pat_program *prog;

  prog = malloc(sizeof(struct dvb_table_pat_program));
  if (!prog) {
   do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
   return -5;
  }

  memcpy(prog, p, size);
  p += size;

  do { prog->service_id = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (prog->service_id); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

  if (prog->pid == 0x1fff) { /* ignore null packets */
   free(prog);
   break;
  }
  do { prog->bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (prog->bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  pat->programs++;

  prog->next = ((void *)0);

  *head = prog;
  head = &(*head)->next;
 }
 if (endbuf - p)
  do { parms->logfunc(4 /* warning conditions */, "%s: %zu spurious bytes at the end", __func__, endbuf - p); } while (0)
                           ;
 return p - buf;
}

# 55 "../../lib/include/libdvbv5/desc_ts_info.h"
struct dvb_desc_ts_info_transmission_type {
 uint8_t transmission_type_info;
 uint8_t num_of_service;
};

# 77 "../../lib/include/libdvbv5/desc_ts_info.h"
struct dvb_desc_ts_info {
 uint8_t type;
 uint8_t length;
 struct dvb_desc *next;

 char *ts_name, *ts_name_emph;
 struct dvb_desc_ts_info_transmission_type transmission_type;
 uint16_t *service_id;

 union {
  uint16_t bitfield;
  struct {
   uint8_t transmission_type_count:2;
   uint8_t length_of_ts_name:6;
   uint8_t remote_control_key_id:8;
  } ;
 };
};

# 33 "./parse_string.h"
void dvb_parse_string(struct dvb_v5_fe_parms *parms, char **dest, char **emph,
        const unsigned char *src, size_t len);

# 26 "descriptors/desc_ts_info.c"
int dvb_desc_ts_info_init(struct dvb_v5_fe_parms *parms,
         const uint8_t *buf, struct dvb_desc *desc)
{
 struct dvb_desc_ts_info *d = (void *)desc;
 unsigned char *p = (unsigned char *)buf;
 struct dvb_desc_ts_info_transmission_type *t;
 size_t len;
 int i;

 len = sizeof(*d) - __builtin_offsetof (struct dvb_desc_ts_info, bitfield);
 memcpy(&d->bitfield, p, len);
 p += len;

 do { d->bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (d->bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

 len = d->length_of_ts_name;
 d->ts_name = ((void *)0);
 d->ts_name_emph = ((void *)0);
 dvb_parse_string(parms, &d->ts_name, &d->ts_name_emph, p, len);
 p += len;

 memcpy(&d->transmission_type, p, sizeof(d->transmission_type));
 p += sizeof(d->transmission_type);

 t = &d->transmission_type;

 d->service_id = malloc(sizeof(*d->service_id) * t->num_of_service);
 if (!d->service_id) {
  do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
  return -1;
 }

 memcpy(d->service_id, p, sizeof(*d->service_id) * t->num_of_service);

 for (i = 0; i < t->num_of_service; i++)
  do { d->service_id[i] = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (d->service_id[i]); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

 p += sizeof(*d->service_id) * t->num_of_service;
 return 0;
}

# 88 "../../lib/include/libdvbv5/sdt.h"
struct dvb_table_sdt_service {
 uint16_t service_id;
 uint8_t EIT_present_following:1;
 uint8_t EIT_schedule:1;
 uint8_t reserved:6;
 union {
  uint16_t bitfield;
  struct {
   uint16_t desc_length:12;
   uint16_t free_CA_mode:1;
   uint16_t running_status:3;
  } ;
 } ;
 struct dvb_desc *descriptor;
 struct dvb_table_sdt_service *next;
};

# 124 "../../lib/include/libdvbv5/sdt.h"
struct dvb_table_sdt {
 struct dvb_table_header header;
 uint16_t network_id;
 uint8_t reserved;
 struct dvb_table_sdt_service *service;
};

# 26 "tables/sdt.c"
ssize_t dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
   ssize_t buflen, struct dvb_table_sdt **table)
{
 const uint8_t *p = buf, *endbuf = buf + buflen;
 struct dvb_table_sdt *sdt;
 struct dvb_table_sdt_service **head;
 size_t size;

 size = __builtin_offsetof (struct dvb_table_sdt, service);
 if (p + size > endbuf) {
  do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - p, size); } while (0)
                       ;
  return -1;
 }

 if (buf[0] != 0x42 && buf[0] != 0x46) {
  do { parms->logfunc(3 /* error conditions */, "%s: invalid marker 0x%02x, sould be 0x%02x or 0x%02x", __func__, buf[0], 0x42, 0x46); } while (0)
                                                    ;
  return -2;
 }

 if (!*table) {
  *table = calloc(sizeof(struct dvb_table_sdt), 1);
  if (!*table) {
   do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
   return -3;
  }
 }
 sdt = *table;
 memcpy(sdt, p, size);
 p += size;
 dvb_table_header_init(&sdt->header);
 do { sdt->network_id = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sdt->network_id); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

 /* find end of curent list */
 head = &sdt->service;
 while (*head != ((void *)0))
  head = &(*head)->next;

 size = sdt->header.section_length + 3 - 4; /* plus header, minus CRC */
 if (buf + size > endbuf) {
  do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - buf, size); } while (0)
                         ;
  return -4;
 }
 endbuf = buf + size;

 /* get the event entries */
 size = __builtin_offsetof (struct dvb_table_sdt_service, descriptor);
 while (p + size <= endbuf) {
  struct dvb_table_sdt_service *service;

  service = malloc(sizeof(struct dvb_table_sdt_service));
  if (!service) {
   do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
   return -5;
  }
  memcpy(service, p, size);
  p += size;

  do { service->service_id = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (service->service_id); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  do { service->bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (service->bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  service->descriptor = ((void *)0);
  service->next = ((void *)0);

  *head = service;
  head = &(*head)->next;

  /* parse the descriptors */
  if (service->desc_length > 0) {
   uint16_t desc_length = service->desc_length;
   if (p + desc_length > endbuf) {
    do { parms->logfunc(4 /* warning conditions */, "%s: decsriptors short read %zd/%d bytes", __func__, endbuf - p, desc_length); } while (0)
                                ;
    desc_length = endbuf - p;
   }
   if (dvb_desc_parse(parms, p, desc_length,
           &service->descriptor) != 0) {
    return -6;
   }
   p += desc_length;
  }

 }
 if (endbuf - p)
  do { parms->logfunc(4 /* warning conditions */, "%s: %zu spurious bytes at the end", __func__, endbuf - p); } while (0)
                           ;

 return p - buf;
}

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 58 "../../lib/include/libdvbv5/desc_isdbt_delivery.h"
struct isdbt_desc_terrestrial_delivery_system {
 uint8_t type;
 uint8_t length;
 struct dvb_desc *next;

 uint32_t *frequency;
 unsigned num_freqs;

 union {
  uint16_t bitfield;
  struct {
   uint16_t transmission_mode:2;
   uint16_t guard_interval:2;
   uint16_t area_code:12;
  } ;
 } ;
};

# 50 "/usr/include/i386-linux-gnu/bits/errno.h"
extern int *__errno_location (void);

# 25 "descriptors/desc_isdbt_delivery.c"
int isdbt_desc_delivery_init(struct dvb_v5_fe_parms *parms,
         const uint8_t *buf, struct dvb_desc *desc)
{
 struct isdbt_desc_terrestrial_delivery_system *d = (void *)desc;
 unsigned char *p = (unsigned char *) buf;
 int i;
 size_t len;
 uint16_t frq;

 len = sizeof(*d) - __builtin_offsetof (struct isdbt_desc_terrestrial_delivery_system, bitfield);
 memcpy(&d->bitfield, p, len);
 p += len;

 do { d->bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (d->bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

 d->num_freqs = (d->length - len)/ sizeof(uint16_t);
 if (!d->num_freqs)
  return 0;
 d->frequency = malloc(d->num_freqs * sizeof(*d->frequency));
 if (!d->frequency) {
  do { parms->logfunc(3 /* error conditions */, "%s: %s", "Can't allocate space for ISDB-T frequencies", strerror((*__errno_location ()))); } while (0);
  return -2;
 }

 for (i = 0; i < d->num_freqs; i++) {
  frq = *(uint16_t *)p;
  p += sizeof(uint16_t);

  do { frq = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (frq); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

  d->frequency[i] = (uint32_t)((((uint64_t)frq) * 1000000ul) / 7);
 }
 return 0;
}

# 109 "../../lib/include/libdvbv5/mpeg_pes.h"
struct ts_t {
 uint8_t one:1;
 uint8_t bits30:3;
 uint8_t tag:4;

 union {
  uint16_t bitfield;
  struct {
   uint16_t one1:1;
   uint16_t bits15:15;
  } ;
 } ;

 union {
  uint16_t bitfield2;
  struct {
   uint16_t one2:1;
   uint16_t bits00:15;
  } ;
 } ;
};

# 153 "../../lib/include/libdvbv5/mpeg_pes.h"
struct dvb_mpeg_pes_optional {
 union {
  uint16_t bitfield;
  struct {
   uint16_t PES_extension:1;
   uint16_t PES_CRC:1;
   uint16_t additional_copy_info:1;
   uint16_t DSM_trick_mode:1;
   uint16_t ES_rate:1;
   uint16_t ESCR:1;
   uint16_t PTS_DTS:2;
   uint16_t original_or_copy:1;
   uint16_t copyright:1;
   uint16_t data_alignment_indicator:1;
   uint16_t PES_priority:1;
   uint16_t PES_scrambling_control:2;
   uint16_t two:2;
  } ;
 } ;
 uint8_t length;
 uint64_t pts;
 uint64_t dts;
};

# 187 "../../lib/include/libdvbv5/mpeg_pes.h"
struct dvb_mpeg_pes {
 union {
  uint32_t bitfield;
  struct {
   uint32_t stream_id:8;
   uint32_t sync:24;
  } ;
 } ;
 uint16_t length;
 struct dvb_mpeg_pes_optional optional[];
};

# 26 "tables/mpeg_pes.c"
ssize_t dvb_mpeg_pes_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table)
{
 struct dvb_mpeg_pes *pes = (struct dvb_mpeg_pes *) table;
 const uint8_t *p = buf;
 ssize_t bytes_read = 0;

 memcpy(table, p, sizeof(struct dvb_mpeg_pes));
 p += sizeof(struct dvb_mpeg_pes);
 bytes_read += sizeof(struct dvb_mpeg_pes);

 do { pes->bitfield = __bswap_32 (pes->bitfield); } while (0);
 do { pes->length = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (pes->length); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

 if (pes->sync != 0x000001) {
  do { parms->logfunc(3 /* error conditions */, "mpeg pes invalid, sync 0x%06x should be 0x000001", pes->sync); } while (0);
  return -1;
 }

 if (pes->stream_id == 0xBE) {
  do { parms->logfunc(4 /* warning conditions */, "mpeg pes padding stream ignored"); } while (0);
 } else if (pes->stream_id == 0xBC ||
     pes->stream_id == 0x5F ||
     pes->stream_id == 0x70 ||
     pes->stream_id == 0x71 ||
     pes->stream_id == 0xFF ||
     pes->stream_id == 0x7A ||
     pes->stream_id == 0xF8 ) {
  do { parms->logfunc(3 /* error conditions */, "mpeg pes: unsupported stream type 0x%04x", pes->stream_id); } while (0);
  return -2;
 } else {
  memcpy(pes->optional, p, sizeof(struct dvb_mpeg_pes_optional) -
      sizeof(pes->optional->pts) -
      sizeof(pes->optional->dts));
  p += sizeof(struct dvb_mpeg_pes_optional) -
       sizeof(pes->optional->pts) -
       sizeof(pes->optional->dts);
  do { pes->optional->bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (pes->optional->bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  pes->optional->pts = 0;
  pes->optional->dts = 0;
  if (pes->optional->PTS_DTS & 2) {
   struct ts_t pts;
   memcpy(&pts, p, sizeof(pts));
   p += sizeof(pts);
   do { pts.bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (pts.bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
   do { pts.bitfield2 = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (pts.bitfield2); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
   if (pts.one != 1 || pts.one1 != 1 || pts.one2 != 1)
    do { parms->logfunc(4 /* warning conditions */, "mpeg pes: invalid pts"); } while (0);
   else {
    pes->optional->pts |= (uint64_t) pts.bits00;
    pes->optional->pts |= (uint64_t) pts.bits15 << 15;
    pes->optional->pts |= (uint64_t) pts.bits30 << 30;
   }
  }
  if (pes->optional->PTS_DTS & 1) {
   struct ts_t dts;
   memcpy(&dts, p, sizeof(dts));
   p += sizeof(dts);
   do { dts.bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dts.bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
   do { dts.bitfield2 = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dts.bitfield2); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
   pes->optional->dts |= (uint64_t) dts.bits00;
   pes->optional->dts |= (uint64_t) dts.bits15 << 15;
   pes->optional->dts |= (uint64_t) dts.bits30 << 30;
  }
  bytes_read += sizeof(struct dvb_mpeg_pes_optional);
 }
 return bytes_read;
}

# 56 "../../lib/include/libdvbv5/desc_partial_reception.h"
struct isdb_partial_reception_service_id {
 uint16_t service_id;
};

# 72 "../../lib/include/libdvbv5/desc_partial_reception.h"
struct isdb_desc_partial_reception {
 uint8_t type;
 uint8_t length;
 struct dvb_desc *next;

 struct isdb_partial_reception_service_id *partial_reception;
};

# 25 "descriptors/desc_partial_reception.c"
int isdb_desc_partial_reception_init(struct dvb_v5_fe_parms *parms,
         const uint8_t *buf, struct dvb_desc *desc)
{
 struct isdb_desc_partial_reception *d = (void *)desc;
 unsigned char *p = (unsigned char *)buf;
 size_t len;
 int i;

 d->partial_reception = malloc(d->length);
 if (!d->partial_reception) {
  do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
  return -1;
 }

 memcpy(d->partial_reception, p, d->length);

 len = d->length / sizeof(d->partial_reception);

 for (i = 0; i < len; i++)
  do { d->partial_reception[i].service_id = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (d->partial_reception[i].service_id); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
 return 0;
}

# 147 "../../lib/include/libdvbv5/descriptors.h"
uint32_t dvb_bcd(uint32_t bcd);

# 64 "../../lib/include/libdvbv5/desc_sat.h"
struct dvb_desc_sat {
 uint8_t type;
 uint8_t length;
 struct dvb_desc *next;

 uint32_t frequency;
 uint16_t orbit;
 uint8_t modulation_type:2;
 uint8_t modulation_system:1;
 uint8_t roll_off:2;
 uint8_t polarization:2;
 uint8_t west_east:1;
 union {
  uint32_t bitfield;
  struct {
   uint32_t fec:4;
   uint32_t symbol_rate:28;
  } ;
 } ;
};

# 25 "descriptors/desc_sat.c"
int dvb_desc_sat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
{
 struct dvb_desc_sat *sat = (struct dvb_desc_sat *) desc;
 ssize_t size = sizeof(struct dvb_desc_sat) - sizeof(struct dvb_desc);

 if (size > desc->length) {
  do { parms->logfunc(3 /* error conditions */, "dvb_desc_sat_init short read %d/%zd bytes", desc->length, size); } while (0);
  return -1;
 }

 memcpy(desc->data, buf, size);
 do { sat->orbit = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sat->orbit); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
 do { sat->bitfield = __bswap_32 (sat->bitfield); } while (0);
 do { sat->frequency = __bswap_32 (sat->frequency); } while (0);
 sat->orbit = dvb_bcd(sat->orbit);
 sat->frequency = dvb_bcd(sat->frequency) * 10;
 sat->symbol_rate = dvb_bcd(sat->symbol_rate) * 100;

 return 0;
}

# 116 "../../lib/include/libdvbv5/desc_extension.h"
struct dvb_extension_descriptor {
 uint8_t type;
 uint8_t length;
 struct dvb_desc *next;

 uint8_t extension_code;

 struct dvb_desc *descriptor;
};

# 50 "../../lib/include/libdvbv5/desc_t2_delivery.h"
struct dvb_desc_t2_delivery_subcell {
 uint8_t cell_id_extension;
 uint16_t transposer_frequency;
};

# 77 "../../lib/include/libdvbv5/desc_t2_delivery.h"
struct dvb_desc_t2_delivery {
 /* extended descriptor */

 uint8_t plp_id;
 uint16_t system_id;
 union {
  uint16_t bitfield;
  struct {
   uint16_t tfs_flag:1;
   uint16_t other_frequency_flag:1;
   uint16_t transmission_mode:3;
   uint16_t guard_interval:3;
   uint16_t reserved:2;
   uint16_t bandwidth:3;
   uint16_t SISO_MISO:2;
  } ;
 } ;

 uint32_t *centre_frequency;
 uint8_t frequency_loop_length;
 uint8_t subcel_info_loop_length;
 struct dvb_desc_t2_delivery_subcell *subcell;
};

# 26 "descriptors/desc_t2_delivery.c"
int dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
          const uint8_t *buf,
          struct dvb_extension_descriptor *ext,
          void *desc)
{
 struct dvb_desc_t2_delivery *d = desc;
 unsigned char *p = (unsigned char *) buf;
 size_t desc_len = ext->length - 1, len, len2;
 int i;

 len = __builtin_offsetof (struct dvb_desc_t2_delivery, bitfield);
 len2 = __builtin_offsetof (struct dvb_desc_t2_delivery, centre_frequency);

 if (desc_len < len) {
  do { parms->logfunc(4 /* warning conditions */, "T2 delivery descriptor is too small"); } while (0);
  return -1;
 }
 if (desc_len < len2) {
  memcpy(p, buf, len);
  do { d->system_id = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (d->system_id); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

  if (desc_len != len)
   do { parms->logfunc(4 /* warning conditions */, "T2 delivery descriptor is truncated"); } while (0);

  return -2;
 }
 memcpy(p, buf, len2);
 p += len2;

 len = desc_len - (p - buf);
 memcpy(&d->centre_frequency, p, len);
 p += len;

 if (d->tfs_flag)
  d->frequency_loop_length = 1;
 else {
  d->frequency_loop_length = *p;
  p++;
 }

 d->centre_frequency = calloc(d->frequency_loop_length,
         sizeof(*d->centre_frequency));
 if (!d->centre_frequency) {
  do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
  return -3;
 }

 memcpy(d->centre_frequency, p, sizeof(*d->centre_frequency) * d->frequency_loop_length);
 p += sizeof(*d->centre_frequency) * d->frequency_loop_length;

 for (i = 0; i < d->frequency_loop_length; i++)
  do { d->centre_frequency[i] = __bswap_32 (d->centre_frequency[i]); } while (0);

 d->subcel_info_loop_length = *p;
 p++;

 d->subcell = calloc(d->subcel_info_loop_length, sizeof(*d->subcell));
 if (!d->subcell) {
  do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
  return -4;
 }
 memcpy(d->subcell, p, sizeof(*d->subcell) * d->subcel_info_loop_length);

 for (i = 0; i < d->subcel_info_loop_length; i++)
  do { d->subcell[i].transposer_frequency = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (d->subcell[i].transposer_frequency); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
 return 0;
}

# 133 "/usr/include/time.h"
struct tm
{
  int tm_sec; /* Seconds.	[0-60] (1 leap second) */
  int tm_min; /* Minutes.	[0-59] */
  int tm_hour; /* Hours.	[0-23] */
  int tm_mday; /* Day.		[1-31] */
  int tm_mon; /* Month.	[0-11] */
  int tm_year; /* Year	- 1900.  */
  int tm_wday; /* Day of week.	[0-6] */
  int tm_yday; /* Days in year.[0-365]	*/
  int tm_isdst; /* DST.		[-1/0/1]*/


  long int tm_gmtoff; /* Seconds east of UTC.  */
  const char *tm_zone; /* Timezone abbreviation.  */




};

# 104 "../../lib/include/libdvbv5/eit.h"
struct dvb_table_eit_event {
 uint16_t event_id;
 union {
  uint16_t bitfield1; /* first 2 bytes are MJD, they need to be bswapped */
  uint8_t dvbstart[5];
 } ;
 uint8_t dvbduration[3];
 union {
  uint16_t bitfield2;
  struct {
   uint16_t desc_length:12;
   uint16_t free_CA_mode:1;
   uint16_t running_status:3;
  } ;
 } ;
 struct dvb_desc *descriptor;
 struct dvb_table_eit_event *next;
 struct tm start;
 uint32_t duration;
 uint16_t service_id;
};

# 145 "../../lib/include/libdvbv5/eit.h"
struct dvb_table_eit {
 struct dvb_table_header header;
 uint16_t transport_id;
 uint16_t network_id;
 uint8_t last_segment;
 uint8_t last_table_id;
 struct dvb_table_eit_event *event;
};

# 218 "../../lib/include/libdvbv5/eit.h"
void dvb_time(const uint8_t data[5], struct tm *tm);

# 25 "tables/eit.c"
ssize_t dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
  ssize_t buflen, struct dvb_table_eit **table)
{
 const uint8_t *p = buf, *endbuf = buf + buflen;
 struct dvb_table_eit *eit;
 struct dvb_table_eit_event **head;
 size_t size;

 size = __builtin_offsetof (struct dvb_table_eit, event);
 if (p + size > endbuf) {
  do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - p, size); } while (0)
                       ;
  return -1;
 }

 if ((buf[0] != 0x4E && buf[0] != 0x4F) &&
  !(buf[0] >= 0x50 /* - 0x5F */ && buf[0] <= 0x50 /* - 0x5F */ + 0xF) &&
  !(buf[0] >= 0x60 /* - 0x6F */ && buf[0] <= 0x60 /* - 0x6F */ + 0xF)) {
  do { parms->logfunc(3 /* error conditions */, "%s: invalid marker 0x%02x, sould be 0x%02x, 0x%02x or between 0x%02x and 0x%02x or 0x%02x and 0x%02x", __func__, buf[0], 0x4E, 0x4F, 0x50 /* - 0x5F */, 0x50 /* - 0x5F */ + 0xF, 0x60 /* - 0x6F */, 0x60 /* - 0x6F */ + 0xF); } while (0)


                                                                     ;
  return -2;
 }

 if (!*table) {
  *table = calloc(sizeof(struct dvb_table_eit), 1);
  if (!*table) {
   do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
   return -3;
  }
 }
 eit = *table;
 memcpy(eit, p, size);
 p += size;
 dvb_table_header_init(&eit->header);

 do { eit->transport_id = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (eit->transport_id); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
 do { eit->network_id = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (eit->network_id); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

 /* find end of curent list */
 head = &eit->event;
 while (*head != ((void *)0))
  head = &(*head)->next;

 /* get the event entries */
 size = __builtin_offsetof (struct dvb_table_eit_event, descriptor);
 while (p + size <= endbuf) {
  struct dvb_table_eit_event *event;

  event = malloc(sizeof(struct dvb_table_eit_event));
  if (!event) {
   do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
   return -4;
  }
  memcpy(event, p, size);
  p += size;

  do { event->event_id = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (event->event_id); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  do { event->bitfield1 = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (event->bitfield1); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  do { event->bitfield2 = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (event->bitfield2); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  event->descriptor = ((void *)0);
  event->next = ((void *)0);
  dvb_time(event->dvbstart, &event->start);
  event->duration = dvb_bcd((uint32_t) event->dvbduration[0]) * 3600 +
      dvb_bcd((uint32_t) event->dvbduration[1]) * 60 +
      dvb_bcd((uint32_t) event->dvbduration[2]);

  event->service_id = eit->header.id;

  *head = event;
  head = &(*head)->next;

  /* parse the descriptors */
  if (event->desc_length > 0) {
   uint16_t desc_length = event->desc_length;
   if (p + desc_length > endbuf) {
    do { parms->logfunc(4 /* warning conditions */, "%s: decsriptors short read %zd/%d bytes", __func__, endbuf - p, desc_length); } while (0)
                                ;
    desc_length = endbuf - p;
   }
   if (dvb_desc_parse(parms, p, desc_length,
           &event->descriptor) != 0) {
    return -5;
   }
   p += desc_length;
  }
 }
 if (p < endbuf)
  do { parms->logfunc(4 /* warning conditions */, "%s: %zu spurious bytes at the end", __func__, endbuf - p); } while (0)
                           ;
 return p - buf;
}

# 52 "../../lib/include/libdvbv5/desc_atsc_service_location.h"
struct atsc_desc_service_location_elementary {
 uint8_t stream_type;
 union {
  uint16_t bitfield;
  struct {
   uint16_t elementary_pid:13;
   uint16_t reserved:3;
  } ;
 } ;
 char ISO_639_language_code[3];
};

# 76 "../../lib/include/libdvbv5/desc_atsc_service_location.h"
struct atsc_desc_service_location {
 uint8_t type;
 uint8_t length;
 struct dvb_desc *next;

 struct atsc_desc_service_location_elementary *elementary;

 union {
  uint16_t bitfield;
  struct {
   uint16_t pcr_pid:13;
   uint16_t reserved:3;
  } ;
 } ;

 uint8_t number_elements;
};

# 24 "descriptors/desc_atsc_service_location.c"
int atsc_desc_service_location_init(struct dvb_v5_fe_parms *parms,
         const uint8_t *buf, struct dvb_desc *desc)
{
 struct atsc_desc_service_location *s_loc = (struct atsc_desc_service_location *)desc;
 struct atsc_desc_service_location_elementary *el;
 unsigned char *p = (unsigned char *)buf;
 int i;
 size_t len;

 len = sizeof(*s_loc) - __builtin_offsetof (struct atsc_desc_service_location, bitfield);
 memcpy(&s_loc->bitfield, p, len);
 p += len;

 do { s_loc->bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (s_loc->bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

 if (s_loc->number_elements) {
  s_loc->elementary = malloc(s_loc->number_elements * sizeof(*s_loc->elementary));
  if (!s_loc->elementary) {
   do { parms->logfunc(3 /* error conditions */, "%s: %s", "Can't allocate space for ATSC service location elementary data", strerror((*__errno_location ()))); } while (0);
   return -1;
  }

  el = s_loc->elementary;

  for (i = 0; i < s_loc->number_elements; i++) {
   memcpy(el, p, sizeof(*el));
   do { el->bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (el->bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

   el++;
   p += sizeof(*el);
  }
 } else {
  s_loc->elementary = ((void *)0);
 }
 return 0;
}

# 58 "../../lib/include/libdvbv5/desc_cable_delivery.h"
struct dvb_desc_cable_delivery {
 uint8_t type;
 uint8_t length;
 struct dvb_desc *next;

 uint32_t frequency;
 union {
  uint16_t bitfield1;
  struct {
   uint16_t fec_outer:4;
   uint16_t reserved_future_use:12;
  } ;
 } ;
 uint8_t modulation;
 union {
  uint32_t bitfield2;
  struct {
   uint32_t fec_inner:4;
   uint32_t symbol_rate:28;
  } ;
 } ;
};

# 26 "descriptors/desc_cable_delivery.c"
int dvb_desc_cable_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
{
 struct dvb_desc_cable_delivery *cable = (struct dvb_desc_cable_delivery *) desc;
 /* copy only the data - length already initialize */
 memcpy(((uint8_t *) cable ) + sizeof(cable->type) + sizeof(cable->next) + sizeof(cable->length),
   buf,
   cable->length);
 do { cable->frequency = __bswap_32 (cable->frequency); } while (0);
 do { cable->bitfield1 = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (cable->bitfield1); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
 do { cable->bitfield2 = __bswap_32 (cable->bitfield2); } while (0);
 cable->frequency = dvb_bcd(cable->frequency) * 100;
 cable->symbol_rate = dvb_bcd(cable->symbol_rate) * 100;
 return 0;
}

# 82 "../../lib/include/libdvbv5/atsc_eit.h"
struct atsc_table_eit_event {
 union {
  uint16_t bitfield;
  struct {
           uint16_t event_id:14;
           uint16_t one:2;
  } ;
 } ;
 uint32_t start_time;
 union {
  uint32_t bitfield2;
  struct {
   uint32_t title_length:8;
   uint32_t duration:20;
   uint32_t etm:2;
   uint32_t one2:2;
   uint32_t :2;
  } ;
 } ;
 struct dvb_desc *descriptor;
 struct atsc_table_eit_event *next;
 struct tm start;
 uint16_t source_id;
};

# 122 "../../lib/include/libdvbv5/atsc_eit.h"
union atsc_table_eit_desc_length {
 uint16_t bitfield;
 struct {
  uint16_t desc_length:12;
  uint16_t reserved:4;
 } ;
};

# 147 "../../lib/include/libdvbv5/atsc_eit.h"
struct atsc_table_eit {
 struct dvb_table_header header;
 uint8_t protocol_version;
 uint8_t events;
 struct atsc_table_eit_event *event;
};

# 215 "../../lib/include/libdvbv5/atsc_eit.h"
void atsc_time(const uint32_t start_time, struct tm *tm);

# 25 "tables/atsc_eit.c"
ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
  ssize_t buflen, struct atsc_table_eit **table)
{
 const uint8_t *p = buf, *endbuf = buf + buflen;
 struct atsc_table_eit *eit;
 struct atsc_table_eit_event **head;
 size_t size;
 int i = 0;

 size = __builtin_offsetof (struct atsc_table_eit, event);
 if (p + size > endbuf) {
  do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - p, size); } while (0)
                       ;
  return -1;
 }

 if (buf[0] != 0xCB) {
  do { parms->logfunc(3 /* error conditions */, "%s: invalid marker 0x%02x, sould be 0x%02x", __func__, buf[0], 0xCB); } while (0)
                                     ;
  return -2;
 }

 if (!*table) {
  *table = calloc(sizeof(struct atsc_table_eit), 1);
  if (!*table) {
   do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
   return -3;
  }
 }
 eit = *table;
 memcpy(eit, p, size);
 p += size;
 dvb_table_header_init(&eit->header);

 /* find end of curent list */
 head = &eit->event;
 while (*head != ((void *)0))
  head = &(*head)->next;

 while (i++ < eit->events && p < endbuf) {
  struct atsc_table_eit_event *event;
                union atsc_table_eit_desc_length dl;

  size = __builtin_offsetof (struct atsc_table_eit_event, descriptor);
  if (p + size > endbuf) {
   do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - p, size); } while (0)
                        ;
   return -4;
  }
  event = (struct atsc_table_eit_event *) malloc(sizeof(struct atsc_table_eit_event));
  if (!event) {
   do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
   return -5;
  }
  memcpy(event, p, size);
  p += size;

  do { event->bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (event->bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  do { event->start_time = __bswap_32 (event->start_time); } while (0);
  do { event->bitfield2 = __bswap_32 (event->bitfield2); } while (0);
  event->descriptor = ((void *)0);
  event->next = ((void *)0);
                atsc_time(event->start_time, &event->start);
  event->source_id = eit->header.id;

  *head = event;
  head = &(*head)->next;

  size = event->title_length - 1;
  if (p + size > endbuf) {
   do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - p, size); } while (0)
                        ;
   return -6;
  }
                /* TODO: parse title */
                p += size;

  /* get the descriptors for each program */
  size = sizeof(union atsc_table_eit_desc_length);
  if (p + size > endbuf) {
   do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - p, size); } while (0)
                        ;
   return -7;
  }
  memcpy(&dl, p, size);
                p += size;
                do { dl.bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dl.bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

  size = dl.desc_length;
  if (p + size > endbuf) {
   do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - p, size); } while (0)
                        ;
   return -8;
  }
  if (dvb_desc_parse(parms, p, size,
     &event->descriptor) != 0 ) {
   return -9;
  }

  p += size;
 }

 return p - buf;
}

# 78 "../../lib/include/libdvbv5/mgt.h"
struct atsc_table_mgt_table {
 uint16_t type;
 union {
  uint16_t bitfield;
  struct {
   uint16_t pid:13;
   uint16_t one:3;
  } ;
 } ;
        uint8_t type_version:5;
        uint8_t one2:3;
        uint32_t size;
 union {
  uint16_t bitfield2;
  struct {
   uint16_t desc_length:12;
   uint16_t one3:4;
  } ;
 } ;
 struct dvb_desc *descriptor;
 struct atsc_table_mgt_table *next;
};

# 123 "../../lib/include/libdvbv5/mgt.h"
struct atsc_table_mgt {
 struct dvb_table_header header;
 uint8_t protocol_version;
        uint16_t tables;
        struct atsc_table_mgt_table *table;
 struct dvb_desc *descriptor;
};

# 25 "tables/mgt.c"
ssize_t atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
  ssize_t buflen, struct atsc_table_mgt **table)
{
 const uint8_t *p = buf, *endbuf = buf + buflen;
 struct atsc_table_mgt *mgt;
 struct atsc_table_mgt_table **head;
 struct dvb_desc **head_desc;
 size_t size;
 int i = 0;

 size = __builtin_offsetof (struct atsc_table_mgt, table);
 if (p + size > endbuf) {
  do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - p, size); } while (0)
                       ;
  return -1;
 }

 if (buf[0] != 0xC7) {
  do { parms->logfunc(3 /* error conditions */, "%s: invalid marker 0x%02x, sould be 0x%02x", __func__, buf[0], 0xC7); } while (0)
                                     ;
  return -2;
 }

 if (!*table) {
  *table = calloc(sizeof(struct atsc_table_mgt), 1);
  if (!*table) {
   do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
   return -3;
  }
 }
 mgt = *table;
 memcpy(mgt, p, size);
 p += size;
 dvb_table_header_init(&mgt->header);

 do { mgt->tables = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (mgt->tables); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);

 /* find end of curent lists */
 head_desc = &mgt->descriptor;
 while (*head_desc != ((void *)0))
  head_desc = &(*head_desc)->next;
 head = &mgt->table;
 while (*head != ((void *)0))
  head = &(*head)->next;

 while (i++ < mgt->tables && p < endbuf) {
  struct atsc_table_mgt_table *table;

  size = __builtin_offsetof (struct atsc_table_mgt_table, descriptor);
  if (p + size > endbuf) {
   do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - p, size); } while (0)
                        ;
   return -4;
  }
  table = (struct atsc_table_mgt_table *) malloc(sizeof(struct atsc_table_mgt_table));
  if (!table) {
   do { parms->logfunc(3 /* error conditions */, "%s: out of memory", __func__); } while (0);
   return -5;
  }
  memcpy(table, p, size);
  p += size;

  do { table->type = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (table->type); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  do { table->bitfield = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (table->bitfield); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  do { table->bitfield2 = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (table->bitfield2); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); } while (0);
  do { table->size = __bswap_32 (table->size); } while (0);
  table->descriptor = ((void *)0);
  table->next = ((void *)0);

  *head = table;
  head = &(*head)->next;

  /* parse the descriptors */
  size = table->desc_length;
  if (p + size > endbuf) {
   do { parms->logfunc(3 /* error conditions */, "%s: short read %zd/%zd bytes", __func__, endbuf - p, size); } while (0)
                        ;
   return -6;
  }
  if (dvb_desc_parse(parms, p, size,
     &table->descriptor) != 0) {
   return -7;
  }

  p += size;
 }

 /* TODO: parse MGT descriptors here into head_desc */

 return p - buf;
}

