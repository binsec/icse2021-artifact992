void * __builtin_alloca (unsigned int);
unsigned int __builtin_bswap32 (unsigned int);
void * __builtin___memcpy_chk (void *, const void *, unsigned int, unsigned int);
unsigned int __builtin_object_size (const void *, int);
unsigned int __builtin_strlen (const char *);
int __builtin_strcmp (const char *, const char *);

struct __sFile {
  int unused;
};

typedef struct __sFILE FILE;

extern int printf(const char *format, ...);

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 55 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long long int __quad_t;

# 131 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __off_t;

# 132 "/usr/include/i386-linux-gnu/bits/types.h"
typedef __quad_t __off64_t;

# 154 "/usr/include/libio.h"
typedef void _IO_lock_t;

# 160 "/usr/include/libio.h"
struct _IO_marker {
  struct _IO_marker *_next;
  struct _IO_FILE *_sbuf;
  /* If _pos >= 0
 it points to _buf->Gbase()+_pos. FIXME comment */
  /* if _pos < 0, it points to _buf->eBptr()+_pos. FIXME comment */
  int _pos;
# 177 "/usr/include/libio.h" 3 4
};

# 245 "/usr/include/libio.h"
struct _IO_FILE {
  int _flags; /* High-order word is _IO_MAGIC; rest is flags. */


  /* The following pointers correspond to the C++ streambuf protocol. */
  /* Note:  Tk uses the _IO_read_ptr and _IO_read_end fields directly. */
  char* _IO_read_ptr; /* Current read pointer */
  char* _IO_read_end; /* End of get area. */
  char* _IO_read_base; /* Start of putback+get area. */
  char* _IO_write_base; /* Start of put area. */
  char* _IO_write_ptr; /* Current put pointer. */
  char* _IO_write_end; /* End of put area. */
  char* _IO_buf_base; /* Start of reserve area. */
  char* _IO_buf_end; /* End of reserve area. */
  /* The following fields are used to support backing up and undo. */
  char *_IO_save_base; /* Pointer to start of non-current get area. */
  char *_IO_backup_base; /* Pointer to first valid character of backup area */
  char *_IO_save_end; /* Pointer to end of non-current get area. */

  struct _IO_marker *_markers;

  struct _IO_FILE *_chain;

  int _fileno;



  int _flags2;

  __off_t _old_offset; /* This used to be _offset but it's too small.  */


  /* 1+column number of pbase(); 0 is unknown. */
  unsigned short _cur_column;
  signed char _vtable_offset;
  char _shortbuf[1];

  /*  char* _save_gptr;  char* _save_egptr; */

  _IO_lock_t *_lock;
# 293 "/usr/include/libio.h" 3 4
  __off64_t _offset;
# 302 "/usr/include/libio.h" 3 4
  void *__pad1;
  void *__pad2;
  void *__pad3;
  void *__pad4;
  size_t __pad5;

  int _mode;
  /* Make sure we don't get into trouble again.  */
  char _unused2[15 * sizeof (int) - 4 * sizeof (void *) - sizeof (size_t)];

};

# 170 "/usr/include/stdio.h"
extern struct _IO_FILE *stderr;

# 242 "/usr/include/stdio.h"
extern int fflush (FILE *__stream);

# 44 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 28 "/usr/include/i386-linux-gnu/bits/sockaddr.h"
typedef unsigned short int sa_family_t;

# 149 "/usr/include/i386-linux-gnu/bits/socket.h"
struct sockaddr
  {
    sa_family_t sa_family; /* Common data: address family and length.  */
    char sa_data[14]; /* Address data.  */
  };

# 30 "/usr/include/netinet/in.h"
typedef uint32_t in_addr_t;

# 31 "/usr/include/netinet/in.h"
struct in_addr
  {
    in_addr_t s_addr;
  };

# 117 "/usr/include/netinet/in.h"
typedef uint16_t in_port_t;

# 237 "/usr/include/netinet/in.h"
struct sockaddr_in
  {
    sa_family_t sin_family;
    in_port_t sin_port; /* Port number.  */
    struct in_addr sin_addr; /* Internet address.  */

    /* Pad to size of `struct sockaddr'.  */
    unsigned char sin_zero[sizeof (struct sockaddr) -
      (sizeof (unsigned short int)) -
      sizeof (in_port_t) -
      sizeof (struct in_addr)];
  };

