# 38 "/usr/lib/i386-linux-gnu/glib-2.0/include/glibconfig.h"
typedef unsigned char guint8;

# 40 "/usr/lib/i386-linux-gnu/glib-2.0/include/glibconfig.h"
typedef unsigned short guint16;

# 45 "/usr/lib/i386-linux-gnu/glib-2.0/include/glibconfig.h"
typedef unsigned int guint32;

# 51 "/usr/lib/i386-linux-gnu/glib-2.0/include/glibconfig.h"
typedef signed long long gint64;

# 66 "/usr/lib/i386-linux-gnu/glib-2.0/include/glibconfig.h"
typedef unsigned int gsize;

# 46 "/usr/include/glib-2.0/glib/gtypes.h"
typedef char gchar;

# 49 "/usr/include/glib-2.0/glib/gtypes.h"
typedef int gint;

# 50 "/usr/include/glib-2.0/glib/gtypes.h"
typedef gint gboolean;

# 55 "/usr/include/glib-2.0/glib/gtypes.h"
typedef unsigned int guint;

# 77 "/usr/include/glib-2.0/glib/gtypes.h"
typedef void* gpointer;

# 36 "/usr/include/glib-2.0/glib/gquark.h"
typedef guint32 GQuark;

# 42 "/usr/include/glib-2.0/glib/gerror.h"
typedef struct _GError GError;

# 44 "/usr/include/glib-2.0/glib/gerror.h"
struct _GError
{
  GQuark domain;
  gint code;
  gchar *message;
};

# 77 "/usr/include/glib-2.0/glib/gconvert.h"
typedef struct _GIConv *GIConv;

# 37 "/usr/include/glib-2.0/glib/gslist.h"
typedef struct _GSList GSList;

# 39 "/usr/include/glib-2.0/glib/gslist.h"
struct _GSList
{
  gpointer data;
  GSList *next;
};

# 31 "/usr/include/glib-2.0/glib/gmain.h"
typedef enum /*< flags >*/
{
  G_IO_IN =1,
  G_IO_OUT =4,
  G_IO_PRI =2,
  G_IO_ERR =8,
  G_IO_HUP =16,
  G_IO_NVAL =32
} GIOCondition;

# 48 "/usr/include/glib-2.0/glib/gmain.h"
typedef struct _GMainContext GMainContext;

# 64 "/usr/include/glib-2.0/glib/gmain.h"
typedef struct _GSource GSource;

# 65 "/usr/include/glib-2.0/glib/gmain.h"
typedef struct _GSourcePrivate GSourcePrivate;

# 77 "/usr/include/glib-2.0/glib/gmain.h"
typedef struct _GSourceCallbackFuncs GSourceCallbackFuncs;

# 128 "/usr/include/glib-2.0/glib/gmain.h"
typedef struct _GSourceFuncs GSourceFuncs;

# 153 "/usr/include/glib-2.0/glib/gmain.h"
typedef gboolean (*GSourceFunc) (gpointer user_data);

# 169 "/usr/include/glib-2.0/glib/gmain.h"
struct _GSource
{
  /*< private >*/
  gpointer callback_data;
  GSourceCallbackFuncs *callback_funcs;

  const GSourceFuncs *source_funcs;
  guint ref_count;

  GMainContext *context;

  gint priority;
  guint flags;
  guint source_id;

  GSList *poll_fds;

  GSource *prev;
  GSource *next;

  char *name;

  GSourcePrivate *priv;
};

# 194 "/usr/include/glib-2.0/glib/gmain.h"
struct _GSourceCallbackFuncs
{
  void (*ref) (gpointer cb_data);
  void (*unref) (gpointer cb_data);
  void (*get) (gpointer cb_data,
                 GSource *source,
                 GSourceFunc *func,
                 gpointer *data);
};

# 210 "/usr/include/glib-2.0/glib/gmain.h"
typedef void (*GSourceDummyMarshal) (void);

# 212 "/usr/include/glib-2.0/glib/gmain.h"
struct _GSourceFuncs
{
  gboolean (*prepare) (GSource *source,
                        gint *timeout_);
  gboolean (*check) (GSource *source);
  gboolean (*dispatch) (GSource *source,
                        GSourceFunc callback,
                        gpointer user_data);
  void (*finalize) (GSource *source); /* Can be NULL */

  /*< private >*/
  /* For use by g_source_set_closure */
  GSourceFunc closure_callback;
  GSourceDummyMarshal closure_marshal; /* Really is of type GClosureMarshal */
};

# 39 "/usr/include/glib-2.0/glib/gstring.h"
typedef struct _GString GString;

# 41 "/usr/include/glib-2.0/glib/gstring.h"
struct _GString
{
  gchar *str;
  gsize len;
  gsize allocated_len;
};

# 41 "/usr/include/glib-2.0/glib/giochannel.h"
typedef struct _GIOChannel GIOChannel;

# 42 "/usr/include/glib-2.0/glib/giochannel.h"
typedef struct _GIOFuncs GIOFuncs;

# 69 "/usr/include/glib-2.0/glib/giochannel.h"
typedef enum
{
  G_IO_STATUS_ERROR,
  G_IO_STATUS_NORMAL,
  G_IO_STATUS_EOF,
  G_IO_STATUS_AGAIN
} GIOStatus;

# 77 "/usr/include/glib-2.0/glib/giochannel.h"
typedef enum
{
  G_SEEK_CUR,
  G_SEEK_SET,
  G_SEEK_END
} GSeekType;

