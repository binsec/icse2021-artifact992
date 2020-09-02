# 147 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef int ptrdiff_t;

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 75 "./include/zn_poly.h"
typedef unsigned long ulong;

# 96 "./include/zn_poly.h"
typedef struct
{
   // the modulus, must be >= 2
   ulong m;

   // ceil(log2(m)) = number of bits in a non-negative residue
   int bits;

   // reduction of B and B^2 mod m (where B = 2^ULONG_BITS)
   ulong B, B2;

   // sh1 and inv1 are respectively ell-1 and m' from Figure 4.1 of [GM94]
   unsigned sh1;
   ulong inv1;

   // sh2, sh3, inv2 and m_norm are respectively N-ell, ell-1, m', d_norm
   // from Figure 8.1 of [GM94]
   unsigned sh2, sh3;
   ulong inv2, m_norm;

   // inv3 = n^(-1) mod B (only valid if m is odd)
   ulong inv3;
}
zn_mod_struct;

# 121 "./include/zn_poly.h"
typedef zn_mod_struct zn_mod_t[1];

# 164 "./include/zn_poly.h"
static inline ulong
zn_mod_add (ulong x, ulong y, const zn_mod_t mod)
{
   ((void) (0));

   ulong temp = mod->m - y;
   if (x < temp)
      return x + y;
   else
      return x - temp;
}

# 201 "./include/zn_poly.h"
static inline ulong
zn_mod_sub (ulong x, ulong y, const zn_mod_t mod)
{
   ((void) (0));

   ulong temp = x - y;
   if (x < y)
      temp += mod->m;
   return temp;
}

# 216 "./include/zn_poly.h"
static inline ulong
zn_mod_sub_slim (ulong x, ulong y, const zn_mod_t mod)
{
   ((void) (0));
   ((void) (0));

   long temp = x - y;
   temp += (temp < 0) ? mod->m : 0;
   return temp;
}

# 267 "./include/zn_poly.h"
static inline ulong
zn_mod_quotient (ulong x, const zn_mod_t mod)
{
   ulong t;
   do { unsigned long __dummy; __asm__ ("mull %3" : "=a" (__dummy), "=d" ((t)) : "%0" ((x)), "rm" ((mod->inv1)));; } while (0);
   return (t + ((x - t) >> 1)) >> mod->sh1;
}

# 295 "./include/zn_poly.h"
static inline ulong
zn_mod_reduce_redc (ulong x, const zn_mod_t mod)
{
   ((void) (0));

   ulong y = x * mod->inv3;
   ulong z;
   do { unsigned long __dummy; __asm__ ("mull %3" : "=a" (__dummy), "=d" ((z)) : "%0" ((y)), "rm" ((mod->m)));; } while (0);
   return z;
}

# 315 "./include/zn_poly.h"
static inline ulong
zn_mod_reduce_wide (ulong x1, ulong x0, const zn_mod_t mod)
{
   ((void) (0));

   ulong y1 = (x1 << mod->sh2) + ((x0 >> 1) >> mod->sh3);
   ulong y0 = (x0 << mod->sh2);

   ulong sign = y0 >> (32 - 1);
   ulong z0 = y0 + (mod->m_norm & -sign);

   ulong a1, a0;
   __asm__ ("mull %3" : "=a" (a0), "=d" (a1) : "%0" (mod->inv2), "rm" (y1 + sign));;
   __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (a1), "=&r" (a0) : "0" ((unsigned long)(a1)), "g" ((unsigned long)(y1)), "%1" ((unsigned long)(a0)), "g" ((unsigned long)(z0)));

   ulong b1, b0;
   __asm__ ("mull %3" : "=a" (b0), "=d" (b1) : "%0" ((-a1 - 1)), "rm" (mod->m));;
   __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (b1), "=&r" (b0) : "0" ((unsigned long)(b1)), "g" ((unsigned long)(x1)), "%1" ((unsigned long)(b0)), "g" ((unsigned long)(x0)));
   b1 -= mod->m;

   return b0 + (b1 & mod->m);
}

# 346 "./include/zn_poly.h"
static inline ulong
zn_mod_reduce_wide_redc (ulong x1, ulong x0, const zn_mod_t mod)
{
   ((void) (0));
   ((void) (0));

   ulong y = x0 * mod->inv3;
   ulong z;
   do { unsigned long __dummy; __asm__ ("mull %3" : "=a" (__dummy), "=d" ((z)) : "%0" ((y)), "rm" ((mod->m)));; } while (0);
   return zn_mod_sub (z, x1, mod);
}

# 366 "./include/zn_poly.h"
static inline ulong
zn_mod_reduce_wide_redc_slim (ulong x1, ulong x0, const zn_mod_t mod)
{
   ((void) (0));
   ((void) (0));

   ulong y = x0 * mod->inv3;
   ulong z;
   do { unsigned long __dummy; __asm__ ("mull %3" : "=a" (__dummy), "=d" ((z)) : "%0" ((y)), "rm" ((mod->m)));; } while (0);
   return zn_mod_sub_slim (z, x1, mod);
}

