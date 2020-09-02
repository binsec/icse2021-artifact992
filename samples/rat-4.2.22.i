# 30 "/usr/include/i386-linux-gnu/bits/types.h"
typedef unsigned char __u_char;

# 33 "/usr/include/i386-linux-gnu/sys/types.h"
typedef __u_char u_char;

# 195 "/usr/include/i386-linux-gnu/sys/types.h"
typedef int int16_t;

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 69 "/usr/include/assert.h"
extern void __assert_fail (const char *__assertion, const char *__file,
      unsigned int __line, const char *__function);

# 50 "/usr/include/uclmmbase/util.h"
void *_block_alloc(unsigned size, const char *filen, int line);

# 21 "audio_types.h"
typedef enum {
 DEV_PCMU, /* mu-law (8 bits) */
        DEV_PCMA, /*  a-law (8 bits) */
 DEV_S8, /* signed 8 bits   */
        DEV_U8, /* unsigned 8 bits */
 DEV_S16 /* signed 16 bits  */
} deve_e;

# 29 "audio_types.h"
typedef struct s_audio_format {
  deve_e encoding;
  uint32_t sample_rate; /* Should be one of 8000, 16000, 24000, 32000, 48000 	*/
  int bits_per_sample; /* Should be 8 or 16 					*/
  int channels; /* Should be 1 or 2  					*/
  int bytes_per_block; /* size of unit we will read/write in 			*/
} audio_format;

# 37 "audio_types.h"
typedef int16_t sample;

# 17 "codec_types.h"
typedef uint32_t codec_id_t;

# 28 "codec_types.h"
typedef struct s_codec_format {
        char short_name[16];
        char long_name[32];
        char description[128];
        u_char default_pt;
        uint16_t mean_per_packet_state_size;
        uint16_t mean_coded_frame_size;
        const audio_format format;
} codec_format_t;

# 38 "codec_types.h"
typedef struct s_coded_unit {
        codec_id_t id;
 u_char *state;
 uint16_t state_len;
 u_char *data;
 uint16_t data_len;
} coded_unit;

# 28 "codec_l16.c"
static codec_format_t cs[] = {
        {"Linear-16", "L16-8K-Mono",
         "Linear 16 uncompressed audio, please do not use wide area.",
         122, 0, 320, {DEV_S16, 8000, 16, 1, 160 * sizeof(sample)}}, /* 20  ms */
        {"Linear-16", "L16-8K-Stereo",
         "Linear 16 uncompressed audio, please do not use wide area.",
         111, 0, 640, {DEV_S16, 8000, 16, 2, 2 * 160 * sizeof(sample)}}, /* 20  ms */
        {"Linear-16", "L16-16K-Mono",
         "Linear 16 uncompressed audio, please do not use wide area.",
         112, 0, 320, {DEV_S16, 16000, 16, 1, 160 * sizeof(sample)}}, /* 10 ms */
        {"Linear-16", "L16-16K-Stereo",
         "Linear 16 uncompressed audio, please do not use wide area.",
         113, 0, 640, {DEV_S16, 16000, 16, 2, 2 * 160 * sizeof(sample)}}, /* 10 ms */
        {"Linear-16", "L16-32K-Mono",
         "Linear 16 uncompressed audio, please do not use wide area.",
         114, 0, 320, {DEV_S16, 32000, 16, 1, 160 * sizeof(sample)}}, /* 5 ms */
        {"Linear-16", "L16-32K-Stereo",
         "Linear 16 uncompressed audio, please do not use wide area.",
         115, 0, 640, {DEV_S16, 32000, 16, 2, 2 * 160 * sizeof(sample)}}, /* 5 ms */
        {"Linear-16", "L16-44K-Mono",
         "Linear 16 uncompressed audio, please do not use wide area.",
         10, 0, 320, {DEV_S16, 44100, 16, 1, 160 * sizeof(sample)}}, /* 3.6 ms */
        {"Linear-16", "L16-44K-Stereo",
         "Linear 16 uncompressed audio, please do not use wide area.",
         11, 0, 640, {DEV_S16, 44100, 16, 2, 2 * 160 * sizeof(sample)}}, /* 3.6 ms */
        {"Linear-16", "L16-48K-Mono",
         "Linear 16 uncompressed audio, please do not use wide area.",
         116, 0, 320, {DEV_S16, 48000, 16, 1, 160 * sizeof(sample)}}, /* 3.3 ms */
        {"Linear-16", "L16-48K-Stereo",
         "Linear 16 uncompressed audio, please do not use wide area.",
         117, 0, 640, {DEV_S16, 48000, 16, 2, 2 * 160 * sizeof(sample)}} /* 3.3 ms */
};

