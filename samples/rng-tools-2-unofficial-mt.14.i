# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 456 "viapadlock_engine.c"
static inline uint32_t via_xstore(uint64_t *addr, uint32_t edx_in)
{
 uint32_t eax_out, edi_out;

 asm(".byte 0x0F,0xA7,0xC0 /* xstore %%edi (addr=%0) */"
     :"=m"(*addr), "=a"(eax_out), "=D"(edi_out)
     :"D"(addr), "d"(edx_in));
 return eax_out;
}