# 384 "./include/zn_poly.h"
static inline ulong
zn_mod_reduce2 (ulong x1, ulong x0, const zn_mod_t mod)
{
   // first reduce into [0, Bm)
   ulong c0, c1;
   __asm__ ("mull %3" : "=a" (c0), "=d" (c1) : "%0" (x1), "rm" (mod->B));;
   __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (c1), "=&r" (c0) : "0" ((unsigned long)(c1)), "g" ((unsigned long)(0)), "%1" ((unsigned long)(c0)), "g" ((unsigned long)(x0)));
   // (must still have c1 < m)

   return zn_mod_reduce_wide (c1, c0, mod);
}

# 405 "./include/zn_poly.h"
static inline ulong
zn_mod_reduce2_redc (ulong x1, ulong x0, const zn_mod_t mod)
{
   ((void) (0));

   // first reduce into [0, Bm)
   ulong c0, c1;
   __asm__ ("mull %3" : "=a" (c0), "=d" (c1) : "%0" (x1), "rm" (mod->B));;
   __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (c1), "=&r" (c0) : "0" ((unsigned long)(c1)), "g" ((unsigned long)(0)), "%1" ((unsigned long)(c0)), "g" ((unsigned long)(x0)));
   // (must still have c1 < m)

   return zn_mod_reduce_wide_redc (c1, c0, mod);
}

# 425 "./include/zn_poly.h"
static inline ulong
zn_mod_reduce3 (ulong x2, ulong x1, ulong x0, const zn_mod_t mod)
{
   // reduce B^2*x2 and B*x1 into [0, Bm)
   ulong c0, c1, d0, d1;
   __asm__ ("mull %3" : "=a" (c0), "=d" (c1) : "%0" (x2), "rm" (mod->B2));;
   __asm__ ("mull %3" : "=a" (d0), "=d" (d1) : "%0" (x1), "rm" (mod->B));;

   // add B^2*x2 and B*x1 and x0 mod Bm
   __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (c1), "=&r" (c0) : "0" ((unsigned long)(c1)), "g" ((unsigned long)(0)), "%1" ((unsigned long)(c0)), "g" ((unsigned long)(d0)));
   // (must still have c1 < m)
   __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (c1), "=&r" (c0) : "0" ((unsigned long)(c1)), "g" ((unsigned long)(0)), "%1" ((unsigned long)(c0)), "g" ((unsigned long)(x0)));
   if (c1 >= mod->m)
      c1 -= mod->m;

   c1 = zn_mod_add (c1, d1, mod);

   // finally reduce it mod m
   return zn_mod_reduce_wide (c1, c0, mod);
}

# 455 "./include/zn_poly.h"
static inline ulong
zn_mod_reduce3_redc (ulong x2, ulong x1, ulong x0, const zn_mod_t mod)
{
   ((void) (0));

   // reduce B^2*x2 and B*x1 into [0, Bm)
   ulong c0, c1, d0, d1;
   __asm__ ("mull %3" : "=a" (c0), "=d" (c1) : "%0" (x2), "rm" (mod->B2));;
   __asm__ ("mull %3" : "=a" (d0), "=d" (d1) : "%0" (x1), "rm" (mod->B));;

   // add B^2*x2 and B*x1 and x0 mod Bm
   __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (c1), "=&r" (c0) : "0" ((unsigned long)(c1)), "g" ((unsigned long)(0)), "%1" ((unsigned long)(c0)), "g" ((unsigned long)(d0)));
   // (must still have c1 < m)
   __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (c1), "=&r" (c0) : "0" ((unsigned long)(c1)), "g" ((unsigned long)(0)), "%1" ((unsigned long)(c0)), "g" ((unsigned long)(x0)));
   if (c1 >= mod->m)
      c1 -= mod->m;

   c1 = zn_mod_add (c1, d1, mod);

   // finally reduce it mod m
   return zn_mod_reduce_wide_redc (c1, c0, mod);
}

# 485 "./include/zn_poly.h"
static inline ulong
zn_mod_mul (ulong x, ulong y, const zn_mod_t mod)
{
   ((void) (0));

   ulong hi, lo;
   __asm__ ("mull %3" : "=a" (lo), "=d" (hi) : "%0" (x), "rm" (y));;
   return zn_mod_reduce_wide (hi, lo, mod);
}

# 501 "./include/zn_poly.h"
static inline ulong
zn_mod_mul_redc (ulong x, ulong y, const zn_mod_t mod)
{
   ((void) (0));
   ((void) (0));

   ulong hi, lo;
   __asm__ ("mull %3" : "=a" (lo), "=d" (hi) : "%0" (x), "rm" (y));;
   return zn_mod_reduce_wide_redc (hi, lo, mod);
}

# 518 "./include/zn_poly.h"
static inline ulong
zn_mod_mul_redc_slim (ulong x, ulong y, const zn_mod_t mod)
{
   ((void) (0));
   ((void) (0));
   ((void) (0));

   ulong hi, lo;
   __asm__ ("mull %3" : "=a" (lo), "=d" (hi) : "%0" (x), "rm" (y));;
   return zn_mod_reduce_wide_redc_slim (hi, lo, mod);
}

