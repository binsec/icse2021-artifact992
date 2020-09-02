unsigned int __builtin_object_size (const void *, int);

# 247 "./libtomcrypt/src/headers/tomcrypt_macros.h"
static inline unsigned ROL(unsigned word, int i)
{
   asm ("roll %%cl,%0"
      :"=r" (word)
      :"0" (word),"c" (i));
   return word;
}

# 255 "./libtomcrypt/src/headers/tomcrypt_macros.h"
static inline unsigned ROR(unsigned word, int i)
{
   asm ("rorl %%cl,%0"
      :"=r" (word)
      :"0" (word),"c" (i));
   return word;
}

# 31 "buffer.h"
struct buf {

 unsigned char * data;
 unsigned int len; /* the used size */
 unsigned int pos;
 unsigned int size; /* the memory size */

};

# 40 "buffer.h"
typedef struct buf buffer;

# 49 "dbutil.h"
void dropbear_exit(const char* format, ...);

# 131 "buffer.c"
void buf_incrwritepos(buffer* buf, unsigned int incr) {
 if (incr > 1000000000 || buf->pos + incr > buf->size) {
  dropbear_exit("Bad buf_incrwritepos");
 }
 buf->pos += incr;
 if (buf->pos > buf->len) {
  buf->len = buf->pos;
 }
}

# 143 "buffer.c"
void buf_incrpos(buffer* buf, int incr) {
 if (incr > 1000000000 ||
   (unsigned int)((int)buf->pos + incr) > buf->len
   || ((int)buf->pos + incr) < 0) {
  dropbear_exit("Bad buf_incrpos");
 }
 buf->pos += incr;
}

# 185 "buffer.c"
unsigned char* buf_getptr(buffer* buf, unsigned int len) {

 if (buf->pos + len > buf->len) {
  dropbear_exit("Bad buf_getptr");
 }
 return &buf->data[buf->pos];
}

# 195 "buffer.c"
unsigned char* buf_getwriteptr(buffer* buf, unsigned int len) {

 if (buf->pos + len > buf->size) {
  dropbear_exit("Bad buf_getwriteptr");
 }
 return &buf->data[buf->pos];
}

# 248 "buffer.c"
unsigned int buf_getint(buffer* buf) {
 unsigned int ret;

 asm __volatile__ ( "movl (%1),%0\n\t" "bswapl %0\n\t" :"=r"(ret): "r"(buf_getptr(buf, 4)));;
 buf_incrpos(buf, 4);
 return ret;
}

# 257 "buffer.c"
void buf_putint(buffer* buf, int unsigned val) {

 asm __volatile__ ( "bswapl %0     \n\t" "movl   %0,(%1)\n\t" "bswapl %0     \n\t" ::"r"(val), "r"(buf_getwriteptr(buf, 4)));;
 buf_incrwritepos(buf, 4);

}

# 125 "/usr/include/i386-linux-gnu/bits/types.h"
typedef unsigned int __uid_t;

# 126 "/usr/include/i386-linux-gnu/bits/types.h"
typedef unsigned int __gid_t;

# 139 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __time_t;

# 141 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __suseconds_t;

# 172 "/usr/include/i386-linux-gnu/bits/types.h"
typedef int __ssize_t;

# 65 "/usr/include/i386-linux-gnu/sys/types.h"
typedef __gid_t gid_t;

# 80 "/usr/include/i386-linux-gnu/sys/types.h"
typedef __uid_t uid_t;

# 109 "/usr/include/i386-linux-gnu/sys/types.h"
typedef __ssize_t ssize_t;

# 75 "/usr/include/time.h"
typedef __time_t time_t;

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 30 "/usr/include/i386-linux-gnu/bits/time.h"
struct timeval
  {
    __time_t tv_sec; /* Seconds.  */
    __suseconds_t tv_usec; /* Microseconds.  */
  };

# 54 "/usr/include/i386-linux-gnu/sys/select.h"
typedef long int __fd_mask;

# 64 "/usr/include/i386-linux-gnu/sys/select.h"
typedef struct
  {
    /* XPG4.2 requires this member name.  Otherwise avoid the name
       from the global namespace.  */




    __fd_mask __fds_bits[1024 / (8 * (int) sizeof (__fd_mask))];


  } fd_set;

# 24 "/usr/include/i386-linux-gnu/bits/select2.h"
extern long int __fdelt_chk (long int __d);

# 25 "/usr/include/i386-linux-gnu/bits/select2.h"
extern long int __fdelt_warn (long int __d);

