unsigned int __builtin_bswap32 (unsigned int);
unsigned int __builtin_object_size (const void *, int);
void * __builtin___memset_chk (void *, int, unsigned int, unsigned int);

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 55 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long long int __quad_t;

# 131 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __off_t;

# 132 "/usr/include/i386-linux-gnu/bits/types.h"
typedef __quad_t __off64_t;

# 44 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}

# 195 "/usr/include/i386-linux-gnu/sys/types.h"
typedef int int16_t;

# 196 "/usr/include/i386-linux-gnu/sys/types.h"
typedef int int32_t;

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

# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 87 "../include/complib/cl_types_osd.h"
typedef int boolean_t;

# 289 "../include/complib/cl_types.h"
typedef int cl_status_t;

# 397 "../include/complib/cl_types.h"
typedef enum _cl_state {
 CL_UNINITIALIZED = 1,
 CL_INITIALIZED,
 CL_DESTROYING,
 CL_DESTROYED
} cl_state_t;

# 1935 "../include/iba/ib_types.h"
typedef uint16_t ib_net16_t;

# 1947 "../include/iba/ib_types.h"
typedef uint32_t ib_net32_t;

# 1959 "../include/iba/ib_types.h"
typedef uint64_t ib_net64_t;

# 1970 "../include/iba/ib_types.h"
typedef ib_net64_t ib_gid_prefix_t;

# 2259 "../include/iba/ib_types.h"
typedef union _ib_gid {
 uint8_t raw[16];
 struct _ib_gid_unicast {
  ib_gid_prefix_t prefix;
  ib_net64_t interface_id;
 } unicast;
 struct _ib_gid_multicast {
  uint8_t header[2];
  uint8_t raw_group_id[14];
 } multicast;
} ib_gid_t;

# 2497 "../include/iba/ib_types.h"
typedef struct _ib_path_rec {
 ib_net64_t service_id;
 ib_gid_t dgid;
 ib_gid_t sgid;
 ib_net16_t dlid;
 ib_net16_t slid;
 ib_net32_t hop_flow_raw;
 uint8_t tclass;
 uint8_t num_path;
 ib_net16_t pkey;
 ib_net16_t qos_class_sl;
 uint8_t mtu;
 uint8_t rate;
 uint8_t pkt_life;
 uint8_t preference;
 uint8_t resv2[6];
} ib_path_rec_t;

# 2846 "../include/iba/ib_types.h"
static inline void
ib_path_rec_init_local(/* Function input parameter */ ib_path_rec_t * const p_rec,
         /* Function input parameter */ ib_gid_t * const p_dgid,
         /* Function input parameter */ ib_gid_t * const p_sgid,
         /* Function input parameter */ ib_net16_t dlid,
         /* Function input parameter */ ib_net16_t slid,
         /* Function input parameter */ uint8_t num_path,
         /* Function input parameter */ ib_net16_t pkey,
         /* Function input parameter */ uint8_t sl,
         /* Function input parameter */ uint16_t qos_class,
         /* Function input parameter */ uint8_t mtu_selector,
         /* Function input parameter */ uint8_t mtu,
         /* Function input parameter */ uint8_t rate_selector,
         /* Function input parameter */ uint8_t rate,
         /* Function input parameter */ uint8_t pkt_life_selector,
         /* Function input parameter */ uint8_t pkt_life, /* Function input parameter */ uint8_t preference)
{
 p_rec->dgid = *p_dgid;
 p_rec->sgid = *p_sgid;
 p_rec->dlid = dlid;
 p_rec->slid = slid;
 p_rec->num_path = num_path;
 p_rec->pkey = pkey;
 p_rec->qos_class_sl = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((sl & 0x000F) | (qos_class << 4)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))
                      ;
 p_rec->mtu = (uint8_t) ((mtu & 0x3F) |
    (uint8_t) (mtu_selector << 6));
 p_rec->rate = (uint8_t) ((rate & 0x3F) |
     (uint8_t) (rate_selector << 6));
 p_rec->pkt_life = (uint8_t) ((pkt_life & 0x3F) |
         (uint8_t) (pkt_life_selector << 6));
 p_rec->preference = preference;

 /* Clear global routing fields for local path records */
 p_rec->hop_flow_raw = 0;
 p_rec->tclass = 0;
 p_rec->service_id = 0;

 memset(p_rec->resv2, 0, sizeof(p_rec->resv2));
}