# 295 "src/ks_support.c"
void
ZNP_zn_array_recover_reduce3 (ulong* res, ptrdiff_t s, const ulong* op1,
                          const ulong* op2, size_t n, unsigned b,
                          int redc, const zn_mod_t mod)
{
   ((void) (0));

   // The main loop is the same as in zn_array_recover_reduce1(), but needs
   // to operate on double-word quantities everywhere, i.e. we simulate
   // double-word registers. The suffixes L and H stand for low and high words
   // of each.

   ulong maskL = -1UL;
   ulong maskH = (1UL << (b - 32)) - 1;

   ulong x1L, x0L = *op1++;
   ulong x1H, x0H = *op1++;

   op2 += 2 * n + 1;
   ulong y0H, y1H = *op2--;
   ulong y0L, y1L = *op2--;

   ulong borrow = 0;

   unsigned b1 = b - 32;
   unsigned b2 = 2 * 32 - b;

   if (redc)
   {
      // REDC version
      for (; n; n--)
      {
         y0H = *op2--;
         y0L = *op2--;
         x1L = *op1++;
         x1H = *op1++;
         if ((y0H < x0H) || (y0H == x0H && y0L < x0L))
         {
            ((void) (0));
            y1H -= (y1L-- == 0);
         }

         *res = zn_mod_reduce3_redc ((y1H << b1) + (y1L >> b2),
                                     (y1L << b1) + x0H, x0L, mod);
         res += s;

         ((void) (0));
         if (borrow)
            y1H += (++y1L == 0);
         borrow = ((x1H < y1H) || (x1H == y1H && x1L < y1L));
         __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (x1H), "=&r" (x1L) : "0" ((unsigned long)(x1H)), "g" ((unsigned long)(y1H)), "1" ((unsigned long)(x1L)), "g" ((unsigned long)(y1L)));
         __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (y1H), "=&r" (y1L) : "0" ((unsigned long)(y0H)), "g" ((unsigned long)(x0H)), "1" ((unsigned long)(y0L)), "g" ((unsigned long)(x0L)));
         y1H &= maskH;
         x0L = x1L;
         x0H = x1H & maskH;
      }
   }
   else
   {
      // plain reduction version
      for (; n; n--)
      {
         y0H = *op2--;
         y0L = *op2--;
         x1L = *op1++;
         x1H = *op1++;
         if ((y0H < x0H) || (y0H == x0H && y0L < x0L))
         {
            ((void) (0));
            y1H -= (y1L-- == 0);
         }

         *res = zn_mod_reduce3 ((y1H << b1) + (y1L >> b2),
                                (y1L << b1) + x0H, x0L, mod);
         res += s;

         ((void) (0));
         if (borrow)
            y1H += (++y1L == 0);
         borrow = ((x1H < y1H) || (x1H == y1H && x1L < y1L));
         __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (x1H), "=&r" (x1L) : "0" ((unsigned long)(x1H)), "g" ((unsigned long)(y1H)), "1" ((unsigned long)(x1L)), "g" ((unsigned long)(y1L)));
         __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (y1H), "=&r" (y1L) : "0" ((unsigned long)(y0H)), "g" ((unsigned long)(x0H)), "1" ((unsigned long)(y0L)), "g" ((unsigned long)(x0L)));
         y1H &= maskH;
         x0L = x1L;
         x0H = x1H & maskH;
      }
   }
}

# 93 "src/array.c"
void
ZNP__zn_array_scalar_mul_redc_v2 (ulong* res, const ulong* op, size_t n, ulong x,
                              const zn_mod_t mod)
{
   ((void) (0));
   ((void) (0));
   ((void) (0));

   for (; n; n--, op++, res++)
   {
      ulong hi, lo;
      __asm__ ("mull %3" : "=a" (lo), "=d" (hi) : "%0" (*op), "rm" (x));;
      *res = zn_mod_reduce_wide_redc_slim (hi, lo, mod);
   }
}

# 116 "src/array.c"
void
ZNP__zn_array_scalar_mul_redc_v3 (ulong* res, const ulong* op, size_t n, ulong x,
                              const zn_mod_t mod)
{
   ((void) (0));
   ((void) (0));

   for (; n; n--, op++, res++)
   {
      ulong hi, lo;
      __asm__ ("mull %3" : "=a" (lo), "=d" (hi) : "%0" (*op), "rm" (x));;
      *res = zn_mod_reduce_wide_redc (hi, lo, mod);
   }
}

# 181 "src/array.c"
void
ZNP__zn_array_scalar_mul_plain_v2 (ulong* res, const ulong* op, size_t n, ulong x,
                               const zn_mod_t mod)
{
   ((void) (0));

   for (; n; n--, op++, res++)
   {
      ulong hi, lo;
      __asm__ ("mull %3" : "=a" (lo), "=d" (hi) : "%0" (*op), "rm" (x));;
      *res = zn_mod_reduce_wide (hi, lo, mod);
   }
}

# 69 "/usr/include/assert.h"
extern void __assert_fail (const char *__assertion, const char *__file,
      unsigned int __line, const char *__function);