# 50 "/usr/include/i386-linux-gnu/bits/errno.h"
extern int *__errno_location (void);

# 23 "/usr/include/i386-linux-gnu/bits/unistd.h"
extern ssize_t __read_chk (int __fd, void *__buf, size_t __nbytes,
      size_t __buflen);

# 25 "/usr/include/i386-linux-gnu/bits/unistd.h"
extern ssize_t __read_alias (int __fd, void *__buf, size_t __nbytes) __asm__ ("" "read");

# 27 "/usr/include/i386-linux-gnu/bits/unistd.h"
extern ssize_t __read_chk_warn (int __fd, void *__buf, size_t __nbytes, size_t __buflen) __asm__ ("" "__read_chk");

# 33 "/usr/include/i386-linux-gnu/bits/unistd.h"
extern __inline ssize_t
read (int __fd, void *__buf, size_t __nbytes)
{
  if (__builtin_object_size (__buf, 0) != (size_t) -1)
    {
      if (!__builtin_constant_p (__nbytes))
 return __read_chk (__fd, __buf, __nbytes, __builtin_object_size (__buf, 0));

      if (__nbytes > __builtin_object_size (__buf, 0))
 return __read_chk_warn (__fd, __buf, __nbytes, __builtin_object_size (__buf, 0));
    }
  return __read_alias (__fd, __buf, __nbytes);
}

# 368 "/usr/include/i386-linux-gnu/zconf.h"
typedef unsigned char Byte;

# 370 "/usr/include/i386-linux-gnu/zconf.h"
typedef unsigned int uInt;

# 371 "/usr/include/i386-linux-gnu/zconf.h"
typedef unsigned long uLong;

# 377 "/usr/include/i386-linux-gnu/zconf.h"
typedef Byte Bytef;

# 386 "/usr/include/i386-linux-gnu/zconf.h"
typedef void *voidpf;

# 80 "/usr/include/zlib.h"
typedef voidpf (*alloc_func) (voidpf opaque, uInt items, uInt size);

# 81 "/usr/include/zlib.h"
typedef void (*free_func) (voidpf opaque, voidpf address);

# 85 "/usr/include/zlib.h"
typedef struct z_stream_s {
    Bytef *next_in; /* next input byte */
    uInt avail_in; /* number of bytes available at next_in */
    uLong total_in; /* total number of input bytes read so far */

    Bytef *next_out; /* next output byte should be put there */
    uInt avail_out; /* remaining free space at next_out */
    uLong total_out; /* total number of bytes output so far */

    char *msg; /* last error message, NULL if no error */
    struct internal_state *state; /* not visible by applications */

    alloc_func zalloc; /* used to allocate the internal state */
    free_func zfree; /* used to free the internal state */
    voidpf opaque; /* private data object passed to zalloc and zfree */

    int data_type; /* best guess about the data type: binary or text */
    uLong adler; /* adler32 value of the uncompressed data */
    uLong reserved; /* reserved for future use */
} z_stream;

# 106 "/usr/include/zlib.h"
typedef z_stream *z_streamp;

# 1742 "/usr/include/zlib.h"
struct internal_state {int dummy;};

# 7 "./libtomcrypt/src/headers/tomcrypt_macros.h"
typedef unsigned long long ulong64;

# 16 "./libtomcrypt/src/headers/tomcrypt_macros.h"
typedef unsigned long ulong32;

# 34 "./libtomcrypt/src/headers/tomcrypt_cipher.h"
struct rijndael_key {
   ulong32 eK[60], dK[60];
   int Nr;
};

# 66 "./libtomcrypt/src/headers/tomcrypt_cipher.h"
struct twofish_key {
      ulong32 K[40];
      unsigned char S[32], start;
   };

# 91 "./libtomcrypt/src/headers/tomcrypt_cipher.h"
struct des_key {
    ulong32 ek[32], dk[32];
};

# 95 "./libtomcrypt/src/headers/tomcrypt_cipher.h"
struct des3_key {
    ulong32 ek[3][32], dk[3][32];
};

# 134 "./libtomcrypt/src/headers/tomcrypt_cipher.h"
typedef union Symmetric_key {

   struct des_key des;
   struct des3_key des3;
# 146 "./libtomcrypt/src/headers/tomcrypt_cipher.h"
   struct twofish_key twofish;
# 161 "./libtomcrypt/src/headers/tomcrypt_cipher.h"
   struct rijndael_key rijndael;
# 187 "./libtomcrypt/src/headers/tomcrypt_cipher.h"
   void *data;
} symmetric_key;

