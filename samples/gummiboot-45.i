# 46 "/usr/include/efi/ia32/efibind.h"
typedef unsigned int uint64_t;

# 90 "/usr/include/efi/ia32/efibind.h"
typedef uint64_t UINT64;

# 37 "src/efi/util.c"
UINT64 ticks_read(void) {
        UINT64 val;
        __asm__ volatile ("rdtsc" : "=A" (val));
        return val;
}