# 311 "src/mulmid_ks.c"
ulong
ZNP_diagonal_sum (ulong* res, const ulong* op1, const ulong* op2,
              size_t n, unsigned w, int redc, const zn_mod_t mod)
{
   ((n >= 1) ? (void) (0) : __assert_fail ("n >= 1", "src/mulmid_ks.c", 315, __PRETTY_FUNCTION__));
   ((w >= 1) ? (void) (0) : __assert_fail ("w >= 1", "src/mulmid_ks.c", 316, __PRETTY_FUNCTION__));
   ((w <= 3) ? (void) (0) : __assert_fail ("w <= 3", "src/mulmid_ks.c", 317, __PRETTY_FUNCTION__));

   size_t i;

   if (w == 1)
   {
      ulong sum = op1[0] * op2[n - 1];

      for (i = 1; i < n; i++)
         sum += op1[i] * op2[n - 1 - i];

      res[0] = sum;
      return redc ? zn_mod_reduce_redc (sum, mod) : zn_mod_reduce (sum, mod);
   }
   else if (w == 2)
   {
      ulong lo, hi, sum0, sum1;

      __asm__ ("mull %3" : "=a" (sum0), "=d" (sum1) : "%0" (op1[0]), "rm" (op2[n - 1]));;

      for (i = 1; i < n; i++)
      {
         __asm__ ("mull %3" : "=a" (lo), "=d" (hi) : "%0" (op1[i]), "rm" (op2[n - 1 - i]));;
         __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (sum1), "=&r" (sum0) : "0" ((unsigned long)(sum1)), "g" ((unsigned long)(hi)), "%1" ((unsigned long)(sum0)), "g" ((unsigned long)(lo)));
      }

      res[0] = sum0;
      res[1] = sum1;
      return redc ? zn_mod_reduce2_redc (sum1, sum0, mod)
                  : zn_mod_reduce2 (sum1, sum0, mod);
   }
   else // w == 3
   {
      ulong lo, hi, sum0, sum1, sum2 = 0;

      __asm__ ("mull %3" : "=a" (sum0), "=d" (sum1) : "%0" (op1[0]), "rm" (op2[n - 1]));;

      for (i = 1; i < n; i++)
      {
         __asm__ ("mull %3" : "=a" (lo), "=d" (hi) : "%0" (op1[i]), "rm" (op2[n - 1 - i]));;
         __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (sum1), "=&r" (sum0) : "0" ((unsigned long)(sum1)), "g" ((unsigned long)(hi)), "%1" ((unsigned long)(sum0)), "g" ((unsigned long)(lo)));
         // carry into third limb:
         if (sum1 <= hi)
            sum2 += (sum1 < hi || sum0 < lo);
      }

      res[0] = sum0;
      res[1] = sum1;
      res[2] = sum2;
      return redc ? zn_mod_reduce3_redc (sum2, sum1, sum0, mod)
                  : zn_mod_reduce3 (sum2, sum1, sum0, mod);
   }
}

# 143 "/usr/include/i386-linux-gnu/gmp.h"
typedef unsigned long int mp_limb_t;

# 168 "/usr/include/i386-linux-gnu/gmp.h"
typedef mp_limb_t * mp_ptr;

# 169 "/usr/include/i386-linux-gnu/gmp.h"
typedef const mp_limb_t * mp_srcptr;

# 177 "/usr/include/i386-linux-gnu/gmp.h"
typedef long int mp_size_t;

# 1473 "/usr/include/i386-linux-gnu/gmp.h"
mp_limb_t __gmpn_add_n (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);

# 1476 "/usr/include/i386-linux-gnu/gmp.h"
mp_limb_t __gmpn_addmul_1 (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t);

# 1535 "/usr/include/i386-linux-gnu/gmp.h"
mp_limb_t __gmpn_mul_1 (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t);

# 1604 "/usr/include/i386-linux-gnu/gmp.h"
mp_limb_t __gmpn_sub_n (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);

# 2123 "/usr/include/i386-linux-gnu/gmp.h"
extern __inline__

mp_limb_t
__gmpn_add (mp_ptr __gmp_wp, mp_srcptr __gmp_xp, mp_size_t __gmp_xsize, mp_srcptr __gmp_yp, mp_size_t __gmp_ysize)
{
  mp_limb_t __gmp_c;
  do { mp_size_t __gmp_i; mp_limb_t __gmp_x; /* ASSERT ((ysize) >= 0); */ /* ASSERT ((xsize) >= (ysize)); */ /* ASSERT (MPN_SAME_OR_SEPARATE2_P (wp, xsize, xp, xsize)); */ /* ASSERT (MPN_SAME_OR_SEPARATE2_P (wp, xsize, yp, ysize)); */ __gmp_i = (__gmp_ysize); if (__gmp_i != 0) { if (__gmpn_add_n (__gmp_wp, __gmp_xp, __gmp_yp, __gmp_i)) { do { if (__gmp_i >= (__gmp_xsize)) { (__gmp_c) = 1; goto __gmp_done; } __gmp_x = (__gmp_xp)[__gmp_i]; } while ((((__gmp_wp)[__gmp_i++] = (__gmp_x + 1) & ((~ ((mp_limb_t) (0))) >> 0)) == 0)); } } if ((__gmp_wp) != (__gmp_xp)) do { mp_size_t __gmp_j; /* ASSERT ((size) >= 0); */ /* ASSERT ((start) >= 0); */ /* ASSERT ((start) <= (size)); */ /* ASSERT (MPN_SAME_OR_SEPARATE_P (dst, src, size)); */ ; for (__gmp_j = (__gmp_i); __gmp_j < (__gmp_xsize); __gmp_j++) (__gmp_wp)[__gmp_j] = (__gmp_xp)[__gmp_j]; } while (0); (__gmp_c) = 0; __gmp_done: ; } while (0);
  return __gmp_c;
}

