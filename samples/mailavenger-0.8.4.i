unsigned int __builtin_strlen (const char *);
int __builtin_strcmp (const char *, const char *);

# 33 "/usr/include/i386-linux-gnu/bits/types.h"
typedef unsigned long int __u_long;

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 36 "/usr/include/i386-linux-gnu/sys/types.h"
typedef __u_long u_long;

# 466 "/usr/include/stdlib.h"
extern void *malloc (size_t __size);

# 483 "/usr/include/stdlib.h"
extern void free (void *__ptr);

# 399 "/usr/include/string.h"
extern size_t strlen (const char *__s);

# 47 "./stktrace.c"
static const char hexdigits[] = "0123456789abcdef";

# 49 "./stktrace.c"
struct traceback {
  struct traceback *next;
  char *name;
};

# 55 "./stktrace.c"
static struct traceback *stkcache[509U];

/*@ rustina_out_of_scope */
# 67 "./stktrace.c"
const char *
__backtrace (const char *file, int lim)
{
  const void *const *framep;
  size_t filelen;
  char buf[256];
  char *bp = buf + sizeof (buf);
  u_long bucket = 5381;
  struct traceback *tb;




  filelen = strlen (file);
  if (filelen >= sizeof (buf))
    return file;
  bp -= filelen + 1;
  strcpy (bp, file);
# 96 "./stktrace.c"
  __asm volatile ("movl %%ebp, %0" : "=g" (framep) :);
  while (!((int) framep & 3) && (const char *) framep > buf
  && framep[0] && bp >= buf + 11 && lim--) {
    int i;
    u_long pc = (u_long) framep[1] - 1;
    bucket = ((bucket << 5) + bucket) ^ pc;

    *--bp = ' ';
    *--bp = hexdigits[pc & 0xf];
    pc >>= 4;
    for (i = 0; pc && i < 7; i++) {
      *--bp = hexdigits[pc & 0xf];
      pc >>= 4;
    }
    *--bp = 'x';
    *--bp = '0';




    framep = *framep;
  }





  bucket = (bucket & 0xffffffff) % 509U;

  for (tb = stkcache[bucket]; tb; tb = tb->next)
    if (!__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (tb->name) && __builtin_constant_p (bp) && (__s1_len = __builtin_strlen (tb->name), __s2_len = __builtin_strlen (bp), (!((size_t)(const void *)((tb->name) + 1) - (size_t)(const void *)(tb->name) == 1) || __s1_len >= 4) && (!((size_t)(const void *)((bp) + 1) - (size_t)(const void *)(bp) == 1) || __s2_len >= 4)) ? __builtin_strcmp (tb->name, bp) : (__builtin_constant_p (tb->name) && ((size_t)(const void *)((tb->name) + 1) - (size_t)(const void *)(tb->name) == 1) && (__s1_len = __builtin_strlen (tb->name), __s1_len < 4) ? (__builtin_constant_p (bp) && ((size_t)(const void *)((bp) + 1) - (size_t)(const void *)(bp) == 1) ? __builtin_strcmp (tb->name, bp) : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (bp); int __result = (((const unsigned char *) (const char *) (tb->name))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (tb->name))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (tb->name))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (tb->name))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p (bp) && ((size_t)(const void *)((bp) + 1) - (size_t)(const void *)(bp) == 1) && (__s2_len = __builtin_strlen (bp), __s2_len < 4) ? (__builtin_constant_p (tb->name) && ((size_t)(const void *)((tb->name) + 1) - (size_t)(const void *)(tb->name) == 1) ? __builtin_strcmp (tb->name, bp) : (- (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (tb->name); int __result = (((const unsigned char *) (const char *) (bp))[0] - __s2[0]); if (__s2_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (bp))[1] - __s2[1]); if (__s2_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (bp))[2] - __s2[2]); if (__s2_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (bp))[3] - __s2[3]); } } __result; })))) : __builtin_strcmp (tb->name, bp)))); }))
      return tb->name;

  tb = malloc (sizeof (*tb));
  if (!tb)
    return file;
  tb->name = malloc (1 + strlen (bp));
  if (!tb->name) {
    free (tb);
    return file;
  }
  strcpy (tb->name, bp);
  tb->next = stkcache[bucket];
  stkcache[bucket] = tb;

  return tb->name;
}
