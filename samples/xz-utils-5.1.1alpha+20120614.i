# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 176 "../../../src/common/tuklib_integer.h"
static inline uint16_t
read16be(const uint8_t *buf)
{
 uint16_t num = *(const uint16_t *)buf;
 return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (num); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 77 "conftest.c"
int
main(void)
{
 (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (42); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 return 0;
}