# 76 "codec_l16.c"
int
l16_encode(uint16_t idx, u_char *state, sample *in, coded_unit *out)
{
        int samples;
        sample *d, *de;

        ((idx < sizeof(cs)/sizeof(codec_format_t)) ? (void) (0) : __assert_fail ("idx < sizeof(cs)/sizeof(codec_format_t)", "codec_l16.c", 82, __PRETTY_FUNCTION__));
        (state=state);

        out->state = ((void *)0);
        out->state_len = 0;
        out->data = (u_char*)_block_alloc(cs[idx].mean_coded_frame_size,"codec_l16.c",87);
        out->data_len = cs[idx].mean_coded_frame_size;

        samples = out->data_len / 2;
        d = (sample*)out->data;
        de = d + samples;

        while (d != de) {
                *d = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (*in); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
                d++; in++;
        }
        return samples;
}

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 55 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long long int __quad_t;

# 131 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __off_t;

# 132 "/usr/include/i386-linux-gnu/bits/types.h"
typedef __quad_t __off64_t;

# 48 "/usr/include/stdio.h"
typedef struct _IO_FILE FILE;

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

# 709 "/usr/include/stdio.h"
extern size_t fread (void *__restrict __ptr, size_t __size,
       size_t __n, FILE *__restrict __stream);

# 715 "/usr/include/stdio.h"
extern size_t fwrite (const void *__restrict __ptr, size_t __size,
        size_t __n, FILE *__restrict __s);

# 51 "/usr/include/uclmmbase/util.h"
void _block_free(void *p, int size, int line);

# 15 "codec_g711.h"
extern short mulawtolin[256];

# 16 "codec_g711.h"
extern unsigned char lintomulaw[65536];

# 18 "codec_g711.h"
extern short alawtolin[256];

# 19 "codec_g711.h"
extern unsigned char lintoalaw[8192];

# 15 "sndfile_types.h"
typedef enum {
        SNDFILE_ENCODING_PCMU,
        SNDFILE_ENCODING_PCMA,
        SNDFILE_ENCODING_L16,
        SNDFILE_ENCODING_L8
} sndfile_encoding_e;

# 22 "sndfile_types.h"
typedef struct {
        sndfile_encoding_e encoding;
        uint32_t sample_rate;
        uint32_t channels;
} sndfile_fmt_t;

# 25 "sndfile_raw.c"
typedef struct {
        sndfile_fmt_t fmt;
} raw_state_t;