# 100 "/usr/include/netdb.h"
struct hostent
{
  char *h_name; /* Official name of host.  */
  char **h_aliases; /* Alias list.  */
  int h_addrtype; /* Host address type.  */
  int h_length; /* Length of address.  */
  char **h_addr_list; /* List of addresses from name server.  */



};

# 144 "/usr/include/netdb.h"
extern struct hostent *gethostbyname (const char *__name);

# 515 "../example-clients/netsource.c"
void
init_sockaddr_in (struct sockaddr_in *name , const char *hostname , uint16_t port)
{
    name->sin_family = 2 /* IP protocol family.  */ ;
    name->sin_port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
    if (hostname) {
        struct hostent *hostinfo = gethostbyname (hostname);
        if (hostinfo == ((void *)0)) {
            fprintf (stderr, "init_sockaddr_in: unknown host: %s.\n", hostname);
            fflush( stderr );
        }



        name->sin_addr = *(struct in_addr *) hostinfo->h_addr_list[0] /* Address, for backward compatibility.*/ ;

    } else
        name->sin_addr.s_addr = __bswap_32 (((in_addr_t) 0x00000000)) ;

}

# 147 "/usr/include/string.h"
extern int strncmp (const char *__s1, const char *__s2, size_t __n);

# 399 "/usr/include/string.h"
extern size_t strlen (const char *__s);

# 47 "/usr/include/i386-linux-gnu/bits/string3.h"
extern __inline void *
 memcpy (void *__restrict __dest, const void *__restrict __src, size_t __len)

{
  return __builtin___memcpy_chk (__dest, __src, __len, __builtin_object_size (__dest, 0));
}

# 33 "/vagrant/allpkg/jackd2-1.9.10+20140719git3eb0ae6a~dfsg/common/jack/types.h"
typedef uint32_t jack_nframes_t;

# 63 "/vagrant/allpkg/jackd2-1.9.10+20140719git3eb0ae6a~dfsg/common/jack/types.h"
typedef struct _jack_port jack_port_t;

# 460 "/vagrant/allpkg/jackd2-1.9.10+20140719git3eb0ae6a~dfsg/common/jack/types.h"
typedef float jack_default_audio_sample_t;

# 39 "/usr/include/samplerate.h"
typedef struct SRC_STATE_tag SRC_STATE;

# 42 "/usr/include/samplerate.h"
typedef struct
{ float *data_in, *data_out ;

 long input_frames, output_frames ;
 long input_frames_used, output_frames_gen ;

 int end_of_input ;

 double src_ratio ;
} SRC_DATA;

# 101 "/usr/include/samplerate.h"
int src_process (SRC_STATE *state, SRC_DATA *data);

# 137 "/usr/include/samplerate.h"
int src_set_ratio (SRC_STATE *state, double new_ratio);

# 774 "/vagrant/allpkg/jackd2-1.9.10+20140719git3eb0ae6a~dfsg/common/jack/jack.h"
void * jack_port_get_buffer (jack_port_t *port, jack_nframes_t);

# 808 "/vagrant/allpkg/jackd2-1.9.10+20140719git3eb0ae6a~dfsg/common/jack/jack.h"
const char * jack_port_type (const jack_port_t *port);

# 1024 "/vagrant/allpkg/jackd2-1.9.10+20140719git3eb0ae6a~dfsg/common/jack/jack.h"
int jack_port_type_size(void);

# 35 "/vagrant/allpkg/jackd2-1.9.10+20140719git3eb0ae6a~dfsg/common/jack/jslist.h"
typedef struct _JSList JSList;

# 38 "/vagrant/allpkg/jackd2-1.9.10+20140719git3eb0ae6a~dfsg/common/jack/jslist.h"
struct _JSList
{
    void *data;
    JSList *next;
};

# 34 "/vagrant/allpkg/jackd2-1.9.10+20140719git3eb0ae6a~dfsg/common/jack/midiport.h"
typedef unsigned char jack_midi_data_t;

# 38 "/vagrant/allpkg/jackd2-1.9.10+20140719git3eb0ae6a~dfsg/common/jack/midiport.h"
typedef struct _jack_midi_event
{
 jack_nframes_t time; /**< Sample index at which event is valid */
 size_t size; /**< Number of bytes of data in \a buffer */
 jack_midi_data_t *buffer; /**< Raw MIDI data */
} jack_midi_event_t;