# 238 "./libtomcrypt/src/headers/tomcrypt_cipher.h"
typedef struct {
   /** The index of the cipher chosen */
   int cipher,
   /** The block size of the given cipher */
                       blocklen;
   /** The current IV */
   unsigned char IV[128];
   /** The scheduled key */
   symmetric_key key;
} symmetric_CBC;

# 253 "./libtomcrypt/src/headers/tomcrypt_cipher.h"
typedef struct {
   /** The index of the cipher chosen */
   int cipher,
   /** The block size of the given cipher */
                       blocklen,
   /** The padding offset */
                       padlen,
   /** The mode (endianess) of the CTR, 0==little, 1==big */
                       mode;
   /** The counter */
   unsigned char ctr[128],
   /** The pad used to encrypt/decrypt */
                       pad[128];
   /** The scheduled key */
   symmetric_key key;
} symmetric_CTR;

# 3 "./libtomcrypt/src/headers/tomcrypt_hash.h"
struct sha512_state {
    ulong64 length, state[8];
    unsigned long curlen;
    unsigned char buf[128];
};

# 11 "./libtomcrypt/src/headers/tomcrypt_hash.h"
struct sha256_state {
    ulong64 length;
    ulong32 state[8], curlen;
    unsigned char buf[64];
};

# 19 "./libtomcrypt/src/headers/tomcrypt_hash.h"
struct sha1_state {
    ulong64 length;
    ulong32 state[5], curlen;
    unsigned char buf[64];
};

# 27 "./libtomcrypt/src/headers/tomcrypt_hash.h"
struct md5_state {
    ulong64 length;
    ulong32 state[4], curlen;
    unsigned char buf[64];
};

# 105 "./libtomcrypt/src/headers/tomcrypt_hash.h"
typedef union Hash_state {
    char dummy[1];







    struct sha512_state sha512;


    struct sha256_state sha256;


    struct sha1_state sha1;


    struct md5_state md5;
# 146 "./libtomcrypt/src/headers/tomcrypt_hash.h"
    void *data;
} hash_state;

# 94 "libtommath/tommath.h"
typedef unsigned long mp_digit;

# 179 "libtommath/tommath.h"
typedef struct {
    int used, alloc, sign;
    mp_digit *dp;
} mp_int;

# 36 "algo.h"
struct Algo_Type {

 const unsigned char *name; /* identifying name */
 char val; /* a value for this cipher, or -1 for invalid */
 const void *data; /* algorithm specific data */
 char usable; /* whether we can use this algorithm */
 const void *mode; /* the mode, currently only used for ciphers,
						 points to a 'struct dropbear_cipher_mode' */
};

# 46 "algo.h"
typedef struct Algo_Type algo_type;

# 60 "algo.h"
struct dropbear_cipher {
 const struct ltc_cipher_descriptor *cipherdesc;
 const unsigned long keysize;
 const unsigned char blocksize;
};

# 66 "algo.h"
struct dropbear_cipher_mode {
 int (*start)(int cipher, const unsigned char *IV,
   const unsigned char *key,
   int keylen, int num_rounds, void *cipher_state);
 int (*encrypt)(const unsigned char *pt, unsigned char *ct,
   unsigned long len, void *cipher_state);
 int (*decrypt)(const unsigned char *ct, unsigned char *pt,
   unsigned long len, void *cipher_state);
};

# 76 "algo.h"
struct dropbear_hash {
 const struct ltc_hash_descriptor *hash_desc;
 const unsigned long keysize;
 /* hashsize may be truncated from the size returned by hash_desc,
	   eg sha1-96 */
 const unsigned char hashsize;
};

# 84 "algo.h"
enum dropbear_kex_mode {
 DROPBEAR_KEX_NORMAL_DH,
 DROPBEAR_KEX_ECDH,
 DROPBEAR_KEX_CURVE25519,
};

# 90 "algo.h"
struct dropbear_kex {
 enum dropbear_kex_mode mode;

 /* "normal" DH KEX */
 const unsigned char *dh_p_bytes;
 const int dh_p_len;

 /* elliptic curve DH KEX */

 const struct dropbear_ecc_curve *ecc_curve;




 /* both */
 const struct ltc_hash_descriptor *hash_desc;
};

# 67 "kex.h"
struct KEXState {

