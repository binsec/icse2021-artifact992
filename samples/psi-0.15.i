unsigned int __builtin_bswap32 (unsigned int);

# 44 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}

# 31 "../../jdns/jdns.h"
typedef void (*jdns_object_dtor_func)(void *);

# 32 "../../jdns/jdns.h"
typedef void *(*jdns_object_cctor_func)(const void *);

# 59 "../../jdns/jdns.h"
typedef struct jdns_list
{
 jdns_object_dtor_func dtor; jdns_object_cctor_func cctor;
 int count;
 void **item;
 int valueList;
 int autoDelete;
} jdns_list_t;

# 72 "../../jdns/jdns.h"
void jdns_list_insert(jdns_list_t *a, void *item, int pos);

# 77 "../../jdns/jdns.h"
typedef struct jdns_string
{
 jdns_object_dtor_func dtor; jdns_object_cctor_func cctor;
 unsigned char *data;
 int size;
} jdns_string_t;

# 84 "../../jdns/jdns.h"
jdns_string_t *jdns_string_new();

# 86 "../../jdns/jdns.h"
void jdns_string_delete(jdns_string_t *s);

# 89 "../../jdns/jdns.h"
void jdns_string_set_cstr(jdns_string_t *s, const char *str);

# 60 "../../jdns/jdns_packet.h"
typedef struct jdns_packet_resource
{
 jdns_object_dtor_func dtor; jdns_object_cctor_func cctor;
 jdns_string_t *qname;
 unsigned short int qtype, qclass;
 unsigned long int ttl; // 31-bit number, top bit always 0
 unsigned short int rdlength;
 unsigned char *rdata;

 // private
 jdns_list_t *writelog; // jdns_packet_write_t
} jdns_packet_resource_t;

# 73 "../../jdns/jdns_packet.h"
jdns_packet_resource_t *jdns_packet_resource_new();

# 75 "../../jdns/jdns_packet.h"
void jdns_packet_resource_delete(jdns_packet_resource_t *a);

# 76 "../../jdns/jdns_packet.h"
void jdns_packet_resource_add_bytes(jdns_packet_resource_t *a, const unsigned char *data, int size);

# 77 "../../jdns/jdns_packet.h"
void jdns_packet_resource_add_name(jdns_packet_resource_t *a, const jdns_string_t *name);

# 39 "../../jdns/jdns_mdnsd.h"
typedef struct mdnsda_struct
{
    unsigned char *name;
    unsigned short int type;
    unsigned long int ttl;
    unsigned long int real_ttl;
    unsigned short int rdlen;
    unsigned char *rdata;
    unsigned long int ip; // A
    unsigned char *rdname; // NS/CNAME/PTR/SRV
    struct { unsigned short int priority, weight, port; } srv; // SRV
} *mdnsda;

# 562 "../../jdns/jdns_mdnsd.c"
void _a_copy(jdns_list_t *dest, unsigned char *name, unsigned short type, unsigned short class, unsigned long int ttl, mdnsda a)
{
    jdns_packet_resource_t *r = jdns_packet_resource_new();
    r->qname = jdns_string_new();
    jdns_string_set_cstr(r->qname, (char *)name);
    r->qtype = type;
    r->qclass = class;
    r->ttl = ttl;
    if(a->rdata)
        jdns_packet_resource_add_bytes(r, a->rdata, a->rdlen);
    else if(a->ip)
    {
        unsigned long int ip;
        ip = __bswap_32 (a->ip);
        jdns_packet_resource_add_bytes(r, (unsigned char *)&ip, 4);
    }
    else if(a->type == 33)
    {
        unsigned short priority, weight, port;
        jdns_string_t *name;
        priority = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (a->srv.priority); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
        weight = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (a->srv.weight); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
        port = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (a->srv.port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
        name = jdns_string_new();
        jdns_string_set_cstr(name, (const char *)a->rdname);
        jdns_packet_resource_add_bytes(r, (unsigned char *)&priority, 2);
        jdns_packet_resource_add_bytes(r, (unsigned char *)&weight, 2);
        jdns_packet_resource_add_bytes(r, (unsigned char *)&port, 2);
        jdns_packet_resource_add_name(r, name);
        jdns_string_delete(name);
    }
    else if(a->rdname)
    {
        jdns_string_t *name;
        name = jdns_string_new();
        jdns_string_set_cstr(name, (const char *)a->rdname);
        jdns_packet_resource_add_name(r, name);
        jdns_string_delete(name);
    }
    jdns_list_insert(dest, r, -1);
    jdns_packet_resource_delete(r);
}

