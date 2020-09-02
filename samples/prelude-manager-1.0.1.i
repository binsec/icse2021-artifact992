# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 117 "/usr/include/libprelude/prelude-extract.h"
static inline uint16_t prelude_extract_uint16(const void *buf)
{
        return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((*(const uint16_t *) (buf))); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

