unsigned int __builtin_bswap32 (unsigned int);
void * __builtin___memcpy_chk (void *, const void *, unsigned int, unsigned int);
unsigned int __builtin_object_size (const void *, int);
void * __builtin___memset_chk (void *, int, unsigned int, unsigned int);

# 139 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __time_t;

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 75 "/usr/include/time.h"
typedef __time_t time_t;

# 28 "/usr/include/i386-linux-gnu/bits/sockaddr.h"
typedef unsigned short int sa_family_t;

# 30 "/usr/include/netinet/in.h"
typedef uint32_t in_addr_t;

# 31 "/usr/include/netinet/in.h"
struct in_addr
  {
    in_addr_t s_addr;
  };

# 209 "/usr/include/netinet/in.h"
struct in6_addr
  {
    union
      {
 uint8_t __u6_addr8[16];

 uint16_t __u6_addr16[8];
 uint32_t __u6_addr32[4];

      } __in6_u;





  };

# 625 "../src/common/compat.h"
void set_uint16(void *cp, uint16_t v);

# 56 "../src/common/util.h"
void tor_assertion_failed_(const char *fname, unsigned int line,
                           const char *func, const char *expr);

# 25 "../src/common/address.h"
typedef struct tor_addr_t
{
  sa_family_t family;
  union {
    uint32_t dummy_; /* This field is here so we have something to initialize
                      * with a reliable cross-platform type. */
    struct in_addr in_addr;
    struct in6_addr in6_addr;
  } addr;
} tor_addr_t;

# 9 "../src/common/compat_libevent.h"
struct event;

# 1133 "../src/or/or.h"
typedef struct buf_t buf_t;

# 1169 "../src/or/or.h"
typedef struct connection_t {
  uint32_t magic; /**< For memory debugging: must equal one of
                   * *_CONNECTION_MAGIC. */

  uint8_t state; /**< Current state of this connection. */
  unsigned int type:5; /**< What kind of connection is this? */
  unsigned int purpose:5; /**< Only used for DIR and EXIT types currently. */

  /* The next fields are all one-bit booleans. Some are only applicable to
   * connection subtypes, but we hold them here anyway, to save space.
   */
  unsigned int read_blocked_on_bw:1; /**< Boolean: should we start reading
                            * again once the bandwidth throttler allows it? */
  unsigned int write_blocked_on_bw:1; /**< Boolean: should we start writing
                             * again once the bandwidth throttler allows
                             * writes? */
  unsigned int hold_open_until_flushed:1; /**< Despite this connection's being
                                      * marked for close, do we flush it
                                      * before closing it? */
  unsigned int inbuf_reached_eof:1; /**< Boolean: did read() return 0 on this
                                     * conn? */
  /** Set to 1 when we're inside connection_flushed_some to keep us from
   * calling connection_handle_write() recursively. */
  unsigned int in_flushed_some:1;
  /** True if connection_handle_write is currently running on this connection.
   */
  unsigned int in_connection_handle_write:1;

  /* For linked connections:
   */
  unsigned int linked:1; /**< True if there is, or has been, a linked_conn. */
  /** True iff we'd like to be notified about read events from the
   * linked conn. */
  unsigned int reading_from_linked_conn:1;
  /** True iff we're willing to write to the linked conn. */
  unsigned int writing_to_linked_conn:1;
  /** True iff we're currently able to read on the linked conn, and our
   * read_event should be made active with libevent. */
  unsigned int active_on_link:1;
  /** True iff we've called connection_close_immediate() on this linked
   * connection. */
  unsigned int linked_conn_is_closed:1;

  /** CONNECT/SOCKS proxy client handshake state (for outgoing connections). */
  unsigned int proxy_state:4;

  /** Our socket; set to TOR_INVALID_SOCKET if this connection is closed,
   * or has no socket. */
  int s;
  int conn_array_index; /**< Index into the global connection array. */

  struct event *read_event; /**< Libevent event structure. */
  struct event *write_event; /**< Libevent event structure. */
  buf_t *inbuf; /**< Buffer holding data read over this connection. */
  buf_t *outbuf; /**< Buffer holding data to write over this connection. */
  size_t outbuf_flushlen; /**< How much data should we try to flush from the
                           * outbuf? */
  time_t timestamp_lastread; /**< When was the last time libevent said we could
                              * read? */
  time_t timestamp_lastwritten; /**< When was the last time libevent said we
                                 * could write? */





  time_t timestamp_created; /**< When was this connection_t created? */

  /* XXXX_IP6 make this IPv6-capable */
  int socket_family; /**< Address family of this connection's socket.  Usually
                      * AF_INET, but it can also be AF_UNIX, or in the future
                      * AF_INET6 */
  tor_addr_t addr; /**< IP of the other side of the connection; used to
                    * identify routers, along with port. */
  uint16_t port; /**< If non-zero, port on the other end
                  * of the connection. */
  uint16_t marked_for_close; /**< Should we close this conn on the next
                              * iteration of the main loop? (If true, holds
                              * the line number where this connection was
                              * marked.) */
  const char *marked_for_close_file; /**< For debugging: in which file were
                                      * we marked for close? */
  char *address; /**< FQDN (or IP) of the guy on the other end.
                  * strdup into this, because free_connection() frees it. */
  /** Another connection that's connected to this one in lieu of a socket. */
  struct connection_t *linked_conn;

  /** Unique identifier for this connection on this Tor instance. */
  uint64_t global_identifier;

  /** Bytes read since last call to control_event_conn_bandwidth_used().
   * Only used if we're configured to emit CONN_BW events. */
  uint32_t n_read_conn_bw;

  /** Bytes written since last call to control_event_conn_bandwidth_used().
   * Only used if we're configured to emit CONN_BW events. */
  uint32_t n_written_conn_bw;
} connection_t;

# 133 "../src/or/connection.h"
void connection_write_to_buf_impl_ (const char *string, size_t len, connection_t *conn, int zlib);

# 141 "../src/or/connection.h"
static inline void
connection_write_to_buf(const char *string, size_t len, connection_t *conn)
{
  connection_write_to_buf_impl_(string, len, conn, 0);
}

