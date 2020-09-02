# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 122 "NetworkUtils.cpp"
uint16_t NetworkToHost(uint16_t value) {
  return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (value); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 150 "NetworkUtils.cpp"
uint16_t HostToNetwork(uint16_t value) {
  return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (value); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

