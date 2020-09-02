unsigned int __builtin_object_size (const void *, int);
void * __builtin___memset_chk (void *, int, unsigned int, unsigned int);

# 86 "../../include/types.h"
typedef unsigned int u32;

# 27 "../../cipher/bithelp.h"
static inline u32
rol( u32 x, int n)
{
 __asm__("roll %%cl,%0"
  :"=r" (x)
  :"0" (x),"c" (n));
 return x;
}

# 51 "../../include/mpi.h"
typedef struct gcry_mpi *MPI;

# 93 "../../include/mpi.h"
unsigned int mpi_get_flags (MPI a);

# 36 "../../mpi/mpi-internal.h"
typedef unsigned int mpi_limb_t;

# 53 "../../mpi/mpi-internal.h"
struct gcry_mpi {
    int alloced; /* array size (# of allocated limbs) */
    int nlimbs; /* number of valid limbs */
    unsigned int nbits; /* the real number of valid bits (info only) */
    int sign; /* indicates a negative number */
    unsigned flags; /* bit 0: array must be allocated in secure memory space */
      /* bit 1: not used */
      /* bit 2: the limb is a pointer to some xmalloced data */
    mpi_limb_t *d; /* array with the limbs */
};

# 277 "../../mpi/mpi-internal.h"
typedef unsigned int USItype;

# 54 "../../mpi/mpi-bit.c"
void
mpi_normalize( MPI a )
{
    if( ((a) && (mpi_get_flags (a)&4)) )
 return;

    for( ; a->nlimbs && !a->d[a->nlimbs-1]; a->nlimbs-- )
 ;
}

# 69 "../../mpi/mpi-bit.c"
unsigned
mpi_get_nbits( MPI a )
{
    unsigned n;

    mpi_normalize( a );
    if( a->nlimbs ) {
 mpi_limb_t alimb = a->d[a->nlimbs-1];
 if( alimb )
     do { USItype __cbtmp; __asm__ ("bsrl %1,%0" : "=r" (__cbtmp) : "rm" ((USItype)(alimb))); (n) = __cbtmp ^ 31; } while (0);
 else
     n = (8*(4));
 n = (8*(4)) - n + (a->nlimbs-1) * (8*(4));
    }
    else
 n = 0;
    return n;
}

# 118 "../../mpi/mpi-scan.c"
unsigned int
mpi_trailing_zeros( MPI a )
{
    unsigned n, count = 0;

    for(n=0; n < a->nlimbs; n++ ) {
 if( a->d[n] ) {
     unsigned nn;
     mpi_limb_t alimb = a->d[n];

     __asm__ ("bsfl %1,%0" : "=r" (nn) : "rm" ((USItype)(alimb)));
     count += nn;
     break;
 }
 count += (8*(4));
    }
    return count;

}

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

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

# 74 "../../include/mpi.h"
void mpi_resize( MPI a, unsigned nlimbs );

# 84 "../../include/mpi.h"
void mpi_set_cond( MPI w, MPI u, unsigned long set);

# 83 "../../mpi/mpi-internal.h"
typedef mpi_limb_t *mpi_ptr_t;

# 84 "../../mpi/mpi-internal.h"
typedef int mpi_size_t;

# 190 "../../mpi/mpi-internal.h"
mpi_ptr_t mpi_alloc_limb_space( unsigned nlimbs, int sec );

# 191 "../../mpi/mpi-internal.h"
void mpi_free_limb_space( mpi_ptr_t a );

# 211 "../../mpi/mpi-internal.h"
mpi_limb_t mpihelp_sub_n( mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
     mpi_ptr_t s2_ptr, mpi_size_t size);

# 221 "../../mpi/mpi-internal.h"
struct karatsuba_ctx {
    struct karatsuba_ctx *next;
    mpi_ptr_t tspace;
    mpi_size_t tspace_size;
    mpi_ptr_t tp;
    mpi_size_t tp_size;
};

