# 8 "bench/../x86info.h"
enum vendor {
 VENDOR_UNKNOWN = 0 ,
 VENDOR_AMD,
 VENDOR_CENTAUR,
 VENDOR_CYRIX,
 VENDOR_INTEL,
 VENDOR_NATSEMI,
 VENDOR_RISE,
 VENDOR_TRANSMETA,
 VENDOR_SIS,
};

# 20 "bench/../x86info.h"
enum connector {
 CONN_UNKNOWN = 0,
 CONN_SOCKET_3,
 CONN_SOCKET_4,
 CONN_SOCKET_5,
 CONN_SOCKET_7,
 CONN_SOCKET_370,
 CONN_SOCKET_370_FCPGA,
 CONN_SOCKET_5_7,
 CONN_SUPER_SOCKET_7,
 CONN_SLOT_A,
 CONN_SOCKET_A,
 CONN_SOCKET_A_SLOT_A,
 CONN_SOCKET_A_OR_SLOT_A,
 CONN_SOCKET_57B,
 CONN_MOBILE_7,
 CONN_SOCKET_8,
 CONN_SLOT_1,
 CONN_SLOT_2,
 CONN_SOCKET_423,
 CONN_MMC,
 CONN_MMC2,
 CONN_BGA474,
 CONN_BGA,
 CONN_SOCKET_754,
 CONN_SOCKET_478,
 CONN_SOCKET_603,
 CONN_MICROFCBGA,
 CONN_SOCKET_939,
 CONN_SOCKET_940,
 CONN_LGA775,
 CONN_SOCKET_F,
 CONN_SOCKET_AM2,
 CONN_SOCKET_S1G1,
 CONN_SOCKET_S1G2,
 CONN_SOCKET_S1G3,
 CONN_SOCKET_F_R2,
 CONN_SOCKET_AM3,
 CONN_SOCKET_G34,
 CONN_SOCKET_ASB2,
 CONN_SOCKET_C32,
 CONN_SOCKET_FP1,
 CONN_SOCKET_FS1,
 CONN_SOCKET_FM1,
 CONN_SOCKET_FT1,
};

# 68 "bench/../x86info.h"
struct cpudata {
 struct cpudata *next;
 unsigned int number;
 enum vendor vendor;
 unsigned int efamily;
 unsigned int family;
 unsigned int model;
 unsigned int emodel;
 unsigned int stepping;
 unsigned int type;
 unsigned int cachesize_L1_I, cachesize_L1_D;
 unsigned int cachesize_L2;
 unsigned int cachesize_L3;
 unsigned int cachesize_trace;
 unsigned int phyaddr_bits;
 unsigned int viraddr_bits;
 unsigned int cpuid_level, maxei, maxei2;
 char name[80];
 enum connector connector;
 unsigned int flags_ecx;
 unsigned int flags_edx;
 unsigned int eflags_ecx;
 unsigned int eflags_edx;
 unsigned int MHz;
 unsigned int nr_cores;
 unsigned int nr_logical;
 char *info_url;
 char *datasheet_url;
 char *errata_url;
 /* Intel specific bits */
 unsigned int brand;
 unsigned int apicid;
 char serialno[30];

 unsigned int phys_proc_id;
 unsigned int initial_apicid;
 unsigned int x86_max_cores;
 unsigned int cpu_core_id;
 unsigned int num_siblings;
};

# 1 "bench/bench.h"
static inline unsigned long long int rdtsc(void)
{
 unsigned int low, high;

 __asm__ __volatile__("rdtsc" : "=a" (low), "=d" (high));
 return ((unsigned long long int)high << 32) | low;
}

# 15 "bench/benchmarks.c"
void show_benchmarks(struct cpudata *cpu )
{
 int tmp = 0;


 { int i; unsigned long bstart, bend; bstart = rdtsc(); for (i=0; i<1000; i++) asm volatile("int $0x80" :"=a" (tmp) :"0" (64)); bend = rdtsc(); printf("int 0x80" ": %ld cycles\n", ((bend-bstart)/1000)); };

 { int i; unsigned long bstart, bend; bstart = rdtsc(); for (i=0; i<1000; i++) asm volatile("cpuid": : :"ax", "dx", "cx", "bx"); bend = rdtsc(); printf("cpuid" ": %ld cycles\n", ((bend-bstart)/1000)); };

 //TIME(asm volatile("addl $1,0(%esp)"), "addl");
 //TIME(asm volatile("lock ; addl $1,0(%esp)"), "locked add");

 { int i; unsigned long bstart, bend; bstart = rdtsc(); for (i=0; i<1000; i++) asm volatile("bswap %0" : "=r" (tmp) : "0" (tmp)); bend = rdtsc(); printf("bswap" ": %ld cycles\n", ((bend-bstart)/1000)); };
}

# 10 "havecpuid.c"
static int flag_is_changeable_p(unsigned long flag)
{
 unsigned long f1, f2;
 __asm__ volatile("pushf\n\t"
   "pushf\n\t"
   "pop %0\n\t"
   "mov %0,%1\n\t"
   "xor %2,%0\n\t"
   "push %0\n\t"
   "popf\n\t"
   "pushf\n\t"
   "pop %0\n\t"
   "popf\n\t"
   : "=&r" (f1), "=&r" (f2)
   : "ir" (flag));
 return ((f1^f2) & flag) != 0;
}

