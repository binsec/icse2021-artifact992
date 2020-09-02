unsigned int __builtin_bswap32 (unsigned int);

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

# 20 "/vagrant/allpkg/linux-tools-3.16.56/include/uapi/asm-generic/int-ll64.h"
typedef unsigned char __u8;

# 23 "/vagrant/allpkg/linux-tools-3.16.56/include/uapi/asm-generic/int-ll64.h"
typedef unsigned short __u16;

# 29 "/vagrant/allpkg/linux-tools-3.16.56/include/uapi/asm-generic/int-ll64.h"
typedef __signed__ long long __s64;

# 360 "/vagrant/allpkg/linux-tools-3.16.56/include/uapi/linux/perf_event.h"
struct perf_event_mmap_page {
 __u32 version; /* version number of this structure */
 __u32 compat_version; /* lowest version this is compat with */

 /*
	 * Bits needed to read the hw events in user-space.
	 *
	 *   u32 seq, time_mult, time_shift, idx, width;
	 *   u64 count, enabled, running;
	 *   u64 cyc, time_offset;
	 *   s64 pmc = 0;
	 *
	 *   do {
	 *     seq = pc->lock;
	 *     barrier()
	 *
	 *     enabled = pc->time_enabled;
	 *     running = pc->time_running;
	 *
	 *     if (pc->cap_usr_time && enabled != running) {
	 *       cyc = rdtsc();
	 *       time_offset = pc->time_offset;
	 *       time_mult   = pc->time_mult;
	 *       time_shift  = pc->time_shift;
	 *     }
	 *
	 *     idx = pc->index;
	 *     count = pc->offset;
	 *     if (pc->cap_usr_rdpmc && idx) {
	 *       width = pc->pmc_width;
	 *       pmc = rdpmc(idx - 1);
	 *     }
	 *
	 *     barrier();
	 *   } while (pc->lock != seq);
	 *
	 * NOTE: for obvious reason this only works on self-monitoring
	 *       processes.
	 */
 __u32 lock; /* seqlock for synchronization */
 __u32 index; /* hardware event identifier */
 __s64 offset; /* add to hardware event value */
 __u64 time_enabled; /* time event active */
 __u64 time_running; /* time event on cpu */
 union {
  __u64 capabilities;
  struct {
   __u64 cap_bit0 : 1, /* Always 0, deprecated, see commit 860f085b74e9 */
    cap_bit0_is_deprecated : 1, /* Always 1, signals that bit 0 is zero */

    cap_user_rdpmc : 1, /* The RDPMC instruction can be used to read counts */
    cap_user_time : 1, /* The time_* fields are used */
    cap_user_time_zero : 1, /* The time_zero field is used */
    cap_____res : 59;
  };
 };

 /*
	 * If cap_usr_rdpmc this field provides the bit-width of the value
	 * read using the rdpmc() or equivalent instruction. This can be used
	 * to sign extend the result like:
	 *
	 *   pmc <<= 64 - width;
	 *   pmc >>= 64 - width; // signed shift right
	 *   count += pmc;
	 */
 __u16 pmc_width;

 /*
	 * If cap_usr_time the below fields can be used to compute the time
	 * delta since time_enabled (in ns) using rdtsc or similar.
	 *
	 *   u64 quot, rem;
	 *   u64 delta;
	 *
	 *   quot = (cyc >> time_shift);
	 *   rem = cyc & ((1 << time_shift) - 1);
	 *   delta = time_offset + quot * time_mult +
	 *              ((rem * time_mult) >> time_shift);
	 *
	 * Where time_offset,time_mult,time_shift and cyc are read in the
	 * seqcount loop described above. This delta can then be added to
	 * enabled and possible running (if idx), improving the scaling:
	 *
	 *   enabled += delta;
	 *   if (idx)
	 *     running += delta;
	 *
	 *   quot = count / running;
	 *   rem  = count % running;
	 *   count = quot * enabled + (rem * enabled) / running;
	 */
 __u16 time_shift;
 __u32 time_mult;
 __u64 time_offset;
 /*
	 * If cap_usr_time_zero, the hardware clock (e.g. TSC) can be calculated
	 * from sample timestamps.
	 *
	 *   time = timestamp - time_zero;
	 *   quot = time / time_mult;
	 *   rem  = time % time_mult;
	 *   cyc = (quot << time_shift) + (rem << time_shift) / time_mult;
	 *
	 * And vice versa:
	 *
	 *   quot = cyc >> time_shift;
	 *   rem  = cyc & ((1 << time_shift) - 1);
	 *   timestamp = time_zero + quot * time_mult +
	 *               ((rem * time_mult) >> time_shift);
	 */
 __u64 time_zero;
 __u32 size; /* Header size up to __reserved[] fields. */

