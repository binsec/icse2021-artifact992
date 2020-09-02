# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 120 "msrtool.h"
struct cpuid_t {
 uint8_t family;
 uint8_t model;
 uint8_t stepping;
 uint8_t ext_family;
 uint8_t ext_model;
};

# 24 "sys.c"
static struct cpuid_t id;

# 26 "sys.c"
struct cpuid_t *cpuid(void) {
 uint32_t outeax;
 asm ("cpuid" : "=a" (outeax) : "a" (1) : "%ebx", "%ecx", "%edx");
 id.stepping = outeax & 0xf;
 outeax >>= 4;
 id.model = outeax & 0xf;
 outeax >>= 4;
 id.family = outeax & 0xf;
 outeax >>= 8;
 id.ext_model = outeax & 0xf;
 outeax >>= 4;
 id.ext_family = outeax & 0xff;
 if (0xf == id.family) {
  /* Intel says always do this, AMD says only for family f */
  id.model |= (id.ext_model << 4);
  id.family += id.ext_family;
 }
 return &id;
}