# 2136 "/usr/include/i386-linux-gnu/gmp.h"
extern __inline__

mp_limb_t
__gmpn_add_1 (mp_ptr __gmp_dst, mp_srcptr __gmp_src, mp_size_t __gmp_size, mp_limb_t __gmp_n)
{
  mp_limb_t __gmp_c;
  do { mp_size_t __gmp_i; mp_limb_t __gmp_x, __gmp_r; /* ASSERT ((n) >= 1); */ /* ASSERT (MPN_SAME_OR_SEPARATE_P (dst, src, n)); */ __gmp_x = (__gmp_src)[0]; __gmp_r = __gmp_x + (__gmp_n); (__gmp_dst)[0] = __gmp_r; if (((__gmp_r) < ((__gmp_n)))) { (__gmp_c) = 1; for (__gmp_i = 1; __gmp_i < (__gmp_size);) { __gmp_x = (__gmp_src)[__gmp_i]; __gmp_r = __gmp_x + 1; (__gmp_dst)[__gmp_i] = __gmp_r; ++__gmp_i; if (!((__gmp_r) < (1))) { if ((__gmp_src) != (__gmp_dst)) do { mp_size_t __gmp_j; /* ASSERT ((size) >= 0); */ /* ASSERT ((start) >= 0); */ /* ASSERT ((start) <= (size)); */ /* ASSERT (MPN_SAME_OR_SEPARATE_P (dst, src, size)); */ ; for (__gmp_j = (__gmp_i); __gmp_j < (__gmp_size); __gmp_j++) (__gmp_dst)[__gmp_j] = (__gmp_src)[__gmp_j]; } while (0); (__gmp_c) = 0; break; } } } else { if ((__gmp_src) != (__gmp_dst)) do { mp_size_t __gmp_j; /* ASSERT ((size) >= 0); */ /* ASSERT ((start) >= 0); */ /* ASSERT ((start) <= (size)); */ /* ASSERT (MPN_SAME_OR_SEPARATE_P (dst, src, size)); */ ; for (__gmp_j = (1); __gmp_j < (__gmp_size); __gmp_j++) (__gmp_dst)[__gmp_j] = (__gmp_src)[__gmp_j]; } while (0); (__gmp_c) = 0; } } while (0);
  return __gmp_c;
}

# 2149 "/usr/include/i386-linux-gnu/gmp.h"
extern __inline__

int
__gmpn_cmp (mp_srcptr __gmp_xp, mp_srcptr __gmp_yp, mp_size_t __gmp_size)
{
  int __gmp_result;
  do { mp_size_t __gmp_i; mp_limb_t __gmp_x, __gmp_y; /* ASSERT ((size) >= 0); */ (__gmp_result) = 0; __gmp_i = (__gmp_size); while (--__gmp_i >= 0) { __gmp_x = (__gmp_xp)[__gmp_i]; __gmp_y = (__gmp_yp)[__gmp_i]; if (__gmp_x != __gmp_y) { /* Cannot use __gmp_x - __gmp_y, may overflow an "int" */ (__gmp_result) = (__gmp_x > __gmp_y ? 1 : -1); break; } } } while (0);
  return __gmp_result;
}

# 2162 "/usr/include/i386-linux-gnu/gmp.h"
extern __inline__

mp_limb_t
__gmpn_sub (mp_ptr __gmp_wp, mp_srcptr __gmp_xp, mp_size_t __gmp_xsize, mp_srcptr __gmp_yp, mp_size_t __gmp_ysize)
{
  mp_limb_t __gmp_c;
  do { mp_size_t __gmp_i; mp_limb_t __gmp_x; /* ASSERT ((ysize) >= 0); */ /* ASSERT ((xsize) >= (ysize)); */ /* ASSERT (MPN_SAME_OR_SEPARATE2_P (wp, xsize, xp, xsize)); */ /* ASSERT (MPN_SAME_OR_SEPARATE2_P (wp, xsize, yp, ysize)); */ __gmp_i = (__gmp_ysize); if (__gmp_i != 0) { if (__gmpn_sub_n (__gmp_wp, __gmp_xp, __gmp_yp, __gmp_i)) { do { if (__gmp_i >= (__gmp_xsize)) { (__gmp_c) = 1; goto __gmp_done; } __gmp_x = (__gmp_xp)[__gmp_i]; } while ((((__gmp_wp)[__gmp_i++] = (__gmp_x - 1) & ((~ ((mp_limb_t) (0))) >> 0)), __gmp_x == 0)); } } if ((__gmp_wp) != (__gmp_xp)) do { mp_size_t __gmp_j; /* ASSERT ((size) >= 0); */ /* ASSERT ((start) >= 0); */ /* ASSERT ((start) <= (size)); */ /* ASSERT (MPN_SAME_OR_SEPARATE_P (dst, src, size)); */ ; for (__gmp_j = (__gmp_i); __gmp_j < (__gmp_xsize); __gmp_j++) (__gmp_wp)[__gmp_j] = (__gmp_xp)[__gmp_j]; } while (0); (__gmp_c) = 0; __gmp_done: ; } while (0);
  return __gmp_c;
}

# 2175 "/usr/include/i386-linux-gnu/gmp.h"
extern __inline__

