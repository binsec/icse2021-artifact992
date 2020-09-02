# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 36 "rhash_timing.c"
static uint64_t read_tsc(void) {
 unsigned long lo, hi;
 __asm volatile("rdtsc" : "=a" (lo), "=d" (hi));
 return (((uint64_t)hi) << 32) + lo;
}