# 229 "../../mpi/mpi-internal.h"
void mpihelp_release_karatsuba_ctx( struct karatsuba_ctx *ctx );

# 237 "../../mpi/mpi-internal.h"
mpi_limb_t mpihelp_mul( mpi_ptr_t prodp, mpi_ptr_t up, mpi_size_t usize,
      mpi_ptr_t vp, mpi_size_t vsize);

# 243 "../../mpi/mpi-internal.h"
void mpihelp_mul_karatsuba_case( mpi_ptr_t prodp,
     mpi_ptr_t up, mpi_size_t usize,
     mpi_ptr_t vp, mpi_size_t vsize,
     struct karatsuba_ctx *ctx );

# 256 "../../mpi/mpi-internal.h"
mpi_limb_t mpihelp_divrem( mpi_ptr_t qp, mpi_size_t qextra_limbs,
      mpi_ptr_t np, mpi_size_t nsize,
      mpi_ptr_t dp, mpi_size_t dsize);

# 264 "../../mpi/mpi-internal.h"
mpi_limb_t mpihelp_lshift( mpi_ptr_t wp, mpi_ptr_t up, mpi_size_t usize,
          unsigned cnt);

# 266 "../../mpi/mpi-internal.h"
mpi_limb_t mpihelp_rshift( mpi_ptr_t wp, mpi_ptr_t up, mpi_size_t usize,
          unsigned cnt);

# 88 "../../mpi/mpi-inline.h"
extern __inline__ mpi_limb_t
mpihelp_sub_1(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
       mpi_size_t s1_size, mpi_limb_t s2_limb )
{
    mpi_limb_t x;

    x = *s1_ptr++;
    s2_limb = x - s2_limb;
    *res_ptr++ = s2_limb;
    if( s2_limb > x ) {
 while( --s1_size ) {
     x = *s1_ptr++;
     *res_ptr++ = x - 1;
     if( x )
  goto leave;
 }
 return 1;
    }

  leave:
    if( res_ptr != s1_ptr ) {
 mpi_size_t i;
 for( i=0; i < s1_size-1; i++ )
     res_ptr[i] = s1_ptr[i];
    }
    return 0;
}

# 118 "../../mpi/mpi-inline.h"
extern __inline__ mpi_limb_t
mpihelp_sub( mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr, mpi_size_t s1_size,
    mpi_ptr_t s2_ptr, mpi_size_t s2_size)
{
    mpi_limb_t cy = 0;

    if( s2_size )
 cy = mpihelp_sub_n(res_ptr, s1_ptr, s2_ptr, s2_size);

    if( s1_size - s2_size )
 cy = mpihelp_sub_1(res_ptr + s2_size, s1_ptr + s2_size,
          s1_size - s2_size, cy);
    return cy;
}

# 69 "/usr/include/assert.h"
extern void __assert_fail (const char *__assertion, const char *__file,
      unsigned int __line, const char *__function);

# 326 "../../mpi/mpi-pow.c"
static void
mul_mod (mpi_ptr_t xp, mpi_size_t *xsize_p,
         mpi_ptr_t rp, mpi_size_t rsize,
         mpi_ptr_t sp, mpi_size_t ssize,
         mpi_ptr_t mp, mpi_size_t msize,
         struct karatsuba_ctx *karactx_p)
{
  if( ssize < 16 )
    mpihelp_mul ( xp, rp, rsize, sp, ssize );
  else
    mpihelp_mul_karatsuba_case (xp, rp, rsize, sp, ssize, karactx_p);

   if (rsize + ssize > msize)
    {
      mpihelp_divrem (xp + msize, 0, xp, rsize + ssize, mp, msize);
      *xsize_p = msize;
    }
   else
     *xsize_p = rsize + ssize;
}

