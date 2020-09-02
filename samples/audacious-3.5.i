# 40 "/usr/lib/i386-linux-gnu/glib-2.0/include/glibconfig.h"
typedef unsigned short guint16;

# 195 "/usr/include/i386-linux-gnu/sys/types.h"
typedef int int16_t;

# 111 "audio.c"
static inline int16_t SWAP16 (int16_t i) {return ((__extension__ ({ guint16 __v, __x = ((guint16) (i)); if (__builtin_constant_p (__x)) __v = ((guint16) ( (guint16) ((guint16) (__x) >> 8) | (guint16) ((guint16) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));}

