# 38 "/usr/lib/i386-linux-gnu/glib-2.0/include/glibconfig.h"
typedef unsigned char guint8;

# 40 "/usr/lib/i386-linux-gnu/glib-2.0/include/glibconfig.h"
typedef unsigned short guint16;

# 127 "/usr/include/gstreamer-1.0/gst/gstutils.h"
static inline guint16 __gst_fast_read_swap16(const guint8 *v) {
  return ((__extension__ ({ guint16 __v, __x = ((guint16) (*(const guint16*)(v))); if (__builtin_constant_p (__x)) __v = ((guint16) ( (guint16) ((guint16) (__x) >> 8) | (guint16) ((guint16) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
}