# 56 "/vagrant/allpkg/jackd2-1.9.10+20140719git3eb0ae6a~dfsg/common/jack/midiport.h"
uint32_t
jack_midi_get_event_count(void* port_buffer);

# 71 "/vagrant/allpkg/jackd2-1.9.10+20140719git3eb0ae6a~dfsg/common/jack/midiport.h"
int
jack_midi_event_get(jack_midi_event_t *event,
                    void *port_buffer,
                    uint32_t event_index);

# 85 "/vagrant/allpkg/jackd2-1.9.10+20140719git3eb0ae6a~dfsg/common/jack/midiport.h"
void
jack_midi_clear_buffer(void *port_buffer);

# 157 "/vagrant/allpkg/jackd2-1.9.10+20140719git3eb0ae6a~dfsg/common/jack/midiport.h"
int
jack_midi_event_write(void *port_buffer,
                      jack_nframes_t time,
                      const jack_midi_data_t *data,
                      size_t data_size);

# 142 "../common/netjack_packet.c"
int jack_port_is_audio(const char *porttype)
{
    return ((__extension__ (__builtin_constant_p (jack_port_type_size()) && ((__builtin_constant_p (porttype) && strlen (porttype) < ((size_t) (jack_port_type_size()))) || (__builtin_constant_p ("32 bit float mono audio") && strlen ("32 bit float mono audio") < ((size_t) (jack_port_type_size())))) ? __extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (porttype) && __builtin_constant_p ("32 bit float mono audio") && (__s1_len = __builtin_strlen (porttype), __s2_len = __builtin_strlen ("32 bit float mono audio"), (!((size_t)(const void *)((porttype) + 1) - (size_t)(const void *)(porttype) == 1) || __s1_len >= 4) && (!((size_t)(const void *)(("32 bit float mono audio") + 1) - (size_t)(const void *)("32 bit float mono audio") == 1) || __s2_len >= 4)) ? __builtin_strcmp (porttype, "32 bit float mono audio") : (__builtin_constant_p (porttype) && ((size_t)(const void *)((porttype) + 1) - (size_t)(const void *)(porttype) == 1) && (__s1_len = __builtin_strlen (porttype), __s1_len < 4) ? (__builtin_constant_p ("32 bit float mono audio") && ((size_t)(const void *)(("32 bit float mono audio") + 1) - (size_t)(const void *)("32 bit float mono audio") == 1) ? __builtin_strcmp (porttype, "32 bit float mono audio") : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) ("32 bit float mono audio"); int __result = (((const unsigned char *) (const char *) (porttype))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (porttype))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (porttype))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (porttype))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p ("32 bit float mono audio") && ((size_t)(const void *)(("32 bit float mono audio") + 1) - (size_t)(const void *)("32 bit float mono audio") == 1) && (__s2_len = __builtin_strlen ("32 bit float mono audio"), __s2_len < 4) ? (__builtin_constant_p (porttype) && ((size_t)(const void *)((porttype) + 1) - (size_t)(const void *)(porttype) == 1) ? __builtin_strcmp (porttype, "32 bit float mono audio") : (- (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (porttype); int __result = (((const unsigned char *) (const char *) ("32 bit float mono audio"))[0] - __s2[0]); if (__s2_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) ("32 bit float mono audio"))[1] - __s2[1]); if (__s2_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) ("32 bit float mono audio"))[2] - __s2[2]); if (__s2_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) ("32 bit float mono audio"))[3] - __s2[3]); } } __result; })))) : __builtin_strcmp (porttype, "32 bit float mono audio")))); }) : strncmp (porttype, "32 bit float mono audio", jack_port_type_size()))) == 0);
}