  /*
		 * Hole for extension of the self monitor capabilities
		 */

 __u8 __reserved[118*8+4]; /* align to 1k. */

 /*
	 * Control data for the mmap() data buffer.
	 *
	 * User-space reading the @data_head value should issue an smp_rmb(),
	 * after reading this value.
	 *
	 * When the mapping is PROT_WRITE the @data_tail value should be
	 * written by userspace to reflect the last read data, after issueing
	 * an smp_mb() to separate the data read from the ->data_tail store.
	 * In this case the kernel will not over-write unread data.
	 *
	 * See perf_output_put_handle() for the data ordering.
	 */
 __u64 data_head; /* head in the data section */
 __u64 data_tail; /* user-space written tail */
};

# 20 "util/evlist.h"
struct perf_mmap {
 void *base;
 int mask;
 unsigned int prev;
 char event_copy[(1 << 16)];
};

/*@ rustina_out_of_scope */
# 175 "util/evlist.h"
static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
{
 struct perf_event_mmap_page *pc = mm->base;
 int head = (*(volatile typeof(pc->data_head) *)&(pc->data_head));
 asm volatile("lock; addl $0,0(%%esp)" ::: "memory");
 return head;
}

/*@ rustina_out_of_scope */
# 183 "util/evlist.h"
static inline void perf_mmap__write_tail(struct perf_mmap *md,
      unsigned long tail)
{
 struct perf_event_mmap_page *pc = md->base;

 /*
	 * ensure all reads are done before we write the tail out.
	 */
 asm volatile("lock; addl $0,0(%%esp)" ::: "memory");
 pc->data_tail = tail;
}

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 28 "/vagrant/allpkg/linux-tools-3.16.56/tools/include/linux/types.h"
typedef uint64_t u64;

# 12 "tests/rdpmc.c"
static u64 rdpmc(unsigned int counter)
{
 unsigned int low, high;

 asm volatile("rdpmc" : "=a" (low), "=d" (high) : "c" (counter));

 return low | ((u64)high) << 32;
}

# 21 "tests/rdpmc.c"
static u64 rdtsc(void)
{
 unsigned int low, high;

 asm volatile("rdtsc" : "=a" (low), "=d" (high));

 return low | ((u64)high) << 32;
}

# 2 "./real-msb-32/types.h"
typedef __u32 kernel_ulong_t;

# 18 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct pci_device_id {
 __u32 vendor, device; /* Vendor and device ID or PCI_ANY_ID*/
 __u32 subvendor, subdevice; /* Subsystem ID's or PCI_ANY_ID */
 __u32 class, class_mask; /* (class,subclass,prog-if) triplet */
 kernel_ulong_t driver_data; /* Data private to the driver */
};

# 31 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct ieee1394_device_id {
 __u32 match_flags;
 __u32 vendor_id;
 __u32 model_id;
 __u32 specifier_id;
 __u32 version;
 kernel_ulong_t driver_data;
};

# 101 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct usb_device_id {
 /* which fields to match against? */
 __u16 match_flags;

 /* Used for product specific matches; range is inclusive */
 __u16 idVendor;
 __u16 idProduct;
 __u16 bcdDevice_lo;
 __u16 bcdDevice_hi;

 /* Used for device class matches */
 __u8 bDeviceClass;
 __u8 bDeviceSubClass;
 __u8 bDeviceProtocol;

 /* Used for interface class matches */
 __u8 bInterfaceClass;
 __u8 bInterfaceSubClass;
 __u8 bInterfaceProtocol;

 /* Used for vendor-specific interface matches */
 __u8 bInterfaceNumber;

 /* not matched against */
 kernel_ulong_t driver_info
  ;
};

# 146 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct hid_device_id {
 __u16 bus;
 __u16 group;
 __u32 vendor;
 __u32 product;
 kernel_ulong_t driver_data;
};

# 155 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct ccw_device_id {
 __u16 match_flags; /* which fields to match against */

 __u16 cu_type; /* control unit type     */
 __u16 dev_type; /* device type           */
 __u8 cu_model; /* control unit model    */
 __u8 dev_model; /* device model          */

 kernel_ulong_t driver_info;
};

# 172 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct ap_device_id {
 __u16 match_flags; /* which fields to match against */
 __u8 dev_type; /* device type */
 kernel_ulong_t driver_info;
};

# 181 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct css_device_id {
 __u8 match_flags;
 __u8 type; /* subchannel type */
 kernel_ulong_t driver_data;
};

# 189 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct acpi_device_id {
 __u8 id[9];
 kernel_ulong_t driver_data;
};

# 197 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct pnp_device_id {
 __u8 id[8];
 kernel_ulong_t driver_data;
};