# 2987 "../include/iba/ib_types.h"
static inline void
ib_path_rec_set_sl(/* Function input parameter */ ib_path_rec_t * const p_rec, /* Function input parameter */ const uint8_t sl)
{
 p_rec->qos_class_sl =
     (p_rec->qos_class_sl & (uint16_t)( (((uint16_t)(0xFFF0) & 0x00FF) << 8) | (((uint16_t)(0xFFF0) & 0xFF00) >> 8) )) |
     (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sl & 0x000F); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 3021 "../include/iba/ib_types.h"
static inline uint8_t
ib_path_rec_sl(/* Function input parameter */ const ib_path_rec_t * const p_rec)
{
 return (uint8_t)((__extension__ ({ unsigned short int __v, __x = (unsigned short int) (p_rec->qos_class_sl); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) & 0x000F);
}

# 3050 "../include/iba/ib_types.h"
static inline void
ib_path_rec_set_qos_class(/* Function input parameter */ ib_path_rec_t * const p_rec,
     /* Function input parameter */ const uint16_t qos_class)
{
 p_rec->qos_class_sl =
     (p_rec->qos_class_sl & (uint16_t)( (((uint16_t)(0x000F) & 0x00FF) << 8) | (((uint16_t)(0x000F) & 0xFF00) >> 8) )) |
     (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (qos_class << 4); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 3085 "../include/iba/ib_types.h"
static inline uint16_t
ib_path_rec_qos_class(/* Function input parameter */ const ib_path_rec_t * const p_rec)
{
 return ((__extension__ ({ unsigned short int __v, __x = (unsigned short int) (p_rec->qos_class_sl); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) >> 4);
}

# 4375 "../include/iba/ib_types.h"
typedef struct _ib_node_info {
 uint8_t base_version;
 uint8_t class_version;
 uint8_t node_type;
 uint8_t num_ports;
 ib_net64_t sys_guid;
 ib_net64_t node_guid;
 ib_net64_t port_guid;
 ib_net16_t partition_cap;
 ib_net16_t device_id;
 ib_net32_t revision;
 ib_net32_t port_num_vendor_id;
} ib_node_info_t;

# 4430 "../include/iba/ib_types.h"
static inline uint32_t ib_get_attr_size(/* Function input parameter */ const ib_net16_t attr_offset)
{
 return (((uint32_t) (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (attr_offset); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))) << 3);
}

# 4435 "../include/iba/ib_types.h"
static inline ib_net16_t ib_get_attr_offset(/* Function input parameter */ const uint32_t attr_size)
{
 return ((__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((uint16_t) (attr_size >> 3)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
}

# 4541 "../include/iba/ib_types.h"
typedef struct _ib_node_desc {
 // Node String is an array of UTF-8 characters
 // that describe the node in text format
 // Note that this string is NOT NULL TERMINATED!
 uint8_t description[64];
} ib_node_desc_t;

# 4569 "../include/iba/ib_types.h"
typedef struct _ib_port_info {
 ib_net64_t m_key;
 ib_net64_t subnet_prefix;
 ib_net16_t base_lid;
 ib_net16_t master_sm_base_lid;
 ib_net32_t capability_mask;
 ib_net16_t diag_code;
 ib_net16_t m_key_lease_period;
 uint8_t local_port_num;
 uint8_t link_width_enabled;
 uint8_t link_width_supported;
 uint8_t link_width_active;
 uint8_t state_info1; /* LinkSpeedSupported and PortState */
 uint8_t state_info2; /* PortPhysState and LinkDownDefaultState */
 uint8_t mkey_lmc; /* M_KeyProtectBits and LMC */
 uint8_t link_speed; /* LinkSpeedEnabled and LinkSpeedActive */
 uint8_t mtu_smsl;
 uint8_t vl_cap; /* VLCap and InitType */
 uint8_t vl_high_limit;
 uint8_t vl_arb_high_cap;
 uint8_t vl_arb_low_cap;
 uint8_t mtu_cap;
 uint8_t vl_stall_life;
 uint8_t vl_enforce;
 ib_net16_t m_key_violations;
 ib_net16_t p_key_violations;
 ib_net16_t q_key_violations;
 uint8_t guid_cap;
 uint8_t subnet_timeout; /* cli_rereg(1b), mcast_pkey_trap_suppr(1b), reserv(1b), timeout(5b) */
 uint8_t resp_time_value; /* reserv(3b), rtv(5b) */
 uint8_t error_threshold; /* local phy errors(4b), overrun errors(4b) */
 ib_net16_t max_credit_hint;
 ib_net32_t link_rt_latency; /* reserv(8b), link round trip lat(24b) */
 ib_net16_t capability_mask2;
 uint8_t link_speed_ext; /* LinkSpeedExtActive and LinkSpeedExtSupported */
 uint8_t link_speed_ext_enabled; /* reserv(3b), LinkSpeedExtEnabled(5b) */
} ib_port_info_t;

# 6315 "../include/iba/ib_types.h"
typedef struct _ib_mlnx_ext_port_info {
 uint8_t resvd1[3];
 uint8_t state_change_enable;
 uint8_t resvd2[3];
 uint8_t link_speed_supported;
 uint8_t resvd3[3];
 uint8_t link_speed_enabled;
 uint8_t resvd4[3];
 uint8_t link_speed_active;
 uint8_t resvd5[48];
} ib_mlnx_ext_port_info_t;

# 6426 "../include/iba/ib_types.h"
typedef struct _ib_switch_info {
 ib_net16_t lin_cap;
 ib_net16_t rand_cap;
 ib_net16_t mcast_cap;
 ib_net16_t lin_top;
 uint8_t def_port;
 uint8_t def_mcast_pri_port;
 uint8_t def_mcast_not_port;
 uint8_t life_state;
 ib_net16_t lids_per_port;
 ib_net16_t enforce_cap;
 uint8_t flags;
 uint8_t resvd;
 ib_net16_t mcast_top;
} ib_switch_info_t;

# 6659 "../include/iba/ib_types.h"
typedef struct _ib_multipath_rec_t {
 ib_net32_t hop_flow_raw;
 uint8_t tclass;
 uint8_t num_path;
 ib_net16_t pkey;
 ib_net16_t qos_class_sl;
 uint8_t mtu;
 uint8_t rate;
 uint8_t pkt_life;
 uint8_t service_id_8msb;
 uint8_t independence; /* formerly resv2 */
 uint8_t sgid_count;
 uint8_t dgid_count;
 uint8_t service_id_56lsb[7];
 ib_gid_t gids[11 /* Support max that can fit into first MAD (for now) */];
} ib_multipath_rec_t;

# 6754 "../include/iba/ib_types.h"
static inline void
ib_multipath_rec_set_sl(
 /* Function input parameter */ ib_multipath_rec_t* const p_rec,
 /* Function input parameter */ const uint8_t sl )
{
 p_rec->qos_class_sl =
  (p_rec->qos_class_sl & (uint16_t)( (((uint16_t)(0xFFF0) & 0x00FF) << 8) | (((uint16_t)(0xFFF0) & 0xFF00) >> 8) )) |
   (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sl & 0x000F); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 6789 "../include/iba/ib_types.h"
static inline uint8_t
ib_multipath_rec_sl(/* Function input parameter */ const ib_multipath_rec_t * const p_rec)
{
 return ((uint8_t) (((__extension__ ({ unsigned short int __v, __x = (unsigned short int) (p_rec->qos_class_sl); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))) & 0x000F));
}

# 6818 "../include/iba/ib_types.h"
static inline void
ib_multipath_rec_set_qos_class(
 /* Function input parameter */ ib_multipath_rec_t* const p_rec,
 /* Function input parameter */ const uint16_t qos_class )
{
 p_rec->qos_class_sl =
  (p_rec->qos_class_sl & (uint16_t)( (((uint16_t)(0x000F) & 0x00FF) << 8) | (((uint16_t)(0x000F) & 0xFF00) >> 8) )) |
   (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (qos_class << 4); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 6853 "../include/iba/ib_types.h"
static inline uint16_t
ib_multipath_rec_qos_class(
 /* Function input parameter */ const ib_multipath_rec_t* const p_rec )
{
 return ((__extension__ ({ unsigned short int __v, __x = (unsigned short int) (p_rec->qos_class_sl); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) >> 4);
}

# 7294 "../include/iba/ib_types.h"
typedef struct _ib_vl_arb_element {
 uint8_t vl;
 uint8_t weight;
} ib_vl_arb_element_t;

# 7313 "../include/iba/ib_types.h"
typedef struct _ib_vl_arb_table {
 ib_vl_arb_element_t vl_entry[32];
} ib_vl_arb_table_t;

# 7761 "../include/iba/ib_types.h"
typedef struct _ib_mad_notice_attr // Total Size calc  Accumulated
{
 uint8_t generic_type; // 1                1
 union _notice_g_or_v {
  struct _notice_generic // 5                6
  {
   uint8_t prod_type_msb;
   ib_net16_t prod_type_lsb;
   ib_net16_t trap_num;
  } generic;
  struct _notice_vend {
   uint8_t vend_id_msb;
   ib_net16_t vend_id_lsb;
   ib_net16_t dev_id;
  } vend;
 } g_or_v;
 ib_net16_t issuer_lid; // 2                 8
 ib_net16_t toggle_count; // 2                 10
 union _data_details // 54                64
 {
  struct _raw_data {
   uint8_t details[54];
  } raw_data;
  struct _ntc_64_67 {
   uint8_t res[6];
   ib_gid_t gid; // the Node or Multicast Group that came in/out
  } ntc_64_67;
  struct _ntc_128 {
   ib_net16_t sw_lid; // the sw lid of which link state changed
  } ntc_128;
  struct _ntc_129_131 {
   ib_net16_t pad;
   ib_net16_t lid; // lid and port number of the violation
   uint8_t port_num;
  } ntc_129_131;
  struct _ntc_144 {
   ib_net16_t pad1;
   ib_net16_t lid; // lid where change occured
   uint8_t pad2; // reserved
   uint8_t local_changes; // 7b reserved 1b local changes
   ib_net32_t new_cap_mask; // new capability mask
   ib_net16_t change_flgs; // 10b reserved 6b change flags
   ib_net16_t cap_mask2;
  } ntc_144;
  struct _ntc_145 {
   ib_net16_t pad1;
   ib_net16_t lid; // lid where sys guid changed
   ib_net16_t pad2;
   ib_net64_t new_sys_guid; // new system image guid
  } ntc_145;
  struct _ntc_256 { // total: 54
   ib_net16_t pad1; // 2
   ib_net16_t lid; // 2
   ib_net16_t dr_slid; // 2
   uint8_t method; // 1
   uint8_t pad2; // 1
   ib_net16_t attr_id; // 2
   ib_net32_t attr_mod; // 4
   ib_net64_t mkey; // 8
   uint8_t pad3; // 1
   uint8_t dr_trunc_hop; // 1
   uint8_t dr_rtn_path[30]; // 30
  } ntc_256;
  struct _ntc_257_258 // violation of p/q_key // 49
  {
   ib_net16_t pad1; // 2
   ib_net16_t lid1; // 2
   ib_net16_t lid2; // 2
   ib_net32_t key; // 4
   ib_net32_t qp1; // 4b sl, 4b pad, 24b qp1
   ib_net32_t qp2; // 8b pad, 24b qp2
   ib_gid_t gid1; // 16
   ib_gid_t gid2; // 16
  } ntc_257_258;
  struct _ntc_259 // pkey violation from switch 51
  {
   ib_net16_t data_valid; // 2
   ib_net16_t lid1; // 2
   ib_net16_t lid2; // 2
   ib_net16_t pkey; // 2
   ib_net32_t sl_qp1; // 4b sl, 4b pad, 24b qp1
   ib_net32_t qp2; // 8b pad, 24b qp2
   ib_gid_t gid1; // 16
   ib_gid_t gid2; // 16
   ib_net16_t sw_lid; // 2
   uint8_t port_no; // 1
  } ntc_259;
  struct _ntc_bkey_259 // bkey violation
  {
   ib_net16_t lidaddr;
   uint8_t method;
   uint8_t reserved;
   ib_net16_t attribute_id;
   ib_net32_t attribute_modifier;
   ib_net32_t qp; // qp is low 24 bits
   ib_net64_t bkey;
   ib_gid_t gid;
  } ntc_bkey_259;
  struct _ntc_cckey_0 // CC key violation
  {
   ib_net16_t slid; // source LID from offending packet LRH
   uint8_t method; // method, from common MAD header
   uint8_t resv0;
   ib_net16_t attribute_id; // Attribute ID, from common MAD header
   ib_net16_t resv1;
   ib_net32_t attribute_modifier; // Attribute Modif, from common MAD header
   ib_net32_t qp; // 8b pad, 24b dest QP from BTH
   ib_net64_t cc_key; // CC key of the offending packet
   ib_gid_t source_gid; // GID from GRH of the offending packet
   uint8_t padding[14]; // Padding - ignored on read
  } ntc_cckey_0;
 } data_details;
 ib_gid_t issuer_gid; // 16          80
} ib_mad_notice_attr_t;

# 7957 "../include/iba/ib_types.h"
static inline ib_net32_t
ib_notice_get_prod_type(/* Function input parameter */ const ib_mad_notice_attr_t * p_ntc)
{
 uint32_t pt;

 pt = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (p_ntc->g_or_v.generic.prod_type_lsb); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) |
     (p_ntc->g_or_v.generic.prod_type_msb << 16);
 return __bswap_32 (pt);
}

# 7988 "../include/iba/ib_types.h"
static inline void
ib_notice_set_prod_type(/* Function input parameter */ ib_mad_notice_attr_t * p_ntc,
   /* Function input parameter */ ib_net32_t prod_type_val)
{
 uint32_t ptv = __bswap_32 (prod_type_val);
 p_ntc->g_or_v.generic.prod_type_lsb =
     (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((uint16_t) (ptv & 0x0000ffff)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 p_ntc->g_or_v.generic.prod_type_msb =
     (uint8_t) ((ptv & 0x00ff0000) >> 16);
}

# 8023 "../include/iba/ib_types.h"
static inline void
ib_notice_set_prod_type_ho(/* Function input parameter */ ib_mad_notice_attr_t * p_ntc,
      /* Function input parameter */ uint32_t prod_type_val_ho)
{
 p_ntc->g_or_v.generic.prod_type_lsb =
     (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((uint16_t) (prod_type_val_ho & 0x0000ffff)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 p_ntc->g_or_v.generic.prod_type_msb =
     (uint8_t) ((prod_type_val_ho & 0x00ff0000) >> 16);
}

# 8057 "../include/iba/ib_types.h"
static inline ib_net32_t
ib_notice_get_vend_id(/* Function input parameter */ const ib_mad_notice_attr_t * p_ntc)
{
 uint32_t vi;

 vi = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (p_ntc->g_or_v.vend.vend_id_lsb); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) |
     (p_ntc->g_or_v.vend.vend_id_msb << 16);
 return __bswap_32 (vi);
}

# 8088 "../include/iba/ib_types.h"
static inline void
ib_notice_set_vend_id(/* Function input parameter */ ib_mad_notice_attr_t * p_ntc, /* Function input parameter */ ib_net32_t vend_id)
{
 uint32_t vi = __bswap_32 (vend_id);
 p_ntc->g_or_v.vend.vend_id_lsb =
     (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((uint16_t) (vi & 0x0000ffff)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 p_ntc->g_or_v.vend.vend_id_msb = (uint8_t) ((vi & 0x00ff0000) >> 16);
}

# 8121 "../include/iba/ib_types.h"
static inline void
ib_notice_set_vend_id_ho(/* Function input parameter */ ib_mad_notice_attr_t * p_ntc,
    /* Function input parameter */ uint32_t vend_id_ho)
{
 p_ntc->g_or_v.vend.vend_id_lsb =
     (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((uint16_t) (vend_id_ho & 0x0000ffff)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 p_ntc->g_or_v.vend.vend_id_msb =
     (uint8_t) ((vend_id_ho & 0x00ff0000) >> 16);
}

# 8147 "../include/iba/ib_types.h"
typedef struct _ib_inform_info {
 ib_gid_t gid;
 ib_net16_t lid_range_begin;
 ib_net16_t lid_range_end;
 ib_net16_t reserved1;
 uint8_t is_generic;
 uint8_t subscribe;
 ib_net16_t trap_type;
 union _inform_g_or_v {
  struct _inform_generic {
   ib_net16_t trap_num;
   ib_net32_t qpn_resp_time_val;
   uint8_t reserved2;
   uint8_t node_type_msb;
   ib_net16_t node_type_lsb;
  } generic;
  struct _inform_vend {
   ib_net16_t dev_id;
   ib_net32_t qpn_resp_time_val;
   uint8_t reserved2;
   uint8_t vendor_id_msb;
   ib_net16_t vendor_id_lsb;
  } vend;
 } g_or_v;
} ib_inform_info_t;

# 8253 "../include/iba/ib_types.h"
static inline ib_net32_t
ib_inform_info_get_prod_type(/* Function input parameter */ const ib_inform_info_t * p_inf)
{
 uint32_t nt;

 nt = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (p_inf->g_or_v.generic.node_type_lsb); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) |
     (p_inf->g_or_v.generic.node_type_msb << 16);
 return __bswap_32 (nt);
}

# 8286 "../include/iba/ib_types.h"
static inline ib_net32_t
ib_inform_info_get_vend_id(/* Function input parameter */ const ib_inform_info_t * p_inf)
{
 uint32_t vi;

 vi = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (p_inf->g_or_v.vend.vendor_id_lsb); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) |
     (p_inf->g_or_v.vend.vendor_id_msb << 16);
 return __bswap_32 (vi);
}

# 11621 "../include/iba/ib_types.h"
typedef struct _ib_sw_cong_setting {
 ib_net32_t control_map;
 uint8_t victim_mask[32];
 uint8_t credit_mask[32];
 uint8_t threshold_resv;
 uint8_t packet_size;
 ib_net16_t cs_threshold_resv;
 ib_net16_t cs_return_delay;
 ib_net16_t marking_rate;
} ib_sw_cong_setting_t;

# 11773 "../include/iba/ib_types.h"
typedef struct _ib_ca_cong_entry {
 ib_net16_t ccti_timer;
 uint8_t ccti_increase;
 uint8_t trigger_threshold;
 uint8_t ccti_min;
 uint8_t resv0;
 ib_net16_t resv1;
} ib_ca_cong_entry_t;

# 11815 "../include/iba/ib_types.h"
typedef struct _ib_ca_cong_setting {
 ib_net16_t port_control;
 ib_net16_t control_map;
 ib_ca_cong_entry_t entry_list[16];
} ib_ca_cong_setting_t;

# 11851 "../include/iba/ib_types.h"
typedef struct _ib_cc_tbl_entry {
 ib_net16_t shift_multiplier;
} ib_cc_tbl_entry_t;

# 11879 "../include/iba/ib_types.h"
typedef struct _ib_cc_tbl {
 ib_net16_t ccti_limit;
 ib_net16_t resv;
 ib_cc_tbl_entry_t entry_list[64];
} ib_cc_tbl_t;

# 116 "../include/complib/cl_qlist.h"
typedef struct _cl_list_item {
 struct _cl_list_item *p_next;
 struct _cl_list_item *p_prev;



} cl_list_item_t;

# 182 "../include/complib/cl_qlist.h"
typedef struct _cl_qlist {
 cl_list_item_t end;
 size_t count;
 cl_state_t state;
} cl_qlist_t;

# 115 "../include/complib/cl_qcomppool.h"
typedef struct _cl_pool_item {
 cl_list_item_t list_item;




} cl_pool_item_t;

# 179 "../include/complib/cl_qcomppool.h"
typedef cl_status_t
    (*cl_pfn_qcpool_init_t) (/* Function input parameter */ void **const p_comp_array,
        /* Function input parameter */ const uint32_t num_components,
        /* Function input parameter */ void *context,
        /* Function output parameter */ cl_pool_item_t ** const pp_pool_item);

# 246 "../include/complib/cl_qcomppool.h"
typedef void
 (*cl_pfn_qcpool_dtor_t) (/* Function input parameter */ const cl_pool_item_t * const p_pool_item,
     /* Function input parameter */ void *context);

# 286 "../include/complib/cl_qcomppool.h"
typedef struct _cl_qcpool {
 uint32_t num_components;
 size_t *component_sizes;
 void **p_components;
 size_t num_objects;
 size_t max_objects;
 size_t grow_size;
 cl_pfn_qcpool_init_t pfn_init;
 cl_pfn_qcpool_dtor_t pfn_dtor;
 const void *context;
 cl_qlist_t free_list;
 cl_qlist_t alloc_list;
 cl_state_t state;
} cl_qcpool_t;

# 110 "../include/complib/cl_qpool.h"
typedef cl_status_t
    (*cl_pfn_qpool_init_t) (/* Function input parameter */ void *const p_object,
       /* Function input parameter */ void *context,
       /* Function output parameter */ cl_pool_item_t ** const pp_pool_item);

# 166 "../include/complib/cl_qpool.h"
typedef void
 (*cl_pfn_qpool_dtor_t) (/* Function input parameter */ const cl_pool_item_t * const p_pool_item,
    /* Function input parameter */ void *context);

# 206 "../include/complib/cl_qpool.h"
typedef struct _cl_qpool {
 cl_qcpool_t qcpool;
 cl_pfn_qpool_init_t pfn_init;
 cl_pfn_qpool_dtor_t pfn_dtor;
 const void *context;
} cl_qpool_t;

# 113 "../include/complib/cl_qmap.h"
typedef enum _cl_map_color {
 CL_MAP_RED,
 CL_MAP_BLACK
} cl_map_color_t;

# 141 "../include/complib/cl_qmap.h"
typedef struct _cl_map_item {
 /* Must be first to allow casting. */
 cl_pool_item_t pool_item;
 struct _cl_map_item *p_left;
 struct _cl_map_item *p_right;
 struct _cl_map_item *p_up;
 cl_map_color_t color;
 uint64_t key;



} cl_map_item_t;

# 246 "../include/complib/cl_qmap.h"
typedef struct _cl_qmap {
 cl_map_item_t root;
 cl_map_item_t nil;
 cl_state_t state;
 size_t count;
} cl_qmap_t;

# 118 "../include/complib/cl_fleximap.h"
typedef struct _cl_fmap_item {
 /* Must be first to allow casting. */
 cl_pool_item_t pool_item;
 struct _cl_fmap_item *p_left;
 struct _cl_fmap_item *p_right;
 struct _cl_fmap_item *p_up;
 cl_map_color_t color;
 const void *p_key;



} cl_fmap_item_t;

# 184 "../include/complib/cl_fleximap.h"
typedef int
    (*cl_pfn_fmap_cmp_t) (/* Function input parameter */ const void *const p_key1,
     /* Function input parameter */ const void *const p_key2);

# 220 "../include/complib/cl_fleximap.h"
typedef struct _cl_fmap {
 cl_fmap_item_t root;
 cl_fmap_item_t nil;
 cl_state_t state;
 size_t count;
 cl_pfn_fmap_cmp_t pfn_compare;
} cl_fmap_t;

# 110 "../include/complib/cl_map.h"
typedef struct _cl_map {
 cl_qmap_t qmap;
 cl_qpool_t pool;
} cl_map_t;

# 180 "../include/complib/cl_ptr_vector.h"
typedef struct _cl_ptr_vector {
 size_t size;
 size_t grow_size;
 size_t capacity;
 const void **p_ptr_array;
 cl_state_t state;
} cl_ptr_vector_t;

# 118 "../include/complib/cl_list.h"
typedef struct _cl_list {
 cl_qlist_t list;
 cl_qpool_t list_item_pool;
} cl_list_t;

# 55 "../include/complib/cl_spinlock_osd.h"
typedef struct _cl_spinlock_t {
 pthread_mutex_t mutex;
 cl_state_t state;
} cl_spinlock_t;

# 92 "../include/opensm/osm_db.h"
typedef struct osm_db_domain {
 struct osm_db *p_db;
 void *p_domain_imp;
} osm_db_domain_t;

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

# 79 "../include/opensm/osm_subnet.h"
typedef enum _osm_partition_enforce_type_enum {
 OSM_PARTITION_ENFORCE_TYPE_BOTH,
 OSM_PARTITION_ENFORCE_TYPE_IN,
 OSM_PARTITION_ENFORCE_TYPE_OUT,
 OSM_PARTITION_ENFORCE_TYPE_OFF
} osm_partition_enforce_type_enum;

# 90 "../include/opensm/osm_subnet.h"
struct osm_opensm;

# 91 "../include/opensm/osm_subnet.h"
struct osm_qos_policy;

# 123 "../include/opensm/osm_subnet.h"
typedef struct osm_qos_options {
 unsigned max_vls;
 int high_limit;
 char *vlarb_high;
 char *vlarb_low;
 char *sl2vl;
} osm_qos_options_t;

# 160 "../include/opensm/osm_subnet.h"
typedef struct osm_cct_entry {
 uint8_t shift; //Alex: shift 2 bits
 uint16_t multiplier; //Alex multiplier 14 bits
} osm_cct_entry_t;

# 184 "../include/opensm/osm_subnet.h"
typedef struct osm_cacongestion_entry {
 ib_net16_t ccti_timer; //Alex: ccti_timer and ccti_increase should be replaced
 uint8_t ccti_increase;
 uint8_t trigger_threshold;
 uint8_t ccti_min;
} osm_cacongestion_entry_t;

# 216 "../include/opensm/osm_subnet.h"
typedef struct osm_cct {
 osm_cct_entry_t entries[128];
 unsigned int entries_len;
 char *input_str;
} osm_cct_t;

# 246 "../include/opensm/osm_subnet.h"
typedef struct osm_subn_opt {
 const char *config_file;
 ib_net64_t guid;
 ib_net64_t m_key;
 ib_net64_t sm_key;
 ib_net64_t sa_key;
 ib_net64_t subnet_prefix;
 ib_net16_t m_key_lease_period;
 uint8_t m_key_protect_bits;
 boolean_t m_key_lookup;
 uint32_t sweep_interval;
 uint32_t max_wire_smps;
 uint32_t max_wire_smps2;
 uint32_t max_smps_timeout;
 uint32_t transaction_timeout;
 uint32_t transaction_retries;
 uint8_t sm_priority;
 uint8_t lmc;
 boolean_t lmc_esp0;
 uint8_t max_op_vls;
 uint8_t force_link_speed;
 uint8_t force_link_speed_ext;
 uint8_t fdr10;
 boolean_t reassign_lids;
 boolean_t ignore_other_sm;
 boolean_t single_thread;
 boolean_t disable_multicast;
 boolean_t force_log_flush;
 uint8_t subnet_timeout;
 uint8_t packet_life_time;
 uint8_t vl_stall_count;
 uint8_t leaf_vl_stall_count;
 uint8_t head_of_queue_lifetime;
 uint8_t leaf_head_of_queue_lifetime;
 uint8_t local_phy_errors_threshold;
 uint8_t overrun_errors_threshold;
 boolean_t use_mfttop;
 uint32_t sminfo_polling_timeout;
 uint32_t polling_retry_number;
 uint32_t max_msg_fifo_timeout;
 boolean_t force_heavy_sweep;
 uint8_t log_flags;
 char *dump_files_dir;
 char *log_file;
 unsigned long log_max_size;
 char *partition_config_file;
 boolean_t no_partition_enforcement;
 char *part_enforce;
 osm_partition_enforce_type_enum part_enforce_enum;
 boolean_t allow_both_pkeys;
 uint8_t sm_assigned_guid;
 boolean_t qos;
 char *qos_policy_file;
 boolean_t suppress_sl2vl_mad_status_errors;
 boolean_t accum_log_file;
 char *console;
 uint16_t console_port;
 char *port_prof_ignore_file;
 char *hop_weights_file;
 char *port_search_ordering_file;
 boolean_t port_profile_switch_nodes;
 boolean_t sweep_on_trap;
 char *routing_engine_names;
 boolean_t use_ucast_cache;
 boolean_t connect_roots;
 char *lid_matrix_dump_file;
 char *lfts_file;
 char *root_guid_file;
 char *cn_guid_file;
 char *io_guid_file;
 boolean_t port_shifting;
 uint32_t scatter_ports;
 uint16_t max_reverse_hops;
 char *ids_guid_file;
 char *guid_routing_order_file;
 boolean_t guid_routing_order_no_scatter;
 char *sa_db_file;
 boolean_t sa_db_dump;
 char *torus_conf_file;
 boolean_t do_mesh_analysis;
 boolean_t exit_on_fatal;
 boolean_t honor_guid2lid_file;
 boolean_t daemon;
 boolean_t sm_inactive;
 boolean_t babbling_port_policy;
 boolean_t drop_event_subscriptions;
 boolean_t use_optimized_slvl;
 boolean_t fsync_high_avail_files;
 osm_qos_options_t qos_options;
 osm_qos_options_t qos_ca_options;
 osm_qos_options_t qos_sw0_options;
 osm_qos_options_t qos_swe_options;
 osm_qos_options_t qos_rtr_options;
 boolean_t congestion_control;
 ib_net64_t cc_key;
 uint32_t cc_max_outstanding_mads;
 ib_net32_t cc_sw_cong_setting_control_map;
 uint8_t cc_sw_cong_setting_victim_mask[32];
 uint8_t cc_sw_cong_setting_credit_mask[32];
 uint8_t cc_sw_cong_setting_threshold;
 uint8_t cc_sw_cong_setting_packet_size;
 uint8_t cc_sw_cong_setting_credit_starvation_threshold;
 osm_cct_entry_t cc_sw_cong_setting_credit_starvation_return_delay;
 ib_net16_t cc_sw_cong_setting_marking_rate;
 ib_net16_t cc_ca_cong_setting_port_control;
 ib_net16_t cc_ca_cong_setting_control_map;
 osm_cacongestion_entry_t cc_ca_cong_entries[16];
 osm_cct_t cc_cct;
 boolean_t enable_quirks;
 boolean_t no_clients_rereg;

 boolean_t perfmgr;
 boolean_t perfmgr_redir;
 uint16_t perfmgr_sweep_time_s;
 uint32_t perfmgr_max_outstanding_queries;
 boolean_t perfmgr_ignore_cas;
 char *event_db_dump_file;
 int perfmgr_rm_nodes;
 boolean_t perfmgr_log_errors;
 boolean_t perfmgr_query_cpi;
 boolean_t perfmgr_xmit_wait_log;
 uint32_t perfmgr_xmit_wait_threshold;

 char *event_plugin_name;
 char *event_plugin_options;
 char *node_name_map_name;
 char *prefix_routes_file;
 char *log_prefix;
 boolean_t consolidate_ipv6_snm_req;
 struct osm_subn_opt *file_opts; /* used for update */
 uint8_t lash_start_vl; /* starting vl to use in lash */
 uint8_t sm_sl; /* which SL to use for SM/SA communication */
 char *per_module_logging_file;
} osm_subn_opt_t;

# 734 "../include/opensm/osm_subnet.h"
typedef struct osm_subn {
 struct osm_opensm *p_osm;
 cl_qmap_t sw_guid_tbl;
 cl_qmap_t node_guid_tbl;
 cl_qmap_t port_guid_tbl;
 cl_qmap_t alias_port_guid_tbl;
 cl_qmap_t assigned_guids_tbl;
 cl_qmap_t rtr_guid_tbl;
 cl_qlist_t prefix_routes_list;
 cl_qmap_t prtn_pkey_tbl;
 cl_qmap_t sm_guid_tbl;
 cl_qlist_t sa_sr_list;
 cl_qlist_t sa_infr_list;
 cl_qlist_t alias_guid_list;
 cl_ptr_vector_t port_lid_tbl;
 ib_net16_t master_sm_base_lid;
 ib_net16_t sm_base_lid;
 ib_net64_t sm_port_guid;
 uint8_t last_sm_port_state;
 uint8_t sm_state;
 osm_subn_opt_t opt;
 struct osm_qos_policy *p_qos_policy;
 uint16_t max_ucast_lid_ho;
 uint16_t max_mcast_lid_ho;
 uint8_t min_ca_mtu;
 uint8_t min_ca_rate;
 uint8_t min_data_vls;
 uint8_t min_sw_data_vls;
 boolean_t ignore_existing_lfts;
 boolean_t subnet_initialization_error;
 boolean_t force_heavy_sweep;
 boolean_t force_reroute;
 boolean_t in_sweep_hop_0;
 boolean_t first_time_master_sweep;
 boolean_t coming_out_of_standby;
 boolean_t sweeping_enabled;
 unsigned need_update;
 cl_fmap_t mgrp_mgid_tbl;
 osm_db_domain_t *p_g2m;
 osm_db_domain_t *p_neighbor;
 void *mboxes[0xFFFE - 0xC000 + 1];
} osm_subn_t;

# 1245 "../include/opensm/osm_subnet.h"
struct osm_port *osm_get_port_by_lid_ho(const osm_subn_t * subn, uint16_t lid);

# 1408 "../include/opensm/osm_subnet.h"
static inline struct osm_port *osm_get_port_by_lid(/* Function input parameter */ osm_subn_t const * subn,
         /* Function input parameter */ ib_net16_t lid)
{
 return osm_get_port_by_lid_ho(subn, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (lid); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
}

# 1463 "../include/opensm/osm_subnet.h"
static inline struct osm_mgrp_box *osm_get_mbox_by_mlid(osm_subn_t const *p_subn, ib_net16_t mlid)
{
 return (struct osm_mgrp_box *)p_subn->mboxes[(__extension__ ({ unsigned short int __v, __x = (unsigned short int) (mlid); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) - 0xC000];
}

# 82 "../include/opensm/osm_path.h"
typedef struct osm_dr_path {
 uint8_t hop_count;
 uint8_t path[64];
} osm_dr_path_t;

# 84 "../include/opensm/osm_pkey.h"
typedef struct osm_pkeybl {
 cl_map_t accum_pkeys;
 cl_ptr_vector_t blocks;
 cl_ptr_vector_t new_blocks;
 cl_map_t keys;
 cl_qlist_t pending;
 uint16_t last_pkey_idx;
 uint16_t used_blocks;
 uint16_t max_blocks;
 uint16_t rcv_blocks_cnt;
} osm_pkey_tbl_t;

# 106 "../include/opensm/osm_port.h"
typedef struct osm_physp {
 ib_port_info_t port_info;
 ib_mlnx_ext_port_info_t ext_port_info;
 ib_net64_t port_guid;
 ib_net64_t (*p_guids)[];
 uint8_t port_num;
 struct osm_node *p_node;
 struct osm_physp *p_remote_physp;
 boolean_t healthy;
 uint8_t vl_high_limit;
 unsigned need_update;
 unsigned is_prof_ignored;
 osm_dr_path_t dr_path;
 osm_pkey_tbl_t pkeys;
 ib_vl_arb_table_t vl_arb[4];
 cl_ptr_vector_t slvl_by_port;
 uint8_t hop_wf;
 union {
  struct {
   ib_sw_cong_setting_t sw_cong_setting;
  } sw;
  struct {
   ib_ca_cong_setting_t ca_cong_setting;
   ib_cc_tbl_t cc_tbl[(128/64)];
  } ca;
 } cc;
} osm_physp_t;

# 325 "../include/opensm/osm_port.h"
static inline boolean_t osm_physp_is_valid(/* Function input parameter */ const osm_physp_t * p_physp)
{
 ;
 return (p_physp->port_guid != 0);
}

# 97 "../include/opensm/osm_node.h"
typedef struct osm_node {
 cl_map_item_t map_item;
 struct osm_switch *sw;
 ib_node_info_t node_info;
 ib_node_desc_t node_desc;
 uint32_t discovery_count;
 uint32_t physp_tbl_size;
 char *print_desc;
 uint8_t *physp_discovered;
 osm_physp_t physp_table[1];
} osm_node_t;

# 217 "../include/opensm/osm_node.h"
static inline osm_physp_t *osm_node_get_physp_ptr(/* Function input parameter */ osm_node_t * p_node,
        /* Function input parameter */ uint32_t port_num)
{

 ;
 return osm_physp_is_valid(&p_node->physp_table[port_num]) ?
  &p_node->physp_table[port_num] : ((void *)0);
}

# 71 "../include/opensm/osm_mcast_tbl.h"
typedef struct osm_mcast_fwdbl {
 uint8_t num_ports;
 uint8_t max_position;
 uint16_t max_block;
 int16_t max_block_in_use;
 uint16_t num_entries;
 uint16_t max_mlid_ho;
 uint16_t mft_depth;
 uint16_t(*p_mask_tbl)[][0xF + 1];
} osm_mcast_tbl_t;

# 92 "../include/opensm/osm_port_profile.h"
typedef struct osm_port_profile {
 uint32_t num_paths;
} osm_port_profile_t;

# 94 "../include/opensm/osm_switch.h"
typedef struct osm_switch {
 cl_map_item_t map_item;
 osm_node_t *p_node;
 ib_switch_info_t switch_info;
 uint16_t max_lid_ho;
 uint8_t num_ports;
 uint16_t num_hops;
 uint8_t **hops;
 osm_port_profile_t *p_prof;
 uint8_t *search_ordering_ports;
 uint8_t *lft;
 uint8_t *new_lft;
 uint16_t lft_size;
 osm_mcast_tbl_t mcast_tbl;
 int32_t mft_block_num;
 uint32_t mft_position;
 unsigned endport_links;
 unsigned need_update;
 void *priv;
 cl_map_item_t mgrp_item;
 uint32_t num_of_mcm;
 uint8_t is_mc_member;
} osm_switch_t;

# 419 "../include/opensm/osm_switch.h"
static inline uint8_t osm_switch_get_port_by_lid(/* Function input parameter */ const osm_switch_t * p_sw,
       /* Function input parameter */ uint16_t lid_ho)
{
 if (lid_ho == 0 || lid_ho > p_sw->max_lid_ho)
  return 0xFF;
 return p_sw->lft[lid_ho];
}

# 452 "../include/opensm/osm_switch.h"
static inline osm_physp_t *osm_switch_get_route_by_lid(/* Function input parameter */ const osm_switch_t *
             p_sw, /* Function input parameter */ ib_net16_t lid)
{
 uint8_t port_num;

 ;
 ;

 port_num = osm_switch_get_port_by_lid(p_sw, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (lid); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));

 /*
	   In order to avoid holes in the subnet (usually happens when
	   running UPDN algorithm), i.e. cases where port is
	   unreachable through a switch (we put an OSM_NO_PATH value at
	   the port entry, we do not assert on unreachable lid entries
	   at the fwd table but return NULL
	 */
 if (port_num != 0xFF)
  return (osm_node_get_physp_ptr(p_sw->p_node, port_num));
 else
  return ((void *)0);
}

# 538 "../include/opensm/osm_switch.h"
static inline uint16_t
osm_switch_get_max_block_id_in_use(/* Function input parameter */ const osm_switch_t * p_sw)
{
 return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (p_sw->switch_info.lin_top); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) / 64;
}

# 1022 "../include/opensm/osm_switch.h"
static inline uint16_t
osm_switch_get_mcast_fwd_tbl_size(/* Function input parameter */ const osm_switch_t * p_sw)
{
 return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (p_sw->switch_info.mcast_cap); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 99 "../include/opensm/osm_mtree.h"
typedef struct osm_mtree_node {
 cl_map_item_t map_item;
 const osm_switch_t *p_sw;
 uint8_t max_children;
 struct osm_mtree_node *p_up;
 struct osm_mtree_node *child_array[1];
} osm_mtree_node_t;

# 8973 "../include/iba/ib_types.h"
typedef enum _ib_api_status_t {
 IB_SUCCESS,
 IB_INSUFFICIENT_RESOURCES,
 IB_INSUFFICIENT_MEMORY,
 IB_INVALID_PARAMETER,
 IB_INVALID_SETTING,
 IB_NOT_FOUND,
 IB_TIMEOUT,
 IB_CANCELED,
 IB_INTERRUPTED,
 IB_INVALID_PERMISSION,
 IB_UNSUPPORTED,
 IB_OVERFLOW,
 IB_MAX_MCAST_QPS_REACHED,
 IB_INVALID_QP_STATE,
 IB_INVALID_EEC_STATE,
 IB_INVALID_APM_STATE,
 IB_INVALID_PORT_STATE,
 IB_INVALID_STATE,
 IB_RESOURCE_BUSY,
 IB_INVALID_PKEY,
 IB_INVALID_LKEY,
 IB_INVALID_RKEY,
 IB_INVALID_MAX_WRS,
 IB_INVALID_MAX_SGE,
 IB_INVALID_CQ_SIZE,
 IB_INVALID_SERVICE_TYPE,
 IB_INVALID_GID,
 IB_INVALID_LID,
 IB_INVALID_GUID,
 IB_INVALID_CA_HANDLE,
 IB_INVALID_AV_HANDLE,
 IB_INVALID_CQ_HANDLE,
 IB_INVALID_EEC_HANDLE,
 IB_INVALID_QP_HANDLE,
 IB_INVALID_PD_HANDLE,
 IB_INVALID_MR_HANDLE,
 IB_INVALID_MW_HANDLE,
 IB_INVALID_RDD_HANDLE,
 IB_INVALID_MCAST_HANDLE,
 IB_INVALID_CALLBACK,
 IB_INVALID_AL_HANDLE, /* InfiniBand Access Layer */
 IB_INVALID_HANDLE, /* InfiniBand Access Layer */
 IB_ERROR, /* InfiniBand Access Layer */
 IB_REMOTE_ERROR, /* Infiniband Access Layer */
 IB_VERBS_PROCESSING_DONE, /* See Notes above         */
 IB_INVALID_WR_TYPE,
 IB_QP_IN_TIMEWAIT,
 IB_EE_IN_TIMEWAIT,
 IB_INVALID_PORT,
 IB_NOT_DONE,
 IB_UNKNOWN_ERROR /* ALWAYS LAST ENUM VALUE! */
} ib_api_status_t;

# 48 "/usr/include/stdio.h"
typedef struct _IO_FILE FILE;

# 101 "../include/opensm/osm_log.h"
typedef uint8_t osm_log_level_t;

# 139 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __time_t;

# 75 "/usr/include/time.h"
typedef __time_t time_t;

# 192 "/usr/include/time.h"
extern time_t time (time_t *__timer);

# 8372 "../include/iba/ib_types.h"
typedef struct _ib_port_counters {
 uint8_t reserved;
 uint8_t port_select;
 ib_net16_t counter_select;
 ib_net16_t symbol_err_cnt;
 uint8_t link_err_recover;
 uint8_t link_downed;
 ib_net16_t rcv_err;
 ib_net16_t rcv_rem_phys_err;
 ib_net16_t rcv_switch_relay_err;
 ib_net16_t xmit_discards;
 uint8_t xmit_constraint_err;
 uint8_t rcv_constraint_err;
 uint8_t counter_select2;
 uint8_t link_int_buffer_overrun;
 ib_net16_t resv;
 ib_net16_t vl15_dropped;
 ib_net32_t xmit_data;
 ib_net32_t rcv_data;
 ib_net32_t xmit_pkts;
 ib_net32_t rcv_pkts;
 ib_net32_t xmit_wait;
} ib_port_counters_t;

# 80 "../include/opensm/osm_perfmgr_db.h"
typedef struct {
 uint64_t symbol_err_cnt;
 uint64_t link_err_recover;
 uint64_t link_downed;
 uint64_t rcv_err;
 uint64_t rcv_rem_phys_err;
 uint64_t rcv_switch_relay_err;
 uint64_t xmit_discards;
 uint64_t xmit_constraint_err;
 uint64_t rcv_constraint_err;
 uint64_t link_integrity;
 uint64_t buffer_overrun;
 uint64_t vl15_dropped;
 uint64_t xmit_wait;
 time_t time;
} perfmgr_db_err_reading_t;

# 1037 "osm_perfmgr_db.c"
void
perfmgr_db_fill_err_read(ib_port_counters_t * wire_read,
    perfmgr_db_err_reading_t * reading,
    boolean_t xmit_wait_sup)
{
 reading->symbol_err_cnt = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (wire_read->symbol_err_cnt); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 reading->link_err_recover = wire_read->link_err_recover;
 reading->link_downed = wire_read->link_downed;
 reading->rcv_err = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (wire_read->rcv_err); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 reading->rcv_rem_phys_err = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (wire_read->rcv_rem_phys_err); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 reading->rcv_switch_relay_err =
     (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (wire_read->rcv_switch_relay_err); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 reading->xmit_discards = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (wire_read->xmit_discards); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 reading->xmit_constraint_err = wire_read->xmit_constraint_err;
 reading->rcv_constraint_err = wire_read->rcv_constraint_err;
 reading->link_integrity =
     ((wire_read->link_int_buffer_overrun & 0xF0) >> 4);
 reading->buffer_overrun =
     (wire_read->link_int_buffer_overrun & 0x0F);
 reading->vl15_dropped = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (wire_read->vl15_dropped); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 if (xmit_wait_sup)
  reading->xmit_wait = __bswap_32 (wire_read->xmit_wait);
 else
  reading->xmit_wait = 0;
 reading->time = time(((void *)0));
}

# 90 "osm_mcast_tbl.c"
void osm_mcast_tbl_set(/* Function input parameter */ osm_mcast_tbl_t * p_tbl, /* Function input parameter */ uint16_t mlid_ho,
         /* Function input parameter */ uint8_t port)
{
 unsigned mlid_offset, mask_offset, bit_mask;
 int16_t block_num;

 ;
 ;
 ;

 mlid_offset = mlid_ho - 0xC000;
 mask_offset = port / 16;
 bit_mask = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((uint16_t) (1 << (port % 16))); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 (*p_tbl->p_mask_tbl)[mlid_offset][mask_offset] |= bit_mask;

 block_num = (int16_t) (mlid_offset / 32);

 if (block_num > p_tbl->max_block_in_use)
  p_tbl->max_block_in_use = (uint16_t) block_num;
}

# 144 "osm_mcast_tbl.c"
boolean_t osm_mcast_tbl_is_port(/* Function input parameter */ const osm_mcast_tbl_t * p_tbl,
    /* Function input parameter */ uint16_t mlid_ho, /* Function input parameter */ uint8_t port_num)
{
 unsigned mlid_offset, mask_offset, bit_mask;

 ;

 if (p_tbl->p_mask_tbl) {
 
                                                    ;
  ;
  ;

  mlid_offset = mlid_ho - 0xC000;
  mask_offset = port_num / 16;
  bit_mask = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((uint16_t) (1 << (port_num % 16))); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))
                                                ;
  return (((*p_tbl->
     p_mask_tbl)[mlid_offset][mask_offset] & bit_mask) ==
   bit_mask);
 }

 return 0;
}

# 321 "/usr/include/stdlib.h"
extern long int random (void);

# 466 "/usr/include/stdlib.h"
extern void *malloc (size_t __size);

# 483 "/usr/include/stdlib.h"
extern void free (void *__ptr);

# 3761 "../include/iba/ib_types.h"
typedef struct _ib_mad {
 uint8_t base_ver;
 uint8_t mgmt_class;
 uint8_t class_ver;
 uint8_t method;
 ib_net16_t status;
 ib_net16_t class_spec;
 ib_net64_t trans_id;
 ib_net16_t attr_id;
 ib_net16_t resv;
 ib_net32_t attr_mod;
} ib_mad_t;

# 4082 "../include/iba/ib_types.h"
typedef struct _ib_smp {
 uint8_t base_ver;
 uint8_t mgmt_class;
 uint8_t class_ver;
 uint8_t method;
 ib_net16_t status;
 uint8_t hop_ptr;
 uint8_t hop_count;
 ib_net64_t trans_id;
 ib_net16_t attr_id;
 ib_net16_t resv;
 ib_net32_t attr_mod;
 ib_net64_t m_key;
 ib_net16_t dr_slid;
 ib_net16_t dr_dlid;
 uint32_t resv1[7];
 uint8_t data[64];
 uint8_t initial_path[64];
 uint8_t return_path[64];
} ib_smp_t;

# 4345 "../include/iba/ib_types.h"
static inline void *
ib_smp_get_payload_ptr(/* Function input parameter */ const ib_smp_t * const p_smp)
{
 return ((void *)p_smp->data);
}

# 7343 "../include/iba/ib_types.h"
typedef struct _ib_grh {
 ib_net32_t ver_class_flow;
 ib_net16_t resv1;
 uint8_t resv2;
 uint8_t hop_limit;
 ib_gid_t src_gid;
 ib_gid_t dest_gid;
} ib_grh_t;

# 91 "../include/complib/cl_dispatcher.h"
typedef uint32_t cl_disp_msgid_t;

# 136 "../include/vendor/osm_vendor_ibumad.h"
typedef void *osm_bind_handle_t;

# 174 "../include/vendor/osm_vendor_ibumad.h"
typedef struct _osm_vend_wrap {
 int agent;
 int size;
 int retries;
 void *umad;
 osm_bind_handle_t h_bind;
} osm_vend_wrap_t;

# 71 "../include/opensm/osm_madw.h"
typedef struct osm_bind_info {
 ib_net64_t port_guid;
 uint8_t mad_class;
 uint8_t class_version;
 boolean_t is_responder;
 boolean_t is_trap_processor;
 boolean_t is_report_processor;
 uint32_t send_q_size;
 uint32_t recv_q_size;
 uint32_t timeout;
 uint32_t retries;
} osm_bind_info_t;

# 147 "../include/opensm/osm_madw.h"
typedef struct osm_ni_context {
 ib_net64_t node_guid;
 uint8_t port_num;
 ib_net64_t dup_node_guid;
 uint8_t dup_port_num;
 unsigned dup_count;
} osm_ni_context_t;

# 179 "../include/opensm/osm_madw.h"
typedef struct osm_pi_context {
 ib_net64_t node_guid;
 ib_net64_t port_guid;
 boolean_t set_method;
 boolean_t light_sweep;
 boolean_t active_transition;
 boolean_t client_rereg;
} osm_pi_context_t;

# 198 "../include/opensm/osm_madw.h"
typedef struct osm_gi_context {
 ib_net64_t node_guid;
 ib_net64_t port_guid;
 boolean_t set_method;
 uint8_t port_num;
} osm_gi_context_t;

# 215 "../include/opensm/osm_madw.h"
typedef struct osm_nd_context {
 ib_net64_t node_guid;
} osm_nd_context_t;

# 229 "../include/opensm/osm_madw.h"
typedef struct osm_si_context {
 ib_net64_t node_guid;
 boolean_t set_method;
 boolean_t light_sweep;
 boolean_t lft_top_change;
} osm_si_context_t;

# 246 "../include/opensm/osm_madw.h"
typedef struct osm_lft_context {
 ib_net64_t node_guid;
 boolean_t set_method;
} osm_lft_context_t;

# 261 "../include/opensm/osm_madw.h"
typedef struct osm_mft_context {
 ib_net64_t node_guid;
 boolean_t set_method;
} osm_mft_context_t;

# 276 "../include/opensm/osm_madw.h"
typedef struct osm_smi_context {
 ib_net64_t port_guid;
 boolean_t set_method;
 boolean_t light_sweep;
} osm_smi_context_t;

# 292 "../include/opensm/osm_madw.h"
typedef struct osm_pkey_context {
 ib_net64_t node_guid;
 ib_net64_t port_guid;
 boolean_t set_method;
} osm_pkey_context_t;

# 308 "../include/opensm/osm_madw.h"
typedef struct osm_slvl_context {
 ib_net64_t node_guid;
 ib_net64_t port_guid;
 boolean_t set_method;
} osm_slvl_context_t;

# 324 "../include/opensm/osm_madw.h"
typedef struct osm_vla_context {
 ib_net64_t node_guid;
 ib_net64_t port_guid;
 boolean_t set_method;
} osm_vla_context_t;

# 335 "../include/opensm/osm_madw.h"
typedef struct osm_perfmgr_context {
 uint64_t node_guid;
 uint16_t port;
 uint8_t mad_method; /* was this a get or a set */
 ib_net16_t mad_attr_id;



} osm_perfmgr_context_t;

# 350 "../include/opensm/osm_madw.h"
typedef struct osm_cc_context {
 ib_net64_t node_guid;
 ib_net64_t port_guid;
 uint8_t port;
 uint8_t mad_method; /* was this a get or a set */
 ib_net32_t attr_mod;
} osm_cc_context_t;

# 385 "../include/opensm/osm_madw.h"
typedef union _osm_madw_context {
 osm_ni_context_t ni_context;
 osm_pi_context_t pi_context;
 osm_gi_context_t gi_context;
 osm_nd_context_t nd_context;
 osm_si_context_t si_context;
 osm_lft_context_t lft_context;
 osm_mft_context_t mft_context;
 osm_smi_context_t smi_context;
 osm_slvl_context_t slvl_context;
 osm_pkey_context_t pkey_context;
 osm_vla_context_t vla_context;
 osm_perfmgr_context_t perfmgr_context;
 osm_cc_context_t cc_context;



} osm_madw_context_t;

# 413 "../include/opensm/osm_madw.h"
typedef struct osm_mad_addr {
 ib_net16_t dest_lid;
 uint8_t path_bits;
 uint8_t static_rate;
 union addr_type {
  struct _smi {
   ib_net16_t source_lid;
   uint8_t port_num;
  } smi;

  struct _gsi {
   ib_net32_t remote_qp;
   ib_net32_t remote_qkey;
   uint16_t pkey_ix;
   uint8_t service_level;
   boolean_t global_route;
   ib_grh_t grh_info;
  } gsi;
 } addr_type;
} osm_mad_addr_t;

# 448 "../include/opensm/osm_madw.h"
typedef struct osm_madw {
 cl_list_item_t list_item;
 osm_bind_handle_t h_bind;
 osm_vend_wrap_t vend_wrap;
 osm_mad_addr_t mad_addr;
 osm_bind_info_t bind_info;
 osm_madw_context_t context;
 uint32_t mad_size;
 ib_api_status_t status;
 cl_disp_msgid_t fail_msg;
 boolean_t resp_expected;
 const ib_mad_t *p_mad;
} osm_madw_t;

# 559 "../include/opensm/osm_madw.h"
static inline ib_smp_t *osm_madw_get_smp_ptr(/* Function input parameter */ const osm_madw_t * p_madw)
{
 return ((ib_smp_t *) p_madw->p_mad);
}

# 356 "../include/opensm/osm_port.h"
static inline boolean_t osm_physp_is_healthy(/* Function input parameter */ const osm_physp_t * p_physp)
{
 ;
 return p_physp->healthy;
}

# 749 "../include/opensm/osm_port.h"
static inline osm_physp_t *osm_physp_get_remote(/* Function input parameter */ const osm_physp_t * p_physp)
{
 ;
 return p_physp->p_remote_physp;
}

# 982 "../include/opensm/osm_port.h"
static inline uint8_t osm_physp_get_port_num(/* Function input parameter */ const osm_physp_t * p_physp)
{
 ;
 ;
 return p_physp->port_num;
}

# 1011 "../include/opensm/osm_port.h"
static inline struct osm_node *osm_physp_get_node_ptr(/* Function input parameter */ const osm_physp_t *
             p_physp)
{
 ;
 ;
 return p_physp->p_node;
}

# 1070 "../include/opensm/osm_port.h"
static inline ib_net16_t osm_physp_get_base_lid(/* Function input parameter */ const osm_physp_t * p_physp)
{
 ;
 ;
 return p_physp->port_info.base_lid;
}

# 1187 "../include/opensm/osm_port.h"
typedef struct osm_port {
 cl_map_item_t map_item;
 cl_list_item_t list_item;
 struct osm_node *p_node;
 ib_net64_t guid;
 uint32_t discovery_count;
 unsigned is_new;
 osm_physp_t *p_physp;
 cl_qlist_t mcm_list;
 int flag;
 int use_scatter;
 unsigned int cc_timeout_count;
 int cc_unavailable_flag;
 void *priv;
 ib_net16_t lid;
} osm_port_t;

# 1308 "../include/opensm/osm_port.h"
static inline ib_net16_t osm_port_get_base_lid(/* Function input parameter */ const osm_port_t * p_port)
{
 ;
 return osm_physp_get_base_lid(p_port->p_physp);
}

# 285 "../include/opensm/osm_node.h"
static inline uint8_t osm_node_get_num_physp(/* Function input parameter */ const osm_node_t * p_node)
{
 return (uint8_t) p_node->physp_tbl_size;
}

# 351 "../include/opensm/osm_node.h"
static inline ib_net16_t osm_node_get_base_lid(/* Function input parameter */ const osm_node_t * p_node,
            /* Function input parameter */ uint32_t port_num)
{
 ;
 return osm_physp_get_base_lid(&p_node->physp_table[port_num]);
}

# 124 "../include/opensm/osm_mcast_tbl.h"
void osm_mcast_tbl_init(/* Function input parameter */ osm_mcast_tbl_t * p_tbl, /* Function input parameter */ uint8_t num_ports,
   /* Function input parameter */ uint16_t capacity);

# 204 "../include/opensm/osm_mcast_tbl.h"
void osm_mcast_tbl_destroy(/* Function input parameter */ osm_mcast_tbl_t * p_tbl);

# 132 "../include/opensm/osm_port_profile.h"
static inline void osm_port_prof_construct(/* Function input parameter */ osm_port_profile_t * p_prof)
{
 ;
 memset(p_prof, 0, sizeof(*p_prof));
}

# 187 "../include/opensm/osm_port_profile.h"
static inline uint32_t
osm_port_prof_path_count_get(/* Function input parameter */ const osm_port_profile_t * p_prof)
{
 return p_prof->num_paths;
}

# 181 "../include/opensm/osm_switch.h"
struct osm_remote_guids_count {
 unsigned count;
 struct osm_remote_node {
  osm_node_t *node;
  unsigned forwarded_to;
  uint8_t port;
 } guids[0];
};

# 266 "../include/opensm/osm_switch.h"
static inline uint8_t osm_switch_get_hop_count(/* Function input parameter */ const osm_switch_t * p_sw,
            /* Function input parameter */ uint16_t lid_ho,
            /* Function input parameter */ uint8_t port_num)
{
 return (lid_ho > p_sw->max_lid_ho || !p_sw->hops[lid_ho]) ?
     0xFF : p_sw->hops[lid_ho][port_num];
}

# 355 "../include/opensm/osm_switch.h"
static inline uint8_t osm_switch_get_least_hops(/* Function input parameter */ const osm_switch_t * p_sw,
      /* Function input parameter */ uint16_t lid_ho)
{
 return (lid_ho > p_sw->max_lid_ho || !p_sw->hops[lid_ho]) ?
     0xFF : p_sw->hops[lid_ho][0];
}

# 884 "../include/opensm/osm_switch.h"
static inline uint8_t osm_switch_get_dimn_port(/* Function input parameter */ const osm_switch_t * p_sw,
            /* Function input parameter */ uint8_t port_num)
{
 ;
 if (p_sw->search_ordering_ports == ((void *)0))
  return port_num;
 return p_sw->search_ordering_ports[port_num];
}

# 56 "osm_switch.c"
struct switch_port_path {
 uint8_t port_num;
 uint32_t path_count;
 int found_sys_guid;
 int found_node_guid;
 uint32_t forwarded_to;
};

# 85 "osm_switch.c"
void osm_switch_delete(/* Function input parameter */ /* Function output parameter */ osm_switch_t ** pp_sw)
{
 osm_switch_t *p_sw = *pp_sw;
 unsigned i;

 osm_mcast_tbl_destroy(&p_sw->mcast_tbl);
 if (p_sw->p_prof)
  free(p_sw->p_prof);
 if (p_sw->search_ordering_ports)
  free(p_sw->search_ordering_ports);
 if (p_sw->lft)
  free(p_sw->lft);
 if (p_sw->new_lft)
  free(p_sw->new_lft);
 if (p_sw->hops) {
  for (i = 0; i < p_sw->num_hops; i++)
   if (p_sw->hops[i])
    free(p_sw->hops[i]);
  free(p_sw->hops);
 }
 free(*pp_sw);
 *pp_sw = ((void *)0);
}

# 109 "osm_switch.c"
osm_switch_t *osm_switch_new(/* Function input parameter */ osm_node_t * p_node,
        /* Function input parameter */ const osm_madw_t * p_madw)
{
 osm_switch_t *p_sw;
 ib_switch_info_t *p_si;
 ib_smp_t *p_smp;
 uint8_t num_ports;
 uint32_t port_num;

 ;
 ;

 p_smp = osm_madw_get_smp_ptr(p_madw);
 p_si = ib_smp_get_payload_ptr(p_smp);
 num_ports = osm_node_get_num_physp(p_node);

 ;

 if (!p_si->lin_cap) /* The switch doesn't support LFT */
  return ((void *)0);

 p_sw = malloc(sizeof(*p_sw));
 if (!p_sw)
  return ((void *)0);

 memset(p_sw, 0, sizeof(*p_sw));

 p_sw->p_node = p_node;
 p_sw->switch_info = *p_si;
 p_sw->num_ports = num_ports;
 p_sw->need_update = 2;

 p_sw->p_prof = malloc(sizeof(*p_sw->p_prof) * num_ports);
 if (!p_sw->p_prof)
  goto err;

 memset(p_sw->p_prof, 0, sizeof(*p_sw->p_prof) * num_ports);

 osm_mcast_tbl_init(&p_sw->mcast_tbl, osm_node_get_num_physp(p_node),
      (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (p_si->mcast_cap); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));

 for (port_num = 0; port_num < num_ports; port_num++)
  osm_port_prof_construct(&p_sw->p_prof[port_num]);

 return p_sw;

err:
 osm_switch_delete(&p_sw);
 return ((void *)0);
}

# 176 "osm_switch.c"
static struct osm_remote_node *
switch_find_guid_common(/* Function input parameter */ const osm_switch_t * p_sw,
   /* Function input parameter */ struct osm_remote_guids_count *r,
   /* Function input parameter */ uint8_t port_num, /* Function input parameter */ int find_sys_guid,
   /* Function input parameter */ int find_node_guid)
{
 struct osm_remote_node *p_remote_guid = ((void *)0);
 osm_physp_t *p_physp;
 osm_physp_t *p_rem_physp;
 osm_node_t *p_rem_node;
 uint64_t sys_guid;
 uint64_t node_guid;
 unsigned int i;

 ;

 if (!r)
  goto out;

 p_physp = osm_node_get_physp_ptr(p_sw->p_node, port_num);
 p_rem_physp = osm_physp_get_remote(p_physp);
 p_rem_node = osm_physp_get_node_ptr(p_rem_physp);
 sys_guid = p_rem_node->node_info.sys_guid;
 node_guid = p_rem_node->node_info.node_guid;

 for (i = 0; i < r->count; i++) {
  if ((!find_sys_guid
       || r->guids[i].node->node_info.sys_guid == sys_guid)
      && (!find_node_guid
   || r->guids[i].node->node_info.node_guid == node_guid)) {
   p_remote_guid = &r->guids[i];
   break;
  }
 }

out:
 return p_remote_guid;
}

# 215 "osm_switch.c"
static struct osm_remote_node *
switch_find_sys_guid_count(/* Function input parameter */ const osm_switch_t * p_sw,
      /* Function input parameter */ struct osm_remote_guids_count *r,
      /* Function input parameter */ uint8_t port_num)
{
 return switch_find_guid_common(p_sw, r, port_num, 1, 0);
}

# 223 "osm_switch.c"
static struct osm_remote_node *
switch_find_node_guid_count(/* Function input parameter */ const osm_switch_t * p_sw,
       /* Function input parameter */ struct osm_remote_guids_count *r,
       /* Function input parameter */ uint8_t port_num)
{
 return switch_find_guid_common(p_sw, r, port_num, 0, 1);
}

# 231 "osm_switch.c"
uint8_t osm_switch_recommend_path(/* Function input parameter */ const osm_switch_t * p_sw,
      /* Function input parameter */ osm_port_t * p_port, /* Function input parameter */ uint16_t lid_ho,
      /* Function input parameter */ unsigned start_from,
      /* Function input parameter */ boolean_t ignore_existing,
      /* Function input parameter */ boolean_t routing_for_lmc,
      /* Function input parameter */ boolean_t dor,
      /* Function input parameter */ boolean_t port_shifting,
      /* Function input parameter */ uint32_t scatter_ports)
{
 /*
	   We support an enhanced LMC aware routing mode:
	   In the case of LMC > 0, we can track the remote side
	   system and node for all of the lids of the target
	   and try and avoid routing again through the same
	   system / node.

	   Assume if routing_for_lmc is true that this procedure was
	   provided the tracking array and counter via p_port->priv,
	   and we can conduct this algorithm.
	 */
 uint16_t base_lid;
 uint8_t hops;
 uint8_t least_hops;
 uint8_t port_num;
 uint8_t num_ports;
 uint32_t least_paths = 0xFFFFFFFF;
 unsigned i;
 /*
	   The follwing will track the least paths if the
	   route should go through a new system/node
	 */
 uint32_t least_paths_other_sys = 0xFFFFFFFF;
 uint32_t least_paths_other_nodes = 0xFFFFFFFF;
 uint32_t least_forwarded_to = 0xFFFFFFFF;
 uint32_t check_count;
 uint8_t best_port = 0;
 /*
	   These vars track the best port if it connects to
	   not used system/node.
	 */
 uint8_t best_port_other_sys = 0;
 uint8_t best_port_other_node = 0;
 boolean_t port_found = 0;
 osm_physp_t *p_physp;
 osm_physp_t *p_rem_physp;
 osm_node_t *p_rem_node;
 osm_node_t *p_rem_node_first = ((void *)0);
 struct osm_remote_node *p_remote_guid = ((void *)0);
 struct osm_remote_node null_remote_node = {((void *)0), 0, 0};
 struct switch_port_path port_paths[0xFE];
 unsigned int port_paths_total_paths = 0;
 unsigned int port_paths_count = 0;
 uint8_t scatter_possible_ports[0xFE];
 unsigned int scatter_possible_ports_count = 0;
 int found_sys_guid = 0;
 int found_node_guid = 0;

 ;

 if (p_port->p_node->sw) {
  if (p_port->p_node->sw == p_sw)
   return 0;
  base_lid = osm_port_get_base_lid(p_port);
 } else {
  p_physp = p_port->p_physp;
  if (!p_physp || !p_physp->p_remote_physp ||
      !p_physp->p_remote_physp->p_node->sw)
   return 0xFF;

  if (p_physp->p_remote_physp->p_node->sw == p_sw)
   return p_physp->p_remote_physp->port_num;
  base_lid =
      osm_node_get_base_lid(p_physp->p_remote_physp->p_node, 0);
 }
 base_lid = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (base_lid); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

 num_ports = p_sw->num_ports;

 least_hops = osm_switch_get_least_hops(p_sw, base_lid);
 if (least_hops == 0xFF)
  return 0xFF;

 /*
	   First, inquire with the forwarding table for an existing
	   route.  If one is found, honor it unless:
	   1. the ignore existing flag is set.
	   2. the physical port is not a valid one or not healthy
	   3. the physical port has a remote port (the link is up)
	   4. the port has min-hops to the target (avoid loops)
	 */
 if (!ignore_existing) {
  port_num = osm_switch_get_port_by_lid(p_sw, lid_ho);

  if (port_num != 0xFF) {
   ;

   p_physp =
       osm_node_get_physp_ptr(p_sw->p_node, port_num);
   /*
			   Don't be too trusting of the current forwarding table!
			   Verify that the port number is legal and that the
			   LID is reachable through this port.
			 */
   if (p_physp && osm_physp_is_healthy(p_physp) &&
       osm_physp_get_remote(p_physp)) {
    hops =
        osm_switch_get_hop_count(p_sw, base_lid,
            port_num);
    /*
				   If we aren't using pre-defined user routes
				   function, then we need to make sure that the
				   current path is the minimum one. In case of
				   having such a user function - this check will
				   not be done, and the old routing will be used.
				   Note: This means that it is the user's job to
				   clean all data in the forwarding tables that
				   he wants to be overridden by the minimum
				   hop function.
				 */
    if (hops == least_hops)
     return port_num;
   }
  }
 }

 /*
	   This algorithm selects a port based on a static load balanced
	   selection across equal hop-count ports.
	   There is lots of room for improved sophistication here,
	   possibly guided by user configuration info.
	 */

 /*
	   OpenSM routing is "local" - not considering a full lid to lid
	   path. As such we can not guarantee a path will not loop if we
	   do not always follow least hops.
	   So we must abort if not least hops.
	 */

 /* port number starts with one and num_ports is 1 + num phys ports */
 for (i = start_from; i < start_from + num_ports; i++) {
  port_num = osm_switch_get_dimn_port(p_sw, i % num_ports);
  if (!port_num ||
      osm_switch_get_hop_count(p_sw, base_lid, port_num) !=
      least_hops)
   continue;

  /* let us make sure it is not down or unhealthy */
  p_physp = osm_node_get_physp_ptr(p_sw->p_node, port_num);
  if (!p_physp || !osm_physp_is_healthy(p_physp) ||
      /*
		       we require all - non sma ports to be linked
		       to be routed through
		     */
      !osm_physp_get_remote(p_physp))
   continue;

  /*
		   We located a least-hop port, possibly one of many.
		   For this port, check the running total count of
		   the number of paths through this port.  Select
		   the port routing the least number of paths.
		 */
  check_count =
      osm_port_prof_path_count_get(&p_sw->p_prof[port_num]);


  if (dor) {
   /* Get the Remote Node */
   p_rem_physp = osm_physp_get_remote(p_physp);
   p_rem_node = osm_physp_get_node_ptr(p_rem_physp);
   /* use the first dimension, but spread traffic
			 * out among the group of ports representing
			 * that dimension */
   if (!p_rem_node_first)
    p_rem_node_first = p_rem_node;
   else if (p_rem_node != p_rem_node_first)
    continue;
   if (routing_for_lmc) {
    struct osm_remote_guids_count *r = p_port->priv;
    uint8_t rem_port = osm_physp_get_port_num(p_rem_physp);
    unsigned int j;

    for (j = 0; j < r->count; j++) {
     p_remote_guid = &r->guids[j];
     if ((p_remote_guid->node == p_rem_node)
         && (p_remote_guid->port == rem_port))
      break;
    }
    if (j == r->count)
     p_remote_guid = &null_remote_node;
   }
  /*
		   Advanced LMC routing requires tracking of the
		   best port by the node connected to the other side of
		   it.
		 */
  } else if (routing_for_lmc) {
   /* Is the sys guid already used ? */
   p_remote_guid = switch_find_sys_guid_count(p_sw,
           p_port->priv,
           port_num);

   /* If not update the least hops for this case */
   if (!p_remote_guid) {
    if (check_count < least_paths_other_sys) {
     least_paths_other_sys = check_count;
     best_port_other_sys = port_num;
     least_forwarded_to = 0;
    }
    found_sys_guid = 0;
   } else { /* same sys found - try node */


    /* Else is the node guid already used ? */
    p_remote_guid = switch_find_node_guid_count(p_sw,
             p_port->priv,
             port_num);

    /* If not update the least hops for this case */
    if (!p_remote_guid
        && check_count < least_paths_other_nodes) {
     least_paths_other_nodes = check_count;
     best_port_other_node = port_num;
     least_forwarded_to = 0;
    }
    /* else prior sys and node guid already used */

    if (!p_remote_guid)
     found_node_guid = 0;
    else
     found_node_guid = 1;
    found_sys_guid = 1;
   } /* same sys found */
  }

  port_paths[port_paths_count].port_num = port_num;
  port_paths[port_paths_count].path_count = check_count;
  if (routing_for_lmc) {
   port_paths[port_paths_count].found_sys_guid = found_sys_guid;
   port_paths[port_paths_count].found_node_guid = found_node_guid;
  }
  if (routing_for_lmc && p_remote_guid)
   port_paths[port_paths_count].forwarded_to = p_remote_guid->forwarded_to;
  else
   port_paths[port_paths_count].forwarded_to = 0;
  port_paths_total_paths += check_count;
  port_paths_count++;

  /* routing for LMC mode */
  /*
		   the count is min but also lower then the max subscribed
		 */
  if (check_count < least_paths) {
   port_found = (!0);
   best_port = port_num;
   least_paths = check_count;
   scatter_possible_ports_count = 0;
   scatter_possible_ports[scatter_possible_ports_count++] = port_num;
   if (routing_for_lmc
       && p_remote_guid
       && p_remote_guid->forwarded_to < least_forwarded_to)
    least_forwarded_to = p_remote_guid->forwarded_to;
  } else if (scatter_ports
      && check_count == least_paths) {
   scatter_possible_ports[scatter_possible_ports_count++] = port_num;
  } else if (routing_for_lmc
      && p_remote_guid
      && check_count == least_paths
      && p_remote_guid->forwarded_to < least_forwarded_to) {
   least_forwarded_to = p_remote_guid->forwarded_to;
   best_port = port_num;
  }
 }

 if (port_found == 0)
  return 0xFF;

 if (port_shifting && port_paths_count) {
  /* In the port_paths[] array, we now have all the ports that we
		 * can route out of.  Using some shifting math below, possibly
		 * select a different one so that lids won't align in LFTs
		 *
		 * If lmc > 0, we need to loop through these ports to find the
		 * least_forwarded_to port, best_port_other_sys, and
		 * best_port_other_node just like before but through the different
		 * ordering.
		 */

  least_paths = 0xFFFFFFFF;
  least_paths_other_sys = 0xFFFFFFFF;
  least_paths_other_nodes = 0xFFFFFFFF;
         least_forwarded_to = 0xFFFFFFFF;
  best_port = 0;
  best_port_other_sys = 0;
  best_port_other_node = 0;

  for (i = 0; i < port_paths_count; i++) {
   unsigned int idx;

   idx = (port_paths_total_paths/port_paths_count + i) % port_paths_count;

   if (routing_for_lmc) {
    if (!port_paths[idx].found_sys_guid
        && port_paths[idx].path_count < least_paths_other_sys) {
     least_paths_other_sys = port_paths[idx].path_count;
     best_port_other_sys = port_paths[idx].port_num;
     least_forwarded_to = 0;
    }
    else if (!port_paths[idx].found_node_guid
      && port_paths[idx].path_count < least_paths_other_nodes) {
     least_paths_other_nodes = port_paths[idx].path_count;
     best_port_other_node = port_paths[idx].port_num;
     least_forwarded_to = 0;
    }
   }

   if (port_paths[idx].path_count < least_paths) {
    best_port = port_paths[idx].port_num;
    least_paths = port_paths[idx].path_count;
    if (routing_for_lmc
        && (port_paths[idx].found_sys_guid
     || port_paths[idx].found_node_guid)
        && port_paths[idx].forwarded_to < least_forwarded_to)
     least_forwarded_to = port_paths[idx].forwarded_to;
   }
   else if (routing_for_lmc
     && (port_paths[idx].found_sys_guid
         || port_paths[idx].found_node_guid)
     && port_paths[idx].path_count == least_paths
     && port_paths[idx].forwarded_to < least_forwarded_to) {
    least_forwarded_to = port_paths[idx].forwarded_to;
    best_port = port_paths[idx].port_num;
   }

  }
 }

 /*
	   if we are in enhanced routing mode and the best port is not
	   the local port 0
	 */
 if (routing_for_lmc && best_port && !scatter_ports) {
  /* Select the least hop port of the non used sys first */
  if (best_port_other_sys)
   best_port = best_port_other_sys;
  else if (best_port_other_node)
   best_port = best_port_other_node;
 } else if (scatter_ports) {
  /*
		 * There is some danger that this random could "rebalance" the routes
		 * every time, to combat this there is a global srandom that
		 * occurs at the start of every sweep.
		 */
  unsigned int idx = random() % scatter_possible_ports_count;
  best_port = scatter_possible_ports[idx];
 }
 return best_port;
}

# 658 "osm_switch.c"
uint8_t osm_switch_get_port_least_hops(/* Function input parameter */ const osm_switch_t * p_sw,
           /* Function input parameter */ const osm_port_t * p_port)
{
 uint16_t lid;

 if (p_port->p_node->sw) {
  if (p_port->p_node->sw == p_sw)
   return 0;
  lid = osm_node_get_base_lid(p_port->p_node, 0);
  return osm_switch_get_least_hops(p_sw, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (lid); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
 } else {
  osm_physp_t *p = p_port->p_physp;
  uint8_t hops;

  if (!p || !p->p_remote_physp || !p->p_remote_physp->p_node->sw)
   return 0xFF;
  if (p->p_remote_physp->p_node->sw == p_sw)
   return 1;
  lid = osm_node_get_base_lid(p->p_remote_physp->p_node, 0);
  hops = osm_switch_get_least_hops(p_sw, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (lid); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
  return hops != 0xFF ? hops + 1 : 0xFF;
 }
}

# 682 "osm_switch.c"
uint8_t osm_switch_recommend_mcast_path(/* Function input parameter */ osm_switch_t * p_sw,
     /* Function input parameter */ osm_port_t * p_port,
     /* Function input parameter */ uint16_t mlid_ho,
     /* Function input parameter */ boolean_t ignore_existing)
{
 uint16_t base_lid;
 uint8_t hops;
 uint8_t port_num;
 uint8_t num_ports;
 uint8_t least_hops;

 ;

 if (p_port->p_node->sw) {
  if (p_port->p_node->sw == p_sw)
   return 0;
  base_lid = osm_port_get_base_lid(p_port);
 } else {
  osm_physp_t *p_physp = p_port->p_physp;
  if (!p_physp || !p_physp->p_remote_physp ||
      !p_physp->p_remote_physp->p_node->sw)
   return 0xFF;
  if (p_physp->p_remote_physp->p_node->sw == p_sw)
   return p_physp->p_remote_physp->port_num;
  base_lid =
      osm_node_get_base_lid(p_physp->p_remote_physp->p_node, 0);
 }
 base_lid = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (base_lid); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 num_ports = p_sw->num_ports;

 /*
	   If the user wants us to ignore existing multicast routes,
	   then simply return the shortest hop count path to the
	   target port.

	   Otherwise, return the first port that has a path to the target,
	   picking from the ports that are already in the multicast group.
	 */
 if (!ignore_existing) {
  for (port_num = 1; port_num < num_ports; port_num++) {
   if (!osm_mcast_tbl_is_port
       (&p_sw->mcast_tbl, mlid_ho, port_num))
    continue;
   /*
			   Don't be too trusting of the current forwarding table!
			   Verify that the LID is reachable through this port.
			 */
   hops =
       osm_switch_get_hop_count(p_sw, base_lid, port_num);
   if (hops != 0xFF)
    return port_num;
  }
 }

 /*
	   Either no existing mcast paths reach this port or we are
	   ignoring existing paths.

	   Determine the best multicast path to the target.  Note that this
	   algorithm is slightly different from the one used for unicast route
	   recommendation.  In this case (multicast), we must NOT
	   perform any sort of load balancing.  We MUST take the FIRST
	   port found that has <= the lowest hop count path.  This prevents
	   more than one multicast path to the same remote switch which
	   prevents a multicast loop.  Multicast loops are bad since the same
	   multicast packet will go around and around, inevitably creating
	   a black hole that will destroy the Earth in a firey conflagration.
	 */
 least_hops = osm_switch_get_least_hops(p_sw, base_lid);
 if (least_hops == 0xFF)
  return 0xFF;
 for (port_num = 1; port_num < num_ports; port_num++)
  if (osm_switch_get_hop_count(p_sw, base_lid, port_num) ==
      least_hops)
   break;

 ;
 return port_num;
}