# 147 "../common/netjack_packet.c"
int jack_port_is_midi(const char *porttype)
{
    return ((__extension__ (__builtin_constant_p (jack_port_type_size()) && ((__builtin_constant_p (porttype) && strlen (porttype) < ((size_t) (jack_port_type_size()))) || (__builtin_constant_p ("8 bit raw midi") && strlen ("8 bit raw midi") < ((size_t) (jack_port_type_size())))) ? __extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (porttype) && __builtin_constant_p ("8 bit raw midi") && (__s1_len = __builtin_strlen (porttype), __s2_len = __builtin_strlen ("8 bit raw midi"), (!((size_t)(const void *)((porttype) + 1) - (size_t)(const void *)(porttype) == 1) || __s1_len >= 4) && (!((size_t)(const void *)(("8 bit raw midi") + 1) - (size_t)(const void *)("8 bit raw midi") == 1) || __s2_len >= 4)) ? __builtin_strcmp (porttype, "8 bit raw midi") : (__builtin_constant_p (porttype) && ((size_t)(const void *)((porttype) + 1) - (size_t)(const void *)(porttype) == 1) && (__s1_len = __builtin_strlen (porttype), __s1_len < 4) ? (__builtin_constant_p ("8 bit raw midi") && ((size_t)(const void *)(("8 bit raw midi") + 1) - (size_t)(const void *)("8 bit raw midi") == 1) ? __builtin_strcmp (porttype, "8 bit raw midi") : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) ("8 bit raw midi"); int __result = (((const unsigned char *) (const char *) (porttype))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (porttype))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (porttype))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (porttype))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p ("8 bit raw midi") && ((size_t)(const void *)(("8 bit raw midi") + 1) - (size_t)(const void *)("8 bit raw midi") == 1) && (__s2_len = __builtin_strlen ("8 bit raw midi"), __s2_len < 4) ? (__builtin_constant_p (porttype) && ((size_t)(const void *)((porttype) + 1) - (size_t)(const void *)(porttype) == 1) ? __builtin_strcmp (porttype, "8 bit raw midi") : (- (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (porttype); int __result = (((const unsigned char *) (const char *) ("8 bit raw midi"))[0] - __s2[0]); if (__s2_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) ("8 bit raw midi"))[1] - __s2[1]); if (__s2_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) ("8 bit raw midi"))[2] - __s2[2]); if (__s2_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) ("8 bit raw midi"))[3] - __s2[3]); } } __result; })))) : __builtin_strcmp (porttype, "8 bit raw midi")))); }) : strncmp (porttype, "8 bit raw midi", jack_port_type_size()))) == 0);
}

# 801 "../common/netjack_packet.c"
void
decode_midi_buffer (uint32_t *buffer_uint32, unsigned int buffer_size_uint32, jack_default_audio_sample_t* buf)
{
    int i;
    jack_midi_clear_buffer (buf);
    for (i = 0; i < buffer_size_uint32 - 3;) {
        uint32_t payload_size;
        payload_size = buffer_uint32[i];
        payload_size = __bswap_32 (payload_size);
        if (payload_size) {
            jack_midi_event_t event;
            event.time = __bswap_32 (buffer_uint32[i + 1]);
            event.size = __bswap_32 (buffer_uint32[i + 2]);
            event.buffer = (jack_midi_data_t*) (&(buffer_uint32[i + 3]));
            jack_midi_event_write (buf, event.time, event.buffer, event.size);

            // skip to the next event
            unsigned int nb_data_quads = (((event.size - 1) & ~0x3) >> 2) + 1;
            i += 3 + nb_data_quads;
        } else
            break; // no events can follow an empty event, we're done
    }
}

# 825 "../common/netjack_packet.c"
void
encode_midi_buffer (uint32_t *buffer_uint32, unsigned int buffer_size_uint32, jack_default_audio_sample_t* buf)
{
    int i;
    unsigned int written = 0;
    // midi port, encode midi events
    unsigned int nevents = jack_midi_get_event_count (buf);
    for (i = 0; i < nevents; ++i) {
        jack_midi_event_t event;
        jack_midi_event_get (&event, buf, i);
        unsigned int nb_data_quads = (((event.size - 1) & ~0x3) >> 2) + 1;
        unsigned int payload_size = 3 + nb_data_quads;
        // only write if we have sufficient space for the event
        // otherwise drop it
        if (written + payload_size < buffer_size_uint32 - 1) {
            // write header
            buffer_uint32[written] = __bswap_32 (payload_size);
            written++;
            buffer_uint32[written] = __bswap_32 (event.time);
            written++;
            buffer_uint32[written] = __bswap_32 (event.size);
            written++;

            // write data
            jack_midi_data_t* tmpbuff = (jack_midi_data_t*)(&(buffer_uint32[written]));
            memcpy (tmpbuff, event.buffer, event.size);
            written += nb_data_quads;
        } else {
            // buffer overflow
            printf ("midi buffer overflow");
            break;
        }
    }
    // now put a netjack_midi 'no-payload' event, signaling EOF
    buffer_uint32[written] = 0;
}

