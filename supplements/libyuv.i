# 21 "util/./psnr.h"
typedef unsigned char uint8_t;

# 23 "util/psnr.cc"
typedef unsigned int uint32_t;

# 149 "util/psnr.cc"
static uint32_t SumSquareError_NEON(const uint8_t* src_a,
                                    const uint8_t* src_b,
                                    int count) {
  volatile uint32_t sse;
  asm volatile(
      "vmov.u8    q7, #0                         \n"
      "vmov.u8    q9, #0                         \n"
      "vmov.u8    q8, #0                         \n"
      "vmov.u8    q10, #0                        \n"

      "1:                                        \n"
      "vld1.u8    %{q0%}, [%0]!                  \n"
      "vld1.u8    %{q1%}, [%1]!                  \n"
      "vsubl.u8   q2, d0, d2                     \n"
      "vsubl.u8   q3, d1, d3                     \n"
      "vmlal.s16  q7, d4, d4                     \n"
      "vmlal.s16  q8, d6, d6                     \n"
      "vmlal.s16  q8, d5, d5                     \n"
      "vmlal.s16  q10, d7, d7                    \n"
      "subs       %2, %2, #16                    \n"
      "bhi        1b                             \n"

      "vadd.u32   q7, q7, q8                     \n"
      "vadd.u32   q9, q9, q10                    \n"
      "vadd.u32   q10, q7, q9                    \n"
      "vpaddl.u32 q1, q10                        \n"
      "vadd.u64   d0, d2, d3                     \n"
      "vmov.32    %3, d0[0]                      \n"
      : "+r"(src_a), "+r"(src_b), "+r"(count), "=r"(sse)
      :
      : "memory", "cc", "q0", "q1", "q2", "q3", "q7", "q8", "q9", "q10");
  return sse;
}
