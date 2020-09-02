# 73 "/usr/include/urcu/arch.h"
typedef unsigned long long cycles_t;

# 75 "/usr/include/urcu/arch.h"
static inline cycles_t caa_get_cycles(void)
{
        cycles_t ret = 0;

        do { unsigned int __a, __d; __asm__ __volatile__ ("rdtsc" : "=a" (__a), "=d" (__d)); (ret) = ((unsigned long long)__a) | (((unsigned long long)__d) << 32); } while(0);
        return ret;
}

# 37 "/usr/include/urcu/uatomic.h"
struct __uatomic_dummy {
 unsigned long v[10];
};

# 46 "/usr/include/urcu/uatomic.h"
static inline
unsigned long __uatomic_cmpxchg(void *addr, unsigned long old,
         unsigned long _new, int len)
{
 switch (len) {
 case 1:
 {
  unsigned char result = old;

  __asm__ __volatile__(
  "lock; cmpxchgb %2, %1"
   : "+a"(result), "+m"(*((struct __uatomic_dummy *)(addr)))
   : "q"((unsigned char)_new)
   : "memory");
  return result;
 }
 case 2:
 {
  unsigned short result = old;

  __asm__ __volatile__(
  "lock; cmpxchgw %2, %1"
   : "+a"(result), "+m"(*((struct __uatomic_dummy *)(addr)))
   : "r"((unsigned short)_new)
   : "memory");
  return result;
 }
 case 4:
 {
  unsigned int result = old;

  __asm__ __volatile__(
  "lock; cmpxchgl %2, %1"
   : "+a"(result), "+m"(*((struct __uatomic_dummy *)(addr)))
   : "r"((unsigned int)_new)
   : "memory");
  return result;
 }
# 97 "/usr/include/urcu/uatomic.h" 3 4
 }
 /*
	 * generate an illegal instruction. Cannot catch this with
	 * linker tricks when optimizations are disabled.
	 */
 __asm__ __volatile__("ud2");
 return 0;
}

# 114 "/usr/include/urcu/uatomic.h"
static inline
unsigned long __uatomic_exchange(void *addr, unsigned long val, int len)
{
 /* Note: the "xchg" instruction does not need a "lock" prefix. */
 switch (len) {
 case 1:
 {
  unsigned char result;
  __asm__ __volatile__(
  "xchgb %0, %1"
   : "=q"(result), "+m"(*((struct __uatomic_dummy *)(addr)))
   : "0" ((unsigned char)val)
   : "memory");
  return result;
 }
 case 2:
 {
  unsigned short result;
  __asm__ __volatile__(
  "xchgw %0, %1"
   : "=r"(result), "+m"(*((struct __uatomic_dummy *)(addr)))
   : "0" ((unsigned short)val)
   : "memory");
  return result;
 }
 case 4:
 {
  unsigned int result;
  __asm__ __volatile__(
  "xchgl %0, %1"
   : "=r"(result), "+m"(*((struct __uatomic_dummy *)(addr)))
   : "0" ((unsigned int)val)
   : "memory");
  return result;
 }
# 161 "/usr/include/urcu/uatomic.h" 3 4
 }
 /*
	 * generate an illegal instruction. Cannot catch this with
	 * linker tricks when optimizations are disabled.
	 */
 __asm__ __volatile__("ud2");
 return 0;
}

# 177 "/usr/include/urcu/uatomic.h"
static inline
unsigned long __uatomic_add_return(void *addr, unsigned long val,
     int len)
{
 switch (len) {
 case 1:
 {
  unsigned char result = val;

  __asm__ __volatile__(
  "lock; xaddb %1, %0"
   : "+m"(*((struct __uatomic_dummy *)(addr))), "+q" (result)
   :
   : "memory");
  return result + (unsigned char)val;
 }
 case 2:
 {
  unsigned short result = val;

  __asm__ __volatile__(
  "lock; xaddw %1, %0"
   : "+m"(*((struct __uatomic_dummy *)(addr))), "+r" (result)
   :
   : "memory");
  return result + (unsigned short)val;
 }
 case 4:
 {
  unsigned int result = val;

  __asm__ __volatile__(
  "lock; xaddl %1, %0"
   : "+m"(*((struct __uatomic_dummy *)(addr))), "+r" (result)
   :
   : "memory");
  return result + (unsigned int)val;
 }
# 228 "/usr/include/urcu/uatomic.h" 3 4
 }
 /*
	 * generate an illegal instruction. Cannot catch this with
	 * linker tricks when optimizations are disabled.
	 */
 __asm__ __volatile__("ud2");
 return 0;
}

