# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 36 "putword.h"
static inline void put16(void *where, uint16_t u) {

  __asm__ volatile("xchg %h[U],%b[U]\n\tmovw %[U],%[WHERE]"
                   : [U] "+Q" (u)
                   : [WHERE] "m" (*(uint16_t *)where));





}

# 52 "putword.h"
static inline void put32(void *where, uint32_t u) {

  __asm__ volatile("bswapl %[U]\n\tmovl %[U],%[WHERE]"
                   : [U] "+r" (u)
                   : [WHERE] "m" (*(uint32_t *)where));







}

# 85 "putword.h"
static inline uint16_t get16(const void *where) {

  uint16_t r;
  __asm__("movw %[WHERE],%[R]\t\nxchg %h[R],%b[R]"
          : [R] "=Q" (r)
          : [WHERE] "m" (*(const uint16_t *)where));
  return r;




}

# 102 "putword.h"
static inline uint32_t get32(const void *where) {

  uint32_t r;
  __asm__("movl %[WHERE],%[R]\n\tbswapl %[R]"
          : [R] "=r" (r)
          : [WHERE] "m" (*(const uint32_t *)where));
  return r;




}

