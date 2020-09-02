# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 200 "/usr/include/bluetooth/bluetooth.h"
static inline uint16_t bt_get_be16(const void *ptr)
{
 return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (({ struct { __typeof__(*((const uint16_t *) ptr)) __v; } *__p = (__typeof__(__p)) ((const uint16_t *) ptr); __p->__v; })); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 230 "/usr/include/bluetooth/bluetooth.h"
static inline void bt_put_be16(uint16_t val, const void *ptr)
{
 do { struct { __typeof__(*((uint16_t *) ptr)) __v; } *__p = (__typeof__(__p)) ((uint16_t *) ptr); __p->__v = ((__extension__ ({ unsigned short int __v, __x = (unsigned short int) (val); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))); } while(0);
}

