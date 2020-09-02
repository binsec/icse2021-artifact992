# 197 "/usr/include/i386-linux-gnu/sys/types.h"
typedef int int64_t;

# 61 "./src/base/basictypes.h"
typedef int64_t int64;

# 81 "./src/base/cycleclock.h"
static inline int64 Now() {
# 94 "./src/base/cycleclock.h"
    int64 ret;
    __asm__ volatile ("rdtsc" : "=A" (ret) );
    return ret;
# 169 "./src/base/cycleclock.h"
  }

