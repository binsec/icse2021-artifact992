# 38 "/usr/lib/i386-linux-gnu/glib-2.0/include/glibconfig.h"
typedef unsigned char guint8;

# 40 "/usr/lib/i386-linux-gnu/glib-2.0/include/glibconfig.h"
typedef unsigned short guint16;

# 44 "/usr/lib/i386-linux-gnu/glib-2.0/include/glibconfig.h"
typedef signed int gint32;

# 45 "/usr/lib/i386-linux-gnu/glib-2.0/include/glibconfig.h"
typedef unsigned int guint32;

# 49 "/usr/include/glib-2.0/glib/gtypes.h"
typedef int gint;

# 50 "/usr/include/glib-2.0/glib/gtypes.h"
typedef gint gboolean;

# 55 "/usr/include/glib-2.0/glib/gtypes.h"
typedef unsigned int guint;

# 25 "edsio.h"
typedef struct _SerialSource SerialSource;

# 26 "edsio.h"
typedef struct _SerialSink SerialSink;

# 27 "edsio.h"
typedef gint32 SerialType;

# 70 "edsio.h"
struct _SerialSource {
  /* Internal variables: don't touch. */
  guint32 alloc_total;
  guint32 alloc_pos;
  void *alloc_buf;
  void *alloc_buf_orig;

  /* These are setup by init.
   */
  SerialType (* source_type) (SerialSource* source, gboolean set_allocation);
  gboolean (* source_close) (SerialSource* source);
  gboolean (* source_read) (SerialSource* source, guint8 *ptr, guint32 len);
  void (* source_free) (SerialSource* source);

  /* These may be NULL
   */
  void* (* salloc_func) (SerialSource* source,
        guint32 len);
  void (* sfree_func) (SerialSource* source,
        void* ptr);

  /* Public functions, defaulted, but may be over-ridden
   * before calls to unserialize.
   */
  gboolean (* next_bytes_known) (SerialSource* source, guint8 *ptr, guint32 len);
  gboolean (* next_bytes) (SerialSource* source, const guint8 **ptr, guint32 *len);
  gboolean (* next_uint) (SerialSource* source, guint32 *ptr);
  gboolean (* next_uint32) (SerialSource* source, guint32 *ptr);
  gboolean (* next_uint16) (SerialSource* source, guint16 *ptr);
  gboolean (* next_uint8) (SerialSource* source, guint8 *ptr);
  gboolean (* next_bool) (SerialSource* source, gboolean *ptr);
  gboolean (* next_string) (SerialSource* source, const char **ptr);
};

# 104 "edsio.h"
struct _SerialSink {

  /* These are setup by init.
   */
  gboolean (* sink_type) (SerialSink* sink, SerialType type, guint mem_size, gboolean set_allocation);
  gboolean (* sink_close) (SerialSink* sink);
  gboolean (* sink_write) (SerialSink* sink, const guint8 *ptr, guint32 len);
  void (* sink_free) (SerialSink* sink);

  /* This may be null, called after each object is serialized. */
  gboolean (* sink_quantum) (SerialSink* sink);

  /* Public functions, defaulted, but may be over-ridden
   * before calls to serialize.
   */
  gboolean (* next_bytes_known) (SerialSink* sink, const guint8 *ptr, guint32 len);
  gboolean (* next_bytes) (SerialSink* sink, const guint8 *ptr, guint32 len);
  gboolean (* next_uint) (SerialSink* sink, guint32 ptr);
  gboolean (* next_uint32) (SerialSink* sink, guint32 ptr);
  gboolean (* next_uint16) (SerialSink* sink, guint16 ptr);
  gboolean (* next_uint8) (SerialSink* sink, guint8 ptr);
  gboolean (* next_bool) (SerialSink* sink, gboolean ptr);
  gboolean (* next_string) (SerialSink* sink, const char *ptr);
};

# 27 "default.c"
static gboolean
sink_next_uint16 (SerialSink* sink, guint16 num)
{
  num = ((((__extension__ ({ guint16 __v, __x = ((guint16) (num)); if (__builtin_constant_p (__x)) __v = ((guint16) ( (guint16) ((guint16) (__x) >> 8) | (guint16) ((guint16) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })))));

  return sink->sink_write (sink, (guint8*) &num, sizeof (num));
}

# 169 "default.c"
static gboolean
source_next_uint16 (SerialSource* source, guint16 *ptr)
{
  guint16 x;

  if (! source->source_read (source, (guint8*) &x, sizeof (x)))
    return (0);

  (*ptr) = (((((__extension__ ({ guint16 __v, __x = ((guint16) (x)); if (__builtin_constant_p (__x)) __v = ((guint16) ( (guint16) ((guint16) (__x) >> 8) | (guint16) ((guint16) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))))));

  return (!(0));
}