# 1007 "../common/netjack_packet.c"
void
render_payload_to_jack_ports_16bit (void *packet_payload, jack_nframes_t net_period_down, JSList *capture_ports, JSList *capture_srcs, jack_nframes_t nframes)
{
    int chn = 0;
    JSList *node = capture_ports;

    JSList *src_node = capture_srcs;


    uint16_t *packet_bufX = (uint16_t *)packet_payload;

    if( !packet_payload )
        return;

    while (node != ((void *)0)) {
        int i;
        //uint32_t val;

        SRC_DATA src;


        jack_port_t *port = (jack_port_t *) node->data;
        jack_default_audio_sample_t* buf = jack_port_get_buffer (port, nframes);


        float *floatbuf = __builtin_alloca (sizeof(float) * net_period_down);

        const char *porttype = jack_port_type (port);

        if (jack_port_is_audio (porttype)) {
            // audio port, resample if necessary


            if (net_period_down != nframes) {
                SRC_STATE *src_state = src_node->data;
                for (i = 0; i < net_period_down; i++) {
                    floatbuf[i] = ((float) (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (packet_bufX[i]); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))) / 32767.0 - 1.0;
                }

                src.data_in = floatbuf;
                src.input_frames = net_period_down;

                src.data_out = buf;
                src.output_frames = nframes;

                src.src_ratio = (float) nframes / (float) net_period_down;
                src.end_of_input = 0;

                src_set_ratio (src_state, src.src_ratio);
                src_process (src_state, &src);
                src_node = ((src_node) ? (((JSList *)(src_node))->next) : ((void *)0));
            } else

                for (i = 0; i < net_period_down; i++)
                    buf[i] = ((float) (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (packet_bufX[i]); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))) / 32768.0 - 1.0;
        } else if (jack_port_is_midi (porttype)) {
            // midi port, decode midi events
            // convert the data buffer to a standard format (uint32_t based)
            unsigned int buffer_size_uint32 = net_period_down / 2;
            uint32_t * buffer_uint32 = (uint32_t*) packet_bufX;
            decode_midi_buffer (buffer_uint32, buffer_size_uint32, buf);
        }
        packet_bufX = (packet_bufX + net_period_down);
        node = ((node) ? (((JSList *)(node))->next) : ((void *)0));
        chn++;
    }
}

# 1075 "../common/netjack_packet.c"
void
render_jack_ports_to_payload_16bit (JSList *playback_ports, JSList *playback_srcs, jack_nframes_t nframes, void *packet_payload, jack_nframes_t net_period_up)
{
    int chn = 0;
    JSList *node = playback_ports;

    JSList *src_node = playback_srcs;


    uint16_t *packet_bufX = (uint16_t *)packet_payload;

    while (node != ((void *)0)) {

        SRC_DATA src;

        int i;
        jack_port_t *port = (jack_port_t *) node->data;
        jack_default_audio_sample_t* buf = jack_port_get_buffer (port, nframes);
        const char *porttype = jack_port_type (port);

        if (jack_port_is_audio (porttype)) {
            // audio port, resample if necessary


            if (net_period_up != nframes) {
                SRC_STATE *src_state = src_node->data;

                float *floatbuf = __builtin_alloca (sizeof(float) * net_period_up);

                src.data_in = buf;
                src.input_frames = nframes;

                src.data_out = floatbuf;
                src.output_frames = net_period_up;

                src.src_ratio = (float) net_period_up / (float) nframes;
                src.end_of_input = 0;

                src_set_ratio (src_state, src.src_ratio);
                src_process (src_state, &src);

                for (i = 0; i < net_period_up; i++) {
                    packet_bufX[i] = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (((uint16_t)((floatbuf[i] + 1.0) * 32767.0))); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
                }
                src_node = ((src_node) ? (((JSList *)(src_node))->next) : ((void *)0));
            } else

                for (i = 0; i < net_period_up; i++)
                    packet_bufX[i] = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (((uint16_t)((buf[i] + 1.0) * 32767.0))); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
        } else if (jack_port_is_midi (porttype)) {
            // encode midi events from port to packet
            // convert the data buffer to a standard format (uint32_t based)
            unsigned int buffer_size_uint32 = net_period_up / 2;
            uint32_t * buffer_uint32 = (uint32_t*) packet_bufX;
            encode_midi_buffer (buffer_uint32, buffer_size_uint32, buf);
        }
        packet_bufX = (packet_bufX + net_period_up);
        node = ((node) ? (((JSList *)(node))->next) : ((void *)0));
        chn++;
    }
}