 unsigned sentkexinit : 1; /*set when we've sent/recv kexinit packet */
 unsigned recvkexinit : 1;
 unsigned them_firstfollows : 1; /* true when first_kex_packet_follows is set */
 unsigned sentnewkeys : 1; /* set once we've send MSG_NEWKEYS (will be cleared once we have also received */
 unsigned recvnewkeys : 1; /* set once we've received MSG_NEWKEYS (cleared once we have also sent */

 unsigned donefirstkex : 1; /* Set to 1 after the first kex has completed,
								  ie the transport layer has been set up */

 unsigned our_first_follows_matches : 1;

 time_t lastkextime; /* time of the last kex */
 unsigned int datatrans; /* data transmitted since last kex */
 unsigned int datarecv; /* data received since last kex */

};

# 27 "circbuffer.h"
struct circbuf {

 unsigned int size;
 unsigned int readpos;
 unsigned int writepos;
 unsigned int used;
 unsigned char* data;
};

# 36 "circbuffer.h"
typedef struct circbuf circbuffer;

# 44 "channel.h"
enum dropbear_channel_prio {
 DROPBEAR_CHANNEL_PRIO_INTERACTIVE, /* pty shell, x11 */
 DROPBEAR_CHANNEL_PRIO_UNKNOWABLE, /* tcp - can't know what's being forwarded */
 DROPBEAR_CHANNEL_PRIO_BULK, /* the rest - probably scp or something */
 DROPBEAR_CHANNEL_PRIO_EARLY, /* channel is still being set up */
};

# 51 "channel.h"
struct Channel {

 unsigned int index; /* the local channel index */
 unsigned int remotechan;
 unsigned int recvwindow, transwindow;
 unsigned int recvdonelen;
 unsigned int recvmaxpacket, transmaxpacket;
 void* typedata; /* a pointer to type specific data */
 int writefd; /* read from wire, written to insecure side */
 int readfd; /* read from insecure side, written to wire */
 int errfd; /* used like writefd or readfd, depending if it's client or server.
				  Doesn't exactly belong here, but is cleaner here */
 circbuffer *writebuf; /* data from the wire, for local consumption. Can be
							 initially NULL */
 circbuffer *extrabuf; /* extended-data for the program - used like writebuf
					     but for stderr */

 /* whether close/eof messages have been exchanged */
 int sent_close, recv_close;
 int recv_eof, sent_eof;

 /* Set after running the ChanType-specific close hander
	 * to ensure we don't run it twice (nor type->checkclose()). */
 int close_handler_done;

 int initconn; /* used for TCP forwarding, whether the channel has been
					 fully initialised */

 int await_open; /* flag indicating whether we've sent an open request
					   for this channel (and are awaiting a confirmation
					   or failure). */

 int flushing;

 /* Used by client chansession to handle ~ escaping, NULL ignored otherwise */
 void (*read_mangler)(struct Channel*, unsigned char* bytes, int *len);

 const struct ChanType* type;

 enum dropbear_channel_prio prio;
};

# 93 "channel.h"
struct ChanType {

 int sepfds; /* Whether this channel has seperate pipes for in/out or not */
 char *name;
 int (*inithandler)(struct Channel*);
 int (*check_close)(struct Channel*);
 void (*reqhandler)(struct Channel*);
 void (*closehandler)(struct Channel*);
};

# 105 "channel.h"
void setchannelfds(fd_set *readfd, fd_set *writefd);

# 106 "channel.h"
void channelio(fd_set *readfd, fd_set *writefd);

# 31 "listener.h"
struct Listener {

 int socks[2 /* IPv4, IPv6 are all we'll get for now. Revisit
								in a few years time.... */
# 33 "listener.h"
                             ];
 unsigned int nsocks;

 int index; /* index in the array of listeners */

 void (*acceptor)(struct Listener*, int sock);
 void (*cleanup)(struct Listener*);

 int type; /* CHANNEL_ID_X11, CHANNEL_ID_AGENT, 
				 CHANNEL_ID_TCPDIRECT (for clients),
				 CHANNEL_ID_TCPFORWARDED (for servers) */

 void *typedata;

};

# 102 "auth.h"
struct AuthState {
 char *username; /* This is the username the client presents to check. It
					   is updated each run through, used for auth checking */
 unsigned char authtypes; /* Flags indicating which auth types are still 
								valid */
 unsigned int failcount; /* Number of (failed) authentication attempts.*/
 unsigned authdone : 1; /* 0 if we haven't authed, 1 if we have. Applies for
							  client and server (though has differing [obvious]
							  meanings). */
 unsigned perm_warn : 1; /* Server only, set if bad permissions on 
							   ~/.ssh/authorized_keys have already been
							   logged. */

