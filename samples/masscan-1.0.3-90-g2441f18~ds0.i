void * __builtin___memcpy_chk (void *, const void *, unsigned int, unsigned int);
unsigned int __builtin_object_size (const void *, int);

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 152 "src/rte-ring.h"
enum rte_ring_queue_behavior {
    RTE_RING_QUEUE_FIXED = 0, /* Enq/Deq a fixed number of items from a ring */
    RTE_RING_QUEUE_VARIABLE /* Enq/Deq as many items a possible from ring */
};

# 168 "src/rte-ring.h"
struct rte_ring {
    int flags; /**< Flags supplied at creation. */

    /** Ring producer status. */
    struct prod {
        uint32_t watermark; /**< Maximum items before EDQUOT. */
        uint32_t sp_enqueue; /**< True, if single producer. */
        uint32_t size; /**< Size of ring. */
        uint32_t mask; /**< Mask (size-1) of ring. */
        volatile uint32_t head; /**< Producer head. */
        volatile uint32_t tail; /**< Producer tail. */
    } prod ;

    /** Ring consumer status. */
    struct cons {
        uint32_t sc_dequeue; /**< True, if single consumer. */
        uint32_t size; /**< Size of the ring. */
        uint32_t mask; /**< Mask (size-1) of ring. */
        volatile uint32_t head; /**< Consumer head. */
        volatile uint32_t tail; /**< Consumer tail. */
    } cons ;






    void * volatile ring[1]
                               ; /**< Memory space of ring starts here. */
};

# 308 "src/rte-ring.h"
static inline int
__rte_ring_mp_do_enqueue(struct rte_ring *r, void * const *obj_table,
             unsigned n, enum rte_ring_queue_behavior behavior)
{
    uint32_t prod_head, prod_next;
    uint32_t cons_tail, free_entries;
    const unsigned max = n;
    int success;
    unsigned i;
    uint32_t mask = r->prod.mask;
    int ret;

    /* move prod.head atomically */
    do {
        /* Reset n to the initial burst count */
        n = max;

        prod_head = r->prod.head;
        cons_tail = r->cons.tail;
        /* The subtraction is done between two unsigned 32bits value
         * (the result is always modulo 32 bits even if we have
         * prod_head > cons_tail). So 'free_entries' is always between 0
         * and size(ring)-1. */
        free_entries = (mask + cons_tail - prod_head);

        /* check that we have enough room in ring */
        if (__builtin_expect((n > free_entries), 0)) {
            if (behavior == RTE_RING_QUEUE_FIXED) {
                ;
                return -105 /* No buffer space available */;
            }
            else {
                /* No free entry available */
                if (__builtin_expect((free_entries == 0), 0)) {
                    ;
                    return 0;
                }

                n = free_entries;
            }
        }

        prod_next = prod_head + n;
        success = __sync_bool_compare_and_swap((volatile int*)(&r->prod.head),(int)prod_head,(int)prod_next)
                                    ;
    } while (__builtin_expect((success == 0), 0));

    /* write entries in ring */
    for (i = 0; __builtin_expect((i < n), !0); i++)
        r->ring[(prod_head + i) & mask] = obj_table[i];
    asm volatile("sfence;" : : : "memory");

    /* if we exceed the watermark */
    if (__builtin_expect((((mask + 1) - free_entries + n) > r->prod.watermark), 0)) {
        ret = (behavior == RTE_RING_QUEUE_FIXED) ? -122 /* Quota exceeded */ :
                (int)(n | (1 << 31) /**< Quota exceed for burst ops */);
        ;
    }
    else {
        ret = (behavior == RTE_RING_QUEUE_FIXED) ? 0 : n;
        ;
    }

    /*
     * If there are other enqueues in progress that preceeded us,
     * we need to wait for them to complete
     */
    while (__builtin_expect((r->prod.tail != prod_head), 0))
        asm volatile ("pause");

    r->prod.tail = prod_next;
    return ret;
}