# 202 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct pnp_card_device_id {
 __u8 id[8];
 kernel_ulong_t driver_data;
 struct {
  __u8 id[8];
 } devs[8];
};

# 213 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct serio_device_id {
 __u8 type;
 __u8 extra;
 __u8 id;
 __u8 proto;
};

# 223 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct of_device_id
{
 char name[32];
 char type[32];
 char compatible[128];
 const void *data;
};

# 232 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct vio_device_id {
 char type[32];
 char compat[32];
};

# 239 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct pcmcia_device_id {
 __u16 match_flags;

 __u16 manf_id;
 __u16 card_id;

 __u8 func_id;

 /* for real multi-function devices */
 __u8 function;

 /* for pseudo multi-function devices */
 __u8 device_no;

 __u32 prod_id_hash[4];

 /* not matched against in kernelspace*/
 const char * prod_id[4];

 /* not matched against */
 kernel_ulong_t driver_info;
 char * cisfile;
};

# 302 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct input_device_id {

 kernel_ulong_t flags;

 __u16 bustype;
 __u16 vendor;
 __u16 product;
 __u16 version;

 kernel_ulong_t evbit[0x1f / 32 + 1];
 kernel_ulong_t keybit[0x2ff / 32 + 1];
 kernel_ulong_t relbit[0x0f / 32 + 1];
 kernel_ulong_t absbit[0x3f / 32 + 1];
 kernel_ulong_t mscbit[0x07 / 32 + 1];
 kernel_ulong_t ledbit[0x0f / 32 + 1];
 kernel_ulong_t sndbit[0x07 / 32 + 1];
 kernel_ulong_t ffbit[0x7f / 32 + 1];
 kernel_ulong_t swbit[0x0f / 32 + 1];

 kernel_ulong_t driver_info;
};

# 329 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct eisa_device_id {
 char sig[8];
 kernel_ulong_t driver_data;
};

# 336 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct parisc_device_id {
 __u8 hw_type; /* 5 bits used */
 __u8 hversion_rev; /* 4 bits */
 __u16 hversion; /* 12 bits */
 __u32 sversion; /* 20 bits */
};

# 352 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct sdio_device_id {
 __u8 class; /* Standard interface or SDIO_ANY_ID */
 __u16 vendor; /* Vendor or SDIO_ANY_ID */
 __u16 device; /* Device ID or SDIO_ANY_ID */
 kernel_ulong_t driver_data; /* Data private to the driver */
};

# 360 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct ssb_device_id {
 __u16 vendor;
 __u16 coreid;
 __u8 revision;
 __u8 __pad;
};

# 376 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct bcma_device_id {
 __u16 manuf;
 __u16 id;
 __u8 rev;
 __u8 class;
};

# 392 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct virtio_device_id {
 __u32 device;
 __u32 vendor;
};

# 401 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct hv_vmbus_device_id {
 __u8 guid[16];
 kernel_ulong_t driver_data; /* Data private to the driver */
};

# 420 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct i2c_device_id {
 char name[20];
 kernel_ulong_t driver_data; /* Data private to the driver */
};

# 430 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct spi_device_id {
 char name[32];
 kernel_ulong_t driver_data; /* Data private to the driver */
};

# 467 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct dmi_strmatch {
 unsigned char slot:7;
 unsigned char exact_match:1;
 char substr[79];
};

# 473 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct dmi_system_id {
 int (*callback)(const struct dmi_system_id *);
 const char *ident;
 struct dmi_strmatch matches[4];
 void *driver_data;
};

# 493 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct platform_device_id {
 char name[20];
 kernel_ulong_t driver_data;
};

# 519 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct mdio_device_id {
 __u32 phy_id;
 __u32 phy_id_mask;
};

# 524 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct zorro_device_id {
 __u32 id; /* Device ID or ZORRO_WILDCARD */
 kernel_ulong_t driver_data; /* Data private to the driver */
};

# 534 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct isapnp_device_id {
 unsigned short card_vendor, card_device;
 unsigned short vendor, function;
 kernel_ulong_t driver_data; /* data private to the driver */
};

# 548 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct amba_id {
 unsigned int id;
 unsigned int mask;
 void *data;
};

# 564 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct x86_cpu_id {
 __u16 vendor;
 __u16 family;
 __u16 model;
 __u16 feature; /* bit index */
 kernel_ulong_t driver_data;
};

# 585 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct cpu_feature {
 __u16 feature;
};

# 591 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct ipack_device_id {
 __u8 format; /* Format version or IPACK_ANY_ID */
 __u32 vendor; /* Vendor ID or IPACK_ANY_ID */
 __u32 device; /* Device ID or IPACK_ANY_ID */
};

