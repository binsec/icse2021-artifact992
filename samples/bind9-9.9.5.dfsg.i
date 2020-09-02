# 29 "../../lib/isc/unix/include/isc/int.h"
typedef int isc_int32_t;

# 30 "../../lib/isc/x86_32/include/isc/atomic.h"
static __inline__ isc_int32_t
isc_atomic_xadd(isc_int32_t *p, isc_int32_t val) {
 isc_int32_t prev = val;

 __asm__ volatile(



  "xadd %0, %1"
  :"=q"(prev)
  :"m"(*p), "0"(prev)
  :"memory", "cc");

 return (prev);
}

# 67 "../../lib/isc/x86_32/include/isc/atomic.h"
static __inline__ void
isc_atomic_store(isc_int32_t *p, isc_int32_t val) {
 __asm__ volatile(
# 78 "../../lib/isc/x86_32/include/isc/atomic.h"
  "xchgl %1, %0"
  :
  : "r"(val), "m"(*p)
  : "memory");
}

# 89 "../../lib/isc/x86_32/include/isc/atomic.h"
static __inline__ isc_int32_t
isc_atomic_cmpxchg(isc_int32_t *p, isc_int32_t cmpval, isc_int32_t val) {
 __asm__ volatile(



  "cmpxchgl %1, %2"
  : "=a"(cmpval)
  : "r"(val), "m"(*p), "a"(cmpval)
  : "memory");

 return (cmpval);
}