# 49 "sndfile_raw.c"
int /* Returns the number of samples read */
raw_read_audio(FILE *pf, char* state, sample *buf, int samples)
{
        raw_state_t *rs;
        int unit_sz, samples_read, i;
        u_char *law;
        sample *bp;

        rs = (raw_state_t*)state;

        switch(rs->fmt.encoding) {
        case SNDFILE_ENCODING_PCMA:
        case SNDFILE_ENCODING_PCMU:
        case SNDFILE_ENCODING_L8:
                unit_sz = 1;
                break;
        case SNDFILE_ENCODING_L16:
                unit_sz = 2;
                break;
        default:
                unit_sz = 0;
                abort();
        }

        samples_read = fread(buf, unit_sz, samples, pf);

        switch(rs->fmt.encoding) {
        case SNDFILE_ENCODING_PCMA:
                law = ((u_char*)buf) + samples_read - 1;
                bp = buf + samples_read - 1;
                for(i = 0; i < samples_read; i++) {
                        *bp-- = alawtolin[((unsigned char)(*law--))];

                }
                break;
        case SNDFILE_ENCODING_PCMU:
                law = ((u_char*)buf) + samples_read - 1;
                bp = buf + samples_read - 1;
                for(i = 0; i < samples_read; i++) {
                        *bp = mulawtolin[((unsigned char)(*law))];
                        ((*law = lintomulaw[((unsigned short)(*law))]) ? (void) (0) : __assert_fail ("*law = lintomulaw[((unsigned short)(*law))]", "sndfile_raw.c", 89, __PRETTY_FUNCTION__));
                        bp--; law--;
                }
                break;
        case SNDFILE_ENCODING_L8:
                law = ((u_char*)buf) + samples_read - 1;
                bp = buf + samples_read - 1;
                for(i = 0; i < samples_read; i++) {
                        *bp = (sample)(*law)*256;
                        bp--; law--;
                }
                break;
        case SNDFILE_ENCODING_L16:
                for(i = 0; i < samples_read; i++) {
                        buf[i] = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (buf[i]); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
                }
                break;
        }
        return samples_read;
}