 /* These are only used for the server */
 uid_t pw_uid;
 gid_t pw_gid;
 char *pw_dir;
 char *pw_shell;
 char *pw_name;
 char *pw_passwd;

 struct PubKeyOptions* pubkey_options;

};

# 129 "auth.h"
struct PubKeyOptions {
 /* Flags */
 int no_port_forwarding_flag;
 int no_agent_forwarding_flag;
 int no_x11_forwarding_flag;
 int no_pty_flag;
 /* "command=" option. */
 unsigned char * forced_command;
};

# 28 "queue.h"
struct Link {

 void* item;
 struct Link* link;

};

# 35 "queue.h"
struct Queue {

 struct Link* head;
 struct Link* tail;
 unsigned int count;

};

# 44 "queue.h"
int isempty(struct Queue* queue);

# 31 "packet.h"
void write_packet();

# 32 "packet.h"
void read_packet();

# 36 "packet.h"
void process_packet();

# 38 "packet.h"
void maybe_flush_reply_queue();

# 39 "packet.h"
typedef struct PacketType {
 unsigned char type; /* SSH_MSG_FOO */
 void (*handler)();
} packettype;

# 54 "dbutil.h"
void fail_assert(const char* expr, const char* file, int line);

# 64 "dbutil.h"
enum dropbear_prio {
 DROPBEAR_PRIO_DEFAULT = 10,
 DROPBEAR_PRIO_LOWDELAY = 11,
 DROPBEAR_PRIO_BULK = 12,
};

# 66 "session.h"
struct key_context_directional {
 const struct dropbear_cipher *algo_crypt;
 const struct dropbear_cipher_mode *crypt_mode;
 const struct dropbear_hash *algo_mac;
 int hash_index; /* lookup for libtomcrypt */
 int algo_comp; /* compression */

 z_streamp zstream;

 /* actual keys */
 union {
  symmetric_CBC cbc;

  symmetric_CTR ctr;

 } cipher_state;
 unsigned char mackey[20];
 int valid;
};

# 86 "session.h"
struct key_context {

 struct key_context_directional recv;
 struct key_context_directional trans;

 const struct dropbear_kex *algo_kex;
 int algo_hostkey;

 int allow_compress; /* whether compression has started (useful in 
							zlib@openssh.com delayed compression case) */
};

# 99 "session.h"
struct packetlist {
 struct packetlist *next;
 buffer * payload;
};

# 104 "session.h"
struct sshsession {

 /* Is it a client or server? */
 unsigned char isserver;

 int sock_in;
 int sock_out;

 /* remotehost will be initially NULL as we delay
	 * reading the remote version string. it will be set
	 * by the time any recv_() packet methods are called */
 unsigned char *remoteident;

 int maxfd; /* the maximum file descriptor to check with select() */


 /* Packet buffers/values etc */
 buffer *writepayload; /* Unencrypted payload to write - this is used
							 throughout the code, as handlers fill out this
							 buffer with the packet to send. */
 struct Queue writequeue; /* A queue of encrypted packets to send */
 buffer *readbuf; /* From the wire, decrypted in-place */
 buffer *payload; /* Post-decompression, the actual SSH packet */
 unsigned int transseq, recvseq; /* Sequence IDs */

 /* Packet-handling flags */
 const packettype * packettypes; /* Packet handler mappings for this
										session, see process-packet.c */

 unsigned dataallowed : 1; /* whether we can send data packets or we are in
								 the middle of a KEX or something */

 unsigned char requirenext; /* byte indicating what packets we require next, 
									 or 0x00 for any.  */

 unsigned char ignorenext; /* whether to ignore the next packet,
								 used for kex_follows stuff */

 unsigned char lastpacket; /* What the last received packet type was */

 int signal_pipe[2]; /* stores endpoints of a self-pipe used for
						   race-free signal handling */

 /* time of the last packet send/receive, for keepalive. Not real-world clock */
 time_t last_packet_time_keepalive_sent;
 time_t last_packet_time_keepalive_recv;
 time_t last_packet_time_any_sent;

 time_t last_packet_time_idle; /* time of the last packet transmission or receive, for
								idle timeout purposes so ignores SSH_MSG_IGNORE
								or responses to keepalives. Not real-world clock */


