# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 353 "../../libtv/yuv2yuv.c"
void _tv_shuffle_3210_MMX (uint8_t * dst, const uint8_t * src, unsigned int width, unsigned int height, unsigned long dst_padding, unsigned long src_padding) { while (height-- > 0) { const uint8_t *end; for (end = src + width; src < end;) { uint32_t *d = (uint32_t *) dst; const uint32_t *s = (const uint32_t *) src; uint32_t t; __asm__ ("bswap %0" : "=r" (t) : "0" (s[0])); d[0] = t; __asm__ ("bswap %0" : "=r" (t) : "0" (s[1])); d[1] = t; __asm__ ("bswap %0" : "=r" (t) : "0" (s[2])); d[2] = t; __asm__ ("bswap %0" : "=r" (t) : "0" (s[3])); d[3] = t; src += 16; dst += 16; } src += src_padding; dst += dst_padding; } }

