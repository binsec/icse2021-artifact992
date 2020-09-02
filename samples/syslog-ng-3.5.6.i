void * __builtin___memcpy_chk (void *, const void *, unsigned int, unsigned int);
unsigned int __builtin_object_size (const void *, int);

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 47 "/usr/include/i386-linux-gnu/bits/string3.h"
extern __inline void *
 memcpy (void *__restrict __dest, const void *__restrict __src, size_t __len)

{
  return __builtin___memcpy_chk (__dest, __src, __len, __builtin_object_size (__dest, 0));
}

# 153 "../../../../../modules/afamqp/rabbitmq-c/librabbitmq/amqp_private.h"
static inline void *amqp_offset(void *data, size_t offset)
{
  return (char *)data + offset;
}

# 249 "../../../../../modules/afamqp/rabbitmq-c/librabbitmq/amqp_private.h"
static inline void amqp_e16(void *data, size_t offset, uint16_t val) { /* The AMQP data might be unaligned. So we encode and then copy the            result into place. */ uint16_t res = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (val); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })); memcpy(amqp_offset(data, offset), &res, 16/8); }