 /* KEX/encryption related */
 struct KEXState kexstate;
 struct key_context *keys;
 struct key_context *newkeys;
 buffer *session_id; /* this is the hash from the first kex */
 /* The below are used temporarily during kex, are freed after use */
 mp_int * dh_K; /* SSH_MSG_KEXDH_REPLY and sending SSH_MSH_NEWKEYS */
 buffer *hash; /* the session hash */
 buffer* kexhashbuf; /* session hash buffer calculated from various packets*/
 buffer* transkexinit; /* the kexinit packet we send should be kept so we
							 can add it to the hash when generating keys */

 /* Enables/disables compression */
 algo_type *compress_algos;

 /* a list of queued replies that should be sent after a KEX has
	   concluded (ie, while dataallowed was unset)*/
 struct packetlist *reply_queue_head, *reply_queue_tail;

 void(*remoteclosed)(); /* A callback to handle closure of the
									  remote connection */

 void(*extra_session_cleanup)(); /* client or server specific cleanup */
 void(*send_kex_first_guess)();

 struct AuthState authstate; /* Common amongst client and server, since most
								   struct elements are common */

 /* Channel related */
 struct Channel ** channels; /* these pointers may be null */
 unsigned int chansize; /* the number of Channel*s allocated for channels */
 unsigned int chancount; /* the number of Channel*s in use */
 const struct ChanType **chantypes; /* The valid channel types */
 int channel_signal_pending; /* Flag set by sigchld handler */

 /* TCP priority level for the main "port 22" tcp socket */
 enum dropbear_prio socket_prio;

 /* TCP forwarding - where manage listeners */
 struct Listener ** listeners;
 unsigned int listensize;

 /* Whether to allow binding to privileged ports (<1024). This doesn't
	 * really belong here, but nowhere else fits nicely */
 int allowprivport;

};

# 38 "common-session.c"
static void checktimeouts();

# 39 "common-session.c"
static long select_timeout();

# 41 "common-session.c"
static void read_session_identification();

# 43 "common-session.c"
struct sshsession ses;

# 50 "common-session.c"
int exitflag = 0;