# 244 "/usr/include/urcu/uatomic.h"
static inline
void __uatomic_and(void *addr, unsigned long val, int len)
{
 switch (len) {
 case 1:
 {
  __asm__ __volatile__(
  "lock; andb %1, %0"
   : "=m"(*((struct __uatomic_dummy *)(addr)))
   : "iq" ((unsigned char)val)
   : "memory");
  return;
 }
 case 2:
 {
  __asm__ __volatile__(
  "lock; andw %1, %0"
   : "=m"(*((struct __uatomic_dummy *)(addr)))
   : "ir" ((unsigned short)val)
   : "memory");
  return;
 }
 case 4:
 {
  __asm__ __volatile__(
  "lock; andl %1, %0"
   : "=m"(*((struct __uatomic_dummy *)(addr)))
   : "ir" ((unsigned int)val)
   : "memory");
  return;
 }
# 286 "/usr/include/urcu/uatomic.h" 3 4
 }
 /*
	 * generate an illegal instruction. Cannot catch this with
	 * linker tricks when optimizations are disabled.
	 */
 __asm__ __volatile__("ud2");
 return;
}

# 300 "/usr/include/urcu/uatomic.h"
static inline
void __uatomic_or(void *addr, unsigned long val, int len)
{
 switch (len) {
 case 1:
 {
  __asm__ __volatile__(
  "lock; orb %1, %0"
   : "=m"(*((struct __uatomic_dummy *)(addr)))
   : "iq" ((unsigned char)val)
   : "memory");
  return;
 }
 case 2:
 {
  __asm__ __volatile__(
  "lock; orw %1, %0"
   : "=m"(*((struct __uatomic_dummy *)(addr)))
   : "ir" ((unsigned short)val)
   : "memory");
  return;
 }
 case 4:
 {
  __asm__ __volatile__(
  "lock; orl %1, %0"
   : "=m"(*((struct __uatomic_dummy *)(addr)))
   : "ir" ((unsigned int)val)
   : "memory");
  return;
 }
# 342 "/usr/include/urcu/uatomic.h" 3 4
 }
 /*
	 * generate an illegal instruction. Cannot catch this with
	 * linker tricks when optimizations are disabled.
	 */
 __asm__ __volatile__("ud2");
 return;
}

# 356 "/usr/include/urcu/uatomic.h"
static inline
void __uatomic_add(void *addr, unsigned long val, int len)
{
 switch (len) {
 case 1:
 {
  __asm__ __volatile__(
  "lock; addb %1, %0"
   : "=m"(*((struct __uatomic_dummy *)(addr)))
   : "iq" ((unsigned char)val)
   : "memory");
  return;
 }
 case 2:
 {
  __asm__ __volatile__(
  "lock; addw %1, %0"
   : "=m"(*((struct __uatomic_dummy *)(addr)))
   : "ir" ((unsigned short)val)
   : "memory");
  return;
 }
 case 4:
 {
  __asm__ __volatile__(
  "lock; addl %1, %0"
   : "=m"(*((struct __uatomic_dummy *)(addr)))
   : "ir" ((unsigned int)val)
   : "memory");
  return;
 }
# 398 "/usr/include/urcu/uatomic.h" 3 4
 }
 /*
	 * generate an illegal instruction. Cannot catch this with
	 * linker tricks when optimizations are disabled.
	 */
 __asm__ __volatile__("ud2");
 return;
}

# 413 "/usr/include/urcu/uatomic.h"
static inline
void __uatomic_inc(void *addr, int len)
{
 switch (len) {
 case 1:
 {
  __asm__ __volatile__(
  "lock; incb %0"
   : "=m"(*((struct __uatomic_dummy *)(addr)))
   :
   : "memory");
  return;
 }
 case 2:
 {
  __asm__ __volatile__(
  "lock; incw %0"
   : "=m"(*((struct __uatomic_dummy *)(addr)))
   :
   : "memory");
  return;
 }
 case 4:
 {
  __asm__ __volatile__(
  "lock; incl %0"
   : "=m"(*((struct __uatomic_dummy *)(addr)))
   :
   : "memory");
  return;
 }
# 455 "/usr/include/urcu/uatomic.h" 3 4
 }
 /* generate an illegal instruction. Cannot catch this with linker tricks
	 * when optimizations are disabled. */
 __asm__ __volatile__("ud2");
 return;
}

# 466 "/usr/include/urcu/uatomic.h"
static inline
void __uatomic_dec(void *addr, int len)
{
 switch (len) {
 case 1:
 {
  __asm__ __volatile__(
  "lock; decb %0"
   : "=m"(*((struct __uatomic_dummy *)(addr)))
   :
   : "memory");
  return;
 }
 case 2:
 {
  __asm__ __volatile__(
  "lock; decw %0"
   : "=m"(*((struct __uatomic_dummy *)(addr)))
   :
   : "memory");
  return;
 }
 case 4:
 {
  __asm__ __volatile__(
  "lock; decl %0"
   : "=m"(*((struct __uatomic_dummy *)(addr)))
   :
   : "memory");
  return;
 }
# 508 "/usr/include/urcu/uatomic.h" 3 4
 }
 /*
	 * generate an illegal instruction. Cannot catch this with
	 * linker tricks when optimizations are disabled.
	 */
 __asm__ __volatile__("ud2");
 return;
}