mp_limb_t
__gmpn_sub_1 (mp_ptr __gmp_dst, mp_srcptr __gmp_src, mp_size_t __gmp_size, mp_limb_t __gmp_n)
{
  mp_limb_t __gmp_c;
  do { mp_size_t __gmp_i; mp_limb_t __gmp_x, __gmp_r; /* ASSERT ((n) >= 1); */ /* ASSERT (MPN_SAME_OR_SEPARATE_P (dst, src, n)); */ __gmp_x = (__gmp_src)[0]; __gmp_r = __gmp_x - (__gmp_n); (__gmp_dst)[0] = __gmp_r; if (((__gmp_x) < ((__gmp_n)))) { (__gmp_c) = 1; for (__gmp_i = 1; __gmp_i < (__gmp_size);) { __gmp_x = (__gmp_src)[__gmp_i]; __gmp_r = __gmp_x - 1; (__gmp_dst)[__gmp_i] = __gmp_r; ++__gmp_i; if (!((__gmp_x) < (1))) { if ((__gmp_src) != (__gmp_dst)) do { mp_size_t __gmp_j; /* ASSERT ((size) >= 0); */ /* ASSERT ((start) >= 0); */ /* ASSERT ((start) <= (size)); */ /* ASSERT (MPN_SAME_OR_SEPARATE_P (dst, src, size)); */ ; for (__gmp_j = (__gmp_i); __gmp_j < (__gmp_size); __gmp_j++) (__gmp_dst)[__gmp_j] = (__gmp_src)[__gmp_j]; } while (0); (__gmp_c) = 0; break; } } } else { if ((__gmp_src) != (__gmp_dst)) do { mp_size_t __gmp_j; /* ASSERT ((size) >= 0); */ /* ASSERT ((start) >= 0); */ /* ASSERT ((start) <= (size)); */ /* ASSERT (MPN_SAME_OR_SEPARATE_P (dst, src, size)); */ ; for (__gmp_j = (1); __gmp_j < (__gmp_size); __gmp_j++) (__gmp_dst)[__gmp_j] = (__gmp_src)[__gmp_j]; } while (0); (__gmp_c) = 0; } } while (0);
  return __gmp_c;
}

# 466 "/usr/include/stdlib.h"
extern void *malloc (size_t __size);

# 483 "/usr/include/stdlib.h"
extern void free (void *__ptr);

# 186 "./include/zn_poly_internal.h"
extern size_t
ZNP_mpn_smp_kara_thresh;

# 27 "src/mpn_mulmid.c"
void
ZNP_mpn_smp_basecase (mp_limb_t* res,
                      const mp_limb_t* op1, size_t n1,
                      const mp_limb_t* op2, size_t n2)
{
   ((void) (0));
   ((void) (0));



   mp_limb_t hi0, hi1, hi;
   size_t s, j;

   j = n2 - 1;
   s = n1 - j;
   op2 += j;

   hi0 = __gmpn_mul_1 (res, op1, s, *op2);
   hi1 = 0;

   for (op1++, op2--; j; j--, op1++, op2--)
   {
      hi = __gmpn_addmul_1 (res, op1, s, *op2);
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (hi1), "=&r" (hi0) : "0" ((unsigned long)(hi1)), "g" ((unsigned long)(0)), "%1" ((unsigned long)(hi0)), "g" ((unsigned long)(hi)));
   }

   res[s] = hi0;
   res[s + 1] = hi1;




}

# 85 "src/mpn_mulmid.c"
int
ZNP_bilinear2_sub_fixup (mp_limb_t* hi, mp_limb_t* lo, mp_limb_t* res,
                     const mp_limb_t* op1, const mp_limb_t* op2,
                     const mp_limb_t* op3, size_t n)
{
   ((void) (0));



   int sign = 0;
   if (__gmpn_cmp (op2, op3, n) < 0)
   {
      // swap y and z if necessary
      const mp_limb_t* temp = op2;
      op2 = op3;
      op3 = temp;
      sign = 1;
   }
   // now can assume y >= z

   // The correction term is computed as follows. Let
   //
   //    y_0     - z_0                =  u_0     - c_0 B,
   //    y_1     - z_1     - c_0      =  u_1     - c_1 B,
   //    y_2     - z_2     - c_1      =  u_2     - c_2 B,
   //                                ...
   //    y_{n-1} - z_{n-1} - c_{n-2}  =  u_{n-1},
   //
   // i.e. where c_j is the borrow (0 or 1) from the j-th limb of the
   // subtraction y - z, and where u_j is the j-th digit of y - z. Note
   // that c_{-1} = c_{n-1} = 0. By definition we want to compute
   //
   //    \sum_{0 <= i < 2n-1, 0 <= j < n, n-1 <= i+j < 2n-1}
   //                                  (c_{j-1} - c_j B) x_i B^{i+j-(n-1)}
   //
   // After some algebra this collapses down to
   //
   //    \sum_{0 <= i < n-1} c_i (x_{n-2-i} - B^n x_{2n-2-i}).

   // First compute y - z using mpn_sub_n (fast)
   __gmpn_sub_n (res, op2, op3, n);

   // Now loop through and figure out where the borrows happened
   size_t i;
   mp_limb_t hi0 = 0, hi1 = 0;
   mp_limb_t lo0 = 0, lo1 = 0;

   for (i = n - 1; i; i--, op1++)
   {
      mp_limb_t borrow = res[i] - op2[i] + op3[i];
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (lo1), "=&r" (lo0) : "0" ((unsigned long)(lo1)), "g" ((unsigned long)(0)), "%1" ((unsigned long)(lo0)), "g" ((unsigned long)(borrow & op1[0])));
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (hi1), "=&r" (hi0) : "0" ((unsigned long)(hi1)), "g" ((unsigned long)(0)), "%1" ((unsigned long)(hi0)), "g" ((unsigned long)(borrow & op1[n])));
   }

   hi[0] = hi0;
   hi[1] = hi1;
   lo[0] = lo0;
   lo[1] = lo1;

   return sign;



}