# 135 "common-session.c"
void session_loop(void(*loophandler)()) {

 fd_set readfd, writefd;
 struct timeval timeout;
 int val;

 /* main loop, select()s for all sockets in use */
 for(;;) {

  timeout.tv_sec = select_timeout();
  timeout.tv_usec = 0;
  do { int __d0, __d1; __asm__ __volatile__ ("cld; rep; " "stosl" : "=c" (__d0), "=D" (__d1) : "a" (0), "0" (sizeof (fd_set) / sizeof (__fd_mask)), "1" (&((&writefd)->__fds_bits)[0]) : "memory"); } while (0);
  do { int __d0, __d1; __asm__ __volatile__ ("cld; rep; " "stosl" : "=c" (__d0), "=D" (__d1) : "a" (0), "0" (sizeof (fd_set) / sizeof (__fd_mask)), "1" (&((&readfd)->__fds_bits)[0]) : "memory"); } while (0);
  do { if (!(ses.payload == ((void *)0))) { fail_assert("ses.payload == NULL", "common-session.c", 148); } } while (0);

  /* during initial setup we flush out the KEXINIT packet before
		 * attempting to read the remote version string, which might block */
  if (ses.sock_in != -1 && (ses.remoteident || isempty(&ses.writequeue))) {
   ((void) (((&readfd)->__fds_bits)[__extension__ ({ long int __d = (ses.sock_in); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] |= ((__fd_mask) 1 << ((ses.sock_in) % (8 * (int) sizeof (__fd_mask))))));
  }
  if (ses.sock_out != -1 && !isempty(&ses.writequeue)) {
   ((void) (((&writefd)->__fds_bits)[__extension__ ({ long int __d = (ses.sock_out); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] |= ((__fd_mask) 1 << ((ses.sock_out) % (8 * (int) sizeof (__fd_mask))))));
  }

  /* We get woken up when signal handlers write to this pipe.
		   SIGCHLD in svr-chansession is the only one currently. */
  ((void) (((&readfd)->__fds_bits)[__extension__ ({ long int __d = (ses.signal_pipe[0]); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] |= ((__fd_mask) 1 << ((ses.signal_pipe[0]) % (8 * (int) sizeof (__fd_mask))))));

  /* set up for channels which can be read/written */
  setchannelfds(&readfd, &writefd);

  val = select(ses.maxfd+1, &readfd, &writefd, ((void *)0), &timeout);

  if (exitflag) {
   dropbear_exit("Terminated by signal");
  }

  if (val < 0 && (*__errno_location ()) != 4 /* Interrupted system call */) {
   dropbear_exit("Error in select");
  }

  if (val <= 0) {
   /* If we were interrupted or the select timed out, we still
			 * want to iterate over channels etc for reading, to handle
			 * server processes exiting etc. 
			 * We don't want to read/write FDs. */
   do { int __d0, __d1; __asm__ __volatile__ ("cld; rep; " "stosl" : "=c" (__d0), "=D" (__d1) : "a" (0), "0" (sizeof (fd_set) / sizeof (__fd_mask)), "1" (&((&writefd)->__fds_bits)[0]) : "memory"); } while (0);
   do { int __d0, __d1; __asm__ __volatile__ ("cld; rep; " "stosl" : "=c" (__d0), "=D" (__d1) : "a" (0), "0" (sizeof (fd_set) / sizeof (__fd_mask)), "1" (&((&readfd)->__fds_bits)[0]) : "memory"); } while (0);
  }

  /* We'll just empty out the pipe if required. We don't do
		any thing with the data, since the pipe's purpose is purely to
		wake up the select() above. */
  if (((((&readfd)->__fds_bits)[__extension__ ({ long int __d = (ses.signal_pipe[0]); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] & ((__fd_mask) 1 << ((ses.signal_pipe[0]) % (8 * (int) sizeof (__fd_mask))))) != 0)) {
   char x;
   while (read(ses.signal_pipe[0], &x, 1) > 0) {}
  }

  /* check for auth timeout, rekeying required etc */
  checktimeouts();

  /* process session socket's incoming data */
  if (ses.sock_in != -1) {
   if (((((&readfd)->__fds_bits)[__extension__ ({ long int __d = (ses.sock_in); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] & ((__fd_mask) 1 << ((ses.sock_in) % (8 * (int) sizeof (__fd_mask))))) != 0)) {
    if (!ses.remoteident) {
     /* blocking read of the version string */
     read_session_identification();
    } else {
     read_packet();
    }
   }

   /* Process the decrypted packet. After this, the read buffer
			 * will be ready for a new packet */
   if (ses.payload != ((void *)0)) {
    process_packet();
   }
  }

  /* if required, flush out any queued reply packets that
		were being held up during a KEX */
  maybe_flush_reply_queue();

  /* process pipes etc for the channels, ses.dataallowed == 0
		 * during rekeying ) */
  channelio(&readfd, &writefd);

  /* process session socket's outgoing data */
  if (ses.sock_out != -1) {
   if (!isempty(&ses.writequeue)) {
    write_packet();
   }
  }


  if (loophandler) {
   loophandler();
  }

 } /* for(;;) */

 /* Not reached */
}

# 325 "common-session.c"
static int ident_readln(int fd, char* buf, int count) {

 char in;
 int pos = 0;
 int num = 0;
 fd_set fds;
 struct timeval timeout;



 if (count < 1) {
  return -1;
 }

 do { int __d0, __d1; __asm__ __volatile__ ("cld; rep; " "stosl" : "=c" (__d0), "=D" (__d1) : "a" (0), "0" (sizeof (fd_set) / sizeof (__fd_mask)), "1" (&((&fds)->__fds_bits)[0]) : "memory"); } while (0);

 /* select since it's a non-blocking fd */

 /* leave space to null-terminate */
 while (pos < count-1) {

  ((void) (((&fds)->__fds_bits)[__extension__ ({ long int __d = (fd); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] |= ((__fd_mask) 1 << ((fd) % (8 * (int) sizeof (__fd_mask))))));

  timeout.tv_sec = 1;
  timeout.tv_usec = 0;
  if (select(fd+1, &fds, ((void *)0), ((void *)0), &timeout) < 0) {
   if ((*__errno_location ()) == 4 /* Interrupted system call */) {
    continue;
   }
  
   return -1;
  }

  checktimeouts();

  /* Have to go one byte at a time, since we don't want to read past
		 * the end, and have to somehow shove bytes back into the normal
		 * packet reader */
  if (((((&fds)->__fds_bits)[__extension__ ({ long int __d = (fd); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] & ((__fd_mask) 1 << ((fd) % (8 * (int) sizeof (__fd_mask))))) != 0)) {
   num = read(fd, &in, 1);
   /* a "\n" is a newline, "\r" we want to read in and keep going
			 * so that it won't be read as part of the next line */
   if (num < 0) {
    /* error */
    if ((*__errno_location ()) == 4 /* Interrupted system call */) {
     continue; /* not a real error */
    }
   
    return -1;
   }
   if (num == 0) {
    /* EOF */
   
    return -1;
   }
   if (in == '\n') {
    /* end of ident string */
    break;
   }
   /* we don't want to include '\r's */
   if (in != '\r') {
    buf[pos] = in;
    pos++;
   }
  }
 }

 buf[pos] = '\0';

 return pos+1;
}

# 30 "/usr/include/i386-linux-gnu/bits/fcntl2.h"
extern int __open_2 (const char *__path, int __oflag) __asm__ ("" "__open64_2");

# 35 "/usr/include/i386-linux-gnu/bits/fcntl2.h"
extern void __open_too_many_args (void);

# 37 "/usr/include/i386-linux-gnu/bits/fcntl2.h"
extern void __open_missing_mode (void);

# 40 "/usr/include/i386-linux-gnu/bits/fcntl2.h"
extern __inline int
open (const char *__path, int __oflag, ...)
{
  if (__builtin_va_arg_pack_len () > 1)
    __open_too_many_args ();

  if (__builtin_constant_p (__oflag))
    {
      if ((((__oflag) & 0100 /* Not fcntl.  */) != 0 || ((__oflag) & 020200000) == 020200000) && __builtin_va_arg_pack_len () < 1)
 {
   __open_missing_mode ();
   return __open_2 (__path, __oflag);
 }
      return __open_alias (__path, __oflag, __builtin_va_arg_pack ());
    }

  if (__builtin_va_arg_pack_len () < 1)
    return __open_2 (__path, __oflag);

  return __open_alias (__path, __oflag, __builtin_va_arg_pack ());
}

# 353 "/usr/include/unistd.h"
extern int close (int __fd);

# 251 "./libtomcrypt/src/headers/tomcrypt_hash.h"
int sha1_process(hash_state * md, const unsigned char *in, unsigned long inlen);

# 52 "dbutil.h"
void dropbear_log(int priority, const char* format, ...);

# 53 "dbrandom.c"
static int
process_file(hash_state *hs, const char *filename,
  unsigned int len, int prngd)
{
 static int already_blocked = 0;
 int readfd;
 unsigned int readcount;
 int ret = -1;
# 69 "dbrandom.c"
 {
  readfd = open(filename, 00);
 }

 if (readfd < 0) {
  goto out;
 }

 readcount = 0;
 while (len == 0 || readcount < len)
 {
  int readlen, wantread;
  unsigned char readbuf[4096];
  if (!already_blocked && !prngd)
  {
   int res;
   struct timeval timeout;
   fd_set read_fds;

    timeout.tv_sec = 2;
    timeout.tv_usec = 0;

   do { int __d0, __d1; __asm__ __volatile__ ("cld; rep; " "stosl" : "=c" (__d0), "=D" (__d1) : "a" (0), "0" (sizeof (fd_set) / sizeof (__fd_mask)), "1" (&((&read_fds)->__fds_bits)[0]) : "memory"); } while (0);
   ((void) (((&read_fds)->__fds_bits)[__extension__ ({ long int __d = (readfd); (__builtin_constant_p (__d) ? (0 <= __d && __d < 1024 ? (__d / (8 * (int) sizeof (__fd_mask))) : __fdelt_warn (__d)) : __fdelt_chk (__d)); })] |= ((__fd_mask) 1 << ((readfd) % (8 * (int) sizeof (__fd_mask))))));
   res = select(readfd + 1, &read_fds, ((void *)0), ((void *)0), &timeout);
   if (res == 0)
   {
    dropbear_log(4 /* warning conditions */, "Warning: Reading the randomness source '%s' seems to have blocked.\nYou may need to find a better entropy source.", filename);
    already_blocked = 1;
   }
  }

  if (len == 0)
  {
   wantread = sizeof(readbuf);
  }
  else
  {
   wantread = (((sizeof(readbuf))<(len-readcount))?(sizeof(readbuf)):(len-readcount));
  }
# 123 "dbrandom.c"
  readlen = read(readfd, readbuf, wantread);
  if (readlen <= 0) {
   if (readlen < 0 && (*__errno_location ()) == 4 /* Interrupted system call */) {
    continue;
   }
   if (readlen == 0 && len == 0)
   {
    /* whole file was read as requested */
    break;
   }
   goto out;
  }
  sha1_process(hs, readbuf, readlen);
  readcount += readlen;
 }
 ret = 0;
out:
 close(readfd);
 return ret;
}