# 84 "/usr/include/glib-2.0/glib/giochannel.h"
typedef enum
{
  G_IO_FLAG_APPEND = 1 << 0,
  G_IO_FLAG_NONBLOCK = 1 << 1,
  G_IO_FLAG_IS_READABLE = 1 << 2, /* Read only flag */
  G_IO_FLAG_IS_WRITABLE = 1 << 3, /* Read only flag */
  G_IO_FLAG_IS_WRITEABLE = 1 << 3, /* Misspelling in 2.29.10 and earlier */
  G_IO_FLAG_IS_SEEKABLE = 1 << 4, /* Read only flag */
  G_IO_FLAG_MASK = (1 << 5) - 1,
  G_IO_FLAG_GET_MASK = G_IO_FLAG_MASK,
  G_IO_FLAG_SET_MASK = G_IO_FLAG_APPEND | G_IO_FLAG_NONBLOCK
} GIOFlags;

# 97 "/usr/include/glib-2.0/glib/giochannel.h"
struct _GIOChannel
{
  /*< private >*/
  gint ref_count;
  GIOFuncs *funcs;

  gchar *encoding;
  GIConv read_cd;
  GIConv write_cd;
  gchar *line_term; /* String which indicates the end of a line of text */
  guint line_term_len; /* So we can have null in the line term */

  gsize buf_size;
  GString *read_buf; /* Raw data from the channel */
  GString *encoded_read_buf; /* Channel data converted to UTF-8 */
  GString *write_buf; /* Data ready to be written to the file */
  gchar partial_write_buf[6]; /* UTF-8 partial characters, null terminated */

  /* Group the flags together, immediately after partial_write_buf, to save memory */

  guint use_buffer : 1; /* The encoding uses the buffers */
  guint do_encode : 1; /* The encoding uses the GIConv coverters */
  guint close_on_unref : 1; /* Close the channel on final unref */
  guint is_readable : 1; /* Cached GIOFlag */
  guint is_writeable : 1; /* ditto */
  guint is_seekable : 1; /* ditto */

  gpointer reserved1;
  gpointer reserved2;
};

# 131 "/usr/include/glib-2.0/glib/giochannel.h"
struct _GIOFuncs
{
  GIOStatus (*io_read) (GIOChannel *channel,
             gchar *buf,
      gsize count,
      gsize *bytes_read,
      GError **err);
  GIOStatus (*io_write) (GIOChannel *channel,
      const gchar *buf,
      gsize count,
      gsize *bytes_written,
      GError **err);
  GIOStatus (*io_seek) (GIOChannel *channel,
      gint64 offset,
      GSeekType type,
      GError **err);
  GIOStatus (*io_close) (GIOChannel *channel,
      GError **err);
  GSource* (*io_create_watch) (GIOChannel *channel,
      GIOCondition condition);
  void (*io_free) (GIOChannel *channel);
  GIOStatus (*io_set_flags) (GIOChannel *channel,
                                  GIOFlags flags,
      GError **err);
  GIOFlags (*io_get_flags) (GIOChannel *channel);
};

# 123 "/usr/include/glib-2.0/glib/gmessages.h"
extern
void g_return_if_fail_warning (const char *log_domain,
          const char *pretty_function,
          const char *expression);

# 94 "/vagrant/allpkg/gimp-2.8.14/./libgimpbase/gimpwire.h"
gboolean _gimp_wire_read_int8 (GIOChannel *channel,
                                                   guint8 *data,
                                                   gint count,
                                                   gpointer user_data);

# 118 "/vagrant/allpkg/gimp-2.8.14/./libgimpbase/gimpwire.h"
gboolean _gimp_wire_write_int8 (GIOChannel *channel,
                                                   const guint8 *data,
                                                   gint count,
                                                   gpointer user_data);

# 342 "/vagrant/allpkg/gimp-2.8.14/./libgimpbase/gimpwire.c"
gboolean
_gimp_wire_read_int16 (GIOChannel *channel,
                       guint16 *data,
                       gint count,
                       gpointer user_data)
{
  do{ if (__builtin_expect (__extension__ ({ int _g_boolean_var_; if (count >= 0) _g_boolean_var_ = 1; else _g_boolean_var_ = 0; _g_boolean_var_; }), 1)) { } else { g_return_if_fail_warning ("LibGimpBase", ((const char*) (__FUNCTION__)), "count >= 0"); return ((0)); }; }while (0);

  if (count > 0)
    {
      if (! _gimp_wire_read_int8 (channel,
                                  (guint8 *) data, count * 2, user_data))
        return (0);

      while (count--)
        {
          *data = (((((__extension__ ({ guint16 __v, __x = ((guint16) (*data)); if (__builtin_constant_p (__x)) __v = ((guint16) ( (guint16) ((guint16) (__x) >> 8) | (guint16) ((guint16) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))))));
          data++;
        }
    }

  return (!(0));
}

# 500 "/vagrant/allpkg/gimp-2.8.14/./libgimpbase/gimpwire.c"
gboolean
_gimp_wire_write_int16 (GIOChannel *channel,
                        const guint16 *data,
                        gint count,
                        gpointer user_data)
{
  do{ if (__builtin_expect (__extension__ ({ int _g_boolean_var_; if (count >= 0) _g_boolean_var_ = 1; else _g_boolean_var_ = 0; _g_boolean_var_; }), 1)) { } else { g_return_if_fail_warning ("LibGimpBase", ((const char*) (__FUNCTION__)), "count >= 0"); return ((0)); }; }while (0);

  if (count > 0)
    {
      gint i;

      for (i = 0; i < count; i++)
        {
          guint16 tmp = ((((__extension__ ({ guint16 __v, __x = ((guint16) (data[i])); if (__builtin_constant_p (__x)) __v = ((guint16) ( (guint16) ((guint16) (__x) >> 8) | (guint16) ((guint16) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })))));

          if (! _gimp_wire_write_int8 (channel,
                                       (const guint8 *) &tmp, 2, user_data))
            return (0);
        }
    }

  return (!(0));
}