# 360 "../../mpi/mpi-pow.c"
void
mpi_powm (MPI res, MPI base, MPI expo, MPI mod)
{
  /* Pointer to the limbs of the arguments, their size and signs. */
  mpi_ptr_t rp, ep, mp, bp;
  mpi_size_t esize, msize, bsize, rsize;
  int msign, bsign, rsign;
  /* Flags telling the secure allocation status of the arguments.  */
  int esec, msec, bsec;
  /* Size of the result including space for temporary values.  */
  mpi_size_t size;
  /* Helper.  */
  int mod_shift_cnt;
  int negative_result;
  mpi_ptr_t mp_marker = ((void *)0);
  mpi_ptr_t bp_marker = ((void *)0);
  mpi_ptr_t ep_marker = ((void *)0);
  mpi_ptr_t xp_marker = ((void *)0);
  mpi_ptr_t precomp[((1 << (5 - 1)))]; /* Pre-computed array: BASE^1, ^3, ^5, ... */
  mpi_size_t precomp_size[((1 << (5 - 1)))];
  mpi_size_t W;
  mpi_ptr_t base_u;
  mpi_size_t base_u_size;
  mpi_size_t max_u_size;

  esize = expo->nlimbs;
  msize = mod->nlimbs;
  size = 2 * msize;
  msign = mod->sign;

  ep = expo->d;
  do { while( (esize) > 0 ) { if( (ep)[(esize)-1] ) break; (esize)--; } } while(0);

  if (esize * (8*(4)) > 512)
    W = 5;
  else if (esize * (8*(4)) > 256)
    W = 4;
  else if (esize * (8*(4)) > 128)
    W = 3;
  else if (esize * (8*(4)) > 64)
    W = 2;
  else
    W = 1;

  esec = ((expo) && (mpi_get_flags (expo)&1));
  msec = ((mod) && (mpi_get_flags (mod)&1));
  bsec = ((base) && (mpi_get_flags (base)&1));

  rp = res->d;

  if (!msize)
    msize = 1 / msize; /* provoke a signal */

  if (!esize)
    {
      /* Exponent is zero, result is 1 mod MOD, i.e., 1 or 0 depending
         on if MOD equals 1.  */
      res->nlimbs = (msize == 1 && mod->d[0] == 1) ? 0 : 1;
      if (res->nlimbs)
        {
          do { if( (res)->alloced < (1) ) mpi_resize((res), (1)); } while(0);
          rp = res->d;
          rp[0] = 1;
        }
      res->sign = 0;
      goto leave;
    }

  /* Normalize MOD (i.e. make its most significant bit set) as
     required by mpn_divrem.  This will make the intermediate values
     in the calculation slightly larger, but the correct result is
     obtained after a final reduction using the original MOD value. */
  mp = mp_marker = mpi_alloc_limb_space(msize, msec);
  do { USItype __cbtmp; __asm__ ("bsrl %1,%0" : "=r" (__cbtmp) : "rm" ((USItype)(mod->d[msize-1]))); (mod_shift_cnt) = __cbtmp ^ 31; } while (0);
  if (mod_shift_cnt)
    mpihelp_lshift (mp, mod->d, msize, mod_shift_cnt);
  else
    do { mpi_size_t _i; for( _i = 0; _i < (msize); _i++ ) (mp)[_i] = (mod->d)[_i]; } while(0);

  bsize = base->nlimbs;
  bsign = base->sign;
  if (bsize > msize)
    {
      /* The base is larger than the module.  Reduce it.

         Allocate (BSIZE + 1) with space for remainder and quotient.
         (The quotient is (bsize - msize + 1) limbs.)  */
      bp = bp_marker = mpi_alloc_limb_space( bsize + 1, bsec );
      do { mpi_size_t _i; for( _i = 0; _i < (bsize); _i++ ) (bp)[_i] = (base->d)[_i]; } while(0);
      /* We don't care about the quotient, store it above the
       * remainder, at BP + MSIZE.  */
      mpihelp_divrem( bp + msize, 0, bp, bsize, mp, msize );
      bsize = msize;
      /* Canonicalize the base, since we are going to multiply with it
         quite a few times.  */
      do { while( (bsize) > 0 ) { if( (bp)[(bsize)-1] ) break; (bsize)--; } } while(0);
    }
  else
    bp = base->d;

  if (!bsize)
    {
      res->nlimbs = 0;
      res->sign = 0;
      goto leave;
    }


  /* Make BASE, EXPO not overlap with RES.  We don't need to check MOD
     because that has already been copied to the MP var.  */
  if ( rp == bp )
    {
      /* RES and BASE are identical.  Allocate temp. space for BASE.  */
      ((!bp_marker) ? (void) (0) : __assert_fail ("!bp_marker", "../../mpi/mpi-pow.c", 473, __PRETTY_FUNCTION__));
      bp = bp_marker = mpi_alloc_limb_space( bsize, bsec );
      do { mpi_size_t _i; for( _i = 0; _i < (bsize); _i++ ) (bp)[_i] = (rp)[_i]; } while(0);
    }
  if ( rp == ep )
    {
      /* RES and EXPO are identical.  Allocate temp. space for EXPO.  */
      ep = ep_marker = mpi_alloc_limb_space( esize, esec );
      do { mpi_size_t _i; for( _i = 0; _i < (esize); _i++ ) (ep)[_i] = (rp)[_i]; } while(0);
    }

  /* Copy base to the result.  */
  if (res->alloced < size)
    {
      mpi_resize (res, size);
      rp = res->d;
    }

  /* Main processing.  */
  {
    mpi_size_t i, j, k;
    mpi_ptr_t xp;
    mpi_size_t xsize;
    int c;
    mpi_limb_t e;
    mpi_limb_t carry_limb;
    struct karatsuba_ctx karactx;
    mpi_ptr_t tp;

    xp = xp_marker = mpi_alloc_limb_space( size, msec );

    memset( &karactx, 0, sizeof karactx );
    negative_result = (ep[0] & 1) && bsign;

    /* Precompute PRECOMP[], BASE^(2 * i + 1), BASE^1, ^3, ^5, ... */
    if (W > 1) /* X := BASE^2 */
      mul_mod (xp, &xsize, bp, bsize, bp, bsize, mp, msize, &karactx);
    base_u = precomp[0] = mpi_alloc_limb_space (bsize, esec);
    base_u_size = max_u_size = precomp_size[0] = bsize;
    do { mpi_size_t _i; for( _i = 0; _i < (bsize); _i++ ) (precomp[0])[_i] = (bp)[_i]; } while(0);
    for (i = 1; i < (1 << (W - 1)); i++)
      { /* PRECOMP[i] = BASE^(2 * i + 1) */
        if (xsize >= base_u_size)
          mul_mod (rp, &rsize, xp, xsize, base_u, base_u_size,
                   mp, msize, &karactx);
        else
          mul_mod (rp, &rsize, base_u, base_u_size, xp, xsize,
                   mp, msize, &karactx);
        base_u = precomp[i] = mpi_alloc_limb_space (rsize, esec);
        base_u_size = precomp_size[i] = rsize;
        if (max_u_size < base_u_size)
          max_u_size = base_u_size;
        do { mpi_size_t _i; for( _i = 0; _i < (rsize); _i++ ) (precomp[i])[_i] = (rp)[_i]; } while(0);
      }

    if (msize > max_u_size)
      max_u_size = msize;
    base_u = mpi_alloc_limb_space (max_u_size, esec);
    do { int _i; for( _i = 0; _i < (max_u_size); _i++ ) (base_u)[_i] = 0; } while (0);

    i = esize - 1;

    /* Main loop.

       Make the result be pointed to alternately by XP and RP.  This
       helps us avoid block copying, which would otherwise be
       necessary with the overlap restrictions of mpihelp_divmod. With
       50% probability the result after this loop will be in the area
       originally pointed by RP (==RES->d), and with 50% probability
       in the area originally pointed to by XP. */
    rsign = 0;
    if (W == 1)
      {
        rsize = bsize;
      }
    else
      {
        rsize = msize;
        do { int _i; for( _i = 0; _i < (rsize); _i++ ) (rp)[_i] = 0; } while (0);
      }
    do { mpi_size_t _i; for( _i = 0; _i < (bsize); _i++ ) (rp)[_i] = (bp)[_i]; } while(0);

    e = ep[i];
    do { USItype __cbtmp; __asm__ ("bsrl %1,%0" : "=r" (__cbtmp) : "rm" ((USItype)(e))); (c) = __cbtmp ^ 31; } while (0);
    e = (e << c) << 1;
    c = (8*(4)) - 1 - c;

    j = 0;

    for (;;)
      if (e == 0)
        {
          j += c;
          if ( --i < 0 )
            break;

          e = ep[i];
          c = (8*(4));
        }
      else
        {
          int c0;
          mpi_limb_t e0;
          struct gcry_mpi w, u;
          w.sign = u.sign = 0;
          w.flags = u.flags = 0;
          w.d = base_u;

          do { USItype __cbtmp; __asm__ ("bsrl %1,%0" : "=r" (__cbtmp) : "rm" ((USItype)(e))); (c0) = __cbtmp ^ 31; } while (0);
          e = (e << c0);
          c -= c0;
          j += c0;

          e0 = (e >> ((8*(4)) - W));
          if (c >= W)
            c0 = 0;
          else
            {
              if ( --i < 0 )
                {
                  e0 = (e >> ((8*(4)) - c));
                  j += c - W;
                  goto last_step;
                }
              else
                {
                  c0 = c;
                  e = ep[i];
                  c = (8*(4));
                  e0 |= (e >> ((8*(4)) - (W - c0)));
  }
            }

          e = e << (W - c0);
          c -= (W - c0);

        last_step:
          __asm__ ("bsfl %1,%0" : "=r" (c0) : "rm" ((USItype)(e0)));
          e0 = (e0 >> c0) >> 1;

          for (j += W - c0; j >= 0; j--)
            {

              /*
               *  base_u <= precomp[e0]
               *  base_u_size <= precomp_size[e0]
               */
              base_u_size = 0;
              for (k = 0; k < (1<< (W - 1)); k++)
                {
                  w.alloced = w.nlimbs = precomp_size[k];
                  u.alloced = u.nlimbs = precomp_size[k];
                  u.d = precomp[k];

                  mpi_set_cond (&w, &u, k == e0);
                  base_u_size |= ( precomp_size[k] & (0UL - (k == e0)) );
                }

              w.alloced = w.nlimbs = rsize;
              u.alloced = u.nlimbs = rsize;
              u.d = rp;
              mpi_set_cond (&w, &u, j != 0);
              base_u_size ^= ((base_u_size ^ rsize) & (0UL - (j != 0)));

              mul_mod (xp, &xsize, rp, rsize, base_u, base_u_size,
                       mp, msize, &karactx);
              tp = rp; rp = xp; xp = tp;
              rsize = xsize;
            }

          j = c0;
          if ( i < 0 )
            break;
        }

    while (j--)
      {
        mul_mod (xp, &xsize, rp, rsize, rp, rsize, mp, msize, &karactx);
        tp = rp; rp = xp; xp = tp;
        rsize = xsize;
      }

    /* We shifted MOD, the modulo reduction argument, left
       MOD_SHIFT_CNT steps.  Adjust the result by reducing it with the
       original MOD.

       Also make sure the result is put in RES->d (where it already
       might be, see above).  */
    if ( mod_shift_cnt )
      {
        carry_limb = mpihelp_lshift( res->d, rp, rsize, mod_shift_cnt);
        rp = res->d;
        if ( carry_limb )
          {
            rp[rsize] = carry_limb;
            rsize++;
          }
      }
    else if (res->d != rp)
      {
        do { mpi_size_t _i; for( _i = 0; _i < (rsize); _i++ ) (res->d)[_i] = (rp)[_i]; } while(0);
        rp = res->d;
      }

    if ( rsize >= msize )
      {
        mpihelp_divrem(rp + msize, 0, rp, rsize, mp, msize);
        rsize = msize;
      }

    /* Remove any leading zero words from the result.  */
    if ( mod_shift_cnt )
      mpihelp_rshift (rp, rp, rsize, mod_shift_cnt);
    do { while( (rsize) > 0 ) { if( (rp)[(rsize)-1] ) break; (rsize)--; } } while(0);

    mpihelp_release_karatsuba_ctx (&karactx );
    for (i = 0; i < (1 << (W - 1)); i++)
      mpi_free_limb_space (precomp[i]);
    mpi_free_limb_space (base_u);
  }

  /* Fixup for negative results.  */
  if ( negative_result && rsize )
    {
      if ( mod_shift_cnt )
        mpihelp_rshift (mp, mp, msize, mod_shift_cnt);
      mpihelp_sub (rp, mp, msize, rp, rsize);
      rsize = msize;
      rsign = msign;
      do { while( (rsize) > 0 ) { if( (rp)[(rsize)-1] ) break; (rsize)--; } } while(0);
    }
  ((res->d == rp) ? (void) (0) : __assert_fail ("res->d == rp", "../../mpi/mpi-pow.c", 704, __PRETTY_FUNCTION__));
  res->nlimbs = rsize;
  res->sign = rsign;

 leave:
  if (mp_marker)
    mpi_free_limb_space (mp_marker);
  if (bp_marker)
    mpi_free_limb_space (bp_marker);
  if (ep_marker)
    mpi_free_limb_space (ep_marker);
  if (xp_marker)
    mpi_free_limb_space (xp_marker);
}