# 56 "../src/or/ext_orport.c"
static int
connection_write_ext_or_command(connection_t *conn,
                                uint16_t command,
                                const char *body,
                                size_t bodylen)
{
  char header[4];
  if (bodylen > (65535))
    return -1;
  set_uint16(header, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (command); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
  set_uint16(header+2, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (bodylen); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
  connection_write_to_buf(header, 4, conn);
  if (bodylen) {
    (void) ({ if (__builtin_expect(!!(!(body)), 0)) { tor_assertion_failed_(("../src/or/ext_orport.c"), 69, __func__, "body"); abort(); } });
    connection_write_to_buf(body, bodylen, conn);
  }
  return 0;
}

# 44 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}

# 47 "/usr/include/i386-linux-gnu/bits/string3.h"
extern __inline void *
 memcpy (void *__restrict __dest, const void *__restrict __src, size_t __len)

{
  return __builtin___memcpy_chk (__dest, __src, __len, __builtin_object_size (__dest, 0));
}

# 622 "../src/common/compat.h"
uint16_t get_uint16(const void *cp);

# 623 "../src/common/compat.h"
uint32_t get_uint32(const void *cp);

# 632 "../src/common/compat.h"
static inline void
set_uint8(void *cp, uint8_t v)
{
  *(uint8_t*)cp = v;
}

# 934 "../src/or/or.h"
typedef uint32_t circid_t;

# 936 "../src/or/or.h"
typedef uint16_t streamid_t;

# 1108 "../src/or/or.h"
typedef struct packed_cell_t {
  /** Next cell queued on this circuit. */
  struct { struct packed_cell_t *sqe_next; /* next element */ } next;
  char body[514]; /**< Cell as packed for network. */
  uint32_t inserted_time; /**< Time (in milliseconds since epoch, with high
                           * bits truncated) when this cell was inserted. */
} packed_cell_t;

# 1125 "../src/or/or.h"
typedef struct {
  uint8_t command; /**< The end-to-end relay command. */
  uint16_t recognized; /**< Used to tell whether cell is for us. */
  streamid_t stream_id; /**< Which stream is this cell associated with? */
  char integrity[4]; /**< Used to tell whether cell is corrupted. */
  uint16_t length; /**< How long is the payload body? */
} relay_header_t;

# 499 "../src/or/relay.c"
void
relay_header_pack(uint8_t *dest, const relay_header_t *src)
{
  set_uint8(dest, src->command);
  set_uint16(dest+1, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (src->recognized); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
  set_uint16(dest+3, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (src->stream_id); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
  memcpy(dest+5, src->integrity, 4);
  set_uint16(dest+9, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (src->length); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
}

# 512 "../src/or/relay.c"
void
relay_header_unpack(relay_header_t *dest, const uint8_t *src)
{
  dest->command = (*(const uint8_t*)(src));
  dest->recognized = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (get_uint16(src+1)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  dest->stream_id = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (get_uint16(src+3)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  memcpy(dest->integrity, src+5, 4);
  dest->length = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (get_uint16(src+9)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 2580 "../src/or/relay.c"
circid_t
packed_cell_get_circid(const packed_cell_t *cell, int wide_circ_ids)
{
  if (wide_circ_ids) {
    return __bswap_32 (get_uint32(cell->body));
  } else {
    return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (get_uint16(cell->body)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  }
}

# 22 "/usr/include/i386-linux-gnu/bits/string3.h"
extern void __warn_memset_zero_len (void);

# 75 "/usr/include/i386-linux-gnu/bits/string3.h"
extern __inline void *
 memset (void *__dest, int __ch, size_t __len)
{
  if (__builtin_constant_p (__len) && __len == 0
      && (!__builtin_constant_p (__ch) || __ch != 0))
    {
      __warn_memset_zero_len ();
      return __dest;
    }
  return __builtin___memset_chk (__dest, __ch, __len, __builtin_object_size (__dest, 0));
}

# 626 "../src/common/compat.h"
void set_uint32(void *cp, uint32_t v);

# 18 "../src/common/di_ops.h"
int tor_memeq(const void *a, const void *b, size_t sz);

# 229 "../src/common/util.h"
int tor_digest_is_zero(const char *digest);

# 37 "../src/common/address.h"
typedef struct tor_addr_port_t
{
  tor_addr_t addr;
  uint16_t port;
} tor_addr_port_t;

# 57 "../src/common/address.h"
void tor_addr_make_unspec(tor_addr_t *a);

# 87 "../src/common/address.h"
static inline uint32_t
tor_addr_to_ipv4n(const tor_addr_t *a)
{
  return a->family == 2 /* IP protocol family.  */ ? a->addr.in_addr.s_addr : 0;
}

# 110 "../src/common/address.h"
static inline sa_family_t
tor_addr_family(const tor_addr_t *a)
{
  return a->family;
}

# 196 "../src/common/address.h"
void tor_addr_from_ipv4n(tor_addr_t *dest, uint32_t v4addr);

# 201 "../src/common/address.h"
void tor_addr_from_ipv6_bytes(tor_addr_t *dest, const char *bytes);

# 1081 "../src/or/or.h"
typedef struct cell_t {
  circid_t circ_id; /**< Circuit which received the cell. */
  uint8_t command; /**< Type of the cell: one of CELL_PADDING, CELL_CREATE,
                    * CELL_DESTROY, etc */
  uint8_t payload[509]; /**< Cell body. */
} cell_t;

# 57 "../src/or/onion.h"
typedef struct create_cell_t {
  /** The cell command. One of CREATE{,_FAST,2} */
  uint8_t cell_type;
  /** One of the ONION_HANDSHAKE_TYPE_* values */
  uint16_t handshake_type;
  /** The number of bytes used in <b>onionskin</b>. */
  uint16_t handshake_len;
  /** The client-side message for the circuit creation handshake. */
  uint8_t onionskin[509 - 4];
} create_cell_t;

# 69 "../src/or/onion.h"
typedef struct created_cell_t {
  /** The cell command. One of CREATED{,_FAST,2} */
  uint8_t cell_type;
  /** The number of bytes used in <b>reply</b>. */
  uint16_t handshake_len;
  /** The server-side message for the circuit creation handshake. */
  uint8_t reply[509 - 2];
} created_cell_t;

# 79 "../src/or/onion.h"
typedef struct extend_cell_t {
  /** One of RELAY_EXTEND or RELAY_EXTEND2 */
  uint8_t cell_type;
  /** An IPv4 address and port for the node we're connecting to. */
  tor_addr_port_t orport_ipv4;
  /** An IPv6 address and port for the node we're connecting to. Not currently
   * used. */
  tor_addr_port_t orport_ipv6;
  /** Identity fingerprint of the node we're conecting to.*/
  uint8_t node_id[20];
  /** The "create cell" embedded in this extend cell. Note that unlike the
   * create cells we generate ourself, this once can have a handshake type we
   * don't recognize. */
  create_cell_t create_cell;
} extend_cell_t;

# 96 "../src/or/onion.h"
typedef struct extended_cell_t {
  /** One of RELAY_EXTENDED or RELAY_EXTENDED2. */
  uint8_t cell_type;
  /** The "created cell" embedded in this extended cell. */
  created_cell_t created_cell;
} extended_cell_t;

# 612 "../src/or/onion.c"
static int
check_create_cell(const create_cell_t *cell, int unknown_ok)
{
  switch (cell->cell_type) {
  case 1:
    if (cell->handshake_type != 0x0000 &&
        cell->handshake_type != 0x0002)
      return -1;
    break;
  case 5:
    if (cell->handshake_type != 0x0001)
      return -1;
    break;
  case 10:
    break;
  default:
    return -1;
  }

  switch (cell->handshake_type) {
  case 0x0000:
    if (cell->handshake_len != (42 + 16 + (1024/8)))
      return -1;
    break;
  case 0x0001:
    if (cell->handshake_len != 20)
      return -1;
    break;

  case 0x0002:
    if (cell->handshake_len != 84)
      return -1;
    break;

  default:
    if (! unknown_ok)
      return -1;
  }

  return 0;
}

# 657 "../src/or/onion.c"
void
create_cell_init(create_cell_t *cell_out, uint8_t cell_type,
                 uint16_t handshake_type, uint16_t handshake_len,
                 const uint8_t *onionskin)
{
  memset(cell_out, 0, sizeof(*cell_out));

  cell_out->cell_type = cell_type;
  cell_out->handshake_type = handshake_type;
  cell_out->handshake_len = handshake_len;
  memcpy(cell_out->onionskin, onionskin, handshake_len);
}

# 677 "../src/or/onion.c"
static int
parse_create2_payload(create_cell_t *cell_out, const uint8_t *p, size_t p_len)
{
  uint16_t handshake_type, handshake_len;

  if (p_len < 4)
    return -1;

  handshake_type = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (get_uint16(p)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  handshake_len = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (get_uint16(p+2)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

  if (handshake_len > 509 - 4 || handshake_len > p_len - 4)
    return -1;
  if (handshake_type == 0x0001)
    return -1;

  create_cell_init(cell_out, 10, handshake_type, handshake_len,
                   p+4);
  return 0;
}

# 739 "../src/or/onion.c"
static int
check_created_cell(const created_cell_t *cell)
{
  switch (cell->cell_type) {
  case 2:
    if (cell->handshake_len != ((1024/8)+20) &&
        cell->handshake_len != 64)
      return -1;
    break;
  case 6:
    if (cell->handshake_len != (20*2))
      return -1;
    break;
  case 11:
    if (cell->handshake_len > (509 -(1+2+2+4+2))-2)
      return -1;
    break;
  }

  return 0;
}

# 763 "../src/or/onion.c"
int
created_cell_parse(created_cell_t *cell_out, const cell_t *cell_in)
{
  memset(cell_out, 0, sizeof(*cell_out));

  switch (cell_in->command) {
  case 2:
    cell_out->cell_type = 2;
    cell_out->handshake_len = ((1024/8)+20);
    memcpy(cell_out->reply, cell_in->payload, ((1024/8)+20));
    break;
  case 6:
    cell_out->cell_type = 6;
    cell_out->handshake_len = (20*2);
    memcpy(cell_out->reply, cell_in->payload, (20*2));
    break;
  case 11:
    {
      const uint8_t *p = cell_in->payload;
      cell_out->cell_type = 11;
      cell_out->handshake_len = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (get_uint16(p)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
      if (cell_out->handshake_len > 509 - 2)
        return -1;
      memcpy(cell_out->reply, p+2, cell_out->handshake_len);
      break;
    }
  }

  return check_created_cell(cell_out);
}

# 795 "../src/or/onion.c"
static int
check_extend_cell(const extend_cell_t *cell)
{
  if (tor_digest_is_zero((const char*)cell->node_id))
    return -1;
  /* We don't currently allow EXTEND2 cells without an IPv4 address */
  if (tor_addr_family(&cell->orport_ipv4.addr) == 0 /* Unspecified.  */)
    return -1;
  if (cell->create_cell.cell_type == 1) {
    if (cell->cell_type != 6)
      return -1;
  } else if (cell->create_cell.cell_type == 10) {
    if (cell->cell_type != 14 &&
        cell->cell_type != 6)
      return -1;
  } else {
    /* In particular, no CREATE_FAST cells are allowed */
    return -1;
  }
  if (cell->create_cell.handshake_type == 0x0001)
    return -1;

  return check_create_cell(&cell->create_cell, 1);
}

# 831 "../src/or/onion.c"
int
extend_cell_parse(extend_cell_t *cell_out, const uint8_t command,
                  const uint8_t *payload, size_t payload_length)
{
  const uint8_t *eop;

  memset(cell_out, 0, sizeof(*cell_out));
  if (payload_length > (509 -(1+2+2+4+2)))
    return -1;
  eop = payload + payload_length;

  switch (command) {
  case 6:
    {
      if (payload_length != 6 + (42 + 16 + (1024/8)) + 20)
        return -1;

      cell_out->cell_type = 6;
      tor_addr_from_ipv4n(&cell_out->orport_ipv4.addr, get_uint32(payload));
      cell_out->orport_ipv4.port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (get_uint16(payload+4)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
      tor_addr_make_unspec(&cell_out->orport_ipv6.addr);
      if (tor_memeq(payload + 6, "ntorNTORntorNTOR", 16)) {
        cell_out->create_cell.cell_type = 10;
        cell_out->create_cell.handshake_type = 0x0002;
        cell_out->create_cell.handshake_len = 84;
        memcpy(cell_out->create_cell.onionskin, payload + 22,
               84);
      } else {
        cell_out->create_cell.cell_type = 1;
        cell_out->create_cell.handshake_type = 0x0000;
        cell_out->create_cell.handshake_len = (42 + 16 + (1024/8));
        memcpy(cell_out->create_cell.onionskin, payload + 6,
               (42 + 16 + (1024/8)));
      }
      memcpy(cell_out->node_id, payload + 6 + (42 + 16 + (1024/8)),
             20);
      break;
    }
  case 14:
    {
      uint8_t n_specs, spectype, speclen;
      int i;
      int found_ipv4 = 0, found_ipv6 = 0, found_id = 0;
      tor_addr_make_unspec(&cell_out->orport_ipv4.addr);
      tor_addr_make_unspec(&cell_out->orport_ipv6.addr);

      if (payload_length == 0)
        return -1;

      cell_out->cell_type = 14;
      n_specs = *payload++;
      /* Parse the specifiers. We'll only take the first IPv4 and first IPv6
       * address, and the node ID, and ignore everything else */
      for (i = 0; i < n_specs; ++i) {
        if (eop - payload < 2)
          return -1;
        spectype = payload[0];
        speclen = payload[1];
        payload += 2;
        if (eop - payload < speclen)
          return -1;
        switch (spectype) {
        case 0:
          if (speclen != 6)
            return -1;
          if (!found_ipv4) {
            tor_addr_from_ipv4n(&cell_out->orport_ipv4.addr,
                                get_uint32(payload));
            cell_out->orport_ipv4.port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (get_uint16(payload+4)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
            found_ipv4 = 1;
          }
          break;
        case 1:
          if (speclen != 18)
            return -1;
          if (!found_ipv6) {
            tor_addr_from_ipv6_bytes(&cell_out->orport_ipv6.addr,
                                     (const char*)payload);
            cell_out->orport_ipv6.port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (get_uint16(payload+16)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
            found_ipv6 = 1;
          }
          break;
        case 2:
          if (speclen != 20)
            return -1;
          if (found_id)
            return -1;
          memcpy(cell_out->node_id, payload, 20);
          found_id = 1;
          break;
        }
        payload += speclen;
      }
      if (!found_id || !found_ipv4)
        return -1;
      if (parse_create2_payload(&cell_out->create_cell,payload,eop-payload)<0)
        return -1;
      break;
    }
  default:
    return -1;
  }

  return check_extend_cell(cell_out);
}

# 938 "../src/or/onion.c"
static int
check_extended_cell(const extended_cell_t *cell)
{
  if (cell->created_cell.cell_type == 2) {
    if (cell->cell_type != 7)
      return -1;
  } else if (cell->created_cell.cell_type == 11) {
    if (cell->cell_type != 15)
      return -1;
  } else {
    return -1;
  }

  return check_created_cell(&cell->created_cell);
}

# 957 "../src/or/onion.c"
int
extended_cell_parse(extended_cell_t *cell_out,
                    const uint8_t command, const uint8_t *payload,
                    size_t payload_len)
{
  memset(cell_out, 0, sizeof(*cell_out));
  if (payload_len > (509 -(1+2+2+4+2)))
    return -1;

  switch (command) {
  case 7:
    if (payload_len != ((1024/8)+20))
      return -1;
    cell_out->cell_type = 7;
    cell_out->created_cell.cell_type = 2;
    cell_out->created_cell.handshake_len = ((1024/8)+20);
    memcpy(cell_out->created_cell.reply, payload, ((1024/8)+20));
    break;
  case 15:
    {
      cell_out->cell_type = 15;
      cell_out->created_cell.cell_type = 11;
      cell_out->created_cell.handshake_len = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (get_uint16(payload)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
      if (cell_out->created_cell.handshake_len > (509 -(1+2+2+4+2)) - 2 ||
          cell_out->created_cell.handshake_len > payload_len - 2)
        return -1;
      memcpy(cell_out->created_cell.reply, payload+2,
             cell_out->created_cell.handshake_len);
    }
    break;
  default:
    return -1;
  }

  return check_extended_cell(cell_out);
}

# 997 "../src/or/onion.c"
static int
create_cell_format_impl(cell_t *cell_out, const create_cell_t *cell_in,
                        int relayed)
{
  uint8_t *p;
  size_t space;
  if (check_create_cell(cell_in, relayed) < 0)
    return -1;

  memset(cell_out->payload, 0, sizeof(cell_out->payload));
  cell_out->command = cell_in->cell_type;

  p = cell_out->payload;
  space = sizeof(cell_out->payload);

  switch (cell_in->cell_type) {
  case 1:
    if (cell_in->handshake_type == 0x0002) {
      memcpy(p, "ntorNTORntorNTOR", 16);
      p += 16;
      space -= 16;
    }
    /* Fall through */
  case 5:
    (void) ({ if (__builtin_expect(!!(!(cell_in->handshake_len <= space)), 0)) { tor_assertion_failed_(("../src/or/onion.c"), 1021, __func__, "cell_in->handshake_len <= space"); abort(); } });
    memcpy(p, cell_in->onionskin, cell_in->handshake_len);
    break;
  case 10:
    (void) ({ if (__builtin_expect(!!(!(cell_in->handshake_len <= sizeof(cell_out->payload)-4)), 0)) { tor_assertion_failed_(("../src/or/onion.c"), 1025, __func__, "cell_in->handshake_len <= sizeof(cell_out->payload)-4"); abort(); } });
    set_uint16(cell_out->payload, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (cell_in->handshake_type); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
    set_uint16(cell_out->payload+2, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (cell_in->handshake_len); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
    memcpy(cell_out->payload + 4, cell_in->onionskin, cell_in->handshake_len);
    break;
  default:
    return -1;
  }

  return 0;
}

# 1052 "../src/or/onion.c"
int
created_cell_format(cell_t *cell_out, const created_cell_t *cell_in)
{
  if (check_created_cell(cell_in) < 0)
    return -1;

  memset(cell_out->payload, 0, sizeof(cell_out->payload));
  cell_out->command = cell_in->cell_type;

  switch (cell_in->cell_type) {
  case 2:
  case 6:
    (void) ({ if (__builtin_expect(!!(!(cell_in->handshake_len <= sizeof(cell_out->payload))), 0)) { tor_assertion_failed_(("../src/or/onion.c"), 1064, __func__, "cell_in->handshake_len <= sizeof(cell_out->payload)"); abort(); } });
    memcpy(cell_out->payload, cell_in->reply, cell_in->handshake_len);
    break;
  case 11:
    (void) ({ if (__builtin_expect(!!(!(cell_in->handshake_len <= sizeof(cell_out->payload)-2)), 0)) { tor_assertion_failed_(("../src/or/onion.c"), 1068, __func__, "cell_in->handshake_len <= sizeof(cell_out->payload)-2"); abort(); } });
    set_uint16(cell_out->payload, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (cell_in->handshake_len); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
    memcpy(cell_out->payload + 2, cell_in->reply, cell_in->handshake_len);
    break;
  default:
    return -1;
  }
  return 0;
}

# 1082 "../src/or/onion.c"
int
extend_cell_format(uint8_t *command_out, uint16_t *len_out,
                   uint8_t *payload_out, const extend_cell_t *cell_in)
{
  uint8_t *p, *eop;
  if (check_extend_cell(cell_in) < 0)
    return -1;

  p = payload_out;
  eop = payload_out + (509 -(1+2+2+4+2));

  memset(p, 0, (509 -(1+2+2+4+2)));

  switch (cell_in->cell_type) {
  case 6:
    {
      *command_out = 6;
      *len_out = 6 + (42 + 16 + (1024/8)) + 20;
      set_uint32(p, tor_addr_to_ipv4n(&cell_in->orport_ipv4.addr));
      set_uint16(p+4, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (cell_in->orport_ipv4.port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
      if (cell_in->create_cell.handshake_type == 0x0002) {
        memcpy(p+6, "ntorNTORntorNTOR", 16);
        memcpy(p+22, cell_in->create_cell.onionskin, 84);
      } else {
        memcpy(p+6, cell_in->create_cell.onionskin,
               (42 + 16 + (1024/8)));
      }
      memcpy(p+6+(42 + 16 + (1024/8)), cell_in->node_id, 20);
    }
    break;
  case 14:
    {
      uint8_t n = 2;
      *command_out = 14;

      *p++ = n; /* 2 identifiers */
      *p++ = 0; /* First is IPV4. */
      *p++ = 6; /* It's 6 bytes long. */
      set_uint32(p, tor_addr_to_ipv4n(&cell_in->orport_ipv4.addr));
      set_uint16(p+4, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (cell_in->orport_ipv4.port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
      p += 6;
      *p++ = 2; /* Next is an identity digest. */
      *p++ = 20; /* It's 20 bytes long */
      memcpy(p, cell_in->node_id, 20);
      p += 20;

      /* Now we can send the handshake */
      set_uint16(p, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (cell_in->create_cell.handshake_type); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
      set_uint16(p+2, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (cell_in->create_cell.handshake_len); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
      p += 4;

      if (cell_in->create_cell.handshake_len > eop - p)
        return -1;

      memcpy(p, cell_in->create_cell.onionskin,
             cell_in->create_cell.handshake_len);

      p += cell_in->create_cell.handshake_len;
      *len_out = p - payload_out;
    }
    break;
  default:
    return -1;
  }

  return 0;
}

# 1154 "../src/or/onion.c"
int
extended_cell_format(uint8_t *command_out, uint16_t *len_out,
                     uint8_t *payload_out, const extended_cell_t *cell_in)
{
  uint8_t *p;
  if (check_extended_cell(cell_in) < 0)
    return -1;

  p = payload_out;
  memset(p, 0, (509 -(1+2+2+4+2)));

  switch (cell_in->cell_type) {
  case 7:
    {
      *command_out = 7;
      *len_out = ((1024/8)+20);
      memcpy(payload_out, cell_in->created_cell.reply,
             ((1024/8)+20));
    }
    break;
  case 15:
    {
      *command_out = 15;
      *len_out = 2 + cell_in->created_cell.handshake_len;
      set_uint16(payload_out, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (cell_in->created_cell.handshake_len); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
      if (2+cell_in->created_cell.handshake_len > (509 -(1+2+2+4+2)))
        return -1;
      memcpy(payload_out+2, cell_in->created_cell.reply,
             cell_in->created_cell.handshake_len);
    }
    break;
  default:
    return -1;
  }

  return 0;
}

# 66 "/usr/include/openssl/stack.h"
typedef struct stack_st {
    int num;
    char **data;
    int sorted;
    int num_alloc;
    int (*comp) (const void *, const void *);
} _STACK;

# 83 "/usr/include/openssl/ossl_typ.h"
typedef struct asn1_string_st ASN1_INTEGER;

# 84 "/usr/include/openssl/ossl_typ.h"
typedef struct asn1_string_st ASN1_ENUMERATED;

# 85 "/usr/include/openssl/ossl_typ.h"
typedef struct asn1_string_st ASN1_BIT_STRING;

# 86 "/usr/include/openssl/ossl_typ.h"
typedef struct asn1_string_st ASN1_OCTET_STRING;

# 87 "/usr/include/openssl/ossl_typ.h"
typedef struct asn1_string_st ASN1_PRINTABLESTRING;

# 88 "/usr/include/openssl/ossl_typ.h"
typedef struct asn1_string_st ASN1_T61STRING;

# 89 "/usr/include/openssl/ossl_typ.h"
typedef struct asn1_string_st ASN1_IA5STRING;

# 90 "/usr/include/openssl/ossl_typ.h"
typedef struct asn1_string_st ASN1_GENERALSTRING;

# 91 "/usr/include/openssl/ossl_typ.h"
typedef struct asn1_string_st ASN1_UNIVERSALSTRING;

# 92 "/usr/include/openssl/ossl_typ.h"
typedef struct asn1_string_st ASN1_BMPSTRING;

# 93 "/usr/include/openssl/ossl_typ.h"
typedef struct asn1_string_st ASN1_UTCTIME;

# 94 "/usr/include/openssl/ossl_typ.h"
typedef struct asn1_string_st ASN1_TIME;

# 95 "/usr/include/openssl/ossl_typ.h"
typedef struct asn1_string_st ASN1_GENERALIZEDTIME;

# 96 "/usr/include/openssl/ossl_typ.h"
typedef struct asn1_string_st ASN1_VISIBLESTRING;

# 97 "/usr/include/openssl/ossl_typ.h"
typedef struct asn1_string_st ASN1_UTF8STRING;

# 98 "/usr/include/openssl/ossl_typ.h"
typedef struct asn1_string_st ASN1_STRING;

# 99 "/usr/include/openssl/ossl_typ.h"
typedef int ASN1_BOOLEAN;

# 118 "/usr/include/openssl/ossl_typ.h"
typedef struct bignum_st BIGNUM;

# 119 "/usr/include/openssl/ossl_typ.h"
typedef struct bignum_ctx BN_CTX;

# 120 "/usr/include/openssl/ossl_typ.h"
typedef struct bn_blinding_st BN_BLINDING;

# 121 "/usr/include/openssl/ossl_typ.h"
typedef struct bn_mont_ctx_st BN_MONT_CTX;

# 123 "/usr/include/openssl/ossl_typ.h"
typedef struct bn_gencb_st BN_GENCB;

# 125 "/usr/include/openssl/ossl_typ.h"
typedef struct buf_mem_st BUF_MEM;

# 127 "/usr/include/openssl/ossl_typ.h"
typedef struct evp_cipher_st EVP_CIPHER;

# 128 "/usr/include/openssl/ossl_typ.h"
typedef struct evp_cipher_ctx_st EVP_CIPHER_CTX;

# 129 "/usr/include/openssl/ossl_typ.h"
typedef struct env_md_st EVP_MD;

# 130 "/usr/include/openssl/ossl_typ.h"
typedef struct env_md_ctx_st EVP_MD_CTX;

# 131 "/usr/include/openssl/ossl_typ.h"
typedef struct evp_pkey_st EVP_PKEY;

# 133 "/usr/include/openssl/ossl_typ.h"
typedef struct evp_pkey_asn1_method_st EVP_PKEY_ASN1_METHOD;

# 136 "/usr/include/openssl/ossl_typ.h"
typedef struct evp_pkey_ctx_st EVP_PKEY_CTX;

# 138 "/usr/include/openssl/ossl_typ.h"
typedef struct dh_st DH;

# 139 "/usr/include/openssl/ossl_typ.h"
typedef struct dh_method DH_METHOD;

# 141 "/usr/include/openssl/ossl_typ.h"
typedef struct dsa_st DSA;

# 142 "/usr/include/openssl/ossl_typ.h"
typedef struct dsa_method DSA_METHOD;

# 144 "/usr/include/openssl/ossl_typ.h"
typedef struct rsa_st RSA;

# 145 "/usr/include/openssl/ossl_typ.h"
typedef struct rsa_meth_st RSA_METHOD;

# 152 "/usr/include/openssl/ossl_typ.h"
typedef struct x509_st X509;

# 153 "/usr/include/openssl/ossl_typ.h"
typedef struct X509_algor_st X509_ALGOR;

# 154 "/usr/include/openssl/ossl_typ.h"
typedef struct X509_crl_st X509_CRL;

# 155 "/usr/include/openssl/ossl_typ.h"
typedef struct x509_crl_method_st X509_CRL_METHOD;

# 157 "/usr/include/openssl/ossl_typ.h"
typedef struct X509_name_st X509_NAME;

# 158 "/usr/include/openssl/ossl_typ.h"
typedef struct X509_pubkey_st X509_PUBKEY;

# 159 "/usr/include/openssl/ossl_typ.h"
typedef struct x509_store_st X509_STORE;

# 160 "/usr/include/openssl/ossl_typ.h"
typedef struct x509_store_ctx_st X509_STORE_CTX;

# 175 "/usr/include/openssl/ossl_typ.h"
typedef struct engine_st ENGINE;

# 176 "/usr/include/openssl/ossl_typ.h"
typedef struct ssl_st SSL;

# 177 "/usr/include/openssl/ossl_typ.h"
typedef struct ssl_ctx_st SSL_CTX;

# 181 "/usr/include/openssl/ossl_typ.h"
typedef struct X509_POLICY_TREE_st X509_POLICY_TREE;

# 182 "/usr/include/openssl/ossl_typ.h"
typedef struct X509_POLICY_CACHE_st X509_POLICY_CACHE;

# 184 "/usr/include/openssl/ossl_typ.h"
typedef struct AUTHORITY_KEYID_st AUTHORITY_KEYID;

# 186 "/usr/include/openssl/ossl_typ.h"
typedef struct ISSUING_DIST_POINT_st ISSUING_DIST_POINT;

# 187 "/usr/include/openssl/ossl_typ.h"
typedef struct NAME_CONSTRAINTS_st NAME_CONSTRAINTS;

# 193 "/usr/include/openssl/ossl_typ.h"
typedef struct crypto_ex_data_st CRYPTO_EX_DATA;

# 292 "/usr/include/openssl/crypto.h"
struct crypto_ex_data_st {
    struct stack_st_void *sk;
    /* gcc is screwing up this data structure :-( */
    int dummy;
};

# 297 "/usr/include/openssl/crypto.h"
struct stack_st_void { _STACK stack; };

# 15 "/usr/include/openssl/comp.h"
typedef struct comp_ctx_st COMP_CTX;

# 17 "/usr/include/openssl/comp.h"
typedef struct comp_method_st {
    int type; /* NID for compression library */
    const char *name; /* A text string to identify the library */
    int (*init) (COMP_CTX *ctx);
    void (*finish) (COMP_CTX *ctx);
    int (*compress) (COMP_CTX *ctx,
                     unsigned char *out, unsigned int olen,
                     unsigned char *in, unsigned int ilen);
    int (*expand) (COMP_CTX *ctx,
                   unsigned char *out, unsigned int olen,
                   unsigned char *in, unsigned int ilen);
    /*
     * The following two do NOTHING, but are kept for backward compatibility
     */
    long (*ctrl) (void);
    long (*callback_ctrl) (void);
} COMP_METHOD;

# 35 "/usr/include/openssl/comp.h"
struct comp_ctx_st {
    COMP_METHOD *meth;
    unsigned long compress_in;
    unsigned long compress_out;
    unsigned long expand_in;
    unsigned long expand_out;
    CRYPTO_EX_DATA ex_data;
};

# 237 "/usr/include/openssl/bio.h"
typedef struct bio_st BIO;

# 308 "/usr/include/openssl/bio.h"
typedef void bio_info_cb (struct bio_st *, int, const char *, int, long,
                          long);

# 311 "/usr/include/openssl/bio.h"
typedef struct bio_method_st {
    int type;
    const char *name;
    int (*bwrite) (BIO *, const char *, int);
    int (*bread) (BIO *, char *, int);
    int (*bputs) (BIO *, const char *);
    int (*bgets) (BIO *, char *, int);
    long (*ctrl) (BIO *, int, long, void *);
    int (*create) (BIO *);
    int (*destroy) (BIO *);
    long (*callback_ctrl) (BIO *, int, bio_info_cb *);
} BIO_METHOD;

# 324 "/usr/include/openssl/bio.h"
struct bio_st {
    BIO_METHOD *method;
    /* bio, mode, argp, argi, argl, ret */
    long (*callback) (struct bio_st *, int, const char *, int, long, long);
    char *cb_arg; /* first argument for the callback */
    int init;
    int shutdown;
    int flags; /* extra storage */
    int retry_reason;
    int num;
    void *ptr;
    struct bio_st *next_bio; /* used by filter BIOs */
    struct bio_st *prev_bio; /* used by filter BIOs */
    int references;
    unsigned long num_read;
    unsigned long num_write;
    CRYPTO_EX_DATA ex_data;
};

# 77 "/usr/include/openssl/buffer.h"
struct buf_mem_st {
    size_t length; /* current number of bytes */
    char *data;
    size_t max; /* size of buffer */
};

# 331 "/usr/include/openssl/bn.h"
struct bignum_st {
    unsigned int *d; /* Pointer to an array of 'BN_BITS2' bit
                                 * chunks. */
    int top; /* Index of last used d +1. */
    /* The next are internal book keeping for bn_expand. */
    int dmax; /* Size of the d array. */
    int neg; /* one if the number is negative */
    int flags;
};

# 342 "/usr/include/openssl/bn.h"
struct bn_mont_ctx_st {
    int ri; /* number of bits in R */
    BIGNUM RR; /* used to convert to montgomery form */
    BIGNUM N; /* The modulus */
    BIGNUM Ni; /* R*(1/R mod N) - N*Ni = 1 (Ni is only
                                 * stored for bignum algorithm) */
    unsigned int n0[2]; /* least significant word(s) of Ni; (type
                                 * changed with 0.9.9, was "BN_ULONG n0;"
                                 * before) */
    int flags;
};

# 367 "/usr/include/openssl/bn.h"
struct bn_gencb_st {
    unsigned int ver; /* To handle binary (in)compatibility */
    void *arg; /* callback-specific data */
    union {
        /* if(ver==1) - handles old style callbacks */
        void (*cb_1) (int, int, void *);
        /* if(ver==2) - new callback style */
        int (*cb_2) (int, int, BN_GENCB *);
    } cb;
};

# 162 "/usr/include/openssl/asn1.h"
struct stack_st_X509_ALGOR { _STACK stack; };

# 210 "/usr/include/openssl/asn1.h"
typedef struct asn1_object_st {
    const char *sn, *ln;
    int nid;
    int length;
    const unsigned char *data; /* data remains const after init */
    int flags; /* Should we free this one */
} ASN1_OBJECT;

# 239 "/usr/include/openssl/asn1.h"
struct asn1_string_st {
    int length;
    int type;
    unsigned char *data;
    /*
     * The value of the following field depends on the type being held.  It
     * is mostly being used for BIT_STRING so if the input data has a
     * non-zero 'unused bits' value, it will be handled correctly
     */
    long flags;
};

# 257 "/usr/include/openssl/asn1.h"
typedef struct ASN1_ENCODING_st {
    unsigned char *enc; /* DER encoding */
    long len; /* Length of encoding */
    int modified; /* set to 1 if 'enc' is invalid */
} ASN1_ENCODING;

# 299 "/usr/include/openssl/asn1.h"
typedef struct ASN1_VALUE_st ASN1_VALUE;

# 524 "/usr/include/openssl/asn1.h"
typedef struct asn1_type_st {
    int type;
    union {
        char *ptr;
        ASN1_BOOLEAN boolean;
        ASN1_STRING *asn1_string;
        ASN1_OBJECT *object;
        ASN1_INTEGER *integer;
        ASN1_ENUMERATED *enumerated;
        ASN1_BIT_STRING *bit_string;
        ASN1_OCTET_STRING *octet_string;
        ASN1_PRINTABLESTRING *printablestring;
        ASN1_T61STRING *t61string;
        ASN1_IA5STRING *ia5string;
        ASN1_GENERALSTRING *generalstring;
        ASN1_BMPSTRING *bmpstring;
        ASN1_UNIVERSALSTRING *universalstring;
        ASN1_UTCTIME *utctime;
        ASN1_GENERALIZEDTIME *generalizedtime;
        ASN1_VISIBLESTRING *visiblestring;
        ASN1_UTF8STRING *utf8string;
        /*
         * set and sequence are left complete and still contain the set or
         * sequence bytes
         */
        ASN1_STRING *set;
        ASN1_STRING *sequence;
        ASN1_VALUE *asn1_value;
    } value;
} ASN1_TYPE;

# 793 "/usr/include/openssl/asn1.h"
struct stack_st_ASN1_OBJECT { _STACK stack; };

# 128 "/usr/include/openssl/evp.h"
struct evp_pkey_st {
    int type;
    int save_type;
    int references;
    const EVP_PKEY_ASN1_METHOD *ameth;
    ENGINE *engine;
    union {
        char *ptr;

        struct rsa_st *rsa; /* RSA */


        struct dsa_st *dsa; /* DSA */


        struct dh_st *dh; /* DH */


        struct ec_key_st *ec; /* ECC */

    } pkey;
    int save_parameters;
    struct stack_st_X509_ATTRIBUTE *attributes; /* [ 0 ] */
};

# 159 "/usr/include/openssl/evp.h"
struct env_md_st {
    int type;
    int pkey_type;
    int md_size;
    unsigned long flags;
    int (*init) (EVP_MD_CTX *ctx);
    int (*update) (EVP_MD_CTX *ctx, const void *data, size_t count);
    int (*final) (EVP_MD_CTX *ctx, unsigned char *md);
    int (*copy) (EVP_MD_CTX *to, const EVP_MD_CTX *from);
    int (*cleanup) (EVP_MD_CTX *ctx);
    /* FIXME: prototype these some day */
    int (*sign) (int type, const unsigned char *m, unsigned int m_length,
                 unsigned char *sigret, unsigned int *siglen, void *key);
    int (*verify) (int type, const unsigned char *m, unsigned int m_length,
                   const unsigned char *sigbuf, unsigned int siglen,
                   void *key);
    int required_pkey_type[5]; /* EVP_PKEY_xxx */
    int block_size;
    int ctx_size; /* how big does the ctx->md_data need to be */
    /* control function */
    int (*md_ctrl) (EVP_MD_CTX *ctx, int cmd, int p1, void *p2);
};

# 267 "/usr/include/openssl/evp.h"
struct env_md_ctx_st {
    const EVP_MD *digest;
    ENGINE *engine; /* functional reference if 'digest' is
                                 * ENGINE-provided */
    unsigned long flags;
    void *md_data;
    /* Public key context for sign/verify */
    EVP_PKEY_CTX *pctx;
    /* Update function: usually copied from EVP_MD */
    int (*update) (EVP_MD_CTX *ctx, const void *data, size_t count);
};

# 307 "/usr/include/openssl/evp.h"
struct evp_cipher_st {
    int nid;
    int block_size;
    /* Default value for variable length ciphers */
    int key_len;
    int iv_len;
    /* Various flags */
    unsigned long flags;
    /* init key */
    int (*init) (EVP_CIPHER_CTX *ctx, const unsigned char *key,
                 const unsigned char *iv, int enc);
    /* encrypt/decrypt data */
    int (*do_cipher) (EVP_CIPHER_CTX *ctx, unsigned char *out,
                      const unsigned char *in, size_t inl);
    /* cleanup ctx */
    int (*cleanup) (EVP_CIPHER_CTX *);
    /* how big ctx->cipher_data needs to be */
    int ctx_size;
    /* Populate a ASN1_TYPE with parameters */
    int (*set_asn1_parameters) (EVP_CIPHER_CTX *, ASN1_TYPE *);
    /* Get parameters from a ASN1_TYPE */
    int (*get_asn1_parameters) (EVP_CIPHER_CTX *, ASN1_TYPE *);
    /* Miscellaneous operations */
    int (*ctrl) (EVP_CIPHER_CTX *, int type, int arg, void *ptr);
    /* Application data */
    void *app_data;
};

# 427 "/usr/include/openssl/evp.h"
struct evp_cipher_ctx_st {
    const EVP_CIPHER *cipher;
    ENGINE *engine; /* functional reference if 'cipher' is
                                 * ENGINE-provided */
    int encrypt; /* encrypt or decrypt */
    int buf_len; /* number we have left */
    unsigned char oiv[16]; /* original iv */
    unsigned char iv[16]; /* working iv */
    unsigned char buf[32]; /* saved partial block */
    int num; /* used by cfb/ofb/ctr mode */
    void *app_data; /* application stuff */
    int key_len; /* May change for variable length cipher */
    unsigned long flags; /* Various flags */
    void *cipher_data; /* per EVP data */
    int final_used;
    int block_mask;
    unsigned char final[32]; /* possible final block */
};

# 85 "/usr/include/openssl/rsa.h"
struct rsa_meth_st {
    const char *name;
    int (*rsa_pub_enc) (int flen, const unsigned char *from,
                        unsigned char *to, RSA *rsa, int padding);
    int (*rsa_pub_dec) (int flen, const unsigned char *from,
                        unsigned char *to, RSA *rsa, int padding);
    int (*rsa_priv_enc) (int flen, const unsigned char *from,
                         unsigned char *to, RSA *rsa, int padding);
    int (*rsa_priv_dec) (int flen, const unsigned char *from,
                         unsigned char *to, RSA *rsa, int padding);
    /* Can be null */
    int (*rsa_mod_exp) (BIGNUM *r0, const BIGNUM *I, RSA *rsa, BN_CTX *ctx);
    /* Can be null */
    int (*bn_mod_exp) (BIGNUM *r, const BIGNUM *a, const BIGNUM *p,
                       const BIGNUM *m, BN_CTX *ctx, BN_MONT_CTX *m_ctx);
    /* called at new */
    int (*init) (RSA *rsa);
    /* called at free */
    int (*finish) (RSA *rsa);
    /* RSA_METHOD_FLAG_* things */
    int flags;
    /* may be needed! */
    char *app_data;
    /*
     * New sign and verify functions: some libraries don't allow arbitrary
     * data to be signed/verified: this allows them to be used. Note: for
     * this to work the RSA_public_decrypt() and RSA_private_encrypt() should
     * *NOT* be used RSA_sign(), RSA_verify() should be used instead. Note:
     * for backwards compatibility this functionality is only enabled if the
     * RSA_FLAG_SIGN_VER option is set in 'flags'.
     */
    int (*rsa_sign) (int type,
                     const unsigned char *m, unsigned int m_length,
                     unsigned char *sigret, unsigned int *siglen,
                     const RSA *rsa);
    int (*rsa_verify) (int dtype, const unsigned char *m,
                       unsigned int m_length, const unsigned char *sigbuf,
                       unsigned int siglen, const RSA *rsa);
    /*
     * If this callback is NULL, the builtin software RSA key-gen will be
     * used. This is for behavioural compatibility whilst the code gets
     * rewired, but one day it would be nice to assume there are no such
     * things as "builtin software" implementations.
     */
    int (*rsa_keygen) (RSA *rsa, int bits, BIGNUM *e, BN_GENCB *cb);
};

# 132 "/usr/include/openssl/rsa.h"
struct rsa_st {
    /*
     * The first parameter is used to pickup errors where this is passed
     * instead of aEVP_PKEY, it is set to 0
     */
    int pad;
    long version;
    const RSA_METHOD *meth;
    /* functional reference if 'meth' is ENGINE-provided */
    ENGINE *engine;
    BIGNUM *n;
    BIGNUM *e;
    BIGNUM *d;
    BIGNUM *p;
    BIGNUM *q;
    BIGNUM *dmp1;
    BIGNUM *dmq1;
    BIGNUM *iqmp;
    /* be careful using this if the RSA structure is shared */
    CRYPTO_EX_DATA ex_data;
    int references;
    int flags;
    /* Used to cache montgomery values */
    BN_MONT_CTX *_method_mod_n;
    BN_MONT_CTX *_method_mod_p;
    BN_MONT_CTX *_method_mod_q;
    /*
     * all BIGNUM values are actually in the following data, if it is not
     * NULL
     */
    char *bignum_data;
    BN_BLINDING *blinding;
    BN_BLINDING *mt_blinding;
};

# 117 "/usr/include/openssl/dh.h"
struct dh_method {
    const char *name;
    /* Methods here */
    int (*generate_key) (DH *dh);
    int (*compute_key) (unsigned char *key, const BIGNUM *pub_key, DH *dh);
    /* Can be null */
    int (*bn_mod_exp) (const DH *dh, BIGNUM *r, const BIGNUM *a,
                       const BIGNUM *p, const BIGNUM *m, BN_CTX *ctx,
                       BN_MONT_CTX *m_ctx);
    int (*init) (DH *dh);
    int (*finish) (DH *dh);
    int flags;
    char *app_data;
    /* If this is non-NULL, it will be used to generate parameters */
    int (*generate_params) (DH *dh, int prime_len, int generator,
                            BN_GENCB *cb);
};

# 135 "/usr/include/openssl/dh.h"
struct dh_st {
    /*
     * This first argument is used to pick up errors when a DH is passed
     * instead of a EVP_PKEY
     */
    int pad;
    int version;
    BIGNUM *p;
    BIGNUM *g;
    long length; /* optional */
    BIGNUM *pub_key; /* g^x */
    BIGNUM *priv_key; /* x */
    int flags;
    BN_MONT_CTX *method_mont_p;
    /* Place holders if we want to do X9.42 DH */
    BIGNUM *q;
    BIGNUM *j;
    unsigned char *seed;
    int seedlen;
    BIGNUM *counter;
    int references;
    CRYPTO_EX_DATA ex_data;
    const DH_METHOD *meth;
    ENGINE *engine;
};

# 124 "/usr/include/openssl/dsa.h"
typedef struct DSA_SIG_st {
    BIGNUM *r;
    BIGNUM *s;
} DSA_SIG;

# 129 "/usr/include/openssl/dsa.h"
struct dsa_method {
    const char *name;
    DSA_SIG *(*dsa_do_sign) (const unsigned char *dgst, int dlen, DSA *dsa);
    int (*dsa_sign_setup) (DSA *dsa, BN_CTX *ctx_in, BIGNUM **kinvp,
                           BIGNUM **rp);
    int (*dsa_do_verify) (const unsigned char *dgst, int dgst_len,
                          DSA_SIG *sig, DSA *dsa);
    int (*dsa_mod_exp) (DSA *dsa, BIGNUM *rr, BIGNUM *a1, BIGNUM *p1,
                        BIGNUM *a2, BIGNUM *p2, BIGNUM *m, BN_CTX *ctx,
                        BN_MONT_CTX *in_mont);
    /* Can be null */
    int (*bn_mod_exp) (DSA *dsa, BIGNUM *r, BIGNUM *a, const BIGNUM *p,
                       const BIGNUM *m, BN_CTX *ctx, BN_MONT_CTX *m_ctx);
    int (*init) (DSA *dsa);
    int (*finish) (DSA *dsa);
    int flags;
    char *app_data;
    /* If this is non-NULL, it is used to generate DSA parameters */
    int (*dsa_paramgen) (DSA *dsa, int bits,
                         const unsigned char *seed, int seed_len,
                         int *counter_ret, unsigned long *h_ret,
                         BN_GENCB *cb);
    /* If this is non-NULL, it is used to generate DSA keys */
    int (*dsa_keygen) (DSA *dsa);
};

# 155 "/usr/include/openssl/dsa.h"
struct dsa_st {
    /*
     * This first variable is used to pick up errors where a DSA is passed
     * instead of of a EVP_PKEY
     */
    int pad;
    long version;
    int write_params;
    BIGNUM *p;
    BIGNUM *q; /* == 20 */
    BIGNUM *g;
    BIGNUM *pub_key; /* y public key */
    BIGNUM *priv_key; /* x private key */
    BIGNUM *kinv; /* Signing pre-calc */
    BIGNUM *r; /* Signing pre-calc */
    int flags;
    /* Normally used to cache montgomery values */
    BN_MONT_CTX *method_mont_p;
    int references;
    CRYPTO_EX_DATA ex_data;
    const DSA_METHOD *meth;
    /* functional reference if 'meth' is ENGINE-provided */
    ENGINE *engine;
};

# 143 "/usr/include/openssl/x509.h"
struct X509_algor_st {
    ASN1_OBJECT *algorithm;
    ASN1_TYPE *parameter;
};

# 152 "/usr/include/openssl/x509.h"
typedef struct X509_val_st {
    ASN1_TIME *notBefore;
    ASN1_TIME *notAfter;
} X509_VAL;

# 157 "/usr/include/openssl/x509.h"
struct X509_pubkey_st {
    X509_ALGOR *algor;
    ASN1_BIT_STRING *public_key;
    EVP_PKEY *pkey;
};

# 175 "/usr/include/openssl/x509.h"
struct stack_st_X509_NAME_ENTRY { _STACK stack; };

# 179 "/usr/include/openssl/x509.h"
struct X509_name_st {
    struct stack_st_X509_NAME_ENTRY *entries;
    int modified; /* true if 'bytes' needs to be built */

    BUF_MEM *bytes;



/*      unsigned long hash; Keep the hash around for lookups */
    unsigned char *canon_enc;
    int canon_enclen;
};

# 192 "/usr/include/openssl/x509.h"
struct stack_st_X509_NAME { _STACK stack; };

# 202 "/usr/include/openssl/x509.h"
typedef struct stack_st_X509_EXTENSION X509_EXTENSIONS;

# 204 "/usr/include/openssl/x509.h"
struct stack_st_X509_EXTENSION { _STACK stack; };

# 223 "/usr/include/openssl/x509.h"
struct stack_st_X509_ATTRIBUTE { _STACK stack; };

# 242 "/usr/include/openssl/x509.h"
typedef struct x509_cinf_st {
    ASN1_INTEGER *version; /* [ 0 ] default of v1 */
    ASN1_INTEGER *serialNumber;
    X509_ALGOR *signature;
    X509_NAME *issuer;
    X509_VAL *validity;
    X509_NAME *subject;
    X509_PUBKEY *key;
    ASN1_BIT_STRING *issuerUID; /* [ 1 ] optional in v2 */
    ASN1_BIT_STRING *subjectUID; /* [ 2 ] optional in v2 */
    struct stack_st_X509_EXTENSION *extensions; /* [ 3 ] optional in v3 */
    ASN1_ENCODING enc;
} X509_CINF;

# 262 "/usr/include/openssl/x509.h"
typedef struct x509_cert_aux_st {
    struct stack_st_ASN1_OBJECT *trust; /* trusted uses */
    struct stack_st_ASN1_OBJECT *reject; /* rejected uses */
    ASN1_UTF8STRING *alias; /* "friendly name" */
    ASN1_OCTET_STRING *keyid; /* key id of private key */
    struct stack_st_X509_ALGOR *other; /* other unspecified info */
} X509_CERT_AUX;

# 270 "/usr/include/openssl/x509.h"
struct x509_st {
    X509_CINF *cert_info;
    X509_ALGOR *sig_alg;
    ASN1_BIT_STRING *signature;
    int valid;
    int references;
    char *name;
    CRYPTO_EX_DATA ex_data;
    /* These contain copies of various extension values */
    long ex_pathlen;
    long ex_pcpathlen;
    unsigned long ex_flags;
    unsigned long ex_kusage;
    unsigned long ex_xkusage;
    unsigned long ex_nscert;
    ASN1_OCTET_STRING *skid;
    AUTHORITY_KEYID *akid;
    X509_POLICY_CACHE *policy_cache;
    struct stack_st_DIST_POINT *crldp;
    struct stack_st_GENERAL_NAME *altname;
    NAME_CONSTRAINTS *nc;





    unsigned char sha1_hash[20];

    X509_CERT_AUX *aux;
};

# 301 "/usr/include/openssl/x509.h"
struct stack_st_X509 { _STACK stack; };

# 437 "/usr/include/openssl/x509.h"
struct stack_st_X509_REVOKED { _STACK stack; };

# 440 "/usr/include/openssl/x509.h"
typedef struct X509_crl_info_st {
    ASN1_INTEGER *version;
    X509_ALGOR *sig_alg;
    X509_NAME *issuer;
    ASN1_TIME *lastUpdate;
    ASN1_TIME *nextUpdate;
    struct stack_st_X509_REVOKED *revoked;
    struct stack_st_X509_EXTENSION /* [0] */ *extensions;
    ASN1_ENCODING enc;
} X509_CRL_INFO;

# 451 "/usr/include/openssl/x509.h"
struct X509_crl_st {
    /* actual signature */
    X509_CRL_INFO *crl;
    X509_ALGOR *sig_alg;
    ASN1_BIT_STRING *signature;
    int references;
    int flags;
    /* Copies of various extensions */
    AUTHORITY_KEYID *akid;
    ISSUING_DIST_POINT *idp;
    /* Convenient breakdown of IDP */
    int idp_flags;
    int idp_reasons;
    /* CRL and base CRL numbers for delta processing */
    ASN1_INTEGER *crl_number;
    ASN1_INTEGER *base_crl_number;

    unsigned char sha1_hash[20];

    struct stack_st_GENERAL_NAMES *issuers;
    const X509_CRL_METHOD *meth;
    void *meth_data;
};

# 475 "/usr/include/openssl/x509.h"
struct stack_st_X509_CRL { _STACK stack; };

# 136 "/usr/include/openssl/x509_vfy.h"
struct stack_st_X509_LOOKUP { _STACK stack; };

# 137 "/usr/include/openssl/x509_vfy.h"
struct stack_st_X509_OBJECT { _STACK stack; };

# 165 "/usr/include/openssl/x509_vfy.h"
typedef struct X509_VERIFY_PARAM_st {
    char *name;
    time_t check_time; /* Time to use */
    unsigned long inh_flags; /* Inheritance flags */
    unsigned long flags; /* Various verify flags */
    int purpose; /* purpose to check untrusted certificates */
    int trust; /* trust setting to check */
    int depth; /* Verify depth */
    struct stack_st_ASN1_OBJECT *policies; /* Permissible policies */
} X509_VERIFY_PARAM;

# 183 "/usr/include/openssl/x509_vfy.h"
struct x509_store_st {
    /* The following is a cache of trusted certs */
    int cache; /* if true, stash any hits */
    struct stack_st_X509_OBJECT *objs; /* Cache of all objects */
    /* These are external lookup methods */
    struct stack_st_X509_LOOKUP *get_cert_methods;
    X509_VERIFY_PARAM *param;
    /* Callbacks for various operations */
    /* called to verify a certificate */
    int (*verify) (X509_STORE_CTX *ctx);
    /* error callback */
    int (*verify_cb) (int ok, X509_STORE_CTX *ctx);
    /* get issuers cert from ctx */
    int (*get_issuer) (X509 **issuer, X509_STORE_CTX *ctx, X509 *x);
    /* check issued */
    int (*check_issued) (X509_STORE_CTX *ctx, X509 *x, X509 *issuer);
    /* Check revocation status of chain */
    int (*check_revocation) (X509_STORE_CTX *ctx);
    /* retrieve CRL */
    int (*get_crl) (X509_STORE_CTX *ctx, X509_CRL **crl, X509 *x);
    /* Check CRL validity */
    int (*check_crl) (X509_STORE_CTX *ctx, X509_CRL *crl);
    /* Check certificate against CRL */
    int (*cert_crl) (X509_STORE_CTX *ctx, X509_CRL *crl, X509 *x);
    struct stack_st_X509 *(*lookup_certs) (X509_STORE_CTX *ctx, X509_NAME *nm);
    struct stack_st_X509_CRL *(*lookup_crls) (X509_STORE_CTX *ctx, X509_NAME *nm);
    int (*cleanup) (X509_STORE_CTX *ctx);
    CRYPTO_EX_DATA ex_data;
    int references;
};

# 233 "/usr/include/openssl/x509_vfy.h"
struct x509_store_ctx_st { /* X509_STORE_CTX */
    X509_STORE *ctx;
    /* used when looking up certs */
    int current_method;
    /* The following are set by the caller */
    /* The cert to check */
    X509 *cert;
    /* chain of X509s - untrusted - passed in */
    struct stack_st_X509 *untrusted;
    /* set of CRLs passed in */
    struct stack_st_X509_CRL *crls;
    X509_VERIFY_PARAM *param;
    /* Other info for use with get_issuer() */
    void *other_ctx;
    /* Callbacks for various operations */
    /* called to verify a certificate */
    int (*verify) (X509_STORE_CTX *ctx);
    /* error callback */
    int (*verify_cb) (int ok, X509_STORE_CTX *ctx);
    /* get issuers cert from ctx */
    int (*get_issuer) (X509 **issuer, X509_STORE_CTX *ctx, X509 *x);
    /* check issued */
    int (*check_issued) (X509_STORE_CTX *ctx, X509 *x, X509 *issuer);
    /* Check revocation status of chain */
    int (*check_revocation) (X509_STORE_CTX *ctx);
    /* retrieve CRL */
    int (*get_crl) (X509_STORE_CTX *ctx, X509_CRL **crl, X509 *x);
    /* Check CRL validity */
    int (*check_crl) (X509_STORE_CTX *ctx, X509_CRL *crl);
    /* Check certificate against CRL */
    int (*cert_crl) (X509_STORE_CTX *ctx, X509_CRL *crl, X509 *x);
    int (*check_policy) (X509_STORE_CTX *ctx);
    struct stack_st_X509 *(*lookup_certs) (X509_STORE_CTX *ctx, X509_NAME *nm);
    struct stack_st_X509_CRL *(*lookup_crls) (X509_STORE_CTX *ctx, X509_NAME *nm);
    int (*cleanup) (X509_STORE_CTX *ctx);
    /* The following is built up */
    /* if 0, rebuild chain */
    int valid;
    /* index of last untrusted cert */
    int last_untrusted;
    /* chain of X509s - built up and trusted */
    struct stack_st_X509 *chain;
    /* Valid policy tree */
    X509_POLICY_TREE *tree;
    /* Require explicit policy value */
    int explicit_policy;
    /* When something goes wrong, this is why */
    int error_depth;
    int error;
    X509 *current_cert;
    /* cert currently being tested as valid issuer */
    X509 *current_issuer;
    /* current CRL */
    X509_CRL *current_crl;
    /* score of current CRL */
    int current_crl_score;
    /* Reason mask */
    unsigned int current_reasons;
    /* For CRL path validation: parent context */
    X509_STORE_CTX *parent;
    CRYPTO_EX_DATA ex_data;
};

# 389 "/usr/include/openssl/pem.h"
typedef int pem_password_cb (char *buf, int size, int rwflag, void *userdata);

# 75 "/usr/include/openssl/hmac.h"
typedef struct hmac_ctx_st {
    const EVP_MD *md;
    EVP_MD_CTX md_ctx;
    EVP_MD_CTX i_ctx;
    EVP_MD_CTX o_ctx;
    unsigned int key_length;
    unsigned char key[128/* largest known is SHA512 */];
} HMAC_CTX;

# 369 "/usr/include/openssl/ssl.h"
typedef struct tls_session_ticket_ext_st TLS_SESSION_TICKET_EXT;

# 370 "/usr/include/openssl/ssl.h"
typedef struct ssl_method_st SSL_METHOD;

# 371 "/usr/include/openssl/ssl.h"
typedef struct ssl_cipher_st SSL_CIPHER;

# 372 "/usr/include/openssl/ssl.h"
typedef struct ssl_session_st SSL_SESSION;

# 374 "/usr/include/openssl/ssl.h"
struct stack_st_SSL_CIPHER { _STACK stack; };

# 377 "/usr/include/openssl/ssl.h"
typedef struct srtp_protection_profile_st {
    const char *name;
    unsigned long id;
} SRTP_PROTECTION_PROFILE;

# 382 "/usr/include/openssl/ssl.h"
struct stack_st_SRTP_PROTECTION_PROFILE { _STACK stack; };

# 384 "/usr/include/openssl/ssl.h"
typedef int (*tls_session_ticket_ext_cb_fn) (SSL *s,
                                             const unsigned char *data,
                                             int len, void *arg);

# 387 "/usr/include/openssl/ssl.h"
typedef int (*tls_session_secret_cb_fn) (SSL *s, void *secret,
                                         int *secret_len,
                                         struct stack_st_SSL_CIPHER *peer_ciphers,
                                         SSL_CIPHER **cipher, void *arg);

# 395 "/usr/include/openssl/ssl.h"
struct ssl_cipher_st {
    int valid;
    const char *name; /* text name */
    unsigned long id; /* id, 4 bytes, first is version */
    /*
     * changed in 0.9.9: these four used to be portions of a single value
     * 'algorithms'
     */
    unsigned long algorithm_mkey; /* key exchange algorithm */
    unsigned long algorithm_auth; /* server authentication */
    unsigned long algorithm_enc; /* symmetric encryption */
    unsigned long algorithm_mac; /* symmetric authentication */
    unsigned long algorithm_ssl; /* (major) protocol version */
    unsigned long algo_strength; /* strength and export flags */
    unsigned long algorithm2; /* Extra flags */
    int strength_bits; /* Number of bits really used */
    int alg_bits; /* Number of bits for algorithm */
};

# 415 "/usr/include/openssl/ssl.h"
struct ssl_method_st {
    int version;
    int (*ssl_new) (SSL *s);
    void (*ssl_clear) (SSL *s);
    void (*ssl_free) (SSL *s);
    int (*ssl_accept) (SSL *s);
    int (*ssl_connect) (SSL *s);
    int (*ssl_read) (SSL *s, void *buf, int len);
    int (*ssl_peek) (SSL *s, void *buf, int len);
    int (*ssl_write) (SSL *s, const void *buf, int len);
    int (*ssl_shutdown) (SSL *s);
    int (*ssl_renegotiate) (SSL *s);
    int (*ssl_renegotiate_check) (SSL *s);
    long (*ssl_get_message) (SSL *s, int st1, int stn, int mt, long
                             max, int *ok);
    int (*ssl_read_bytes) (SSL *s, int type, unsigned char *buf, int len,
                           int peek);
    int (*ssl_write_bytes) (SSL *s, int type, const void *buf_, int len);
    int (*ssl_dispatch_alert) (SSL *s);
    long (*ssl_ctrl) (SSL *s, int cmd, long larg, void *parg);
    long (*ssl_ctx_ctrl) (SSL_CTX *ctx, int cmd, long larg, void *parg);
    const SSL_CIPHER *(*get_cipher_by_char) (const unsigned char *ptr);
    int (*put_cipher_by_char) (const SSL_CIPHER *cipher, unsigned char *ptr);
    int (*ssl_pending) (const SSL *s);
    int (*num_ciphers) (void);
    const SSL_CIPHER *(*get_cipher) (unsigned ncipher);
    const struct ssl_method_st *(*get_ssl_method) (int version);
    long (*get_timeout) (void);
    struct ssl3_enc_method *ssl3_enc; /* Extra SSLv3/TLS stuff */
    int (*ssl_version) (void);
    long (*ssl_callback_ctrl) (SSL *s, int cb_id, void (*fp) (void));
    long (*ssl_ctx_callback_ctrl) (SSL_CTX *s, int cb_id, void (*fp) (void));
};

# 475 "/usr/include/openssl/ssl.h"
struct ssl_session_st {
    int ssl_version; /* what ssl version session info is being
                                 * kept in here? */
    /* only really used in SSLv2 */
    unsigned int key_arg_length;
    unsigned char key_arg[8];
    int master_key_length;
    unsigned char master_key[48];
    /* session_id - valid? */
    unsigned int session_id_length;
    unsigned char session_id[32];
    /*
     * this is used to determine whether the session is being reused in the
     * appropriate context. It is up to the application to set this, via
     * SSL_new
     */
    unsigned int sid_ctx_length;
    unsigned char sid_ctx[32];





    char *psk_identity_hint;
    char *psk_identity;

    /*
     * Used to indicate that session resumption is not allowed. Applications
     * can also set this bit for a new session via not_resumable_session_cb
     * to disable session caching and tickets.
     */
    int not_resumable;
    /* The cert is the certificate used to establish this connection */
    struct sess_cert_st /* SESS_CERT */ *sess_cert;
    /*
     * This is the cert for the other end. On clients, it will be the same as
     * sess_cert->peer_key->x509 (the latter is not enough as sess_cert is
     * not retained in the external representation of sessions, see
     * ssl_asn1.c).
     */
    X509 *peer;
    /*
     * when app_verify_callback accepts a session where the peer's
     * certificate is not ok, we must remember the error for session reuse:
     */
    long verify_result; /* only for servers */
    int references;
    long timeout;
    long time;
    unsigned int compress_meth; /* Need to lookup the method */
    const SSL_CIPHER *cipher;
    unsigned long cipher_id; /* when ASN.1 loaded, this needs to be used
                                 * to load the 'cipher' structure */
    struct stack_st_SSL_CIPHER *ciphers; /* shared ciphers? */
    CRYPTO_EX_DATA ex_data; /* application specific data */
    /*
     * These are used to make removal of session-ids more efficient and to
     * implement a maximum cache size.
     */
    struct ssl_session_st *prev, *next;

    char *tlsext_hostname;

    size_t tlsext_ecpointformatlist_length;
    unsigned char *tlsext_ecpointformatlist; /* peer's list */
    size_t tlsext_ellipticcurvelist_length;
    unsigned char *tlsext_ellipticcurvelist; /* peer's list */

    /* RFC4507 info */
    unsigned char *tlsext_tick; /* Session ticket */
    size_t tlsext_ticklen; /* Session ticket length */
    long tlsext_tick_lifetime_hint; /* Session lifetime hint in seconds */


    char *srp_username;

};

# 748 "/usr/include/openssl/ssl.h"
typedef struct srp_ctx_st {
    /* param for all the callbacks */
    void *SRP_cb_arg;
    /* set client Hello login callback */
    int (*TLS_ext_srp_username_callback) (SSL *, int *, void *);
    /* set SRP N/g param callback for verification */
    int (*SRP_verify_param_callback) (SSL *, void *);
    /* set SRP client passwd callback */
    char *(*SRP_give_srp_client_pwd_callback) (SSL *, void *);
    char *login;
    BIGNUM *N, *g, *s, *B, *A;
    BIGNUM *a, *b, *v;
    char *info;
    int strength;
    unsigned long srp_Mask;
} SRP_CTX;

# 804 "/usr/include/openssl/ssl.h"
typedef int (*GEN_SESSION_CB) (const SSL *ssl, unsigned char *id,
                               unsigned int *id_len);

# 821 "/usr/include/openssl/ssl.h"
struct stack_st_SSL_COMP { _STACK stack; };

# 822 "/usr/include/openssl/ssl.h"
struct lhash_st_SSL_SESSION { int dummy; };

# 824 "/usr/include/openssl/ssl.h"
struct ssl_ctx_st {
    const SSL_METHOD *method;
    struct stack_st_SSL_CIPHER *cipher_list;
    /* same as above but sorted for lookup */
    struct stack_st_SSL_CIPHER *cipher_list_by_id;
    struct x509_store_st /* X509_STORE */ *cert_store;
    struct lhash_st_SSL_SESSION *sessions;
    /*
     * Most session-ids that will be cached, default is
     * SSL_SESSION_CACHE_MAX_SIZE_DEFAULT. 0 is unlimited.
     */
    unsigned long session_cache_size;
    struct ssl_session_st *session_cache_head;
    struct ssl_session_st *session_cache_tail;
    /*
     * This can have one of 2 values, ored together, SSL_SESS_CACHE_CLIENT,
     * SSL_SESS_CACHE_SERVER, Default is SSL_SESSION_CACHE_SERVER, which
     * means only SSL_accept which cache SSL_SESSIONS.
     */
    int session_cache_mode;
    /*
     * If timeout is not 0, it is the default timeout value set when
     * SSL_new() is called.  This has been put in to make life easier to set
     * things up
     */
    long session_timeout;
    /*
     * If this callback is not null, it will be called each time a session id
     * is added to the cache.  If this function returns 1, it means that the
     * callback will do a SSL_SESSION_free() when it has finished using it.
     * Otherwise, on 0, it means the callback has finished with it. If
     * remove_session_cb is not null, it will be called when a session-id is
     * removed from the cache.  After the call, OpenSSL will
     * SSL_SESSION_free() it.
     */
    int (*new_session_cb) (struct ssl_st *ssl, SSL_SESSION *sess);
    void (*remove_session_cb) (struct ssl_ctx_st *ctx, SSL_SESSION *sess);
    SSL_SESSION *(*get_session_cb) (struct ssl_st *ssl,
                                    unsigned char *data, int len, int *copy);
    struct {
        int sess_connect; /* SSL new conn - started */
        int sess_connect_renegotiate; /* SSL reneg - requested */
        int sess_connect_good; /* SSL new conne/reneg - finished */
        int sess_accept; /* SSL new accept - started */
        int sess_accept_renegotiate; /* SSL reneg - requested */
        int sess_accept_good; /* SSL accept/reneg - finished */
        int sess_miss; /* session lookup misses */
        int sess_timeout; /* reuse attempt on timeouted session */
        int sess_cache_full; /* session removed due to full cache */
        int sess_hit; /* session reuse actually done */
        int sess_cb_hit; /* session-id that was not in the cache was
                                 * passed back via the callback.  This
                                 * indicates that the application is
                                 * supplying session-id's from other
                                 * processes - spooky :-) */
    } stats;

    int references;

    /* if defined, these override the X509_verify_cert() calls */
    int (*app_verify_callback) (X509_STORE_CTX *, void *);
    void *app_verify_arg;
    /*
     * before OpenSSL 0.9.7, 'app_verify_arg' was ignored
     * ('app_verify_callback' was called with just one argument)
     */

    /* Default password callback. */
    pem_password_cb *default_passwd_callback;

    /* Default password callback user data. */
    void *default_passwd_callback_userdata;

    /* get client cert callback */
    int (*client_cert_cb) (SSL *ssl, X509 **x509, EVP_PKEY **pkey);

    /* cookie generate callback */
    int (*app_gen_cookie_cb) (SSL *ssl, unsigned char *cookie,
                              unsigned int *cookie_len);

    /* verify cookie callback */
    int (*app_verify_cookie_cb) (SSL *ssl, unsigned char *cookie,
                                 unsigned int cookie_len);

    CRYPTO_EX_DATA ex_data;

    const EVP_MD *rsa_md5; /* For SSLv2 - name is 'ssl2-md5' */
    const EVP_MD *md5; /* For SSLv3/TLSv1 'ssl3-md5' */
    const EVP_MD *sha1; /* For SSLv3/TLSv1 'ssl3->sha1' */

    struct stack_st_X509 *extra_certs;
    struct stack_st_SSL_COMP *comp_methods; /* stack of SSL_COMP, SSLv3/TLSv1 */

    /* Default values used when no per-SSL value is defined follow */

    /* used if SSL's info_callback is NULL */
    void (*info_callback) (const SSL *ssl, int type, int val);

    /* what we put in client cert requests */
    struct stack_st_X509_NAME *client_CA;

    /*
     * Default values to use in SSL structures follow (these are copied by
     * SSL_new)
     */

    unsigned long options;
    unsigned long mode;
    long max_cert_list;

    struct cert_st /* CERT */ *cert;
    int read_ahead;

    /* callback that allows applications to peek at protocol messages */
    void (*msg_callback) (int write_p, int version, int content_type,
                          const void *buf, size_t len, SSL *ssl, void *arg);
    void *msg_callback_arg;

    int verify_mode;
    unsigned int sid_ctx_length;
    unsigned char sid_ctx[32];
    /* called 'verify_callback' in the SSL */
    int (*default_verify_callback) (int ok, X509_STORE_CTX *ctx);

    /* Default generate session ID callback. */
    GEN_SESSION_CB generate_session_id;

    X509_VERIFY_PARAM *param;






    int quiet_shutdown;

    /*
     * Maximum amount of data to send in one fragment. actual record size can
     * be more than this due to padding and MAC overheads.
     */
    unsigned int max_send_fragment;


    /*
     * Engine to pass requests for client certs to
     */
    ENGINE *client_cert_engine;



    /* TLS extensions servername callback */
    int (*tlsext_servername_callback) (SSL *, int *, void *);
    void *tlsext_servername_arg;
    /* RFC 4507 session ticket keys */
    unsigned char tlsext_tick_key_name[16];
    unsigned char tlsext_tick_hmac_key[16];
    unsigned char tlsext_tick_aes_key[16];
    /* Callback to support customisation of ticket key setting */
    int (*tlsext_ticket_key_cb) (SSL *ssl,
                                 unsigned char *name, unsigned char *iv,
                                 EVP_CIPHER_CTX *ectx,
                                 HMAC_CTX *hctx, int enc);

    /* certificate status request info */
    /* Callback for status request */
    int (*tlsext_status_cb) (SSL *ssl, void *arg);
    void *tlsext_status_arg;

    /* draft-rescorla-tls-opaque-prf-input-00.txt information */
    int (*tlsext_opaque_prf_input_callback) (SSL *, void *peerinput,
                                             size_t len, void *arg);
    void *tlsext_opaque_prf_input_callback_arg;



    char *psk_identity_hint;
    unsigned int (*psk_client_callback) (SSL *ssl, const char *hint,
                                         char *identity,
                                         unsigned int max_identity_len,
                                         unsigned char *psk,
                                         unsigned int max_psk_len);
    unsigned int (*psk_server_callback) (SSL *ssl, const char *identity,
                                         unsigned char *psk,
                                         unsigned int max_psk_len);




    unsigned int freelist_max_len;
    struct ssl3_buf_freelist_st *wbuf_freelist;
    struct ssl3_buf_freelist_st *rbuf_freelist;


    SRP_CTX srp_ctx; /* ctx for SRP authentication */





    /* Next protocol negotiation information */
    /* (for experimental NPN extension). */

    /*
     * For a server, this contains a callback function by which the set of
     * advertised protocols can be provided.
     */
    int (*next_protos_advertised_cb) (SSL *s, const unsigned char **buf,
                                      unsigned int *len, void *arg);
    void *next_protos_advertised_cb_arg;
    /*
     * For a client, this contains a callback function that selects the next
     * protocol from the list provided by the server.
     */
    int (*next_proto_select_cb) (SSL *s, unsigned char **out,
                                 unsigned char *outlen,
                                 const unsigned char *in,
                                 unsigned int inlen, void *arg);
    void *next_proto_select_cb_arg;

    /* SRTP profiles we are willing to do from RFC 5764 */
    struct stack_st_SRTP_PROTECTION_PROFILE *srtp_profiles;

};

# 1247 "/usr/include/openssl/ssl.h"
struct ssl_st {
    /*
     * protocol version (one of SSL2_VERSION, SSL3_VERSION, TLS1_VERSION,
     * DTLS1_VERSION)
     */
    int version;
    /* SSL_ST_CONNECT or SSL_ST_ACCEPT */
    int type;
    /* SSLv3 */
    const SSL_METHOD *method;
    /*
     * There are 2 BIO's even though they are normally both the same.  This
     * is so data can be read and written to different handlers
     */

    /* used by SSL_read */
    BIO *rbio;
    /* used by SSL_write */
    BIO *wbio;
    /* used during session-id reuse to concatenate messages */
    BIO *bbio;







    /*
     * This holds a variable that indicates what we were doing when a 0 or -1
     * is returned.  This is needed for non-blocking IO so we know what
     * request needs re-doing when in SSL_accept or SSL_connect
     */
    int rwstate;
    /* true when we are actually in SSL_accept() or SSL_connect() */
    int in_handshake;
    int (*handshake_func) (SSL *);
    /*
     * Imagine that here's a boolean member "init" that is switched as soon
     * as SSL_set_{accept/connect}_state is called for the first time, so
     * that "state" and "handshake_func" are properly initialized.  But as
     * handshake_func is == 0 until then, we use this test instead of an
     * "init" member.
     */
    /* are we the server side? - mostly used by SSL_clear */
    int server;
    /*
     * Generate a new session or reuse an old one.
     * NB: For servers, the 'new' session may actually be a previously
     * cached session or even the previous session unless
     * SSL_OP_NO_SESSION_RESUMPTION_ON_RENEGOTIATION is set
     */
    int new_session;
    /* don't send shutdown packets */
    int quiet_shutdown;
    /* we have shut things down, 0x01 sent, 0x02 for received */
    int shutdown;
    /* where we are */
    int state;
    /* where we are when reading */
    int rstate;
    BUF_MEM *init_buf; /* buffer used during init */
    void *init_msg; /* pointer to handshake message body, set by
                                 * ssl3_get_message() */
    int init_num; /* amount read/written */
    int init_off; /* amount read/written */
    /* used internally to point at a raw packet */
    unsigned char *packet;
    unsigned int packet_length;
    struct ssl2_state_st *s2; /* SSLv2 variables */
    struct ssl3_state_st *s3; /* SSLv3 variables */
    struct dtls1_state_st *d1; /* DTLSv1 variables */
    int read_ahead; /* Read as many input bytes as possible (for
                                 * non-blocking reads) */
    /* callback that allows applications to peek at protocol messages */
    void (*msg_callback) (int write_p, int version, int content_type,
                          const void *buf, size_t len, SSL *ssl, void *arg);
    void *msg_callback_arg;
    int hit; /* reusing a previous session */
    X509_VERIFY_PARAM *param;




    /* crypto */
    struct stack_st_SSL_CIPHER *cipher_list;
    struct stack_st_SSL_CIPHER *cipher_list_by_id;
    /*
     * These are the ones being used, the ones in SSL_SESSION are the ones to
     * be 'copied' into these ones
     */
    int mac_flags;
    EVP_CIPHER_CTX *enc_read_ctx; /* cryptographic state */
    EVP_MD_CTX *read_hash; /* used for mac generation */

    COMP_CTX *expand; /* uncompress */



    EVP_CIPHER_CTX *enc_write_ctx; /* cryptographic state */
    EVP_MD_CTX *write_hash; /* used for mac generation */

    COMP_CTX *compress; /* compression */



    /* session info */
    /* client cert? */
    /* This is used to hold the server certificate used */
    struct cert_st /* CERT */ *cert;
    /*
     * the session_id_context is used to ensure sessions are only reused in
     * the appropriate context
     */
    unsigned int sid_ctx_length;
    unsigned char sid_ctx[32];
    /* This can also be in the session once a session is established */
    SSL_SESSION *session;
    /* Default generate session ID callback. */
    GEN_SESSION_CB generate_session_id;
    /* Used in SSL2 and SSL3 */
    /*
     * 0 don't care about verify failure.
     * 1 fail if verify fails
     */
    int verify_mode;
    /* fail if callback returns 0 */
    int (*verify_callback) (int ok, X509_STORE_CTX *ctx);
    /* optional informational callback */
    void (*info_callback) (const SSL *ssl, int type, int val);
    /* error bytes to be written */
    int error;
    /* actual code */
    int error_code;





    unsigned int (*psk_client_callback) (SSL *ssl, const char *hint,
                                         char *identity,
                                         unsigned int max_identity_len,
                                         unsigned char *psk,
                                         unsigned int max_psk_len);
    unsigned int (*psk_server_callback) (SSL *ssl, const char *identity,
                                         unsigned char *psk,
                                         unsigned int max_psk_len);

    SSL_CTX *ctx;
    /*
     * set this flag to 1 and a sleep(1) is put into all SSL_read() and
     * SSL_write() calls, good for nbio debuging :-)
     */
    int debug;
    /* extra application data */
    long verify_result;
    CRYPTO_EX_DATA ex_data;
    /* for server side, keep the list of CA_dn we can use */
    struct stack_st_X509_NAME *client_CA;
    int references;
    /* protocol behaviour */
    unsigned long options;
    /* API behaviour */
    unsigned long mode;
    long max_cert_list;
    int first_packet;
    /* what was passed, used for SSLv3/TLS rollback check */
    int client_version;
    unsigned int max_send_fragment;

    /* TLS extension debug callback */
    void (*tlsext_debug_cb) (SSL *s, int client_server, int type,
                             unsigned char *data, int len, void *arg);
    void *tlsext_debug_arg;
    char *tlsext_hostname;
    /*-
     * no further mod of servername
     * 0 : call the servername extension callback.
     * 1 : prepare 2, allow last ack just after in server callback.
     * 2 : don't call servername callback, no ack in server hello
     */
    int servername_done;
    /* certificate status request info */
    /* Status type or -1 if no status type */
    int tlsext_status_type;
    /* Expect OCSP CertificateStatus message */
    int tlsext_status_expected;
    /* OCSP status request only */
    struct stack_st_OCSP_RESPID *tlsext_ocsp_ids;
    X509_EXTENSIONS *tlsext_ocsp_exts;
    /* OCSP response received or to be sent */
    unsigned char *tlsext_ocsp_resp;
    int tlsext_ocsp_resplen;
    /* RFC4507 session ticket expected to be received or sent */
    int tlsext_ticket_expected;

    size_t tlsext_ecpointformatlist_length;
    /* our list */
    unsigned char *tlsext_ecpointformatlist;
    size_t tlsext_ellipticcurvelist_length;
    /* our list */
    unsigned char *tlsext_ellipticcurvelist;

    /*
     * draft-rescorla-tls-opaque-prf-input-00.txt information to be used for
     * handshakes
     */
    void *tlsext_opaque_prf_input;
    size_t tlsext_opaque_prf_input_len;
    /* TLS Session Ticket extension override */
    TLS_SESSION_TICKET_EXT *tlsext_session_ticket;
    /* TLS Session Ticket extension callback */
    tls_session_ticket_ext_cb_fn tls_session_ticket_ext_cb;
    void *tls_session_ticket_ext_cb_arg;
    /* TLS pre-shared secret session resumption */
    tls_session_secret_cb_fn tls_session_secret_cb;
    void *tls_session_secret_cb_arg;
    SSL_CTX *initial_ctx; /* initial ctx, used to store sessions */

    /*
     * Next protocol negotiation. For the client, this is the protocol that
     * we sent in NextProtocol and is set when handling ServerHello
     * extensions. For a server, this is the client's selected_protocol from
     * NextProtocol and is set when handling the NextProtocol message, before
     * the Finished message.
     */
    unsigned char *next_proto_negotiated;
    unsigned char next_proto_negotiated_len;


    /* What we'll do */
    struct stack_st_SRTP_PROTECTION_PROFILE *srtp_profiles;
    /* What's been chosen */
    SRTP_PROTECTION_PROFILE *srtp_profile;
        /*-
         * Is use of the Heartbeat extension negotiated?
         * 0: disabled
         * 1: enabled
         * 2: enabled, but not allowed to send Requests
         */
    unsigned int tlsext_heartbeat;
    /* Indicates if a HeartbeatRequest is in flight */
    unsigned int tlsext_hb_pending;
    /* HeartbeatRequest sequence number */
    unsigned int tlsext_hb_seq;



    /*-
     * 1 if we are renegotiating.
     * 2 if we are a server and are inside a handshake
     * (i.e. not just sending a HelloRequest)
     */
    int renegotiate;

    /* ctx for SRP authentication */
    SRP_CTX srp_ctx;

};

# 777 "/usr/include/openssl/tls1.h"
struct tls_session_ticket_ext_st {
    unsigned short length;
    void *data;
};

# 1497 "../src/common/tortls.c"
static int
find_cipher_by_id(const SSL_METHOD *m, uint16_t cipher)
{
  const SSL_CIPHER *c;

  if (m && m->get_cipher_by_char) {
    unsigned char cipherid[3];
    set_uint16(cipherid, (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (cipher); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
    cipherid[2] = 0; /* If ssl23_get_cipher_by_char finds no cipher starting
                      * with a two-byte 'cipherid', it may look for a v2
                      * cipher with the appropriate 3 bytes. */
    c = m->get_cipher_by_char(cipherid);
    if (c)
      (void) ({ if (__builtin_expect(!!(!((c->id & 0xffff) == cipher)), 0)) { tor_assertion_failed_(("../src/common/tortls.c"), 1510, __func__, "(c->id & 0xffff) == cipher"); abort(); } });
    return c != ((void *)0);
  } else

  if (m && m->get_cipher && m->num_ciphers) {
    /* It would seem that some of the "let's-clean-up-openssl" forks have
     * removed the get_cipher_by_char function.  Okay, so now you get a
     * quadratic search.
     */
    int i;
    for (i = 0; i < m->num_ciphers(); ++i) {
      c = m->get_cipher(i);
      if (c && (c->id & 0xffff) == cipher) {
        return 1;
      }
    }
    return 0;
  } else {
    return 1; /* No way to search */
  }
}