# 600 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct mei_cl_device_id {
 char name[32];
 kernel_ulong_t driver_info;
};

# 619 "/vagrant/allpkg/linux-tools-3.16.56/include/linux/mod_devicetable.h"
struct rio_device_id {
 __u16 did, vid;
 __u16 asm_did, asm_vid;
};

# 54 "/usr/include/i386-linux-gnu/sys/select.h"
typedef long int __fd_mask;

# 64 "/usr/include/i386-linux-gnu/sys/select.h"
typedef struct
  {
    /* XPG4.2 requires this member name.  Otherwise avoid the name
       from the global namespace.  */

    __fd_mask fds_bits[1024 / (8 * (int) sizeof (__fd_mask))];
#define __FDS_BITS(set) ((set)->fds_bits)




  } fd_set;

# 24 "/usr/include/i386-linux-gnu/bits/select2.h"
extern long int __fdelt_chk (long int __d);

# 25 "/usr/include/i386-linux-gnu/bits/select2.h"
extern long int __fdelt_warn (long int __d);

# 584 "/usr/include/stdlib.h"
extern int setenv (const char *__name, const char *__value, int __replace);

# 12 "util/pager.c"
static void pager_preexec(void)
{
 /*
	 * Work around bug in "less" by not starting it until we
	 * have real input
	 */
 fd_set in;

 do { int __d0, __d1; __asm__ __volatile__ ("cld; rep; " "stosl" : "=c" (__d0), "=D" (__d1) : "a" (0), "0" (sizeof (fd_set) / sizeof (__fd_mask)), "1" (&((&in)->fds_bits)[0]) : "memory"); } while (0);
 ((void) (((&in)->fds_bits)[__extension__ ({ long int __d = (0); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] |= ((__fd_mask) 1 << ((0) % (8 * (int) sizeof (__fd_mask))))));
 select(1, &in, ((void *)0), &in, ((void *)0));

 setenv("LESS", "FRSX", 0);
}

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 77 "/vagrant/allpkg/linux-tools-3.16.56/drivers/staging/usbip/userspace/src/usbip_network.c"
void usbip_net_pack_uint16_t(int pack, uint16_t *num)
{
 uint16_t i;

 if (pack)
  i = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (*num); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 else
  i = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (*num); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

 *num = i;
}

# 44 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}

# 522 "/vagrant/allpkg/linux-tools-3.16.56/include/uapi/linux/perf_event.h"
struct perf_event_header {
 __u32 type;
 __u16 misc;
 __u16 size;
};

# 1076 "util/session.c"
void perf_event_header__bswap(struct perf_event_header *hdr)
{
 hdr->type = __bswap_32 (hdr->type);
 hdr->misc = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (hdr->misc); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 hdr->size = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (hdr->size); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 31 "/vagrant/allpkg/linux-tools-3.16.56/tools/include/linux/types.h"
typedef __u32 u32;

# 34 "/vagrant/allpkg/linux-tools-3.16.56/tools/include/linux/types.h"
typedef __u16 u16;

# 97 "/vagrant/allpkg/linux-tools-3.16.56/tools/perf/util/include/linux/kernel.h"
int eprintf(int level,
     const char *fmt, ...);

# 6 "arch/x86/util/tsc.h"
struct perf_tsc_conversion {
 u16 time_shift;
 u32 time_mult;
 u64 time_zero;
};

/*@ rustina_out_of_scope */
# 32 "arch/x86/util/tsc.c"
int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
        struct perf_tsc_conversion *tc)
{
 _Bool cap_user_time_zero;
 u32 seq;
 int i = 0;

 while (1) {
  seq = pc->lock;
  asm volatile("lock; addl $0,0(%%esp)" ::: "memory");
  tc->time_mult = pc->time_mult;
  tc->time_shift = pc->time_shift;
  tc->time_zero = pc->time_zero;
  cap_user_time_zero = pc->cap_user_time_zero;
  asm volatile("lock; addl $0,0(%%esp)" ::: "memory");
  if (pc->lock == seq && !(seq & 1))
   break;
  if (++i > 10000) {
   eprintf(1, "failed to get perf_event_mmap_page lock\n");
   return -22 /* Invalid argument */;
  }
 }

 if (!cap_user_time_zero)
  return -95 /* Operation not supported on transport endpoint */;

 return 0;
}

# 9 "arch/x86/util/header.c"
static inline void
cpuid(unsigned int op, unsigned int *a, unsigned int *b, unsigned int *c,
      unsigned int *d)
{
 __asm__ __volatile__ (".byte 0x53\n\tcpuid\n\t"
         "movl %%ebx, %%esi\n\t.byte 0x5b"
   : "=a" (*a),
   "=S" (*b),
   "=c" (*c),
   "=d" (*d)
   : "a" (op));
}