# 254 "../../mpi/mpi-internal.h"
mpi_limb_t mpihelp_mod_1(mpi_ptr_t dividend_ptr, mpi_size_t dividend_size,
       mpi_limb_t divisor_limb);

# 259 "../../mpi/mpi-internal.h"
mpi_limb_t mpihelp_divmod_1( mpi_ptr_t quot_ptr,
        mpi_ptr_t dividend_ptr, mpi_size_t dividend_size,
        mpi_limb_t divisor_limb);

# 129 "../../mpi/mpi-div.c"
void
mpi_tdiv_qr( MPI quot, MPI rem, MPI num, MPI den)
{
    mpi_ptr_t np, dp;
    mpi_ptr_t qp, rp;
    mpi_size_t nsize = num->nlimbs;
    mpi_size_t dsize = den->nlimbs;
    mpi_size_t qsize, rsize;
    mpi_size_t sign_remainder = num->sign;
    mpi_size_t sign_quotient = num->sign ^ den->sign;
    unsigned normalization_steps;
    mpi_limb_t q_limb;
    mpi_ptr_t marker[5];
    int markidx=0;

    /* Ensure space is enough for quotient and remainder.
     * We need space for an extra limb in the remainder, because it's
     * up-shifted (normalized) below.  */
    rsize = nsize + 1;
    mpi_resize( rem, rsize);

    qsize = rsize - dsize; /* qsize cannot be bigger than this.	*/
    if( qsize <= 0 ) {
 if( num != rem ) {
     rem->nlimbs = num->nlimbs;
     rem->sign = num->sign;
     do { mpi_size_t _i; for( _i = 0; _i < (nsize); _i++ ) (rem->d)[_i] = (num->d)[_i]; } while(0);
 }
 if( quot ) {
     /* This needs to follow the assignment to rem, in case the
	     * numerator and quotient are the same.  */
     quot->nlimbs = 0;
     quot->sign = 0;
 }
 return;
    }

    if( quot )
 mpi_resize( quot, qsize);

    /* Read pointers here, when reallocation is finished.  */
    np = num->d;
    dp = den->d;
    rp = rem->d;

    /* Optimize division by a single-limb divisor.  */
    if( dsize == 1 ) {
 mpi_limb_t rlimb;
 if( quot ) {
     qp = quot->d;
     rlimb = mpihelp_divmod_1( qp, np, nsize, dp[0] );
     qsize -= qp[qsize - 1] == 0;
     quot->nlimbs = qsize;
     quot->sign = sign_quotient;
 }
 else
     rlimb = mpihelp_mod_1( np, nsize, dp[0] );
 rp[0] = rlimb;
 rsize = rlimb != 0?1:0;
 rem->nlimbs = rsize;
 rem->sign = sign_remainder;
 return;
    }


    if( quot ) {
 qp = quot->d;
 /* Make sure QP and NP point to different objects.  Otherwise the
	 * numerator would be gradually overwritten by the quotient limbs.  */
 if(qp == np) { /* Copy NP object to temporary space.  */
     np = marker[markidx++] = mpi_alloc_limb_space(nsize,
         ((quot) && (mpi_get_flags (quot)&1)));
     do { mpi_size_t _i; for( _i = 0; _i < (nsize); _i++ ) (np)[_i] = (qp)[_i]; } while(0);
 }
    }
    else /* Put quotient at top of remainder. */
 qp = rp + dsize;

    do { USItype __cbtmp; __asm__ ("bsrl %1,%0" : "=r" (__cbtmp) : "rm" ((USItype)(dp[dsize - 1]))); (normalization_steps) = __cbtmp ^ 31; } while (0);

    /* Normalize the denominator, i.e. make its most significant bit set by
     * shifting it NORMALIZATION_STEPS bits to the left.  Also shift the
     * numerator the same number of steps (to keep the quotient the same!).
     */
    if( normalization_steps ) {
 mpi_ptr_t tp;
 mpi_limb_t nlimb;

 /* Shift up the denominator setting the most significant bit of
	 * the most significant word.  Use temporary storage not to clobber
	 * the original contents of the denominator.  */
 tp = marker[markidx++] = mpi_alloc_limb_space(dsize,((den) && (mpi_get_flags (den)&1)));
 mpihelp_lshift( tp, dp, dsize, normalization_steps );
 dp = tp;

 /* Shift up the numerator, possibly introducing a new most
	 * significant word.  Move the shifted numerator in the remainder
	 * meanwhile.  */
 nlimb = mpihelp_lshift(rp, np, nsize, normalization_steps);
 if( nlimb ) {
     rp[nsize] = nlimb;
     rsize = nsize + 1;
 }
 else
     rsize = nsize;
    }
    else {
 /* The denominator is already normalized, as required.	Copy it to
	 * temporary space if it overlaps with the quotient or remainder.  */
 if( dp == rp || (quot && (dp == qp))) {
     mpi_ptr_t tp;

     tp = marker[markidx++] = mpi_alloc_limb_space(dsize, ((den) && (mpi_get_flags (den)&1)));
     do { mpi_size_t _i; for( _i = 0; _i < (dsize); _i++ ) (tp)[_i] = (dp)[_i]; } while(0);
     dp = tp;
 }

 /* Move the numerator to the remainder.  */
 if( rp != np )
     do { mpi_size_t _i; for( _i = 0; _i < (nsize); _i++ ) (rp)[_i] = (np)[_i]; } while(0);

 rsize = nsize;
    }

    q_limb = mpihelp_divrem( qp, 0, rp, rsize, dp, dsize );

    if( quot ) {
 qsize = rsize - dsize;
 if(q_limb) {
     qp[qsize] = q_limb;
     qsize += 1;
 }

 quot->nlimbs = qsize;
 quot->sign = sign_quotient;
    }

    rsize = dsize;
    do { while( (rsize) > 0 ) { if( (rp)[(rsize)-1] ) break; (rsize)--; } } while(0);

    if( normalization_steps && rsize ) {
 mpihelp_rshift(rp, rp, rsize, normalization_steps);
 rsize -= rp[rsize - 1] == 0?1:0;
    }

    rem->nlimbs = rsize;
    rem->sign = sign_remainder;
    while( markidx )
 mpi_free_limb_space(marker[--markidx]);
}