# 130 "sndfile_raw.c"
int
raw_write_audio(FILE *fp, char *state, sample *buf, int samples)
{
        int i, bytes_per_sample = 1;
        raw_state_t *rs;
        u_char *outbuf = ((void *)0);

        rs = (raw_state_t*)state;

        switch(rs->fmt.encoding) {
        case SNDFILE_ENCODING_L16:
                bytes_per_sample = (int)sizeof(sample);
                if ((__extension__ ({ unsigned short int __v, __x = (unsigned short int) (1); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) != 1) {
                        sample *l16buf;
                        l16buf = (sample*)_block_alloc(sizeof(sample)*samples,"sndfile_raw.c",144);
                        /* If we are on a little endian machine fix samples before
                         * writing them out.
                         */
                        for(i = 0; i < samples; i++) {
                                l16buf[i] = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (buf[i]); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
                        }
                        outbuf = (u_char*)l16buf;
                } else {
                        outbuf = (u_char*)buf;
                }
                break;
        case SNDFILE_ENCODING_L8:
                outbuf = (u_char*)_block_alloc(samples,"sndfile_raw.c",157);
                bytes_per_sample = 1;
                for(i = 0; i < samples; i++) {
                        outbuf[i] = (u_char)(buf[i]/256);
                }
                break;
        case SNDFILE_ENCODING_PCMA:
                outbuf = (u_char*)_block_alloc(samples,"sndfile_raw.c",164);
                bytes_per_sample = 1;
                for(i = 0; i < samples; i++) {
                        outbuf[i] = lintoalaw[((unsigned short)(buf[i]))>>3];
                }
                break;
        case SNDFILE_ENCODING_PCMU:
                outbuf = (u_char*)_block_alloc(samples,"sndfile_raw.c",171);
                bytes_per_sample = 1;
                for(i = 0; i < samples; i++) {
                        outbuf[i] = lintomulaw[((unsigned short)(buf[i]))];
                }
                break;
        }

        fwrite(outbuf, bytes_per_sample, samples, fp);

        /* outbuf only equals buf if no sample type conversion was done */
        if (outbuf != (u_char*)buf) {
                _block_free(outbuf,bytes_per_sample * samples,183);
        }

        return 1;
}

# 28 "sndfile_au.c"
typedef struct {
 uint32_t magic; /* magic number */
 uint32_t hdr_size; /* size of this header */
 uint32_t data_size; /* length of data (optional) */
 uint32_t encoding; /* data encoding format */
 uint32_t sample_rate; /* samples per second */
 uint32_t channels; /* number of interleaved channels */
} sun_audio_filehdr;

# 97 "sndfile_au.c"
int /* Returns the number of samples read */
sun_read_audio(FILE *pf, char* state, sample *buf, int samples)
{
        sun_audio_filehdr *afh;
        int unit_sz, samples_read, i;
        u_char *law;
        sample *bp;

        afh = (sun_audio_filehdr*)state;

        switch(afh->encoding) {
        case (27u) /* A-law PCM         */:
        case (1u) /* u-law PCM         */:
        case (2u) /* 8-bit linear PCM  */:
                unit_sz = 1;
                break;
        case (3u) /* 16-bit linear PCM */:
                unit_sz = 2;
                break;
        default:
                return 0;
        }

        samples_read = fread(buf, unit_sz, samples, pf);

        switch(afh->encoding) {
        case (27u) /* A-law PCM         */:
                law = ((u_char*)buf) + samples_read - 1;
                bp = buf + samples_read - 1;
                for(i = 0; i < samples_read; i++) {
                        *bp-- = alawtolin[((unsigned char)(*law--))];

                }
                break;
        case (1u) /* u-law PCM         */:
                law = ((u_char*)buf) + samples_read - 1;
                bp = buf + samples_read - 1;
                for(i = 0; i < samples_read; i++) {
                        *bp-- = mulawtolin[((unsigned char)(*law--))];
                }
                break;
        case (2u) /* 8-bit linear PCM  */:
                law = ((u_char*)buf) + samples_read - 1;
                bp = buf + samples_read - 1;
                for(i = 0; i < samples_read; i++) {
                        *bp-- = (sample)(*law) * 256;
                        law--;
                }
                break;
        case (3u) /* 16-bit linear PCM */:
                for(i = 0; i < samples_read; i++) {
                        buf[i] = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (buf[i]); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
                }
                break;
        }
        return samples_read;
}

# 199 "sndfile_au.c"
int
sun_write_audio(FILE *fp, char *state, sample *buf, int samples)
{
        int i, bytes_per_sample = 1;
        sun_audio_filehdr *saf;
        u_char *outbuf = ((void *)0);

        saf = (sun_audio_filehdr*)state;

        switch(saf->encoding) {
        case (3u) /* 16-bit linear PCM */:
                bytes_per_sample = (int)sizeof(sample);
                if ((__extension__ ({ unsigned short int __v, __x = (unsigned short int) (1); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) != 1) {
                        sample *l16buf;
                        l16buf = (sample*)_block_alloc(sizeof(sample)*samples,"sndfile_au.c",213);
                        /* If we are on a little endian machine fix samples before
                         * writing them out.
                         */
                        for(i = 0; i < samples; i++) {
                                l16buf[i] = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (buf[i]); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
                        }
                        outbuf = (u_char*)l16buf;
                } else {
                        outbuf = (u_char*)buf;
                }

                break;
        case (2u) /* 8-bit linear PCM  */:
                outbuf = (u_char*)_block_alloc(samples,"sndfile_au.c",227);
                bytes_per_sample = 1;
                for(i = 0; i < samples; i++) {
                        outbuf[i] = (u_char)(buf[i]>>8);
                }
                break;
        case (27u) /* A-law PCM         */:
                outbuf = (u_char*)_block_alloc(samples,"sndfile_au.c",234);
                bytes_per_sample = 1;
                for(i = 0; i < samples; i++) {
                        outbuf[i] = lintoalaw[((unsigned short)(buf[i]))>>3];
                }
                break;
        case (1u) /* u-law PCM         */:
                outbuf = (u_char*)_block_alloc(samples,"sndfile_au.c",241);
                bytes_per_sample = 1;
                for(i = 0; i < samples; i++) {
                        outbuf[i] = lintomulaw[((unsigned short)(buf[i]))];
                }
                break;
        }

        fwrite(outbuf, bytes_per_sample, samples, fp);

        /* outbuf only equals buf if no sample type conversion was done */
        if (outbuf != (u_char*)buf) {
                _block_free(outbuf,bytes_per_sample * samples,253);
        }

        return 1;
}