# 169 "src/mpn_mulmid.c"
void
ZNP_bilinear1_add_fixup (mp_limb_t* hi, mp_limb_t* lo, mp_limb_t* res,
                     const mp_limb_t* op1, const mp_limb_t* op2,
                     const mp_limb_t* op3, size_t n)
{
   ((void) (0));



   // The correction term is computed as follows. Let
   //
   //    x_0      + y_0                  =  u_0      + c_0 B,
   //    x_1      + y_1      + c_0       =  u_1      + c_1 B,
   //    x_2      + y_2      + c_1       =  u_2      + c_2 B,
   //                                   ...
   //    x_{2n-2} + y_{2n-2} + c_{2n-3}  =  u_{2n-2} + c_{2n-1} B,
   //
   // i.e. where c_j is the carry (0 or 1) from the j-th limb of the
   // addition x + y, and u_j is the j-th digit of x + y. Note that
   // c_{-1} = 0. By definition we want to compute
   //
   //    \sum_{0 <= i < 2n-1, 0 <= j < n, n-1 <= i+j < 2n-1}
   //                                  (c_i B - c_{i-1}) z_j B^{i+j-(n-1)}
   //
   // After some algebra this collapses down to
   //
   //     -\sum_{0 <= j < n-1}    c_j z_{n-2-j}  +
   //  B^n \sum_{n-1 <= j < 2n-1} c_j z_{2n-2-j}.

   // First compute x + y using mpn_add_n (fast)
   mp_limb_t last_carry = __gmpn_add_n (res, op1, op2, 2*n - 1);

   // Now loop through and figure out where the carries happened
   size_t j;
   mp_limb_t fix0 = 0, fix1 = 0;
   op3 += n - 2;

   for (j = 0; j < n - 1; j++, op3--)
   {
      // carry = -1 if there was a carry in the j-th limb addition
      mp_limb_t carry = op1[j+1] + op2[j+1] - res[j+1];
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (fix1), "=&r" (fix0) : "0" ((unsigned long)(fix1)), "g" ((unsigned long)(0)), "%1" ((unsigned long)(fix0)), "g" ((unsigned long)(carry & *op3)));
   }

   lo[0] = fix0;
   lo[1] = fix1;

   fix0 = fix1 = 0;
   op3 += n;

   for (; j < 2*n - 2; j++, op3--)
   {
      // carry = -1 if there was a carry in the j-th limb addition
      mp_limb_t carry = op1[j+1] + op2[j+1] - res[j+1];
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (fix1), "=&r" (fix0) : "0" ((unsigned long)(fix1)), "g" ((unsigned long)(0)), "%1" ((unsigned long)(fix0)), "g" ((unsigned long)(carry & *op3)));
   }

   __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (fix1), "=&r" (fix0) : "0" ((unsigned long)(fix1)), "g" ((unsigned long)(0)), "%1" ((unsigned long)(fix0)), "g" ((unsigned long)((-last_carry) & *op3)));

   hi[0] = fix0;
   hi[1] = fix1;



}