# 404 "src/rte-ring.h"
static inline int
__rte_ring_sp_do_enqueue(struct rte_ring *r, void * const *obj_table,
             unsigned n, enum rte_ring_queue_behavior behavior)
{
    uint32_t prod_head, cons_tail;
    uint32_t prod_next, free_entries;
    unsigned i;
    uint32_t mask = r->prod.mask;
    int ret;

    prod_head = r->prod.head;
    cons_tail = r->cons.tail;
    /* The subtraction is done between two unsigned 32bits value
     * (the result is always modulo 32 bits even if we have
     * prod_head > cons_tail). So 'free_entries' is always between 0
     * and size(ring)-1. */
    free_entries = mask + cons_tail - prod_head;

    /* check that we have enough room in ring */
    if (__builtin_expect((n > free_entries), 0)) {
        if (behavior == RTE_RING_QUEUE_FIXED) {
            ;
            return -105 /* No buffer space available */;
        }
        else {
            /* No free entry available */
            if (__builtin_expect((free_entries == 0), 0)) {
                ;
                return 0;
            }

            n = free_entries;
        }
    }

    prod_next = prod_head + n;
    r->prod.head = prod_next;

    /* write entries in ring */
    for (i = 0; __builtin_expect((i < n), !0); i++)
        r->ring[(prod_head + i) & mask] = obj_table[i];
    asm volatile("sfence;" : : : "memory");

    /* if we exceed the watermark */
    if (__builtin_expect((((mask + 1) - free_entries + n) > r->prod.watermark), 0)) {
        ret = (behavior == RTE_RING_QUEUE_FIXED) ? -122 /* Quota exceeded */ :
            (int)(n | (1 << 31) /**< Quota exceed for burst ops */);
        ;
    }
    else {
        ret = (behavior == RTE_RING_QUEUE_FIXED) ? 0 : n;
        ;
    }

    r->prod.tail = prod_next;
    return ret;
}

# 489 "src/rte-ring.h"
static inline int
__rte_ring_mc_do_dequeue(struct rte_ring *r, void **obj_table,
         unsigned n, enum rte_ring_queue_behavior behavior)
{
    uint32_t cons_head, prod_tail;
    uint32_t cons_next, entries;
    const unsigned max = n;
    int success;
    unsigned i;
    uint32_t mask = r->prod.mask;

    /* move cons.head atomically */
    do {
        /* Restore n as it may change every loop */
        n = max;

        cons_head = r->cons.head;
        prod_tail = r->prod.tail;
        /* The subtraction is done between two unsigned 32bits value
         * (the result is always modulo 32 bits even if we have
         * cons_head > prod_tail). So 'entries' is always between 0
         * and size(ring)-1. */
        entries = (prod_tail - cons_head);

        /* Set the actual entries for dequeue */
        if (__builtin_expect((n > entries), 0)) {
            if (behavior == RTE_RING_QUEUE_FIXED) {
                ;
                return -2 /* No such file or directory */;
            }
            else {
                if (__builtin_expect((entries == 0), 0)){
                    ;
                    return 0;
                }

                n = entries;
            }
        }

        cons_next = cons_head + n;
        success = __sync_bool_compare_and_swap((volatile int*)(&r->cons.head),(int)cons_head,(int)cons_next)
                                    ;
    } while (__builtin_expect((success == 0), 0));

    /* copy in table */
    asm volatile("lfence;" : : : "memory");
    for (i = 0; __builtin_expect((i < n), !0); i++) {
        obj_table[i] = r->ring[(cons_head + i) & mask];
    }

    /*
     * If there are other dequeues in progress that preceded us,
     * we need to wait for them to complete
     */
    while (__builtin_expect((r->cons.tail != cons_head), 0))
        asm volatile ("pause");

    ;
    r->cons.tail = cons_next;

    return behavior == RTE_RING_QUEUE_FIXED ? 0 : n;
}

