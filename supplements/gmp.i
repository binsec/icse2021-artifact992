void * __builtin_alloca (unsigned int);

# 143 "../gmp.h"
typedef unsigned long int mp_limb_t;

# 169 "../gmp.h"
typedef const mp_limb_t * mp_srcptr;

# 177 "../gmp.h"
typedef long int mp_size_t;

# 2981 "../gmp-impl.h"
mp_limb_t __gmpn_invert_limb (mp_limb_t);

# 159 "mod_1_1.c"
void
__gmpn_mod_1_1p_cps (mp_limb_t cps[4], mp_limb_t b)
{
  mp_limb_t bi;
  mp_limb_t B1modb, B2modb;
  int cnt;

  __asm__ ("clz\t%0, %1" : "=r" (cnt) : "r" (b));

  b <<= cnt;
  do { (bi) = __gmpn_invert_limb (b); } while (0);

  cps[0] = bi;
  cps[1] = cnt;

  B1modb = -b;
  if (__builtin_expect ((cnt != 0) != 0, 1))
    B1modb *= ((bi >> (32 -cnt)) | (((mp_limb_t) 1L) << cnt));
  do {} while (0); /* NB: not fully reduced mod b */
  cps[2] = B1modb >> cnt;

  /* In the normalized case, this can be simplified to
   *
   *   B2modb = - b * bi;
   *   ASSERT (B2modb <= b);    // NB: equality iff b = B/2
   */
  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((B1modb)), "r" ((bi))); if (__builtin_constant_p (((mp_limb_t) 0L)) && (((mp_limb_t) 0L)) == 0) { _r = ~(_qh + (B1modb)) * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((B1modb) + 1), "%r" (_ql), "rI" ((((mp_limb_t) 0L))) : "cc"); _r = (((mp_limb_t) 0L)) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (B2modb) = _r; } while (0);
  cps[3] = B2modb >> cnt;
}

# 189 "mod_1_1.c"
mp_limb_t
__gmpn_mod_1_1p (mp_srcptr ap, mp_size_t n, mp_limb_t b, const mp_limb_t bmodb[4])
{
  mp_limb_t rh, rl, bi, ph, pl, r;
  mp_limb_t B1modb, B2modb;
  mp_size_t i;
  int cnt;
  mp_limb_t mask;

  do {} while (0); /* fix tuneup.c if this is changed */

  B1modb = bmodb[2];
  B2modb = bmodb[3];

  rl = ap[n - 1];
  __asm__ ("umull %0,%1,%2,%3" : "=&r" (pl), "=&r" (ph) : "r" (rl), "r" (B1modb));
  __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (rh), "=&r" (rl) : "r" (ph), "rI" (((mp_limb_t) 0L)), "%r" (pl), "rI" (ap[n - 2]) : "cc");

  for (i = n - 3; i >= 0; i -= 1)
    {
      /* rr = ap[i]				< B
	    + LO(rr)  * (B mod b)		<= (B-1)(b-1)
	    + HI(rr)  * (B^2 mod b)		<= (B-1)(b-1)
      */
      __asm__ ("umull %0,%1,%2,%3" : "=&r" (pl), "=&r" (ph) : "r" (rl), "r" (B1modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (ph), "=&r" (pl) : "r" (ph), "rI" (((mp_limb_t) 0L)), "%r" (pl), "rI" (ap[i]) : "cc");

      __asm__ ("umull %0,%1,%2,%3" : "=&r" (rl), "=&r" (rh) : "r" (rh), "r" (B2modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (rh), "=&r" (rl) : "r" (rh), "rI" (ph), "%r" (rl), "rI" (pl) : "cc");
    }

  cnt = bmodb[1];
  bi = bmodb[0];

  if (__builtin_expect ((cnt != 0) != 0, 1))
    rh = (rh << cnt) | (rl >> (32 - cnt));

  mask = -(mp_limb_t) (rh >= b);
  rh -= mask & b;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((rh)), "r" ((bi))); if (__builtin_constant_p (rl << cnt) && (rl << cnt) == 0) { _r = ~(_qh + (rh)) * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((rh) + 1), "%r" (_ql), "rI" ((rl << cnt)) : "cc"); _r = (rl << cnt) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (r) = _r; } while (0);

  return r >> cnt;
}

# 168 "../gmp.h"
typedef mp_limb_t * mp_ptr;

# 1499 "../gmp.h"
mp_limb_t __gmpn_divrem_2 (mp_ptr, mp_size_t, mp_ptr, mp_size_t, mp_srcptr);

# 1550 "../gmp.h"
void __gmpn_com (mp_ptr, mp_srcptr, mp_size_t);

# 255 "../gmp-impl.h"
typedef struct {mp_limb_t inv32;} gmp_pi1_t;

# 1440 "../gmp-impl.h"
mp_limb_t __gmpn_sbpi1_divappr_q (mp_ptr, mp_ptr, mp_size_t, mp_srcptr, mp_size_t, mp_limb_t);

# 1451 "../gmp-impl.h"
mp_limb_t __gmpn_dcpi1_divappr_q (mp_ptr, mp_ptr, mp_size_t, mp_srcptr, mp_size_t, gmp_pi1_t *);

# 91 "invertappr.c"
static mp_limb_t
mpn_bc_invertappr (mp_ptr ip, mp_srcptr dp, mp_size_t n, mp_ptr tp)
{
  mp_ptr xp;

  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);

  /* Compute a base value of r limbs. */
  if (n == 1)
    do { (*ip) = __gmpn_invert_limb (*dp); } while (0);
  else {
    mp_size_t i;
    xp = tp + n + 2; /* 2 * n limbs */

    for (i = n - 1; i >= 0; i--)
      xp[i] = ((~ ((mp_limb_t) (0))) >> 0);
    __gmpn_com (xp + n, dp, n);

    /* Now xp contains B^2n - {dp,n}*B^n - 1 */

    /* FIXME: if mpn_*pi1_divappr_q handles n==2, use it! */
    if (n == 2) {
      __gmpn_divrem_2 (ip, 0, xp, 4, dp);
    } else {
      gmp_pi1_t inv;
      do { mp_limb_t _v, _p, _t1, _t0, _mask; do { (_v) = __gmpn_invert_limb (dp[n-1]); } while (0); _p = (dp[n-1]) * _v; _p += (dp[n-2]); if (_p < (dp[n-2])) { _v--; _mask = -(mp_limb_t) (_p >= (dp[n-1])); _p -= (dp[n-1]); _v += _mask; _p -= _mask & (dp[n-1]); } __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" (dp[n-2]), "r" (_v)); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (dp[n-1])) != 0, 0)) { if (_p > (dp[n-1]) || _t0 >= (dp[n-2])) _v--; } } (inv).inv32 = _v; } while (0);
      if (! (474 < 494)
   || (! ((__builtin_constant_p (494) && (494) == 0) || (!(__builtin_constant_p (494) && (494) == 0x7fffffffL) && (n) >= (494)))))
 __gmpn_sbpi1_divappr_q (ip, xp, 2 * n, dp, n, inv.inv32);
      else
 __gmpn_dcpi1_divappr_q (ip, xp, 2 * n, dp, n, &inv);
      do { mp_limb_t __x; mp_ptr __p = (ip); if (__builtin_constant_p (1) && (1) == 1) { while ((*(__p++))-- == 0) ; } else { __x = *__p; *__p = __x - (1); if (__x < (1)) while ((*(++__p))-- == 0) ; } } while (0);
      return 1;
    }
  }
  return 0;
}

# 216 "/usr/lib/gcc-cross/arm-linux-gnueabi/5/include/stddef.h"
typedef unsigned int size_t;

# 152 "../gmp.h"
typedef struct
{
  int _mp_alloc; /* Number of *limbs* allocated and pointed
				   to by the _mp_d field.  */
  int _mp_size; /* abs(_mp_size) is the number of limbs the
				   last field points to.  If _mp_size is
				   negative this is a negative number.  */
  mp_limb_t *_mp_d; /* Pointer to the limbs.  */
} __mpz_struct;

# 226 "../gmp.h"
typedef const __mpz_struct *mpz_srcptr;

# 1529 "../gmp.h"
mp_limb_t __gmpn_mod_1 (mp_srcptr, mp_size_t, mp_limb_t);

# 1576 "../gmp.h"
mp_limb_t __gmpn_rshift (mp_ptr, mp_srcptr, mp_size_t, unsigned int);

# 1610 "../gmp.h"
void __gmpn_tdiv_qr (mp_ptr, mp_ptr, mp_size_t, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t);

# 1630 "../gmp.h"
void __gmpn_copyi (mp_ptr, mp_srcptr, mp_size_t);

# 362 "../gmp-impl.h"
struct tmp_reentrant_t {
  struct tmp_reentrant_t *next;
  size_t size; /* bytes, including header */
};

# 366 "../gmp-impl.h"
void *__gmp_tmp_reentrant_alloc (struct tmp_reentrant_t **, size_t);

# 367 "../gmp-impl.h"
void __gmp_tmp_reentrant_free (struct tmp_reentrant_t *);

# 1064 "../gmp-impl.h"
int __gmpn_jacobi_base (mp_limb_t, mp_limb_t, int);

# 1070 "../gmp-impl.h"
int __gmpn_jacobi_n (mp_ptr, mp_ptr, mp_size_t, unsigned);

# 3206 "../gmp-impl.h"
mp_limb_t __gmpn_modexact_1c_odd (mp_srcptr, mp_size_t, mp_limb_t, mp_limb_t);

# 3705 "../gmp-impl.h"
typedef mp_limb_t UWtype;

# 4069 "../gmp-impl.h"
static inline unsigned
mpn_jacobi_init (unsigned a, unsigned b, unsigned s)
{
  do {} while (0);
  do {} while (0);
  return ((a & 3) << 2) + (b & 2) + s;
}

# 58 "jacobi.c"
int
__gmpz_jacobi (mpz_srcptr a, mpz_srcptr b)
{
  mp_srcptr asrcp, bsrcp;
  mp_size_t asize, bsize;
  mp_limb_t alow, blow;
  mp_ptr ap, bp;
  unsigned btwos;
  int result_bit1;
  int res;
  struct tmp_reentrant_t *__tmp_marker;

  asize = ((a)->_mp_size);
  asrcp = ((a)->_mp_d);
  alow = asrcp[0];

  bsize = ((b)->_mp_size);
  bsrcp = ((b)->_mp_d);
  blow = bsrcp[0];

  /* The MPN jacobi functions require positive a and b, and b odd. So
     we must to handle the cases of a or b zero, then signs, and then
     the case of even b.
  */

  if (bsize == 0)
    /* (a/0) = [ a = 1 or a = -1 ] */
    return (((asize) == 1 || (asize) == -1) && (alow) == 1);

  if (asize == 0)
    /* (0/b) = [ b = 1 or b = - 1 ] */
    return (((bsize) == 1 || (bsize) == -1) && (blow) == 1);

  if ( (((alow | blow) & 1) == 0))
    /* Common factor of 2 ==> (a/b) = 0 */
    return 0;

  if (bsize < 0)
    {
      /* (a/-1) = -1 if a < 0, +1 if a >= 0 */
      result_bit1 = (asize < 0) << 1;
      bsize = -bsize;
    }
  else
    result_bit1 = 0;

  do { do {} while (0); do {} while (0); while (__builtin_expect (((blow) == 0) != 0, 0)) { (bsize)--; do {} while (0); (bsrcp)++; (blow) = *(bsrcp); do {} while (0); if (((32 - 0) % 2) == 1) (result_bit1) ^= ((int) (((alow) >> 1) ^ (alow))); } } while (0);

  do { UWtype __ctz_x = (blow); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (btwos) = 32 - 1 - __ctz_c; } while (0);
  blow >>= btwos;

  if (bsize > 1 && btwos > 0)
    {
      mp_limb_t b1 = bsrcp[1];
      blow |= b1 << ((32 - 0) - btwos);
      if (bsize == 2 && (b1 >> btwos) == 0)
 bsize = 1;
    }

  if (asize < 0)
    {
      /* (-1/b) = -1 iff b = 3 (mod 4) */
      result_bit1 ^= ((int) (blow));
      asize = -asize;
    }

  do { do {} while (0); do {} while (0); while (__builtin_expect (((alow) == 0) != 0, 0)) { (asize)--; do {} while (0); (asrcp)++; (alow) = *(asrcp); do {} while (0); if (((32 - 0) % 2) == 1) (result_bit1) ^= ((int) (((blow) >> 1) ^ (blow))); } } while (0);

  /* Ensure asize >= bsize. Take advantage of the generalized
     reciprocity law (a/b*2^n) = (b*2^n / a) * RECIP(a,b) */

  if (asize < bsize)
    {
      do { do { mp_srcptr __mp_srcptr_swap__tmp = (asrcp); (asrcp) = (bsrcp); (bsrcp) = __mp_srcptr_swap__tmp; } while (0); do { mp_size_t __mp_size_t_swap__tmp = (asize); (asize) = (bsize); (bsize) = __mp_size_t_swap__tmp; } while (0); } while(0);
      do { mp_limb_t __mp_limb_t_swap__tmp = (alow); (alow) = (blow); (blow) = __mp_limb_t_swap__tmp; } while (0);

      /* NOTE: The value of alow (old blow) is a bit subtle. For this code
	 path, we get alow as the low, always odd, limb of shifted A. Which is
	 what we need for the reciprocity update below.

	 However, all other uses of alow assumes that it is *not*
	 shifted. Luckily, alow matters only when either

	 + btwos > 0, in which case A is always odd

	 + asize == bsize == 1, in which case this code path is never
	   taken. */

      do { UWtype __ctz_x = (blow); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (btwos) = 32 - 1 - __ctz_c; } while (0);
      blow >>= btwos;

      if (bsize > 1 && btwos > 0)
 {
   mp_limb_t b1 = bsrcp[1];
   blow |= b1 << ((32 - 0) - btwos);
   if (bsize == 2 && (b1 >> btwos) == 0)
     bsize = 1;
 }

      result_bit1 ^= ((int) ((alow) & (blow)));
    }

  if (bsize == 1)
    {
      result_bit1 ^= ((int) ((btwos) << 1) & ((int) (((alow) >> 1) ^ (alow))));

      if (blow == 1)
 return (1 - ((int) (result_bit1) & 2));

      if (asize > 1)
 do { mp_srcptr __a_ptr = (asrcp); mp_size_t __a_size = (asize); mp_limb_t __b = (blow); do {} while (0); do {} while (0); if (((32 - 0) % 2) != 0 || ((__builtin_constant_p (41) && (41) == 0) || (!(__builtin_constant_p (41) && (41) == 0x7fffffffL) && (__a_size) >= (41)))) { (alow) = __gmpn_mod_1 (__a_ptr, __a_size, __b); } else { (result_bit1) ^= ((int) (__b)); (alow) = __gmpn_modexact_1c_odd (__a_ptr, __a_size, __b, ((mp_limb_t) 0L)); } } while (0);

      return __gmpn_jacobi_base (alow, blow, result_bit1);
    }

  /* Allocation strategy: For A, we allocate a working copy only for A % B, but
     when A is much larger than B, we have to allocate space for the large
     quotient. We use the same area, pointed to by bp, for both the quotient
     A/B and the working copy of B. */

  __tmp_marker = 0;

  if (asize >= 2*bsize)
    do { if (0) { (ap) = ((mp_limb_t *) (__builtin_expect ((((bsize) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((bsize) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (bsize) * sizeof (mp_limb_t)))); (bp) = ((mp_limb_t *) (__builtin_expect ((((asize - bsize + 1) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((asize - bsize + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (asize - bsize + 1) * sizeof (mp_limb_t)))); } else { (ap) = ((mp_limb_t *) (__builtin_expect (((((bsize) + (asize - bsize + 1)) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca(((bsize) + (asize - bsize + 1)) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, ((bsize) + (asize - bsize + 1)) * sizeof (mp_limb_t)))); (bp) = (ap) + (bsize); } } while (0);
  else
    do { if (0) { (ap) = ((mp_limb_t *) (__builtin_expect ((((bsize) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((bsize) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (bsize) * sizeof (mp_limb_t)))); (bp) = ((mp_limb_t *) (__builtin_expect ((((bsize) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((bsize) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (bsize) * sizeof (mp_limb_t)))); } else { (ap) = ((mp_limb_t *) (__builtin_expect (((((bsize) + (bsize)) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca(((bsize) + (bsize)) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, ((bsize) + (bsize)) * sizeof (mp_limb_t)))); (bp) = (ap) + (bsize); } } while (0);

  /* In the case of even B, we conceptually shift out the powers of two first,
     and then divide A mod B. Hence, when taking those powers of two into
     account, we must use alow *before* the division. Doing the actual division
     first is ok, because the point is to remove multiples of B from A, and
     multiples of 2^k B are good enough. */
  if (asize > bsize)
    __gmpn_tdiv_qr (bp, ap, 0, asrcp, asize, bsrcp, bsize);
  else
    do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (ap, asrcp, bsize); } while (0); } while (0);

  if (btwos > 0)
    {
      result_bit1 ^= ((int) ((btwos) << 1) & ((int) (((alow) >> 1) ^ (alow))));

      (__gmpn_rshift (bp, bsrcp, bsize, btwos));
      bsize -= (ap[bsize-1] | bp[bsize-1]) == 0;
    }
  else
    do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (bp, bsrcp, bsize); } while (0); } while (0);

  do {} while (0);
  res = __gmpn_jacobi_n (ap, bp, bsize,
        mpn_jacobi_init (ap[0], blow, (result_bit1>>1) & 1));

  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
  return res;
}

# 60 "hgcd.c"
mp_size_t
__gmpn_hgcd_itch (mp_size_t n)
{
  unsigned k;
  int count;
  mp_size_t nscaled;

  if ((! ((__builtin_constant_p (197) && (197) == 0) || (!(__builtin_constant_p (197) && (197) == 0x7fffffffL) && (n) >= (197)))))
    return n;

  /* Get the recursion depth. */
  nscaled = (n - 1) / (197 - 1);
  __asm__ ("clz\t%0, %1" : "=r" (count) : "r" (nscaled));
  k = 32 - count;

  return 20 * ((n+3) / 4) + 22 * k + 197;
}

# 1526 "../gmp.h"
mp_limb_t __gmpn_lshift (mp_ptr, mp_srcptr, mp_size_t, unsigned int);

# 1566 "../gmp-impl.h"
mp_limb_t __gmpn_sec_pi1_div_qr (mp_ptr, mp_ptr, mp_size_t, mp_srcptr, mp_size_t, mp_limb_t, mp_ptr);

# 68 "sec_div_qr.c"
mp_limb_t
__gmpn_sec_div_qr (mp_ptr qp,
       mp_ptr np, mp_size_t nn,
       mp_srcptr dp, mp_size_t dn,
       mp_ptr tp)
{
  mp_limb_t d1, d0;
  unsigned int cnt;
  gmp_pi1_t dinv;
  mp_limb_t inv32;

  do {} while (0);
  do {} while (0);
  do {} while (0);

  d1 = dp[dn - 1];
  __asm__ ("clz\t%0, %1" : "=r" (cnt) : "r" (d1));

  if (cnt != 0)
    {
      mp_limb_t qh, cy;
      mp_ptr np2, dp2;
      dp2 = tp; /* dn limbs */
      __gmpn_lshift (dp2, dp, dn, cnt);

      np2 = tp + dn; /* (nn + 1) limbs */
      cy = __gmpn_lshift (np2, np, nn, cnt);
      np2[nn++] = cy;

      d0 = dp2[dn - 1];
      d0 += (~d0 != 0);
      do { (inv32) = __gmpn_invert_limb (d0); } while (0);

      /* We add nn + dn to tp here, not nn + 1 + dn, as expected.  This is
	 since nn here will have been incremented.  */

      qh = __gmpn_sec_pi1_div_qr (np2 + dn, np2, nn, dp2, dn, inv32, tp + nn + dn);
      do {} while (0); /* FIXME: this indicates inefficiency! */
      do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (qp, np2 + dn, nn - dn - 1); } while (0); } while (0);
      qh = np2[nn - 1];




      __gmpn_rshift (np, np2, dn, cnt);


      return qh;

    }
  else
    {
      /* FIXME: Consider copying np => np2 here, adding a 0-limb at the top.
	 That would simplify the underlying pi1 function, since then it could
	 assume nn > dn.  */
      d0 = dp[dn - 1];
      d0 += (~d0 != 0);
      do { (inv32) = __gmpn_invert_limb (d0); } while (0);


      return __gmpn_sec_pi1_div_qr (qp, np, nn, dp, dn, inv32, tp);



    }
}

# 147 "../gmp.h"
typedef unsigned long int mp_bitcnt_t;

# 227 "../gmp.h"
typedef __mpz_struct *mpz_ptr;

# 626 "../gmp.h"
void *__gmpz_realloc (mpz_ptr, mp_size_t);

# 1532 "../gmp.h"
mp_limb_t __gmpn_mul (mp_ptr, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t);

# 1535 "../gmp.h"
mp_limb_t __gmpn_mul_1 (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t);

# 1541 "../gmp.h"
void __gmpn_sqr (mp_ptr, mp_srcptr, mp_size_t);

# 161 "n_pow_ui.c"
void
__gmpz_n_pow_ui (mpz_ptr r, mp_srcptr bp, mp_size_t bsize, unsigned long int e)
{
  mp_ptr rp;
  mp_size_t rtwos_limbs, ralloc, rsize;
  int rneg, i, cnt, btwos, r_bp_overlap;
  mp_limb_t blimb, rl;
  mp_bitcnt_t rtwos_bits;



  mp_limb_t b_twolimbs[2];

  struct tmp_reentrant_t *__tmp_marker;

 

                             ;

  do {} while (0);
  do {} while (0);

  /* b^0 == 1, including 0^0 == 1 */
  if (e == 0)
    {
      ((r)->_mp_d)[0] = 1;
      ((r)->_mp_size) = 1;
      return;
    }

  /* 0^e == 0 apart from 0^0 above */
  if (bsize == 0)
    {
      ((r)->_mp_size) = 0;
      return;
    }

  /* Sign of the final result. */
  rneg = (bsize < 0 && (e & 1) != 0);
  bsize = ((bsize) >= 0 ? (bsize) : -(bsize));
  ;

  r_bp_overlap = (((r)->_mp_d) == bp);

  /* Strip low zero limbs from b. */
  rtwos_limbs = 0;
  for (blimb = *bp; blimb == 0; blimb = *++bp)
    {
      rtwos_limbs += e;
      bsize--; do {} while (0);
    }
  ;

  /* Strip low zero bits from b. */
  do { UWtype __ctz_x = (blimb); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (btwos) = 32 - 1 - __ctz_c; } while (0);
  blimb >>= btwos;
  rtwos_bits = e * btwos;
  rtwos_limbs += rtwos_bits / (32 - 0);
  rtwos_bits %= (32 - 0);
 
                                   ;

  __tmp_marker = 0;

  rl = 1;




  if (bsize == 1)
    {
    bsize_1:
      /* Power up as far as possible within blimb.  We start here with e!=0,
	 but if e is small then we might reach e==0 and the whole b^e in rl.
	 Notice this code works when blimb==1 too, reaching e==0.  */

      while (blimb <= (((mp_limb_t) 1 << (32 - 0)/2) - 1))
 {
  
                  ;
   do {} while (0);
   if ((e & 1) != 0)
     rl *= blimb;
   e >>= 1;
   if (e == 0)
     goto got_rl;
   blimb *= blimb;
 }
# 293 "n_pow_ui.c"
    got_rl:
     
                     ;

      /* Combine left-over rtwos_bits into rl to be handled by the final
	 mul_1 rather than a separate lshift.
	 - rl mustn't be 1 (since then there's no final mul)
	 - rl mustn't overflow	*/

      if (rtwos_bits != 0
   && rl != 1
   && (rl >> ((32 - 0)-rtwos_bits)) == 0)
 {
   rl <<= rtwos_bits;
   rtwos_bits = 0;
   ;
 }

    }
  else if (bsize == 2)
    {
      mp_limb_t bsecond = bp[1];
      if (btwos != 0)
 blimb |= (bsecond << ((32 - 0) - btwos)) & ((~ ((mp_limb_t) (0))) >> 0);
      bsecond >>= btwos;
      if (bsecond == 0)
 {
   /* Two limbs became one after rshift. */
   bsize = 1;
   goto bsize_1;
 }

      ;



      bp = b_twolimbs;
      b_twolimbs[0] = blimb;
      b_twolimbs[1] = bsecond;

      blimb = bsecond;
    }
  else
    {
      if (r_bp_overlap || btwos != 0)
 {
   mp_ptr tp = ((mp_limb_t *) (__builtin_expect ((((bsize) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((bsize) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (bsize) * sizeof (mp_limb_t))));
   do { if ((btwos) == 0) do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (tp, bp, bsize); } while (0); } while (0); else { __gmpn_rshift (tp, bp, bsize, btwos); (bsize) -= ((tp)[(bsize)-1] == 0); } } while (0);
   bp = tp;
   ;
 }




      blimb = bp[bsize-1];

     
                                 ;
    }

  /* At this point blimb is the most significant limb of the base to use.

     Each factor of b takes (bsize*BPML-cnt) bits and there's e of them; +1
     limb to round up the division; +1 for multiplies all using an extra
     limb over the true size; +2 for rl at the end; +1 for lshift at the
     end.

     The size calculation here is reasonably accurate.  The base is at least
     half a limb, so in 32 bits the worst case is 2^16+1 treated as 17 bits
     when it will power up as just over 16, an overestimate of 17/16 =
     6.25%.  For a 64-bit limb it's half that.

     If e==0 then blimb won't be anything useful (though it will be
     non-zero), but that doesn't matter since we just end up with ralloc==5,
     and that's fine for 2 limbs of rl and 1 of lshift.  */

  do {} while (0);
  __asm__ ("clz\t%0, %1" : "=r" (cnt) : "r" (blimb));
  ralloc = (bsize*(32 - 0) - cnt + 0) * e / (32 - 0) + 5;
 
                              ;
  rp = (__builtin_expect (((ralloc + rtwos_limbs) > ((r)->_mp_alloc)) != 0, 0) ? (mp_ptr) __gmpz_realloc(r,ralloc + rtwos_limbs) : ((r)->_mp_d));

  /* Low zero limbs resulting from powers of 2. */
  do { do {} while (0); if ((rtwos_limbs) != 0) { mp_ptr __dst = (rp); mp_size_t __n = (rtwos_limbs); do *__dst++ = 0; while (--__n); } } while (0);
  rp += rtwos_limbs;

  if (e == 0)
    {
      /* Any e==0 other than via bsize==1 or bsize==2 is covered at the
	 start. */
      rp[0] = rl;
      rsize = 1;




      do {} while (0);
    }
  else
    {
      mp_ptr tp;
      mp_size_t talloc;

      /* In the mpn_mul_1 or mpn_mul_2 loops or in the mpn_mul loop when the
	 low bit of e is zero, tp only has to hold the second last power
	 step, which is half the size of the final result.  There's no need
	 to round up the divide by 2, since ralloc includes a +2 for rl
	 which not needed by tp.  In the mpn_mul loop when the low bit of e
	 is 1, tp must hold nearly the full result, so just size it the same
	 as rp.  */

      talloc = ralloc;




      if (bsize <= 1 || (e & 1) == 0)
 talloc /= 2;

      ;
      tp = ((mp_limb_t *) (__builtin_expect ((((talloc) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((talloc) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (talloc) * sizeof (mp_limb_t))));

      /* Go from high to low over the bits of e, starting with i pointing at
	 the bit below the highest 1 (which will mean i==-1 if e==1).  */
      __asm__ ("clz\t%0, %1" : "=r" (cnt) : "r" ((mp_limb_t) e));
      i = 32 - cnt - 2;
# 465 "n_pow_ui.c"
      if (bsize == 1)
 {
   /* Arrange the final result ends up in r, not in the temp space */
   if ((i & 1) == 0)
     do { do { mp_ptr __mp_ptr_swap__tmp = (rp); (rp) = (tp); (tp) = __mp_ptr_swap__tmp; } while (0); ; } while (0);

   rp[0] = blimb;
   rsize = 1;

   for ( ; i >= 0; i--)
     {
      

                                  ;

       do { do {} while (0); __gmpn_sqr (tp, rp, rsize); (rsize) *= 2; (rsize) -= ((tp)[(rsize)-1] == 0); } while (0);
       do { do { mp_ptr __mp_ptr_swap__tmp = (rp); (rp) = (tp); (tp) = __mp_ptr_swap__tmp; } while (0); ; } while (0);
       if ((e & (1L << i)) != 0)
  do { mp_limb_t cy; do {} while (0); cy = __gmpn_mul_1 (rp, rp, rsize, blimb); (rp)[rsize] = cy; (rsize) += (cy != 0); } while (0);
     }

   ;
   if (rl != 1)
     do { mp_limb_t cy; do {} while (0); cy = __gmpn_mul_1 (rp, rp, rsize, rl); (rp)[rsize] = cy; (rsize) += (cy != 0); } while (0);
 }

      else
 {
   int parity;

   /* Arrange the final result ends up in r, not in the temp space */
   do { unsigned long __n = (e); int __p = 0; do { __p ^= 0x96696996L >> (__n & 0x1F); __n >>= 5; } while (__n != 0); (parity) = __p & 1; } while (0);
   if (((parity ^ i) & 1) != 0)
     do { do { mp_ptr __mp_ptr_swap__tmp = (rp); (rp) = (tp); (tp) = __mp_ptr_swap__tmp; } while (0); ; } while (0);

   do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (rp, bp, bsize); } while (0); } while (0);
   rsize = bsize;

   for ( ; i >= 0; i--)
     {
      

                                  ;

       do { do {} while (0); __gmpn_sqr (tp, rp, rsize); (rsize) *= 2; (rsize) -= ((tp)[(rsize)-1] == 0); } while (0);
       do { do { mp_ptr __mp_ptr_swap__tmp = (rp); (rp) = (tp); (tp) = __mp_ptr_swap__tmp; } while (0); ; } while (0);
       if ((e & (1L << i)) != 0)
  {
    do { mp_limb_t cy; do {} while (0); cy = __gmpn_mul (tp, rp, rsize, bp, bsize); (rsize) += (bsize) - (cy == 0); } while (0);
    do { do { mp_ptr __mp_ptr_swap__tmp = (rp); (rp) = (tp); (tp) = __mp_ptr_swap__tmp; } while (0); ; } while (0);
  }
     }
 }
    }

  do {} while (0);
  ;
  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);

  /* Apply any partial limb factors of 2. */
  if (rtwos_bits != 0)
    {
      do { mp_limb_t cy; do {} while (0); cy = __gmpn_lshift (rp, rp, rsize, (unsigned) rtwos_bits); (rp)[rsize] = cy; (rsize) += (cy != 0); } while (0);
      ;
    }

  rsize += rtwos_limbs;
  ((r)->_mp_size) = (rneg ? -rsize : rsize);
}

# 44 "div_qr_2n_pi1.c"
mp_limb_t
__gmpn_div_qr_2n_pi1 (mp_ptr qp, mp_ptr rp, mp_srcptr np, mp_size_t nn,
     mp_limb_t d1, mp_limb_t d0, mp_limb_t di)
{
  mp_limb_t qh;
  mp_size_t i;
  mp_limb_t r1, r0;

  do {} while (0);
  do {} while (0);

  np += nn - 2;
  r1 = np[1];
  r0 = np[0];

  qh = 0;
  if (r1 >= d1 && (r1 > d1 || r0 >= d0))
    {

      do { if (__builtin_constant_p (r0)) { if (__builtin_constant_p (r1)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (r1), "=&r" (r0) : "rI" (r1), "r" (d1), "rI" (r0), "r" (d0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (r1), "=&r" (r0) : "r" (r1), "rI" (d1), "rI" (r0), "r" (d0) : "cc"); } else if (__builtin_constant_p (r1)) { if (__builtin_constant_p (d0)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (r1), "=&r" (r0) : "rI" (r1), "r" (d1), "r" (r0), "rI" (d0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (r1), "=&r" (r0) : "rI" (r1), "r" (d1), "rI" (r0), "r" (d0) : "cc"); } else if (__builtin_constant_p (d0)) { if (__builtin_constant_p (d1)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (r1), "=&r" (r0) : "r" (r1), "rI" (d1), "r" (r0), "rI" (d0) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (r1), "=&r" (r0) : "rI" (r1), "r" (d1), "r" (r0), "rI" (d0) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (r1), "=&r" (r0) : "r" (r1), "rI" (d1), "r" (r0), "rI" (d0) : "cc"); } while (0);





      qh = 1;
    }

  for (i = nn - 2 - 1; i >= 0; i--)
    {
      mp_limb_t n0, q;
      n0 = np[-1];
      do { mp_limb_t _q0, _t1, _t0, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_q0), "=&r" ((q)) : "r" ((r1)), "r" ((di))); __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" ((q)), "=&r" (_q0) : "r" ((q)), "rI" ((r1)), "%r" (_q0), "rI" ((r0)) : "cc"); /* Compute the two most significant limbs of n - q'd */ (r1) = (r0) - (d1) * (q); do { if (__builtin_constant_p ((n0))) { if (__builtin_constant_p ((r1))) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" ((d1)), "rI" ((n0)), "r" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" ((d1)), "rI" ((n0)), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((r1))) { if (__builtin_constant_p ((d0))) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" ((d1)), "r" ((n0)), "rI" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" ((d1)), "rI" ((n0)), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((d0))) { if (__builtin_constant_p ((d1))) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" ((d1)), "r" ((n0)), "rI" ((d0)) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" ((d1)), "r" ((n0)), "rI" ((d0)) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" ((d1)), "r" ((n0)), "rI" ((d0)) : "cc"); } while (0); __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" ((d0)), "r" ((q))); do { if (__builtin_constant_p ((r0))) { if (__builtin_constant_p ((r1))) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" (_t1), "rI" ((r0)), "r" (_t0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" (_t1), "rI" ((r0)), "r" (_t0) : "cc"); } else if (__builtin_constant_p ((r1))) { if (__builtin_constant_p (_t0)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" (_t1), "r" ((r0)), "rI" (_t0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" (_t1), "rI" ((r0)), "r" (_t0) : "cc"); } else if (__builtin_constant_p (_t0)) { if (__builtin_constant_p (_t1)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" (_t1), "r" ((r0)), "rI" (_t0) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" (_t1), "r" ((r0)), "rI" (_t0) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" (_t1), "r" ((r0)), "rI" (_t0) : "cc"); } while (0); (q)++; /* Conditionally adjust q and the remainders */ _mask = - (mp_limb_t) ((r1) >= _q0); (q) += _mask; __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" (_mask & (d1)), "%r" ((r0)), "rI" (_mask & (d0)) : "cc"); if (__builtin_expect (((r1) >= (d1)) != 0, 0)) { if ((r1) > (d1) || (r0) >= (d0)) { (q)++; do { if (__builtin_constant_p ((r0))) { if (__builtin_constant_p ((r1))) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" ((d1)), "rI" ((r0)), "r" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" ((d1)), "rI" ((r0)), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((r1))) { if (__builtin_constant_p ((d0))) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" ((d1)), "r" ((r0)), "rI" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" ((d1)), "rI" ((r0)), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((d0))) { if (__builtin_constant_p ((d1))) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" ((d1)), "r" ((r0)), "rI" ((d0)) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" ((d1)), "r" ((r0)), "rI" ((d0)) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" ((d1)), "r" ((r0)), "rI" ((d0)) : "cc"); } while (0); } } } while (0);
      np--;
      qp[i] = q;
    }

  rp[1] = r1;
  rp[0] = r0;

  return qh;
}

# 637 "../gmp.h"
void __gmpz_add_ui (mpz_ptr, mpz_srcptr, unsigned long int);

# 703 "../gmp.h"
int __gmpz_cmp_ui (mpz_srcptr, unsigned long int);

# 787 "../gmp.h"
unsigned long int __gmpz_fdiv_ui (mpz_srcptr, unsigned long int);

# 928 "../gmp.h"
int __gmpz_millerrabin (mpz_srcptr, int);

# 1041 "../gmp.h"
void __gmpz_set_ui (mpz_ptr, unsigned long int);

# 1044 "../gmp.h"
void __gmpz_setbit (mpz_ptr, mp_bitcnt_t);

# 37 "nextprime.c"
static const unsigned char primegap[] =
{
  2,2,4,2,4,2,4,6,2,6,4,2,4,6,6,2,6,4,2,6,4,6,8,4,2,4,2,4,14,4,6,
  2,10,2,6,6,4,6,6,2,10,2,4,2,12,12,4,2,4,6,2,10,6,6,6,2,6,4,2,10,14,4,2,
  4,14,6,10,2,4,6,8,6,6,4,6,8,4,8,10,2,10,2,6,4,6,8,4,2,4,12,8,4,8,4,6,
  12,2,18,6,10,6,6,2,6,10,6,6,2,6,6,4,2,12,10,2,4,6,6,2,12,4,6,8,10,8,10,8,
  6,6,4,8,6,4,8,4,14,10,12,2,10,2,4,2,10,14,4,2,4,14,4,2,4,20,4,8,10,8,4,6,
  6,14,4,6,6,8,6,12
};

# 49 "nextprime.c"
void
__gmpz_nextprime (mpz_ptr p, mpz_srcptr n)
{
  unsigned short *moduli;
  unsigned long difference;
  int i;
  unsigned prime_limit;
  unsigned long prime;
  mp_size_t pn;
  mp_bitcnt_t nbits;
  unsigned incr;
  ;

  /* First handle tiny numbers */
  if ((__builtin_constant_p (2) && (2) == 0 ? ((n)->_mp_size < 0 ? -1 : (n)->_mp_size > 0) : __gmpz_cmp_ui (n,2)) < 0)
    {
      __gmpz_set_ui (p, 2);
      return;
    }
  __gmpz_add_ui (p, n, 1);
  __gmpz_setbit (p, 0);

  if ((__builtin_constant_p (7) && (7) == 0 ? ((p)->_mp_size < 0 ? -1 : (p)->_mp_size > 0) : __gmpz_cmp_ui (p,7)) <= 0)
    return;

  pn = ((p)->_mp_size);
  do { int __cnt; mp_bitcnt_t __totbits; do {} while (0); do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__cnt) : "r" ((((p)->_mp_d))[(pn)-1])); __totbits = (mp_bitcnt_t) (pn) * (32 - 0) - (__cnt - 0); (nbits) = (__totbits + (1)-1) / (1); } while (0);
  if (nbits / 2 >= 167)
    prime_limit = 167 - 1;
  else
    prime_limit = nbits / 2;

  ;

  /* Compute residues modulo small odd primes */
  moduli = ((unsigned short *) __builtin_alloca((prime_limit * sizeof moduli[0]) * sizeof (unsigned short)));

  for (;;)
    {
      /* FIXME: Compute lazily? */
      prime = 3;
      for (i = 0; i < prime_limit; i++)
 {
   moduli[i] = __gmpz_fdiv_ui (p, prime);
   prime += primegap[i];
 }



      for (difference = incr = 0; incr < 0x10000 /* deep science */; difference += 2)
 {
   /* First check residues */
   prime = 3;
   for (i = 0; i < prime_limit; i++)
     {
       unsigned r;
       /* FIXME: Reduce moduli + incr and store back, to allow for
		 division-free reductions.  Alternatively, table primes[]'s
		 inverses (mod 2^16).  */
       r = (moduli[i] + incr) % prime;
       prime += primegap[i];

       if (r == 0)
  goto next;
     }

   __gmpz_add_ui (p, p, difference);
   difference = 0;

   /* Miller-Rabin test */
   if (__gmpz_millerrabin (p, 25))
     goto done;
 next:;
   incr += 2;
 }
      __gmpz_add_ui (p, p, difference);
      difference = 0;
    }
 done:
  ;
}

# 1473 "../gmp.h"
mp_limb_t __gmpn_add_n (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);

# 1538 "../gmp.h"
void __gmpn_mul_n (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);

# 2123 "../gmp.h"
/* extern */ __inline__

mp_limb_t
__gmpn_add (mp_ptr __gmp_wp, mp_srcptr __gmp_xp, mp_size_t __gmp_xsize, mp_srcptr __gmp_yp, mp_size_t __gmp_ysize)
{
  mp_limb_t __gmp_c;
  do { mp_size_t __gmp_i; mp_limb_t __gmp_x; /* ASSERT ((ysize) >= 0); */ /* ASSERT ((xsize) >= (ysize)); */ /* ASSERT (MPN_SAME_OR_SEPARATE2_P (wp, xsize, xp, xsize)); */ /* ASSERT (MPN_SAME_OR_SEPARATE2_P (wp, xsize, yp, ysize)); */ __gmp_i = (__gmp_ysize); if (__gmp_i != 0) { if (__gmpn_add_n (__gmp_wp, __gmp_xp, __gmp_yp, __gmp_i)) { do { if (__gmp_i >= (__gmp_xsize)) { (__gmp_c) = 1; goto __gmp_done; } __gmp_x = (__gmp_xp)[__gmp_i]; } while ((((__gmp_wp)[__gmp_i++] = (__gmp_x + 1) & ((~ ((mp_limb_t) (0))) >> 0)) == 0)); } } if ((__gmp_wp) != (__gmp_xp)) do { mp_size_t __gmp_j; /* ASSERT ((size) >= 0); */ /* ASSERT ((start) >= 0); */ /* ASSERT ((start) <= (size)); */ /* ASSERT (MPN_SAME_OR_SEPARATE_P (dst, src, size)); */ ; for (__gmp_j = (__gmp_i); __gmp_j < (__gmp_xsize); __gmp_j++) (__gmp_wp)[__gmp_j] = (__gmp_xp)[__gmp_j]; } while (0); (__gmp_c) = 0; __gmp_done: ; } while (0);
  return __gmp_c;
}

# 1437 "../gmp-impl.h"
mp_limb_t __gmpn_sbpi1_div_q (mp_ptr, mp_ptr, mp_size_t, mp_srcptr, mp_size_t, mp_limb_t);

# 1490 "../gmp-impl.h"
mp_limb_t __gmpn_ni_invertappr (mp_ptr, mp_srcptr, mp_size_t, mp_ptr);

# 41 "invert.c"
void
__gmpn_invert (mp_ptr ip, mp_srcptr dp, mp_size_t n, mp_ptr scratch)
{
  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);

  if (n == 1)
    do { (*ip) = __gmpn_invert_limb (*dp); } while (0);
  else {
    struct tmp_reentrant_t *__tmp_marker;

    __tmp_marker = 0;
    if ((! ((__builtin_constant_p (478) && (478) == 0) || (!(__builtin_constant_p (478) && (478) == 0x7fffffffL) && (n) >= (478)))))
      {
 /* Maximum scratch needed by this branch: 2*n */
 mp_size_t i;
 mp_ptr xp;

 xp = scratch; /* 2 * n limbs */
 for (i = n - 1; i >= 0; i--)
   xp[i] = ((~ ((mp_limb_t) (0))) >> 0);
 __gmpn_com (xp + n, dp, n);
 if (n == 2) {
   __gmpn_divrem_2 (ip, 0, xp, 4, dp);
 } else {
   gmp_pi1_t inv;
   do { mp_limb_t _v, _p, _t1, _t0, _mask; do { (_v) = __gmpn_invert_limb (dp[n-1]); } while (0); _p = (dp[n-1]) * _v; _p += (dp[n-2]); if (_p < (dp[n-2])) { _v--; _mask = -(mp_limb_t) (_p >= (dp[n-1])); _p -= (dp[n-1]); _v += _mask; _p -= _mask & (dp[n-1]); } __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" (dp[n-2]), "r" (_v)); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (dp[n-1])) != 0, 0)) { if (_p > (dp[n-1]) || _t0 >= (dp[n-2])) _v--; } } (inv).inv32 = _v; } while (0);
   /* FIXME: should we use dcpi1_div_q, for big sizes? */
   __gmpn_sbpi1_div_q (ip, xp, 2 * n, dp, n, inv.inv32);
 }
      }
    else { /* Use approximated inverse; correct the result if needed. */
      mp_limb_t e; /* The possible error in the approximate inverse */

      do {} while (0);
      e = __gmpn_ni_invertappr (ip, dp, n, scratch);

      if (__builtin_expect ((e) != 0, 0)) { /* Assume the error can only be "0" (no error) or "1". */
 /* Code to detect and correct the "off by one" approximation. */
 __gmpn_mul_n (scratch, ip, dp, n);
 (__gmpn_add_n (scratch + n, scratch + n, dp, n));
 if (! __gmpn_add (scratch, scratch, 2*n, dp, n))
   do { mp_limb_t __x; mp_ptr __p = (ip); if (__builtin_constant_p (1) && (1) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (1); *__p = __x; if (__x < (1)) while (++(*(++__p)) == 0) ; } } while (0); /* The value was wrong, correct it.  */
      }
    }
    do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
  }
}

# 45 "div_qr_2u_pi1.c"
mp_limb_t
__gmpn_div_qr_2u_pi1 (mp_ptr qp, mp_ptr rp, mp_srcptr np, mp_size_t nn,
     mp_limb_t d1, mp_limb_t d0, int shift, mp_limb_t di)
{
  mp_limb_t qh;
  mp_limb_t r2, r1, r0;
  mp_size_t i;

  do {} while (0);
  do {} while (0);
  do {} while (0);

  r2 = np[nn-1] >> (32 - shift);
  r1 = (np[nn-1] << shift) | (np[nn-2] >> (32 - shift));
  r0 = np[nn-2] << shift;

  do { mp_limb_t _q0, _t1, _t0, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_q0), "=&r" ((qh)) : "r" ((r2)), "r" ((di))); __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" ((qh)), "=&r" (_q0) : "r" ((qh)), "rI" ((r2)), "%r" (_q0), "rI" ((r1)) : "cc"); /* Compute the two most significant limbs of n - q'd */ (r2) = (r1) - (d1) * (qh); do { if (__builtin_constant_p ((r0))) { if (__builtin_constant_p ((r2))) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" ((d1)), "rI" ((r0)), "r" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" ((d1)), "rI" ((r0)), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((r2))) { if (__builtin_constant_p ((d0))) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" ((d1)), "r" ((r0)), "rI" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" ((d1)), "rI" ((r0)), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((d0))) { if (__builtin_constant_p ((d1))) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" ((d1)), "r" ((r0)), "rI" ((d0)) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" ((d1)), "r" ((r0)), "rI" ((d0)) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" ((d1)), "r" ((r0)), "rI" ((d0)) : "cc"); } while (0); __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" ((d0)), "r" ((qh))); do { if (__builtin_constant_p ((r1))) { if (__builtin_constant_p ((r2))) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" (_t1), "rI" ((r1)), "r" (_t0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" (_t1), "rI" ((r1)), "r" (_t0) : "cc"); } else if (__builtin_constant_p ((r2))) { if (__builtin_constant_p (_t0)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" (_t1), "r" ((r1)), "rI" (_t0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" (_t1), "rI" ((r1)), "r" (_t0) : "cc"); } else if (__builtin_constant_p (_t0)) { if (__builtin_constant_p (_t1)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" (_t1), "r" ((r1)), "rI" (_t0) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" (_t1), "r" ((r1)), "rI" (_t0) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" (_t1), "r" ((r1)), "rI" (_t0) : "cc"); } while (0); (qh)++; /* Conditionally adjust q and the remainders */ _mask = - (mp_limb_t) ((r2) >= _q0); (qh) += _mask; __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" (_mask & (d1)), "%r" ((r1)), "rI" (_mask & (d0)) : "cc"); if (__builtin_expect (((r2) >= (d1)) != 0, 0)) { if ((r2) > (d1) || (r1) >= (d0)) { (qh)++; do { if (__builtin_constant_p ((r1))) { if (__builtin_constant_p ((r2))) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" ((d1)), "rI" ((r1)), "r" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" ((d1)), "rI" ((r1)), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((r2))) { if (__builtin_constant_p ((d0))) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" ((d1)), "r" ((r1)), "rI" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" ((d1)), "rI" ((r1)), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((d0))) { if (__builtin_constant_p ((d1))) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" ((d1)), "r" ((r1)), "rI" ((d0)) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" ((d1)), "r" ((r1)), "rI" ((d0)) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" ((d1)), "r" ((r1)), "rI" ((d0)) : "cc"); } while (0); } } } while (0);

  for (i = nn - 2 - 1; i >= 0; i--)
    {
      mp_limb_t q;
      r0 = np[i];
      r1 |= r0 >> (32 - shift);
      r0 <<= shift;
      do { mp_limb_t _q0, _t1, _t0, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_q0), "=&r" ((q)) : "r" ((r2)), "r" ((di))); __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" ((q)), "=&r" (_q0) : "r" ((q)), "rI" ((r2)), "%r" (_q0), "rI" ((r1)) : "cc"); /* Compute the two most significant limbs of n - q'd */ (r2) = (r1) - (d1) * (q); do { if (__builtin_constant_p ((r0))) { if (__builtin_constant_p ((r2))) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" ((d1)), "rI" ((r0)), "r" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" ((d1)), "rI" ((r0)), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((r2))) { if (__builtin_constant_p ((d0))) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" ((d1)), "r" ((r0)), "rI" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" ((d1)), "rI" ((r0)), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((d0))) { if (__builtin_constant_p ((d1))) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" ((d1)), "r" ((r0)), "rI" ((d0)) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" ((d1)), "r" ((r0)), "rI" ((d0)) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" ((d1)), "r" ((r0)), "rI" ((d0)) : "cc"); } while (0); __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" ((d0)), "r" ((q))); do { if (__builtin_constant_p ((r1))) { if (__builtin_constant_p ((r2))) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" (_t1), "rI" ((r1)), "r" (_t0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" (_t1), "rI" ((r1)), "r" (_t0) : "cc"); } else if (__builtin_constant_p ((r2))) { if (__builtin_constant_p (_t0)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" (_t1), "r" ((r1)), "rI" (_t0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" (_t1), "rI" ((r1)), "r" (_t0) : "cc"); } else if (__builtin_constant_p (_t0)) { if (__builtin_constant_p (_t1)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" (_t1), "r" ((r1)), "rI" (_t0) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" (_t1), "r" ((r1)), "rI" (_t0) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" (_t1), "r" ((r1)), "rI" (_t0) : "cc"); } while (0); (q)++; /* Conditionally adjust q and the remainders */ _mask = - (mp_limb_t) ((r2) >= _q0); (q) += _mask; __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" (_mask & (d1)), "%r" ((r1)), "rI" (_mask & (d0)) : "cc"); if (__builtin_expect (((r2) >= (d1)) != 0, 0)) { if ((r2) > (d1) || (r1) >= (d0)) { (q)++; do { if (__builtin_constant_p ((r1))) { if (__builtin_constant_p ((r2))) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" ((d1)), "rI" ((r1)), "r" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" ((d1)), "rI" ((r1)), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((r2))) { if (__builtin_constant_p ((d0))) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" ((d1)), "r" ((r1)), "rI" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" ((d1)), "rI" ((r1)), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((d0))) { if (__builtin_constant_p ((d1))) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" ((d1)), "r" ((r1)), "rI" ((d0)) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r2)), "=&r" ((r1)) : "rI" ((r2)), "r" ((d1)), "r" ((r1)), "rI" ((d0)) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r2)), "=&r" ((r1)) : "r" ((r2)), "rI" ((d1)), "r" ((r1)), "rI" ((d0)) : "cc"); } while (0); } } } while (0);
      qp[i] = q;
    }

  rp[0] = (r1 >> shift) | (r2 << (32 - shift));
  rp[1] = r2 >> shift;

  return qh;
}

# 43 "pre_mod_1.c"
mp_limb_t
__gmpn_preinv_mod_1 (mp_srcptr up, mp_size_t un, mp_limb_t d, mp_limb_t dinv)
{
  mp_size_t i;
  mp_limb_t n0, r;

  do {} while (0);
  do {} while (0);

  r = up[un - 1];
  if (r >= d)
    r -= d;

  for (i = un - 2; i >= 0; i--)
    {
      n0 = up[i];
      do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((r)), "r" ((dinv))); if (__builtin_constant_p (n0) && (n0) == 0) { _r = ~(_qh + (r)) * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((r) + 1), "%r" (_ql), "rI" ((n0)) : "cc"); _r = (n0) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) _r -= (d); } (r) = _r; } while (0);
    }
  return r;
}

# 39 "scan0.c"
mp_bitcnt_t
__gmpn_scan0 (mp_srcptr up, mp_bitcnt_t starting_bit)
{
  mp_size_t starting_word;
  mp_limb_t alimb;
  int cnt;
  mp_srcptr p;

  /* Start at the word implied by STARTING_BIT.  */
  starting_word = starting_bit / (32 - 0);
  p = up + starting_word;
  alimb = *p++ ^ ((~ ((mp_limb_t) (0))) >> 0);

  /* Mask off any bits before STARTING_BIT in the first limb.  */
  alimb &= - (mp_limb_t) 1 << (starting_bit % (32 - 0));

  while (alimb == 0)
    alimb = *p++ ^ ((~ ((mp_limb_t) (0))) >> 0);

  do { UWtype __ctz_x = (alimb); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (cnt) = 32 - 1 - __ctz_c; } while (0);
  return (p - up - 1) * (32 - 0) + cnt;
}

# 104 "mod_1.c"
static mp_limb_t
mpn_mod_1_unnorm (mp_srcptr up, mp_size_t un, mp_limb_t d)
{
  mp_size_t i;
  mp_limb_t n1, n0, r;
  mp_limb_t dummy;
  int cnt;

  do {} while (0);
  do {} while (0);

  d <<= 0;

  /* Skip a division if high < divisor.  Having the test here before
     normalizing will still skip as often as possible.  */
  r = up[un - 1] << 0;
  if (r < d)
    {
      r >>= 0;
      un--;
      if (un == 0)
 return r;
    }
  else
    r = 0;

  /* If udiv_qrnnd doesn't need a normalized divisor, can use the simple
     code above. */
  if (! 1
      && (! ((__builtin_constant_p (0 /* always */) && (0 /* always */) == 0) || (!(__builtin_constant_p (0 /* always */) && (0 /* always */) == 0x7fffffffL) && (un) >= (0 /* always */)))))
    {
      for (i = un - 1; i >= 0; i--)
 {
   n0 = up[i] << 0;
   do { UWtype __di; __di = __gmpn_invert_limb (d); do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((r)), "r" ((__di))); if (__builtin_constant_p (n0) && (n0) == 0) { _qh += (r) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((r) + 1), "%r" (_ql), "rI" ((n0)) : "cc"); _r = (n0) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (r) = _r; (dummy) = _qh; } while (0); } while (0);
   r >>= 0;
 }
      return r;
    }

  __asm__ ("clz\t%0, %1" : "=r" (cnt) : "r" (d));
  d <<= cnt;

  n1 = up[un - 1] << 0;
  r = (r << cnt) | (n1 >> (32 - cnt));

  if (1
      && (! ((__builtin_constant_p (0 /* always */) && (0 /* always */) == 0) || (!(__builtin_constant_p (0 /* always */) && (0 /* always */) == 0x7fffffffL) && (un) >= (0 /* always */)))))
    {
      mp_limb_t nshift;
      for (i = un - 2; i >= 0; i--)
 {
   n0 = up[i] << 0;
   nshift = (n1 << cnt) | (n0 >> ((32 - 0) - cnt));
   do { UWtype __di; __di = __gmpn_invert_limb (d); do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((r)), "r" ((__di))); if (__builtin_constant_p (nshift) && (nshift) == 0) { _qh += (r) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((r) + 1), "%r" (_ql), "rI" ((nshift)) : "cc"); _r = (nshift) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (r) = _r; (dummy) = _qh; } while (0); } while (0);
   r >>= 0;
   n1 = n0;
 }
      do { UWtype __di; __di = __gmpn_invert_limb (d); do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((r)), "r" ((__di))); if (__builtin_constant_p (n1 << cnt) && (n1 << cnt) == 0) { _qh += (r) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((r) + 1), "%r" (_ql), "rI" ((n1 << cnt)) : "cc"); _r = (n1 << cnt) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (r) = _r; (dummy) = _qh; } while (0); } while (0);
      r >>= 0;
      return r >> cnt;
    }
  else
    {
      mp_limb_t inv, nshift;
      do { (inv) = __gmpn_invert_limb (d); } while (0);

      for (i = un - 2; i >= 0; i--)
 {
   n0 = up[i] << 0;
   nshift = (n1 << cnt) | (n0 >> ((32 - 0) - cnt));
   do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((r)), "r" ((inv))); if (__builtin_constant_p (nshift) && (nshift) == 0) { _r = ~(_qh + (r)) * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((r) + 1), "%r" (_ql), "rI" ((nshift)) : "cc"); _r = (nshift) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) _r -= (d); } (r) = _r; } while (0);
   r >>= 0;
   n1 = n0;
 }
      do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((r)), "r" ((inv))); if (__builtin_constant_p (n1 << cnt) && (n1 << cnt) == 0) { _r = ~(_qh + (r)) * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((r) + 1), "%r" (_ql), "rI" ((n1 << cnt)) : "cc"); _r = (n1 << cnt) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) _r -= (d); } (r) = _r; } while (0);
      r >>= 0;
      return r >> cnt;
    }
}

# 185 "mod_1.c"
static mp_limb_t
mpn_mod_1_norm (mp_srcptr up, mp_size_t un, mp_limb_t d)
{
  mp_size_t i;
  mp_limb_t n0, r;
  mp_limb_t dummy;

  do {} while (0);

  d <<= 0;

  do {} while (0);

  /* High limb is initial remainder, possibly with one subtract of
     d to get r<d.  */
  r = up[un - 1] << 0;
  if (r >= d)
    r -= d;
  r >>= 0;
  un--;
  if (un == 0)
    return r;

  if ((! ((__builtin_constant_p (0 /* always */) && (0 /* always */) == 0) || (!(__builtin_constant_p (0 /* always */) && (0 /* always */) == 0x7fffffffL) && (un) >= (0 /* always */)))))
    {
      for (i = un - 1; i >= 0; i--)
 {
   n0 = up[i] << 0;
   do { UWtype __di; __di = __gmpn_invert_limb (d); do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((r)), "r" ((__di))); if (__builtin_constant_p (n0) && (n0) == 0) { _qh += (r) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((r) + 1), "%r" (_ql), "rI" ((n0)) : "cc"); _r = (n0) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (r) = _r; (dummy) = _qh; } while (0); } while (0);
   r >>= 0;
 }
      return r;
    }
  else
    {
      mp_limb_t inv;
      do { (inv) = __gmpn_invert_limb (d); } while (0);
      for (i = un - 1; i >= 0; i--)
 {
   n0 = up[i] << 0;
   do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((r)), "r" ((inv))); if (__builtin_constant_p (n0) && (n0) == 0) { _r = ~(_qh + (r)) * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((r) + 1), "%r" (_ql), "rI" ((n0)) : "cc"); _r = (n0) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) _r -= (d); } (r) = _r; } while (0);
   r >>= 0;
 }
      return r;
    }
}

# 1476 "../gmp.h"
mp_limb_t __gmpn_addmul_1 (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t);

# 855 "../gmp-impl.h"
mp_limb_t __gmpn_addlsh1_n (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);

# 290 "sqr_basecase.c"
void
__gmpn_sqr_basecase (mp_ptr rp, mp_srcptr up, mp_size_t n)
{
  mp_size_t i;

  do {} while (0);
  do {} while (0);

  {
    mp_limb_t ul, lpl;
    ul = up[0];
    __asm__ ("umull %0,%1,%2,%3" : "=&r" (lpl), "=&r" (rp[1]) : "r" (ul), "r" (ul << 0));
    rp[0] = lpl >> 0;
  }
  if (n > 1)
    {
      mp_limb_t tarr[2 * 78];
      mp_ptr tp = tarr;
      mp_limb_t cy;

      /* must fit 2*n limbs in tarr */
      do {} while (0);

      cy = __gmpn_mul_1 (tp, up + 1, n - 1, up[0]);
      tp[n - 1] = cy;
      for (i = 2; i < n; i++)
 {
   mp_limb_t cy;
   cy = __gmpn_addmul_1 (tp + 2 * i - 2, up + i, n - i, up[i - 1]);
   tp[n + i - 2] = cy;
 }

      do { mp_limb_t cy; do { mp_size_t _i; for (_i = 0; _i < (n); _i++) { mp_limb_t ul, lpl; ul = (up)[_i]; __asm__ ("umull %0,%1,%2,%3" : "=&r" (lpl), "=&r" ((rp)[2 * _i + 1]) : "r" (ul), "r" (ul << 0)); (rp)[2 * _i] = lpl >> 0; } } while (0); cy = __gmpn_addlsh1_n (rp + 1, rp + 1, tp, 2 * n - 2); rp[2 * n - 1] += cy; } while (0);
    }
}

# 44 "mod_1_4.c"
void
__gmpn_mod_1s_4p_cps (mp_limb_t cps[7], mp_limb_t b)
{
  mp_limb_t bi;
  mp_limb_t B1modb, B2modb, B3modb, B4modb, B5modb;
  int cnt;

  do {} while (0);

  __asm__ ("clz\t%0, %1" : "=r" (cnt) : "r" (b));

  b <<= cnt;
  do { (bi) = __gmpn_invert_limb (b); } while (0);

  cps[0] = bi;
  cps[1] = cnt;

  B1modb = -b * ((bi >> (32 -cnt)) | (((mp_limb_t) 1L) << cnt));
  do {} while (0); /* NB: not fully reduced mod b */
  cps[2] = B1modb >> cnt;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((B1modb)), "r" ((bi))); if (__builtin_constant_p (((mp_limb_t) 0L)) && (((mp_limb_t) 0L)) == 0) { _r = ~(_qh + (B1modb)) * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((B1modb) + 1), "%r" (_ql), "rI" ((((mp_limb_t) 0L))) : "cc"); _r = (((mp_limb_t) 0L)) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (B2modb) = _r; } while (0);
  cps[3] = B2modb >> cnt;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((B2modb)), "r" ((bi))); if (__builtin_constant_p (((mp_limb_t) 0L)) && (((mp_limb_t) 0L)) == 0) { _r = ~(_qh + (B2modb)) * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((B2modb) + 1), "%r" (_ql), "rI" ((((mp_limb_t) 0L))) : "cc"); _r = (((mp_limb_t) 0L)) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (B3modb) = _r; } while (0);
  cps[4] = B3modb >> cnt;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((B3modb)), "r" ((bi))); if (__builtin_constant_p (((mp_limb_t) 0L)) && (((mp_limb_t) 0L)) == 0) { _r = ~(_qh + (B3modb)) * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((B3modb) + 1), "%r" (_ql), "rI" ((((mp_limb_t) 0L))) : "cc"); _r = (((mp_limb_t) 0L)) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (B4modb) = _r; } while (0);
  cps[5] = B4modb >> cnt;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((B4modb)), "r" ((bi))); if (__builtin_constant_p (((mp_limb_t) 0L)) && (((mp_limb_t) 0L)) == 0) { _r = ~(_qh + (B4modb)) * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((B4modb) + 1), "%r" (_ql), "rI" ((((mp_limb_t) 0L))) : "cc"); _r = (((mp_limb_t) 0L)) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (B5modb) = _r; } while (0);
  cps[6] = B5modb >> cnt;
# 88 "mod_1_4.c"
}

# 90 "mod_1_4.c"
mp_limb_t
__gmpn_mod_1s_4p (mp_srcptr ap, mp_size_t n, mp_limb_t b, const mp_limb_t cps[7])
{
  mp_limb_t rh, rl, bi, ph, pl, ch, cl, r;
  mp_limb_t B1modb, B2modb, B3modb, B4modb, B5modb;
  mp_size_t i;
  int cnt;

  do {} while (0);

  B1modb = cps[2];
  B2modb = cps[3];
  B3modb = cps[4];
  B4modb = cps[5];
  B5modb = cps[6];

  switch (n & 3)
    {
    case 0:
      __asm__ ("umull %0,%1,%2,%3" : "=&r" (pl), "=&r" (ph) : "r" (ap[n - 3]), "r" (B1modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (ph), "=&r" (pl) : "r" (ph), "rI" (((mp_limb_t) 0L)), "%r" (pl), "rI" (ap[n - 4]) : "cc");
      __asm__ ("umull %0,%1,%2,%3" : "=&r" (cl), "=&r" (ch) : "r" (ap[n - 2]), "r" (B2modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (ph), "=&r" (pl) : "r" (ph), "rI" (ch), "%r" (pl), "rI" (cl) : "cc");
      __asm__ ("umull %0,%1,%2,%3" : "=&r" (rl), "=&r" (rh) : "r" (ap[n - 1]), "r" (B3modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (rh), "=&r" (rl) : "r" (rh), "rI" (ph), "%r" (rl), "rI" (pl) : "cc");
      n -= 4;
      break;
    case 1:
      rh = 0;
      rl = ap[n - 1];
      n -= 1;
      break;
    case 2:
      rh = ap[n - 1];
      rl = ap[n - 2];
      n -= 2;
      break;
    case 3:
      __asm__ ("umull %0,%1,%2,%3" : "=&r" (pl), "=&r" (ph) : "r" (ap[n - 2]), "r" (B1modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (ph), "=&r" (pl) : "r" (ph), "rI" (((mp_limb_t) 0L)), "%r" (pl), "rI" (ap[n - 3]) : "cc");
      __asm__ ("umull %0,%1,%2,%3" : "=&r" (rl), "=&r" (rh) : "r" (ap[n - 1]), "r" (B2modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (rh), "=&r" (rl) : "r" (rh), "rI" (ph), "%r" (rl), "rI" (pl) : "cc");
      n -= 3;
      break;
    }

  for (i = n - 4; i >= 0; i -= 4)
    {
      /* rr = ap[i]				< B
	    + ap[i+1] * (B mod b)		<= (B-1)(b-1)
	    + ap[i+2] * (B^2 mod b)		<= (B-1)(b-1)
	    + ap[i+3] * (B^3 mod b)		<= (B-1)(b-1)
	    + LO(rr)  * (B^4 mod b)		<= (B-1)(b-1)
	    + HI(rr)  * (B^5 mod b)		<= (B-1)(b-1)
      */
      __asm__ ("umull %0,%1,%2,%3" : "=&r" (pl), "=&r" (ph) : "r" (ap[i + 1]), "r" (B1modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (ph), "=&r" (pl) : "r" (ph), "rI" (((mp_limb_t) 0L)), "%r" (pl), "rI" (ap[i + 0]) : "cc");

      __asm__ ("umull %0,%1,%2,%3" : "=&r" (cl), "=&r" (ch) : "r" (ap[i + 2]), "r" (B2modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (ph), "=&r" (pl) : "r" (ph), "rI" (ch), "%r" (pl), "rI" (cl) : "cc");

      __asm__ ("umull %0,%1,%2,%3" : "=&r" (cl), "=&r" (ch) : "r" (ap[i + 3]), "r" (B3modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (ph), "=&r" (pl) : "r" (ph), "rI" (ch), "%r" (pl), "rI" (cl) : "cc");

      __asm__ ("umull %0,%1,%2,%3" : "=&r" (cl), "=&r" (ch) : "r" (rl), "r" (B4modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (ph), "=&r" (pl) : "r" (ph), "rI" (ch), "%r" (pl), "rI" (cl) : "cc");

      __asm__ ("umull %0,%1,%2,%3" : "=&r" (rl), "=&r" (rh) : "r" (rh), "r" (B5modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (rh), "=&r" (rl) : "r" (rh), "rI" (ph), "%r" (rl), "rI" (pl) : "cc");
    }

  __asm__ ("umull %0,%1,%2,%3" : "=&r" (cl), "=&r" (rh) : "r" (rh), "r" (B1modb));
  __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (rh), "=&r" (rl) : "r" (rh), "rI" (((mp_limb_t) 0L)), "%r" (rl), "rI" (cl) : "cc");

  cnt = cps[1];
  bi = cps[0];

  r = (rh << cnt) | (rl >> (32 - cnt));
  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((r)), "r" ((bi))); if (__builtin_constant_p (rl << cnt) && (rl << cnt) == 0) { _r = ~(_qh + (r)) * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((r) + 1), "%r" (_ql), "rI" ((rl << cnt)) : "cc"); _r = (rl << cnt) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (r) = _r; } while (0);

  return r >> cnt;
}

# 47 "mulmid_basecase.c"
void
__gmpn_mulmid_basecase (mp_ptr rp,
                     mp_srcptr up, mp_size_t un,
                     mp_srcptr vp, mp_size_t vn)
{
  mp_limb_t lo, hi; /* last two limbs of output */
  mp_limb_t cy;

  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);

  up += vn - 1;
  un -= vn - 1;

  /* multiply by first limb, store result */
  lo = __gmpn_mul_1 (rp, up, un, vp[0]);
  hi = 0;

  /* accumulate remaining rows */
  for (vn--; vn; vn--)
    {
      up--, vp++;
      cy = __gmpn_addmul_1 (rp, up, un, vp[0]);
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (hi), "=&r" (lo) : "r" (hi), "rI" (((mp_limb_t) 0L)), "%r" (lo), "rI" (cy) : "cc");
    }

  /* store final limbs */





  rp[un] = lo;
  rp[un + 1] = hi;
}

# 181 "../gmp.h"
typedef struct
{
  __mpz_struct _mp_num;
  __mpz_struct _mp_den;
} __mpq_struct;

# 188 "../gmp.h"
typedef __mpq_struct mpq_t[1];

# 2149 "../gmp.h"
/* extern */ __inline__

int
__gmpn_cmp (mp_srcptr __gmp_xp, mp_srcptr __gmp_yp, mp_size_t __gmp_size)
{
  int __gmp_result;
  do { mp_size_t __gmp_i; mp_limb_t __gmp_x, __gmp_y; /* ASSERT ((size) >= 0); */ (__gmp_result) = 0; __gmp_i = (__gmp_size); while (--__gmp_i >= 0) { __gmp_x = (__gmp_xp)[__gmp_i]; __gmp_y = (__gmp_yp)[__gmp_i]; if (__gmp_x != __gmp_y) { /* Cannot use __gmp_x - __gmp_y, may overflow an "int" */ (__gmp_result) = (__gmp_x > __gmp_y ? 1 : -1); break; } } } while (0);
  return __gmp_result;
}

# 36 "cmp.c"
int
__gmpq_cmp (const mpq_t op1, const mpq_t op2)
{
  mp_size_t num1_size = (((&((op1)->_mp_num)))->_mp_size);
  mp_size_t den1_size = (((&((op1)->_mp_den)))->_mp_size);
  mp_size_t num2_size = (((&((op2)->_mp_num)))->_mp_size);
  mp_size_t den2_size = (((&((op2)->_mp_den)))->_mp_size);
  mp_size_t tmp1_size, tmp2_size;
  mp_ptr tmp1_ptr, tmp2_ptr;
  mp_size_t num1_sign;
  int cc;
  struct tmp_reentrant_t *__tmp_marker;

  /* need canonical signs to get right result */
  do {} while (0);
  do {} while (0);

  if (num1_size == 0)
    return -num2_size;
  if (num2_size == 0)
    return num1_size;
  if ((num1_size ^ num2_size) < 0) /* I.e. are the signs different? */
    return num1_size;

  num1_sign = num1_size;
  num1_size = ((num1_size) >= 0 ? (num1_size) : -(num1_size));
  num2_size = ((num2_size) >= 0 ? (num2_size) : -(num2_size));

  tmp1_size = num1_size + den2_size;
  tmp2_size = num2_size + den1_size;

  /* 1. Check to see if we can tell which operand is larger by just looking at
     the number of limbs.  */

  /* NUM1 x DEN2 is either TMP1_SIZE limbs or TMP1_SIZE-1 limbs.
     Same for NUM1 x DEN1 with respect to TMP2_SIZE.  */
  if (tmp1_size > tmp2_size + 1)
    /* NUM1 x DEN2 is surely larger in magnitude than NUM2 x DEN1.  */
    return num1_sign;
  if (tmp2_size > tmp1_size + 1)
    /* NUM1 x DEN2 is surely smaller in magnitude than NUM2 x DEN1.  */
    return -num1_sign;

  /* 2. Same, but compare the number of significant bits.  */
  {
    int cnt1, cnt2;
    mp_bitcnt_t bits1, bits2;

    __asm__ ("clz\t%0, %1" : "=r" (cnt1) : "r" ((((&((op1)->_mp_num)))->_mp_d)[num1_size - 1]));
    __asm__ ("clz\t%0, %1" : "=r" (cnt2) : "r" ((((&((op2)->_mp_den)))->_mp_d)[den2_size - 1]));
    bits1 = tmp1_size * (32 - 0) - cnt1 - cnt2 + 2 * 0;

    __asm__ ("clz\t%0, %1" : "=r" (cnt1) : "r" ((((&((op2)->_mp_num)))->_mp_d)[num2_size - 1]));
    __asm__ ("clz\t%0, %1" : "=r" (cnt2) : "r" ((((&((op1)->_mp_den)))->_mp_d)[den1_size - 1]));
    bits2 = tmp2_size * (32 - 0) - cnt1 - cnt2 + 2 * 0;

    if (bits1 > bits2 + 1)
      return num1_sign;
    if (bits2 > bits1 + 1)
      return -num1_sign;
  }

  /* 3. Finally, cross multiply and compare.  */

  __tmp_marker = 0;
  do { if (0) { (tmp1_ptr) = ((mp_limb_t *) (__builtin_expect ((((tmp1_size) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((tmp1_size) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (tmp1_size) * sizeof (mp_limb_t)))); (tmp2_ptr) = ((mp_limb_t *) (__builtin_expect ((((tmp2_size) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((tmp2_size) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (tmp2_size) * sizeof (mp_limb_t)))); } else { (tmp1_ptr) = ((mp_limb_t *) (__builtin_expect (((((tmp1_size) + (tmp2_size)) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca(((tmp1_size) + (tmp2_size)) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, ((tmp1_size) + (tmp2_size)) * sizeof (mp_limb_t)))); (tmp2_ptr) = (tmp1_ptr) + (tmp1_size); } } while (0);

  if (num1_size >= den2_size)
    tmp1_size -= 0 == __gmpn_mul (tmp1_ptr,
          (((&((op1)->_mp_num)))->_mp_d), num1_size,
          (((&((op2)->_mp_den)))->_mp_d), den2_size);
  else
    tmp1_size -= 0 == __gmpn_mul (tmp1_ptr,
          (((&((op2)->_mp_den)))->_mp_d), den2_size,
          (((&((op1)->_mp_num)))->_mp_d), num1_size);

   if (num2_size >= den1_size)
     tmp2_size -= 0 == __gmpn_mul (tmp2_ptr,
    (((&((op2)->_mp_num)))->_mp_d), num2_size,
    (((&((op1)->_mp_den)))->_mp_d), den1_size);
   else
     tmp2_size -= 0 == __gmpn_mul (tmp2_ptr,
    (((&((op1)->_mp_den)))->_mp_d), den1_size,
    (((&((op2)->_mp_num)))->_mp_d), num2_size);


  cc = tmp1_size - tmp2_size != 0
    ? tmp1_size - tmp2_size : __gmpn_cmp (tmp1_ptr, tmp2_ptr, tmp1_size);
  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
  return num1_sign < 0 ? -cc : cc;
}

# 2820 "../gmp-impl.h"
struct bases
{
  /* Number of digits in the conversion base that always fits in an mp_limb_t.
     For example, for base 10 on a machine where a mp_limb_t has 32 bits this
     is 9, since 10**9 is the largest number that fits into a mp_limb_t.  */
  int chars_per_limb;

  /* log(2)/log(conversion_base) */
  mp_limb_t logb2;

  /* log(conversion_base)/log(2) */
  mp_limb_t log2b;

  /* base**chars_per_limb, i.e. the biggest number that fits a word, built by
     factors of base.  Exception: For 2, 4, 8, etc, big_base is log2(base),
     i.e. the number of bits used to represent each digit in the base.  */
  mp_limb_t big_base;

  /* A GMP_LIMB_BITS bit approximation to 1/big_base, represented as a
     fixed-point number.  Instead of dividing by big_base an application can
     choose to multiply by big_base_inverted.  */
  mp_limb_t big_base_inverted;
};

# 2845 "../gmp-impl.h"
/* extern */ const struct bases __gmpn_bases[257];

# 44 "sizeinbase.c"
size_t
__gmpn_sizeinbase (mp_srcptr xp, mp_size_t xsize, int base)
{
  size_t result;
  do { int __lb_base, __cnt; size_t __totbits; do {} while (0); do {} while (0); do {} while (0); /* Special case for X == 0.  */ if ((xsize) == 0) (result) = 1; else { /* Calculate the total number of significant bits of X.  */ __asm__ ("clz\t%0, %1" : "=r" (__cnt) : "r" ((xp)[(xsize)-1])); __totbits = (size_t) (xsize) * (32 - 0) - (__cnt - 0); if ((((base) & ((base) - 1)) == 0)) { __lb_base = __gmpn_bases[base].big_base; (result) = (__totbits + __lb_base - 1) / __lb_base; } else { do { mp_limb_t _ph, _dummy; size_t _nbits = (__totbits); __asm__ ("umull %0,%1,%2,%3" : "=&r" (_dummy), "=&r" (_ph) : "r" (__gmpn_bases[base].logb2 + 1), "r" (_nbits)); result = _ph + 1; } while (0); } } } while (0);
  return result;
}

# 171 "div_qr_2.c"
static void
invert_4by2 (mp_ptr di, mp_limb_t d1, mp_limb_t d0)
{
  mp_limb_t v1, v0, p1, t1, t0, p0, mask;
  do { (v1) = __gmpn_invert_limb (d1); } while (0);
  p1 = d1 * v1;
  /* <1, v1> * d1 = <B-1, p1> */
  p1 += d0;
  if (p1 < d0)
    {
      v1--;
      mask = -(mp_limb_t) (p1 >= d1);
      p1 -= d1;
      v1 += mask;
      p1 -= mask & d1;
    }
  /* <1, v1> * d1 + d0 = <B-1, p1> */
  __asm__ ("umull %0,%1,%2,%3" : "=&r" (p0), "=&r" (t1) : "r" (d0), "r" (v1));
  p1 += t1;
  if (p1 < t1)
    {
      if (__builtin_expect ((p1 >= d1) != 0, 0))
 {
   if (p1 > d1 || p0 >= d0)
     {
       do { if (__builtin_constant_p (p0)) { if (__builtin_constant_p (p1)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (p1), "=&r" (p0) : "rI" (p1), "r" (d1), "rI" (p0), "r" (d0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (p1), "=&r" (p0) : "r" (p1), "rI" (d1), "rI" (p0), "r" (d0) : "cc"); } else if (__builtin_constant_p (p1)) { if (__builtin_constant_p (d0)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (p1), "=&r" (p0) : "rI" (p1), "r" (d1), "r" (p0), "rI" (d0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (p1), "=&r" (p0) : "rI" (p1), "r" (d1), "rI" (p0), "r" (d0) : "cc"); } else if (__builtin_constant_p (d0)) { if (__builtin_constant_p (d1)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (p1), "=&r" (p0) : "r" (p1), "rI" (d1), "r" (p0), "rI" (d0) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (p1), "=&r" (p0) : "rI" (p1), "r" (d1), "r" (p0), "rI" (d0) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (p1), "=&r" (p0) : "r" (p1), "rI" (d1), "r" (p0), "rI" (d0) : "cc"); } while (0);
       v1--;
     }
 }
      do { if (__builtin_constant_p (p0)) { if (__builtin_constant_p (p1)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (p1), "=&r" (p0) : "rI" (p1), "r" (d1), "rI" (p0), "r" (d0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (p1), "=&r" (p0) : "r" (p1), "rI" (d1), "rI" (p0), "r" (d0) : "cc"); } else if (__builtin_constant_p (p1)) { if (__builtin_constant_p (d0)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (p1), "=&r" (p0) : "rI" (p1), "r" (d1), "r" (p0), "rI" (d0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (p1), "=&r" (p0) : "rI" (p1), "r" (d1), "rI" (p0), "r" (d0) : "cc"); } else if (__builtin_constant_p (d0)) { if (__builtin_constant_p (d1)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (p1), "=&r" (p0) : "r" (p1), "rI" (d1), "r" (p0), "rI" (d0) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (p1), "=&r" (p0) : "rI" (p1), "r" (d1), "r" (p0), "rI" (d0) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (p1), "=&r" (p0) : "r" (p1), "rI" (d1), "r" (p0), "rI" (d0) : "cc"); } while (0);
      v1--;
    }
  /* Now v1 is the 3/2 inverse, <1, v1> * <d1, d0> = <B-1, p1, p0>,
   * with <p1, p0> + <d1, d0> >= B^2.
   *
   * The 4/2 inverse is (B^4 - 1) / <d1, d0> = <1, v1, v0>. The
   * partial remainder after <1, v1> is
   *
   * B^4 - 1 - B <1, v1> <d1, d0> = <B-1, B-1, B-1, B-1> - <B-1, p1, p0, 0>
   *                              = <~p1, ~p0, B-1>
   */
  do { mp_limb_t _q0, _t1, _t0, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_q0), "=&r" ((v0)) : "r" ((~p1)), "r" ((v1))); __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" ((v0)), "=&r" (_q0) : "r" ((v0)), "rI" ((~p1)), "%r" (_q0), "rI" ((~p0)) : "cc"); /* Compute the two most significant limbs of n - q'd */ (t1) = (~p0) - (d1) * (v0); do { if (__builtin_constant_p (((~ (mp_limb_t) 0)))) { if (__builtin_constant_p ((t1))) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((t1)), "=&r" ((t0)) : "rI" ((t1)), "r" ((d1)), "rI" (((~ (mp_limb_t) 0))), "r" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" ((t1)), "=&r" ((t0)) : "r" ((t1)), "rI" ((d1)), "rI" (((~ (mp_limb_t) 0))), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((t1))) { if (__builtin_constant_p ((d0))) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((t1)), "=&r" ((t0)) : "rI" ((t1)), "r" ((d1)), "r" (((~ (mp_limb_t) 0))), "rI" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((t1)), "=&r" ((t0)) : "rI" ((t1)), "r" ((d1)), "rI" (((~ (mp_limb_t) 0))), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((d0))) { if (__builtin_constant_p ((d1))) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((t1)), "=&r" ((t0)) : "r" ((t1)), "rI" ((d1)), "r" (((~ (mp_limb_t) 0))), "rI" ((d0)) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((t1)), "=&r" ((t0)) : "rI" ((t1)), "r" ((d1)), "r" (((~ (mp_limb_t) 0))), "rI" ((d0)) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((t1)), "=&r" ((t0)) : "r" ((t1)), "rI" ((d1)), "r" (((~ (mp_limb_t) 0))), "rI" ((d0)) : "cc"); } while (0); __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" ((d0)), "r" ((v0))); do { if (__builtin_constant_p ((t0))) { if (__builtin_constant_p ((t1))) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((t1)), "=&r" ((t0)) : "rI" ((t1)), "r" (_t1), "rI" ((t0)), "r" (_t0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" ((t1)), "=&r" ((t0)) : "r" ((t1)), "rI" (_t1), "rI" ((t0)), "r" (_t0) : "cc"); } else if (__builtin_constant_p ((t1))) { if (__builtin_constant_p (_t0)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((t1)), "=&r" ((t0)) : "rI" ((t1)), "r" (_t1), "r" ((t0)), "rI" (_t0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((t1)), "=&r" ((t0)) : "rI" ((t1)), "r" (_t1), "rI" ((t0)), "r" (_t0) : "cc"); } else if (__builtin_constant_p (_t0)) { if (__builtin_constant_p (_t1)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((t1)), "=&r" ((t0)) : "r" ((t1)), "rI" (_t1), "r" ((t0)), "rI" (_t0) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((t1)), "=&r" ((t0)) : "rI" ((t1)), "r" (_t1), "r" ((t0)), "rI" (_t0) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((t1)), "=&r" ((t0)) : "r" ((t1)), "rI" (_t1), "r" ((t0)), "rI" (_t0) : "cc"); } while (0); (v0)++; /* Conditionally adjust q and the remainders */ _mask = - (mp_limb_t) ((t1) >= _q0); (v0) += _mask; __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" ((t1)), "=&r" ((t0)) : "r" ((t1)), "rI" (_mask & (d1)), "%r" ((t0)), "rI" (_mask & (d0)) : "cc"); if (__builtin_expect (((t1) >= (d1)) != 0, 0)) { if ((t1) > (d1) || (t0) >= (d0)) { (v0)++; do { if (__builtin_constant_p ((t0))) { if (__builtin_constant_p ((t1))) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((t1)), "=&r" ((t0)) : "rI" ((t1)), "r" ((d1)), "rI" ((t0)), "r" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" ((t1)), "=&r" ((t0)) : "r" ((t1)), "rI" ((d1)), "rI" ((t0)), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((t1))) { if (__builtin_constant_p ((d0))) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((t1)), "=&r" ((t0)) : "rI" ((t1)), "r" ((d1)), "r" ((t0)), "rI" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((t1)), "=&r" ((t0)) : "rI" ((t1)), "r" ((d1)), "rI" ((t0)), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((d0))) { if (__builtin_constant_p ((d1))) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((t1)), "=&r" ((t0)) : "r" ((t1)), "rI" ((d1)), "r" ((t0)), "rI" ((d0)) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((t1)), "=&r" ((t0)) : "rI" ((t1)), "r" ((d1)), "r" ((t0)), "rI" ((d0)) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((t1)), "=&r" ((t0)) : "r" ((t1)), "rI" ((d1)), "r" ((t0)), "rI" ((d0)) : "cc"); } while (0); } } } while (0);
  di[0] = v0;
  di[1] = v1;
# 229 "div_qr_2.c"
}

# 231 "div_qr_2.c"
static mp_limb_t
mpn_div_qr_2n_pi2 (mp_ptr qp, mp_ptr rp, mp_srcptr np, mp_size_t nn,
     mp_limb_t d1, mp_limb_t d0, mp_limb_t di1, mp_limb_t di0)
{
  mp_limb_t qh;
  mp_size_t i;
  mp_limb_t r1, r0;

  do {} while (0);
  do {} while (0);

  r1 = np[nn-1];
  r0 = np[nn-2];

  qh = 0;
  if (r1 >= d1 && (r1 > d1 || r0 >= d0))
    {

      do { if (__builtin_constant_p (r0)) { if (__builtin_constant_p (r1)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (r1), "=&r" (r0) : "rI" (r1), "r" (d1), "rI" (r0), "r" (d0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (r1), "=&r" (r0) : "r" (r1), "rI" (d1), "rI" (r0), "r" (d0) : "cc"); } else if (__builtin_constant_p (r1)) { if (__builtin_constant_p (d0)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (r1), "=&r" (r0) : "rI" (r1), "r" (d1), "r" (r0), "rI" (d0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (r1), "=&r" (r0) : "rI" (r1), "r" (d1), "rI" (r0), "r" (d0) : "cc"); } else if (__builtin_constant_p (d0)) { if (__builtin_constant_p (d1)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (r1), "=&r" (r0) : "r" (r1), "rI" (d1), "r" (r0), "rI" (d0) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (r1), "=&r" (r0) : "rI" (r1), "r" (d1), "r" (r0), "rI" (d0) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (r1), "=&r" (r0) : "r" (r1), "rI" (d1), "r" (r0), "rI" (d0) : "cc"); } while (0);





      qh = 1;
    }

  for (i = nn - 2; i >= 2; i -= 2)
    {
      mp_limb_t n1, n0, q1, q0;
      n1 = np[i-1];
      n0 = np[i-2];
      do { mp_limb_t _q3, _q2a, _q2, _q1, _q2c, _q1c, _q1d, _q0; mp_limb_t _t1, _t0; mp_limb_t _c, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_q2a), "=&r" (_q3) : "r" (r1), "r" (di1)); __asm__ ("umull %0,%1,%2,%3" : "=&r" (_q1), "=&r" (_q2) : "r" (r0), "r" (di1)); __asm__ ("umull %0,%1,%2,%3" : "=&r" (_q1c), "=&r" (_q2c) : "r" (r1), "r" (di0)); do { UWtype __s0, __s1, __c0, __c1; __s0 = (_q1) + (_q1c); __s1 = (_q2) + (_q2c); __c0 = __s0 < (_q1); __c1 = __s1 < (_q2); (_q1) = __s0; __s1 = __s1 + __c0; (_q2) = __s1; (_q3) += __c1 + (__s1 < __c0); } while (0); __asm__ ("umull %0,%1,%2,%3" : "=&r" (_q0), "=&r" (_q1d) : "r" (r0), "r" (di0)); do { UWtype __s0, __s1, __c0, __c1; __s0 = (_q1) + (_q1d); __s1 = (_q2) + (_q2a); __c0 = __s0 < (_q1); __c1 = __s1 < (_q2); (_q1) = __s0; __s1 = __s1 + __c0; (_q2) = __s1; (_q3) += __c1 + (__s1 < __c0); } while (0); __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (r1), "=&r" (r0) : "r" (r1), "rI" (((mp_limb_t) 0L)), "%r" (r0), "rI" (((mp_limb_t) 1L)) : "cc"); /* [q3,q2,q1,q0] += [n3,n3,n1,n0] */ do { UWtype __s, __c; __s = (_q0) + (n0); __c = __s < (_q0); __s = __s + (((mp_limb_t) 0L)); (_q0) = __s; (_c) = __c + (__s < (((mp_limb_t) 0L))); } while (0); do { UWtype __s, __c; __s = (_q1) + (n1); __c = __s < (_q1); __s = __s + (_c); (_q1) = __s; (_c) = __c + (__s < (_c)); } while (0); do { UWtype __s, __c; __s = (_q2) + (r0); __c = __s < (_q2); __s = __s + (_c); (_q2) = __s; (_c) = __c + (__s < (_c)); } while (0); _q3 = _q3 + r1 + _c; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" (_q2), "r" (d0)); _t1 += _q2 * d1 + _q3 * d0; do { if (__builtin_constant_p (n0)) { if (__builtin_constant_p (n1)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (r1), "=&r" (r0) : "rI" (n1), "r" (_t1), "rI" (n0), "r" (_t0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (r1), "=&r" (r0) : "r" (n1), "rI" (_t1), "rI" (n0), "r" (_t0) : "cc"); } else if (__builtin_constant_p (n1)) { if (__builtin_constant_p (_t0)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (r1), "=&r" (r0) : "rI" (n1), "r" (_t1), "r" (n0), "rI" (_t0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (r1), "=&r" (r0) : "rI" (n1), "r" (_t1), "rI" (n0), "r" (_t0) : "cc"); } else if (__builtin_constant_p (_t0)) { if (__builtin_constant_p (_t1)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (r1), "=&r" (r0) : "r" (n1), "rI" (_t1), "r" (n0), "rI" (_t0) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (r1), "=&r" (r0) : "rI" (n1), "r" (_t1), "r" (n0), "rI" (_t0) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (r1), "=&r" (r0) : "r" (n1), "rI" (_t1), "r" (n0), "rI" (_t0) : "cc"); } while (0); _mask = -(mp_limb_t) (r1 >= _q1 & (r1 > _q1 | r0 >= _q0)); /* (r1,r0) >= (q1,q0) */ __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (r1), "=&r" (r0) : "r" (r1), "rI" (d1 & _mask), "%r" (r0), "rI" (d0 & _mask) : "cc"); do { if (__builtin_constant_p (_q2)) { if (__builtin_constant_p (_q3)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (_q3), "=&r" (_q2) : "rI" (_q3), "r" (((mp_limb_t) 0L)), "rI" (_q2), "r" (-_mask) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (_q3), "=&r" (_q2) : "r" (_q3), "rI" (((mp_limb_t) 0L)), "rI" (_q2), "r" (-_mask) : "cc"); } else if (__builtin_constant_p (_q3)) { if (__builtin_constant_p (-_mask)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (_q3), "=&r" (_q2) : "rI" (_q3), "r" (((mp_limb_t) 0L)), "r" (_q2), "rI" (-_mask) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (_q3), "=&r" (_q2) : "rI" (_q3), "r" (((mp_limb_t) 0L)), "rI" (_q2), "r" (-_mask) : "cc"); } else if (__builtin_constant_p (-_mask)) { if (__builtin_constant_p (((mp_limb_t) 0L))) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (_q3), "=&r" (_q2) : "r" (_q3), "rI" (((mp_limb_t) 0L)), "r" (_q2), "rI" (-_mask) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (_q3), "=&r" (_q2) : "rI" (_q3), "r" (((mp_limb_t) 0L)), "r" (_q2), "rI" (-_mask) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (_q3), "=&r" (_q2) : "r" (_q3), "rI" (((mp_limb_t) 0L)), "r" (_q2), "rI" (-_mask) : "cc"); } while (0); if (__builtin_expect ((r1 >= d1) != 0, 0)) { if (r1 > d1 || r0 >= d0) { do { if (__builtin_constant_p (r0)) { if (__builtin_constant_p (r1)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (r1), "=&r" (r0) : "rI" (r1), "r" (d1), "rI" (r0), "r" (d0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (r1), "=&r" (r0) : "r" (r1), "rI" (d1), "rI" (r0), "r" (d0) : "cc"); } else if (__builtin_constant_p (r1)) { if (__builtin_constant_p (d0)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (r1), "=&r" (r0) : "rI" (r1), "r" (d1), "r" (r0), "rI" (d0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (r1), "=&r" (r0) : "rI" (r1), "r" (d1), "rI" (r0), "r" (d0) : "cc"); } else if (__builtin_constant_p (d0)) { if (__builtin_constant_p (d1)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (r1), "=&r" (r0) : "r" (r1), "rI" (d1), "r" (r0), "rI" (d0) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (r1), "=&r" (r0) : "rI" (r1), "r" (d1), "r" (r0), "rI" (d0) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (r1), "=&r" (r0) : "r" (r1), "rI" (d1), "r" (r0), "rI" (d0) : "cc"); } while (0); __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_q3), "=&r" (_q2) : "r" (_q3), "rI" (((mp_limb_t) 0L)), "%r" (_q2), "rI" (((mp_limb_t) 1L)) : "cc"); } } (q1) = _q3; (q0) = _q2; } while (0);
      qp[i-1] = q1;
      qp[i-2] = q0;
    }

  if (i > 0)
    {
      mp_limb_t q;
      do { mp_limb_t _q0, _t1, _t0, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_q0), "=&r" ((q)) : "r" ((r1)), "r" ((di1))); __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" ((q)), "=&r" (_q0) : "r" ((q)), "rI" ((r1)), "%r" (_q0), "rI" ((r0)) : "cc"); /* Compute the two most significant limbs of n - q'd */ (r1) = (r0) - (d1) * (q); do { if (__builtin_constant_p ((np[0]))) { if (__builtin_constant_p ((r1))) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" ((d1)), "rI" ((np[0])), "r" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" ((d1)), "rI" ((np[0])), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((r1))) { if (__builtin_constant_p ((d0))) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" ((d1)), "r" ((np[0])), "rI" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" ((d1)), "rI" ((np[0])), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((d0))) { if (__builtin_constant_p ((d1))) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" ((d1)), "r" ((np[0])), "rI" ((d0)) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" ((d1)), "r" ((np[0])), "rI" ((d0)) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" ((d1)), "r" ((np[0])), "rI" ((d0)) : "cc"); } while (0); __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" ((d0)), "r" ((q))); do { if (__builtin_constant_p ((r0))) { if (__builtin_constant_p ((r1))) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" (_t1), "rI" ((r0)), "r" (_t0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" (_t1), "rI" ((r0)), "r" (_t0) : "cc"); } else if (__builtin_constant_p ((r1))) { if (__builtin_constant_p (_t0)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" (_t1), "r" ((r0)), "rI" (_t0) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" (_t1), "rI" ((r0)), "r" (_t0) : "cc"); } else if (__builtin_constant_p (_t0)) { if (__builtin_constant_p (_t1)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" (_t1), "r" ((r0)), "rI" (_t0) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" (_t1), "r" ((r0)), "rI" (_t0) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" (_t1), "r" ((r0)), "rI" (_t0) : "cc"); } while (0); (q)++; /* Conditionally adjust q and the remainders */ _mask = - (mp_limb_t) ((r1) >= _q0); (q) += _mask; __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" (_mask & (d1)), "%r" ((r0)), "rI" (_mask & (d0)) : "cc"); if (__builtin_expect (((r1) >= (d1)) != 0, 0)) { if ((r1) > (d1) || (r0) >= (d0)) { (q)++; do { if (__builtin_constant_p ((r0))) { if (__builtin_constant_p ((r1))) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" ((d1)), "rI" ((r0)), "r" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" ((d1)), "rI" ((r0)), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((r1))) { if (__builtin_constant_p ((d0))) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" ((d1)), "r" ((r0)), "rI" ((d0)) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" ((d1)), "rI" ((r0)), "r" ((d0)) : "cc"); } else if (__builtin_constant_p ((d0))) { if (__builtin_constant_p ((d1))) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" ((d1)), "r" ((r0)), "rI" ((d0)) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" ((r1)), "=&r" ((r0)) : "rI" ((r1)), "r" ((d1)), "r" ((r0)), "rI" ((d0)) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" ((r1)), "=&r" ((r0)) : "r" ((r1)), "rI" ((d1)), "r" ((r0)), "rI" ((d0)) : "cc"); } while (0); } } } while (0);
      qp[0] = q;
    }
  rp[1] = r1;
  rp[0] = r0;

  return qh;
}

# 291 "div_qr_2.c"
mp_limb_t
__gmpn_div_qr_2 (mp_ptr qp, mp_ptr rp, mp_srcptr np, mp_size_t nn,
       mp_srcptr dp)
{
  mp_limb_t d1;
  mp_limb_t d0;
  gmp_pi1_t dinv;

  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);

  d1 = dp[1]; d0 = dp[0];

  do {} while (0);

  if (__builtin_expect ((d1 & (((mp_limb_t) 1L) << ((32 - 0)-1))) != 0, 0))
    {
      if ((! ((__builtin_constant_p ((~ (mp_limb_t) 0)) && ((~ (mp_limb_t) 0)) == 0) || (!(__builtin_constant_p ((~ (mp_limb_t) 0)) && ((~ (mp_limb_t) 0)) == 0x7fffffffL) && (nn) >= ((~ (mp_limb_t) 0))))))
 {
   gmp_pi1_t dinv;
   do { mp_limb_t _v, _p, _t1, _t0, _mask; do { (_v) = __gmpn_invert_limb (d1); } while (0); _p = (d1) * _v; _p += (d0); if (_p < (d0)) { _v--; _mask = -(mp_limb_t) (_p >= (d1)); _p -= (d1); _v += _mask; _p -= _mask & (d1); } __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" (d0), "r" (_v)); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (d1)) != 0, 0)) { if (_p > (d1) || _t0 >= (d0)) _v--; } } (dinv).inv32 = _v; } while (0);
   return __gmpn_div_qr_2n_pi1 (qp, rp, np, nn, d1, d0, dinv.inv32);
 }
      else
 {
   mp_limb_t di[2];
   invert_4by2 (di, d1, d0);
   return mpn_div_qr_2n_pi2 (qp, rp, np, nn, d1, d0, di[1], di[0]);
 }
    }
  else
    {
      int shift;
      __asm__ ("clz\t%0, %1" : "=r" (shift) : "r" (d1));
      d1 = (d1 << shift) | (d0 >> (32 - shift));
      d0 <<= shift;
      do { mp_limb_t _v, _p, _t1, _t0, _mask; do { (_v) = __gmpn_invert_limb (d1); } while (0); _p = (d1) * _v; _p += (d0); if (_p < (d0)) { _v--; _mask = -(mp_limb_t) (_p >= (d1)); _p -= (d1); _v += _mask; _p -= _mask & (d1); } __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" (d0), "r" (_v)); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (d1)) != 0, 0)) { if (_p > (d1) || _t0 >= (d0)) _v--; } } (dinv).inv32 = _v; } while (0);
      return __gmpn_div_qr_2u_pi1 (qp, rp, np, nn, d1, d0, shift, dinv.inv32);
    }
}

# 144 "../gmp.h"
typedef long int mp_limb_signed_t;

# 4059 "../gmp-impl.h"
/* extern */ const unsigned char __gmp_jacobi_table[208];

# 4086 "../gmp-impl.h"
static inline unsigned
mpn_jacobi_update (unsigned bits, unsigned denominator, unsigned q)
{
  /* FIXME: Could halve table size by not including the e bit in the
   * index, and instead xor when updating. Then the lookup would be
   * like
   *
   *   bits ^= table[((bits & 30) << 2) + (denominator << 2) + q];
   */

  do {} while (0);
  do {} while (0);
  do {} while (0);

  /* For almost all calls, denominator is constant and quite often q
     is constant too. So use addition rather than or, so the compiler
     can put the constant part can into the offset of an indexed
     addressing instruction.

     With constant denominator, the below table lookup is compiled to

       C Constant q = 1, constant denominator = 1
       movzbl table+5(%eax,8), %eax

     or

       C q in %edx, constant denominator = 1
       movzbl table+4(%edx,%eax,8), %eax

     One could maintain the state preshifted 3 bits, to save a shift
     here, but at least on x86, that's no real saving.
  */
  return bits = __gmp_jacobi_table[(bits << 3) + (denominator << 2) + q];
}

# 4159 "../gmp-impl.h"
struct hgcd_matrix1
{
  mp_limb_t u[2][2];
};

# 45 "hgcd2_jacobi.c"
static inline mp_limb_t
div1 (mp_ptr rp,
      mp_limb_t n0,
      mp_limb_t d0)
{
  mp_limb_t q = 0;

  if ((mp_limb_signed_t) n0 < 0)
    {
      int cnt;
      for (cnt = 1; (mp_limb_signed_t) d0 >= 0; cnt++)
 {
   d0 = d0 << 1;
 }

      q = 0;
      while (cnt)
 {
   q <<= 1;
   if (n0 >= d0)
     {
       n0 = n0 - d0;
       q |= 1;
     }
   d0 = d0 >> 1;
   cnt--;
 }
    }
  else
    {
      int cnt;
      for (cnt = 0; n0 >= d0; cnt++)
 {
   d0 = d0 << 1;
 }

      q = 0;
      while (cnt)
 {
   d0 = d0 >> 1;
   q <<= 1;
   if (n0 >= d0)
     {
       n0 = n0 - d0;
       q |= 1;
     }
   cnt--;
 }
    }
  *rp = n0;
  return q;
}

# 99 "hgcd2_jacobi.c"
static inline mp_limb_t
div2 (mp_ptr rp,
      mp_limb_t nh, mp_limb_t nl,
      mp_limb_t dh, mp_limb_t dl)
{
  mp_limb_t q = 0;

  if ((mp_limb_signed_t) nh < 0)
    {
      int cnt;
      for (cnt = 1; (mp_limb_signed_t) dh >= 0; cnt++)
 {
   dh = (dh << 1) | (dl >> (32 - 1));
   dl = dl << 1;
 }

      while (cnt)
 {
   q <<= 1;
   if (nh > dh || (nh == dh && nl >= dl))
     {
       do { if (__builtin_constant_p (nl)) { if (__builtin_constant_p (nh)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (nh), "=&r" (nl) : "rI" (nh), "r" (dh), "rI" (nl), "r" (dl) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (nh), "=&r" (nl) : "r" (nh), "rI" (dh), "rI" (nl), "r" (dl) : "cc"); } else if (__builtin_constant_p (nh)) { if (__builtin_constant_p (dl)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (nh), "=&r" (nl) : "rI" (nh), "r" (dh), "r" (nl), "rI" (dl) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (nh), "=&r" (nl) : "rI" (nh), "r" (dh), "rI" (nl), "r" (dl) : "cc"); } else if (__builtin_constant_p (dl)) { if (__builtin_constant_p (dh)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (nh), "=&r" (nl) : "r" (nh), "rI" (dh), "r" (nl), "rI" (dl) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (nh), "=&r" (nl) : "rI" (nh), "r" (dh), "r" (nl), "rI" (dl) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (nh), "=&r" (nl) : "r" (nh), "rI" (dh), "r" (nl), "rI" (dl) : "cc"); } while (0);
       q |= 1;
     }
   dl = (dh << (32 - 1)) | (dl >> 1);
   dh = dh >> 1;
   cnt--;
 }
    }
  else
    {
      int cnt;
      for (cnt = 0; nh > dh || (nh == dh && nl >= dl); cnt++)
 {
   dh = (dh << 1) | (dl >> (32 - 1));
   dl = dl << 1;
 }

      while (cnt)
 {
   dl = (dh << (32 - 1)) | (dl >> 1);
   dh = dh >> 1;
   q <<= 1;
   if (nh > dh || (nh == dh && nl >= dl))
     {
       do { if (__builtin_constant_p (nl)) { if (__builtin_constant_p (nh)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (nh), "=&r" (nl) : "rI" (nh), "r" (dh), "rI" (nl), "r" (dl) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (nh), "=&r" (nl) : "r" (nh), "rI" (dh), "rI" (nl), "r" (dl) : "cc"); } else if (__builtin_constant_p (nh)) { if (__builtin_constant_p (dl)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (nh), "=&r" (nl) : "rI" (nh), "r" (dh), "r" (nl), "rI" (dl) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (nh), "=&r" (nl) : "rI" (nh), "r" (dh), "rI" (nl), "r" (dl) : "cc"); } else if (__builtin_constant_p (dl)) { if (__builtin_constant_p (dh)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (nh), "=&r" (nl) : "r" (nh), "rI" (dh), "r" (nl), "rI" (dl) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (nh), "=&r" (nl) : "rI" (nh), "r" (dh), "r" (nl), "rI" (dl) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (nh), "=&r" (nl) : "r" (nh), "rI" (dh), "r" (nl), "rI" (dl) : "cc"); } while (0);
       q |= 1;
     }
   cnt--;
 }
    }

  rp[0] = nl;
  rp[1] = nh;

  return q;
}

# 157 "hgcd2_jacobi.c"
int
__gmpn_hgcd2_jacobi (mp_limb_t ah, mp_limb_t al, mp_limb_t bh, mp_limb_t bl,
    struct hgcd_matrix1 *M, unsigned *bitsp)
{
  mp_limb_t u00, u01, u10, u11;
  unsigned bits = *bitsp;

  if (ah < 2 || bh < 2)
    return 0;

  if (ah > bh || (ah == bh && al > bl))
    {
      do { if (__builtin_constant_p (al)) { if (__builtin_constant_p (ah)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "rI" (al), "r" (bl) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (ah), "=&r" (al) : "r" (ah), "rI" (bh), "rI" (al), "r" (bl) : "cc"); } else if (__builtin_constant_p (ah)) { if (__builtin_constant_p (bl)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "r" (al), "rI" (bl) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "rI" (al), "r" (bl) : "cc"); } else if (__builtin_constant_p (bl)) { if (__builtin_constant_p (bh)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (ah), "=&r" (al) : "r" (ah), "rI" (bh), "r" (al), "rI" (bl) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "r" (al), "rI" (bl) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (ah), "=&r" (al) : "r" (ah), "rI" (bh), "r" (al), "rI" (bl) : "cc"); } while (0);
      if (ah < 2)
 return 0;

      u00 = u01 = u11 = 1;
      u10 = 0;
      bits = mpn_jacobi_update (bits, 1, 1);
    }
  else
    {
      do { if (__builtin_constant_p (bl)) { if (__builtin_constant_p (bh)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "rI" (bl), "r" (al) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (bh), "=&r" (bl) : "r" (bh), "rI" (ah), "rI" (bl), "r" (al) : "cc"); } else if (__builtin_constant_p (bh)) { if (__builtin_constant_p (al)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "r" (bl), "rI" (al) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "rI" (bl), "r" (al) : "cc"); } else if (__builtin_constant_p (al)) { if (__builtin_constant_p (ah)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (bh), "=&r" (bl) : "r" (bh), "rI" (ah), "r" (bl), "rI" (al) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "r" (bl), "rI" (al) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (bh), "=&r" (bl) : "r" (bh), "rI" (ah), "r" (bl), "rI" (al) : "cc"); } while (0);
      if (bh < 2)
 return 0;

      u00 = u10 = u11 = 1;
      u01 = 0;
      bits = mpn_jacobi_update (bits, 0, 1);
    }

  if (ah < bh)
    goto subtract_a;

  for (;;)
    {
      do {} while (0);
      if (ah == bh)
 goto done;

      if (ah < (((mp_limb_t) 1L) << (32 / 2)))
 {
   ah = (ah << (32 / 2) ) + (al >> (32 / 2));
   bh = (bh << (32 / 2) ) + (bl >> (32 / 2));

   break;
 }

      /* Subtract a -= q b, and multiply M from the right by (1 q ; 0
	 1), affecting the second column of M. */
      do {} while (0);
      do { if (__builtin_constant_p (al)) { if (__builtin_constant_p (ah)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "rI" (al), "r" (bl) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (ah), "=&r" (al) : "r" (ah), "rI" (bh), "rI" (al), "r" (bl) : "cc"); } else if (__builtin_constant_p (ah)) { if (__builtin_constant_p (bl)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "r" (al), "rI" (bl) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "rI" (al), "r" (bl) : "cc"); } else if (__builtin_constant_p (bl)) { if (__builtin_constant_p (bh)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (ah), "=&r" (al) : "r" (ah), "rI" (bh), "r" (al), "rI" (bl) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "r" (al), "rI" (bl) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (ah), "=&r" (al) : "r" (ah), "rI" (bh), "r" (al), "rI" (bl) : "cc"); } while (0);

      if (ah < 2)
 goto done;

      if (ah <= bh)
 {
   /* Use q = 1 */
   u01 += u00;
   u11 += u10;
   bits = mpn_jacobi_update (bits, 1, 1);
 }
      else
 {
   mp_limb_t r[2];
   mp_limb_t q = div2 (r, ah, al, bh, bl);
   al = r[0]; ah = r[1];
   if (ah < 2)
     {
       /* A is too small, but q is correct. */
       u01 += q * u00;
       u11 += q * u10;
       bits = mpn_jacobi_update (bits, 1, q & 3);
       goto done;
     }
   q++;
   u01 += q * u00;
   u11 += q * u10;
   bits = mpn_jacobi_update (bits, 1, q & 3);
 }
    subtract_a:
      do {} while (0);
      if (ah == bh)
 goto done;

      if (bh < (((mp_limb_t) 1L) << (32 / 2)))
 {
   ah = (ah << (32 / 2) ) + (al >> (32 / 2));
   bh = (bh << (32 / 2) ) + (bl >> (32 / 2));

   goto subtract_a1;
 }

      /* Subtract b -= q a, and multiply M from the right by (1 0 ; q
	 1), affecting the first column of M. */
      do { if (__builtin_constant_p (bl)) { if (__builtin_constant_p (bh)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "rI" (bl), "r" (al) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (bh), "=&r" (bl) : "r" (bh), "rI" (ah), "rI" (bl), "r" (al) : "cc"); } else if (__builtin_constant_p (bh)) { if (__builtin_constant_p (al)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "r" (bl), "rI" (al) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "rI" (bl), "r" (al) : "cc"); } else if (__builtin_constant_p (al)) { if (__builtin_constant_p (ah)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (bh), "=&r" (bl) : "r" (bh), "rI" (ah), "r" (bl), "rI" (al) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "r" (bl), "rI" (al) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (bh), "=&r" (bl) : "r" (bh), "rI" (ah), "r" (bl), "rI" (al) : "cc"); } while (0);

      if (bh < 2)
 goto done;

      if (bh <= ah)
 {
   /* Use q = 1 */
   u00 += u01;
   u10 += u11;
   bits = mpn_jacobi_update (bits, 0, 1);
 }
      else
 {
   mp_limb_t r[2];
   mp_limb_t q = div2 (r, bh, bl, ah, al);
   bl = r[0]; bh = r[1];
   if (bh < 2)
     {
       /* B is too small, but q is correct. */
       u00 += q * u01;
       u10 += q * u11;
       bits = mpn_jacobi_update (bits, 0, q & 3);
       goto done;
     }
   q++;
   u00 += q * u01;
   u10 += q * u11;
   bits = mpn_jacobi_update (bits, 0, q & 3);
 }
    }

  /* NOTE: Since we discard the least significant half limb, we don't
     get a truly maximal M (corresponding to |a - b| <
     2^{GMP_LIMB_BITS +1}). */
  /* Single precision loop */
  for (;;)
    {
      do {} while (0);
      if (ah == bh)
 break;

      ah -= bh;
      if (ah < (((mp_limb_t) 1L) << (32 / 2 + 1)))
 break;

      if (ah <= bh)
 {
   /* Use q = 1 */
   u01 += u00;
   u11 += u10;
   bits = mpn_jacobi_update (bits, 1, 1);
 }
      else
 {
   mp_limb_t r;
   mp_limb_t q = div1 (&r, ah, bh);
   ah = r;
   if (ah < (((mp_limb_t) 1L) << (32 / 2 + 1)))
     {
       /* A is too small, but q is correct. */
       u01 += q * u00;
       u11 += q * u10;
       bits = mpn_jacobi_update (bits, 1, q & 3);
       break;
     }
   q++;
   u01 += q * u00;
   u11 += q * u10;
   bits = mpn_jacobi_update (bits, 1, q & 3);
 }
    subtract_a1:
      do {} while (0);
      if (ah == bh)
 break;

      bh -= ah;
      if (bh < (((mp_limb_t) 1L) << (32 / 2 + 1)))
 break;

      if (bh <= ah)
 {
   /* Use q = 1 */
   u00 += u01;
   u10 += u11;
   bits = mpn_jacobi_update (bits, 0, 1);
 }
      else
 {
   mp_limb_t r;
   mp_limb_t q = div1 (&r, bh, ah);
   bh = r;
   if (bh < (((mp_limb_t) 1L) << (32 / 2 + 1)))
     {
       /* B is too small, but q is correct. */
       u00 += q * u01;
       u10 += q * u11;
       bits = mpn_jacobi_update (bits, 0, q & 3);
       break;
     }
   q++;
   u00 += q * u01;
   u10 += q * u11;
   bits = mpn_jacobi_update (bits, 0, q & 3);
 }
    }

 done:
  M->u[0][0] = u00; M->u[0][1] = u01;
  M->u[1][0] = u10; M->u[1][1] = u11;
  *bitsp = bits;

  return 1;
}

# 166 "../gmp.h"
typedef __mpz_struct mpz_t[1];

# 982 "../gmp.h"
void __gmpz_powm (mpz_ptr, mpz_srcptr, mpz_srcptr, mpz_srcptr);

# 1496 "../gmp.h"
mp_limb_t __gmpn_divrem_1 (mp_ptr, mp_size_t, mp_srcptr, mp_size_t, mp_limb_t);

# 1604 "../gmp.h"
mp_limb_t __gmpn_sub_n (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);

# 1434 "../gmp-impl.h"
mp_limb_t __gmpn_sbpi1_div_qr (mp_ptr, mp_ptr, mp_size_t, mp_srcptr, mp_size_t, mp_limb_t);

# 1443 "../gmp-impl.h"
mp_limb_t __gmpn_dcpi1_div_qr (mp_ptr, mp_ptr, mp_size_t, mp_srcptr, mp_size_t, gmp_pi1_t *);

# 1456 "../gmp-impl.h"
mp_limb_t __gmpn_mu_div_qr (mp_ptr, mp_ptr, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t, mp_ptr);

# 1458 "../gmp-impl.h"
mp_size_t __gmpn_mu_div_qr_itch (mp_size_t, mp_size_t, int);

# 3866 "../gmp-impl.h"
void __gmp_divide_by_zero (void);

# 59 "powm_ui.c"
static void
mod (mp_ptr np, mp_size_t nn, mp_srcptr dp, mp_size_t dn, gmp_pi1_t *dinv, mp_ptr tp)
{
  mp_ptr qp;
  struct tmp_reentrant_t *__tmp_marker;
  __tmp_marker = 0;

  qp = tp;

  if (dn == 1)
    {
      np[0] = __gmpn_divrem_1 (qp, (mp_size_t) 0, np, nn, dp[0]);
    }
  else if (dn == 2)
    {
      __gmpn_div_qr_2n_pi1 (qp, np, np, nn, dp[1], dp[0], dinv->inv32);
    }
  else if ((! ((__builtin_constant_p (150) && (150) == 0) || (!(__builtin_constant_p (150) && (150) == 0x7fffffffL) && (dn) >= (150)))) ||
    (! ((__builtin_constant_p (150) && (150) == 0) || (!(__builtin_constant_p (150) && (150) == 0x7fffffffL) && (nn - dn) >= (150)))))
    {
      __gmpn_sbpi1_div_qr (qp, np, nn, dp, dn, dinv->inv32);
    }
  else if ((! ((__builtin_constant_p (225) && (225) == 0) || (!(__builtin_constant_p (225) && (225) == 0x7fffffffL) && (dn) >= (225)))) || /* fast condition */
    (! ((__builtin_constant_p (2 * 2089) && (2 * 2089) == 0) || (!(__builtin_constant_p (2 * 2089) && (2 * 2089) == 0x7fffffffL) && (nn) >= (2 * 2089)))) || /* fast condition */
    (double) (2 * (2089 - 225)) * dn /* slow... */
    + (double) 225 * nn > (double) dn * nn) /* ...condition */
    {
      __gmpn_dcpi1_div_qr (qp, np, nn, dp, dn, dinv);
    }
  else
    {
      /* We need to allocate separate remainder area, since mpn_mu_div_qr does
	 not handle overlap between the numerator and remainder areas.
	 FIXME: Make it handle such overlap.  */
      mp_ptr rp = ((mp_limb_t *) __gmp_tmp_reentrant_alloc (&__tmp_marker, (dn) * sizeof (mp_limb_t)));
      mp_size_t itch = __gmpn_mu_div_qr_itch (nn, dn, 0);
      mp_ptr scratch = ((mp_limb_t *) __gmp_tmp_reentrant_alloc (&__tmp_marker, (itch) * sizeof (mp_limb_t)));
      __gmpn_mu_div_qr (qp, rp, np, nn, dp, dn, scratch);
      do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (np, rp, dn); } while (0); } while (0);
    }

  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
}

# 105 "powm_ui.c"
static void
reduce (mp_ptr tp, mp_srcptr ap, mp_size_t an, mp_srcptr mp, mp_size_t mn, gmp_pi1_t *dinv)
{
  mp_ptr rp, scratch;
  struct tmp_reentrant_t *__tmp_marker;
  __tmp_marker = 0;

  rp = ((mp_limb_t *) (__builtin_expect ((((an) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((an) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (an) * sizeof (mp_limb_t))));
  scratch = ((mp_limb_t *) (__builtin_expect ((((an - mn + 1) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((an - mn + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (an - mn + 1) * sizeof (mp_limb_t))));
  do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (rp, ap, an); } while (0); } while (0);
  mod (rp, an, mp, mn, dinv, scratch);
  do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (tp, rp, mn); } while (0); } while (0);

  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
}

# 121 "powm_ui.c"
void
__gmpz_powm_ui (mpz_ptr r, mpz_srcptr b, unsigned long int el, mpz_srcptr m)
{
  if (el < 20)
    {
      mp_ptr xp, tp, mp, bp, scratch;
      mp_size_t xn, tn, mn, bn;
      int m_zero_cnt;
      int c;
      mp_limb_t e, m2;
      gmp_pi1_t dinv;
      struct tmp_reentrant_t *__tmp_marker;

      mp = ((m)->_mp_d);
      mn = ((((m)->_mp_size)) >= 0 ? (((m)->_mp_size)) : -(((m)->_mp_size)));
      if (__builtin_expect ((mn == 0) != 0, 0))
 __gmp_divide_by_zero ();

      if (el == 0)
 {
   /* Exponent is zero, result is 1 mod M, i.e., 1 or 0 depending on if
	     M equals 1.  */
   ((r)->_mp_size) = (mn == 1 && mp[0] == 1) ? 0 : 1;
   ((r)->_mp_d)[0] = 1;
   return;
 }

      __tmp_marker = 0;

      /* Normalize m (i.e. make its most significant bit set) as required by
	 division functions below.  */
      __asm__ ("clz\t%0, %1" : "=r" (m_zero_cnt) : "r" (mp[mn - 1]));
      m_zero_cnt -= 0;
      if (m_zero_cnt != 0)
 {
   mp_ptr new_mp = ((mp_limb_t *) (__builtin_expect ((((mn) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((mn) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (mn) * sizeof (mp_limb_t))));
   __gmpn_lshift (new_mp, mp, mn, m_zero_cnt);
   mp = new_mp;
 }

      m2 = mn == 1 ? 0 : mp[mn - 2];
      do { mp_limb_t _v, _p, _t1, _t0, _mask; do { (_v) = __gmpn_invert_limb (mp[mn - 1]); } while (0); _p = (mp[mn - 1]) * _v; _p += (m2); if (_p < (m2)) { _v--; _mask = -(mp_limb_t) (_p >= (mp[mn - 1])); _p -= (mp[mn - 1]); _v += _mask; _p -= _mask & (mp[mn - 1]); } __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" (m2), "r" (_v)); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (mp[mn - 1])) != 0, 0)) { if (_p > (mp[mn - 1]) || _t0 >= (m2)) _v--; } } (dinv).inv32 = _v; } while (0);

      bn = ((((b)->_mp_size)) >= 0 ? (((b)->_mp_size)) : -(((b)->_mp_size)));
      bp = ((b)->_mp_d);
      if (bn > mn)
 {
   /* Reduce possibly huge base.  Use a function call to reduce, since we
	     don't want the quotient allocation to live until function return.  */
   mp_ptr new_bp = ((mp_limb_t *) (__builtin_expect ((((mn) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((mn) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (mn) * sizeof (mp_limb_t))));
   reduce (new_bp, bp, bn, mp, mn, &dinv);
   bp = new_bp;
   bn = mn;
   /* Canonicalize the base, since we are potentially going to multiply with
	     it quite a few times.  */
   do { while ((bn) > 0) { if ((bp)[(bn) - 1] != 0) break; (bn)--; } } while (0);
 }

      if (bn == 0)
 {
   ((r)->_mp_size) = 0;
   do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
   return;
 }

      tp = ((mp_limb_t *) (__builtin_expect ((((2 * mn + 1) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((2 * mn + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (2 * mn + 1) * sizeof (mp_limb_t))));
      xp = ((mp_limb_t *) (__builtin_expect ((((mn) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((mn) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (mn) * sizeof (mp_limb_t))));
      scratch = ((mp_limb_t *) (__builtin_expect ((((mn + 1) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((mn + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (mn + 1) * sizeof (mp_limb_t))));

      do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (xp, bp, bn); } while (0); } while (0);
      xn = bn;

      e = el;
      __asm__ ("clz\t%0, %1" : "=r" (c) : "r" (e));
      e = (e << c) << 1; /* shift the exp bits to the left, lose msb */
      c = 32 - 1 - c;

      if (c == 0)
 {
   /* If m is already normalized (high bit of high limb set), and b is
	     the same size, but a bigger value, and e==1, then there's no
	     modular reductions done and we can end up with a result out of
	     range at the end. */
   if (xn == mn && __gmpn_cmp (xp, mp, mn) >= 0)
     __gmpn_sub_n (xp, xp, mp, mn);
 }
      else
 {
   /* Main loop. */
   do
     {
       __gmpn_sqr (tp, xp, xn);
       tn = 2 * xn; tn -= tp[tn - 1] == 0;
       if (tn < mn)
  {
    do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (xp, tp, tn); } while (0); } while (0);
    xn = tn;
  }
       else
  {
    mod (tp, tn, mp, mn, &dinv, scratch);
    do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (xp, tp, mn); } while (0); } while (0);
    xn = mn;
  }

       if ((mp_limb_signed_t) e < 0)
  {
    __gmpn_mul (tp, xp, xn, bp, bn);
    tn = xn + bn; tn -= tp[tn - 1] == 0;
    if (tn < mn)
      {
        do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (xp, tp, tn); } while (0); } while (0);
        xn = tn;
      }
    else
      {
        mod (tp, tn, mp, mn, &dinv, scratch);
        do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (xp, tp, mn); } while (0); } while (0);
        xn = mn;
      }
  }
       e <<= 1;
       c--;
     }
   while (c != 0);
 }

      /* We shifted m left m_zero_cnt steps.  Adjust the result by reducing it
	 with the original M.  */
      if (m_zero_cnt != 0)
 {
   mp_limb_t cy;
   cy = __gmpn_lshift (tp, xp, xn, m_zero_cnt);
   tp[xn] = cy; xn += cy != 0;

   if (xn < mn)
     {
       do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (xp, tp, xn); } while (0); } while (0);
     }
   else
     {
       mod (tp, xn, mp, mn, &dinv, scratch);
       do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (xp, tp, mn); } while (0); } while (0);
       xn = mn;
     }
   __gmpn_rshift (xp, xp, xn, m_zero_cnt);
 }
      do { while ((xn) > 0) { if ((xp)[(xn) - 1] != 0) break; (xn)--; } } while (0);

      if ((el & 1) != 0 && ((b)->_mp_size) < 0 && xn != 0)
 {
   mp = ((m)->_mp_d); /* want original, unnormalized m */
   __gmpn_sub (xp, mp, mn, xp, xn);
   xn = mn;
   do { while ((xn) > 0) { if ((xp)[(xn) - 1] != 0) break; (xn)--; } } while (0);
 }
      (__builtin_expect (((xn) > ((r)->_mp_alloc)) != 0, 0) ? (mp_ptr) __gmpz_realloc(r,xn) : ((r)->_mp_d));
      ((r)->_mp_size) = xn;
      do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (((r)->_mp_d), xp, xn); } while (0); } while (0);

      do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
    }
  else
    {
      /* For large exponents, fake a mpz_t exponent and deflect to the more
	 sophisticated mpz_powm.  */
      mpz_t e;
      mp_limb_t ep[1];
      (ep)[0] = (el); ((e)->_mp_d) = (ep); ((e)->_mp_size) = ((ep)[0] != 0); ;;
      __gmpz_powm (r, b, e, m);
    }
}

# 39 "scan1.c"
mp_bitcnt_t
__gmpn_scan1 (mp_srcptr up, mp_bitcnt_t starting_bit)
{
  mp_size_t starting_word;
  mp_limb_t alimb;
  int cnt;
  mp_srcptr p;

  /* Start at the word implied by STARTING_BIT.  */
  starting_word = starting_bit / (32 - 0);
  p = up + starting_word;
  alimb = *p++;

  /* Mask off any bits before STARTING_BIT in the first limb.  */
  alimb &= - (mp_limb_t) 1 << (starting_bit % (32 - 0));

  while (alimb == 0)
    alimb = *p++;

  do { UWtype __ctz_x = (alimb); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (cnt) = 32 - 1 - __ctz_c; } while (0);
  return (p - up - 1) * (32 - 0) + cnt;
}

# 39 "kronzs.c"
int
__gmpz_kronecker_si (mpz_srcptr a, long b)
{
  mp_srcptr a_ptr;
  mp_size_t a_size;
  mp_limb_t a_rem, b_limb;
  int result_bit1;

  a_size = ((a)->_mp_size);
  if (a_size == 0)
    return ((b) == 1 || (b) == -1);
# 63 "kronzs.c"
  result_bit1 = ((((a_size)<0) & ((b)<0)) << 1);
  b_limb = ((b) >= 0 ? ((unsigned long) (b)) : (- (((unsigned long) ((b) + 1)) - 1)));
  a_ptr = ((a)->_mp_d);

  if ((b_limb & 1) == 0)
    {
      mp_limb_t a_low = a_ptr[0];
      int twos;

      if (b_limb == 0)
 return (((a_size) == 1 || (a_size) == -1) && (a_low) == 1); /* (a/0) */

      if (! (a_low & 1))
 return 0; /* (even/even)=0 */

      /* (a/2)=(2/a) for a odd */
      do { UWtype __ctz_x = (b_limb); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (twos) = 32 - 1 - __ctz_c; } while (0);
      b_limb >>= twos;
      result_bit1 ^= ((int) ((twos) << 1) & ((int) (((a_low) >> 1) ^ (a_low))));
    }

  if (b_limb == 1)
    return (1 - ((int) (result_bit1) & 2)); /* (a/1)=1 for any a */

  result_bit1 ^= ((((a_size) < 0) << 1) & ((int) (b_limb)));
  a_size = ((a_size) >= 0 ? (a_size) : -(a_size));

  /* (a/b) = (a mod b / b) */
  do { mp_srcptr __a_ptr = (a_ptr); mp_size_t __a_size = (a_size); mp_limb_t __b = (b_limb); do {} while (0); do {} while (0); if (((32 - 0) % 2) != 0 || ((__builtin_constant_p (41) && (41) == 0) || (!(__builtin_constant_p (41) && (41) == 0x7fffffffL) && (__a_size) >= (41)))) { (a_rem) = __gmpn_mod_1 (__a_ptr, __a_size, __b); } else { (result_bit1) ^= ((int) (__b)); (a_rem) = __gmpn_modexact_1c_odd (__a_ptr, __a_size, __b, ((mp_limb_t) 0L)); } } while (0);
  return __gmpn_jacobi_base (a_rem, b_limb, result_bit1);
}

# 48 "redc_2.c"
static mp_limb_t
mpn_addmul_2 (mp_ptr rp, mp_srcptr up, mp_size_t n, mp_srcptr vp)
{
  rp[n] = __gmpn_addmul_1 (rp, up, n, vp[0]);
  return __gmpn_addmul_1 (rp + 1, up, n, vp[1]);
}

# 81 "redc_2.c"
mp_limb_t
__gmpn_redc_2 (mp_ptr rp, mp_ptr up, mp_srcptr mp, mp_size_t n, mp_srcptr mip)
{
  mp_limb_t q[2];
  mp_size_t j;
  mp_limb_t upn;
  mp_limb_t cy;

  do {} while (0);
  do {} while (0);

  if ((n & 1) != 0)
    {
      up[0] = __gmpn_addmul_1 (up, mp, n, (up[0] * mip[0]) & ((~ ((mp_limb_t) (0))) >> 0));
      up++;
    }

  for (j = n - 2; j >= 0; j -= 2)
    {
      do { mp_limb_t _ph, _pl; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_pl), "=&r" (_ph) : "r" (mip[0]), "r" (up[0])); (q[1]) = _ph + (mip[0]) * (up[1]) + (mip[1]) * (up[0]); (q[0]) = _pl; } while (0);
      upn = up[n]; /* mpn_addmul_2 overwrites this */
      up[1] = mpn_addmul_2 (up, mp, n, q);
      up[0] = up[n];
      up[n] = upn;
      up += 2;
    }

  cy = __gmpn_add_n (rp, up, up - n, n);
  return cy;
}

# 61 "pre_divrem_1.c"
mp_limb_t
__gmpn_preinv_divrem_1 (mp_ptr qp, mp_size_t xsize,
       mp_srcptr ap, mp_size_t size, mp_limb_t d_unnorm,
       mp_limb_t dinv, int shift)
{
  mp_limb_t ahigh, qhigh, r;
  mp_size_t i;
  mp_limb_t n1, n0;
  mp_limb_t d;

  do {} while (0);
  do {} while (0);
  do {} while (0);
# 84 "pre_divrem_1.c"
  /* FIXME: What's the correct overlap rule when xsize!=0? */
  do {} while (0);

  ahigh = ap[size-1];
  d = d_unnorm << shift;
  qp += (size + xsize - 1); /* dest high limb */

  if (shift == 0)
    {
      /* High quotient limb is 0 or 1, and skip a divide step. */
      r = ahigh;
      qhigh = (r >= d);
      r = (qhigh ? r-d : r);
      *qp-- = qhigh;
      size--;

      for (i = size-1; i >= 0; i--)
 {
   n0 = ap[i];
   do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((r)), "r" ((dinv))); if (__builtin_constant_p (n0) && (n0) == 0) { _qh += (r) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((r) + 1), "%r" (_ql), "rI" ((n0)) : "cc"); _r = (n0) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (r) = _r; (*qp) = _qh; } while (0);
   qp--;
 }
    }
  else
    {
      r = 0;
      if (ahigh < d_unnorm)
 {
   r = ahigh << shift;
   *qp-- = 0;
   size--;
   if (size == 0)
     goto done_integer;
 }

      n1 = ap[size-1];
      r |= n1 >> (32 - shift);

      for (i = size-2; i >= 0; i--)
 {
   do {} while (0);
   n0 = ap[i];
   do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((r)), "r" ((dinv))); if (__builtin_constant_p (((n1 << shift) | (n0 >> (32 - shift)))) && (((n1 << shift) | (n0 >> (32 - shift)))) == 0) { _qh += (r) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((r) + 1), "%r" (_ql), "rI" ((((n1 << shift) | (n0 >> (32 - shift))))) : "cc"); _r = (((n1 << shift) | (n0 >> (32 - shift)))) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (r) = _r; (*qp) = _qh; } while (0)

                ;
   qp--;
   n1 = n0;
 }
      do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((r)), "r" ((dinv))); if (__builtin_constant_p (n1 << shift) && (n1 << shift) == 0) { _qh += (r) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((r) + 1), "%r" (_ql), "rI" ((n1 << shift)) : "cc"); _r = (n1 << shift) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (r) = _r; (*qp) = _qh; } while (0);
      qp--;
    }

 done_integer:
  for (i = 0; i < xsize; i++)
    {
      do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((r)), "r" ((dinv))); if (__builtin_constant_p (((mp_limb_t) 0L)) && (((mp_limb_t) 0L)) == 0) { _qh += (r) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((r) + 1), "%r" (_ql), "rI" ((((mp_limb_t) 0L))) : "cc"); _r = (((mp_limb_t) 0L)) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (r) = _r; (*qp) = _qh; } while (0);
      qp--;
    }

  return r >> shift;
}

# 694 "../gmp.h"
int __gmpz_cmp (mpz_srcptr, mpz_srcptr);

# 1678 "../gmp-impl.h"
int __gmpn_divisible_p (mp_srcptr, mp_size_t, mp_srcptr, mp_size_t);

# 61 "cong.c"
int
__gmpz_congruent_p (mpz_srcptr a, mpz_srcptr c, mpz_srcptr d)
{
  mp_size_t asize, csize, dsize, sign;
  mp_srcptr ap, cp, dp;
  mp_ptr xp;
  mp_limb_t alow, clow, dlow, dmask, r;
  int result;
  struct tmp_reentrant_t *__tmp_marker;

  dsize = ((d)->_mp_size);
  if (__builtin_expect ((dsize == 0) != 0, 0))
    return (__gmpz_cmp (a, c) == 0);

  dsize = ((dsize) >= 0 ? (dsize) : -(dsize));
  dp = ((d)->_mp_d);

  if (((((a)->_mp_size)) >= 0 ? (((a)->_mp_size)) : -(((a)->_mp_size))) < ((((c)->_mp_size)) >= 0 ? (((c)->_mp_size)) : -(((c)->_mp_size))))
    do { mpz_srcptr __mpz_srcptr_swap__tmp = (a); (a) = (c); (c) = __mpz_srcptr_swap__tmp; } while (0);

  asize = ((a)->_mp_size);
  csize = ((c)->_mp_size);
  sign = (asize ^ csize);

  asize = ((asize) >= 0 ? (asize) : -(asize));
  ap = ((a)->_mp_d);

  if (csize == 0)
    return __gmpn_divisible_p (ap, asize, dp, dsize);

  csize = ((csize) >= 0 ? (csize) : -(csize));
  cp = ((c)->_mp_d);

  alow = ap[0];
  clow = cp[0];
  dlow = dp[0];

  /* Check a==c mod low zero bits of dlow.  This might catch a few cases of
     a!=c quickly, and it helps the csize==1 special cases below.  */
  dmask = (((dlow) & -(dlow)) - 1) & ((~ ((mp_limb_t) (0))) >> 0);
  alow = (sign >= 0 ? alow : -alow);
  if (((alow-clow) & dmask) != 0)
    return 0;

  if (csize == 1)
    {
      if (dsize == 1)
 {
 cong_1:
   if (sign < 0)
     do { do {} while (0); do {} while (0); do {} while (0); if ((clow) <= (dlow)) { /* small a is reasonably likely */ (clow) = (dlow) - (clow); } else { unsigned __twos; mp_limb_t __dnorm; __asm__ ("clz\t%0, %1" : "=r" (__twos) : "r" (dlow)); __twos -= 0; __dnorm = (dlow) << __twos; (clow) = ((clow) <= __dnorm ? __dnorm : 2*__dnorm) - (clow); } do {} while (0); } while (0);

   if (((__builtin_constant_p (41) && (41) == 0) || (!(__builtin_constant_p (41) && (41) == 0x7fffffffL) && (asize) >= (41))))
     {
       r = __gmpn_mod_1 (ap, asize, dlow);
       if (clow < dlow)
  return r == clow;
       else
  return r == (clow % dlow);
     }

   if ((dlow & 1) == 0)
     {
       /* Strip low zero bits to get odd d required by modexact.  If
		 d==e*2^n then a==c mod d if and only if both a==c mod e and
		 a==c mod 2^n, the latter having been done above.  */
       unsigned twos;
       do { UWtype __ctz_x = (dlow); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (twos) = 32 - 1 - __ctz_c; } while (0);
       dlow >>= twos;
     }

   r = __gmpn_modexact_1c_odd (ap, asize, dlow, clow);
   return r == 0 || r == dlow;
 }

      /* dlow==0 is avoided since we don't want to bother handling extra low
	 zero bits if dsecond is even (would involve borrow if a,c differ in
	 sign and alow,clow!=0).  */
      if (dsize == 2 && dlow != 0)
 {
   mp_limb_t dsecond = dp[1];

   if (dsecond <= dmask)
     {
       unsigned twos;
       do { UWtype __ctz_x = (dlow); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (twos) = 32 - 1 - __ctz_c; } while (0);
       dlow = (dlow >> twos) | (dsecond << ((32 - 0)-twos));
       do {} while (0);

       /* dlow will be odd here, so the test for it even under cong_1
		 is unnecessary, but the rest of that code is wanted. */
       goto cong_1;
     }
 }
    }

  __tmp_marker = 0;
  xp = ((mp_limb_t *) (__builtin_expect ((((asize+1) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((asize+1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (asize+1) * sizeof (mp_limb_t))));

  /* calculate abs(a-c) */
  if (sign >= 0)
    {
      /* same signs, subtract */
      if (asize > csize || __gmpn_cmp (ap, cp, asize) >= 0)
 (__gmpn_sub (xp, ap, asize, cp, csize));
      else
 (__gmpn_sub_n (xp, cp, ap, asize));
      do { while ((asize) > 0) { if ((xp)[(asize) - 1] != 0) break; (asize)--; } } while (0);
    }
  else
    {
      /* different signs, add */
      mp_limb_t carry;
      carry = __gmpn_add (xp, ap, asize, cp, csize);
      xp[asize] = carry;
      asize += (carry != 0);
    }

  result = __gmpn_divisible_p (xp, asize, dp, dsize);

  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
  return result;
}

# 707 "../gmp-impl.h"
/* extern */ void * (*__gmp_allocate_func) (size_t);

# 48 "export.c"
void *
__gmpz_export (void *data, size_t *countp, int order,
     size_t size, int endian, size_t nail, mpz_srcptr z)
{
  mp_size_t zsize;
  mp_srcptr zp;
  size_t count, dummy;
  unsigned long numb;
  unsigned align;

  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0); /* nail < 8*size+(SIZ(z)==0) */

  if (countp == 
# 63 "export.c" 3 4
               ((void *)0)
# 63 "export.c"
                   )
    countp = &dummy;

  zsize = ((z)->_mp_size);
  if (zsize == 0)
    {
      *countp = 0;
      return data;
    }

  zsize = ((zsize) >= 0 ? (zsize) : -(zsize));
  zp = ((z)->_mp_d);
  numb = 8*size - nail;
  do { int __cnt; mp_bitcnt_t __totbits; do {} while (0); do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__cnt) : "r" ((zp)[(zsize)-1])); __totbits = (mp_bitcnt_t) (zsize) * (32 - 0) - (__cnt - 0); (count) = (__totbits + (numb)-1) / (numb); } while (0);
  *countp = count;

  if (data == 
# 79 "export.c" 3 4
             ((void *)0)
# 79 "export.c"
                 )
    data = (*__gmp_allocate_func) (count*size);

  if (endian == 0)
    endian = (-1);

  align = ((char *) data - (char *) 
# 85 "export.c" 3 4
                                   ((void *)0)
# 85 "export.c"
                                       ) % sizeof (mp_limb_t);

  if (nail == 0)
    {
      if (size == sizeof (mp_limb_t) && align == 0)
 {
   if (order == -1 && endian == (-1))
     {
       do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi ((mp_ptr) data, zp, (mp_size_t) count); } while (0); } while (0);
       return data;
     }
   if (order == 1 && endian == (-1))
     {
       do { mp_ptr __dst = ((mp_ptr) data); mp_size_t __size = ((mp_size_t) count); mp_srcptr __src = (zp) + __size - 1; mp_size_t __i; do {} while (0); do {} while (0); ; for (__i = 0; __i < __size; __i++) { *__dst = *__src; __dst++; __src--; } } while (0);
       return data;
     }

   if (order == -1 && endian == -(-1))
     {
       do { mp_ptr __dst = ((mp_ptr) data); mp_srcptr __src = (zp); mp_size_t __size = ((mp_size_t) count); mp_size_t __i; do {} while (0); do {} while (0); ; for (__i = 0; __i < __size; __i++) { do { (*__dst) = ((*(__src)) << 24) + (((*(__src)) & 0xFF00) << 8) + (((*(__src)) >> 8) & 0xFF00) + ((*(__src)) >> 24); } while (0); __dst++; __src++; } } while (0);
       return data;
     }
   if (order == 1 && endian == -(-1))
     {
       do { mp_ptr __dst = ((mp_ptr) data); mp_size_t __size = ((mp_size_t) count); mp_srcptr __src = (zp) + __size - 1; mp_size_t __i; do {} while (0); do {} while (0); ; for (__i = 0; __i < __size; __i++) { do { (*__dst) = ((*(__src)) << 24) + (((*(__src)) & 0xFF00) << 8) + (((*(__src)) >> 8) & 0xFF00) + ((*(__src)) >> 24); } while (0); __dst++; __src--; } } while (0);
       return data;
     }
 }
    }

  {
    mp_limb_t limb, wbitsmask;
    size_t i, numb;
    mp_size_t j, wbytes, woffset;
    unsigned char *dp;
    int lbits, wbits;
    mp_srcptr zend;

    numb = size * 8 - nail;

    /* whole bytes per word */
    wbytes = numb / 8;

    /* possible partial byte */
    wbits = numb % 8;
    wbitsmask = (((mp_limb_t) 1L) << wbits) - 1;

    /* offset to get to the next word */
    woffset = (endian >= 0 ? size : - (mp_size_t) size)
      + (order < 0 ? size : - (mp_size_t) size);

    /* least significant byte */
    dp = (unsigned char *) data
      + (order >= 0 ? (count-1)*size : 0) + (endian >= 0 ? size-1 : 0);
# 158 "export.c"
    zend = zp + zsize;
    lbits = 0;
    limb = 0;
    for (i = 0; i < count; i++)
      {
 for (j = 0; j < wbytes; j++)
   {
     do { if (lbits >= (8)) { *dp = limb + 0; limb >>= (8); lbits -= (8); } else { mp_limb_t newlimb; newlimb = (zp == zend ? 0 : *zp++); *dp = (limb | (newlimb << lbits)) + 0; limb = newlimb >> ((8)-lbits); lbits += (32 - 0) - (8); } } while (0);
     dp -= endian;
   }
 if (wbits != 0)
   {
     do { if (lbits >= (wbits)) { *dp = limb & wbitsmask; limb >>= (wbits); lbits -= (wbits); } else { mp_limb_t newlimb; newlimb = (zp == zend ? 0 : *zp++); *dp = (limb | (newlimb << lbits)) & wbitsmask; limb = newlimb >> ((wbits)-lbits); lbits += (32 - 0) - (wbits); } } while (0);
     dp -= endian;
     j++;
   }
 for ( ; j < size; j++)
   {
     *dp = '\0';
     dp -= endian;
   }
 dp += woffset;
      }

    do {} while (0);

    /* low byte of word after most significant */
    do {} while (0)

                                                ;
  }
  return data;
}

# 225 "hgcd2.c"
int
__gmpn_hgcd2 (mp_limb_t ah, mp_limb_t al, mp_limb_t bh, mp_limb_t bl,
    struct hgcd_matrix1 *M)
{
  mp_limb_t u00, u01, u10, u11;

  if (ah < 2 || bh < 2)
    return 0;

  if (ah > bh || (ah == bh && al > bl))
    {
      do { if (__builtin_constant_p (al)) { if (__builtin_constant_p (ah)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "rI" (al), "r" (bl) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (ah), "=&r" (al) : "r" (ah), "rI" (bh), "rI" (al), "r" (bl) : "cc"); } else if (__builtin_constant_p (ah)) { if (__builtin_constant_p (bl)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "r" (al), "rI" (bl) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "rI" (al), "r" (bl) : "cc"); } else if (__builtin_constant_p (bl)) { if (__builtin_constant_p (bh)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (ah), "=&r" (al) : "r" (ah), "rI" (bh), "r" (al), "rI" (bl) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "r" (al), "rI" (bl) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (ah), "=&r" (al) : "r" (ah), "rI" (bh), "r" (al), "rI" (bl) : "cc"); } while (0);
      if (ah < 2)
 return 0;

      u00 = u01 = u11 = 1;
      u10 = 0;
    }
  else
    {
      do { if (__builtin_constant_p (bl)) { if (__builtin_constant_p (bh)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "rI" (bl), "r" (al) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (bh), "=&r" (bl) : "r" (bh), "rI" (ah), "rI" (bl), "r" (al) : "cc"); } else if (__builtin_constant_p (bh)) { if (__builtin_constant_p (al)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "r" (bl), "rI" (al) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "rI" (bl), "r" (al) : "cc"); } else if (__builtin_constant_p (al)) { if (__builtin_constant_p (ah)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (bh), "=&r" (bl) : "r" (bh), "rI" (ah), "r" (bl), "rI" (al) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "r" (bl), "rI" (al) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (bh), "=&r" (bl) : "r" (bh), "rI" (ah), "r" (bl), "rI" (al) : "cc"); } while (0);
      if (bh < 2)
 return 0;

      u00 = u10 = u11 = 1;
      u01 = 0;
    }

  if (ah < bh)
    goto subtract_a;

  for (;;)
    {
      do {} while (0);
      if (ah == bh)
 goto done;

      if (ah < (((mp_limb_t) 1L) << (32 / 2)))
 {
   ah = (ah << (32 / 2) ) + (al >> (32 / 2));
   bh = (bh << (32 / 2) ) + (bl >> (32 / 2));

   break;
 }

      /* Subtract a -= q b, and multiply M from the right by (1 q ; 0
	 1), affecting the second column of M. */
      do {} while (0);
      do { if (__builtin_constant_p (al)) { if (__builtin_constant_p (ah)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "rI" (al), "r" (bl) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (ah), "=&r" (al) : "r" (ah), "rI" (bh), "rI" (al), "r" (bl) : "cc"); } else if (__builtin_constant_p (ah)) { if (__builtin_constant_p (bl)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "r" (al), "rI" (bl) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "rI" (al), "r" (bl) : "cc"); } else if (__builtin_constant_p (bl)) { if (__builtin_constant_p (bh)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (ah), "=&r" (al) : "r" (ah), "rI" (bh), "r" (al), "rI" (bl) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "r" (al), "rI" (bl) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (ah), "=&r" (al) : "r" (ah), "rI" (bh), "r" (al), "rI" (bl) : "cc"); } while (0);

      if (ah < 2)
 goto done;

      if (ah <= bh)
 {
   /* Use q = 1 */
   u01 += u00;
   u11 += u10;
 }
      else
 {
   mp_limb_t r[2];
   mp_limb_t q = div2 (r, ah, al, bh, bl);
   al = r[0]; ah = r[1];
   if (ah < 2)
     {
       /* A is too small, but q is correct. */
       u01 += q * u00;
       u11 += q * u10;
       goto done;
     }
   q++;
   u01 += q * u00;
   u11 += q * u10;
 }
    subtract_a:
      do {} while (0);
      if (ah == bh)
 goto done;

      if (bh < (((mp_limb_t) 1L) << (32 / 2)))
 {
   ah = (ah << (32 / 2) ) + (al >> (32 / 2));
   bh = (bh << (32 / 2) ) + (bl >> (32 / 2));

   goto subtract_a1;
 }

      /* Subtract b -= q a, and multiply M from the right by (1 0 ; q
	 1), affecting the first column of M. */
      do { if (__builtin_constant_p (bl)) { if (__builtin_constant_p (bh)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "rI" (bl), "r" (al) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (bh), "=&r" (bl) : "r" (bh), "rI" (ah), "rI" (bl), "r" (al) : "cc"); } else if (__builtin_constant_p (bh)) { if (__builtin_constant_p (al)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "r" (bl), "rI" (al) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "rI" (bl), "r" (al) : "cc"); } else if (__builtin_constant_p (al)) { if (__builtin_constant_p (ah)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (bh), "=&r" (bl) : "r" (bh), "rI" (ah), "r" (bl), "rI" (al) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "r" (bl), "rI" (al) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (bh), "=&r" (bl) : "r" (bh), "rI" (ah), "r" (bl), "rI" (al) : "cc"); } while (0);

      if (bh < 2)
 goto done;

      if (bh <= ah)
 {
   /* Use q = 1 */
   u00 += u01;
   u10 += u11;
 }
      else
 {
   mp_limb_t r[2];
   mp_limb_t q = div2 (r, bh, bl, ah, al);
   bl = r[0]; bh = r[1];
   if (bh < 2)
     {
       /* B is too small, but q is correct. */
       u00 += q * u01;
       u10 += q * u11;
       goto done;
     }
   q++;
   u00 += q * u01;
   u10 += q * u11;
 }
    }

  /* NOTE: Since we discard the least significant half limb, we don't
     get a truly maximal M (corresponding to |a - b| <
     2^{GMP_LIMB_BITS +1}). */
  /* Single precision loop */
  for (;;)
    {
      do {} while (0);

      ah -= bh;
      if (ah < (((mp_limb_t) 1L) << (32 / 2 + 1)))
 break;

      if (ah <= bh)
 {
   /* Use q = 1 */
   u01 += u00;
   u11 += u10;
 }
      else
 {
   mp_limb_t r;
   mp_limb_t q = div1 (&r, ah, bh);
   ah = r;
   if (ah < (((mp_limb_t) 1L) << (32 / 2 + 1)))
     {
       /* A is too small, but q is correct. */
       u01 += q * u00;
       u11 += q * u10;
       break;
     }
   q++;
   u01 += q * u00;
   u11 += q * u10;
 }
    subtract_a1:
      do {} while (0);

      bh -= ah;
      if (bh < (((mp_limb_t) 1L) << (32 / 2 + 1)))
 break;

      if (bh <= ah)
 {
   /* Use q = 1 */
   u00 += u01;
   u10 += u11;
 }
      else
 {
   mp_limb_t r;
   mp_limb_t q = div1 (&r, bh, ah);
   bh = r;
   if (bh < (((mp_limb_t) 1L) << (32 / 2 + 1)))
     {
       /* B is too small, but q is correct. */
       u00 += q * u01;
       u10 += q * u11;
       break;
     }
   q++;
   u00 += q * u01;
   u10 += q * u11;
 }
    }

 done:
  M->u[0][0] = u00; M->u[0][1] = u01;
  M->u[1][0] = u10; M->u[1][1] = u11;

  return 1;
}

# 187 "div_qr_1n_pi1.c"
mp_limb_t
__gmpn_div_qr_1n_pi1 (mp_ptr qp, mp_srcptr up, mp_size_t n, mp_limb_t u1,
     mp_limb_t d, mp_limb_t dinv)
{
  mp_limb_t B2;
  mp_limb_t u0, u2;
  mp_limb_t q0, q1;
  mp_limb_t p0, p1;
  mp_limb_t t;
  mp_size_t j;

  do {} while (0);
  do {} while (0);
  do {} while (0);

  if (n == 1)
    {
      do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((u1)), "r" ((dinv))); if (__builtin_constant_p (up[0]) && (up[0]) == 0) { _qh += (u1) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((u1) + 1), "%r" (_ql), "rI" ((up[0])) : "cc"); _r = (up[0]) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (u1) = _r; (qp[0]) = _qh; } while (0);
      return u1;
    }

  /* FIXME: Could be precomputed */
  B2 = -d*dinv;

  __asm__ ("umull %0,%1,%2,%3" : "=&r" (q0), "=&r" (q1) : "r" (dinv), "r" (u1));
  __asm__ ("umull %0,%1,%2,%3" : "=&r" (p0), "=&r" (p1) : "r" (B2), "r" (u1));
  q1 += u1;
  do {} while (0);
  u0 = up[n-1]; /* Early read, to allow qp == up. */
  qp[n-1] = q1;

  __asm__ ( "adds	%2, %5, %6\n\t" "adcs	%1, %3, %4\n\t" "movcc	%0, #0\n\t" "movcs	%0, #-1" : "=r" (u2), "=r" (u1), "=&r" (u0) : "r" (u0), "rI" (p1), "%r" (up[n-2]), "rI" (p0) : "cc");

  /* FIXME: Keep q1 in a variable between iterations, to reduce number
     of memory accesses. */
  for (j = n-2; j-- > 0; )
    {
      mp_limb_t q2, cy;

      /* Additions for the q update:
       *	+-------+
       *        |u1 * v |
       *        +---+---+
       *        | u1|
       *    +---+---+
       *    | 1 | v |  (conditional on u2)
       *    +---+---+
       *        | 1 |  (conditional on u0 + u2 B2 carry)
       *        +---+
       * +      | q0|
       *   -+---+---+---+
       *    | q2| q1| q0|
       *    +---+---+---+
      */
      __asm__ ("umull %0,%1,%2,%3" : "=&r" (t), "=&r" (p1) : "r" (u1), "r" (dinv));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (q2), "=&r" (q1) : "r" (-u2), "rI" (((mp_limb_t) 0L)), "%r" (u2 & dinv), "rI" (u1) : "cc");
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (q2), "=&r" (q1) : "r" (q2), "rI" (((mp_limb_t) 0L)), "%r" (q1), "rI" (p1) : "cc");
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (q2), "=&r" (q1) : "r" (q2), "rI" (((mp_limb_t) 0L)), "%r" (q1), "rI" (q0) : "cc");
      q0 = t;

      __asm__ ("umull %0,%1,%2,%3" : "=&r" (p0), "=&r" (p1) : "r" (u1), "r" (B2));
      do { mp_limb_t __x = (u0); mp_limb_t __y = (u2 & B2); mp_limb_t __w = __x + __y; (u0) = __w; (cy) = __w < __x; } while (0);
      u0 -= (-cy) & d;

      /* Final q update */
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (q2), "=&r" (q1) : "r" (q2), "rI" (((mp_limb_t) 0L)), "%r" (q1), "rI" (cy) : "cc");
      qp[j+1] = q1;
      do { mp_limb_t __x; mp_ptr __p = (qp+j+2); if (__builtin_constant_p (q2) && (q2) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (q2); *__p = __x; if (__x < (q2)) while (++(*(++__p)) == 0) ; } } while (0);

      __asm__ ( "adds	%2, %5, %6\n\t" "adcs	%1, %3, %4\n\t" "movcc	%0, #0\n\t" "movcs	%0, #-1" : "=r" (u2), "=r" (u1), "=&r" (u0) : "r" (u0), "rI" (p1), "%r" (up[j]), "rI" (p0) : "cc");
    }

  q1 = (u2 > 0);
  u1 -= (-q1) & d;

  t = (u1 >= d);
  q1 += t;
  u1 -= (-t) & d;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((u1)), "r" ((dinv))); if (__builtin_constant_p (u0) && (u0) == 0) { _qh += (u1) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((u1) + 1), "%r" (_ql), "rI" ((u0)) : "cc"); _r = (u0) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (u0) = _r; (t) = _qh; } while (0);
  __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (q1), "=&r" (q0) : "r" (q1), "rI" (((mp_limb_t) 0L)), "%r" (q0), "rI" (t) : "cc");

  do { mp_limb_t __x; mp_ptr __p = (qp+1); if (__builtin_constant_p (q1) && (q1) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (q1); *__p = __x; if (__x < (q1)) while (++(*(++__p)) == 0) ; } } while (0);

  qp[0] = q0;
  return u0;
}

# 173 "jacobi_2.c"
int
__gmpn_jacobi_2 (mp_srcptr ap, mp_srcptr bp, unsigned bit)
{
  mp_limb_t ah, al, bh, bl;
  int c;

  al = ap[0];
  ah = ap[1];
  bl = bp[0];
  bh = bp[1];

  do {} while (0);

  /* Use bit 1. */
  bit <<= 1;

  if (bh == 0 && bl == 1)
    /* (a|1) = 1 */
    return 1 - (bit & 2);

  if (al == 0)
    {
      if (ah == 0)
 /* (0|b) = 0, b > 1 */
 return 0;

      do { UWtype __ctz_x = (ah); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (c) = 32 - 1 - __ctz_c; } while (0);
      bit ^= (((32 - 0) + c) << 1) & (bl ^ (bl >> 1));

      al = bl;
      bl = ah >> c;

      if (bl == 1)
 /* (1|b) = 1 */
 return 1 - (bit & 2);

      ah = bh;

      bit ^= al & bl;

      goto b_reduced;
    }
  if ( (al & 1) == 0)
    {
      do { UWtype __ctz_x = (al); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (c) = 32 - 1 - __ctz_c; } while (0);

      al = ((ah << ((32 - 0) - c)) & ((~ ((mp_limb_t) (0))) >> 0)) | (al >> c);
      ah >>= c;
      bit ^= (c << 1) & (bl ^ (bl >> 1));
    }
  if (ah == 0)
    {
      if (bh > 0)
 {
   bit ^= al & bl;
   do { mp_limb_t __mp_limb_t_swap__tmp = (al); (al) = (bl); (bl) = __mp_limb_t_swap__tmp; } while (0);
   ah = bh;
   goto b_reduced;
 }
      goto ab_reduced;
    }

  while (bh > 0)
    {
      /* Compute (a|b) */
      while (ah > bh)
 {
   do { if (__builtin_constant_p (al)) { if (__builtin_constant_p (ah)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "rI" (al), "r" (bl) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (ah), "=&r" (al) : "r" (ah), "rI" (bh), "rI" (al), "r" (bl) : "cc"); } else if (__builtin_constant_p (ah)) { if (__builtin_constant_p (bl)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "r" (al), "rI" (bl) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "rI" (al), "r" (bl) : "cc"); } else if (__builtin_constant_p (bl)) { if (__builtin_constant_p (bh)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (ah), "=&r" (al) : "r" (ah), "rI" (bh), "r" (al), "rI" (bl) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (ah), "=&r" (al) : "rI" (ah), "r" (bh), "r" (al), "rI" (bl) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (ah), "=&r" (al) : "r" (ah), "rI" (bh), "r" (al), "rI" (bl) : "cc"); } while (0);
   if (al == 0)
     {
       do { UWtype __ctz_x = (ah); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (c) = 32 - 1 - __ctz_c; } while (0);
       bit ^= (((32 - 0) + c) << 1) & (bl ^ (bl >> 1));

       al = bl;
       bl = ah >> c;
       ah = bh;

       bit ^= al & bl;
       goto b_reduced;
     }
   do { UWtype __ctz_x = (al); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (c) = 32 - 1 - __ctz_c; } while (0);
   bit ^= (c << 1) & (bl ^ (bl >> 1));
   al = ((ah << ((32 - 0) - c)) & ((~ ((mp_limb_t) (0))) >> 0)) | (al >> c);
   ah >>= c;
 }
      if (ah == bh)
 goto cancel_hi;

      if (ah == 0)
 {
   bit ^= al & bl;
   do { mp_limb_t __mp_limb_t_swap__tmp = (al); (al) = (bl); (bl) = __mp_limb_t_swap__tmp; } while (0);
   ah = bh;
   break;
 }

      bit ^= al & bl;

      /* Compute (b|a) */
      while (bh > ah)
 {
   do { if (__builtin_constant_p (bl)) { if (__builtin_constant_p (bh)) __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "rI" (bl), "r" (al) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\tsbc\t%0, %2, %3" : "=r" (bh), "=&r" (bl) : "r" (bh), "rI" (ah), "rI" (bl), "r" (al) : "cc"); } else if (__builtin_constant_p (bh)) { if (__builtin_constant_p (al)) __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "r" (bl), "rI" (al) : "cc"); else __asm__ ("rsbs\t%1, %5, %4\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "rI" (bl), "r" (al) : "cc"); } else if (__builtin_constant_p (al)) { if (__builtin_constant_p (ah)) __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (bh), "=&r" (bl) : "r" (bh), "rI" (ah), "r" (bl), "rI" (al) : "cc"); else __asm__ ("subs\t%1, %4, %5\n\trsc\t%0, %3, %2" : "=r" (bh), "=&r" (bl) : "rI" (bh), "r" (ah), "r" (bl), "rI" (al) : "cc"); } else /* only bh might be a constant */ __asm__ ("subs\t%1, %4, %5\n\tsbc\t%0, %2, %3" : "=r" (bh), "=&r" (bl) : "r" (bh), "rI" (ah), "r" (bl), "rI" (al) : "cc"); } while (0);
   if (bl == 0)
     {
       do { UWtype __ctz_x = (bh); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (c) = 32 - 1 - __ctz_c; } while (0);
       bit ^= (((32 - 0) + c) << 1) & (al ^ (al >> 1));

       bl = bh >> c;
       bit ^= al & bl;
       goto b_reduced;
     }
   do { UWtype __ctz_x = (bl); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (c) = 32 - 1 - __ctz_c; } while (0);
   bit ^= (c << 1) & (al ^ (al >> 1));
   bl = ((bh << ((32 - 0) - c)) & ((~ ((mp_limb_t) (0))) >> 0)) | (bl >> c);
   bh >>= c;
 }
      bit ^= al & bl;

      /* Compute (a|b) */
      if (ah == bh)
 {
 cancel_hi:
   if (al < bl)
     {
       do { mp_limb_t __mp_limb_t_swap__tmp = (al); (al) = (bl); (bl) = __mp_limb_t_swap__tmp; } while (0);
       bit ^= al & bl;
     }
   al -= bl;
   if (al == 0)
     return 0;

   do { UWtype __ctz_x = (al); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (c) = 32 - 1 - __ctz_c; } while (0);
   bit ^= (c << 1) & (bl ^ (bl >> 1));
   al >>= c;

   if (al == 1)
     return 1 - (bit & 2);

   do { mp_limb_t __mp_limb_t_swap__tmp = (al); (al) = (bl); (bl) = __mp_limb_t_swap__tmp; } while (0);
   bit ^= al & bl;
   break;
 }
    }

 b_reduced:
  /* Compute (a|b), with b a single limb. */
  do {} while (0);

  if (bl == 1)
    /* (a|1) = 1 */
    return 1 - (bit & 2);

  while (ah > 0)
    {
      ah -= (al < bl);
      al -= bl;
      if (al == 0)
 {
   if (ah == 0)
     return 0;
   do { UWtype __ctz_x = (ah); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (c) = 32 - 1 - __ctz_c; } while (0);
   bit ^= (((32 - 0) + c) << 1) & (bl ^ (bl >> 1));
   al = ah >> c;
   goto ab_reduced;
 }
      do { UWtype __ctz_x = (al); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (c) = 32 - 1 - __ctz_c; } while (0);

      al = ((ah << ((32 - 0) - c)) & ((~ ((mp_limb_t) (0))) >> 0)) | (al >> c);
      ah >>= c;
      bit ^= (c << 1) & (bl ^ (bl >> 1));
    }
 ab_reduced:
  do {} while (0);
  do {} while (0);

  return __gmpn_jacobi_base (al, bl, bit);
}

# 207 "../gmp.h"
typedef enum
{
  GMP_RAND_ALG_DEFAULT = 0,
  GMP_RAND_ALG_LC = GMP_RAND_ALG_DEFAULT /* Linear congruential.  */
} gmp_randalg_t;

# 214 "../gmp.h"
typedef struct
{
  mpz_t _mp_seed; /* _mp_d member points to state of the generator. */
  gmp_randalg_t _mp_alg; /* Currently unused. */
  union {
    void *_mp_lc; /* Pointer to function pointers structure.  */
  } _mp_algdata;
} __gmp_randstate_struct;

# 222 "../gmp.h"
typedef __gmp_randstate_struct gmp_randstate_t[1];

# 1201 "../gmp-impl.h"
typedef __gmp_randstate_struct *gmp_randstate_ptr;

# 1202 "../gmp-impl.h"
typedef const __gmp_randstate_struct *gmp_randstate_srcptr;

# 1205 "../gmp-impl.h"
typedef struct {
  void (*randseed_fn) (gmp_randstate_t, mpz_srcptr);
  void (*randget_fn) (gmp_randstate_t, mp_ptr, unsigned long int);
  void (*randclear_fn) (gmp_randstate_t);
  void (*randiset_fn) (gmp_randstate_ptr, gmp_randstate_srcptr);
} gmp_randfnptr_t;

# 46 "randmui.c"
unsigned long
__gmp_urandomm_ui (gmp_randstate_ptr rstate, unsigned long n)
{
  mp_limb_t a[1];
  unsigned long ret, bits, leading;
  int i;

  if (__builtin_expect ((n == 0) != 0, 0))
    __gmp_divide_by_zero ();

  /* start with zeros, since if bits==0 then _gmp_rand will store nothing at
     all (bits==0 arises when n==1), or if bits <= GMP_NUMB_BITS then it
     will store only a[0].  */
  a[0] = 0;




  __asm__ ("clz\t%0, %1" : "=r" (leading) : "r" ((mp_limb_t) n));
  bits = 32 - leading - ((((n) & ((n) - 1)) == 0) != 0);

  for (i = 0; i < 80; i++)
    {
      do { gmp_randstate_ptr __rstate = (rstate); (*((gmp_randfnptr_t *) ((__rstate)->_mp_algdata._mp_lc))->randget_fn) (__rstate, a, bits); } while (0);

      ret = a[0];



      if (__builtin_expect ((ret < n) != 0, 1)) /* usually one iteration suffices */
        goto done;
    }

  /* Too many iterations, there must be something degenerate about the
     rstate algorithm.  Return r%n.  */
  ret -= n;
  do {} while (0);

 done:
  return ret;
}

# 37 "sizeinbase.c"
size_t
__gmpz_sizeinbase (mpz_srcptr x, int base)
{
  size_t result;
  do { int __lb_base, __cnt; size_t __totbits; do {} while (0); do {} while (0); do {} while (0); /* Special case for X == 0.  */ if ((((((x)->_mp_size)) >= 0 ? (((x)->_mp_size)) : -(((x)->_mp_size)))) == 0) (result) = 1; else { /* Calculate the total number of significant bits of X.  */ __asm__ ("clz\t%0, %1" : "=r" (__cnt) : "r" ((((x)->_mp_d))[(((((x)->_mp_size)) >= 0 ? (((x)->_mp_size)) : -(((x)->_mp_size))))-1])); __totbits = (size_t) (((((x)->_mp_size)) >= 0 ? (((x)->_mp_size)) : -(((x)->_mp_size)))) * (32 - 0) - (__cnt - 0); if ((((base) & ((base) - 1)) == 0)) { __lb_base = __gmpn_bases[base].big_base; (result) = (__totbits + __lb_base - 1) / __lb_base; } else { do { mp_limb_t _ph, _dummy; size_t _nbits = (__totbits); __asm__ ("umull %0,%1,%2,%3" : "=&r" (_dummy), "=&r" (_ph) : "r" (__gmpn_bases[base].logb2 + 1), "r" (_nbits)); result = _ph + 1; } while (0); } } } while (0);
  return result;
}

# 178 "../gmp.h"
typedef long int mp_exp_t;

# 190 "../gmp.h"
typedef struct
{
  int _mp_prec; /* Max precision, in number of `mp_limb_t's.
				   Set by mpf_init and modified by
				   mpf_set_prec.  The area pointed to by the
				   _mp_d field contains `prec' + 1 limbs.  */
  int _mp_size; /* abs(_mp_size) is the number of limbs the
				   last field points to.  If _mp_size is
				   negative this is a negative number.  */
  mp_exp_t _mp_exp; /* Exponent, in the base of `mp_limb_t'.  */
  mp_limb_t *_mp_d; /* Pointer to the limbs.  */
} __mpf_struct;

# 228 "../gmp.h"
typedef const __mpf_struct *mpf_srcptr;

# 36 "eq.c"
int
__gmpf_eq (mpf_srcptr u, mpf_srcptr v, mp_bitcnt_t n_bits)
{
  mp_srcptr up, vp, p;
  mp_size_t usize, vsize, minsize, maxsize, n_limbs, i, size;
  mp_exp_t uexp, vexp;
  mp_limb_t diff;
  int cnt;

  uexp = u->_mp_exp;
  vexp = v->_mp_exp;

  usize = u->_mp_size;
  vsize = v->_mp_size;

  /* 1. Are the signs different?  */
  if ((usize ^ vsize) >= 0)
    {
      /* U and V are both non-negative or both negative.  */
      if (usize == 0)
 return vsize == 0;
      if (vsize == 0)
 return 0;

      /* Fall out.  */
    }
  else
    {
      /* Either U or V is negative, but not both.  */
      return 0;
    }

  /* U and V have the same sign and are both non-zero.  */

  /* 2. Are the exponents different?  */
  if (uexp != vexp)
    return 0;

  usize = ((usize) >= 0 ? (usize) : -(usize));
  vsize = ((vsize) >= 0 ? (vsize) : -(vsize));

  up = u->_mp_d;
  vp = v->_mp_d;

  up += usize; /* point just above most significant limb */
  vp += vsize; /* point just above most significant limb */

  __asm__ ("clz\t%0, %1" : "=r" (cnt) : "r" (up[-1]));
  if ((vp[-1] >> (32 - 1 - cnt)) != 1)
    return 0; /* msb positions different */

  n_bits += cnt - 0;
  n_limbs = (n_bits + (32 - 0) - 1) / (32 - 0);

  usize = ((usize) < (n_limbs) ? (usize) : (n_limbs));
  vsize = ((vsize) < (n_limbs) ? (vsize) : (n_limbs));
# 101 "eq.c"
  minsize = ((usize) < (vsize) ? (usize) : (vsize));
  maxsize = usize + vsize - minsize;

  up -= minsize; /* point at most significant common limb */
  vp -= minsize; /* point at most significant common limb */

  /* Compare the most significant part which has explicit limbs for U and V. */
  for (i = minsize - 1; i > 0; i--)
    {
      if (up[i] != vp[i])
 return 0;
    }

  n_bits -= (maxsize - 1) * (32 - 0);

  size = maxsize - minsize;
  if (size != 0)
    {
      if (up[0] != vp[0])
 return 0;

      /* Now either U or V has its limbs consumed, i.e, continues with an
	 infinite number of implicit zero limbs.  Check that the other operand
	 has just zeros in the corresponding, relevant part.  */

      if (usize > vsize)
 p = up - size;
      else
 p = vp - size;

      for (i = size - 1; i > 0; i--)
 {
   if (p[i] != 0)
     return 0;
 }

      diff = p[0];
    }
  else
    {
      /* Both U or V has its limbs consumed.  */

      diff = up[0] ^ vp[0];
    }

  if (n_bits < (32 - 0))
    diff >>= (32 - 0) - n_bits;

  return diff == 0;
}

# 1607 "../gmp.h"
mp_limb_t __gmpn_submul_1 (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t);

# 1637 "../gmp.h"
mp_limb_t __gmpn_cnd_add_n (mp_limb_t, mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);

# 1639 "../gmp.h"
mp_limb_t __gmpn_cnd_sub_n (mp_limb_t, mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);

# 78 "sec_pi1_div_r.c"
void
__gmpn_sec_pi1_div_r (
       mp_ptr np, mp_size_t nn,
       mp_srcptr dp, mp_size_t dn,
       mp_limb_t dinv,
       mp_ptr tp)
{
  mp_limb_t nh, cy, q1h, q0h, dummy, cnd;
  mp_size_t i;
  mp_ptr hp;





  do {} while (0);
  do {} while (0);
  do {} while (0);

  if (nn == dn)
    {
      cy = __gmpn_sub_n (np, np, dp, dn);
      __gmpn_cnd_add_n (cy, np, np, dp, dn);



      return;

    }

  /* Create a divisor copy shifted half a limb.  */
  hp = tp; /* (dn + 1) limbs */
  hp[dn] = __gmpn_lshift (hp, dp, dn, (32 - 0) / 2);






  np += nn - dn;
  nh = 0;

  for (i = nn - dn - 1; i >= 0; i--)
    {
      np--;

      nh = (nh << (32 - 0)/2) + (np[dn] >> (32 - 0)/2);
      __asm__ ("umull %0,%1,%2,%3" : "=&r" (dummy), "=&r" (q1h) : "r" (nh), "r" (dinv));
      q1h += nh;



      __gmpn_submul_1 (np, hp, dn + 1, q1h);

      nh = np[dn];
      __asm__ ("umull %0,%1,%2,%3" : "=&r" (dummy), "=&r" (q0h) : "r" (nh), "r" (dinv));
      q0h += nh;



      nh -= __gmpn_submul_1 (np, dp, dn, q0h);
    }

  /* 1st adjustment depends on extra high remainder limb.  */
  cnd = nh != 0; /* FIXME: cmp-to-int */



  nh -= __gmpn_cnd_sub_n (cnd, np, np, dp, dn);

  /* 2nd adjustment depends on remainder/divisor comparison as well as whether
     extra remainder limb was nullified by previous subtract.  */
  cy = __gmpn_sub_n (np, np, dp, dn);
  cy = cy - nh;



  __gmpn_cnd_add_n (cy, np, np, dp, dn);

  /* 3rd adjustment depends on remainder/divisor comparison.  */
  cy = __gmpn_sub_n (np, np, dp, dn);



  __gmpn_cnd_add_n (cy, np, np, dp, dn);
# 171 "sec_pi1_div_r.c"
  return;

}

# 1095 "../gmp-impl.h"
void __gmpn_mul_basecase (mp_ptr, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t);

# 1125 "../gmp-impl.h"
mp_limb_t __gmpn_redc_1 (mp_ptr, mp_ptr, mp_srcptr, mp_size_t, mp_limb_t);

# 1134 "../gmp-impl.h"
void __gmpn_redc_n (mp_ptr, mp_ptr, mp_srcptr, mp_size_t, mp_srcptr);

# 1496 "../gmp-impl.h"
void __gmpn_binvert (mp_ptr, mp_srcptr, mp_size_t, mp_ptr);

# 3243 "../gmp-impl.h"
/* extern */ const unsigned char __gmp_binvert_limb_table[128];

# 113 "powm.c"
static inline mp_limb_t
getbits (const mp_limb_t *p, mp_bitcnt_t bi, int nbits)
{
  int nbits_in_r;
  mp_limb_t r;
  mp_size_t i;

  if (bi < nbits)
    {
      return p[0] & (((mp_limb_t) 1 << bi) - 1);
    }
  else
    {
      bi -= nbits; /* bit index of low bit to extract */
      i = bi / (32 - 0); /* word index of low bit to extract */
      bi %= (32 - 0); /* bit index in low word */
      r = p[i] >> bi; /* extract (low) bits */
      nbits_in_r = (32 - 0) - bi; /* number of bits now in r */
      if (nbits_in_r < nbits) /* did we get enough bits? */
 r += p[i + 1] << nbits_in_r; /* prepend bits from higher word */
      return r & (((mp_limb_t ) 1 << nbits) - 1);
    }
}

# 137 "powm.c"
static inline int
win_size (mp_bitcnt_t eb)
{
  int k;
  static mp_bitcnt_t x[] = {0,7,25,81,241,673,1793,4609,11521,28161,~(mp_bitcnt_t)0};
  for (k = 1; eb > x[k]; k++)
    ;
  return k;
}

# 148 "powm.c"
static void
redcify (mp_ptr rp, mp_srcptr up, mp_size_t un, mp_srcptr mp, mp_size_t n)
{
  mp_ptr tp, qp;
  struct tmp_reentrant_t *__tmp_marker;
  __tmp_marker = 0;

  tp = ((mp_limb_t *) (__builtin_expect ((((un + n) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((un + n) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (un + n) * sizeof (mp_limb_t))));
  qp = ((mp_limb_t *) (__builtin_expect ((((un + 1) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((un + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (un + 1) * sizeof (mp_limb_t)))); /* FIXME: Put at tp+? */

  do { do {} while (0); if ((n) != 0) { mp_ptr __dst = (tp); mp_size_t __n = (n); do *__dst++ = 0; while (--__n); } } while (0);
  do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (tp + n, up, un); } while (0); } while (0);
  __gmpn_tdiv_qr (qp, rp, 0L, tp, un + n, mp, n);
  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
}

# 168 "powm.c"
void
__gmpn_powm (mp_ptr rp, mp_srcptr bp, mp_size_t bn,
   mp_srcptr ep, mp_size_t en,
   mp_srcptr mp, mp_size_t n, mp_ptr tp)
{
  mp_limb_t ip[2], *mip;
  int cnt;
  mp_bitcnt_t ebi;
  int windowsize, this_windowsize;
  mp_limb_t expbits;
  mp_ptr pp, this_pp;
  long i;
  struct tmp_reentrant_t *__tmp_marker;

  do {} while (0);
  do {} while (0);

  __tmp_marker = 0;

  do { int __cnt; mp_bitcnt_t __totbits; do {} while (0); do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__cnt) : "r" ((ep)[(en)-1])); __totbits = (mp_bitcnt_t) (en) * (32 - 0) - (__cnt - 0); (ebi) = (__totbits + (1)-1) / (1); } while (0);
# 205 "powm.c"
  windowsize = win_size (ebi);
# 221 "powm.c"
  if ((! ((__builtin_constant_p (117) && (117) == 0) || (!(__builtin_constant_p (117) && (117) == 0x7fffffffL) && (n) >= (117)))))
    {
      mip = ip;
      do { mp_limb_t __n = (mp[0]); mp_limb_t __inv; do {} while (0); __inv = __gmp_binvert_limb_table[(__n/2) & 0x7F]; /*  8 */ if ((32 - 0) > 8) __inv = 2 * __inv - __inv * __inv * __n; if ((32 - 0) > 16) __inv = 2 * __inv - __inv * __inv * __n; if ((32 - 0) > 32) __inv = 2 * __inv - __inv * __inv * __n; if ((32 - 0) > 64) { int __invbits = 64; do { __inv = 2 * __inv - __inv * __inv * __n; __invbits *= 2; } while (__invbits < (32 - 0)); } do {} while (0); (mip[0]) = __inv & ((~ ((mp_limb_t) (0))) >> 0); } while (0);
      mip[0] = -mip[0];
    }

  else
    {
      mip = ((mp_limb_t *) (__builtin_expect ((((n) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((n) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (n) * sizeof (mp_limb_t))));
      __gmpn_binvert (mip, mp, n, tp);
    }

  pp = ((mp_limb_t *) (__builtin_expect ((((n << (windowsize - 1)) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((n << (windowsize - 1)) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (n << (windowsize - 1)) * sizeof (mp_limb_t))));

  this_pp = pp;
  redcify (this_pp, bp, bn, mp, n);

  /* Store b^2 at rp.  */
  __gmpn_sqr (tp, this_pp, n);






  if ((! ((__builtin_constant_p (117) && (117) == 0) || (!(__builtin_constant_p (117) && (117) == 0x7fffffffL) && (n) >= (117)))))
    do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0);

  else
    __gmpn_redc_n (rp, tp, mp, n, mip);

  /* Precompute odd powers of b and put them in the temporary area at pp.  */
  for (i = (1 << (windowsize - 1)) - 1; i > 0; i--)
    {
      __gmpn_mul_n (tp, this_pp, rp, n);
      this_pp += n;






      if ((! ((__builtin_constant_p (117) && (117) == 0) || (!(__builtin_constant_p (117) && (117) == 0x7fffffffL) && (n) >= (117)))))
 do { mp_limb_t cy; cy = __gmpn_redc_1 (this_pp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (this_pp, this_pp, mp, n); } while (0);

      else
 __gmpn_redc_n (this_pp, tp, mp, n, mip);
    }

  expbits = getbits (ep, ebi, windowsize);
  if (ebi < windowsize)
    ebi = 0;
  else
    ebi -= windowsize;

  do { UWtype __ctz_x = (expbits); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (cnt) = 32 - 1 - __ctz_c; } while (0);
  ebi += cnt;
  expbits >>= cnt;

  do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (rp, pp + n * (expbits >> 1), n); } while (0); } while (0);
# 459 "powm.c"
  if (117 < 36)
    {
      if ((! ((__builtin_constant_p (117) && (117) == 0) || (!(__builtin_constant_p (117) && (117) == 0x7fffffffL) && (n) >= (117)))))
 {
   if (117 < 12
       || (! ((__builtin_constant_p (12) && (12) == 0) || (!(__builtin_constant_p (12) && (12) == 0x7fffffffL) && (n) >= (12)))))
     {






       while (ebi != 0) { while (((ep[(ebi - 1) / 32] >> (ebi - 1) % 32) & 1) == 0) { __gmpn_mul_basecase (tp,rp,n,rp,n); do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0); ebi--; if (ebi == 0) goto done; } /* The next bit of the exponent is 1.  Now extract the largest		 block of bits <= windowsize, and such that the least			 significant bit is 1.  */ expbits = getbits (ep, ebi, windowsize); this_windowsize = windowsize; if (ebi < windowsize) { this_windowsize -= windowsize - ebi; ebi = 0; } else ebi -= windowsize; do { UWtype __ctz_x = (expbits); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (cnt) = 32 - 1 - __ctz_c; } while (0); this_windowsize -= cnt; ebi += cnt; expbits >>= cnt; do { __gmpn_mul_basecase (tp,rp,n,rp,n); do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0); this_windowsize--; } while (this_windowsize != 0); __gmpn_mul_basecase (tp,rp,n,pp + n * (expbits >> 1),n); do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0); };
     }
   else
     {






       while (ebi != 0) { while (((ep[(ebi - 1) / 32] >> (ebi - 1) % 32) & 1) == 0) { __gmpn_sqr_basecase (tp,rp,n); do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0); ebi--; if (ebi == 0) goto done; } /* The next bit of the exponent is 1.  Now extract the largest		 block of bits <= windowsize, and such that the least			 significant bit is 1.  */ expbits = getbits (ep, ebi, windowsize); this_windowsize = windowsize; if (ebi < windowsize) { this_windowsize -= windowsize - ebi; ebi = 0; } else ebi -= windowsize; do { UWtype __ctz_x = (expbits); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (cnt) = 32 - 1 - __ctz_c; } while (0); this_windowsize -= cnt; ebi += cnt; expbits >>= cnt; do { __gmpn_sqr_basecase (tp,rp,n); do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0); this_windowsize--; } while (this_windowsize != 0); __gmpn_mul_basecase (tp,rp,n,pp + n * (expbits >> 1),n); do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0); };
     }
 }
      else if ((! ((__builtin_constant_p (36) && (36) == 0) || (!(__builtin_constant_p (36) && (36) == 0x7fffffffL) && (n) >= (36)))))
 {
   if (36 < 12
       || (! ((__builtin_constant_p (12) && (12) == 0) || (!(__builtin_constant_p (12) && (12) == 0x7fffffffL) && (n) >= (12)))))
     {






       while (ebi != 0) { while (((ep[(ebi - 1) / 32] >> (ebi - 1) % 32) & 1) == 0) { __gmpn_mul_basecase (tp,rp,n,rp,n); __gmpn_redc_n (rp, tp, mp, n, mip); ebi--; if (ebi == 0) goto done; } /* The next bit of the exponent is 1.  Now extract the largest		 block of bits <= windowsize, and such that the least			 significant bit is 1.  */ expbits = getbits (ep, ebi, windowsize); this_windowsize = windowsize; if (ebi < windowsize) { this_windowsize -= windowsize - ebi; ebi = 0; } else ebi -= windowsize; do { UWtype __ctz_x = (expbits); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (cnt) = 32 - 1 - __ctz_c; } while (0); this_windowsize -= cnt; ebi += cnt; expbits >>= cnt; do { __gmpn_mul_basecase (tp,rp,n,rp,n); __gmpn_redc_n (rp, tp, mp, n, mip); this_windowsize--; } while (this_windowsize != 0); __gmpn_mul_basecase (tp,rp,n,pp + n * (expbits >> 1),n); __gmpn_redc_n (rp, tp, mp, n, mip); };
     }
   else
     {






       while (ebi != 0) { while (((ep[(ebi - 1) / 32] >> (ebi - 1) % 32) & 1) == 0) { __gmpn_sqr_basecase (tp,rp,n); __gmpn_redc_n (rp, tp, mp, n, mip); ebi--; if (ebi == 0) goto done; } /* The next bit of the exponent is 1.  Now extract the largest		 block of bits <= windowsize, and such that the least			 significant bit is 1.  */ expbits = getbits (ep, ebi, windowsize); this_windowsize = windowsize; if (ebi < windowsize) { this_windowsize -= windowsize - ebi; ebi = 0; } else ebi -= windowsize; do { UWtype __ctz_x = (expbits); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (cnt) = 32 - 1 - __ctz_c; } while (0); this_windowsize -= cnt; ebi += cnt; expbits >>= cnt; do { __gmpn_sqr_basecase (tp,rp,n); __gmpn_redc_n (rp, tp, mp, n, mip); this_windowsize--; } while (this_windowsize != 0); __gmpn_mul_basecase (tp,rp,n,pp + n * (expbits >> 1),n); __gmpn_redc_n (rp, tp, mp, n, mip); };
     }
 }
      else
 {






   while (ebi != 0) { while (((ep[(ebi - 1) / 32] >> (ebi - 1) % 32) & 1) == 0) { __gmpn_sqr (tp,rp,n); __gmpn_redc_n (rp, tp, mp, n, mip); ebi--; if (ebi == 0) goto done; } /* The next bit of the exponent is 1.  Now extract the largest		 block of bits <= windowsize, and such that the least			 significant bit is 1.  */ expbits = getbits (ep, ebi, windowsize); this_windowsize = windowsize; if (ebi < windowsize) { this_windowsize -= windowsize - ebi; ebi = 0; } else ebi -= windowsize; do { UWtype __ctz_x = (expbits); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (cnt) = 32 - 1 - __ctz_c; } while (0); this_windowsize -= cnt; ebi += cnt; expbits >>= cnt; do { __gmpn_sqr (tp,rp,n); __gmpn_redc_n (rp, tp, mp, n, mip); this_windowsize--; } while (this_windowsize != 0); __gmpn_mul_n (tp,rp,pp + n * (expbits >> 1),n); __gmpn_redc_n (rp, tp, mp, n, mip); };
 }
    }
  else
    {
      if ((! ((__builtin_constant_p (36) && (36) == 0) || (!(__builtin_constant_p (36) && (36) == 0x7fffffffL) && (n) >= (36)))))
 {
   if (36 < 12
       || (! ((__builtin_constant_p (12) && (12) == 0) || (!(__builtin_constant_p (12) && (12) == 0x7fffffffL) && (n) >= (12)))))
     {






       while (ebi != 0) { while (((ep[(ebi - 1) / 32] >> (ebi - 1) % 32) & 1) == 0) { __gmpn_mul_basecase (tp,rp,n,rp,n); do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0); ebi--; if (ebi == 0) goto done; } /* The next bit of the exponent is 1.  Now extract the largest		 block of bits <= windowsize, and such that the least			 significant bit is 1.  */ expbits = getbits (ep, ebi, windowsize); this_windowsize = windowsize; if (ebi < windowsize) { this_windowsize -= windowsize - ebi; ebi = 0; } else ebi -= windowsize; do { UWtype __ctz_x = (expbits); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (cnt) = 32 - 1 - __ctz_c; } while (0); this_windowsize -= cnt; ebi += cnt; expbits >>= cnt; do { __gmpn_mul_basecase (tp,rp,n,rp,n); do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0); this_windowsize--; } while (this_windowsize != 0); __gmpn_mul_basecase (tp,rp,n,pp + n * (expbits >> 1),n); do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0); };
     }
   else
     {






       while (ebi != 0) { while (((ep[(ebi - 1) / 32] >> (ebi - 1) % 32) & 1) == 0) { __gmpn_sqr_basecase (tp,rp,n); do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0); ebi--; if (ebi == 0) goto done; } /* The next bit of the exponent is 1.  Now extract the largest		 block of bits <= windowsize, and such that the least			 significant bit is 1.  */ expbits = getbits (ep, ebi, windowsize); this_windowsize = windowsize; if (ebi < windowsize) { this_windowsize -= windowsize - ebi; ebi = 0; } else ebi -= windowsize; do { UWtype __ctz_x = (expbits); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (cnt) = 32 - 1 - __ctz_c; } while (0); this_windowsize -= cnt; ebi += cnt; expbits >>= cnt; do { __gmpn_sqr_basecase (tp,rp,n); do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0); this_windowsize--; } while (this_windowsize != 0); __gmpn_mul_basecase (tp,rp,n,pp + n * (expbits >> 1),n); do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0); };
     }
 }
      else if ((! ((__builtin_constant_p (117) && (117) == 0) || (!(__builtin_constant_p (117) && (117) == 0x7fffffffL) && (n) >= (117)))))
 {






   while (ebi != 0) { while (((ep[(ebi - 1) / 32] >> (ebi - 1) % 32) & 1) == 0) { __gmpn_sqr (tp,rp,n); do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0); ebi--; if (ebi == 0) goto done; } /* The next bit of the exponent is 1.  Now extract the largest		 block of bits <= windowsize, and such that the least			 significant bit is 1.  */ expbits = getbits (ep, ebi, windowsize); this_windowsize = windowsize; if (ebi < windowsize) { this_windowsize -= windowsize - ebi; ebi = 0; } else ebi -= windowsize; do { UWtype __ctz_x = (expbits); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (cnt) = 32 - 1 - __ctz_c; } while (0); this_windowsize -= cnt; ebi += cnt; expbits >>= cnt; do { __gmpn_sqr (tp,rp,n); do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0); this_windowsize--; } while (this_windowsize != 0); __gmpn_mul_n (tp,rp,pp + n * (expbits >> 1),n); do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0); };
 }
      else
 {






   while (ebi != 0) { while (((ep[(ebi - 1) / 32] >> (ebi - 1) % 32) & 1) == 0) { __gmpn_sqr (tp,rp,n); __gmpn_redc_n (rp, tp, mp, n, mip); ebi--; if (ebi == 0) goto done; } /* The next bit of the exponent is 1.  Now extract the largest		 block of bits <= windowsize, and such that the least			 significant bit is 1.  */ expbits = getbits (ep, ebi, windowsize); this_windowsize = windowsize; if (ebi < windowsize) { this_windowsize -= windowsize - ebi; ebi = 0; } else ebi -= windowsize; do { UWtype __ctz_x = (expbits); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (cnt) = 32 - 1 - __ctz_c; } while (0); this_windowsize -= cnt; ebi += cnt; expbits >>= cnt; do { __gmpn_sqr (tp,rp,n); __gmpn_redc_n (rp, tp, mp, n, mip); this_windowsize--; } while (this_windowsize != 0); __gmpn_mul_n (tp,rp,pp + n * (expbits >> 1),n); __gmpn_redc_n (rp, tp, mp, n, mip); };
 }
    }


 done:

  do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (tp, rp, n); } while (0); } while (0);
  do { do {} while (0); if ((n) != 0) { mp_ptr __dst = (tp + n); mp_size_t __n = (n); do *__dst++ = 0; while (--__n); } } while (0);







  if ((! ((__builtin_constant_p (117) && (117) == 0) || (!(__builtin_constant_p (117) && (117) == 0x7fffffffL) && (n) >= (117)))))
    do { mp_limb_t cy; cy = __gmpn_redc_1 (rp, tp, mp, n, mip[0]); if (cy != 0) __gmpn_sub_n (rp, rp, mp, n); } while (0);

  else
    __gmpn_redc_n (rp, tp, mp, n, mip);

  if (__gmpn_cmp (rp, mp, n) >= 0)
    __gmpn_sub_n (rp, rp, mp, n);

  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
}

# 36 "kronsz.c"
int
__gmpz_si_kronecker (long a, mpz_srcptr b)
{
  mp_srcptr b_ptr;
  mp_limb_t b_low;
  mp_size_t b_size;
  mp_size_t b_abs_size;
  mp_limb_t a_limb, b_rem;
  unsigned twos;
  int result_bit1;
# 59 "kronsz.c"
  b_size = ((b)->_mp_size);
  if (b_size == 0)
    return (((a) == 1) | ((a) == -1)); /* (a/0) */

  /* account for the effect of the sign of b, then ignore it */
  result_bit1 = ((((a)<0) & ((b_size)<0)) << 1);

  b_ptr = ((b)->_mp_d);
  b_low = b_ptr[0];
  b_abs_size = ((b_size) >= 0 ? (b_size) : -(b_size));

  if ((b_low & 1) != 0)
    {
      /* b odd */

      result_bit1 ^= ((((a) < 0) << 1) & ((int) (b_low)));
      a_limb = (unsigned long) ((a) >= 0 ? (a) : -(a));

      if ((a_limb & 1) == 0)
 {
   /* (0/b)=1 for b=+/-1, 0 otherwise */
   if (a_limb == 0)
     return (b_abs_size == 1 && b_low == 1);

   /* a even, b odd */
   do { UWtype __ctz_x = (a_limb); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (twos) = 32 - 1 - __ctz_c; } while (0);
   a_limb >>= twos;
   /* (a*2^n/b) = (a/b) * twos(n,a) */
   result_bit1 ^= ((int) ((twos) << 1) & ((int) (((b_low) >> 1) ^ (b_low))));
 }
    }
  else
    {
      /* (even/even)=0, and (0/b)=0 for b!=+/-1 */
      if ((a & 1) == 0)
 return 0;

      /* a odd, b even

	 Establish shifted b_low with valid bit1 for ASGN and RECIP below.
	 Zero limbs stripped are accounted for, but zero bits on b_low are
	 not because they remain in {b_ptr,b_abs_size} for the
	 JACOBI_MOD_OR_MODEXACT_1_ODD. */

      do { do {} while (0); do {} while (0); while (__builtin_expect (((b_low) == 0) != 0, 0)) { (b_abs_size)--; do {} while (0); (b_ptr)++; (b_low) = *(b_ptr); do {} while (0); if (((32 - 0) % 2) == 1) (result_bit1) ^= ((int) (((a) >> 1) ^ (a))); } } while (0);
      if ((b_low & 1) == 0)
 {
   if (__builtin_expect ((b_low == (((mp_limb_t) 1L) << ((32 - 0)-1))) != 0, 0))
     {
       /* need b_ptr[1] to get bit1 in b_low */
       if (b_abs_size == 1)
  {
    /* (a/0x80000000) = (a/2)^(BPML-1) */
    if (((32 - 0) % 2) == 0)
      result_bit1 ^= ((int) (((a) >> 1) ^ (a)));
    return (1 - ((int) (result_bit1) & 2));
  }

       /* b_abs_size > 1 */
       b_low = b_ptr[1] << 1;
     }
   else
     {
       do { UWtype __ctz_x = (b_low); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (twos) = 32 - 1 - __ctz_c; } while (0);
       b_low >>= twos;
     }
 }

      result_bit1 ^= ((((a) < 0) << 1) & ((int) (b_low)));
      a_limb = (unsigned long) ((a) >= 0 ? (a) : -(a));
    }

  if (a_limb == 1)
    return (1 - ((int) (result_bit1) & 2)); /* (1/b)=1 */

  /* (a/b*2^n) = (b*2^n mod a / a) * recip(a,b) */
  do { mp_srcptr __a_ptr = (b_ptr); mp_size_t __a_size = (b_abs_size); mp_limb_t __b = (a_limb); do {} while (0); do {} while (0); if (((32 - 0) % 2) != 0 || ((__builtin_constant_p (41) && (41) == 0) || (!(__builtin_constant_p (41) && (41) == 0x7fffffffL) && (__a_size) >= (41)))) { (b_rem) = __gmpn_mod_1 (__a_ptr, __a_size, __b); } else { (result_bit1) ^= ((int) (__b)); (b_rem) = __gmpn_modexact_1c_odd (__a_ptr, __a_size, __b, ((mp_limb_t) 0L)); } } while (0);
  result_bit1 ^= ((int) ((a_limb) & (b_low)));
  return __gmpn_jacobi_base (b_rem, a_limb, result_bit1);
}

# 135 "sec_powm.c"
static void
mpn_local_sqr (mp_ptr rp, mp_srcptr up, mp_size_t n, mp_ptr tp)
{
  mp_size_t i;

  do {} while (0);
  do {} while (0);

  if ((! ((__builtin_constant_p (78) && (78) == 0) || (!(__builtin_constant_p (78) && (78) == 0x7fffffffL) && (n) >= (78)))))
    {
      __gmpn_sqr_basecase (rp, up, n);
      return;
    }

  {
    mp_limb_t ul, lpl;
    ul = up[0];
    __asm__ ("umull %0,%1,%2,%3" : "=&r" (lpl), "=&r" (rp[1]) : "r" (ul), "r" (ul << 0));
    rp[0] = lpl >> 0;
  }
  if (n > 1)
    {
      mp_limb_t cy;

      cy = __gmpn_mul_1 (tp, up + 1, n - 1, up[0]);
      tp[n - 1] = cy;
      for (i = 2; i < n; i++)
 {
   mp_limb_t cy;
   cy = __gmpn_addmul_1 (tp + 2 * i - 2, up + i, n - i, up[i - 1]);
   tp[n + i - 2] = cy;
 }
      do { mp_size_t _i; for (_i = 0; _i < (n - 1); _i++) { mp_limb_t ul, lpl; ul = (up + 1)[_i]; __asm__ ("umull %0,%1,%2,%3" : "=&r" (lpl), "=&r" ((rp + 2)[2 * _i + 1]) : "r" (ul), "r" (ul << 0)); (rp + 2)[2 * _i] = lpl >> 0; } } while (0);

      {
 mp_limb_t cy;

 cy = __gmpn_addlsh1_n (rp + 1, rp + 1, tp, 2 * n - 2);




 rp[2 * n - 1] += cy;
      }
    }
}

# 68 "sec_div_r.c"
void
__gmpn_sec_div_r (
       mp_ptr np, mp_size_t nn,
       mp_srcptr dp, mp_size_t dn,
       mp_ptr tp)
{
  mp_limb_t d1, d0;
  unsigned int cnt;
  gmp_pi1_t dinv;
  mp_limb_t inv32;

  do {} while (0);
  do {} while (0);
  do {} while (0);

  d1 = dp[dn - 1];
  __asm__ ("clz\t%0, %1" : "=r" (cnt) : "r" (d1));

  if (cnt != 0)
    {
      mp_limb_t qh, cy;
      mp_ptr np2, dp2;
      dp2 = tp; /* dn limbs */
      __gmpn_lshift (dp2, dp, dn, cnt);

      np2 = tp + dn; /* (nn + 1) limbs */
      cy = __gmpn_lshift (np2, np, nn, cnt);
      np2[nn++] = cy;

      d0 = dp2[dn - 1];
      d0 += (~d0 != 0);
      do { (inv32) = __gmpn_invert_limb (d0); } while (0);

      /* We add nn + dn to tp here, not nn + 1 + dn, as expected.  This is
	 since nn here will have been incremented.  */






      __gmpn_sec_pi1_div_r (np2, nn, dp2, dn, inv32, tp + nn + dn);


      __gmpn_rshift (np, np2, dn, cnt);




    }
  else
    {
      /* FIXME: Consider copying np => np2 here, adding a 0-limb at the top.
	 That would simplify the underlying pi1 function, since then it could
	 assume nn > dn.  */
      d0 = dp[dn - 1];
      d0 += (~d0 != 0);
      do { (inv32) = __gmpn_invert_limb (d0); } while (0);




      __gmpn_sec_pi1_div_r (np, nn, dp, dn, inv32, tp);

    }
}

# 1543 "../gmp-impl.h"
void __gmpn_bdiv_q (mp_ptr, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t, mp_ptr);

# 1545 "../gmp-impl.h"
mp_size_t __gmpn_bdiv_q_itch (mp_size_t, mp_size_t);

# 3190 "../gmp-impl.h"
void __gmpn_divexact_1 (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t);

# 45 "divexact.c"
void
__gmpn_divexact (mp_ptr qp,
       mp_srcptr np, mp_size_t nn,
       mp_srcptr dp, mp_size_t dn)
{
  unsigned shift;
  mp_size_t qn;
  mp_ptr tp;
  struct tmp_reentrant_t *__tmp_marker;

  do {} while (0);
  do {} while (0);
  do {} while (0);

  while (dp[0] == 0)
    {
      do {} while (0);
      dp++;
      np++;
      dn--;
      nn--;
    }

  if (dn == 1)
    {
      do { if ((! ((__builtin_constant_p (0 /* always */) && (0 /* always */) == 0) || (!(__builtin_constant_p (0 /* always */) && (0 /* always */) == 0x7fffffffL) && (nn) >= (0 /* always */))))) (__gmpn_divrem_1 (qp, (mp_size_t) 0, np, nn, dp[0])); else { do {} while (0); __gmpn_divexact_1 (qp, np, nn, dp[0]); } } while (0);
      return;
    }

  __tmp_marker = 0;

  qn = nn + 1 - dn;
  do { UWtype __ctz_x = (dp[0]); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (shift) = 32 - 1 - __ctz_c; } while (0);

  if (shift > 0)
    {
      mp_ptr wp;
      mp_size_t ss;
      ss = (dn > qn) ? qn + 1 : dn;

      tp = ((mp_limb_t *) (__builtin_expect ((((ss) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((ss) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (ss) * sizeof (mp_limb_t))));
      __gmpn_rshift (tp, dp, ss, shift);
      dp = tp;

      /* Since we have excluded dn == 1, we have nn > qn, and we need
	 to shift one limb beyond qn. */
      wp = ((mp_limb_t *) (__builtin_expect ((((qn + 1) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((qn + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (qn + 1) * sizeof (mp_limb_t))));
      __gmpn_rshift (wp, np, qn + 1, shift);
      np = wp;
    }

  if (dn > qn)
    dn = qn;

  tp = ((mp_limb_t *) (__builtin_expect ((((__gmpn_bdiv_q_itch (qn, dn)) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((__gmpn_bdiv_q_itch (qn, dn)) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (__gmpn_bdiv_q_itch (qn, dn)) * sizeof (mp_limb_t))));
  __gmpn_bdiv_q (qp, np, qn, dp, dn, tp);
  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
}

# 55 "/usr/arm-linux-gnueabi/include/bits/types.h"
typedef long long int __quad_t;

# 131 "/usr/arm-linux-gnueabi/include/bits/types.h"
typedef long int __off_t;

# 132 "/usr/arm-linux-gnueabi/include/bits/types.h"
typedef __quad_t __off64_t;

# 48 "/usr/arm-linux-gnueabi/include/stdio.h"
typedef struct _IO_FILE FILE;

# 150 "/usr/arm-linux-gnueabi/include/libio.h"
typedef void _IO_lock_t;

# 156 "/usr/arm-linux-gnueabi/include/libio.h"
struct _IO_marker {
  struct _IO_marker *_next;
  struct _IO_FILE *_sbuf;
  /* If _pos >= 0
 it points to _buf->Gbase()+_pos. FIXME comment */
  /* if _pos < 0, it points to _buf->eBptr()+_pos. FIXME comment */
  int _pos;
# 173 "/usr/arm-linux-gnueabi/include/libio.h" 3
};

# 241 "/usr/arm-linux-gnueabi/include/libio.h"
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
# 289 "/usr/arm-linux-gnueabi/include/libio.h" 3
  __off64_t _offset;







  void *__pad1;
  void *__pad2;
  void *__pad3;
  void *__pad4;

  size_t __pad5;
  int _mode;
  /* Make sure we don't get into trouble again.  */
  char _unused2[15 * sizeof (int) - 4 * sizeof (void *) - sizeof (size_t)];

};

# 169 "/usr/arm-linux-gnueabi/include/stdio.h"
/* extern */ struct _IO_FILE *stdout;

# 715 "/usr/arm-linux-gnueabi/include/stdio.h"
/* extern */ size_t fwrite (const void *__restrict __ptr, size_t __size,
        size_t __n, FILE *__restrict __s);

# 709 "../gmp-impl.h"
/* extern */ void (*__gmp_free_func) (void *, size_t);

# 2361 "../gmp-impl.h"
void __gmp_assert_fail (const char *, int, const char *);

# 60 "out_raw.c"
size_t
__gmpz_out_raw (FILE *fp, mpz_srcptr x)
{
  mp_size_t xsize, abs_xsize, bytes, i;
  mp_srcptr xp;
  char *tp, *bp;
  mp_limb_t xlimb;
  int zeros;
  size_t tsize, ssize;

  xsize = ((x)->_mp_size);
  abs_xsize = ((xsize) >= 0 ? (xsize) : -(xsize));
  bytes = (abs_xsize * (32 - 0) + 7) / 8;
  tsize = ((((4) & ((4) - 1)) == 0) ? ((unsigned) 4) + (-((unsigned) 4))%(4) : ((unsigned) 4)+(4)-1 - ((((unsigned) 4)+(4)-1) % (4))) + bytes;

  tp = ((char *) (*__gmp_allocate_func) ((tsize) * sizeof (char)));
  bp = tp + ((((4) & ((4) - 1)) == 0) ? ((unsigned) 4) + (-((unsigned) 4))%(4) : ((unsigned) 4)+(4)-1 - ((((unsigned) 4)+(4)-1) % (4)));

  if (bytes != 0)
    {
      bp += bytes;
      xp = ((x)->_mp_d);
      i = abs_xsize;

      if (0 == 0)
 {
   /* reverse limb order, and byte swap if necessary */



   do
     {
       bp -= 4;
       xlimb = *xp;
       do { (*((mp_ptr) bp)) = ((xlimb) << 24) + (((xlimb) & 0xFF00) << 8) + (((xlimb) >> 8) & 0xFF00) + ((xlimb) >> 24); } while (0);
       xp++;
     }
   while (--i > 0);

   /* strip high zero bytes (without fetching from bp) */
   __asm__ ("clz\t%0, %1" : "=r" (zeros) : "r" (xlimb));
   zeros /= 8;
   bp += zeros;
   bytes -= zeros;
 }
      else
 {
   mp_limb_t new_xlimb;
   int bits;
   ;

   do { if (__builtin_expect ((!((32 - 0) >= 8)) != 0, 0)) __gmp_assert_fail ("out_raw.c", 111, "(32 - 0) >= 8"); } while (0);

   bits = 0;
   xlimb = 0;
   for (;;)
     {
       while (bits >= 8)
  {
    do {} while (0);
    *--bp = xlimb & 0xFF;
    xlimb >>= 8;
    bits -= 8;
  }

       if (i == 0)
  break;

       new_xlimb = *xp++;
       i--;
       do {} while (0);
       *--bp = (xlimb | (new_xlimb << bits)) & 0xFF;
       xlimb = new_xlimb >> (8 - bits);
       bits += (32 - 0) - 8;
     }

   if (bits != 0)
     {
       do {} while (0);
       *--bp = xlimb;
     }

   do {} while (0);
   while (*bp == 0)
     {
       bp++;
       bytes--;
     }
 }
    }

  /* total bytes to be written */
  ssize = 4 + bytes;

  /* twos complement negative for the size value */
  bytes = (xsize >= 0 ? bytes : -bytes);

  /* so we don't rely on sign extension in ">>" */
  do { if (__builtin_expect ((!(sizeof (bytes) >= 4)) != 0, 0)) __gmp_assert_fail ("out_raw.c", 158, "sizeof (bytes) >= 4"); } while (0);

  bp[-4] = bytes >> 24;
  bp[-3] = bytes >> 16;
  bp[-2] = bytes >> 8;
  bp[-1] = bytes;
  bp -= 4;

  if (fp == 0)
    fp = 
# 167 "out_raw.c" 3
        stdout
# 167 "out_raw.c"
              ;
  if (fwrite (bp, ssize, 1, fp) != 1)
    ssize = 0;

  (*__gmp_free_func) (tp, tsize);
  return ssize;
}

# 1448 "../gmp-impl.h"
mp_limb_t __gmpn_dcpi1_div_q (mp_ptr, mp_ptr, mp_size_t, mp_srcptr, mp_size_t, gmp_pi1_t *);

# 1468 "../gmp-impl.h"
mp_limb_t __gmpn_mu_divappr_q (mp_ptr, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t, mp_ptr);

# 1470 "../gmp-impl.h"
mp_size_t __gmpn_mu_divappr_q_itch (mp_size_t, mp_size_t, int);

# 1478 "../gmp-impl.h"
mp_limb_t __gmpn_mu_div_q (mp_ptr, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t, mp_ptr);

# 1480 "../gmp-impl.h"
mp_size_t __gmpn_mu_div_q_itch (mp_size_t, mp_size_t, int);

# 100 "div_q.c"
void
__gmpn_div_q (mp_ptr qp,
    mp_srcptr np, mp_size_t nn,
    mp_srcptr dp, mp_size_t dn, mp_ptr scratch)
{
  mp_ptr new_dp, new_np, tp, rp;
  mp_limb_t cy, dh, qh;
  mp_size_t new_nn, qn;
  gmp_pi1_t dinv;
  int cnt;
  struct tmp_reentrant_t *__tmp_marker;
  __tmp_marker = 0;

  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);

  do { if (__builtin_expect ((!(5 /* FIXME: tune this */ >= 2)) != 0, 0)) __gmp_assert_fail ("div_q.c", 120, "5 /* FIXME: tune this */ >= 2"); } while (0);

  if (dn == 1)
    {
      __gmpn_divrem_1 (qp, 0L, np, nn, dp[dn - 1]);
      return;
    }

  qn = nn - dn + 1; /* Quotient size, high limb might be zero */

  if (qn + 5 /* FIXME: tune this */ >= dn)
    {
      /* |________________________|
                          |_______|  */
      new_np = scratch;

      dh = dp[dn - 1];
      if (__builtin_expect (((dh & (((mp_limb_t) 1L) << ((32 - 0)-1))) == 0) != 0, 1))
 {
   __asm__ ("clz\t%0, %1" : "=r" (cnt) : "r" (dh));

   cy = __gmpn_lshift (new_np, np, nn, cnt);
   new_np[nn] = cy;
   new_nn = nn + (cy != 0);

   new_dp = ((mp_limb_t *) (__builtin_expect ((((dn) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((dn) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (dn) * sizeof (mp_limb_t))));
   __gmpn_lshift (new_dp, dp, dn, cnt);

   if (dn == 2)
     {
       qh = __gmpn_divrem_2 (qp, 0L, new_np, new_nn, new_dp);
     }
   else if ((! ((__builtin_constant_p (494) && (494) == 0) || (!(__builtin_constant_p (494) && (494) == 0x7fffffffL) && (dn) >= (494)))) ||
     (! ((__builtin_constant_p (494) && (494) == 0) || (!(__builtin_constant_p (494) && (494) == 0x7fffffffL) && (new_nn - dn) >= (494)))))
     {
       do { mp_limb_t _v, _p, _t1, _t0, _mask; do { (_v) = __gmpn_invert_limb (new_dp[dn - 1]); } while (0); _p = (new_dp[dn - 1]) * _v; _p += (new_dp[dn - 2]); if (_p < (new_dp[dn - 2])) { _v--; _mask = -(mp_limb_t) (_p >= (new_dp[dn - 1])); _p -= (new_dp[dn - 1]); _v += _mask; _p -= _mask & (new_dp[dn - 1]); } __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" (new_dp[dn - 2]), "r" (_v)); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (new_dp[dn - 1])) != 0, 0)) { if (_p > (new_dp[dn - 1]) || _t0 >= (new_dp[dn - 2])) _v--; } } (dinv).inv32 = _v; } while (0);
       qh = __gmpn_sbpi1_div_q (qp, new_np, new_nn, new_dp, dn, dinv.inv32);
     }
   else if ((! ((__builtin_constant_p (225) && (225) == 0) || (!(__builtin_constant_p (225) && (225) == 0x7fffffffL) && (dn) >= (225)))) || /* fast condition */
     (! ((__builtin_constant_p (2 * 2172) && (2 * 2172) == 0) || (!(__builtin_constant_p (2 * 2172) && (2 * 2172) == 0x7fffffffL) && (nn) >= (2 * 2172)))) || /* fast condition */
     (double) (2 * (2172 - 225)) * dn /* slow... */
     + (double) 225 * nn > (double) dn * nn) /* ...condition */
     {
       do { mp_limb_t _v, _p, _t1, _t0, _mask; do { (_v) = __gmpn_invert_limb (new_dp[dn - 1]); } while (0); _p = (new_dp[dn - 1]) * _v; _p += (new_dp[dn - 2]); if (_p < (new_dp[dn - 2])) { _v--; _mask = -(mp_limb_t) (_p >= (new_dp[dn - 1])); _p -= (new_dp[dn - 1]); _v += _mask; _p -= _mask & (new_dp[dn - 1]); } __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" (new_dp[dn - 2]), "r" (_v)); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (new_dp[dn - 1])) != 0, 0)) { if (_p > (new_dp[dn - 1]) || _t0 >= (new_dp[dn - 2])) _v--; } } (dinv).inv32 = _v; } while (0);
       qh = __gmpn_dcpi1_div_q (qp, new_np, new_nn, new_dp, dn, &dinv);
     }
   else
     {
       mp_size_t itch = __gmpn_mu_div_q_itch (new_nn, dn, 0);
       mp_ptr scratch = ((mp_limb_t *) (__builtin_expect ((((itch) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((itch) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (itch) * sizeof (mp_limb_t))));
       qh = __gmpn_mu_div_q (qp, new_np, new_nn, new_dp, dn, scratch);
     }
   if (cy == 0)
     qp[qn - 1] = qh;
   else if (__builtin_expect ((qh != 0) != 0, 0))
     {
       /* This happens only when the quotient is close to B^n and
		 mpn_*_divappr_q returned B^n.  */
       mp_size_t i, n;
       n = new_nn - dn;
       for (i = 0; i < n; i++)
  qp[i] = ((~ ((mp_limb_t) (0))) >> 0);
       qh = 0; /* currently ignored */
     }
 }
      else /* divisor is already normalised */
 {
   if (new_np != np)
     do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (new_np, np, nn); } while (0); } while (0);

   if (dn == 2)
     {
       qh = __gmpn_divrem_2 (qp, 0L, new_np, nn, dp);
     }
   else if ((! ((__builtin_constant_p (494) && (494) == 0) || (!(__builtin_constant_p (494) && (494) == 0x7fffffffL) && (dn) >= (494)))) ||
     (! ((__builtin_constant_p (494) && (494) == 0) || (!(__builtin_constant_p (494) && (494) == 0x7fffffffL) && (nn - dn) >= (494)))))
     {
       do { mp_limb_t _v, _p, _t1, _t0, _mask; do { (_v) = __gmpn_invert_limb (dh); } while (0); _p = (dh) * _v; _p += (dp[dn - 2]); if (_p < (dp[dn - 2])) { _v--; _mask = -(mp_limb_t) (_p >= (dh)); _p -= (dh); _v += _mask; _p -= _mask & (dh); } __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" (dp[dn - 2]), "r" (_v)); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (dh)) != 0, 0)) { if (_p > (dh) || _t0 >= (dp[dn - 2])) _v--; } } (dinv).inv32 = _v; } while (0);
       qh = __gmpn_sbpi1_div_q (qp, new_np, nn, dp, dn, dinv.inv32);
     }
   else if ((! ((__builtin_constant_p (225) && (225) == 0) || (!(__builtin_constant_p (225) && (225) == 0x7fffffffL) && (dn) >= (225)))) || /* fast condition */
     (! ((__builtin_constant_p (2 * 2172) && (2 * 2172) == 0) || (!(__builtin_constant_p (2 * 2172) && (2 * 2172) == 0x7fffffffL) && (nn) >= (2 * 2172)))) || /* fast condition */
     (double) (2 * (2172 - 225)) * dn /* slow... */
     + (double) 225 * nn > (double) dn * nn) /* ...condition */
     {
       do { mp_limb_t _v, _p, _t1, _t0, _mask; do { (_v) = __gmpn_invert_limb (dh); } while (0); _p = (dh) * _v; _p += (dp[dn - 2]); if (_p < (dp[dn - 2])) { _v--; _mask = -(mp_limb_t) (_p >= (dh)); _p -= (dh); _v += _mask; _p -= _mask & (dh); } __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" (dp[dn - 2]), "r" (_v)); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (dh)) != 0, 0)) { if (_p > (dh) || _t0 >= (dp[dn - 2])) _v--; } } (dinv).inv32 = _v; } while (0);
       qh = __gmpn_dcpi1_div_q (qp, new_np, nn, dp, dn, &dinv);
     }
   else
     {
       mp_size_t itch = __gmpn_mu_div_q_itch (nn, dn, 0);
       mp_ptr scratch = ((mp_limb_t *) (__builtin_expect ((((itch) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((itch) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (itch) * sizeof (mp_limb_t))));
       qh = __gmpn_mu_div_q (qp, np, nn, dp, dn, scratch);
     }
   qp[nn - dn] = qh;
 }
    }
  else
    {
      /* |________________________|
                |_________________|  */
      tp = ((mp_limb_t *) (__builtin_expect ((((qn + 1) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((qn + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (qn + 1) * sizeof (mp_limb_t))));

      new_np = scratch;
      new_nn = 2 * qn + 1;
      if (new_np == np)
 /* We need {np,nn} to remain untouched until the final adjustment, so
	   we need to allocate separate space for new_np.  */
 new_np = ((mp_limb_t *) (__builtin_expect ((((new_nn + 1) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((new_nn + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (new_nn + 1) * sizeof (mp_limb_t))));


      dh = dp[dn - 1];
      if (__builtin_expect (((dh & (((mp_limb_t) 1L) << ((32 - 0)-1))) == 0) != 0, 1))
 {
   __asm__ ("clz\t%0, %1" : "=r" (cnt) : "r" (dh));

   cy = __gmpn_lshift (new_np, np + nn - new_nn, new_nn, cnt);
   new_np[new_nn] = cy;

   new_nn += (cy != 0);

   new_dp = ((mp_limb_t *) (__builtin_expect ((((qn + 1) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((qn + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (qn + 1) * sizeof (mp_limb_t))));
   __gmpn_lshift (new_dp, dp + dn - (qn + 1), qn + 1, cnt);
   new_dp[0] |= dp[dn - (qn + 1) - 1] >> ((32 - 0) - cnt);

   if (qn + 1 == 2)
     {
       qh = __gmpn_divrem_2 (tp, 0L, new_np, new_nn, new_dp);
     }
   else if ((! ((__builtin_constant_p (494 - 1) && (494 - 1) == 0) || (!(__builtin_constant_p (494 - 1) && (494 - 1) == 0x7fffffffL) && (qn) >= (494 - 1)))))
     {
       do { mp_limb_t _v, _p, _t1, _t0, _mask; do { (_v) = __gmpn_invert_limb (new_dp[qn]); } while (0); _p = (new_dp[qn]) * _v; _p += (new_dp[qn - 1]); if (_p < (new_dp[qn - 1])) { _v--; _mask = -(mp_limb_t) (_p >= (new_dp[qn])); _p -= (new_dp[qn]); _v += _mask; _p -= _mask & (new_dp[qn]); } __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" (new_dp[qn - 1]), "r" (_v)); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (new_dp[qn])) != 0, 0)) { if (_p > (new_dp[qn]) || _t0 >= (new_dp[qn - 1])) _v--; } } (dinv).inv32 = _v; } while (0);
       qh = __gmpn_sbpi1_divappr_q (tp, new_np, new_nn, new_dp, qn + 1, dinv.inv32);
     }
   else if ((! ((__builtin_constant_p (2172 - 1) && (2172 - 1) == 0) || (!(__builtin_constant_p (2172 - 1) && (2172 - 1) == 0x7fffffffL) && (qn) >= (2172 - 1)))))
     {
       do { mp_limb_t _v, _p, _t1, _t0, _mask; do { (_v) = __gmpn_invert_limb (new_dp[qn]); } while (0); _p = (new_dp[qn]) * _v; _p += (new_dp[qn - 1]); if (_p < (new_dp[qn - 1])) { _v--; _mask = -(mp_limb_t) (_p >= (new_dp[qn])); _p -= (new_dp[qn]); _v += _mask; _p -= _mask & (new_dp[qn]); } __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" (new_dp[qn - 1]), "r" (_v)); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (new_dp[qn])) != 0, 0)) { if (_p > (new_dp[qn]) || _t0 >= (new_dp[qn - 1])) _v--; } } (dinv).inv32 = _v; } while (0);
       qh = __gmpn_dcpi1_divappr_q (tp, new_np, new_nn, new_dp, qn + 1, &dinv);
     }
   else
     {
       mp_size_t itch = __gmpn_mu_divappr_q_itch (new_nn, qn + 1, 0);
       mp_ptr scratch = ((mp_limb_t *) (__builtin_expect ((((itch) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((itch) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (itch) * sizeof (mp_limb_t))));
       qh = __gmpn_mu_divappr_q (tp, new_np, new_nn, new_dp, qn + 1, scratch);
     }
   if (cy == 0)
     tp[qn] = qh;
   else if (__builtin_expect ((qh != 0) != 0, 0))
     {
       /* This happens only when the quotient is close to B^n and
		 mpn_*_divappr_q returned B^n.  */
       mp_size_t i, n;
       n = new_nn - (qn + 1);
       for (i = 0; i < n; i++)
  tp[i] = ((~ ((mp_limb_t) (0))) >> 0);
       qh = 0; /* currently ignored */
     }
 }
      else /* divisor is already normalised */
 {
   do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (new_np, np + nn - new_nn, new_nn); } while (0); } while (0); /* pointless of MU will be used */

   new_dp = (mp_ptr) dp + dn - (qn + 1);

   if (qn == 2 - 1)
     {
       qh = __gmpn_divrem_2 (tp, 0L, new_np, new_nn, new_dp);
     }
   else if ((! ((__builtin_constant_p (494 - 1) && (494 - 1) == 0) || (!(__builtin_constant_p (494 - 1) && (494 - 1) == 0x7fffffffL) && (qn) >= (494 - 1)))))
     {
       do { mp_limb_t _v, _p, _t1, _t0, _mask; do { (_v) = __gmpn_invert_limb (dh); } while (0); _p = (dh) * _v; _p += (new_dp[qn - 1]); if (_p < (new_dp[qn - 1])) { _v--; _mask = -(mp_limb_t) (_p >= (dh)); _p -= (dh); _v += _mask; _p -= _mask & (dh); } __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" (new_dp[qn - 1]), "r" (_v)); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (dh)) != 0, 0)) { if (_p > (dh) || _t0 >= (new_dp[qn - 1])) _v--; } } (dinv).inv32 = _v; } while (0);
       qh = __gmpn_sbpi1_divappr_q (tp, new_np, new_nn, new_dp, qn + 1, dinv.inv32);
     }
   else if ((! ((__builtin_constant_p (2172 - 1) && (2172 - 1) == 0) || (!(__builtin_constant_p (2172 - 1) && (2172 - 1) == 0x7fffffffL) && (qn) >= (2172 - 1)))))
     {
       do { mp_limb_t _v, _p, _t1, _t0, _mask; do { (_v) = __gmpn_invert_limb (dh); } while (0); _p = (dh) * _v; _p += (new_dp[qn - 1]); if (_p < (new_dp[qn - 1])) { _v--; _mask = -(mp_limb_t) (_p >= (dh)); _p -= (dh); _v += _mask; _p -= _mask & (dh); } __asm__ ("umull %0,%1,%2,%3" : "=&r" (_t0), "=&r" (_t1) : "r" (new_dp[qn - 1]), "r" (_v)); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (dh)) != 0, 0)) { if (_p > (dh) || _t0 >= (new_dp[qn - 1])) _v--; } } (dinv).inv32 = _v; } while (0);
       qh = __gmpn_dcpi1_divappr_q (tp, new_np, new_nn, new_dp, qn + 1, &dinv);
     }
   else
     {
       mp_size_t itch = __gmpn_mu_divappr_q_itch (new_nn, qn + 1, 0);
       mp_ptr scratch = ((mp_limb_t *) (__builtin_expect ((((itch) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((itch) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (itch) * sizeof (mp_limb_t))));
       qh = __gmpn_mu_divappr_q (tp, new_np, new_nn, new_dp, qn + 1, scratch);
     }
   tp[qn] = qh;
 }

      do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (qp, tp + 1, qn); } while (0); } while (0);
      if (tp[0] <= 4)
        {
   mp_size_t rn;

          rp = ((mp_limb_t *) (__builtin_expect ((((dn + qn) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((dn + qn) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (dn + qn) * sizeof (mp_limb_t))));
          __gmpn_mul (rp, dp, dn, tp + 1, qn);
   rn = dn + qn;
   rn -= rp[rn - 1] == 0;

          if (rn > nn || __gmpn_cmp (np, rp, nn) < 0)
            do { mp_limb_t __x; mp_ptr __p = (qp); if (__builtin_constant_p (1) && (1) == 1) { while ((*(__p++))-- == 0) ; } else { __x = *__p; *__p = __x - (1); if (__x < (1)) while ((*(++__p))-- == 0) ; } } while (0);
        }
    }

  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
}

# 44 "mod_1_3.c"
void
__gmpn_mod_1s_3p_cps (mp_limb_t cps[6], mp_limb_t b)
{
  mp_limb_t bi;
  mp_limb_t B1modb, B2modb, B3modb, B4modb;
  int cnt;

  do {} while (0);

  __asm__ ("clz\t%0, %1" : "=r" (cnt) : "r" (b));

  b <<= cnt;
  do { (bi) = __gmpn_invert_limb (b); } while (0);

  cps[0] = bi;
  cps[1] = cnt;

  B1modb = -b * ((bi >> (32 -cnt)) | (((mp_limb_t) 1L) << cnt));
  do {} while (0); /* NB: not fully reduced mod b */
  cps[2] = B1modb >> cnt;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((B1modb)), "r" ((bi))); if (__builtin_constant_p (((mp_limb_t) 0L)) && (((mp_limb_t) 0L)) == 0) { _r = ~(_qh + (B1modb)) * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((B1modb) + 1), "%r" (_ql), "rI" ((((mp_limb_t) 0L))) : "cc"); _r = (((mp_limb_t) 0L)) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (B2modb) = _r; } while (0);
  cps[3] = B2modb >> cnt;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((B2modb)), "r" ((bi))); if (__builtin_constant_p (((mp_limb_t) 0L)) && (((mp_limb_t) 0L)) == 0) { _r = ~(_qh + (B2modb)) * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((B2modb) + 1), "%r" (_ql), "rI" ((((mp_limb_t) 0L))) : "cc"); _r = (((mp_limb_t) 0L)) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (B3modb) = _r; } while (0);
  cps[4] = B3modb >> cnt;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((B3modb)), "r" ((bi))); if (__builtin_constant_p (((mp_limb_t) 0L)) && (((mp_limb_t) 0L)) == 0) { _r = ~(_qh + (B3modb)) * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((B3modb) + 1), "%r" (_ql), "rI" ((((mp_limb_t) 0L))) : "cc"); _r = (((mp_limb_t) 0L)) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (B4modb) = _r; } while (0);
  cps[5] = B4modb >> cnt;
# 85 "mod_1_3.c"
}

# 87 "mod_1_3.c"
mp_limb_t
__gmpn_mod_1s_3p (mp_srcptr ap, mp_size_t n, mp_limb_t b, const mp_limb_t cps[6])
{
  mp_limb_t rh, rl, bi, ph, pl, ch, cl, r;
  mp_limb_t B1modb, B2modb, B3modb, B4modb;
  mp_size_t i;
  int cnt;

  do {} while (0);

  B1modb = cps[2];
  B2modb = cps[3];
  B3modb = cps[4];
  B4modb = cps[5];

  /* We compute n mod 3 in a tricky way, which works except for when n is so
     close to the maximum size that we don't need to support it.  The final
     cast to int is a workaround for HP cc.  */
  switch ((int) ((mp_limb_t) n * (((((~ ((mp_limb_t) (0))) >> 0) >> ((32 - 0) % 2)) / 3) * 2 + 1) >> ((32 - 0) - 2)))
    {
    case 0:
      __asm__ ("umull %0,%1,%2,%3" : "=&r" (pl), "=&r" (ph) : "r" (ap[n - 2]), "r" (B1modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (ph), "=&r" (pl) : "r" (ph), "rI" (((mp_limb_t) 0L)), "%r" (pl), "rI" (ap[n - 3]) : "cc");
      __asm__ ("umull %0,%1,%2,%3" : "=&r" (rl), "=&r" (rh) : "r" (ap[n - 1]), "r" (B2modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (rh), "=&r" (rl) : "r" (rh), "rI" (ph), "%r" (rl), "rI" (pl) : "cc");
      n -= 3;
      break;
    case 2: /* n mod 3 = 1 */
      rh = 0;
      rl = ap[n - 1];
      n -= 1;
      break;
    case 1: /* n mod 3 = 2 */
      rh = ap[n - 1];
      rl = ap[n - 2];
      n -= 2;
      break;
    }

  for (i = n - 3; i >= 0; i -= 3)
    {
      /* rr = ap[i]				< B
	    + ap[i+1] * (B mod b)		<= (B-1)(b-1)
	    + ap[i+2] * (B^2 mod b)		<= (B-1)(b-1)
	    + LO(rr)  * (B^3 mod b)		<= (B-1)(b-1)
	    + HI(rr)  * (B^4 mod b)		<= (B-1)(b-1)
      */
      __asm__ ("umull %0,%1,%2,%3" : "=&r" (pl), "=&r" (ph) : "r" (ap[i + 1]), "r" (B1modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (ph), "=&r" (pl) : "r" (ph), "rI" (((mp_limb_t) 0L)), "%r" (pl), "rI" (ap[i + 0]) : "cc");

      __asm__ ("umull %0,%1,%2,%3" : "=&r" (cl), "=&r" (ch) : "r" (ap[i + 2]), "r" (B2modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (ph), "=&r" (pl) : "r" (ph), "rI" (ch), "%r" (pl), "rI" (cl) : "cc");

      __asm__ ("umull %0,%1,%2,%3" : "=&r" (cl), "=&r" (ch) : "r" (rl), "r" (B3modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (ph), "=&r" (pl) : "r" (ph), "rI" (ch), "%r" (pl), "rI" (cl) : "cc");

      __asm__ ("umull %0,%1,%2,%3" : "=&r" (rl), "=&r" (rh) : "r" (rh), "r" (B4modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (rh), "=&r" (rl) : "r" (rh), "rI" (ph), "%r" (rl), "rI" (pl) : "cc");
    }

  __asm__ ("umull %0,%1,%2,%3" : "=&r" (cl), "=&r" (rh) : "r" (rh), "r" (B1modb));
  __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (rh), "=&r" (rl) : "r" (rh), "rI" (((mp_limb_t) 0L)), "%r" (rl), "rI" (cl) : "cc");

  cnt = cps[1];
  bi = cps[0];

  r = (rh << cnt) | (rl >> (32 - cnt));
  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((r)), "r" ((bi))); if (__builtin_constant_p (rl << cnt) && (rl << cnt) == 0) { _r = ~(_qh + (r)) * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((r) + 1), "%r" (_ql), "rI" ((rl << cnt)) : "cc"); _r = (rl << cnt) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (r) = _r; } while (0);

  return r >> cnt;
}

# 51 "div_qr_1.c"
mp_limb_t
__gmpn_div_qr_1 (mp_ptr qp, mp_limb_t *qh, mp_srcptr up, mp_size_t n,
       mp_limb_t d)
{
  unsigned cnt;
  mp_limb_t uh;

  do {} while (0);
  do {} while (0);

  if (d & (((mp_limb_t) 1L) << ((32 - 0)-1)))
    {
      /* Normalized case */
      mp_limb_t dinv, q;

      uh = up[--n];

      q = (uh >= d);
      *qh = q;
      uh -= (-q) & d;

      if ((! ((__builtin_constant_p (3) && (3) == 0) || (!(__builtin_constant_p (3) && (3) == 0x7fffffffL) && (n) >= (3)))))
 {
   cnt = 0;
 plain:
   while (n > 0)
     {
       mp_limb_t ul = up[--n];
       do { UWtype __di; __di = __gmpn_invert_limb (d); do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((uh)), "r" ((__di))); if (__builtin_constant_p (ul) && (ul) == 0) { _qh += (uh) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((uh) + 1), "%r" (_ql), "rI" ((ul)) : "cc"); _r = (ul) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (uh) = _r; (qp[n]) = _qh; } while (0); } while (0);
     }
   return uh >> cnt;
 }
      do { (dinv) = __gmpn_invert_limb (d); } while (0);
      return __gmpn_div_qr_1n_pi1 (qp, up, n, uh, d, dinv);
    }
  else
    {
      /* Unnormalized case */
      mp_limb_t dinv, ul;

      if (! 1
   && (! ((__builtin_constant_p (3) && (3) == 0) || (!(__builtin_constant_p (3) && (3) == 0x7fffffffL) && (n) >= (3)))))
 {
   uh = up[--n];
   do { UWtype __di; __di = __gmpn_invert_limb (d); do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((((mp_limb_t) 0L))), "r" ((__di))); if (__builtin_constant_p (uh) && (uh) == 0) { _qh += (((mp_limb_t) 0L)) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((((mp_limb_t) 0L)) + 1), "%r" (_ql), "rI" ((uh)) : "cc"); _r = (uh) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (uh) = _r; (*qh) = _qh; } while (0); } while (0);
   cnt = 0;
   goto plain;
 }

      __asm__ ("clz\t%0, %1" : "=r" (cnt) : "r" (d));
      d <<= cnt;





      /* Shift up front, use qp area for shifted copy. A bit messy,
	 since we have only n-1 limbs available, and shift the high
	 limb manually. */
      uh = up[--n];
      ul = (uh << cnt) | __gmpn_lshift (qp, up, n, cnt);
      uh >>= (32 - cnt);

      if (1
   && (! ((__builtin_constant_p (3) && (3) == 0) || (!(__builtin_constant_p (3) && (3) == 0x7fffffffL) && (n) >= (3)))))
 {
   do { UWtype __di; __di = __gmpn_invert_limb (d); do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((uh)), "r" ((__di))); if (__builtin_constant_p (ul) && (ul) == 0) { _qh += (uh) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((uh) + 1), "%r" (_ql), "rI" ((ul)) : "cc"); _r = (ul) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (uh) = _r; (*qh) = _qh; } while (0); } while (0);
   up = qp;
   goto plain;
 }
      do { (dinv) = __gmpn_invert_limb (d); } while (0);

      do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((uh)), "r" ((dinv))); if (__builtin_constant_p (ul) && (ul) == 0) { _qh += (uh) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((uh) + 1), "%r" (_ql), "rI" ((ul)) : "cc"); _r = (ul) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (uh) = _r; (*qh) = _qh; } while (0);
      return __gmpn_div_qr_1n_pi1 (qp, qp, n, uh, d, dinv) >> cnt;
    }
}

# 60 "gcd_1.c"
mp_limb_t
__gmpn_gcd_1 (mp_srcptr up, mp_size_t size, mp_limb_t vlimb)
{
  mp_limb_t ulimb;
  unsigned long zero_bits, u_low_zero_bits;

  do {} while (0);
  do {} while (0);
  do {} while (0);

  ulimb = up[0];

  /* Need vlimb odd for modexact, want it odd to get common zeros. */
  do { UWtype __ctz_x = (vlimb); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (zero_bits) = 32 - 1 - __ctz_c; } while (0);
  vlimb >>= zero_bits;

  if (size > 1)
    {
      /* Must get common zeros before the mod reduction.  If ulimb==0 then
	 vlimb already gives the common zeros.  */
      if (ulimb != 0)
 {
   do { UWtype __ctz_x = (ulimb); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (u_low_zero_bits) = 32 - 1 - __ctz_c; } while (0);
   zero_bits = ((zero_bits) < (u_low_zero_bits) ? (zero_bits) : (u_low_zero_bits));
 }

      ulimb = ((! ((__builtin_constant_p (41) && (41) == 0) || (!(__builtin_constant_p (41) && (41) == 0x7fffffffL) && (size) >= (41)))) ? __gmpn_modexact_1c_odd (up, size, vlimb, ((mp_limb_t) 0L)) : __gmpn_mod_1 (up, size, vlimb));
      if (ulimb == 0)
 goto done;

      goto strip_u_maybe;
    }

  /* size==1, so up[0]!=0 */
  do { UWtype __ctz_x = (ulimb); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (u_low_zero_bits) = 32 - 1 - __ctz_c; } while (0);
  ulimb >>= u_low_zero_bits;
  zero_bits = ((zero_bits) < (u_low_zero_bits) ? (zero_bits) : (u_low_zero_bits));

  /* make u bigger */
  if (vlimb > ulimb)
    do { mp_limb_t __mp_limb_t_swap__tmp = (ulimb); (ulimb) = (vlimb); (vlimb) = __mp_limb_t_swap__tmp; } while (0);

  /* if u is much bigger than v, reduce using a division rather than
     chipping away at it bit-by-bit */
  if ((ulimb >> 16) > vlimb)
    {
      ulimb %= vlimb;
      if (ulimb == 0)
 goto done;
      goto strip_u_maybe;
    }

  do {} while (0);
  do {} while (0);
# 147 "gcd_1.c"
  ulimb >>= 1;
  vlimb >>= 1;

  while (ulimb != vlimb)
    {
      int c;
      mp_limb_t t;
      mp_limb_t vgtu;

      t = ulimb - vlimb;
      vgtu = (((mp_limb_signed_t) -1 >> 1) < 0 ? (mp_limb_signed_t) (t) >> (32 - 1) : (t) & ((~ (mp_limb_t) 0) ^ ((~ (mp_limb_t) 0) >> 1)) ? (~ (mp_limb_t) 0) : ((mp_limb_t) 0L));

      /* v <-- min (u, v) */
      vlimb += (vgtu & t);

      /* u <-- |u - v| */
      ulimb = (t ^ vgtu) - vgtu;
# 180 "gcd_1.c"
      if (0)
 {
 strip_u_maybe:
   vlimb >>= 1;
   t = ulimb;
 }
      do { UWtype __ctz_x = (t); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (c) = 32 - 1 - __ctz_c; } while (0);

      ulimb >>= (c + 1);
    }

  vlimb = (vlimb << 1) | 1;





 done:
  return vlimb << zero_bits;
}

# 41 "scan0.c"
mp_bitcnt_t
__gmpz_scan0 (mpz_srcptr u, mp_bitcnt_t starting_bit)
{
  mp_srcptr u_ptr = ((u)->_mp_d);
  mp_size_t size = ((u)->_mp_size);
  mp_size_t abs_size = ((size) >= 0 ? (size) : -(size));
  mp_srcptr u_end = u_ptr + abs_size;
  mp_size_t starting_limb = starting_bit / (32 - 0);
  mp_srcptr p = u_ptr + starting_limb;
  mp_limb_t limb;
  int cnt;

  /* When past end, there's an immediate 0 bit for u>=0, or no 0 bits for
     u<0.  Notice this test picks up all cases of u==0 too. */
  if (starting_limb >= abs_size)
    return (size >= 0 ? starting_bit : ~(mp_bitcnt_t) 0);

  limb = *p;

  if (size >= 0)
    {
      /* Mask to 1 all bits before starting_bit, thus ignoring them. */
      limb |= (((mp_limb_t) 1L) << (starting_bit % (32 - 0))) - 1;

      /* Search for a limb which isn't all ones.  If the end is reached then
	 the zero bit immediately past the end is returned.  */
      while (limb == ((~ ((mp_limb_t) (0))) >> 0))
 {
   p++;
   if (p == u_end)
     return (mp_bitcnt_t) abs_size * (32 - 0);
   limb = *p;
 }

      /* Now seek low 1 bit. */
      limb = ~limb;
    }
  else
    {
      mp_srcptr q;

      /* If there's a non-zero limb before ours then we're in the ones
	 complement region.  Search from *(p-1) downwards since that might
	 give better cache locality, and since a non-zero in the middle of a
	 number is perhaps a touch more likely than at the end.  */
      q = p;
      while (q != u_ptr)
 {
   q--;
   if (*q != 0)
     goto inverted;
 }

      /* Adjust so ~limb implied by searching for 1 bit below becomes -limb.
	 If limb==0 here then this isn't the beginning of twos complement
	 inversion, but that doesn't matter because limb==0 is a zero bit
	 immediately (-1 is all ones for below).  */
      limb--;

    inverted:
      /* Now seeking a 1 bit. */

      /* Mask to 0 all bits before starting_bit, thus ignoring them. */
      limb &= ((~ (mp_limb_t) 0) << (starting_bit % (32 - 0)));

      if (limb == 0)
 {
   /* If the high limb is zero after masking, then no 1 bits past
	     starting_bit.  */
   p++;
   if (p == u_end)
     return ~(mp_bitcnt_t) 0;

   /* Search further for a non-zero limb.  The high limb is non-zero,
	     if nothing else.  */
   for (;;)
     {
       limb = *p;
       if (limb != 0)
  break;
       p++;
       do {} while (0);
     }
 }
    }

  do {} while (0);
  do { UWtype __ctz_x = (limb); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (cnt) = 32 - 1 - __ctz_c; } while (0);
  return (mp_bitcnt_t) (p - u_ptr) * (32 - 0) + cnt;
}

# 3792 "../gmp-impl.h"
double __gmpn_get_d (mp_srcptr, mp_size_t, mp_size_t, long);

# 35 "get_d_2exp.c"
double
__gmpz_get_d_2exp (signed long int *exp2, mpz_srcptr src)
{
  mp_size_t size, abs_size;
  mp_srcptr ptr;
  long exp;

  size = ((src)->_mp_size);
  if (__builtin_expect ((size == 0) != 0, 0))
    {
      *exp2 = 0;
      return 0.0;
    }

  ptr = ((src)->_mp_d);
  abs_size = ((size) >= 0 ? (size) : -(size));
  do { int __cnt; mp_bitcnt_t __totbits; do {} while (0); do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__cnt) : "r" ((ptr)[(abs_size)-1])); __totbits = (mp_bitcnt_t) (abs_size) * (32 - 0) - (__cnt - 0); (exp) = (__totbits + (1)-1) / (1); } while (0);
  *exp2 = exp;
  return __gmpn_get_d (ptr, abs_size, size, -exp);
}

# 1563 "../gmp.h"
mp_size_t __gmpn_pow_1 (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t, mp_ptr);

# 1632 "../gmp.h"
void __gmpn_copyd (mp_ptr, mp_srcptr, mp_size_t);

# 130 "rootrem.c"
static mp_size_t
mpn_rootrem_internal (mp_ptr rootp, mp_ptr remp, mp_srcptr up, mp_size_t un,
        mp_limb_t k, int approx)
{
  mp_ptr qp, rp, sp, wp, scratch;
  mp_size_t qn, rn, sn, wn, nl, bn;
  mp_limb_t save, save2, cy;
  unsigned long int unb; /* number of significant bits of {up,un} */
  unsigned long int xnb; /* number of significant bits of the result */
  unsigned long b, kk;
  unsigned long sizes[(32 - 0) + 1];
  int ni, i;
  int c;
  int logk;
  struct tmp_reentrant_t *__tmp_marker;

  __tmp_marker = 0;

  if (remp == 
# 148 "rootrem.c" 3 4
             ((void *)0)
# 148 "rootrem.c"
                 )
    {
      rp = ((mp_limb_t *) (__builtin_expect ((((un + 1) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((un + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (un + 1) * sizeof (mp_limb_t)))); /* will contain the remainder */
      scratch = rp; /* used by mpn_div_q */
    }
  else
    {
      scratch = ((mp_limb_t *) (__builtin_expect ((((un + 1) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((un + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (un + 1) * sizeof (mp_limb_t)))); /* used by mpn_div_q */
      rp = remp;
    }
  sp = rootp;

  do { int __cnt; mp_bitcnt_t __totbits; do {} while (0); do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__cnt) : "r" ((up)[(un)-1])); __totbits = (mp_bitcnt_t) (un) * (32 - 0) - (__cnt - 0); (unb) = (__totbits + (1)-1) / (1); } while (0);
  /* unb is the number of bits of the input U */

  xnb = (unb - 1) / k + 1; /* ceil (unb / k) */
  /* xnb is the number of bits of the root R */

  if (xnb == 1) /* root is 1 */
    {
      if (remp == 
# 168 "rootrem.c" 3 4
                 ((void *)0)
# 168 "rootrem.c"
                     )
 remp = rp;
      __gmpn_sub_1 (remp, up, un, (mp_limb_t) 1);
      do { while ((un) > 0) { if ((remp)[(un) - 1] != 0) break; (un)--; } } while (0); /* There should be at most one zero limb,
				   if we demand u to be normalized  */
      rootp[0] = 1;
      do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
      return un;
    }

  /* We initialize the algorithm with a 1-bit approximation to zero: since we
     know the root has exactly xnb bits, we write r0 = 2^(xnb-1), so that
     r0^k = 2^(k*(xnb-1)), that we subtract to the input. */
  kk = k * (xnb - 1); /* number of truncated bits in the input */
  rn = un - kk / (32 - 0); /* number of limbs of the non-truncated part */
  do { if ((kk % (32 - 0)) != 0) cy = __gmpn_rshift (rp, up + kk / (32 - 0), rn, kk % (32 - 0)); else { do { do {} while (0); do {} while (0); __gmpn_copyi (rp, up + kk / (32 - 0), rn); } while (0); cy = 0; } } while (0);
  __gmpn_sub_1 (rp, rp, rn, 1); /* subtract the initial approximation: since
				   the non-truncated part is less than 2^k, it
				   is <= k bits: rn <= ceil(k/GMP_NUMB_BITS) */
  sp[0] = 1; /* initial approximation */
  sn = 1; /* it has one limb */

  for (logk = 1; ((k - 1) >> logk) != 0; logk++)
    ;
  /* logk = ceil(log(k)/log(2)) */

  b = xnb - 1; /* number of remaining bits to determine in the kth root */
  ni = 0;
  while (b != 0)
    {
      /* invariant: here we want b+1 total bits for the kth root */
      sizes[ni] = b;
      /* if c is the new value of b, this means that we'll go from a root
	 of c+1 bits (say s') to a root of b+1 bits.
	 It is proved in the book "Modern Computer Arithmetic" from Brent
	 and Zimmermann, Chapter 1, that
	 if s' >= k*beta, then at most one correction is necessary.
	 Here beta = 2^(b-c), and s' >= 2^c, thus it suffices that
	 c >= ceil((b + log2(k))/2). */
      b = (b + logk + 1) / 2;
      if (b >= sizes[ni])
 b = sizes[ni] - 1; /* add just one bit at a time */
      ni++;
    }
  sizes[ni] = 0;
  do { if (__builtin_expect ((!(ni < (32 - 0) + 1)) != 0, 0)) __gmp_assert_fail ("rootrem.c", 213, "ni < (32 - 0) + 1"); } while (0);
  /* We have sizes[0] = b > sizes[1] > ... > sizes[ni] = 0 with
     sizes[i] <= 2 * sizes[i+1].
     Newton iteration will first compute sizes[ni-1] extra bits,
     then sizes[ni-2], ..., then sizes[0] = b. */

  /* qp and wp need enough space to store S'^k where S' is an approximate
     root. Since S' can be as large as S+2, the worst case is when S=2 and
     S'=4. But then since we know the number of bits of S in advance, S'
     can only be 3 at most. Similarly for S=4, then S' can be 6 at most.
     So the worst case is S'/S=3/2, thus S'^k <= (3/2)^k * S^k. Since S^k
     fits in un limbs, the number of extra limbs needed is bounded by
     ceil(k*log2(3/2)/GMP_NUMB_BITS). */

  qp = ((mp_limb_t *) (__builtin_expect ((((un + 2 + (mp_size_t) (0.585 * (double) k / (double) (32 - 0))) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((un + 2 + (mp_size_t) (0.585 * (double) k / (double) (32 - 0))) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (un + 2 + (mp_size_t) (0.585 * (double) k / (double) (32 - 0))) * sizeof (mp_limb_t)))); /* will contain quotient and remainder
					of R/(k*S^(k-1)), and S^k */
  wp = ((mp_limb_t *) (__builtin_expect ((((un + 2 + (mp_size_t) (0.585 * (double) k / (double) (32 - 0))) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((un + 2 + (mp_size_t) (0.585 * (double) k / (double) (32 - 0))) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (un + 2 + (mp_size_t) (0.585 * (double) k / (double) (32 - 0))) * sizeof (mp_limb_t)))); /* will contain S^(k-1), k*S^(k-1),
					and temporary for mpn_pow_1 */

  wp[0] = 1; /* {sp,sn}^(k-1) = 1 */
  wn = 1;
  for (i = ni; i != 0; i--)
    {
      /* 1: loop invariant:
	 {sp, sn} is the current approximation of the root, which has
		  exactly 1 + sizes[ni] bits.
	 {rp, rn} is the current remainder
	 {wp, wn} = {sp, sn}^(k-1)
	 kk = number of truncated bits of the input
      */
      b = sizes[i - 1] - sizes[i]; /* number of bits to compute in that
				      iteration */

      /* Reinsert a low zero limb if we normalized away the entire remainder */
      if (rn == 0)
 {
   rp[0] = 0;
   rn = 1;
 }

      /* first multiply the remainder by 2^b */
      do { if ((b % (32 - 0)) != 0) cy = __gmpn_lshift (rp + b / (32 - 0), rp, rn, b % (32 - 0)); else { do { do {} while (0); do {} while (0); __gmpn_copyd (rp + b / (32 - 0), rp, rn); } while (0); cy = 0; } } while (0);
      rn = rn + b / (32 - 0);
      if (cy != 0)
 {
   rp[rn] = cy;
   rn++;
 }

      kk = kk - b;

      /* 2: current buffers: {sp,sn}, {rp,rn}, {wp,wn} */

      /* Now insert bits [kk,kk+b-1] from the input U */
      bn = b / (32 - 0); /* lowest limb from high part of rp[] */
      save = rp[bn];
      /* nl is the number of limbs in U which contain bits [kk,kk+b-1] */
      nl = 1 + (kk + b - 1) / (32 - 0) - (kk / (32 - 0));
      /* nl  = 1 + floor((kk + b - 1) / GMP_NUMB_BITS)
		 - floor(kk / GMP_NUMB_BITS)
	     <= 1 + (kk + b - 1) / GMP_NUMB_BITS
		  - (kk - GMP_NUMB_BITS + 1) / GMP_NUMB_BITS
	     = 2 + (b - 2) / GMP_NUMB_BITS
	 thus since nl is an integer:
	 nl <= 2 + floor(b/GMP_NUMB_BITS) <= 2 + bn. */
      /* we have to save rp[bn] up to rp[nl-1], i.e. 1 or 2 limbs */
      if (nl - 1 > bn)
 save2 = rp[bn + 1];
      do { if ((kk % (32 - 0)) != 0) cy = __gmpn_rshift (rp, up + kk / (32 - 0), nl, kk % (32 - 0)); else { do { do {} while (0); do {} while (0); __gmpn_copyi (rp, up + kk / (32 - 0), nl); } while (0); cy = 0; } } while (0);
      /* set to zero high bits of rp[bn] */
      rp[bn] &= ((mp_limb_t) 1 << (b % (32 - 0))) - 1;
      /* restore corresponding bits */
      rp[bn] |= save;
      if (nl - 1 > bn)
 rp[bn + 1] = save2; /* the low b bits go in rp[0..bn] only, since
			       they start by bit 0 in rp[0], so they use
			       at most ceil(b/GMP_NUMB_BITS) limbs */

      /* 3: current buffers: {sp,sn}, {rp,rn}, {wp,wn} */

      /* compute {wp, wn} = k * {sp, sn}^(k-1) */
      cy = __gmpn_mul_1 (wp, wp, wn, k);
      wp[wn] = cy;
      wn += cy != 0;

      /* 4: current buffers: {sp,sn}, {rp,rn}, {wp,wn} */

      /* now divide {rp, rn} by {wp, wn} to get the low part of the root */
      if (rn < wn)
 {
   qn = 0;
 }
      else
 {
   qn = rn - wn; /* expected quotient size */
   __gmpn_div_q (qp, rp, rn, wp, wn, scratch);
   qn += qp[qn] != 0;
 }

      /* 5: current buffers: {sp,sn}, {qp,qn}.
	 Note: {rp,rn} is not needed any more since we'll compute it from
	 scratch at the end of the loop.
       */

      /* Number of limbs used by b bits, when least significant bit is
	 aligned to least limb */
      bn = (b - 1) / (32 - 0) + 1;

      /* the quotient should be smaller than 2^b, since the previous
	 approximation was correctly rounded toward zero */
      if (qn > bn || (qn == bn && (b % (32 - 0) != 0) &&
        qp[qn - 1] >= ((mp_limb_t) 1 << (b % (32 - 0)))))
 {
   qn = b / (32 - 0) + 1; /* b+1 bits */
   do { do {} while (0); if ((qn) != 0) { mp_ptr __dst = (qp); mp_size_t __n = (qn); do *__dst++ = 0; while (--__n); } } while (0);
   qp[qn - 1] = (mp_limb_t) 1 << (b % (32 - 0));
   do { mp_limb_t __x; mp_ptr __p = (qp); if (__builtin_constant_p (1) && (1) == 1) { while ((*(__p++))-- == 0) ; } else { __x = *__p; *__p = __x - (1); if (__x < (1)) while ((*(++__p))-- == 0) ; } } while (0);
   qn -= qp[qn - 1] == 0;
 }

      /* 6: current buffers: {sp,sn}, {qp,qn} */

      /* multiply the root approximation by 2^b */
      do { if ((b % (32 - 0)) != 0) cy = __gmpn_lshift (sp + b / (32 - 0), sp, sn, b % (32 - 0)); else { do { do {} while (0); do {} while (0); __gmpn_copyd (sp + b / (32 - 0), sp, sn); } while (0); cy = 0; } } while (0);
      sn = sn + b / (32 - 0);
      if (cy != 0)
 {
   sp[sn] = cy;
   sn++;
 }

      /* 7: current buffers: {sp,sn}, {qp,qn} */

      do { if (__builtin_expect ((!(bn >= qn)) != 0, 0)) __gmp_assert_fail ("rootrem.c", 346, "bn >= qn"); } while (0); /* this is ok since in the case qn > bn
				   above, q is set to 2^b-1, which has
				   exactly bn limbs */

      /* Combine sB and q to form sB + q.  */
      save = sp[b / (32 - 0)];
      do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (sp, qp, qn); } while (0); } while (0);
      do { do {} while (0); if ((bn - qn) != 0) { mp_ptr __dst = (sp + qn); mp_size_t __n = (bn - qn); do *__dst++ = 0; while (--__n); } } while (0);
      sp[b / (32 - 0)] |= save;

      /* 8: current buffer: {sp,sn} */

      /* Since each iteration treats b bits from the root and thus k*b bits
	 from the input, and we already considered b bits from the input,
	 we now have to take another (k-1)*b bits from the input. */
      kk -= (k - 1) * b; /* remaining input bits */
      /* {rp, rn} = floor({up, un} / 2^kk) */
      do { if ((kk % (32 - 0)) != 0) cy = __gmpn_rshift (rp, up + kk / (32 - 0), un - kk / (32 - 0), kk % (32 - 0)); else { do { do {} while (0); do {} while (0); __gmpn_copyi (rp, up + kk / (32 - 0), un - kk / (32 - 0)); } while (0); cy = 0; } } while (0);
      rn = un - kk / (32 - 0);
      rn -= rp[rn - 1] == 0;

      /* 9: current buffers: {sp,sn}, {rp,rn} */

     for (c = 0;; c++)
 {
   /* Compute S^k in {qp,qn}. */
   if (i == 1)
     {
       /* Last iteration: we don't need W anymore. */
       /* mpn_pow_1 requires that both qp and wp have enough space to
		 store the result {sp,sn}^k + 1 limb */
       approx = approx && (sp[0] > 1);
       qn = (approx == 0) ? __gmpn_pow_1 (qp, sp, sn, k, wp) : 0;
     }
   else
     {
       /* W <- S^(k-1) for the next iteration,
		 and S^k = W * S. */
       wn = __gmpn_pow_1 (wp, sp, sn, k - 1, qp);
       __gmpn_mul (qp, wp, wn, sp, sn);
       qn = wn + sn;
       qn -= qp[qn - 1] == 0;
     }

   /* if S^k > floor(U/2^kk), the root approximation was too large */
   if (qn > rn || (qn == rn && __gmpn_cmp (qp, rp, rn) > 0))
     do { mp_limb_t __x; mp_ptr __p = (sp); if (__builtin_constant_p (1) && (1) == 1) { while ((*(__p++))-- == 0) ; } else { __x = *__p; *__p = __x - (1); if (__x < (1)) while ((*(++__p))-- == 0) ; } } while (0);
   else
     break;
 }

      /* 10: current buffers: {sp,sn}, {rp,rn}, {qp,qn}, {wp,wn} */

      do { if (__builtin_expect ((!(c <= 1)) != 0, 0)) __gmp_assert_fail ("rootrem.c", 399, "c <= 1"); } while (0);
      do { if (__builtin_expect ((!(rn >= qn)) != 0, 0)) __gmp_assert_fail ("rootrem.c", 400, "rn >= qn"); } while (0);

      /* R = R - Q = floor(U/2^kk) - S^k */
      if (i > 1 || approx == 0)
 {
   __gmpn_sub (rp, rp, rn, qp, qn);
   do { while ((rn) > 0) { if ((rp)[(rn) - 1] != 0) break; (rn)--; } } while (0);
 }
      /* otherwise we have rn > 0, thus the return value is ok */

      /* 11: current buffers: {sp,sn}, {rp,rn}, {wp,wn} */
    }

  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
  return rn;
}

# 229 "../gmp.h"
typedef __mpf_struct *mpf_ptr;

# 90 "mul_ui.c"
void
__gmpf_mul_ui (mpf_ptr r, mpf_srcptr u, unsigned long int v)
{
  mp_srcptr up;
  mp_size_t usize;
  mp_size_t size;
  mp_size_t prec, excess;
  mp_limb_t cy_limb, vl, cbit, cin;
  mp_ptr rp;

  usize = u->_mp_size;
  if (__builtin_expect ((v == 0) != 0, 0) || __builtin_expect ((usize == 0) != 0, 0))
    {
      r->_mp_size = 0;
      r->_mp_exp = 0;
      return;
    }
# 124 "mul_ui.c"
  size = ((usize) >= 0 ? (usize) : -(usize));
  prec = r->_mp_prec;
  up = u->_mp_d;
  vl = v;
  excess = size - prec;
  cin = 0;

  if (excess > 0)
    {
      /* up is bigger than desired rp, shorten it to prec limbs and
         determine a carry-in */

      mp_limb_t vl_shifted = vl << 0;
      mp_limb_t hi, lo, next_lo, sum;
      mp_size_t i;

      /* high limb of top product */
      i = excess - 1;
      __asm__ ("umull %0,%1,%2,%3" : "=&r" (lo), "=&r" (cin) : "r" (up[i]), "r" (vl_shifted));

      /* and carry bit out of products below that, if any */
      for (;;)
        {
          i--;
          if (i < 0)
            break;

          __asm__ ("umull %0,%1,%2,%3" : "=&r" (next_lo), "=&r" (hi) : "r" (up[i]), "r" (vl_shifted));
          lo >>= 0;
          do { mp_limb_t __x = (hi); mp_limb_t __y = (lo); mp_limb_t __w = __x + __y; (sum) = __w; (cbit) = __w < __x; } while (0);
          cin += cbit;
          lo = next_lo;

          /* Continue only if the sum is GMP_NUMB_MAX.  GMP_NUMB_MAX is the
             only value a carry from below can propagate across.  If we've
             just seen the carry out (ie. cbit!=0) then sum!=GMP_NUMB_MAX,
             so this test stops us for that case too.  */
          if (__builtin_expect ((sum != ((~ ((mp_limb_t) (0))) >> 0)) != 0, 1))
            break;
        }

      up += excess;
      size = prec;
    }

  rp = r->_mp_d;



  cy_limb = __gmpn_mul_1 (rp, up, size, vl);
  do { mp_size_t __gmp_i; mp_limb_t __gmp_x, __gmp_r; /* ASSERT ((n) >= 1); */ /* ASSERT (MPN_SAME_OR_SEPARATE_P (dst, src, n)); */ __gmp_x = (rp)[0]; __gmp_r = __gmp_x + (cin); (rp)[0] = __gmp_r; if (((__gmp_r) < ((cin)))) { (cbit) = 1; for (__gmp_i = 1; __gmp_i < (size);) { __gmp_x = (rp)[__gmp_i]; __gmp_r = __gmp_x + 1; (rp)[__gmp_i] = __gmp_r; ++__gmp_i; if (!((__gmp_r) < (1))) { if ((rp) != (rp)) do { mp_size_t __gmp_j; /* ASSERT ((size) >= 0); */ /* ASSERT ((start) >= 0); */ /* ASSERT ((start) <= (size)); */ /* ASSERT (MPN_SAME_OR_SEPARATE_P (dst, src, size)); */ ; for (__gmp_j = (__gmp_i); __gmp_j < (size); __gmp_j++) (rp)[__gmp_j] = (rp)[__gmp_j]; } while (0); (cbit) = 0; break; } } } else { if ((rp) != (rp)) do { mp_size_t __gmp_j; /* ASSERT ((size) >= 0); */ /* ASSERT ((start) >= 0); */ /* ASSERT ((start) <= (size)); */ /* ASSERT (MPN_SAME_OR_SEPARATE_P (dst, src, size)); */ ; for (__gmp_j = (1); __gmp_j < (size); __gmp_j++) (rp)[__gmp_j] = (rp)[__gmp_j]; } while (0); (cbit) = 0; } } while (0);
  cy_limb += cbit;

  rp[size] = cy_limb;
  cy_limb = cy_limb != 0;
  r->_mp_exp = u->_mp_exp + cy_limb;
  size += cy_limb;
  r->_mp_size = usize >= 0 ? size : -size;
}

# 1099 "../gmp-impl.h"
void __gmpn_mullo_n (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);

# 77 "powlo.c"
void
__gmpn_powlo (mp_ptr rp, mp_srcptr bp,
    mp_srcptr ep, mp_size_t en,
    mp_size_t n, mp_ptr tp)
{
  int cnt;
  mp_bitcnt_t ebi;
  int windowsize, this_windowsize;
  mp_limb_t expbits;
  mp_limb_t *pp, *this_pp, *last_pp;
  mp_limb_t *b2p;
  long i;
  struct tmp_reentrant_t *__tmp_marker;

  do {} while (0);

  __tmp_marker = 0;

  do { int __cnt; mp_bitcnt_t __totbits; do {} while (0); do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__cnt) : "r" ((ep)[(en)-1])); __totbits = (mp_bitcnt_t) (en) * (32 - 0) - (__cnt - 0); (ebi) = (__totbits + (1)-1) / (1); } while (0);

  windowsize = win_size (ebi);

  pp = ((mp_limb_t *) (__builtin_expect (((((n << (windowsize - 1)) + n) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca(((n << (windowsize - 1)) + n) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, ((n << (windowsize - 1)) + n) * sizeof (mp_limb_t)))); /* + n is for mullo ign part */

  this_pp = pp;

  do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (this_pp, bp, n); } while (0); } while (0);

  b2p = tp + 2*n;

  /* Store b^2 in b2.  */
  __gmpn_sqr (tp, bp, n); /* FIXME: Use "mpn_sqrlo" */
  do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (b2p, tp, n); } while (0); } while (0);

  /* Precompute odd powers of b and put them in the temporary area at pp.  */
  for (i = (1 << (windowsize - 1)) - 1; i > 0; i--)
    {
      last_pp = this_pp;
      this_pp += n;
      __gmpn_mullo_n (this_pp, last_pp, b2p, n);
    }

  expbits = getbits (ep, ebi, windowsize);
  if (ebi < windowsize)
    ebi = 0;
  else
    ebi -= windowsize;

  do { UWtype __ctz_x = (expbits); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (cnt) = 32 - 1 - __ctz_c; } while (0);
  ebi += cnt;
  expbits >>= cnt;

  do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (rp, pp + n * (expbits >> 1), n); } while (0); } while (0);

  while (ebi != 0)
    {
      while (((ep[(ebi - 1) / 32] >> (ebi - 1) % 32) & 1) == 0)
 {
   __gmpn_sqr (tp, rp, n); /* FIXME: Use "mpn_sqrlo" */
   do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (rp, tp, n); } while (0); } while (0);
   ebi--;
   if (ebi == 0)
     goto done;
 }

      /* The next bit of the exponent is 1.  Now extract the largest block of
	 bits <= windowsize, and such that the least significant bit is 1.  */

      expbits = getbits (ep, ebi, windowsize);
      this_windowsize = windowsize;
      if (ebi < windowsize)
 {
   this_windowsize -= windowsize - ebi;
   ebi = 0;
 }
      else
 ebi -= windowsize;

      do { UWtype __ctz_x = (expbits); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (cnt) = 32 - 1 - __ctz_c; } while (0);
      this_windowsize -= cnt;
      ebi += cnt;
      expbits >>= cnt;

      do
 {
   __gmpn_sqr (tp, rp, n);
   do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (rp, tp, n); } while (0); } while (0);
   this_windowsize--;
 }
      while (this_windowsize != 0);

      __gmpn_mullo_n (tp, rp, pp + n * (expbits >> 1), n);
      do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (rp, tp, n); } while (0); } while (0);
    }

 done:
  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
}

# 4277 "../gmp-impl.h"
struct powers
{
  mp_ptr p; /* actual power value */
  mp_size_t n; /* # of limbs at p */
  mp_size_t shift; /* weight of lowest limb, in limb base B */
  size_t digits_in_base; /* number of corresponding digits */
  int base;
};

# 4285 "../gmp-impl.h"
typedef struct powers powers_t;

# 149 "get_str.c"
static unsigned char *
mpn_sb_get_str (unsigned char *str, size_t len,
  mp_ptr up, mp_size_t un, int base)
{
  mp_limb_t rl, ul;
  unsigned char *s;
  size_t l;
  /* Allocate memory for largest possible string, given that we only get here
     for operands with un < GET_STR_PRECOMPUTE_THRESHOLD and that the smallest
     base is 3.  7/11 is an approximation to 1/log2(3).  */





  unsigned char buf[(39 * 32 * 7 / 11)];



  mp_limb_t rp[39];


  if (base == 10)
    {
      /* Special case code for base==10 so that the compiler has a chance to
	 optimize things.  */

      do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (rp + 1, up, un); } while (0); } while (0);

      s = buf + (39 * 32 * 7 / 11);
      while (un > 1)
 {
   int i;
   mp_limb_t frac, digit;
   __gmpn_preinv_divrem_1 (rp, (mp_size_t) 1, rp + 1, un, ((mp_limb_t) 0x3b9aca00L), ((mp_limb_t) 0x12e0be82L), 2)


                                      ;
   un -= rp[un] == 0;
   frac = (rp[0] + 1) << 0;
   s -= 9;
# 201 "get_str.c"
   /* Use the fact that 10 in binary is 1010, with the lowest bit 0.
	     After a few umul_ppmm, we will have accumulated enough low zeros
	     to use a plain multiply.  */
   if (2 == 0)
     {
       __asm__ ("umull %0,%1,%2,%3" : "=&r" (frac), "=&r" (digit) : "r" (frac), "r" (10));
       *s++ = digit;
     }
   if (2 <= 1)
     {
       __asm__ ("umull %0,%1,%2,%3" : "=&r" (frac), "=&r" (digit) : "r" (frac), "r" (10));
       *s++ = digit;
     }
   if (2 <= 2)
     {
       __asm__ ("umull %0,%1,%2,%3" : "=&r" (frac), "=&r" (digit) : "r" (frac), "r" (10));
       *s++ = digit;
     }
   if (2 <= 3)
     {
       __asm__ ("umull %0,%1,%2,%3" : "=&r" (frac), "=&r" (digit) : "r" (frac), "r" (10));
       *s++ = digit;
     }
   i = (9 - ((2 < 4)
          ? (4-2)
          : 0));
   frac = (frac + 0xf) >> 4;
   do
     {
       frac *= 10;
       digit = frac >> (32 - 4);
       *s++ = digit;
       frac &= (~(mp_limb_t) 0) >> 4;
     }
   while (--i);

   s -= 9;
 }

      ul = rp[1];
      while (ul != 0)
 {
   do { mp_limb_t __q = (ul) / (10); mp_limb_t __r = (ul) - __q*(10); (ul) = __q; (rl) = __r; } while (0);
   *--s = rl;
 }
    }
  else /* not base 10 */
    {
      unsigned chars_per_limb;
      mp_limb_t big_base, big_base_inverted;
      unsigned normalization_steps;

      chars_per_limb = __gmpn_bases[base].chars_per_limb;
      big_base = __gmpn_bases[base].big_base;
      big_base_inverted = __gmpn_bases[base].big_base_inverted;
      __asm__ ("clz\t%0, %1" : "=r" (normalization_steps) : "r" (big_base));

      do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (rp + 1, up, un); } while (0); } while (0);

      s = buf + (39 * 32 * 7 / 11);
      while (un > 1)
 {
   int i;
   mp_limb_t frac;
   __gmpn_preinv_divrem_1 (rp, (mp_size_t) 1, rp + 1, un, big_base, big_base_inverted, normalization_steps)

                          ;
   un -= rp[un] == 0;
   frac = (rp[0] + 1) << 0;
   s -= chars_per_limb;
   i = chars_per_limb;
   do
     {
       mp_limb_t digit;
       __asm__ ("umull %0,%1,%2,%3" : "=&r" (frac), "=&r" (digit) : "r" (frac), "r" (base));
       *s++ = digit;
     }
   while (--i);
   s -= chars_per_limb;
 }

      ul = rp[1];
      while (ul != 0)
 {
   do { mp_limb_t __q = (ul) / (base); mp_limb_t __r = (ul) - __q*(base); (ul) = __q; (rl) = __r; } while (0);
   *--s = rl;
 }
    }

  l = buf + (39 * 32 * 7 / 11) - s;
  while (l < len)
    {
      *str++ = 0;
      len--;
    }
  while (l != 0)
    {
      *str++ = *s++;
      l--;
    }
  return str;
}

# 310 "get_str.c"
static unsigned char *
mpn_dc_get_str (unsigned char *str, size_t len,
  mp_ptr up, mp_size_t un,
  const powers_t *powtab, mp_ptr tmp)
{
  if ((! ((__builtin_constant_p (20) && (20) == 0) || (!(__builtin_constant_p (20) && (20) == 0x7fffffffL) && (un) >= (20)))))
    {
      if (un != 0)
 str = mpn_sb_get_str (str, len, up, un, powtab->base);
      else
 {
   while (len != 0)
     {
       *str++ = 0;
       len--;
     }
 }
    }
  else
    {
      mp_ptr pwp, qp, rp;
      mp_size_t pwn, qn;
      mp_size_t sn;

      pwp = powtab->p;
      pwn = powtab->n;
      sn = powtab->shift;

      if (un < pwn + sn || (un == pwn + sn && __gmpn_cmp (up + sn, pwp, un - sn) < 0))
 {
   str = mpn_dc_get_str (str, len, up, un, powtab - 1, tmp);
 }
      else
 {
   qp = tmp; /* (un - pwn + 1) limbs for qp */
   rp = up; /* pwn limbs for rp; overwrite up area */

   __gmpn_tdiv_qr (qp, rp + sn, 0L, up + sn, un - sn, pwp, pwn);
   qn = un - sn - pwn; qn += qp[qn] != 0; /* quotient size */

   do {} while (0);

   if (len != 0)
     len = len - powtab->digits_in_base;

   str = mpn_dc_get_str (str, len, qp, qn, powtab - 1, tmp + qn);
   str = mpn_dc_get_str (str, powtab->digits_in_base, rp, pwn + sn, powtab - 1, tmp);
 }
    }
  return str;
}

# 367 "get_str.c"
size_t
__gmpn_get_str (unsigned char *str, int base, mp_ptr up, mp_size_t un)
{
  mp_ptr powtab_mem, powtab_mem_ptr;
  mp_limb_t big_base;
  size_t digits_in_base;
  powers_t powtab[32];
  int pi;
  mp_size_t n;
  mp_ptr p, t;
  size_t out_len;
  mp_ptr tmp;
  struct tmp_reentrant_t *__tmp_marker;

  /* Special case zero, as the code below doesn't handle it.  */
  if (un == 0)
    {
      str[0] = 0;
      return 1;
    }

  if ((((base) & ((base) - 1)) == 0))
    {
      /* The base is a power of 2.  Convert from most significant end.  */
      mp_limb_t n1, n0;
      int bits_per_digit = __gmpn_bases[base].big_base;
      int cnt;
      int bit_pos;
      mp_size_t i;
      unsigned char *s = str;
      mp_bitcnt_t bits;

      n1 = up[un - 1];
      __asm__ ("clz\t%0, %1" : "=r" (cnt) : "r" (n1));

      /* BIT_POS should be R when input ends in least significant nibble,
	 R + bits_per_digit * n when input ends in nth least significant
	 nibble. */

      bits = (mp_bitcnt_t) (32 - 0) * un - cnt + 0;
      cnt = bits % bits_per_digit;
      if (cnt != 0)
 bits += bits_per_digit - cnt;
      bit_pos = bits - (mp_bitcnt_t) (un - 1) * (32 - 0);

      /* Fast loop for bit output.  */
      i = un - 1;
      for (;;)
 {
   bit_pos -= bits_per_digit;
   while (bit_pos >= 0)
     {
       *s++ = (n1 >> bit_pos) & ((1 << bits_per_digit) - 1);
       bit_pos -= bits_per_digit;
     }
   i--;
   if (i < 0)
     break;
   n0 = (n1 << -bit_pos) & ((1 << bits_per_digit) - 1);
   n1 = up[i];
   bit_pos += (32 - 0);
   *s++ = n0 | (n1 >> bit_pos);
 }

      return s - str;
    }

  /* General case.  The base is not a power of 2.  */

  if ((! ((__builtin_constant_p (39) && (39) == 0) || (!(__builtin_constant_p (39) && (39) == 0x7fffffffL) && (un) >= (39)))))
    return mpn_sb_get_str (str, (size_t) 0, up, un, base) - str;

  __tmp_marker = 0;

  /* Allocate one large block for the powers of big_base.  */
  powtab_mem = ((mp_limb_t *) __gmp_tmp_reentrant_alloc (&__tmp_marker, (((un) + 2 * 32)) * sizeof (mp_limb_t)));
  powtab_mem_ptr = powtab_mem;

  /* Compute a table of powers, were the largest power is >= sqrt(U).  */

  big_base = __gmpn_bases[base].big_base;
  digits_in_base = __gmpn_bases[base].chars_per_limb;

  {
    mp_size_t n_pows, xn, pn, exptab[32], bexp;
    mp_limb_t cy;
    mp_size_t shift;
    size_t ndig;

    do { mp_limb_t _ph, _pl; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_pl), "=&r" (_ph) : "r" (__gmpn_bases[base].logb2), "r" ((32 - 0) * (mp_limb_t) (un))); ndig = _ph; } while (0);
    xn = 1 + ndig / __gmpn_bases[base].chars_per_limb; /* FIXME: scalar integer division */

    n_pows = 0;
    for (pn = xn; pn != 1; pn = (pn + 1) >> 1)
      {
 exptab[n_pows] = pn;
 n_pows++;
      }
    exptab[n_pows] = 1;

    powtab[0].p = &big_base;
    powtab[0].n = 1;
    powtab[0].digits_in_base = digits_in_base;
    powtab[0].base = base;
    powtab[0].shift = 0;

    powtab[1].p = powtab_mem_ptr; powtab_mem_ptr += 2;
    powtab[1].p[0] = big_base;
    powtab[1].n = 1;
    powtab[1].digits_in_base = digits_in_base;
    powtab[1].base = base;
    powtab[1].shift = 0;

    n = 1;
    p = &big_base;
    bexp = 1;
    shift = 0;
    for (pi = 2; pi < n_pows; pi++)
      {
 t = powtab_mem_ptr;
 powtab_mem_ptr += 2 * n + 2;

 do { if (__builtin_expect ((!(powtab_mem_ptr < powtab_mem + ((un) + 2 * 32))) != 0, 0)) __gmp_assert_fail ("get_str.c", 489, "powtab_mem_ptr < powtab_mem + ((un) + 2 * 32)"); } while (0);

 __gmpn_sqr (t, p, n);

 digits_in_base *= 2;
 n *= 2; n -= t[n - 1] == 0;
 bexp *= 2;

 if (bexp + 1 < exptab[n_pows - pi])
   {
     digits_in_base += __gmpn_bases[base].chars_per_limb;
     cy = __gmpn_mul_1 (t, t, n, big_base);
     t[n] = cy;
     n += cy != 0;
     bexp += 1;
   }
 shift *= 2;
 /* Strip low zero limbs.  */
 while (t[0] == 0)
   {
     t++;
     n--;
     shift++;
   }
 p = t;
 powtab[pi].p = p;
 powtab[pi].n = n;
 powtab[pi].digits_in_base = digits_in_base;
 powtab[pi].base = base;
 powtab[pi].shift = shift;
      }

    for (pi = 1; pi < n_pows; pi++)
      {
 t = powtab[pi].p;
 n = powtab[pi].n;
 cy = __gmpn_mul_1 (t, t, n, big_base);
 t[n] = cy;
 n += cy != 0;
 if (t[0] == 0)
   {
     powtab[pi].p = t + 1;
     n--;
     powtab[pi].shift++;
   }
 powtab[pi].n = n;
 powtab[pi].digits_in_base += __gmpn_bases[base].chars_per_limb;
      }
# 545 "get_str.c"
  }

  /* Using our precomputed powers, now in powtab[], convert our number.  */
  tmp = ((mp_limb_t *) __gmp_tmp_reentrant_alloc (&__tmp_marker, (((un) + 32)) * sizeof (mp_limb_t)));
  out_len = mpn_dc_get_str (str, 0, up, un, powtab + (pi - 1), tmp) - str;
  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);

  return out_len;
}

# 36 "get_d_2exp.c"
double
__gmpf_get_d_2exp (signed long int *exp2, mpf_srcptr src)
{
  mp_size_t size, abs_size;
  mp_srcptr ptr;
  int cnt;
  long exp;

  size = ((src)->_mp_size);
  if (__builtin_expect ((size == 0) != 0, 0))
    {
      *exp2 = 0;
      return 0.0;
    }

  ptr = ((src)->_mp_d);
  abs_size = ((size) >= 0 ? (size) : -(size));
  __asm__ ("clz\t%0, %1" : "=r" (cnt) : "r" (ptr[abs_size - 1]));
  cnt -= 0;

  exp = ((src)->_mp_exp) * (32 - 0) - cnt;
  *exp2 = exp;

  return __gmpn_get_d (ptr, abs_size, (mp_size_t) 0,
                    (long) - (abs_size * (32 - 0) - cnt));
}

# 4676 "../gmp-impl.h"
static inline int
mpn_zero_p (mp_srcptr ap, mp_size_t n)
{
  while (--n >= 0)
    {
      if (ap[n] != 0)
 return 0;
    }
  return 1;
}

# 41 "scan1.c"
mp_bitcnt_t
__gmpz_scan1 (mpz_srcptr u, mp_bitcnt_t starting_bit)
{
  mp_srcptr u_ptr = ((u)->_mp_d);
  mp_size_t size = ((u)->_mp_size);
  mp_size_t abs_size = ((size) >= 0 ? (size) : -(size));
  mp_srcptr u_end = u_ptr + abs_size - 1;
  mp_size_t starting_limb = starting_bit / (32 - 0);
  mp_srcptr p = u_ptr + starting_limb;
  mp_limb_t limb;
  int cnt;

  /* Past the end there's no 1 bits for u>=0, or an immediate 1 bit for u<0.
     Notice this test picks up any u==0 too. */
  if (starting_limb >= abs_size)
    return (size >= 0 ? ~(mp_bitcnt_t) 0 : starting_bit);

  /* This is an important case, where sign is not relevant! */
  if (starting_bit == 0)
    goto short_cut;

  limb = *p;

  if (size >= 0)
    {
      /* Mask to 0 all bits before starting_bit, thus ignoring them. */
      limb &= ((~ (mp_limb_t) 0) << (starting_bit % (32 - 0)));

      if (limb == 0)
 {
   /* If it's the high limb which is zero after masking, then there's
	     no 1 bits after starting_bit.  */
   if (p == u_end)
     return ~(mp_bitcnt_t) 0;

   /* Otherwise search further for a non-zero limb.  The high limb is
	     non-zero, if nothing else.  */
 search_nonzero:
   do
     {
       do {} while (0);
       p++;
     short_cut:
       limb = *p;
     }
   while (limb == 0);
 }
    }
  else
    {
      /* If there's a non-zero limb before ours then we're in the ones
	 complement region.  */
      if (mpn_zero_p (u_ptr, starting_limb)) {
 if (limb == 0)
   /* Seeking for the first non-zero bit, it is the same for u and -u. */
   goto search_nonzero;

 /* Adjust so ~limb implied by searching for 0 bit becomes -limb.  */
 limb--;
      }

      /* Now seeking a 0 bit. */

      /* Mask to 1 all bits before starting_bit, thus ignoring them. */
      limb |= (((mp_limb_t) 1L) << (starting_bit % (32 - 0))) - 1;

      /* Search for a limb which is not all ones.  If the end is reached
	 then the zero immediately past the end is the result.  */
      while (limb == ((~ ((mp_limb_t) (0))) >> 0))
 {
   if (p == u_end)
     return (mp_bitcnt_t) abs_size * (32 - 0);
   p++;
   limb = *p;
 }

      /* Now seeking low 1 bit. */
      limb = ~limb;
    }

  do {} while (0);
  do { UWtype __ctz_x = (limb); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (cnt) = 32 - 1 - __ctz_c; } while (0);
  return (mp_bitcnt_t) (p - u_ptr) * (32 - 0) + cnt;
}

# 40 "bdiv_q_1.c"
mp_limb_t
__gmpn_pi1_bdiv_q_1 (mp_ptr rp, mp_srcptr up, mp_size_t n, mp_limb_t d,
    mp_limb_t di, int shift)
{
  mp_size_t i;
  mp_limb_t c, h, l, u, u_next, dummy;

  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);

  d <<= 0;

  if (shift != 0)
    {
      c = 0;

      u = up[0];
      rp--;
      for (i = 1; i < n; i++)
 {
   u_next = up[i];
   u = ((u >> shift) | (u_next << ((32 - 0)-shift))) & ((~ ((mp_limb_t) (0))) >> 0);

   do { mp_limb_t __x = (u); mp_limb_t __y = (c); mp_limb_t __w = __x - __y; (l) = __w; (c) = __w > __x; } while (0);

   l = (l * di) & ((~ ((mp_limb_t) (0))) >> 0);
   rp[i] = l;

   __asm__ ("umull %0,%1,%2,%3" : "=&r" (dummy), "=&r" (h) : "r" (l), "r" (d));
   c += h;
   u = u_next;
 }

      u = u >> shift;
      l = u - c;
      l = (l * di) & ((~ ((mp_limb_t) (0))) >> 0);
      rp[i] = l;
    }
  else
    {
      u = up[0];
      l = (u * di) & ((~ ((mp_limb_t) (0))) >> 0);
      rp[0] = l;
      c = 0;

      for (i = 1; i < n; i++)
 {
   __asm__ ("umull %0,%1,%2,%3" : "=&r" (dummy), "=&r" (h) : "r" (l), "r" (d));
   c += h;

   u = up[i];
   do { mp_limb_t __x = (u); mp_limb_t __y = (c); mp_limb_t __w = __x - __y; (l) = __w; (c) = __w > __x; } while (0);

   l = (l * di) & ((~ ((mp_limb_t) (0))) >> 0);
   rp[i] = l;
 }
    }

  return c;
}

# 104 "bdiv_q_1.c"
mp_limb_t
__gmpn_bdiv_q_1 (mp_ptr rp, mp_srcptr up, mp_size_t n, mp_limb_t d)
{
  mp_limb_t di;
  int shift;

  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);

  if ((d & 1) == 0)
    {
      do { UWtype __ctz_x = (d); UWtype __ctz_c; do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__ctz_c) : "r" (__ctz_x & -__ctz_x)); (shift) = 32 - 1 - __ctz_c; } while (0);
      d >>= shift;
    }
  else
    shift = 0;

  do { mp_limb_t __n = (d); mp_limb_t __inv; do {} while (0); __inv = __gmp_binvert_limb_table[(__n/2) & 0x7F]; /*  8 */ if ((32 - 0) > 8) __inv = 2 * __inv - __inv * __inv * __n; if ((32 - 0) > 16) __inv = 2 * __inv - __inv * __inv * __n; if ((32 - 0) > 32) __inv = 2 * __inv - __inv * __inv * __n; if ((32 - 0) > 64) { int __invbits = 64; do { __inv = 2 * __inv - __inv * __inv * __n; __invbits *= 2; } while (__invbits < (32 - 0)); } do {} while (0); (di) = __inv & ((~ ((mp_limb_t) (0))) >> 0); } while (0);
  return __gmpn_pi1_bdiv_q_1 (rp, up, n, d, di, shift);
}

# 2188 "../gmp.h"
/* extern */ __inline__

mp_limb_t
__gmpn_neg (mp_ptr __gmp_rp, mp_srcptr __gmp_up, mp_size_t __gmp_n)
{
  mp_limb_t __gmp_ul, __gmp_cy;
  __gmp_cy = 0;
  do {
      __gmp_ul = *__gmp_up++;
      *__gmp_rp++ = -__gmp_ul - __gmp_cy;
      __gmp_cy |= __gmp_ul != 0;
  } while (--__gmp_n != 0);
  return __gmp_cy;
}

# 1690 "../gmp-impl.h"
void __gmpn_brootinv (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t, mp_ptr);

# 1696 "../gmp-impl.h"
int __gmpn_bsqrtinv (mp_ptr, mp_srcptr, mp_bitcnt_t, mp_ptr);

# 2019 "../gmp-impl.h"
typedef struct
{
  unsigned long d; /* current index in s[] */
  unsigned long s0; /* number corresponding to s[0] */
  unsigned long sqrt_s0; /* misnomer for sqrt(s[SIEVESIZE-1]) */
  unsigned char s[512 /* FIXME: Allow gmp_init_primesieve to choose */ + 1]; /* sieve table */
} gmp_primesieve_t;

# 2028 "../gmp-impl.h"
void __gmp_init_primesieve (gmp_primesieve_t *);

# 2031 "../gmp-impl.h"
unsigned long int __gmp_nextprime (gmp_primesieve_t *);

# 2572 "../gmp-impl.h"
mp_limb_t __gmpn_trialdiv (mp_srcptr, mp_size_t, mp_size_t, int *);

# 51 "perfpow.c"
static int
pow_equals (mp_srcptr np, mp_size_t n,
     mp_srcptr xp,mp_size_t xn,
     mp_limb_t k, mp_bitcnt_t f,
     mp_ptr tp)
{
  mp_limb_t *tp2;
  mp_bitcnt_t y, z;
  mp_size_t i, bn;
  int ans;
  mp_limb_t h, l;
  struct tmp_reentrant_t *__tmp_marker;

  do {} while (0);
  do {} while (0);
  do {} while (0);

  if (xn == 1 && xp[0] == 1)
    return 0;

  z = 1 + (n >> 1);
  for (bn = 1; bn < z; bn <<= 1)
    {
      __gmpn_powlo (tp, xp, &k, 1, bn, tp + bn);
      if (__gmpn_cmp (tp, np, bn) != 0)
 return 0;
    }

  __tmp_marker = 0;

  /* Final check. Estimate the size of {xp,xn}^k before computing the power
     with full precision.  Optimization: It might pay off to make a more
     accurate estimation of the logarithm of {xp,xn}, rather than using the
     index of the MSB.  */

  do { int __cnt; mp_bitcnt_t __totbits; do {} while (0); do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__cnt) : "r" ((xp)[(xn)-1])); __totbits = (mp_bitcnt_t) (xn) * (32 - 0) - (__cnt - 0); (y) = (__totbits + (1)-1) / (1); } while (0);
  y -= 1; /* msb_index (xp, xn) */

  __asm__ ("umull %0,%1,%2,%3" : "=&r" (l), "=&r" (h) : "r" (k), "r" (y));
  h -= l == 0; l--; /* two-limb decrement */

  z = f - 1; /* msb_index (np, n) */
  if (h == 0 && l <= z)
    {
      mp_limb_t size;
      size = l + k;
      do { if (__builtin_expect ((!(size >= k)) != 0, 0)) __gmp_assert_fail ("perfpow.c", 97, "size >= k"); } while (0);

      y = 2 + size / 32;
      tp2 = ((mp_limb_t *) (__builtin_expect ((((y) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((y) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (y) * sizeof (mp_limb_t))));

      i = __gmpn_pow_1 (tp, xp, xn, k, tp2);
      if (i == n && __gmpn_cmp (tp, np, n) == 0)
 ans = 1;
      else
 ans = 0;
    }
  else
    {
      ans = 0;
    }

  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
  return ans;
}

# 120 "perfpow.c"
static int
is_kth_power (mp_ptr rp, mp_srcptr np,
       mp_limb_t k, mp_srcptr ip,
       mp_size_t n, mp_bitcnt_t f,
       mp_ptr tp)
{
  mp_bitcnt_t b;
  mp_size_t rn, xn;

  do {} while (0);
  do {} while (0);
  do {} while (0);

  if (k == 2)
    {
      b = (f + 1) >> 1;
      rn = 1 + b / 32;
      if (__gmpn_bsqrtinv (rp, ip, b, tp) != 0)
 {
   rp[rn - 1] &= (((mp_limb_t) 1L) << (b % 32)) - 1;
   xn = rn;
   do { while ((xn) > 0) { if ((rp)[(xn) - 1] != 0) break; (xn)--; } } while (0);
   if (pow_equals (np, n, rp, xn, k, f, tp) != 0)
     return 1;

   /* Check if (2^b - r)^2 == n */
   __gmpn_neg (rp, rp, rn);
   rp[rn - 1] &= (((mp_limb_t) 1L) << (b % 32)) - 1;
   do { while ((rn) > 0) { if ((rp)[(rn) - 1] != 0) break; (rn)--; } } while (0);
   if (pow_equals (np, n, rp, rn, k, f, tp) != 0)
     return 1;
 }
    }
  else
    {
      b = 1 + (f - 1) / k;
      rn = 1 + (b - 1) / 32;
      __gmpn_brootinv (rp, ip, rn, k, tp);
      if ((b % 32) != 0)
 rp[rn - 1] &= (((mp_limb_t) 1L) << (b % 32)) - 1;
      do { while ((rn) > 0) { if ((rp)[(rn) - 1] != 0) break; (rn)--; } } while (0);
      if (pow_equals (np, n, rp, rn, k, f, tp) != 0)
 return 1;
    }
  do { do {} while (0); if ((rn) != 0) { mp_ptr __dst = (rp); mp_size_t __n = (rn); do *__dst++ = 0; while (--__n); } } while (0); /* Untrash rp */
  return 0;
}

# 168 "perfpow.c"
static int
perfpow (mp_srcptr np, mp_size_t n,
  mp_limb_t ub, mp_limb_t g,
  mp_bitcnt_t f, int neg)
{
  mp_ptr ip, tp, rp;
  mp_limb_t k;
  int ans;
  mp_bitcnt_t b;
  gmp_primesieve_t ps;
  struct tmp_reentrant_t *__tmp_marker;

  do {} while (0);
  do {} while (0);
  do {} while (0);

  __tmp_marker = 0;
  __gmp_init_primesieve (&ps);
  b = (f + 3) >> 1;

  ip = ((mp_limb_t *) (__builtin_expect ((((n) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((n) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (n) * sizeof (mp_limb_t))));
  rp = ((mp_limb_t *) (__builtin_expect ((((n) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((n) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (n) * sizeof (mp_limb_t))));
  tp = ((mp_limb_t *) (__builtin_expect ((((5 * n) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((5 * n) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (5 * n) * sizeof (mp_limb_t)))); /* FIXME */
  do { do {} while (0); if ((n) != 0) { mp_ptr __dst = (rp); mp_size_t __n = (n); do *__dst++ = 0; while (--__n); } } while (0);

  /* FIXME: It seems the inverse in ninv is needed only to get non-inverted
     roots. I.e., is_kth_power computes n^{1/2} as (n^{-1})^{-1/2} and
     similarly for nth roots. It should be more efficient to compute n^{1/2} as
     n * n^{-1/2}, with a mullo instead of a binvert. And we can do something
     similar for kth roots if we switch to an iteration converging to n^{1/k -
     1}, and we can then eliminate this binvert call. */
  __gmpn_binvert (ip, np, 1 + (b - 1) / 32, tp);
  if (b % 32)
    ip[(b - 1) / 32] &= (((mp_limb_t) 1L) << (b % 32)) - 1;

  if (neg)
    __gmp_nextprime (&ps);

  ans = 0;
  if (g > 0)
    {
      ub = ((ub) < (g + 1) ? (ub) : (g + 1));
      while ((k = __gmp_nextprime (&ps)) < ub)
 {
   if ((g % k) == 0)
     {
       if (is_kth_power (rp, np, k, ip, n, f, tp) != 0)
  {
    ans = 1;
    goto ret;
  }
     }
 }
    }
  else
    {
      while ((k = __gmp_nextprime (&ps)) < ub)
 {
   if (is_kth_power (rp, np, k, ip, n, f, tp) != 0)
     {
       ans = 1;
       goto ret;
     }
 }
    }
 ret:
  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
  return ans;
}

# 238 "perfpow.c"
static const unsigned short nrtrial[] = { 100, 500, 1000 };

# 242 "perfpow.c"
static const double logs[] =
  { 0.1099457228193620, 0.0847016403115322, 0.0772048195144415 };

# 245 "perfpow.c"
int
__gmpn_perfect_power_p (mp_srcptr np, mp_size_t n)
{
  mp_size_t ncn, s, pn, xn;
  mp_limb_t *nc, factor, g;
  mp_limb_t exp, *prev, *next, d, l, r, c, *tp, cry;
  mp_bitcnt_t twos, count;
  int ans, where, neg, trial;
  struct tmp_reentrant_t *__tmp_marker;

  nc = (mp_ptr) np;

  neg = 0;
  if (n < 0)
    {
      neg = 1;
      n = -n;
    }

  if (n == 0 || (n == 1 && np[0] == 1))
    return 1;

  __tmp_marker = 0;

  g = 0;

  ncn = n;
  twos = __gmpn_scan1 (np, 0);
  if (twos > 0)
    {
      if (twos == 1)
 {
   ans = 0;
   goto ret;
 }
      s = twos / 32;
      if (s + 1 == n && (((np[s]) & ((np[s]) - 1)) == 0))
 {
   ans = ! (neg && (((twos) & ((twos) - 1)) == 0));
   goto ret;
 }
      count = twos % 32;
      ncn = n - s;
      nc = ((mp_limb_t *) (__builtin_expect ((((ncn) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((ncn) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (ncn) * sizeof (mp_limb_t))));
      if (count > 0)
 {
   __gmpn_rshift (nc, np + s, ncn, count);
   ncn -= (nc[ncn - 1] == 0);
 }
      else
 {
   do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (nc, np + s, ncn); } while (0); } while (0);
 }
      g = twos;
    }

  if (ncn <= 20)
    trial = 0;
  else if (ncn <= 100)
    trial = 1;
  else
    trial = 2;

  where = 0;
  factor = __gmpn_trialdiv (nc, ncn, nrtrial[trial], &where);

  if (factor != 0)
    {
      if (twos == 0)
 {
   nc = ((mp_limb_t *) (__builtin_expect ((((ncn) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((ncn) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (ncn) * sizeof (mp_limb_t))));
   do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (nc, np, ncn); } while (0); } while (0);
 }

      /* Remove factors found by trialdiv.  Optimization: Perhaps better to use
	 the strategy in mpz_remove ().  */
      prev = ((mp_limb_t *) (__builtin_expect ((((ncn + 2) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((ncn + 2) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (ncn + 2) * sizeof (mp_limb_t))));
      next = ((mp_limb_t *) (__builtin_expect ((((ncn + 2) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((ncn + 2) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (ncn + 2) * sizeof (mp_limb_t))));
      tp = ((mp_limb_t *) (__builtin_expect ((((4 * ncn) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? __builtin_alloca((4 * ncn) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (4 * ncn) * sizeof (mp_limb_t))));

      do
 {
   do { mp_limb_t __n = (factor); mp_limb_t __inv; do {} while (0); __inv = __gmp_binvert_limb_table[(__n/2) & 0x7F]; /*  8 */ if ((32 - 0) > 8) __inv = 2 * __inv - __inv * __inv * __n; if ((32 - 0) > 16) __inv = 2 * __inv - __inv * __inv * __n; if ((32 - 0) > 32) __inv = 2 * __inv - __inv * __inv * __n; if ((32 - 0) > 64) { int __invbits = 64; do { __inv = 2 * __inv - __inv * __inv * __n; __invbits *= 2; } while (__invbits < (32 - 0)); } do {} while (0); (d) = __inv & ((~ ((mp_limb_t) (0))) >> 0); } while (0);
   prev[0] = d;
   pn = 1;
   exp = 1;
   while (2 * pn - 1 <= ncn)
     {
       __gmpn_sqr (next, prev, pn);
       xn = 2 * pn;
       xn -= (next[xn - 1] == 0);

       if (__gmpn_divisible_p (nc, ncn, next, xn) == 0)
  break;

       exp <<= 1;
       pn = xn;
       do { mp_ptr __mp_ptr_swap__tmp = (next); (next) = (prev); (prev) = __mp_ptr_swap__tmp; } while (0);
     }

   /* Binary search for the exponent */
   l = exp + 1;
   r = 2 * exp - 1;
   while (l <= r)
     {
       c = (l + r) >> 1;
       if (c - exp > 1)
  {
    xn = __gmpn_pow_1 (tp, &d, 1, c - exp, next);
    if (pn + xn - 1 > ncn)
      {
        r = c - 1;
        continue;
      }
    __gmpn_mul (next, prev, pn, tp, xn);
    xn += pn;
    xn -= (next[xn - 1] == 0);
  }
       else
  {
    cry = __gmpn_mul_1 (next, prev, pn, d);
    next[pn] = cry;
    xn = pn + (cry != 0);
  }

       if (__gmpn_divisible_p (nc, ncn, next, xn) == 0)
  {
    r = c - 1;
  }
       else
  {
    exp = c;
    l = c + 1;
    do { mp_ptr __mp_ptr_swap__tmp = (next); (next) = (prev); (prev) = __mp_ptr_swap__tmp; } while (0);
    pn = xn;
  }
     }

   if (g == 0)
     g = exp;
   else
     g = __gmpn_gcd_1 (&g, 1, exp);

   if (g == 1)
     {
       ans = 0;
       goto ret;
     }

   __gmpn_divexact (next, nc, ncn, prev, pn);
   ncn = ncn - pn;
   ncn += next[ncn] != 0;
   do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (nc, next, ncn); } while (0); } while (0);

   if (ncn == 1 && nc[0] == 1)
     {
       ans = ! (neg && (((g) & ((g) - 1)) == 0));
       goto ret;
     }

   factor = __gmpn_trialdiv (nc, ncn, nrtrial[trial], &where);
 }
      while (factor != 0);
    }

  do { int __cnt; mp_bitcnt_t __totbits; do {} while (0); do {} while (0); __asm__ ("clz\t%0, %1" : "=r" (__cnt) : "r" ((nc)[(ncn)-1])); __totbits = (mp_bitcnt_t) (ncn) * (32 - 0) - (__cnt - 0); (count) = (__totbits + (1)-1) / (1); } while (0); /* log (nc) + 1 */
  d = (mp_limb_t) (count * logs[trial] + 1e-9) + 1;
  ans = perfpow (nc, ncn, d, g, count, neg);

 ret:
  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
  return ans;
}

# 1493 "../gmp.h"
mp_limb_t __gmpn_divrem (mp_ptr, mp_size_t, mp_ptr, mp_size_t, mp_srcptr, mp_size_t);

# 2136 "../gmp.h"
/* extern */ __inline__

mp_limb_t
__gmpn_add_1 (mp_ptr __gmp_dst, mp_srcptr __gmp_src, mp_size_t __gmp_size, mp_limb_t __gmp_n)
{
  mp_limb_t __gmp_c;
  do { mp_size_t __gmp_i; mp_limb_t __gmp_x, __gmp_r; /* ASSERT ((n) >= 1); */ /* ASSERT (MPN_SAME_OR_SEPARATE_P (dst, src, n)); */ __gmp_x = (__gmp_src)[0]; __gmp_r = __gmp_x + (__gmp_n); (__gmp_dst)[0] = __gmp_r; if (((__gmp_r) < ((__gmp_n)))) { (__gmp_c) = 1; for (__gmp_i = 1; __gmp_i < (__gmp_size);) { __gmp_x = (__gmp_src)[__gmp_i]; __gmp_r = __gmp_x + 1; (__gmp_dst)[__gmp_i] = __gmp_r; ++__gmp_i; if (!((__gmp_r) < (1))) { if ((__gmp_src) != (__gmp_dst)) do { mp_size_t __gmp_j; /* ASSERT ((size) >= 0); */ /* ASSERT ((start) >= 0); */ /* ASSERT ((start) <= (size)); */ /* ASSERT (MPN_SAME_OR_SEPARATE_P (dst, src, size)); */ ; for (__gmp_j = (__gmp_i); __gmp_j < (__gmp_size); __gmp_j++) (__gmp_dst)[__gmp_j] = (__gmp_src)[__gmp_j]; } while (0); (__gmp_c) = 0; break; } } } else { if ((__gmp_src) != (__gmp_dst)) do { mp_size_t __gmp_j; /* ASSERT ((size) >= 0); */ /* ASSERT ((start) >= 0); */ /* ASSERT ((start) <= (size)); */ /* ASSERT (MPN_SAME_OR_SEPARATE_P (dst, src, size)); */ ; for (__gmp_j = (1); __gmp_j < (__gmp_size); __gmp_j++) (__gmp_dst)[__gmp_j] = (__gmp_src)[__gmp_j]; } while (0); (__gmp_c) = 0; } } while (0);
  return __gmp_c;
}

# 51 "sqrtrem.c"
static const unsigned char invsqrttab[384] = /* The common 0x100 was removed */
{
  0xff,0xfd,0xfb,0xf9,0xf7,0xf5,0xf3,0xf2, /* sqrt(1/80)..sqrt(1/87) */
  0xf0,0xee,0xec,0xea,0xe9,0xe7,0xe5,0xe4, /* sqrt(1/88)..sqrt(1/8f) */
  0xe2,0xe0,0xdf,0xdd,0xdb,0xda,0xd8,0xd7, /* sqrt(1/90)..sqrt(1/97) */
  0xd5,0xd4,0xd2,0xd1,0xcf,0xce,0xcc,0xcb, /* sqrt(1/98)..sqrt(1/9f) */
  0xc9,0xc8,0xc6,0xc5,0xc4,0xc2,0xc1,0xc0, /* sqrt(1/a0)..sqrt(1/a7) */
  0xbe,0xbd,0xbc,0xba,0xb9,0xb8,0xb7,0xb5, /* sqrt(1/a8)..sqrt(1/af) */
  0xb4,0xb3,0xb2,0xb0,0xaf,0xae,0xad,0xac, /* sqrt(1/b0)..sqrt(1/b7) */
  0xaa,0xa9,0xa8,0xa7,0xa6,0xa5,0xa4,0xa3, /* sqrt(1/b8)..sqrt(1/bf) */
  0xa2,0xa0,0x9f,0x9e,0x9d,0x9c,0x9b,0x9a, /* sqrt(1/c0)..sqrt(1/c7) */
  0x99,0x98,0x97,0x96,0x95,0x94,0x93,0x92, /* sqrt(1/c8)..sqrt(1/cf) */
  0x91,0x90,0x8f,0x8e,0x8d,0x8c,0x8c,0x8b, /* sqrt(1/d0)..sqrt(1/d7) */
  0x8a,0x89,0x88,0x87,0x86,0x85,0x84,0x83, /* sqrt(1/d8)..sqrt(1/df) */
  0x83,0x82,0x81,0x80,0x7f,0x7e,0x7e,0x7d, /* sqrt(1/e0)..sqrt(1/e7) */
  0x7c,0x7b,0x7a,0x79,0x79,0x78,0x77,0x76, /* sqrt(1/e8)..sqrt(1/ef) */
  0x76,0x75,0x74,0x73,0x72,0x72,0x71,0x70, /* sqrt(1/f0)..sqrt(1/f7) */
  0x6f,0x6f,0x6e,0x6d,0x6d,0x6c,0x6b,0x6a, /* sqrt(1/f8)..sqrt(1/ff) */
  0x6a,0x69,0x68,0x68,0x67,0x66,0x66,0x65, /* sqrt(1/100)..sqrt(1/107) */
  0x64,0x64,0x63,0x62,0x62,0x61,0x60,0x60, /* sqrt(1/108)..sqrt(1/10f) */
  0x5f,0x5e,0x5e,0x5d,0x5c,0x5c,0x5b,0x5a, /* sqrt(1/110)..sqrt(1/117) */
  0x5a,0x59,0x59,0x58,0x57,0x57,0x56,0x56, /* sqrt(1/118)..sqrt(1/11f) */
  0x55,0x54,0x54,0x53,0x53,0x52,0x52,0x51, /* sqrt(1/120)..sqrt(1/127) */
  0x50,0x50,0x4f,0x4f,0x4e,0x4e,0x4d,0x4d, /* sqrt(1/128)..sqrt(1/12f) */
  0x4c,0x4b,0x4b,0x4a,0x4a,0x49,0x49,0x48, /* sqrt(1/130)..sqrt(1/137) */
  0x48,0x47,0x47,0x46,0x46,0x45,0x45,0x44, /* sqrt(1/138)..sqrt(1/13f) */
  0x44,0x43,0x43,0x42,0x42,0x41,0x41,0x40, /* sqrt(1/140)..sqrt(1/147) */
  0x40,0x3f,0x3f,0x3e,0x3e,0x3d,0x3d,0x3c, /* sqrt(1/148)..sqrt(1/14f) */
  0x3c,0x3b,0x3b,0x3a,0x3a,0x39,0x39,0x39, /* sqrt(1/150)..sqrt(1/157) */
  0x38,0x38,0x37,0x37,0x36,0x36,0x35,0x35, /* sqrt(1/158)..sqrt(1/15f) */
  0x35,0x34,0x34,0x33,0x33,0x32,0x32,0x32, /* sqrt(1/160)..sqrt(1/167) */
  0x31,0x31,0x30,0x30,0x2f,0x2f,0x2f,0x2e, /* sqrt(1/168)..sqrt(1/16f) */
  0x2e,0x2d,0x2d,0x2d,0x2c,0x2c,0x2b,0x2b, /* sqrt(1/170)..sqrt(1/177) */
  0x2b,0x2a,0x2a,0x29,0x29,0x29,0x28,0x28, /* sqrt(1/178)..sqrt(1/17f) */
  0x27,0x27,0x27,0x26,0x26,0x26,0x25,0x25, /* sqrt(1/180)..sqrt(1/187) */
  0x24,0x24,0x24,0x23,0x23,0x23,0x22,0x22, /* sqrt(1/188)..sqrt(1/18f) */
  0x21,0x21,0x21,0x20,0x20,0x20,0x1f,0x1f, /* sqrt(1/190)..sqrt(1/197) */
  0x1f,0x1e,0x1e,0x1e,0x1d,0x1d,0x1d,0x1c, /* sqrt(1/198)..sqrt(1/19f) */
  0x1c,0x1b,0x1b,0x1b,0x1a,0x1a,0x1a,0x19, /* sqrt(1/1a0)..sqrt(1/1a7) */
  0x19,0x19,0x18,0x18,0x18,0x18,0x17,0x17, /* sqrt(1/1a8)..sqrt(1/1af) */
  0x17,0x16,0x16,0x16,0x15,0x15,0x15,0x14, /* sqrt(1/1b0)..sqrt(1/1b7) */
  0x14,0x14,0x13,0x13,0x13,0x12,0x12,0x12, /* sqrt(1/1b8)..sqrt(1/1bf) */
  0x12,0x11,0x11,0x11,0x10,0x10,0x10,0x0f, /* sqrt(1/1c0)..sqrt(1/1c7) */
  0x0f,0x0f,0x0f,0x0e,0x0e,0x0e,0x0d,0x0d, /* sqrt(1/1c8)..sqrt(1/1cf) */
  0x0d,0x0c,0x0c,0x0c,0x0c,0x0b,0x0b,0x0b, /* sqrt(1/1d0)..sqrt(1/1d7) */
  0x0a,0x0a,0x0a,0x0a,0x09,0x09,0x09,0x09, /* sqrt(1/1d8)..sqrt(1/1df) */
  0x08,0x08,0x08,0x07,0x07,0x07,0x07,0x06, /* sqrt(1/1e0)..sqrt(1/1e7) */
  0x06,0x06,0x06,0x05,0x05,0x05,0x04,0x04, /* sqrt(1/1e8)..sqrt(1/1ef) */
  0x04,0x04,0x03,0x03,0x03,0x03,0x02,0x02, /* sqrt(1/1f0)..sqrt(1/1f7) */
  0x02,0x02,0x01,0x01,0x01,0x01,0x00,0x00 /* sqrt(1/1f8)..sqrt(1/1ff) */
};

# 111 "sqrtrem.c"
static mp_limb_t
mpn_sqrtrem1 (mp_ptr rp, mp_limb_t a0)
{



  mp_limb_t x0, t2, t, x2;
  unsigned abits;

  do { if (__builtin_expect ((!(0 == 0)) != 0, 0)) __gmp_assert_fail ("sqrtrem.c", 120, "0 == 0"); } while (0);
  do { if (__builtin_expect ((!(32 == 32 || 32 == 64)) != 0, 0)) __gmp_assert_fail ("sqrtrem.c", 121, "32 == 32 || 32 == 64"); } while (0);
  do {} while (0);

  /* Use Newton iterations for approximating 1/sqrt(a) instead of sqrt(a),
     since we can do the former without division.  As part of the last
     iteration convert from 1/sqrt(a) to sqrt(a).  */

  abits = a0 >> (32 - 1 - 8); /* extract bits for table lookup */
  x0 = 0x100 | invsqrttab[abits - 0x80]; /* initial 1/sqrt(a) */

  /* x0 is now an 8 bits approximation of 1/sqrt(a0) */
# 146 "sqrtrem.c"
  t2 = x0 * (a0 >> (16-8));
  t = t2 >> 13;
  t = ((mp_limb_signed_t) ((a0 << 6) - t * t - ((mp_limb_t) 0x100000L) /* 0xfee6f < MAGIC < 0x29cbc8 */) >> (16-8));
  x0 = t2 + ((mp_limb_signed_t) (x0 * t) >> 7);
  x0 >>= 16;


  /* x0 is now a full limb approximation of sqrt(a0) */

  x2 = x0 * x0;
  if (x2 + 2*x0 <= a0 - 1)
    {
      x2 += 2*x0 + 1;
      x0++;
    }

  *rp = a0 - x2;
  return x0;
}

# 171 "sqrtrem.c"
static mp_limb_t
mpn_sqrtrem2 (mp_ptr sp, mp_ptr rp, mp_srcptr np)
{
  mp_limb_t qhl, q, u, np0, sp0, rp0, q2;
  int cc;

  do {} while (0);

  np0 = np[0];
  sp0 = mpn_sqrtrem1 (rp, np[1]);
  qhl = 0;
  rp0 = rp[0];
  while (rp0 >= sp0)
    {
      qhl++;
      rp0 -= sp0;
    }
  /* now rp0 < sp0 < 2^Prec */
  rp0 = (rp0 << ((32 - 0) >> 1)) + (np0 >> ((32 - 0) >> 1));
  u = 2 * sp0;
  q = rp0 / u;
  u = rp0 - q * u;
  q += (qhl & 1) << (((32 - 0) >> 1) - 1);
  qhl >>= 1; /* if qhl=1, necessary q=0 as qhl*2^Prec + q <= 2^Prec */
  /* now we have (initial rp0)<<Prec + np0>>Prec = (qhl<<Prec + q) * (2sp0) + u */
  sp0 = ((sp0 + qhl) << ((32 - 0) >> 1)) + q;
  cc = u >> ((32 - 0) >> 1);
  rp0 = ((u << ((32 - 0) >> 1)) & ((~ ((mp_limb_t) (0))) >> 0)) + (np0 & (((mp_limb_t) 1 << ((32 - 0) >> 1)) - 1));
  /* subtract q * q or qhl*2^(2*Prec) from rp */
  q2 = q * q;
  cc -= (rp0 < q2) + qhl;
  rp0 -= q2;
  /* now subtract 2*q*2^Prec + 2^(2*Prec) if qhl is set */
  if (cc < 0)
    {
      if (sp0 != 0)
 {
   rp0 += sp0;
   cc += rp0 < sp0;
 }
      else
 cc++;
      --sp0;
      rp0 += sp0;
      cc += rp0 < sp0;
    }

  rp[0] = rp0;
  sp[0] = sp0;
  return cc;
}

# 228 "sqrtrem.c"
static mp_limb_t
mpn_dc_sqrtrem (mp_ptr sp, mp_ptr np, mp_size_t n)
{
  mp_limb_t q; /* carry out of {sp, n} */
  int c, b; /* carry out of remainder */
  mp_size_t l, h;

  do {} while (0);

  if (n == 1)
    c = mpn_sqrtrem2 (sp, np, np);
  else
    {
      l = n / 2;
      h = n - l;
      q = mpn_dc_sqrtrem (sp + l, np + 2 * l, h);
      if (q != 0)
 __gmpn_sub_n (np + 2 * l, np + 2 * l, sp + l, h);
      q += __gmpn_divrem (sp, 0, np + l, n, sp + l, h);
      c = sp[0] & 1;
      __gmpn_rshift (sp, sp, l, 1);
      sp[l - 1] |= (q << ((32 - 0) - 1)) & ((~ ((mp_limb_t) (0))) >> 0);
      q >>= 1;
      if (c != 0)
 c = __gmpn_add_n (np + l, np + l, sp + l, h);
      __gmpn_sqr (np + n, sp, l);
      b = q + __gmpn_sub_n (np, np, np + n, 2 * l);
      c -= (l == h) ? b : __gmpn_sub_1 (np + 2 * l, np + 2 * l, 1, (mp_limb_t) b);
      q = __gmpn_add_1 (sp + l, sp + l, h, q);

      if (c < 0)
 {

   c += __gmpn_addlsh1_n (np, np, sp, n) + 2 * q;



   c -= __gmpn_sub_1 (np, np, n, ((mp_limb_t) 1L));
   q -= __gmpn_sub_1 (sp, sp, n, ((mp_limb_t) 1L));
 }
    }

  return c;
}

# 274 "sqrtrem.c"
mp_size_t
__gmpn_sqrtrem (mp_ptr sp, mp_ptr rp, mp_srcptr np, mp_size_t nn)
{
  mp_limb_t *tp, s0[1], cc, high, rl;
  int c;
  mp_size_t rn, tn;
  struct tmp_reentrant_t *__tmp_marker;

  do {} while (0);
  do {} while (0);

  /* If OP is zero, both results are zero.  */
  if (nn == 0)
    return 0;

  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);

  high = np[nn - 1];
  if (nn == 1 && (high & (((mp_limb_t) 1L) << ((32 - 0)-1))))
    {
      mp_limb_t r;
      sp[0] = mpn_sqrtrem1 (&r, high);
      if (rp != 
# 299 "sqrtrem.c" 3 4
               ((void *)0)
# 299 "sqrtrem.c"
                   )
 rp[0] = r;
      return r != 0;
    }
  __asm__ ("clz\t%0, %1" : "=r" (c) : "r" (high));
  c -= 0;

  c = c / 2; /* we have to shift left by 2c bits to normalize {np, nn} */
  tn = (nn + 1) / 2; /* 2*tn is the smallest even integer >= nn */

  __tmp_marker = 0;
  if (nn % 2 != 0 || c > 0)
    {
      tp = ((mp_limb_t *) (__builtin_expect ((((2 * tn) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? 
# 312 "sqrtrem.c" 3
          __builtin_alloca (
# 312 "sqrtrem.c"
          (2 * tn) * sizeof (mp_limb_t)
# 312 "sqrtrem.c" 3
          ) 
# 312 "sqrtrem.c"
          : __gmp_tmp_reentrant_alloc (&__tmp_marker, (2 * tn) * sizeof (mp_limb_t))));
      tp[0] = 0; /* needed only when 2*tn > nn, but saves a test */
      if (c != 0)
 __gmpn_lshift (tp + 2 * tn - nn, np, nn, 2 * c);
      else
 do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (tp + 2 * tn - nn, np, nn); } while (0); } while (0);
      rl = mpn_dc_sqrtrem (sp, tp, tn);
      /* We have 2^(2k)*N = S^2 + R where k = c + (2tn-nn)*GMP_NUMB_BITS/2,
	 thus 2^(2k)*N = (S-s0)^2 + 2*S*s0 - s0^2 + R where s0=S mod 2^k */
      c += (nn % 2) * (32 - 0) / 2; /* c now represents k */
      s0[0] = sp[0] & (((mp_limb_t) 1 << c) - 1); /* S mod 2^k */
      rl += __gmpn_addmul_1 (tp, sp, tn, 2 * s0[0]); /* R = R + 2*s0*S */
      cc = __gmpn_submul_1 (tp, s0, 1, s0[0]);
      rl -= (tn > 1) ? __gmpn_sub_1 (tp + 1, tp + 1, tn - 1, cc) : cc;
      __gmpn_rshift (sp, sp, tn, c);
      tp[tn] = rl;
      if (rp == 
# 328 "sqrtrem.c" 3 4
               ((void *)0)
# 328 "sqrtrem.c"
                   )
 rp = tp;
      c = c << 1;
      if (c < (32 - 0))
 tn++;
      else
 {
   tp++;
   c -= (32 - 0);
 }
      if (c != 0)
 __gmpn_rshift (rp, tp, tn, c);
      else
 do { do {} while (0); do {} while (0); __gmpn_copyi (rp, tp, tn); } while (0);
      rn = tn;
    }
  else
    {
      if (rp == 
# 346 "sqrtrem.c" 3 4
               ((void *)0)
# 346 "sqrtrem.c"
                   )
 rp = ((mp_limb_t *) (__builtin_expect ((((nn) * sizeof (mp_limb_t)) < 65536) != 0, 1) ? 
# 347 "sqrtrem.c" 3
     __builtin_alloca (
# 347 "sqrtrem.c"
     (nn) * sizeof (mp_limb_t)
# 347 "sqrtrem.c" 3
     ) 
# 347 "sqrtrem.c"
     : __gmp_tmp_reentrant_alloc (&__tmp_marker, (nn) * sizeof (mp_limb_t))));
      if (rp != np)
 do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (rp, np, nn); } while (0); } while (0);
      rn = tn + (rp[tn] = mpn_dc_sqrtrem (sp, rp, tn));
    }

  do { while ((rn) > 0) { if ((rp)[(rn) - 1] != 0) break; (rn)--; } } while (0);

  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
  return rn;
}

# 1005 "../gmp-impl.h"
mp_limb_t __gmpn_rsh1add_n (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);

# 1410 "../gmp-impl.h"
int __gmpn_fft_best_k (mp_size_t, int);

# 1413 "../gmp-impl.h"
mp_limb_t __gmpn_mul_fft (mp_ptr, mp_size_t, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t, int);

# 4664 "../gmp-impl.h"
mp_limb_t __gmpn_sub_nc (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t, mp_limb_t);

# 47 "mulmod_bnm1.c"
void
__gmpn_bc_mulmod_bnm1 (mp_ptr rp, mp_srcptr ap, mp_srcptr bp, mp_size_t rn,
      mp_ptr tp)
{
  mp_limb_t cy;

  do {} while (0);

  __gmpn_mul_n (tp, ap, bp, rn);
  cy = __gmpn_add_n (rp, tp, tp + rn, rn);
  /* If cy == 1, then the value of rp is at most B^rn - 2, so there can
   * be no overflow when adding in the carry. */
  do { mp_limb_t __x; mp_ptr __p = (rp); if (__builtin_constant_p (cy) && (cy) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (cy); *__p = __x; if (__x < (cy)) while (++(*(++__p)) == 0) ; } } while (0);
}

# 67 "mulmod_bnm1.c"
static void
mpn_bc_mulmod_bnp1 (mp_ptr rp, mp_srcptr ap, mp_srcptr bp, mp_size_t rn,
      mp_ptr tp)
{
  mp_limb_t cy;

  do {} while (0);

  __gmpn_mul_n (tp, ap, bp, rn + 1);
  do {} while (0);
  do {} while (0);
  cy = tp[2*rn] + __gmpn_sub_n (rp, tp, tp+rn, rn);
  rp[rn] = 0;
  do { mp_limb_t __x; mp_ptr __p = (rp); if (__builtin_constant_p (cy) && (cy) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (cy); *__p = __x; if (__x < (cy)) while (++(*(++__p)) == 0) ; } } while (0);
}

# 100 "mulmod_bnm1.c"
void
__gmpn_mulmod_bnm1 (mp_ptr rp, mp_size_t rn, mp_srcptr ap, mp_size_t an, mp_srcptr bp, mp_size_t bn, mp_ptr tp)
{
  do {} while (0);
  do {} while (0);
  do {} while (0);

  if ((rn & 1) != 0 || (! ((__builtin_constant_p (20) && (20) == 0) || (!(__builtin_constant_p (20) && (20) == 0x7fffffffL) && (rn) >= (20)))))
    {
      if (__builtin_expect ((bn < rn) != 0, 0))
 {
   if (__builtin_expect ((an + bn <= rn) != 0, 0))
     {
       __gmpn_mul (rp, ap, an, bp, bn);
     }
   else
     {
       mp_limb_t cy;
       __gmpn_mul (tp, ap, an, bp, bn);
       cy = __gmpn_add (rp, tp, rn, tp + rn, an + bn - rn);
       do { mp_limb_t __x; mp_ptr __p = (rp); if (__builtin_constant_p (cy) && (cy) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (cy); *__p = __x; if (__x < (cy)) while (++(*(++__p)) == 0) ; } } while (0);
     }
 }
      else
 __gmpn_bc_mulmod_bnm1 (rp, ap, bp, rn, tp);
    }
  else
    {
      mp_size_t n;
      mp_limb_t cy;
      mp_limb_t hi;

      n = rn >> 1;

      /* We need at least an + bn >= n, to be able to fit one of the
	 recursive products at rp. Requiring strict inequality makes
	 the coded slightly simpler. If desired, we could avoid this
	 restriction by initially halving rn as long as rn is even and
	 an + bn <= rn/2. */

      do {} while (0);

      /* Compute xm = a*b mod (B^n - 1), xp = a*b mod (B^n + 1)
	 and crt together as

	 x = -xp * B^n + (B^n + 1) * [ (xp + xm)/2 mod (B^n-1)]
      */







      /* am1  maybe in {xp, n} */
      /* bm1  maybe in {xp + n, n} */

      /* ap1  maybe in {sp1, n + 1} */
      /* bp1  maybe in {sp1 + n + 1, n + 1} */

      {
 mp_srcptr am1, bm1;
 mp_size_t anm, bnm;
 mp_ptr so;

 bm1 = bp;
 bnm = bn;
 if (__builtin_expect ((an > n) != 0, 1))
   {
     am1 = tp /* 2n + 2 */;
     cy = __gmpn_add (tp /* 2n + 2 */, ap, n, (ap + n), an - n);
     do { mp_limb_t __x; mp_ptr __p = (tp /* 2n + 2 */); if (__builtin_constant_p (cy) && (cy) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (cy); *__p = __x; if (__x < (cy)) while (++(*(++__p)) == 0) ; } } while (0);
     anm = n;
     so = tp /* 2n + 2 */ + n;
     if (__builtin_expect ((bn > n) != 0, 1))
       {
  bm1 = so;
  cy = __gmpn_add (so, bp, n, (bp + n), bn - n);
  do { mp_limb_t __x; mp_ptr __p = (so); if (__builtin_constant_p (cy) && (cy) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (cy); *__p = __x; if (__x < (cy)) while (++(*(++__p)) == 0) ; } } while (0);
  bnm = n;
  so += n;
       }
   }
 else
   {
     so = tp /* 2n + 2 */;
     am1 = ap;
     anm = an;
   }

 __gmpn_mulmod_bnm1 (rp, n, am1, anm, bm1, bnm, so);
      }

      {
 int k;
 mp_srcptr ap1, bp1;
 mp_size_t anp, bnp;

 bp1 = bp;
 bnp = bn;
 if (__builtin_expect ((an > n) != 0, 1)) {
   ap1 = (tp + 2*n + 2);
   cy = __gmpn_sub ((tp + 2*n + 2), ap, n, (ap + n), an - n);
   (tp + 2*n + 2)[n] = 0;
   do { mp_limb_t __x; mp_ptr __p = ((tp + 2*n + 2)); if (__builtin_constant_p (cy) && (cy) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (cy); *__p = __x; if (__x < (cy)) while (++(*(++__p)) == 0) ; } } while (0);
   anp = n + ap1[n];
   if (__builtin_expect ((bn > n) != 0, 1)) {
     bp1 = (tp + 2*n + 2) + n + 1;
     cy = __gmpn_sub ((tp + 2*n + 2) + n + 1, bp, n, (bp + n), bn - n);
     (tp + 2*n + 2)[2*n+1] = 0;
     do { mp_limb_t __x; mp_ptr __p = ((tp + 2*n + 2) + n + 1); if (__builtin_constant_p (cy) && (cy) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (cy); *__p = __x; if (__x < (cy)) while (++(*(++__p)) == 0) ; } } while (0);
     bnp = n + bp1[n];
   }
 } else {
   ap1 = ap;
   anp = an;
 }

 if ((! ((__builtin_constant_p (436 /* k = 5 */) && (436 /* k = 5 */) == 0) || (!(__builtin_constant_p (436 /* k = 5 */) && (436 /* k = 5 */) == 0x7fffffffL) && (n) >= (436 /* k = 5 */)))))
   k=0;
 else
   {
     int mask;
     k = __gmpn_fft_best_k (n, 0);
     mask = (1<<k) - 1;
     while (n & mask) {k--; mask >>=1;};
   }
 if (k >= 4)
   tp /* 2n + 2 */[n] = __gmpn_mul_fft (tp /* 2n + 2 */, n, ap1, anp, bp1, bnp, k);
 else if (__builtin_expect ((bp1 == bp) != 0, 0))
   {
     do {} while (0);
     do {} while (0);
     do {} while (0);
     __gmpn_mul (tp /* 2n + 2 */, ap1, anp, bp1, bnp);
     anp = anp + bnp - n;
     do {} while (0);
     anp-= anp > n;
     cy = __gmpn_sub (tp /* 2n + 2 */, tp /* 2n + 2 */, n, tp /* 2n + 2 */ + n, anp);
     tp /* 2n + 2 */[n] = 0;
     do { mp_limb_t __x; mp_ptr __p = (tp /* 2n + 2 */); if (__builtin_constant_p (cy) && (cy) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (cy); *__p = __x; if (__x < (cy)) while (++(*(++__p)) == 0) ; } } while (0);
   }
 else
   mpn_bc_mulmod_bnp1 (tp /* 2n + 2 */, ap1, bp1, n, tp /* 2n + 2 */);
      }

      /* Here the CRT recomposition begins.

	 xm <- (xp + xm)/2 = (xp + xm)B^n/2 mod (B^n-1)
	 Division by 2 is a bitwise rotation.

	 Assumes xp normalised mod (B^n+1).

	 The residue class [0] is represented by [B^n-1]; except when
	 both input are ZERO.
      */
# 265 "mulmod_bnm1.c"
      cy = tp /* 2n + 2 */[n] + __gmpn_rsh1add_n(rp, rp, tp /* 2n + 2 */, n); /* B^n = 1 */
      hi = (cy<<((32 - 0)-1))&((~ ((mp_limb_t) (0))) >> 0); /* (cy&1) << ... */
      cy >>= 1;
      /* cy = 1 only if xp[n] = 1 i.e. {xp,n} = ZERO, this implies that
	 the rsh1add was a simple rshift: the top bit is 0. cy=1 => hi=0. */


      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (cy), "=&r" (rp[n-1]) : "r" (cy), "rI" (0), "%r" (rp[n-1]), "rI" (hi) : "cc");
# 293 "mulmod_bnm1.c"
      do {} while (0);
      /* Next increment can not overflow, read the previous comments about cy. */
      do {} while (0);
      do { mp_limb_t __x; mp_ptr __p = (rp); if (__builtin_constant_p (cy) && (cy) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (cy); *__p = __x; if (__x < (cy)) while (++(*(++__p)) == 0) ; } } while (0);

      /* Compute the highest half:
	 ([(xp + xm)/2 mod (B^n-1)] - xp ) * B^n
       */
      if (__builtin_expect ((an + bn < rn) != 0, 0))
 {
   /* Note that in this case, the only way the result can equal
	     zero mod B^{rn} - 1 is if one of the inputs is zero, and
	     then the output of both the recursive calls and this CRT
	     reconstruction is zero, not B^{rn} - 1. Which is good,
	     since the latter representation doesn't fit in the output
	     area.*/
   cy = __gmpn_sub_n (rp + n, rp, tp /* 2n + 2 */, an + bn - n);

   /* FIXME: This subtraction of the high parts is not really
	     necessary, we do it to get the carry out, and for sanity
	     checking. */
   cy = tp /* 2n + 2 */[n] + __gmpn_sub_nc (tp /* 2n + 2 */ + an + bn - n, rp + an + bn - n,
       tp /* 2n + 2 */ + an + bn - n, rn - (an + bn), cy);
   do {} while (0)
                                                          ;
   cy = __gmpn_sub_1 (rp, rp, an + bn, cy);
   do {} while (0);
 }
      else
 {
   cy = tp /* 2n + 2 */[n] + __gmpn_sub_n (rp + n, rp, tp /* 2n + 2 */, n);
   /* cy = 1 only if {xp,n+1} is not ZERO, i.e. {rp,n} is not ZERO.
	     DECR will affect _at most_ the lowest n limbs. */
   do { mp_limb_t __x; mp_ptr __p = (rp); if (__builtin_constant_p (cy) && (cy) == 1) { while ((*(__p++))-- == 0) ; } else { __x = *__p; *__p = __x - (cy); if (__x < (cy)) while ((*(++__p))-- == 0) ; } } while (0);
 }






    }
}

# 41 "hgcd_appr.c"
mp_size_t
__gmpn_hgcd_appr_itch (mp_size_t n)
{
  if ((! ((__builtin_constant_p (400) && (400) == 0) || (!(__builtin_constant_p (400) && (400) == 0x7fffffffL) && (n) >= (400)))))
    return n;
  else
    {
      unsigned k;
      int count;
      mp_size_t nscaled;

      /* Get the recursion depth. */
      nscaled = (n - 1) / (400 - 1);
      __asm__ ("clz\t%0, %1" : "=r" (count) : "r" (nscaled));
      k = 32 - count;

      return 20 * ((n+3) / 4) + 22 * k + 197;
    }
}

# 47 "sqrmod_bnm1.c"
static void
mpn_bc_sqrmod_bnm1 (mp_ptr rp, mp_srcptr ap, mp_size_t rn, mp_ptr tp)
{
  mp_limb_t cy;

  do {} while (0);

  __gmpn_sqr (tp, ap, rn);
  cy = __gmpn_add_n (rp, tp, tp + rn, rn);
  /* If cy == 1, then the value of rp is at most B^rn - 2, so there can
   * be no overflow when adding in the carry. */
  do { mp_limb_t __x; mp_ptr __p = (rp); if (__builtin_constant_p (cy) && (cy) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (cy); *__p = __x; if (__x < (cy)) while (++(*(++__p)) == 0) ; } } while (0);
}

# 66 "sqrmod_bnm1.c"
static void
mpn_bc_sqrmod_bnp1 (mp_ptr rp, mp_srcptr ap, mp_size_t rn, mp_ptr tp)
{
  mp_limb_t cy;

  do {} while (0);

  __gmpn_sqr (tp, ap, rn + 1);
  do {} while (0);
  do {} while (0);
  cy = tp[2*rn] + __gmpn_sub_n (rp, tp, tp+rn, rn);
  rp[rn] = 0;
  do { mp_limb_t __x; mp_ptr __p = (rp); if (__builtin_constant_p (cy) && (cy) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (cy); *__p = __x; if (__x < (cy)) while (++(*(++__p)) == 0) ; } } while (0);
}

# 96 "sqrmod_bnm1.c"
void
__gmpn_sqrmod_bnm1 (mp_ptr rp, mp_size_t rn, mp_srcptr ap, mp_size_t an, mp_ptr tp)
{
  do {} while (0);
  do {} while (0);

  if ((rn & 1) != 0 || (! ((__builtin_constant_p (26) && (26) == 0) || (!(__builtin_constant_p (26) && (26) == 0x7fffffffL) && (rn) >= (26)))))
    {
      if (__builtin_expect ((an < rn) != 0, 0))
 {
   if (__builtin_expect ((2*an <= rn) != 0, 0))
     {
       __gmpn_sqr (rp, ap, an);
     }
   else
     {
       mp_limb_t cy;
       __gmpn_sqr (tp, ap, an);
       cy = __gmpn_add (rp, tp, rn, tp + rn, 2*an - rn);
       do { mp_limb_t __x; mp_ptr __p = (rp); if (__builtin_constant_p (cy) && (cy) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (cy); *__p = __x; if (__x < (cy)) while (++(*(++__p)) == 0) ; } } while (0);
     }
 }
      else
 mpn_bc_sqrmod_bnm1 (rp, ap, rn, tp);
    }
  else
    {
      mp_size_t n;
      mp_limb_t cy;
      mp_limb_t hi;

      n = rn >> 1;

      do {} while (0);

      /* Compute xm = a^2 mod (B^n - 1), xp = a^2 mod (B^n + 1)
	 and crt together as

	 x = -xp * B^n + (B^n + 1) * [ (xp + xm)/2 mod (B^n-1)]
      */





      /* am1  maybe in {xp, n} */

      /* ap1  maybe in {sp1, n + 1} */

      {
 mp_srcptr am1;
 mp_size_t anm;
 mp_ptr so;

 if (__builtin_expect ((an > n) != 0, 1))
   {
     so = tp /* 2n + 2 */ + n;
     am1 = tp /* 2n + 2 */;
     cy = __gmpn_add (tp /* 2n + 2 */, ap, n, (ap + n), an - n);
     do { mp_limb_t __x; mp_ptr __p = (tp /* 2n + 2 */); if (__builtin_constant_p (cy) && (cy) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (cy); *__p = __x; if (__x < (cy)) while (++(*(++__p)) == 0) ; } } while (0);
     anm = n;
   }
 else
   {
     so = tp /* 2n + 2 */;
     am1 = ap;
     anm = an;
   }

 __gmpn_sqrmod_bnm1 (rp, n, am1, anm, so);
      }

      {
 int k;
 mp_srcptr ap1;
 mp_size_t anp;

 if (__builtin_expect ((an > n) != 0, 1)) {
   ap1 = (tp + 2*n + 2);
   cy = __gmpn_sub ((tp + 2*n + 2), ap, n, (ap + n), an - n);
   (tp + 2*n + 2)[n] = 0;
   do { mp_limb_t __x; mp_ptr __p = ((tp + 2*n + 2)); if (__builtin_constant_p (cy) && (cy) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (cy); *__p = __x; if (__x < (cy)) while (++(*(++__p)) == 0) ; } } while (0);
   anp = n + ap1[n];
 } else {
   ap1 = ap;
   anp = an;
 }

 if ((! ((__builtin_constant_p (436 /* k = 5 */) && (436 /* k = 5 */) == 0) || (!(__builtin_constant_p (436 /* k = 5 */) && (436 /* k = 5 */) == 0x7fffffffL) && (n) >= (436 /* k = 5 */)))))
   k=0;
 else
   {
     int mask;
     k = __gmpn_fft_best_k (n, 1);
     mask = (1<<k) -1;
     while (n & mask) {k--; mask >>=1;};
   }
 if (k >= 4)
   tp /* 2n + 2 */[n] = __gmpn_mul_fft (tp /* 2n + 2 */, n, ap1, anp, ap1, anp, k);
 else if (__builtin_expect ((ap1 == ap) != 0, 0))
   {
     do {} while (0);
     do {} while (0);
     __gmpn_sqr (tp /* 2n + 2 */, ap, an);
     anp = 2*an - n;
     cy = __gmpn_sub (tp /* 2n + 2 */, tp /* 2n + 2 */, n, tp /* 2n + 2 */ + n, anp);
     tp /* 2n + 2 */[n] = 0;
     do { mp_limb_t __x; mp_ptr __p = (tp /* 2n + 2 */); if (__builtin_constant_p (cy) && (cy) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (cy); *__p = __x; if (__x < (cy)) while (++(*(++__p)) == 0) ; } } while (0);
   }
 else
   mpn_bc_sqrmod_bnp1 (tp /* 2n + 2 */, ap1, n, tp /* 2n + 2 */);
      }

      /* Here the CRT recomposition begins.

	 xm <- (xp + xm)/2 = (xp + xm)B^n/2 mod (B^n-1)
	 Division by 2 is a bitwise rotation.

	 Assumes xp normalised mod (B^n+1).

	 The residue class [0] is represented by [B^n-1]; except when
	 both input are ZERO.
      */
# 228 "sqrmod_bnm1.c"
      cy = tp /* 2n + 2 */[n] + __gmpn_rsh1add_n(rp, rp, tp /* 2n + 2 */, n); /* B^n = 1 */
      hi = (cy<<((32 - 0)-1))&((~ ((mp_limb_t) (0))) >> 0); /* (cy&1) << ... */
      cy >>= 1;
      /* cy = 1 only if xp[n] = 1 i.e. {xp,n} = ZERO, this implies that
	 the rsh1add was a simple rshift: the top bit is 0. cy=1 => hi=0. */


      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (cy), "=&r" (rp[n-1]) : "r" (cy), "rI" (((mp_limb_t) 0L)), "%r" (rp[n-1]), "rI" (hi) : "cc");
# 256 "sqrmod_bnm1.c"
      do {} while (0);
      /* Next increment can not overflow, read the previous comments about cy. */
      do {} while (0);
      do { mp_limb_t __x; mp_ptr __p = (rp); if (__builtin_constant_p (cy) && (cy) == 1) { while (++(*(__p++)) == 0) ; } else { __x = *__p + (cy); *__p = __x; if (__x < (cy)) while (++(*(++__p)) == 0) ; } } while (0);

      /* Compute the highest half:
	 ([(xp + xm)/2 mod (B^n-1)] - xp ) * B^n
       */
      if (__builtin_expect ((2*an < rn) != 0, 0))
 {
   /* Note that in this case, the only way the result can equal
	     zero mod B^{rn} - 1 is if the input is zero, and
	     then the output of both the recursive calls and this CRT
	     reconstruction is zero, not B^{rn} - 1. */
   cy = __gmpn_sub_n (rp + n, rp, tp /* 2n + 2 */, 2*an - n);

   /* FIXME: This subtraction of the high parts is not really
	     necessary, we do it to get the carry out, and for sanity
	     checking. */
   cy = tp /* 2n + 2 */[n] + __gmpn_sub_nc (tp /* 2n + 2 */ + 2*an - n, rp + 2*an - n,
       tp /* 2n + 2 */ + 2*an - n, rn - 2*an, cy);
   do {} while (0);
   cy = __gmpn_sub_1 (rp, rp, 2*an, cy);
   do {} while (0);
 }
      else
 {
   cy = tp /* 2n + 2 */[n] + __gmpn_sub_n (rp + n, rp, tp /* 2n + 2 */, n);
   /* cy = 1 only if {xp,n+1} is not ZERO, i.e. {rp,n} is not ZERO.
	     DECR will affect _at most_ the lowest n limbs. */
   do { mp_limb_t __x; mp_ptr __p = (rp); if (__builtin_constant_p (cy) && (cy) == 1) { while ((*(__p++))-- == 0) ; } else { __x = *__p; *__p = __x - (cy); if (__x < (cy)) while ((*(++__p))-- == 0) ; } } while (0);
 }




    }
}

# 44 "mod_1_2.c"
void
__gmpn_mod_1s_2p_cps (mp_limb_t cps[5], mp_limb_t b)
{
  mp_limb_t bi;
  mp_limb_t B1modb, B2modb, B3modb;
  int cnt;

  do {} while (0);

  __asm__ ("clz\t%0, %1" : "=r" (cnt) : "r" (b));

  b <<= cnt;
  do { (bi) = __gmpn_invert_limb (b); } while (0);

  cps[0] = bi;
  cps[1] = cnt;

  B1modb = -b * ((bi >> (32 -cnt)) | (((mp_limb_t) 1L) << cnt));
  do {} while (0); /* NB: not fully reduced mod b */
  cps[2] = B1modb >> cnt;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((B1modb)), "r" ((bi))); if (__builtin_constant_p (((mp_limb_t) 0L)) && (((mp_limb_t) 0L)) == 0) { _r = ~(_qh + (B1modb)) * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((B1modb) + 1), "%r" (_ql), "rI" ((((mp_limb_t) 0L))) : "cc"); _r = (((mp_limb_t) 0L)) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (B2modb) = _r; } while (0);
  cps[3] = B2modb >> cnt;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((B2modb)), "r" ((bi))); if (__builtin_constant_p (((mp_limb_t) 0L)) && (((mp_limb_t) 0L)) == 0) { _r = ~(_qh + (B2modb)) * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((B2modb) + 1), "%r" (_ql), "rI" ((((mp_limb_t) 0L))) : "cc"); _r = (((mp_limb_t) 0L)) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (B3modb) = _r; } while (0);
  cps[4] = B3modb >> cnt;
# 82 "mod_1_2.c"
}

# 84 "mod_1_2.c"
mp_limb_t
__gmpn_mod_1s_2p (mp_srcptr ap, mp_size_t n, mp_limb_t b, const mp_limb_t cps[5])
{
  mp_limb_t rh, rl, bi, ph, pl, ch, cl, r;
  mp_limb_t B1modb, B2modb, B3modb;
  mp_size_t i;
  int cnt;

  do {} while (0);

  B1modb = cps[2];
  B2modb = cps[3];
  B3modb = cps[4];

  if ((n & 1) != 0)
    {
      if (n == 1)
 {
   rl = ap[n - 1];
   bi = cps[0];
   cnt = cps[1];
   do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((rl >> (32 - cnt))), "r" ((bi))); if (__builtin_constant_p (rl << cnt) && (rl << cnt) == 0) { _r = ~(_qh + (rl >> (32 - cnt))) * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((rl >> (32 - cnt)) + 1), "%r" (_ql), "rI" ((rl << cnt)) : "cc"); _r = (rl << cnt) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (r) = _r; } while (0)
                         ;
   return r >> cnt;
 }

      __asm__ ("umull %0,%1,%2,%3" : "=&r" (pl), "=&r" (ph) : "r" (ap[n - 2]), "r" (B1modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (ph), "=&r" (pl) : "r" (ph), "rI" (((mp_limb_t) 0L)), "%r" (pl), "rI" (ap[n - 3]) : "cc");
      __asm__ ("umull %0,%1,%2,%3" : "=&r" (rl), "=&r" (rh) : "r" (ap[n - 1]), "r" (B2modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (rh), "=&r" (rl) : "r" (rh), "rI" (ph), "%r" (rl), "rI" (pl) : "cc");
      n--;
    }
  else
    {
      rh = ap[n - 1];
      rl = ap[n - 2];
    }

  for (i = n - 4; i >= 0; i -= 2)
    {
      /* rr = ap[i]				< B
	    + ap[i+1] * (B mod b)		<= (B-1)(b-1)
	    + LO(rr)  * (B^2 mod b)		<= (B-1)(b-1)
	    + HI(rr)  * (B^3 mod b)		<= (B-1)(b-1)
      */
      __asm__ ("umull %0,%1,%2,%3" : "=&r" (pl), "=&r" (ph) : "r" (ap[i + 1]), "r" (B1modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (ph), "=&r" (pl) : "r" (ph), "rI" (((mp_limb_t) 0L)), "%r" (pl), "rI" (ap[i + 0]) : "cc");

      __asm__ ("umull %0,%1,%2,%3" : "=&r" (cl), "=&r" (ch) : "r" (rl), "r" (B2modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (ph), "=&r" (pl) : "r" (ph), "rI" (ch), "%r" (pl), "rI" (cl) : "cc");

      __asm__ ("umull %0,%1,%2,%3" : "=&r" (rl), "=&r" (rh) : "r" (rh), "r" (B3modb));
      __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (rh), "=&r" (rl) : "r" (rh), "rI" (ph), "%r" (rl), "rI" (pl) : "cc");
    }

  __asm__ ("umull %0,%1,%2,%3" : "=&r" (cl), "=&r" (rh) : "r" (rh), "r" (B1modb));
  __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (rh), "=&r" (rl) : "r" (rh), "rI" (((mp_limb_t) 0L)), "%r" (rl), "rI" (cl) : "cc");

  cnt = cps[1];
  bi = cps[0];

  r = (rh << cnt) | (rl >> (32 - cnt));
  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("umull %0,%1,%2,%3" : "=&r" (_ql), "=&r" (_qh) : "r" ((r)), "r" ((bi))); if (__builtin_constant_p (rl << cnt) && (rl << cnt) == 0) { _r = ~(_qh + (r)) * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); } else { __asm__ ("adds\t%1, %4, %5\n\tadc\t%0, %2, %3" : "=r" (_qh), "=&r" (_ql) : "r" (_qh), "rI" ((r) + 1), "%r" (_ql), "rI" ((rl << cnt)) : "cc"); _r = (rl << cnt) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */ _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (r) = _r; } while (0);

  return r >> cnt;
}