# 237 "src/mpn_mulmid.c"
void
ZNP_mpn_smp_kara (mp_limb_t* res, const mp_limb_t* op1, const mp_limb_t* op2,
                  size_t n)
{
   ((void) (0));

   if (n & 1)
   {
      // If n is odd, we strip off the bottom row and last diagonal and
      // handle them separately at the end (stuff marked O in the diagram
      // below); the remainder gets handled via karatsuba (stuff marked E):

      // EEEEO....
      // .EEEEO...
      // ..EEEEO..
      // ...EEEEO.
      // ....OOOOO

      op2++;
   }

   size_t k = n / 2;

   size_t __FASTALLOC_request_temp = (2 * k + 2); mp_limb_t* temp; mp_limb_t __FASTALLOC_temp [6642]; if (__FASTALLOC_request_temp <= (6642)) temp = __FASTALLOC_temp; else temp = (mp_limb_t*) malloc (sizeof (mp_limb_t) * __FASTALLOC_request_temp);;

   mp_limb_t hi[2], lo[2];

   // The following diagram shows the contributions from various regions
   // for k = 3:

   //  AAABBB.....
   //  .AAABBB....
   //  ..AAABBB...
   //  ...CCCDDD..
   //  ....CCCDDD.
   //  .....CCCDDD

   // ------------------------------------------------------------------------
   // Step 1: compute contribution from A + contribution from B

   // Let x = op1[0, 2*k-1)
   //     y = op1[k, 3*k-1)
   //     z = op2[k, 2*k).

   // Need to compute SMP(x, z) + SMP(y, z). To do this, we will compute
   // SMP((x + y) mod B^(2k-1), z) and a correction term.

   // First compute x + y mod B^(2k-1) and the correction term.
   ZNP_bilinear1_add_fixup (hi, lo, temp, op1, op1 + k, op2 + k, k);

   // Now compute SMP(x + y mod B^(2k-1), z).
   // Store result in first half of output.
   if (k < ZNP_mpn_smp_kara_thresh)
      ZNP_mpn_smp_basecase (res, temp, 2 * k - 1, op2 + k, k);
   else
      ZNP_mpn_smp_kara (res, temp, op2 + k, k);

   // Add in the correction term.
   __gmpn_sub (res, res, k + 2, lo, 2);
   __gmpn_add_n (res + k, res + k, hi, 2);

   // Save the last two limbs (they're about to get overwritten)
   mp_limb_t saved[2];
   saved[0] = res[k];
   saved[1] = res[k + 1];

   // ------------------------------------------------------------------------
   // Step 2: compute contribution from C + contribution from D

   // Let x = op1[k, 3*k-1)
   //     y = op1[2*k, 4*k-1)
   //     z = op2[0, k).

   // Need to compute SMP(x, z) + SMP(y, z). To do this, we will compute
   // SMP((x + y) mod B^(2k-1), z) and a correction term.

   // First compute x + y mod B^(2k-1) and the correction term.
   ZNP_bilinear1_add_fixup (hi, lo, temp, op1 + k, op1 + 2 * k, op2, k);

   // Now compute SMP(x + y mod B^(2k-1), z).
   // Store result in second half of output.
   if (k < ZNP_mpn_smp_kara_thresh)
      ZNP_mpn_smp_basecase (res + k, temp, 2 * k - 1, op2, k);
   else
      ZNP_mpn_smp_kara (res + k, temp, op2, k);

   // Add in the correction term.
   __gmpn_sub (res + k, res + k, k + 2, lo, 2);
   __gmpn_add_n (res + 2 * k, res + 2 * k, hi, 2);

   // Add back the saved limbs.
   __gmpn_add (res + k, res + k, k + 2, saved, 2);

   // ------------------------------------------------------------------------
   // Step 3: compute contribution from B - contribution from C

   // Let x = op1[k, 3*k-1)
   //     y = op2[k, 2*k).
   //     z = op2[0, k)

   // Need to compute SMP(x, y) - SMP(x, z). To do this, we will compute
   // SMP(x, abs(y - z)), and a correction term.

   // First compute abs(y - z) and the correction term.
   int sign = ZNP_bilinear2_sub_fixup (hi, lo, temp, op1 + k, op2 + k, op2, k);

   // Now compute SMP(x, abs(y - z)).
   // Store it in second half of temp space, in two's complement (mod B^(k+2))
   if (k < ZNP_mpn_smp_kara_thresh)
      ZNP_mpn_smp_basecase (temp + k, op1 + k, 2 * k - 1, temp, k);
   else
      ZNP_mpn_smp_kara (temp + k, op1 + k, temp, k);

   // Add in the correction term.
   __gmpn_add (temp + k, temp + k, k + 2, lo, 2);
   mp_limb_t borrow = __gmpn_sub_n (temp + 2 * k, temp + 2 * k, hi, 2);

   // ------------------------------------------------------------------------
   // Step 4: put the pieces together

   // First half of output is A + C = t4 - t2
   // Second half of output is B + D = t6 + t2
   if (sign)
   {
      __gmpn_add (res, res, 2 * k + 2, temp + k, k + 2);
      __gmpn_sub_1 (res + k + 2, res + k + 2, k, borrow);
      __gmpn_sub (res + k, res + k, k + 2, temp + k, k + 2);
   }
   else
   {
      __gmpn_sub (res, res, 2 * k + 2, temp + k, k + 2);
      __gmpn_add_1 (res + k + 2, res + k + 2, k, borrow);
      __gmpn_add (res + k, res + k, k + 2, temp + k, k + 2);
   }

   // ------------------------------------------------------------------------
   // Step 5: add in correction if the length was odd



   if (n & 1)
   {
      op2--;

      mp_limb_t hi0 = __gmpn_addmul_1 (res, op1 + n - 1, n, *op2);
      mp_limb_t hi1 = 0, lo0 = 0, lo1 = 0;

      size_t i;
      for (i = n - 1; i; i--)
      {
         mp_limb_t y0, y1;
         __asm__ ("mull %3" : "=a" (y0), "=d" (y1) : "%0" (op1[2 * n - i - 2]), "rm" (op2[i]));;
         __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (hi1), "=&r" (hi0) : "0" ((unsigned long)(hi1)), "g" ((unsigned long)(0)), "%1" ((unsigned long)(hi0)), "g" ((unsigned long)(y1)));
         __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (lo1), "=&r" (lo0) : "0" ((unsigned long)(lo1)), "g" ((unsigned long)(0)), "%1" ((unsigned long)(lo0)), "g" ((unsigned long)(y0)));
      }

      res[n + 1] = hi1;
      __gmpn_add_1 (res + n, res + n, 2, hi0);
      __gmpn_add_1 (res + n, res + n, 2, lo1);
      __gmpn_add_1 (res + n - 1, res + n - 1, 3, lo0);
   }

   if (temp != __FASTALLOC_temp) free (temp);;




}