# 576 "src/rte-ring.h"
static inline int
__rte_ring_sc_do_dequeue(struct rte_ring *r, void **obj_table,
         unsigned n, enum rte_ring_queue_behavior behavior)
{
    uint32_t cons_head, prod_tail;
    uint32_t cons_next, entries;
    unsigned i;
    uint32_t mask = r->prod.mask;

    cons_head = r->cons.head;
    prod_tail = r->prod.tail;
    /* The subtraction is done between two unsigned 32bits value
     * (the result is always modulo 32 bits even if we have
     * cons_head > prod_tail). So 'entries' is always between 0
     * and size(ring)-1. */
    entries = prod_tail - cons_head;

    if (__builtin_expect((n > entries), 0)) {
        if (behavior == RTE_RING_QUEUE_FIXED) {
            ;
            return -2 /* No such file or directory */;
        }
        else {
            if (__builtin_expect((entries == 0), 0)){
                ;
                return 0;
            }

            n = entries;
        }
    }

    cons_next = cons_head + n;
    r->cons.head = cons_next;

    /* copy in table */
    asm volatile("lfence;" : : : "memory");
    for (i = 0; __builtin_expect((i < n), !0); i++) {
        /* WTF??? WHY DOES THIS CODE GIVE STRICT-ALIASING WARNINGS
         * ON SOME GCC. THEY ARE FREAKING VOID* !!! */
        obj_table[i] = r->ring[(cons_head + i) & mask];
    }

    ;
    r->cons.tail = cons_next;
    return behavior == RTE_RING_QUEUE_FIXED ? 0 : n;
}

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 466 "/usr/include/stdlib.h"
extern void *malloc (size_t __size);

# 468 "/usr/include/stdlib.h"
extern void *calloc (size_t __nmemb, size_t __size);

# 399 "/usr/include/string.h"
extern size_t strlen (const char *__s);

# 1278 "/usr/include/i386-linux-gnu/bits/string2.h"
extern char *__strdup (const char *__string);

# 47 "/usr/include/i386-linux-gnu/bits/string3.h"
extern __inline void *
 memcpy (void *__restrict __dest, const void *__restrict __src, size_t __len)

{
  return __builtin___memcpy_chk (__dest, __src, __len, __builtin_object_size (__dest, 0));
}

# 257 "/usr/include/netdb.h"
struct servent
{
  char *s_name; /* Official service name.  */
  char **s_aliases; /* Alias list.  */
  int s_port; /* Port number.  */
  char *s_proto; /* Protocol to use.  */
};

# 318 "/usr/include/netdb.h"
extern int getservbyport_r (int __port, const char *__restrict __proto,
       struct servent *__restrict __result_buf,
       char *__restrict __buf, size_t __buflen,
       struct servent **__restrict __result);

# 31 "src/out-unicornscan.c"
static char *tcp_service_name(int port)
{

    int r;
    struct servent result_buf;
    struct servent *result;
    char buf[2048];

    r = getservbyport_r((__extension__ ({ unsigned short int __v, __x = (unsigned short int) (port); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })), "tcp", &result_buf,buf, sizeof(buf), &result);

    /* ignore ERANGE - if the result can't fit in 2k, just return unknown */
    if (r != 0 || result == ((void *)0))
        return "unknown";

    return (__extension__ (__builtin_constant_p (result_buf.s_name) && ((size_t)(const void *)((result_buf.s_name) + 1) - (size_t)(const void *)(result_buf.s_name) == 1) ? (((const char *) (result_buf.s_name))[0] == '\0' ? (char *) calloc ((size_t) 1, (size_t) 1) : ({ size_t __len = strlen (result_buf.s_name) + 1; char *__retval = (char *) malloc (__len); if (__retval != ((void *)0)) __retval = (char *) memcpy (__retval, result_buf.s_name, __len); __retval; })) : __strdup (result_buf.s_name)));
# 56 "src/out-unicornscan.c"
}

