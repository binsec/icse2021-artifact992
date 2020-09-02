# 21 "util/./psnr.h"
typedef unsigned char uint8_t;

# 23 "util/psnr.cc"
typedef unsigned int uint32_t;

# 149 "util/psnr.cc"
static uint32_t SumSquareError_SSE2(const uint8_t* src_a,
                                    const uint8_t* src_b,
                                    int count) {
  uint32_t sse;
  asm volatile(
      "pxor      %%xmm0,%%xmm0                   \n"
      "pxor      %%xmm5,%%xmm5                   \n"
      "sub       %0,%1                           \n"

      "1:                                        \n"
      "movdqu    (%0),%%xmm1                     \n"
      "movdqu    (%0,%1,1),%%xmm2                \n"
      "lea       0x10(%0),%0                     \n"
      "movdqu    %%xmm1,%%xmm3                   \n"
      "psubusb   %%xmm2,%%xmm1                   \n"
      "psubusb   %%xmm3,%%xmm2                   \n"
      "por       %%xmm2,%%xmm1                   \n"
      "movdqu    %%xmm1,%%xmm2                   \n"
      "punpcklbw %%xmm5,%%xmm1                   \n"
      "punpckhbw %%xmm5,%%xmm2                   \n"
      "pmaddwd   %%xmm1,%%xmm1                   \n"
      "pmaddwd   %%xmm2,%%xmm2                   \n"
      "paddd     %%xmm1,%%xmm0                   \n"
      "paddd     %%xmm2,%%xmm0                   \n"
      "sub       $0x10,%2                        \n"
      "ja        1b                              \n"

      "pshufd    $0xee,%%xmm0,%%xmm1             \n"
      "paddd     %%xmm1,%%xmm0                   \n"
      "pshufd    $0x1,%%xmm0,%%xmm1              \n"
      "paddd     %%xmm1,%%xmm0                   \n"
      "movd      %%xmm0,%3                       \n"

      : "+r"(src_a),
        "+r"(src_b),
        "+r"(count),
        "=g"(sse)
      :
      : "memory", "cc"




      );
  return sse;
}

# 210 "util/psnr.cc"
static __inline void __cpuid(int cpu_info[4], int info_type) {
  asm volatile(
      "cpuid                                     \n"
      : "=a"(cpu_info[0]), "=b"(cpu_info[1]), "=c"(cpu_info[2]),
        "=d"(cpu_info[3])
      : "a"(info_type));
}

# 49 "source/cpu_id.cc"
void CpuId(int info_eax, int info_ecx, int* cpu_info) {
# 74 "source/cpu_id.cc"
  int info_ebx, info_edx;
  asm volatile(







      "cpuid                                     \n"
      : "=b"(info_ebx),

        "+a"(info_eax), "+c"(info_ecx), "=d"(info_edx));
  cpu_info[0] = info_eax;
  cpu_info[1] = info_ebx;
  cpu_info[2] = info_ecx;
  cpu_info[3] = info_edx;

}

# 118 "source/cpu_id.cc"
int GetXCR0() {
  int xcr0 = 0;



  asm(".byte 0x0f, 0x01, 0xd0" : "=a"(xcr0) : "c"(0) : "%edx");

  return xcr0;
}

