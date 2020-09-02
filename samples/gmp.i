void * __builtin_alloca (unsigned int);

# 30 "/usr/local/share/frama-c/libc/stdarg.h"
typedef __builtin_va_list va_list;

# 29 "/usr/local/share/frama-c/libc/__fc_define_size_t.h"
typedef unsigned int size_t;

# 112 "/usr/local/share/frama-c/libc/string.h"
/* extern */ size_t strlen (const char *s);

# 152 "/usr/local/share/frama-c/libc/stdio.h"
/* extern */ int snprintf(char * s, size_t n,
    const char * format, ...);

# 141 "../gmp.h"
typedef unsigned long int mp_limb_t;

# 176 "../gmp.h"
typedef long int mp_exp_t;

# 188 "../gmp.h"
typedef struct
{
  int _mp_prec;



  int _mp_size;


  mp_exp_t _mp_exp;
  mp_limb_t *_mp_d;
} __mpf_struct;

# 226 "../gmp.h"
typedef const __mpf_struct *mpf_srcptr;

# 698 "../gmp-impl.h"
/* extern */ void (*__gmp_free_func) (void *, size_t);

# 2839 "../gmp-impl.h"
struct bases
{



  int chars_per_limb;


  mp_limb_t logb2;


  mp_limb_t log2b;




  mp_limb_t big_base;




  mp_limb_t big_base_inverted;
};

# 2864 "../gmp-impl.h"
const struct bases __gmpn_bases[257];

# 3703 "../gmp-impl.h"
typedef unsigned int USItype;

# 4403 "../gmp-impl.h"
struct doprnt_params_t {
  int base;
  int conv;
  const char *expfmt;
  int exptimes4;
  char fill;
  int justify;
  int prec;
  int showbase;
  int showpoint;
  int showtrailing;
  char sign;
  int width;
};

# 4420 "../gmp-impl.h"
typedef int (*doprnt_format_t) (void *, const char *, va_list);

# 4421 "../gmp-impl.h"
typedef int (*doprnt_memory_t) (void *, const char *, size_t);

# 4422 "../gmp-impl.h"
typedef int (*doprnt_reps_t) (void *, int, int);

# 4423 "../gmp-impl.h"
typedef int (*doprnt_final_t) (void *);

# 4425 "../gmp-impl.h"
struct doprnt_funs_t {
  doprnt_format_t format;
  doprnt_memory_t memory;
  doprnt_reps_t reps;
  doprnt_final_t final;
};

# 58 "doprntf.c"
int
__gmp_doprnt_mpf2 (const struct doprnt_funs_t *funs,
    void *data,
    const struct doprnt_params_t *p,
    const char *point,
    mpf_srcptr f)
{
  int prec, ndigits, free_size, len, newlen, justify, justlen, explen;
  int showbaselen, sign, signlen, intlen, intzeros, pointlen;
  int fraczeros, fraclen, preczeros;
  char *s, *free_ptr;
  mp_exp_t exp;
  char exponent[32 + 10];
  const char *showbase;
  int retval = 0;

 
                                                   ;

  prec = p->prec;
  if (prec <= -1)
    {

      ndigits = 0;



      if (p->conv == 3)
 do { size_t rawn; do {} while (0); do { mp_limb_t _ph, _dummy; __asm__ ("mull %3" : "=a" (_dummy), "=d" (_ph) : "%0" ((USItype)(__gmpn_bases[((f)->_mp_prec)].logb2)), "rm" ((USItype)((32 - 0) * (mp_limb_t) ((((p->base) >= 0 ? (p->base) : -(p->base))) - 1)))); rawn = _ph; } while (0); prec = rawn + 2; } while (0);
    }
  else
    {
      switch (p->conv) {
      case 1:
# 100 "doprntf.c"
 ndigits = prec + 2 + 1
   + ((f)->_mp_exp) * (__gmpn_bases[((p->base) >= 0 ? (p->base) : -(p->base))].chars_per_limb + (((f)->_mp_exp)>=0));
 ndigits = ((ndigits) > (1) ? (ndigits) : (1));
 break;

      case 2:


 ndigits = prec + 1;
 break;

      default:
 do {} while (0);


      case 3:


 ndigits = ((prec) > (1) ? (prec) : (1));
 break;
      }
    }
  ;

  s = __gmpf_get_str (((void*)0), &exp, p->base, ndigits, f);
  len = strlen (s);
  free_ptr = s;
  free_size = len + 1;
 

                             ;



  do {} while (0)
                                               ;

  sign = p->sign;
  if (s[0] == '-')
    {
      sign = s[0];
      s++, len--;
    }
  signlen = (sign != '\0');
  ;

  switch (p->conv) {
  case 1:
    if (prec <= -1)
      prec = ((0) > (len-exp) ? (0) : (len-exp));


    do {} while (0);
    newlen = exp + prec;
    if (newlen < 0)
      {


 len = 0;
 exp = 0;
      }
    else if (len <= newlen)
      {

      }
    else
      {


 const char *num_to_text = (p->base >= 0
        ? "0123456789abcdefghijklmnopqrstuvwxyz"
        : "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ");
 int base = ((p->base) >= 0 ? (p->base) : -(p->base));
 int n;

 do {} while (0);

 len = newlen;
 n = (isdigit (s[len]) ? (s[len]) - '0' : islower (s[len]) ? (s[len]) - 'a' + 10 : (s[len]) - 'A' + 10);
 ;
 if (n >= (base + 1) / 2)
   {

     for (;;)
       {
  if (len == 0)
    {
      s[0] = '1';
      len = 1;
      exp++;
      break;
    }
  n = (isdigit (s[len-1]) ? (s[len-1]) - '0' : islower (s[len-1]) ? (s[len-1]) - 'a' + 10 : (s[len-1]) - 'A' + 10);
  do {} while (0);
  n++;
  if (n != base)
    {
      ;
      s[len-1] = num_to_text[n];
      break;
    }
  len--;
       }
   }
 else
   {

     while (len > 0 && s[len-1] == '0')
       len--;
   }




 if (len == 0)
   exp = 0;
      }

  fixed:
    do {} while (0);
    if (exp <= 0)
      {
 ;
 intlen = 0;
 intzeros = 1;
 fraczeros = -exp;
 fraclen = len;
      }
    else
      {
 ;
 intlen = ((len) < (exp) ? (len) : (exp));
 intzeros = exp - intlen;
 fraczeros = 0;
 fraclen = len - intlen;
      }
    explen = 0;
    break;

  case 2:
    {
      long int expval;
      char expsign;

      if (prec <= -1)
 prec = ((0) > (len-1) ? (0) : (len-1));

    scientific:
      ;

      intlen = ((1) < (len) ? (1) : (len));
      intzeros = (intlen == 0 ? 1 : 0);
      fraczeros = 0;
      fraclen = len - intlen;

      expval = (exp-intlen);
      if (p->exptimes4)
 expval <<= 2;



      expsign = (expval >= 0 ? '+' : '-');
      expval = ((expval) >= 0 ? (expval) : -(expval));


      explen = snprintf (exponent, sizeof(exponent),
    p->expfmt, expsign, expval);


      do {} while (0);





      ;
    }
    break;

  default:
    do {} while (0);


  case 3:





    if (exp-1 < -4 || exp-1 >= ((1) > (prec) ? (1) : (prec)))
      goto scientific;
    else
      goto fixed;
  }

 
                                         ;
  do {} while (0)

                                    ;

  if (p->showtrailing)
    {


      preczeros = prec - (fraczeros + fraclen
     + (p->conv == 3
        ? intlen + intzeros : 0));
      preczeros = ((0) > (preczeros) ? (0) : (preczeros));
    }
  else
    preczeros = 0;
 
                                     ;


  pointlen = ((fraczeros + fraclen + preczeros) != 0 || p->showpoint != 0)
    ? strlen (point) : 0;
  ;



  showbase = ((void*)0);
  showbaselen = 0;
  switch (p->showbase) {
  default:
    do {} while (0);

  case 2:
    break;
  case 3:
    if (intlen == 0 && fraclen == 0)
      break;

  case 1:
    switch (p->base) {
    case 16: showbase = "0x"; showbaselen = 2; break;
    case -16: showbase = "0X"; showbaselen = 2; break;
    case 8: showbase = "0"; showbaselen = 1; break;
    }
    break;
  }
 
                                                  ;


  justlen = p->width - (signlen + showbaselen + intlen + intzeros + pointlen
   + fraczeros + fraclen + preczeros + explen);
  ;

  justify = p->justify;
  if (justlen <= 0)
    justify = 0;

 
                                       ;

  if (justify == 2)
    do { do {} while (0); do { int __ret; __ret = (*(funs->reps)) (data, p->fill, justlen); if (__ret == -1) goto error; retval += __ret; } while (0); } while (0);

  if (signlen)
    do { do {} while (0); do { int __ret; __ret = (*(funs->reps)) (data, sign, 1); if (__ret == -1) goto error; retval += __ret; } while (0); } while (0);

  do { if ((showbaselen) != 0) do { do {} while (0); do { int __ret; __ret = (*(funs->memory)) (data, showbase, showbaselen); if (__ret == -1) goto error; retval += __ret; } while (0); } while (0); } while (0);

  if (justify == 3)
    do { do {} while (0); do { int __ret; __ret = (*(funs->reps)) (data, p->fill, justlen); if (__ret == -1) goto error; retval += __ret; } while (0); } while (0);

  do { do {} while (0); do { int __ret; __ret = (*(funs->memory)) (data, s, intlen); if (__ret == -1) goto error; retval += __ret; } while (0); } while (0);
  do { if ((intzeros) != 0) do { do {} while (0); do { int __ret; __ret = (*(funs->reps)) (data, '0', intzeros); if (__ret == -1) goto error; retval += __ret; } while (0); } while (0); } while (0);

  do { if ((pointlen) != 0) do { do {} while (0); do { int __ret; __ret = (*(funs->memory)) (data, point, pointlen); if (__ret == -1) goto error; retval += __ret; } while (0); } while (0); } while (0);

  do { if ((fraczeros) != 0) do { do {} while (0); do { int __ret; __ret = (*(funs->reps)) (data, '0', fraczeros); if (__ret == -1) goto error; retval += __ret; } while (0); } while (0); } while (0);
  do { if ((fraclen) != 0) do { do {} while (0); do { int __ret; __ret = (*(funs->memory)) (data, s+intlen, fraclen); if (__ret == -1) goto error; retval += __ret; } while (0); } while (0); } while (0);

  do { if ((preczeros) != 0) do { do {} while (0); do { int __ret; __ret = (*(funs->reps)) (data, '0', preczeros); if (__ret == -1) goto error; retval += __ret; } while (0); } while (0); } while (0);

  do { if ((explen) != 0) do { do {} while (0); do { int __ret; __ret = (*(funs->memory)) (data, exponent, explen); if (__ret == -1) goto error; retval += __ret; } while (0); } while (0); } while (0);

  if (justify == 1)
    do { do {} while (0); do { int __ret; __ret = (*(funs->reps)) (data, p->fill, justlen); if (__ret == -1) goto error; retval += __ret; } while (0); } while (0);

 done:
  (*__gmp_free_func) (free_ptr, free_size);
  return retval;

 error:
  retval = -1;
  goto done;
}

# 166 "../gmp.h"
typedef mp_limb_t * mp_ptr;

# 167 "../gmp.h"
typedef const mp_limb_t * mp_srcptr;

# 175 "../gmp.h"
typedef long int mp_size_t;

# 1470 "../gmp.h"
mp_limb_t __gmpn_add_n (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);

# 1531 "../gmp.h"
mp_limb_t __gmpn_lshift (mp_ptr, mp_srcptr, mp_size_t, unsigned int);

# 1607 "../gmp.h"
mp_limb_t __gmpn_sub_n (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);

# 1610 "../gmp.h"
mp_limb_t __gmpn_submul_1 (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t);

# 1640 "../gmp.h"
mp_limb_t __gmpn_cnd_add_n (mp_limb_t, mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);

# 1642 "../gmp.h"
mp_limb_t __gmpn_cnd_sub_n (mp_limb_t, mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);

# 78 "sec_pi1_div_qr.c"
mp_limb_t
__gmpn_sec_pi1_div_qr (mp_ptr qp,
       mp_ptr np, mp_size_t nn,
       mp_srcptr dp, mp_size_t dn,
       mp_limb_t dinv,
       mp_ptr tp)
{
  mp_limb_t nh, cy, q1h, q0h, dummy, cnd;
  mp_size_t i;
  mp_ptr hp;

  mp_limb_t qh;
  mp_ptr qlp, qhp;


  do {} while (0);
  do {} while (0);
  do {} while (0);

  if (nn == dn)
    {
      cy = __gmpn_sub_n (np, np, dp, dn);
      __gmpn_cnd_add_n (cy, np, np, dp, dn);

      return 1 - cy;



    }


  hp = tp;
  hp[dn] = __gmpn_lshift (hp, dp, dn, (32 - 0) / 2);


  qlp = tp + (dn + 1);
  qhp = tp + (nn + 1);


  np += nn - dn;
  nh = 0;

  for (i = nn - dn - 1; i >= 0; i--)
    {
      np--;

      nh = (nh << (32 - 0)/2) + (np[dn] >> (32 - 0)/2);
      __asm__ ("mull %3" : "=a" (dummy), "=d" (q1h) : "%0" ((USItype)(nh)), "rm" ((USItype)(dinv)));
      q1h += nh;

      qhp[i] = q1h;

      __gmpn_submul_1 (np, hp, dn + 1, q1h);

      nh = np[dn];
      __asm__ ("mull %3" : "=a" (dummy), "=d" (q0h) : "%0" ((USItype)(nh)), "rm" ((USItype)(dinv)));
      q0h += nh;

      qlp[i] = q0h;

      nh -= __gmpn_submul_1 (np, dp, dn, q0h);
    }


  cnd = nh != 0;

  qlp[0] += cnd;

  nh -= __gmpn_cnd_sub_n (cnd, np, np, dp, dn);



  cy = __gmpn_sub_n (np, np, dp, dn);
  cy = cy - nh;

  qlp[0] += 1 - cy;

  __gmpn_cnd_add_n (cy, np, np, dp, dn);


  cy = __gmpn_sub_n (np, np, dp, dn);

  qlp[0] += 1 - cy;

  __gmpn_cnd_add_n (cy, np, np, dp, dn);



  qh = __gmpn_lshift (qhp, qhp, nn - dn, (32 - 0)/2);
  qh += __gmpn_add_n (qp, qhp, qlp, nn - dn);

  return qh;



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

  do { mp_limb_t _q0, _t1, _t0, _mask; __asm__ ("mull %3" : "=a" (_q0), "=d" ((qh)) : "%0" ((USItype)((r2))), "rm" ((USItype)((di)))); __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" ((qh)), "=&r" (_q0) : "0" ((USItype)((qh))), "g" ((USItype)((r2))), "%1" ((USItype)(_q0)), "g" ((USItype)((r1)))); (r2) = (r1) - (d1) * (qh); __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((r2)), "=&r" ((r1)) : "0" ((USItype)((r2))), "g" ((USItype)((d1))), "1" ((USItype)((r0))), "g" ((USItype)((d0)))); __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)((d0))), "rm" ((USItype)((qh)))); __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((r2)), "=&r" ((r1)) : "0" ((USItype)((r2))), "g" ((USItype)(_t1)), "1" ((USItype)((r1))), "g" ((USItype)(_t0))); (qh)++; _mask = - (mp_limb_t) ((r2) >= _q0); (qh) += _mask; __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" ((r2)), "=&r" ((r1)) : "0" ((USItype)((r2))), "g" ((USItype)(_mask & (d1))), "%1" ((USItype)((r1))), "g" ((USItype)(_mask & (d0)))); if (__builtin_expect (((r2) >= (d1)) != 0, 0)) { if ((r2) > (d1) || (r1) >= (d0)) { (qh)++; __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((r2)), "=&r" ((r1)) : "0" ((USItype)((r2))), "g" ((USItype)((d1))), "1" ((USItype)((r1))), "g" ((USItype)((d0)))); } } } while (0);

  for (i = nn - 2 - 1; i >= 0; i--)
    {
      mp_limb_t q;
      r0 = np[i];
      r1 |= r0 >> (32 - shift);
      r0 <<= shift;
      do { mp_limb_t _q0, _t1, _t0, _mask; __asm__ ("mull %3" : "=a" (_q0), "=d" ((q)) : "%0" ((USItype)((r2))), "rm" ((USItype)((di)))); __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" ((q)), "=&r" (_q0) : "0" ((USItype)((q))), "g" ((USItype)((r2))), "%1" ((USItype)(_q0)), "g" ((USItype)((r1)))); (r2) = (r1) - (d1) * (q); __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((r2)), "=&r" ((r1)) : "0" ((USItype)((r2))), "g" ((USItype)((d1))), "1" ((USItype)((r0))), "g" ((USItype)((d0)))); __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)((d0))), "rm" ((USItype)((q)))); __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((r2)), "=&r" ((r1)) : "0" ((USItype)((r2))), "g" ((USItype)(_t1)), "1" ((USItype)((r1))), "g" ((USItype)(_t0))); (q)++; _mask = - (mp_limb_t) ((r2) >= _q0); (q) += _mask; __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" ((r2)), "=&r" ((r1)) : "0" ((USItype)((r2))), "g" ((USItype)(_mask & (d1))), "%1" ((USItype)((r1))), "g" ((USItype)(_mask & (d0)))); if (__builtin_expect (((r2) >= (d1)) != 0, 0)) { if ((r2) > (d1) || (r1) >= (d0)) { (q)++; __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((r2)), "=&r" ((r1)) : "0" ((USItype)((r2))), "g" ((USItype)((d1))), "1" ((USItype)((r1))), "g" ((USItype)((d0)))); } } } while (0);
      qp[i] = q;
    }

  rp[0] = (r1 >> shift) | (r2 << (32 - shift));
  rp[1] = r2 >> shift;

  return qh;
}

# 2155 "../gmp.h"
/* extern */ __inline__

int
__gmpn_cmp (mp_srcptr __gmp_xp, mp_srcptr __gmp_yp, mp_size_t __gmp_size)
{
  int __gmp_result;
  do { mp_size_t __gmp_i; mp_limb_t __gmp_x, __gmp_y; (__gmp_result) = 0; __gmp_i = (__gmp_size); while (--__gmp_i >= 0) { __gmp_x = (__gmp_xp)[__gmp_i]; __gmp_y = (__gmp_yp)[__gmp_i]; if (__gmp_x != __gmp_y) { (__gmp_result) = (__gmp_x > __gmp_y ? 1 : -1); break; } } } while (0);
  return __gmp_result;
}

# 2384 "../gmp-impl.h"
void __gmp_assert_fail (const char *, int, const char *);

# 44 "sbpi1_divappr_q.c"
mp_limb_t
__gmpn_sbpi1_divappr_q (mp_ptr qp,
       mp_ptr np, mp_size_t nn,
       mp_srcptr dp, mp_size_t dn,
       mp_limb_t dinv)
{
  mp_limb_t qh;
  mp_size_t qn, i;
  mp_limb_t n1, n0;
  mp_limb_t d1, d0;
  mp_limb_t cy, cy1;
  mp_limb_t q;
  mp_limb_t flag;

  do {} while (0);
  do {} while (0);
  do {} while (0);

  np += nn;

  qn = nn - dn;
  if (qn + 1 < dn)
    {
      dp += dn - (qn + 1);
      dn = qn + 1;
    }

  qh = __gmpn_cmp (np - dn, dp, dn) >= 0;
  if (qh != 0)
    __gmpn_sub_n (np - dn, np - dn, dp, dn);

  qp += qn;

  dn -= 2;

  d1 = dp[dn + 1];
  d0 = dp[dn + 0];

  np -= 2;

  n1 = np[1];

  for (i = qn - (dn + 2); i >= 0; i--)
    {
      np--;
      if (__builtin_expect ((n1 == d1) != 0, 0) && np[1] == d0)
 {
   q = ((~ ((mp_limb_t) (0))) >> 0);
   __gmpn_submul_1 (np - dn, dp, dn + 2, q);
   n1 = np[1];
 }
      else
 {
   do { mp_limb_t _q0, _t1, _t0, _mask; __asm__ ("mull %3" : "=a" (_q0), "=d" ((q)) : "%0" ((USItype)((n1))), "rm" ((USItype)((dinv)))); __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" ((q)), "=&r" (_q0) : "0" ((USItype)((q))), "g" ((USItype)((n1))), "%1" ((USItype)(_q0)), "g" ((USItype)((np[1])))); (n1) = (np[1]) - (d1) * (q); __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((n1)), "=&r" ((n0)) : "0" ((USItype)((n1))), "g" ((USItype)((d1))), "1" ((USItype)((np[0]))), "g" ((USItype)((d0)))); __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)((d0))), "rm" ((USItype)((q)))); __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((n1)), "=&r" ((n0)) : "0" ((USItype)((n1))), "g" ((USItype)(_t1)), "1" ((USItype)((n0))), "g" ((USItype)(_t0))); (q)++; _mask = - (mp_limb_t) ((n1) >= _q0); (q) += _mask; __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" ((n1)), "=&r" ((n0)) : "0" ((USItype)((n1))), "g" ((USItype)(_mask & (d1))), "%1" ((USItype)((n0))), "g" ((USItype)(_mask & (d0)))); if (__builtin_expect (((n1) >= (d1)) != 0, 0)) { if ((n1) > (d1) || (n0) >= (d0)) { (q)++; __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((n1)), "=&r" ((n0)) : "0" ((USItype)((n1))), "g" ((USItype)((d1))), "1" ((USItype)((n0))), "g" ((USItype)((d0)))); } } } while (0);

   cy = __gmpn_submul_1 (np - dn, dp, dn, q);

   cy1 = n0 < cy;
   n0 = (n0 - cy) & ((~ ((mp_limb_t) (0))) >> 0);
   cy = n1 < cy1;
   n1 -= cy1;
   np[0] = n0;

   if (__builtin_expect ((cy != 0) != 0, 0))
     {
       n1 += d1 + __gmpn_add_n (np - dn, np - dn, dp, dn + 1);
       q--;
     }
 }

      *--qp = q;
    }

  flag = ~((mp_limb_t) 0L);

  if (dn >= 0)
    {
      for (i = dn; i > 0; i--)
 {
   np--;
   if (__builtin_expect ((n1 >= (d1 & flag)) != 0, 0))
     {
       q = ((~ ((mp_limb_t) (0))) >> 0);
       cy = __gmpn_submul_1 (np - dn, dp, dn + 2, q);

       if (__builtin_expect ((n1 != cy) != 0, 0))
  {
    if (n1 < (cy & flag))
      {
        q--;
        __gmpn_add_n (np - dn, np - dn, dp, dn + 2);
      }
    else
      flag = 0;
  }
       n1 = np[1];
     }
   else
     {
       do { mp_limb_t _q0, _t1, _t0, _mask; __asm__ ("mull %3" : "=a" (_q0), "=d" ((q)) : "%0" ((USItype)((n1))), "rm" ((USItype)((dinv)))); __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" ((q)), "=&r" (_q0) : "0" ((USItype)((q))), "g" ((USItype)((n1))), "%1" ((USItype)(_q0)), "g" ((USItype)((np[1])))); (n1) = (np[1]) - (d1) * (q); __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((n1)), "=&r" ((n0)) : "0" ((USItype)((n1))), "g" ((USItype)((d1))), "1" ((USItype)((np[0]))), "g" ((USItype)((d0)))); __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)((d0))), "rm" ((USItype)((q)))); __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((n1)), "=&r" ((n0)) : "0" ((USItype)((n1))), "g" ((USItype)(_t1)), "1" ((USItype)((n0))), "g" ((USItype)(_t0))); (q)++; _mask = - (mp_limb_t) ((n1) >= _q0); (q) += _mask; __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" ((n1)), "=&r" ((n0)) : "0" ((USItype)((n1))), "g" ((USItype)(_mask & (d1))), "%1" ((USItype)((n0))), "g" ((USItype)(_mask & (d0)))); if (__builtin_expect (((n1) >= (d1)) != 0, 0)) { if ((n1) > (d1) || (n0) >= (d0)) { (q)++; __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((n1)), "=&r" ((n0)) : "0" ((USItype)((n1))), "g" ((USItype)((d1))), "1" ((USItype)((n0))), "g" ((USItype)((d0)))); } } } while (0);

       cy = __gmpn_submul_1 (np - dn, dp, dn, q);

       cy1 = n0 < cy;
       n0 = (n0 - cy) & ((~ ((mp_limb_t) (0))) >> 0);
       cy = n1 < cy1;
       n1 -= cy1;
       np[0] = n0;

       if (__builtin_expect ((cy != 0) != 0, 0))
  {
    n1 += d1 + __gmpn_add_n (np - dn, np - dn, dp, dn + 1);
    q--;
  }
     }

   *--qp = q;


   dn--;
   dp++;
 }

      np--;
      if (__builtin_expect ((n1 >= (d1 & flag)) != 0, 0))
 {
   q = ((~ ((mp_limb_t) (0))) >> 0);
   cy = __gmpn_submul_1 (np, dp, 2, q);

   if (__builtin_expect ((n1 != cy) != 0, 0))
     {
       if (n1 < (cy & flag))
  {
    q--;
    __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (np[1]), "=&r" (np[0]) : "0" ((USItype)(np[1])), "g" ((USItype)(dp[1])), "%1" ((USItype)(np[0])), "g" ((USItype)(dp[0])));
  }
       else
  flag = 0;
     }
   n1 = np[1];
 }
      else
 {
   do { mp_limb_t _q0, _t1, _t0, _mask; __asm__ ("mull %3" : "=a" (_q0), "=d" ((q)) : "%0" ((USItype)((n1))), "rm" ((USItype)((dinv)))); __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" ((q)), "=&r" (_q0) : "0" ((USItype)((q))), "g" ((USItype)((n1))), "%1" ((USItype)(_q0)), "g" ((USItype)((np[1])))); (n1) = (np[1]) - (d1) * (q); __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((n1)), "=&r" ((n0)) : "0" ((USItype)((n1))), "g" ((USItype)((d1))), "1" ((USItype)((np[0]))), "g" ((USItype)((d0)))); __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)((d0))), "rm" ((USItype)((q)))); __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((n1)), "=&r" ((n0)) : "0" ((USItype)((n1))), "g" ((USItype)(_t1)), "1" ((USItype)((n0))), "g" ((USItype)(_t0))); (q)++; _mask = - (mp_limb_t) ((n1) >= _q0); (q) += _mask; __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" ((n1)), "=&r" ((n0)) : "0" ((USItype)((n1))), "g" ((USItype)(_mask & (d1))), "%1" ((USItype)((n0))), "g" ((USItype)(_mask & (d0)))); if (__builtin_expect (((n1) >= (d1)) != 0, 0)) { if ((n1) > (d1) || (n0) >= (d0)) { (q)++; __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((n1)), "=&r" ((n0)) : "0" ((USItype)((n1))), "g" ((USItype)((d1))), "1" ((USItype)((n0))), "g" ((USItype)((d0)))); } } } while (0);

   np[1] = n1;
   np[0] = n0;
 }

      *--qp = q;
    }

  do { if (__builtin_expect ((!(np[1] == n1)) != 0, 0)) __gmp_assert_fail ("sbpi1_divappr_q.c", 196, "np[1] == n1"); } while (0);

  return qh;
}

# 142 "../gmp.h"
typedef long int mp_limb_signed_t;

# 4173 "../gmp-impl.h"
struct hgcd_matrix1
{
  mp_limb_t u[2][2];
};

# 45 "hgcd2.c"
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

# 99 "hgcd2.c"
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
       __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (nh), "=&r" (nl) : "0" ((USItype)(nh)), "g" ((USItype)(dh)), "1" ((USItype)(nl)), "g" ((USItype)(dl)));
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
       __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (nh), "=&r" (nl) : "0" ((USItype)(nh)), "g" ((USItype)(dh)), "1" ((USItype)(nl)), "g" ((USItype)(dl)));
       q |= 1;
     }
   cnt--;
 }
    }

  rp[0] = nl;
  rp[1] = nh;

  return q;
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
      __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (ah), "=&r" (al) : "0" ((USItype)(ah)), "g" ((USItype)(bh)), "1" ((USItype)(al)), "g" ((USItype)(bl)));
      if (ah < 2)
 return 0;

      u00 = u01 = u11 = 1;
      u10 = 0;
    }
  else
    {
      __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (bh), "=&r" (bl) : "0" ((USItype)(bh)), "g" ((USItype)(ah)), "1" ((USItype)(bl)), "g" ((USItype)(al)));
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



      do {} while (0);
      __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (ah), "=&r" (al) : "0" ((USItype)(ah)), "g" ((USItype)(bh)), "1" ((USItype)(al)), "g" ((USItype)(bl)));

      if (ah < 2)
 goto done;

      if (ah <= bh)
 {

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



      __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (bh), "=&r" (bl) : "0" ((USItype)(bh)), "g" ((USItype)(ah)), "1" ((USItype)(bl)), "g" ((USItype)(al)));

      if (bh < 2)
 goto done;

      if (bh <= ah)
 {

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

       u00 += q * u01;
       u10 += q * u11;
       goto done;
     }
   q++;
   u00 += q * u01;
   u10 += q * u11;
 }
    }





  for (;;)
    {
      do {} while (0);

      ah -= bh;
      if (ah < (((mp_limb_t) 1L) << (32 / 2 + 1)))
 break;

      if (ah <= bh)
 {

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
      do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("mull %3" : "=a" (_ql), "=d" (_qh) : "%0" ((USItype)((u1))), "rm" ((USItype)((dinv)))); if (__builtin_constant_p (up[0]) && (up[0]) == 0) { _qh += (u1) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); _qh += _mask; _r += _mask & (d); } else { __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (_qh), "=&r" (_ql) : "0" ((USItype)(_qh)), "g" ((USItype)((u1) + 1)), "%1" ((USItype)(_ql)), "g" ((USItype)((up[0])))); _r = (up[0]) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (u1) = _r; (qp[0]) = _qh; } while (0);
      return u1;
    }


  B2 = -d*dinv;

  __asm__ ("mull %3" : "=a" (q0), "=d" (q1) : "%0" ((USItype)(dinv)), "rm" ((USItype)(u1)));
  __asm__ ("mull %3" : "=a" (p0), "=d" (p1) : "%0" ((USItype)(B2)), "rm" ((USItype)(u1)));
  q1 += u1;
  do {} while (0);
  u0 = up[n-1];
  qp[n-1] = q1;

  __asm__ ( "add	%6, %k2\n\t" "adc	%4, %k1\n\t" "sbb	%k0, %k0" : "=r" (u2), "=r" (u1), "=&r" (u0) : "1" ((USItype)(u0)), "g" ((USItype)(p1)), "%2" ((USItype)(up[n-2])), "g" ((USItype)(p0)));



  for (j = n-2; j-- > 0; )
    {
      mp_limb_t q2, cy;
# 241 "div_qr_1n_pi1.c"
      __asm__ ("mull %3" : "=a" (t), "=d" (p1) : "%0" ((USItype)(u1)), "rm" ((USItype)(dinv)));
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (q2), "=&r" (q1) : "0" ((USItype)(-u2)), "g" ((USItype)(((mp_limb_t) 0L))), "%1" ((USItype)(u2 & dinv)), "g" ((USItype)(u1)));
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (q2), "=&r" (q1) : "0" ((USItype)(q2)), "g" ((USItype)(((mp_limb_t) 0L))), "%1" ((USItype)(q1)), "g" ((USItype)(p1)));
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (q2), "=&r" (q1) : "0" ((USItype)(q2)), "g" ((USItype)(((mp_limb_t) 0L))), "%1" ((USItype)(q1)), "g" ((USItype)(q0)));
      q0 = t;

      __asm__ ("mull %3" : "=a" (p0), "=d" (p1) : "%0" ((USItype)(u1)), "rm" ((USItype)(B2)));
      do { mp_limb_t __x = (u0); mp_limb_t __y = (u2 & B2); mp_limb_t __w = __x + __y; (u0) = __w; (cy) = __w < __x; } while (0);
      u0 -= (-cy) & d;


      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (q2), "=&r" (q1) : "0" ((USItype)(q2)), "g" ((USItype)(((mp_limb_t) 0L))), "%1" ((USItype)(q1)), "g" ((USItype)(cy)));
      qp[j+1] = q1;
      do { mp_ptr __ptr_dummy; if (__builtin_constant_p (q2) && (q2) == 0) { } else if (__builtin_constant_p (q2) && (q2) == 1) { __asm__ __volatile__ ("\n" ".L" "asm_%=_" "top" ":\n" "\t" "addl" "\t$1, (%0)\n" "\tlea\t%c2(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" : "=r" (__ptr_dummy) : "0" (qp+j+2), "n" (sizeof(mp_limb_t)) : "memory"); } else { __asm__ __volatile__ ( "addl" "\t%2, (%0)\n" "\tjnc\t" ".L" "asm_%=_" "done" "\n" ".L" "asm_%=_" "top" ":\n" "\t" "addl" "\t$1, %c3(%0)\n" "\tlea\t%c3(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" "\n" ".L" "asm_%=_" "done" ":\n" : "=r" (__ptr_dummy) : "0" (qp+j+2), "re" ((mp_limb_t) (q2)), "n" (sizeof(mp_limb_t)) : "memory"); } } while (0);

      __asm__ ( "add	%6, %k2\n\t" "adc	%4, %k1\n\t" "sbb	%k0, %k0" : "=r" (u2), "=r" (u1), "=&r" (u0) : "1" ((USItype)(u0)), "g" ((USItype)(p1)), "%2" ((USItype)(up[j])), "g" ((USItype)(p0)));
    }

  q1 = (u2 > 0);
  u1 -= (-q1) & d;

  t = (u1 >= d);
  q1 += t;
  u1 -= (-t) & d;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("mull %3" : "=a" (_ql), "=d" (_qh) : "%0" ((USItype)((u1))), "rm" ((USItype)((dinv)))); if (__builtin_constant_p (u0) && (u0) == 0) { _qh += (u1) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); _qh += _mask; _r += _mask & (d); } else { __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (_qh), "=&r" (_ql) : "0" ((USItype)(_qh)), "g" ((USItype)((u1) + 1)), "%1" ((USItype)(_ql)), "g" ((USItype)((u0)))); _r = (u0) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (u0) = _r; (t) = _qh; } while (0);
  __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (q1), "=&r" (q0) : "0" ((USItype)(q1)), "g" ((USItype)(((mp_limb_t) 0L))), "%1" ((USItype)(q0)), "g" ((USItype)(t)));

  do { mp_ptr __ptr_dummy; if (__builtin_constant_p (q1) && (q1) == 0) { } else if (__builtin_constant_p (q1) && (q1) == 1) { __asm__ __volatile__ ("\n" ".L" "asm_%=_" "top" ":\n" "\t" "addl" "\t$1, (%0)\n" "\tlea\t%c2(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" : "=r" (__ptr_dummy) : "0" (qp+1), "n" (sizeof(mp_limb_t)) : "memory"); } else { __asm__ __volatile__ ( "addl" "\t%2, (%0)\n" "\tjnc\t" ".L" "asm_%=_" "done" "\n" ".L" "asm_%=_" "top" ":\n" "\t" "addl" "\t$1, %c3(%0)\n" "\tlea\t%c3(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" "\n" ".L" "asm_%=_" "done" ":\n" : "=r" (__ptr_dummy) : "0" (qp+1), "re" ((mp_limb_t) (q1)), "n" (sizeof(mp_limb_t)) : "memory"); } } while (0);

  qp[0] = q0;
  return u0;
}

# 1473 "../gmp.h"
mp_limb_t __gmpn_addmul_1 (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t);

# 1537 "../gmp.h"
mp_limb_t __gmpn_mul (mp_ptr, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t);

# 1546 "../gmp.h"
void __gmpn_sqr (mp_ptr, mp_srcptr, mp_size_t);

# 1579 "../gmp.h"
mp_limb_t __gmpn_rshift (mp_ptr, mp_srcptr, mp_size_t, unsigned int);

# 1613 "../gmp.h"
void __gmpn_tdiv_qr (mp_ptr, mp_ptr, mp_size_t, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t);

# 1633 "../gmp.h"
void __gmpn_copyi (mp_ptr, mp_srcptr, mp_size_t);

# 2142 "../gmp.h"
/* extern */ __inline__

mp_limb_t
__gmpn_add_1 (mp_ptr __gmp_dst, mp_srcptr __gmp_src, mp_size_t __gmp_size, mp_limb_t __gmp_n)
{
  mp_limb_t __gmp_c;
  do { mp_size_t __gmp_i; mp_limb_t __gmp_x, __gmp_r; __gmp_x = (__gmp_src)[0]; __gmp_r = __gmp_x + (__gmp_n); (__gmp_dst)[0] = __gmp_r; if (((__gmp_r) < ((__gmp_n)))) { (__gmp_c) = 1; for (__gmp_i = 1; __gmp_i < (__gmp_size);) { __gmp_x = (__gmp_src)[__gmp_i]; __gmp_r = __gmp_x + 1; (__gmp_dst)[__gmp_i] = __gmp_r; ++__gmp_i; if (!((__gmp_r) < (1))) { if ((__gmp_src) != (__gmp_dst)) do { mp_size_t __gmp_j; ; for (__gmp_j = (__gmp_i); __gmp_j < (__gmp_size); __gmp_j++) (__gmp_dst)[__gmp_j] = (__gmp_src)[__gmp_j]; } while (0); (__gmp_c) = 0; break; } } } else { if ((__gmp_src) != (__gmp_dst)) do { mp_size_t __gmp_j; ; for (__gmp_j = (1); __gmp_j < (__gmp_size); __gmp_j++) (__gmp_dst)[__gmp_j] = (__gmp_src)[__gmp_j]; } while (0); (__gmp_c) = 0; } } while (0);
  return __gmp_c;
}

# 2168 "../gmp.h"
/* extern */ __inline__

int
__gmpn_zero_p (mp_srcptr __gmp_p, mp_size_t __gmp_n)
{

    do {
      if (__gmp_p[--__gmp_n] != 0)
 return 0;
    } while (__gmp_n != 0);
  return 1;
}

# 2197 "../gmp.h"
/* extern */ __inline__

mp_limb_t
__gmpn_sub_1 (mp_ptr __gmp_dst, mp_srcptr __gmp_src, mp_size_t __gmp_size, mp_limb_t __gmp_n)
{
  mp_limb_t __gmp_c;
  do { mp_size_t __gmp_i; mp_limb_t __gmp_x, __gmp_r; __gmp_x = (__gmp_src)[0]; __gmp_r = __gmp_x - (__gmp_n); (__gmp_dst)[0] = __gmp_r; if (((__gmp_x) < ((__gmp_n)))) { (__gmp_c) = 1; for (__gmp_i = 1; __gmp_i < (__gmp_size);) { __gmp_x = (__gmp_src)[__gmp_i]; __gmp_r = __gmp_x - 1; (__gmp_dst)[__gmp_i] = __gmp_r; ++__gmp_i; if (!((__gmp_x) < (1))) { if ((__gmp_src) != (__gmp_dst)) do { mp_size_t __gmp_j; ; for (__gmp_j = (__gmp_i); __gmp_j < (__gmp_size); __gmp_j++) (__gmp_dst)[__gmp_j] = (__gmp_src)[__gmp_j]; } while (0); (__gmp_c) = 0; break; } } } else { if ((__gmp_src) != (__gmp_dst)) do { mp_size_t __gmp_j; ; for (__gmp_j = (1); __gmp_j < (__gmp_size); __gmp_j++) (__gmp_dst)[__gmp_j] = (__gmp_src)[__gmp_j]; } while (0); (__gmp_c) = 0; } } while (0);
  return __gmp_c;
}

# 255 "../gmp-impl.h"
typedef struct {mp_limb_t inv32;} gmp_pi1_t;

# 362 "../gmp-impl.h"
struct tmp_reentrant_t {
  struct tmp_reentrant_t *next;
  size_t size;
};

# 366 "../gmp-impl.h"
void *__gmp_tmp_reentrant_alloc (struct tmp_reentrant_t **, size_t);

# 367 "../gmp-impl.h"
void __gmp_tmp_reentrant_free (struct tmp_reentrant_t *);

# 1448 "../gmp-impl.h"
mp_limb_t __gmpn_dcpi1_divappr_q (mp_ptr, mp_ptr, mp_size_t, mp_srcptr, mp_size_t, gmp_pi1_t *);

# 1465 "../gmp-impl.h"
mp_limb_t __gmpn_mu_divappr_q (mp_ptr, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t, mp_ptr);

# 1467 "../gmp-impl.h"
mp_size_t __gmpn_mu_divappr_q_itch (mp_size_t, mp_size_t, int);

# 53 "sqrtrem.c"
static const unsigned char invsqrttab[384] =
{
  0xff,0xfd,0xfb,0xf9,0xf7,0xf5,0xf3,0xf2,
  0xf0,0xee,0xec,0xea,0xe9,0xe7,0xe5,0xe4,
  0xe2,0xe0,0xdf,0xdd,0xdb,0xda,0xd8,0xd7,
  0xd5,0xd4,0xd2,0xd1,0xcf,0xce,0xcc,0xcb,
  0xc9,0xc8,0xc6,0xc5,0xc4,0xc2,0xc1,0xc0,
  0xbe,0xbd,0xbc,0xba,0xb9,0xb8,0xb7,0xb5,
  0xb4,0xb3,0xb2,0xb0,0xaf,0xae,0xad,0xac,
  0xaa,0xa9,0xa8,0xa7,0xa6,0xa5,0xa4,0xa3,
  0xa2,0xa0,0x9f,0x9e,0x9d,0x9c,0x9b,0x9a,
  0x99,0x98,0x97,0x96,0x95,0x94,0x93,0x92,
  0x91,0x90,0x8f,0x8e,0x8d,0x8c,0x8c,0x8b,
  0x8a,0x89,0x88,0x87,0x86,0x85,0x84,0x83,
  0x83,0x82,0x81,0x80,0x7f,0x7e,0x7e,0x7d,
  0x7c,0x7b,0x7a,0x79,0x79,0x78,0x77,0x76,
  0x76,0x75,0x74,0x73,0x72,0x72,0x71,0x70,
  0x6f,0x6f,0x6e,0x6d,0x6d,0x6c,0x6b,0x6a,
  0x6a,0x69,0x68,0x68,0x67,0x66,0x66,0x65,
  0x64,0x64,0x63,0x62,0x62,0x61,0x60,0x60,
  0x5f,0x5e,0x5e,0x5d,0x5c,0x5c,0x5b,0x5a,
  0x5a,0x59,0x59,0x58,0x57,0x57,0x56,0x56,
  0x55,0x54,0x54,0x53,0x53,0x52,0x52,0x51,
  0x50,0x50,0x4f,0x4f,0x4e,0x4e,0x4d,0x4d,
  0x4c,0x4b,0x4b,0x4a,0x4a,0x49,0x49,0x48,
  0x48,0x47,0x47,0x46,0x46,0x45,0x45,0x44,
  0x44,0x43,0x43,0x42,0x42,0x41,0x41,0x40,
  0x40,0x3f,0x3f,0x3e,0x3e,0x3d,0x3d,0x3c,
  0x3c,0x3b,0x3b,0x3a,0x3a,0x39,0x39,0x39,
  0x38,0x38,0x37,0x37,0x36,0x36,0x35,0x35,
  0x35,0x34,0x34,0x33,0x33,0x32,0x32,0x32,
  0x31,0x31,0x30,0x30,0x2f,0x2f,0x2f,0x2e,
  0x2e,0x2d,0x2d,0x2d,0x2c,0x2c,0x2b,0x2b,
  0x2b,0x2a,0x2a,0x29,0x29,0x29,0x28,0x28,
  0x27,0x27,0x27,0x26,0x26,0x26,0x25,0x25,
  0x24,0x24,0x24,0x23,0x23,0x23,0x22,0x22,
  0x21,0x21,0x21,0x20,0x20,0x20,0x1f,0x1f,
  0x1f,0x1e,0x1e,0x1e,0x1d,0x1d,0x1d,0x1c,
  0x1c,0x1b,0x1b,0x1b,0x1a,0x1a,0x1a,0x19,
  0x19,0x19,0x18,0x18,0x18,0x18,0x17,0x17,
  0x17,0x16,0x16,0x16,0x15,0x15,0x15,0x14,
  0x14,0x14,0x13,0x13,0x13,0x12,0x12,0x12,
  0x12,0x11,0x11,0x11,0x10,0x10,0x10,0x0f,
  0x0f,0x0f,0x0f,0x0e,0x0e,0x0e,0x0d,0x0d,
  0x0d,0x0c,0x0c,0x0c,0x0c,0x0b,0x0b,0x0b,
  0x0a,0x0a,0x0a,0x0a,0x09,0x09,0x09,0x09,
  0x08,0x08,0x08,0x07,0x07,0x07,0x07,0x06,
  0x06,0x06,0x06,0x05,0x05,0x05,0x04,0x04,
  0x04,0x04,0x03,0x03,0x03,0x03,0x02,0x02,
  0x02,0x02,0x01,0x01,0x01,0x01,0x00,0x00
};

# 113 "sqrtrem.c"
static mp_limb_t
mpn_sqrtrem1 (mp_ptr rp, mp_limb_t a0)
{



  mp_limb_t x0, t2, t, x2;
  unsigned abits;

  do { if (__builtin_expect ((!(0 == 0)) != 0, 0)) __gmp_assert_fail ("sqrtrem.c", 122, "0 == 0"); } while (0);
  do { if (__builtin_expect ((!(32 == 32 || 32 == 64)) != 0, 0)) __gmp_assert_fail ("sqrtrem.c", 123, "32 == 32 || 32 == 64"); } while (0);
  do {} while (0);





  abits = a0 >> (32 - 1 - 8);
  x0 = 0x100 | invsqrttab[abits - 0x80];
# 148 "sqrtrem.c"
  t2 = x0 * (a0 >> (16-8));
  t = t2 >> 13;
  t = ((mp_limb_signed_t) ((a0 << 6) - t * t - ((mp_limb_t) 0x100000L)) >> (16-8));
  x0 = t2 + ((mp_limb_signed_t) (x0 * t) >> 7);
  x0 >>= 16;




  x2 = x0 * x0;
  if (x2 + 2*x0 <= a0 - 1)
    {
      x2 += 2*x0 + 1;
      x0++;
    }

  *rp = a0 - x2;
  return x0;
}

# 173 "sqrtrem.c"
static mp_limb_t
mpn_sqrtrem2 (mp_ptr sp, mp_ptr rp, mp_srcptr np)
{
  mp_limb_t q, u, np0, sp0, rp0, q2;
  int cc;

  do {} while (0);

  np0 = np[0];
  sp0 = mpn_sqrtrem1 (rp, np[1]);
  rp0 = rp[0];

  rp0 = (rp0 << (((32 - 0) >> 1) - 1)) + (np0 >> (((32 - 0) >> 1) + 1));
  q = rp0 / sp0;

  q -= q >> ((32 - 0) >> 1);

  u = rp0 - q * sp0;

  sp0 = (sp0 << ((32 - 0) >> 1)) | q;
  cc = u >> (((32 - 0) >> 1) - 1);
  rp0 = ((u << (((32 - 0) >> 1) + 1)) & ((~ ((mp_limb_t) (0))) >> 0)) + (np0 & ((((mp_limb_t) 1L) << (((32 - 0) >> 1) + 1)) - 1));

  q2 = q * q;
  cc -= rp0 < q2;
  rp0 -= q2;
  if (cc < 0)
    {
      rp0 += sp0;
      cc += rp0 < sp0;
      --sp0;
      rp0 += sp0;
      cc += rp0 < sp0;
    }

  rp[0] = rp0;
  sp[0] = sp0;
  return cc;
}

# 219 "sqrtrem.c"
static mp_limb_t
mpn_dc_sqrtrem (mp_ptr sp, mp_ptr np, mp_size_t n, mp_limb_t approx, mp_ptr scratch)
{
  mp_limb_t q;
  int c, b;
  mp_size_t l, h;

  do {} while (0);

  if (n == 1)
    c = mpn_sqrtrem2 (sp, np, np);
  else
    {
      l = n / 2;
      h = n - l;
      q = mpn_dc_sqrtrem (sp + l, np + 2 * l, h, 0, scratch);
      if (q != 0)
 (__gmpn_sub_n (np + 2 * l, np + 2 * l, sp + l, h));
      ;
      __gmpn_tdiv_qr (scratch, np + l, 0, np + l, n, sp + l, h);
      q += scratch[l];
      c = scratch[0] & 1;
      __gmpn_rshift (sp, scratch, l, 1);
      sp[l - 1] |= (q << ((32 - 0) - 1)) & ((~ ((mp_limb_t) (0))) >> 0);
      if (__builtin_expect (((sp[0] & approx) != 0) != 0, 0))
 return 1;
      q >>= 1;
      if (c != 0)
 c = __gmpn_add_n (np + l, np + l, sp + l, h);
      ;
      __gmpn_sqr (np + n, sp, l);
      b = q + __gmpn_sub_n (np, np, np + n, 2 * l);
      c -= (l == h) ? b : __gmpn_sub_1 (np + 2 * l, np + 2 * l, 1, (mp_limb_t) b);

      if (c < 0)
 {
   q = __gmpn_add_1 (sp + l, sp + l, h, q);



   c += __gmpn_addmul_1 (np, sp, n, ((mp_limb_t) 2L)) + 2 * q;

   c -= __gmpn_sub_1 (np, np, n, ((mp_limb_t) 1L));
   q -= __gmpn_sub_1 (sp, sp, n, ((mp_limb_t) 1L));
 }
    }

  return c;
}

# 270 "sqrtrem.c"
static void
mpn_divappr_q (mp_ptr qp, mp_srcptr np, mp_size_t nn, mp_srcptr dp, mp_size_t dn, mp_ptr scratch)
{
  gmp_pi1_t inv;
  mp_limb_t qh;
  do {} while (0);
  do {} while (0);
  do {} while (0);

  do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (scratch, np, nn); } while (0); } while (0);
  do { mp_limb_t _v, _p, _t1, _t0, _mask; do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (_v), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(dp[dn-1]))), "rm" ((USItype)(dp[dn-1]))); } while (0); _p = (dp[dn-1]) * _v; _p += (dp[dn-2]); if (_p < (dp[dn-2])) { _v--; _mask = -(mp_limb_t) (_p >= (dp[dn-1])); _p -= (dp[dn-1]); _v += _mask; _p -= _mask & (dp[dn-1]); } __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)(dp[dn-2])), "rm" ((USItype)(_v))); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (dp[dn-1])) != 0, 0)) { if (_p > (dp[dn-1]) || _t0 >= (dp[dn-2])) _v--; } } (inv).inv32 = _v; } while (0);
  if ((! ((__builtin_constant_p (43) && (43) == 0) || (!(__builtin_constant_p (43) && (43) == 2147483647L) && (dn) >= (43)))))
    qh = __gmpn_sbpi1_divappr_q (qp, scratch, nn, dp, dn, inv.inv32);
  else if ((! ((__builtin_constant_p (667) && (667) == 0) || (!(__builtin_constant_p (667) && (667) == 2147483647L) && (dn) >= (667)))))
    qh = __gmpn_dcpi1_divappr_q (qp, scratch, nn, dp, dn, &inv);
  else
    {
      mp_size_t itch = __gmpn_mu_divappr_q_itch (nn, dn, 0);
      struct tmp_reentrant_t *__tmp_marker;
      __tmp_marker = 0;

      qh = __gmpn_mu_divappr_q (qp, np, nn, dp, dn, ((mp_limb_t *) (__builtin_expect ((((itch) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((itch) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (itch) * sizeof (mp_limb_t)))));
      do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
    }
  qp [nn - dn] = qh;
}

# 305 "sqrtrem.c"
static int
mpn_dc_sqrt (mp_ptr sp, mp_srcptr np, mp_size_t n, unsigned nsh, unsigned odd)
{
  mp_limb_t q;
  int c;
  mp_size_t l, h;
  mp_ptr qp, tp, scratch;
  struct tmp_reentrant_t *__tmp_marker;
  __tmp_marker = 0;

  do {} while (0);
  do {} while (0);
  do {} while (0);

  l = (n - 1) / 2;
  h = n - l;
  do {} while (0);
  scratch = ((mp_limb_t *) (__builtin_expect ((((l + 2 * n + 5 - 1) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((l + 2 * n + 5 - 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (l + 2 * n + 5 - 1) * sizeof (mp_limb_t))));
  tp = scratch + n + 2 - 1;
  if (nsh != 0)
    {

      int o = l > (1 + odd);
      (__gmpn_lshift (tp - o, np + l - 1 - o - odd, n + h + 1 + o, 2 * nsh));
    }
  else
    do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (tp, np + l - 1 - odd, n + h + 1); } while (0); } while (0);
  q = mpn_dc_sqrtrem (sp + l, tp + l + 1, h, 0, scratch);
  if (q != 0)
    (__gmpn_sub_n (tp + l + 1, tp + l + 1, sp + l, h));
  qp = tp + n + 1;
  ;

  mpn_divappr_q (qp, tp, n + 1, sp + l, h, scratch);



  q += qp [l + 1];
  c = 1;
  if (q > 1)
    {

      do { mp_ptr __dst = (sp); mp_size_t __n = (l); do {} while (0); do *__dst++ = (((~ ((mp_limb_t) (0))) >> 0)); while (--__n); } while (0);
    }
  else
    {

      __gmpn_rshift (sp, qp + 1, l, 1);
      sp[l - 1] |= q << ((32 - 0) - 1);
      if (((qp[0] >> (2 + 1)) |
    (qp[1] & (((~ ((mp_limb_t) (0))) >> 0) >> (((32 - 0) >> odd)- nsh - 1)))) == 0)
 {
   mp_limb_t cy;





   ;
   (__gmpn_mul (scratch, sp + l, h, qp + 1, l + 1));

   cy = __gmpn_sub_n (tp + 1, tp + 1, scratch, h);

   do { mp_ptr __ptr_dummy; if (__builtin_constant_p (cy) && (cy) == 0) { } else if (__builtin_constant_p (cy) && (cy) == 1) { __asm__ __volatile__ ("\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, (%0)\n" "\tlea\t%c2(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" : "=r" (__ptr_dummy) : "0" (tp + 1 + h), "n" (sizeof(mp_limb_t)) : "memory"); } else { __asm__ __volatile__ ( "subl" "\t%2, (%0)\n" "\tjnc\t" ".L" "asm_%=_" "done" "\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, %c3(%0)\n" "\tlea\t%c3(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" "\n" ".L" "asm_%=_" "done" ":\n" : "=r" (__ptr_dummy) : "0" (tp + 1 + h), "re" ((mp_limb_t) (cy)), "n" (sizeof(mp_limb_t)) : "memory"); } } while (0);

   do {} while (0);
   if (__gmpn_cmp (tp + 1 + h, scratch + h, l) < 0)
     {




       cy = __gmpn_addmul_1 (tp + 1, sp + l, h, ((mp_limb_t) 2L));

       (__gmpn_add_1 (tp + 1 + h, tp + 1 + h, l, cy));
       do { mp_ptr __ptr_dummy; if (__builtin_constant_p (1) && (1) == 0) { } else if (__builtin_constant_p (1) && (1) == 1) { __asm__ __volatile__ ("\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, (%0)\n" "\tlea\t%c2(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" : "=r" (__ptr_dummy) : "0" (sp), "n" (sizeof(mp_limb_t)) : "memory"); } else { __asm__ __volatile__ ( "subl" "\t%2, (%0)\n" "\tjnc\t" ".L" "asm_%=_" "done" "\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, %c3(%0)\n" "\tlea\t%c3(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" "\n" ".L" "asm_%=_" "done" ":\n" : "=r" (__ptr_dummy) : "0" (sp), "re" ((mp_limb_t) (1)), "n" (sizeof(mp_limb_t)) : "memory"); } } while (0);
     }
# 390 "sqrtrem.c"
   if (__gmpn_zero_p (tp + l + 1, h - l))
     {
       ;
       __gmpn_sqr (scratch, sp, l);
       c = __gmpn_cmp (tp + 1, scratch + l, l);
       if (c == 0)
  {
    if (nsh != 0)
      {
        __gmpn_lshift (tp, np, l, 2 * nsh);
        np = tp;
      }
    c = __gmpn_cmp (np, scratch + odd, l - odd);
  }
       if (c < 0)
  {
    do { mp_ptr __ptr_dummy; if (__builtin_constant_p (1) && (1) == 0) { } else if (__builtin_constant_p (1) && (1) == 1) { __asm__ __volatile__ ("\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, (%0)\n" "\tlea\t%c2(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" : "=r" (__ptr_dummy) : "0" (sp), "n" (sizeof(mp_limb_t)) : "memory"); } else { __asm__ __volatile__ ( "subl" "\t%2, (%0)\n" "\tjnc\t" ".L" "asm_%=_" "done" "\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, %c3(%0)\n" "\tlea\t%c3(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" "\n" ".L" "asm_%=_" "done" ":\n" : "=r" (__ptr_dummy) : "0" (sp), "re" ((mp_limb_t) (1)), "n" (sizeof(mp_limb_t)) : "memory"); } } while (0);
    c = 1;
  }
     }
 }
    }
  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);

  if ((odd | nsh) != 0)
    __gmpn_rshift (sp, sp, n, nsh + (odd ? (32 - 0) / 2 : 0));
  return c;
}

# 150 "../gmp.h"
typedef struct
{
  int _mp_alloc;

  int _mp_size;


  mp_limb_t *_mp_d;
} __mpz_struct;

# 164 "../gmp.h"
typedef __mpz_struct mpz_t[1];

# 224 "../gmp.h"
typedef const __mpz_struct *mpz_srcptr;

# 225 "../gmp.h"
typedef __mpz_struct *mpz_ptr;

# 617 "../gmp.h"
void *__gmpz_realloc (mpz_ptr, mp_size_t);

# 973 "../gmp.h"
void __gmpz_powm (mpz_ptr, mpz_srcptr, mpz_srcptr, mpz_srcptr);

# 1501 "../gmp.h"
mp_limb_t __gmpn_divrem_1 (mp_ptr, mp_size_t, mp_srcptr, mp_size_t, mp_limb_t);

# 2184 "../gmp.h"
/* extern */ __inline__

mp_limb_t
__gmpn_sub (mp_ptr __gmp_wp, mp_srcptr __gmp_xp, mp_size_t __gmp_xsize, mp_srcptr __gmp_yp, mp_size_t __gmp_ysize)
{
  mp_limb_t __gmp_c;
  do { mp_size_t __gmp_i; mp_limb_t __gmp_x; __gmp_i = (__gmp_ysize); if (__gmp_i != 0) { if (__gmpn_sub_n (__gmp_wp, __gmp_xp, __gmp_yp, __gmp_i)) { do { if (__gmp_i >= (__gmp_xsize)) { (__gmp_c) = 1; goto __gmp_done; } __gmp_x = (__gmp_xp)[__gmp_i]; } while ((((__gmp_wp)[__gmp_i++] = (__gmp_x - 1) & ((~ ((mp_limb_t) (0))) >> 0)), __gmp_x == 0)); } } if ((__gmp_wp) != (__gmp_xp)) do { mp_size_t __gmp_j; ; for (__gmp_j = (__gmp_i); __gmp_j < (__gmp_xsize); __gmp_j++) (__gmp_wp)[__gmp_j] = (__gmp_xp)[__gmp_j]; } while (0); (__gmp_c) = 0; __gmp_done: ; } while (0);
  return __gmp_c;
}

# 1425 "../gmp-impl.h"
mp_limb_t __gmpn_div_qr_2n_pi1 (mp_ptr, mp_ptr, mp_srcptr, mp_size_t, mp_limb_t, mp_limb_t, mp_limb_t);

# 1431 "../gmp-impl.h"
mp_limb_t __gmpn_sbpi1_div_qr (mp_ptr, mp_ptr, mp_size_t, mp_srcptr, mp_size_t, mp_limb_t);

# 1440 "../gmp-impl.h"
mp_limb_t __gmpn_dcpi1_div_qr (mp_ptr, mp_ptr, mp_size_t, mp_srcptr, mp_size_t, gmp_pi1_t *);

# 1453 "../gmp-impl.h"
mp_limb_t __gmpn_mu_div_qr (mp_ptr, mp_ptr, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t, mp_ptr);

# 1455 "../gmp-impl.h"
mp_size_t __gmpn_mu_div_qr_itch (mp_size_t, mp_size_t, int);

# 3880 "../gmp-impl.h"
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
  else if ((! ((__builtin_constant_p (25) && (25) == 0) || (!(__builtin_constant_p (25) && (25) == 2147483647L) && (dn) >= (25)))) ||
    (! ((__builtin_constant_p (25) && (25) == 0) || (!(__builtin_constant_p (25) && (25) == 2147483647L) && (nn - dn) >= (25)))))
    {
      __gmpn_sbpi1_div_qr (qp, np, nn, dp, dn, dinv->inv32);
    }
  else if ((! ((__builtin_constant_p (0) && (0) == 0) || (!(__builtin_constant_p (0) && (0) == 2147483647L) && (dn) >= (0)))) ||
    (! ((__builtin_constant_p (2 * 998) && (2 * 998) == 0) || (!(__builtin_constant_p (2 * 998) && (2 * 998) == 2147483647L) && (nn) >= (2 * 998)))) ||
    (double) (2 * (998 - 0)) * dn
    + (double) 0 * nn > (double) dn * nn)
    {
      __gmpn_dcpi1_div_qr (qp, np, nn, dp, dn, dinv);
    }
  else
    {



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

  rp = ((mp_limb_t *) (__builtin_expect ((((an) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((an) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (an) * sizeof (mp_limb_t))));
  scratch = ((mp_limb_t *) (__builtin_expect ((((an - mn + 1) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((an - mn + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (an - mn + 1) * sizeof (mp_limb_t))));
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


   ((r)->_mp_size) = (mn == 1 && mp[0] == 1) ? 0 : 1;
   ((r)->_mp_d)[0] = 1;
   return;
 }

      __tmp_marker = 0;



      do { do {} while (0); (m_zero_cnt) = __builtin_clzl (mp[mn - 1]); } while (0);
      m_zero_cnt -= 0;
      if (m_zero_cnt != 0)
 {
   mp_ptr new_mp = ((mp_limb_t *) (__builtin_expect ((((mn) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((mn) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (mn) * sizeof (mp_limb_t))));
   __gmpn_lshift (new_mp, mp, mn, m_zero_cnt);
   mp = new_mp;
 }

      m2 = mn == 1 ? 0 : mp[mn - 2];
      do { mp_limb_t _v, _p, _t1, _t0, _mask; do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (_v), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(mp[mn - 1]))), "rm" ((USItype)(mp[mn - 1]))); } while (0); _p = (mp[mn - 1]) * _v; _p += (m2); if (_p < (m2)) { _v--; _mask = -(mp_limb_t) (_p >= (mp[mn - 1])); _p -= (mp[mn - 1]); _v += _mask; _p -= _mask & (mp[mn - 1]); } __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)(m2)), "rm" ((USItype)(_v))); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (mp[mn - 1])) != 0, 0)) { if (_p > (mp[mn - 1]) || _t0 >= (m2)) _v--; } } (dinv).inv32 = _v; } while (0);

      bn = ((((b)->_mp_size)) >= 0 ? (((b)->_mp_size)) : -(((b)->_mp_size)));
      bp = ((b)->_mp_d);
      if (bn > mn)
 {


   mp_ptr new_bp = ((mp_limb_t *) (__builtin_expect ((((mn) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((mn) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (mn) * sizeof (mp_limb_t))));
   reduce (new_bp, bp, bn, mp, mn, &dinv);
   bp = new_bp;
   bn = mn;


   do { while ((bn) > 0) { if ((bp)[(bn) - 1] != 0) break; (bn)--; } } while (0);
 }

      if (bn == 0)
 {
   ((r)->_mp_size) = 0;
   do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
   return;
 }

      tp = ((mp_limb_t *) (__builtin_expect ((((2 * mn + 1) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((2 * mn + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (2 * mn + 1) * sizeof (mp_limb_t))));
      xp = ((mp_limb_t *) (__builtin_expect ((((mn) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((mn) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (mn) * sizeof (mp_limb_t))));
      scratch = ((mp_limb_t *) (__builtin_expect ((((mn + 1) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((mn + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (mn + 1) * sizeof (mp_limb_t))));

      do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (xp, bp, bn); } while (0); } while (0);
      xn = bn;

      e = el;
      do { do {} while (0); (c) = __builtin_clzl (e); } while (0);
      e = (e << c) << 1;
      c = 32 - 1 - c;

      if (c == 0)
 {




   if (xn == mn && __gmpn_cmp (xp, mp, mn) >= 0)
     __gmpn_sub_n (xp, xp, mp, mn);
 }
      else
 {

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
   mp = ((m)->_mp_d);
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


      mpz_t e;
      mp_limb_t ep[1];
      (ep)[0] = (el); ((e)->_mp_d) = (ep); ((e)->_mp_size) = ((ep)[0] != 0); ;;
      __gmpz_powm (r, b, e, m);
    }
}

# 145 "../gmp.h"
typedef unsigned long int mp_bitcnt_t;

# 1540 "../gmp.h"
mp_limb_t __gmpn_mul_1 (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t);

# 3158 "../gmp-impl.h"
mp_limb_t __gmpn_preinv_divrem_1 (mp_ptr, mp_size_t, mp_srcptr, mp_size_t, mp_limb_t, mp_limb_t, int);

# 4291 "../gmp-impl.h"
struct powers
{
  mp_ptr p;
  mp_size_t n;
  mp_size_t shift;
  size_t digits_in_base;
  int base;
};

# 4299 "../gmp-impl.h"
typedef struct powers powers_t;

# 149 "get_str.c"
static unsigned char *
mpn_sb_get_str (unsigned char *str, size_t len,
  mp_ptr up, mp_size_t un, int base)
{
  mp_limb_t rl, ul;
  unsigned char *s;
  size_t l;
# 164 "get_str.c"
  unsigned char buf[(21 * 32 * 7 / 11)];



  mp_limb_t rp[21];


  if (base == 10)
    {



      do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (rp + 1, up, un); } while (0); } while (0);

      s = buf + (21 * 32 * 7 / 11);
      while (un > 1)
 {
   int i;
   mp_limb_t frac, digit;
   __gmpn_preinv_divrem_1 (rp, (mp_size_t) 1, rp + 1, un, ((mp_limb_t) 0x3b9aca00L), ((mp_limb_t) 0x12e0be82L), 2)


                                      ;
   un -= rp[un] == 0;
   frac = (rp[0] + 1) << 0;
   s -= 9;



   i = 9;
   do
     {
       __asm__ ("mull %3" : "=a" (frac), "=d" (digit) : "%0" ((USItype)(frac)), "rm" ((USItype)(10)));
       *s++ = digit;
     }
   while (--i);
# 237 "get_str.c"
   s -= 9;
 }

      ul = rp[1];
      while (ul != 0)
 {
   do { mp_limb_t __q = (ul) / (10); mp_limb_t __r = (ul) % (10); (ul) = __q; (rl) = __r; } while (0);
   *--s = rl;
 }
    }
  else
    {
      unsigned chars_per_limb;
      mp_limb_t big_base, big_base_inverted;
      unsigned normalization_steps;

      chars_per_limb = __gmpn_bases[base].chars_per_limb;
      big_base = __gmpn_bases[base].big_base;
      big_base_inverted = __gmpn_bases[base].big_base_inverted;
      do { do {} while (0); (normalization_steps) = __builtin_clzl (big_base); } while (0);

      do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (rp + 1, up, un); } while (0); } while (0);

      s = buf + (21 * 32 * 7 / 11);
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
       __asm__ ("mull %3" : "=a" (frac), "=d" (digit) : "%0" ((USItype)(frac)), "rm" ((USItype)(base)));
       *s++ = digit;
     }
   while (--i);
   s -= chars_per_limb;
 }

      ul = rp[1];
      while (ul != 0)
 {
   do { mp_limb_t __q = (ul) / (base); mp_limb_t __r = (ul) % (base); (ul) = __q; (rl) = __r; } while (0);
   *--s = rl;
 }
    }

  l = buf + (21 * 32 * 7 / 11) - s;
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
  if ((! ((__builtin_constant_p (12) && (12) == 0) || (!(__builtin_constant_p (12) && (12) == 2147483647L) && (un) >= (12)))))
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
   qp = tmp;
   rp = up;

   __gmpn_tdiv_qr (qp, rp + sn, 0L, up + sn, un - sn, pwp, pwn);
   qn = un - sn - pwn; qn += qp[qn] != 0;

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


  if (un == 0)
    {
      str[0] = 0;
      return 1;
    }

  if ((((base) & ((base) - 1)) == 0))
    {

      mp_limb_t n1, n0;
      int bits_per_digit = __gmpn_bases[base].big_base;
      int cnt;
      int bit_pos;
      mp_size_t i;
      unsigned char *s = str;
      mp_bitcnt_t bits;

      n1 = up[un - 1];
      do { do {} while (0); (cnt) = __builtin_clzl (n1); } while (0);





      bits = (mp_bitcnt_t) (32 - 0) * un - cnt + 0;
      cnt = bits % bits_per_digit;
      if (cnt != 0)
 bits += bits_per_digit - cnt;
      bit_pos = bits - (mp_bitcnt_t) (un - 1) * (32 - 0);


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



  if ((! ((__builtin_constant_p (21) && (21) == 0) || (!(__builtin_constant_p (21) && (21) == 2147483647L) && (un) >= (21)))))
    return mpn_sb_get_str (str, (size_t) 0, up, un, base) - str;

  __tmp_marker = 0;


  powtab_mem = ((mp_limb_t *) __gmp_tmp_reentrant_alloc (&__tmp_marker, (((un) + 2 * 32)) * sizeof (mp_limb_t)));
  powtab_mem_ptr = powtab_mem;



  big_base = __gmpn_bases[base].big_base;
  digits_in_base = __gmpn_bases[base].chars_per_limb;

  {
    mp_size_t n_pows, xn, pn, exptab[32], bexp;
    mp_limb_t cy;
    mp_size_t shift;
    size_t ndig;

    do { mp_limb_t _ph, _dummy; __asm__ ("mull %3" : "=a" (_dummy), "=d" (_ph) : "%0" ((USItype)(__gmpn_bases[base].logb2)), "rm" ((USItype)((32 - 0) * (mp_limb_t) (un)))); ndig = _ph; } while (0);
    xn = 1 + ndig / __gmpn_bases[base].chars_per_limb;

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


  tmp = ((mp_limb_t *) __gmp_tmp_reentrant_alloc (&__tmp_marker, (((un) + 32)) * sizeof (mp_limb_t)));
  out_len = mpn_dc_get_str (str, 0, up, un, powtab + (pi - 1), tmp) - str;
  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);

  return out_len;
}

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


  if (e == 0)
    {
      ((r)->_mp_d)[0] = 1;
      ((r)->_mp_size) = 1;
      return;
    }


  if (bsize == 0)
    {
      ((r)->_mp_size) = 0;
      return;
    }


  rneg = (bsize < 0 && (e & 1) != 0);
  bsize = ((bsize) >= 0 ? (bsize) : -(bsize));
  ;

  r_bp_overlap = (((r)->_mp_d) == bp);


  rtwos_limbs = 0;
  for (blimb = *bp; blimb == 0; blimb = *++bp)
    {
      rtwos_limbs += e;
      bsize--; do {} while (0);
    }
  ;


  do { do {} while (0); (btwos) = __builtin_ctzl (blimb); } while (0);
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
   mp_ptr tp = ((mp_limb_t *) (__builtin_expect ((((bsize) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((bsize) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (bsize) * sizeof (mp_limb_t))));
   do { if ((btwos) == 0) do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (tp, bp, bsize); } while (0); } while (0); else { __gmpn_rshift (tp, bp, bsize, btwos); (bsize) -= ((tp)[(bsize)-1] == 0); } } while (0);
   bp = tp;
   ;
 }




      blimb = bp[bsize-1];

     
                                 ;
    }
# 370 "n_pow_ui.c"
  do {} while (0);
  do { do {} while (0); (cnt) = __builtin_clzl (blimb); } while (0);
  ralloc = (bsize*(32 - 0) - cnt + 0) * e / (32 - 0) + 5;
 
                              ;
  rp = (__builtin_expect (((ralloc + rtwos_limbs) > ((r)->_mp_alloc)) != 0, 0) ? (mp_ptr) __gmpz_realloc(r,ralloc + rtwos_limbs) : ((r)->_mp_d));


  do { do {} while (0); if ((rtwos_limbs) != 0) do { mp_ptr __dst = (rp); mp_size_t __n = (rtwos_limbs); do {} while (0); do *__dst++ = (((mp_limb_t) 0L)); while (--__n); } while (0); } while (0);
  rp += rtwos_limbs;

  if (e == 0)
    {


      rp[0] = rl;
      rsize = 1;




      do {} while (0);
    }
  else
    {
      mp_ptr tp;
      mp_size_t talloc;
# 406 "n_pow_ui.c"
      talloc = ralloc;




      if (bsize <= 1 || (e & 1) == 0)
 talloc /= 2;

      ;
      tp = ((mp_limb_t *) (__builtin_expect ((((talloc) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((talloc) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (talloc) * sizeof (mp_limb_t))));



      do { do {} while (0); (cnt) = __builtin_clzl ((mp_limb_t) e); } while (0);
      i = 32 - cnt - 2;
# 465 "n_pow_ui.c"
      if (bsize == 1)
 {

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


   do { char __p; unsigned long __n = (e); __n ^= (__n >> 16); __asm__ ("xorb %h1, %b1\n\t" "setpo %0" : "=Qm" (__p), "=Q" (__n) : "1" (__n)); (parity) = __p; } while (0);
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


  if (rtwos_bits != 0)
    {
      do { mp_limb_t cy; do {} while (0); cy = __gmpn_lshift (rp, rp, rsize, (unsigned) rtwos_bits); (rp)[rsize] = cy; (rsize) += (cy != 0); } while (0);
      ;
    }

  rsize += rtwos_limbs;
  ((r)->_mp_size) = (rneg ? -rsize : rsize);
}

# 227 "../gmp.h"
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



      mp_limb_t vl_shifted = vl << 0;
      mp_limb_t hi, lo, next_lo, sum;
      mp_size_t i;


      i = excess - 1;
      __asm__ ("mull %3" : "=a" (lo), "=d" (cin) : "%0" ((USItype)(up[i])), "rm" ((USItype)(vl_shifted)));


      for (;;)
        {
          i--;
          if (i < 0)
            break;

          __asm__ ("mull %3" : "=a" (next_lo), "=d" (hi) : "%0" ((USItype)(up[i])), "rm" ((USItype)(vl_shifted)));
          lo >>= 0;
          do { mp_limb_t __x = (hi); mp_limb_t __y = (lo); mp_limb_t __w = __x + __y; (sum) = __w; (cbit) = __w < __x; } while (0);
          cin += cbit;
          lo = next_lo;





          if (__builtin_expect ((sum != ((~ ((mp_limb_t) (0))) >> 0)) != 0, 1))
            break;
        }

      up += excess;
      size = prec;
    }

  rp = r->_mp_d;



  cy_limb = __gmpn_mul_1 (rp, up, size, vl);
  do { mp_size_t __gmp_i; mp_limb_t __gmp_x, __gmp_r; __gmp_x = (rp)[0]; __gmp_r = __gmp_x + (cin); (rp)[0] = __gmp_r; if (((__gmp_r) < ((cin)))) { (cbit) = 1; for (__gmp_i = 1; __gmp_i < (size);) { __gmp_x = (rp)[__gmp_i]; __gmp_r = __gmp_x + 1; (rp)[__gmp_i] = __gmp_r; ++__gmp_i; if (!((__gmp_r) < (1))) { if ((rp) != (rp)) do { mp_size_t __gmp_j; ; for (__gmp_j = (__gmp_i); __gmp_j < (size); __gmp_j++) (rp)[__gmp_j] = (rp)[__gmp_j]; } while (0); (cbit) = 0; break; } } } else { if ((rp) != (rp)) do { mp_size_t __gmp_j; ; for (__gmp_j = (1); __gmp_j < (size); __gmp_j++) (rp)[__gmp_j] = (rp)[__gmp_j]; } while (0); (cbit) = 0; } } while (0);
  cy_limb += cbit;

  rp[size] = cy_limb;
  cy_limb = cy_limb != 0;
  r->_mp_exp = u->_mp_exp + cy_limb;
  size += cy_limb;
  r->_mp_size = usize >= 0 ? size : -size;
}

# 696 "../gmp-impl.h"
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
  do {} while (0);

  if (countp == ((void*)0))
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
  do { int __cnt; mp_bitcnt_t __totbits; do {} while (0); do {} while (0); do { do {} while (0); (__cnt) = __builtin_clzl ((zp)[(zsize)-1]); } while (0); __totbits = (mp_bitcnt_t) (zsize) * (32 - 0) - (__cnt - 0); (count) = (__totbits + (numb)-1) / (numb); } while (0);
  *countp = count;

  if (data == ((void*)0))
    data = (*__gmp_allocate_func) (count*size);

  if (endian == 0)
    endian = (-1);

  align = ((char *) data - (char *) ((void*)0)) % sizeof (mp_limb_t);

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
       do { mp_ptr __dst = ((mp_ptr) data); mp_srcptr __src = (zp); mp_size_t __size = ((mp_size_t) count); mp_size_t __i; do {} while (0); do {} while (0); ; for (__i = 0; __i < __size; __i++) { do { __asm__ ("bswap %0" : "=r" (*__dst) : "0" (*(__src))); } while (0); __dst++; __src++; } } while (0);
       return data;
     }
   if (order == 1 && endian == -(-1))
     {
       do { mp_ptr __dst = ((mp_ptr) data); mp_size_t __size = ((mp_size_t) count); mp_srcptr __src = (zp) + __size - 1; mp_size_t __i; do {} while (0); do {} while (0); ; for (__i = 0; __i < __size; __i++) { do { __asm__ ("bswap %0" : "=r" (*__dst) : "0" (*(__src))); } while (0); __dst++; __src--; } } while (0);
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


    wbytes = numb / 8;


    wbits = numb % 8;
    wbitsmask = (((mp_limb_t) 1L) << wbits) - 1;


    woffset = (endian >= 0 ? size : - (mp_size_t) size)
      + (order < 0 ? size : - (mp_size_t) size);


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


    do {} while (0)

                                                ;
  }
  return data;
}

# 1566 "../gmp.h"
mp_size_t __gmpn_pow_1 (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t, mp_ptr);

# 1560 "../gmp-impl.h"
void __gmpn_powlo (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t, mp_size_t, mp_ptr);

# 51 "perfpow.c"
static int
pow_equals (mp_srcptr np, mp_size_t n,
     mp_srcptr xp,mp_size_t xn,
     mp_limb_t k, mp_bitcnt_t f,
     mp_ptr tp)
{
  mp_bitcnt_t y, z;
  mp_size_t bn;
  mp_limb_t h, l;

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






  do { int __cnt; mp_bitcnt_t __totbits; do {} while (0); do {} while (0); do { do {} while (0); (__cnt) = __builtin_clzl ((xp)[(xn)-1]); } while (0); __totbits = (mp_bitcnt_t) (xn) * (32 - 0) - (__cnt - 0); (y) = (__totbits + (1)-1) / (1); } while (0);
  y -= 1;

  __asm__ ("mull %3" : "=a" (l), "=d" (h) : "%0" ((USItype)(k)), "rm" ((USItype)(y)));
  h -= l == 0; --l;

  z = f - 1;
  if (h == 0 && l <= z)
    {
      mp_limb_t *tp2;
      mp_size_t i;
      int ans;
      mp_limb_t size;
      struct tmp_reentrant_t *__tmp_marker;

      size = l + k;
      do { if (__builtin_expect ((!(size >= k)) != 0, 0)) __gmp_assert_fail ("perfpow.c", 97, "size >= k"); } while (0);

      __tmp_marker = 0;
      y = 2 + size / 32;
      tp2 = ((mp_limb_t *) (__builtin_expect ((((y) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((y) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (y) * sizeof (mp_limb_t))));

      i = __gmpn_pow_1 (tp, xp, xn, k, tp2);
      if (i == n && __gmpn_cmp (tp, np, n) == 0)
 ans = 1;
      else
 ans = 0;
      do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
      return ans;
    }

  return 0;
}

# 1504 "../gmp.h"
mp_limb_t __gmpn_divrem_2 (mp_ptr, mp_size_t, mp_ptr, mp_size_t, mp_srcptr);

# 1434 "../gmp-impl.h"
mp_limb_t __gmpn_sbpi1_div_q (mp_ptr, mp_ptr, mp_size_t, mp_srcptr, mp_size_t, mp_limb_t);

# 1445 "../gmp-impl.h"
mp_limb_t __gmpn_dcpi1_div_q (mp_ptr, mp_ptr, mp_size_t, mp_srcptr, mp_size_t, gmp_pi1_t *);

# 1475 "../gmp-impl.h"
mp_limb_t __gmpn_mu_div_q (mp_ptr, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t, mp_ptr);

# 1477 "../gmp-impl.h"
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

  do { if (__builtin_expect ((!(5 >= 2)) != 0, 0)) __gmp_assert_fail ("div_q.c", 120, "5 >= 2"); } while (0);

  if (dn == 1)
    {
      __gmpn_divrem_1 (qp, 0L, np, nn, dp[dn - 1]);
      return;
    }

  qn = nn - dn + 1;

  if (qn + 5 >= dn)
    {


      new_np = scratch;

      dh = dp[dn - 1];
      if (__builtin_expect (((dh & (((mp_limb_t) 1L) << ((32 - 0)-1))) == 0) != 0, 1))
 {
   do { do {} while (0); (cnt) = __builtin_clzl (dh); } while (0);

   cy = __gmpn_lshift (new_np, np, nn, cnt);
   new_np[nn] = cy;
   new_nn = nn + (cy != 0);

   new_dp = ((mp_limb_t *) (__builtin_expect ((((dn) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((dn) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (dn) * sizeof (mp_limb_t))));
   __gmpn_lshift (new_dp, dp, dn, cnt);

   if (dn == 2)
     {
       qh = __gmpn_divrem_2 (qp, 0L, new_np, new_nn, new_dp);
     }
   else if ((! ((__builtin_constant_p (43) && (43) == 0) || (!(__builtin_constant_p (43) && (43) == 2147483647L) && (dn) >= (43)))) ||
     (! ((__builtin_constant_p (43) && (43) == 0) || (!(__builtin_constant_p (43) && (43) == 2147483647L) && (new_nn - dn) >= (43)))))
     {
       do { mp_limb_t _v, _p, _t1, _t0, _mask; do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (_v), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(new_dp[dn - 1]))), "rm" ((USItype)(new_dp[dn - 1]))); } while (0); _p = (new_dp[dn - 1]) * _v; _p += (new_dp[dn - 2]); if (_p < (new_dp[dn - 2])) { _v--; _mask = -(mp_limb_t) (_p >= (new_dp[dn - 1])); _p -= (new_dp[dn - 1]); _v += _mask; _p -= _mask & (new_dp[dn - 1]); } __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)(new_dp[dn - 2])), "rm" ((USItype)(_v))); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (new_dp[dn - 1])) != 0, 0)) { if (_p > (new_dp[dn - 1]) || _t0 >= (new_dp[dn - 2])) _v--; } } (dinv).inv32 = _v; } while (0);
       qh = __gmpn_sbpi1_div_q (qp, new_np, new_nn, new_dp, dn, dinv.inv32);
     }
   else if ((! ((__builtin_constant_p (0) && (0) == 0) || (!(__builtin_constant_p (0) && (0) == 2147483647L) && (dn) >= (0)))) ||
     (! ((__builtin_constant_p (2 * 667) && (2 * 667) == 0) || (!(__builtin_constant_p (2 * 667) && (2 * 667) == 2147483647L) && (nn) >= (2 * 667)))) ||
     (double) (2 * (667 - 0)) * dn
     + (double) 0 * nn > (double) dn * nn)
     {
       do { mp_limb_t _v, _p, _t1, _t0, _mask; do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (_v), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(new_dp[dn - 1]))), "rm" ((USItype)(new_dp[dn - 1]))); } while (0); _p = (new_dp[dn - 1]) * _v; _p += (new_dp[dn - 2]); if (_p < (new_dp[dn - 2])) { _v--; _mask = -(mp_limb_t) (_p >= (new_dp[dn - 1])); _p -= (new_dp[dn - 1]); _v += _mask; _p -= _mask & (new_dp[dn - 1]); } __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)(new_dp[dn - 2])), "rm" ((USItype)(_v))); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (new_dp[dn - 1])) != 0, 0)) { if (_p > (new_dp[dn - 1]) || _t0 >= (new_dp[dn - 2])) _v--; } } (dinv).inv32 = _v; } while (0);
       qh = __gmpn_dcpi1_div_q (qp, new_np, new_nn, new_dp, dn, &dinv);
     }
   else
     {
       mp_size_t itch = __gmpn_mu_div_q_itch (new_nn, dn, 0);
       mp_ptr scratch = ((mp_limb_t *) (__builtin_expect ((((itch) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((itch) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (itch) * sizeof (mp_limb_t))));
       qh = __gmpn_mu_div_q (qp, new_np, new_nn, new_dp, dn, scratch);
     }
   if (cy == 0)
     qp[qn - 1] = qh;
   else if (__builtin_expect ((qh != 0) != 0, 0))
     {


       mp_size_t i, n;
       n = new_nn - dn;
       for (i = 0; i < n; i++)
  qp[i] = ((~ ((mp_limb_t) (0))) >> 0);
       qh = 0;
     }
 }
      else
 {
   if (new_np != np)
     do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (new_np, np, nn); } while (0); } while (0);

   if (dn == 2)
     {
       qh = __gmpn_divrem_2 (qp, 0L, new_np, nn, dp);
     }
   else if ((! ((__builtin_constant_p (43) && (43) == 0) || (!(__builtin_constant_p (43) && (43) == 2147483647L) && (dn) >= (43)))) ||
     (! ((__builtin_constant_p (43) && (43) == 0) || (!(__builtin_constant_p (43) && (43) == 2147483647L) && (nn - dn) >= (43)))))
     {
       do { mp_limb_t _v, _p, _t1, _t0, _mask; do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (_v), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(dh))), "rm" ((USItype)(dh))); } while (0); _p = (dh) * _v; _p += (dp[dn - 2]); if (_p < (dp[dn - 2])) { _v--; _mask = -(mp_limb_t) (_p >= (dh)); _p -= (dh); _v += _mask; _p -= _mask & (dh); } __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)(dp[dn - 2])), "rm" ((USItype)(_v))); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (dh)) != 0, 0)) { if (_p > (dh) || _t0 >= (dp[dn - 2])) _v--; } } (dinv).inv32 = _v; } while (0);
       qh = __gmpn_sbpi1_div_q (qp, new_np, nn, dp, dn, dinv.inv32);
     }
   else if ((! ((__builtin_constant_p (0) && (0) == 0) || (!(__builtin_constant_p (0) && (0) == 2147483647L) && (dn) >= (0)))) ||
     (! ((__builtin_constant_p (2 * 667) && (2 * 667) == 0) || (!(__builtin_constant_p (2 * 667) && (2 * 667) == 2147483647L) && (nn) >= (2 * 667)))) ||
     (double) (2 * (667 - 0)) * dn
     + (double) 0 * nn > (double) dn * nn)
     {
       do { mp_limb_t _v, _p, _t1, _t0, _mask; do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (_v), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(dh))), "rm" ((USItype)(dh))); } while (0); _p = (dh) * _v; _p += (dp[dn - 2]); if (_p < (dp[dn - 2])) { _v--; _mask = -(mp_limb_t) (_p >= (dh)); _p -= (dh); _v += _mask; _p -= _mask & (dh); } __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)(dp[dn - 2])), "rm" ((USItype)(_v))); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (dh)) != 0, 0)) { if (_p > (dh) || _t0 >= (dp[dn - 2])) _v--; } } (dinv).inv32 = _v; } while (0);
       qh = __gmpn_dcpi1_div_q (qp, new_np, nn, dp, dn, &dinv);
     }
   else
     {
       mp_size_t itch = __gmpn_mu_div_q_itch (nn, dn, 0);
       mp_ptr scratch = ((mp_limb_t *) (__builtin_expect ((((itch) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((itch) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (itch) * sizeof (mp_limb_t))));
       qh = __gmpn_mu_div_q (qp, np, nn, dp, dn, scratch);
     }
   qp[nn - dn] = qh;
 }
    }
  else
    {


      tp = ((mp_limb_t *) (__builtin_expect ((((qn + 1) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((qn + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (qn + 1) * sizeof (mp_limb_t))));

      new_np = scratch;
      new_nn = 2 * qn + 1;
      if (new_np == np)


 new_np = ((mp_limb_t *) (__builtin_expect ((((new_nn + 1) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((new_nn + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (new_nn + 1) * sizeof (mp_limb_t))));


      dh = dp[dn - 1];
      if (__builtin_expect (((dh & (((mp_limb_t) 1L) << ((32 - 0)-1))) == 0) != 0, 1))
 {
   do { do {} while (0); (cnt) = __builtin_clzl (dh); } while (0);

   cy = __gmpn_lshift (new_np, np + nn - new_nn, new_nn, cnt);
   new_np[new_nn] = cy;

   new_nn += (cy != 0);

   new_dp = ((mp_limb_t *) (__builtin_expect ((((qn + 1) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((qn + 1) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (qn + 1) * sizeof (mp_limb_t))));
   __gmpn_lshift (new_dp, dp + dn - (qn + 1), qn + 1, cnt);
   new_dp[0] |= dp[dn - (qn + 1) - 1] >> ((32 - 0) - cnt);

   if (qn + 1 == 2)
     {
       qh = __gmpn_divrem_2 (tp, 0L, new_np, new_nn, new_dp);
     }
   else if ((! ((__builtin_constant_p (43 - 1) && (43 - 1) == 0) || (!(__builtin_constant_p (43 - 1) && (43 - 1) == 2147483647L) && (qn) >= (43 - 1)))))
     {
       do { mp_limb_t _v, _p, _t1, _t0, _mask; do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (_v), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(new_dp[qn]))), "rm" ((USItype)(new_dp[qn]))); } while (0); _p = (new_dp[qn]) * _v; _p += (new_dp[qn - 1]); if (_p < (new_dp[qn - 1])) { _v--; _mask = -(mp_limb_t) (_p >= (new_dp[qn])); _p -= (new_dp[qn]); _v += _mask; _p -= _mask & (new_dp[qn]); } __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)(new_dp[qn - 1])), "rm" ((USItype)(_v))); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (new_dp[qn])) != 0, 0)) { if (_p > (new_dp[qn]) || _t0 >= (new_dp[qn - 1])) _v--; } } (dinv).inv32 = _v; } while (0);
       qh = __gmpn_sbpi1_divappr_q (tp, new_np, new_nn, new_dp, qn + 1, dinv.inv32);
     }
   else if ((! ((__builtin_constant_p (667 - 1) && (667 - 1) == 0) || (!(__builtin_constant_p (667 - 1) && (667 - 1) == 2147483647L) && (qn) >= (667 - 1)))))
     {
       do { mp_limb_t _v, _p, _t1, _t0, _mask; do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (_v), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(new_dp[qn]))), "rm" ((USItype)(new_dp[qn]))); } while (0); _p = (new_dp[qn]) * _v; _p += (new_dp[qn - 1]); if (_p < (new_dp[qn - 1])) { _v--; _mask = -(mp_limb_t) (_p >= (new_dp[qn])); _p -= (new_dp[qn]); _v += _mask; _p -= _mask & (new_dp[qn]); } __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)(new_dp[qn - 1])), "rm" ((USItype)(_v))); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (new_dp[qn])) != 0, 0)) { if (_p > (new_dp[qn]) || _t0 >= (new_dp[qn - 1])) _v--; } } (dinv).inv32 = _v; } while (0);
       qh = __gmpn_dcpi1_divappr_q (tp, new_np, new_nn, new_dp, qn + 1, &dinv);
     }
   else
     {
       mp_size_t itch = __gmpn_mu_divappr_q_itch (new_nn, qn + 1, 0);
       mp_ptr scratch = ((mp_limb_t *) (__builtin_expect ((((itch) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((itch) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (itch) * sizeof (mp_limb_t))));
       qh = __gmpn_mu_divappr_q (tp, new_np, new_nn, new_dp, qn + 1, scratch);
     }
   if (cy == 0)
     tp[qn] = qh;
   else if (__builtin_expect ((qh != 0) != 0, 0))
     {


       mp_size_t i, n;
       n = new_nn - (qn + 1);
       for (i = 0; i < n; i++)
  tp[i] = ((~ ((mp_limb_t) (0))) >> 0);
       qh = 0;
     }
 }
      else
 {
   do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (new_np, np + nn - new_nn, new_nn); } while (0); } while (0);

   new_dp = (mp_ptr) dp + dn - (qn + 1);

   if (qn == 2 - 1)
     {
       qh = __gmpn_divrem_2 (tp, 0L, new_np, new_nn, new_dp);
     }
   else if ((! ((__builtin_constant_p (43 - 1) && (43 - 1) == 0) || (!(__builtin_constant_p (43 - 1) && (43 - 1) == 2147483647L) && (qn) >= (43 - 1)))))
     {
       do { mp_limb_t _v, _p, _t1, _t0, _mask; do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (_v), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(dh))), "rm" ((USItype)(dh))); } while (0); _p = (dh) * _v; _p += (new_dp[qn - 1]); if (_p < (new_dp[qn - 1])) { _v--; _mask = -(mp_limb_t) (_p >= (dh)); _p -= (dh); _v += _mask; _p -= _mask & (dh); } __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)(new_dp[qn - 1])), "rm" ((USItype)(_v))); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (dh)) != 0, 0)) { if (_p > (dh) || _t0 >= (new_dp[qn - 1])) _v--; } } (dinv).inv32 = _v; } while (0);
       qh = __gmpn_sbpi1_divappr_q (tp, new_np, new_nn, new_dp, qn + 1, dinv.inv32);
     }
   else if ((! ((__builtin_constant_p (667 - 1) && (667 - 1) == 0) || (!(__builtin_constant_p (667 - 1) && (667 - 1) == 2147483647L) && (qn) >= (667 - 1)))))
     {
       do { mp_limb_t _v, _p, _t1, _t0, _mask; do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (_v), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(dh))), "rm" ((USItype)(dh))); } while (0); _p = (dh) * _v; _p += (new_dp[qn - 1]); if (_p < (new_dp[qn - 1])) { _v--; _mask = -(mp_limb_t) (_p >= (dh)); _p -= (dh); _v += _mask; _p -= _mask & (dh); } __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)(new_dp[qn - 1])), "rm" ((USItype)(_v))); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (dh)) != 0, 0)) { if (_p > (dh) || _t0 >= (new_dp[qn - 1])) _v--; } } (dinv).inv32 = _v; } while (0);
       qh = __gmpn_dcpi1_divappr_q (tp, new_np, new_nn, new_dp, qn + 1, &dinv);
     }
   else
     {
       mp_size_t itch = __gmpn_mu_divappr_q_itch (new_nn, qn + 1, 0);
       mp_ptr scratch = ((mp_limb_t *) (__builtin_expect ((((itch) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((itch) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (itch) * sizeof (mp_limb_t))));
       qh = __gmpn_mu_divappr_q (tp, new_np, new_nn, new_dp, qn + 1, scratch);
     }
   tp[qn] = qh;
 }

      do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (qp, tp + 1, qn); } while (0); } while (0);
      if (tp[0] <= 4)
        {
   mp_size_t rn;

          rp = ((mp_limb_t *) (__builtin_expect ((((dn + qn) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((dn + qn) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (dn + qn) * sizeof (mp_limb_t))));
          __gmpn_mul (rp, dp, dn, tp + 1, qn);
   rn = dn + qn;
   rn -= rp[rn - 1] == 0;

          if (rn > nn || __gmpn_cmp (np, rp, nn) < 0)
            do { mp_ptr __ptr_dummy; if (__builtin_constant_p (1) && (1) == 0) { } else if (__builtin_constant_p (1) && (1) == 1) { __asm__ __volatile__ ("\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, (%0)\n" "\tlea\t%c2(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" : "=r" (__ptr_dummy) : "0" (qp), "n" (sizeof(mp_limb_t)) : "memory"); } else { __asm__ __volatile__ ( "subl" "\t%2, (%0)\n" "\tjnc\t" ".L" "asm_%=_" "done" "\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, %c3(%0)\n" "\tlea\t%c3(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" "\n" ".L" "asm_%=_" "done" ":\n" : "=r" (__ptr_dummy) : "0" (qp), "re" ((mp_limb_t) (1)), "n" (sizeof(mp_limb_t)) : "memory"); } } while (0);
        }
    }

  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
}

# 49 "import.c"
void
__gmpz_import (mpz_ptr z, size_t count, int order,
     size_t size, int endian, size_t nail, const void *data)
{
  mp_size_t zsize;
  mp_ptr zp;

  do {} while (0);
  do {} while (0);
  do {} while (0);

  zsize = (((count * (8*size - nail)) + ((32 - 0) - 1)) / (32 - 0));
  zp = (__builtin_expect (((zsize) > ((z)->_mp_alloc)) != 0, 0) ? (mp_ptr) __gmpz_realloc(z,zsize) : ((z)->_mp_d));

  if (endian == 0)
    endian = (-1);



  if (nail == 0 && 0 == 0)
    {
      unsigned align = ((char *) data - (char *) ((void*)0)) % sizeof (mp_limb_t);

      if (order == -1
   && size == sizeof (mp_limb_t)
   && endian == (-1)
   && align == 0)
 {
   do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (zp, (mp_srcptr) data, (mp_size_t) count); } while (0); } while (0);
   goto done;
 }

      if (order == -1
   && size == sizeof (mp_limb_t)
   && endian == - (-1)
   && align == 0)
 {
   do { mp_ptr __dst = (zp); mp_srcptr __src = ((mp_srcptr) data); mp_size_t __size = ((mp_size_t) count); mp_size_t __i; do {} while (0); do {} while (0); ; for (__i = 0; __i < __size; __i++) { do { __asm__ ("bswap %0" : "=r" (*__dst) : "0" (*(__src))); } while (0); __dst++; __src++; } } while (0);
   goto done;
 }

      if (order == 1
   && size == sizeof (mp_limb_t)
   && endian == (-1)
   && align == 0)
 {
   do { mp_ptr __dst = (zp); mp_size_t __size = ((mp_size_t) count); mp_srcptr __src = ((mp_srcptr) data) + __size - 1; mp_size_t __i; do {} while (0); do {} while (0); ; for (__i = 0; __i < __size; __i++) { *__dst = *__src; __dst++; __src--; } } while (0);
   goto done;
 }
    }

  {
    mp_limb_t limb, byte, wbitsmask;
    size_t i, j, numb, wbytes;
    mp_size_t woffset;
    unsigned char *dp;
    int lbits, wbits;

    numb = size * 8 - nail;


    wbytes = numb / 8;


    wbits = numb % 8;
    wbitsmask = (((mp_limb_t) 1L) << wbits) - 1;


    woffset = (numb + 7) / 8;
    woffset = (endian >= 0 ? woffset : -woffset)
      + (order < 0 ? size : - (mp_size_t) size);


    dp = (unsigned char *) data
      + (order >= 0 ? (count-1)*size : 0) + (endian >= 0 ? size-1 : 0);
# 141 "import.c"
    limb = 0;
    lbits = 0;
    for (i = 0; i < count; i++)
      {
 for (j = 0; j < wbytes; j++)
   {
     byte = *dp;
     dp -= endian;
     do { do {} while (0); do {} while (0); limb |= (mp_limb_t) byte << lbits; lbits += (8); if (lbits >= (32 - 0)) { *zp++ = limb & ((~ ((mp_limb_t) (0))) >> 0); lbits -= (32 - 0); do {} while (0); limb = byte >> ((8) - lbits); } } while (0);
   }
 if (wbits != 0)
   {
     byte = *dp & wbitsmask;
     dp -= endian;
     do { do {} while (0); do {} while (0); limb |= (mp_limb_t) byte << lbits; lbits += (wbits); if (lbits >= (32 - 0)) { *zp++ = limb & ((~ ((mp_limb_t) (0))) >> 0); lbits -= (32 - 0); do {} while (0); limb = byte >> ((wbits) - lbits); } } while (0);
   }
 dp += woffset;
      }

    if (lbits != 0)
      {
 do {} while (0);
 do {} while (0);
 *zp++ = limb;
      }

    do {} while (0);


    do {} while (0)

                                                ;

  }

 done:
  zp = ((z)->_mp_d);
  do { while ((zsize) > 0) { if ((zp)[(zsize) - 1] != 0) break; (zsize)--; } } while (0);
  ((z)->_mp_size) = zsize;
}

# 171 "div_qr_2.c"
static void
invert_4by2 (mp_ptr di, mp_limb_t d1, mp_limb_t d0)
{
  mp_limb_t v1, v0, p1, t1, t0, p0, mask;
  do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (v1), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(d1))), "rm" ((USItype)(d1))); } while (0);
  p1 = d1 * v1;

  p1 += d0;
  if (p1 < d0)
    {
      v1--;
      mask = -(mp_limb_t) (p1 >= d1);
      p1 -= d1;
      v1 += mask;
      p1 -= mask & d1;
    }

  __asm__ ("mull %3" : "=a" (p0), "=d" (t1) : "%0" ((USItype)(d0)), "rm" ((USItype)(v1)));
  p1 += t1;
  if (p1 < t1)
    {
      if (__builtin_expect ((p1 >= d1) != 0, 0))
 {
   if (p1 > d1 || p0 >= d0)
     {
       __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (p1), "=&r" (p0) : "0" ((USItype)(p1)), "g" ((USItype)(d1)), "1" ((USItype)(p0)), "g" ((USItype)(d0)));
       v1--;
     }
 }
      __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (p1), "=&r" (p0) : "0" ((USItype)(p1)), "g" ((USItype)(d1)), "1" ((USItype)(p0)), "g" ((USItype)(d0)));
      v1--;
    }
# 212 "div_qr_2.c"
  do { mp_limb_t _q0, _t1, _t0, _mask; __asm__ ("mull %3" : "=a" (_q0), "=d" ((v0)) : "%0" ((USItype)((~p1))), "rm" ((USItype)((v1)))); __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" ((v0)), "=&r" (_q0) : "0" ((USItype)((v0))), "g" ((USItype)((~p1))), "%1" ((USItype)(_q0)), "g" ((USItype)((~p0)))); (t1) = (~p0) - (d1) * (v0); __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((t1)), "=&r" ((t0)) : "0" ((USItype)((t1))), "g" ((USItype)((d1))), "1" ((USItype)(((~ (mp_limb_t) 0)))), "g" ((USItype)((d0)))); __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)((d0))), "rm" ((USItype)((v0)))); __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((t1)), "=&r" ((t0)) : "0" ((USItype)((t1))), "g" ((USItype)(_t1)), "1" ((USItype)((t0))), "g" ((USItype)(_t0))); (v0)++; _mask = - (mp_limb_t) ((t1) >= _q0); (v0) += _mask; __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" ((t1)), "=&r" ((t0)) : "0" ((USItype)((t1))), "g" ((USItype)(_mask & (d1))), "%1" ((USItype)((t0))), "g" ((USItype)(_mask & (d0)))); if (__builtin_expect (((t1) >= (d1)) != 0, 0)) { if ((t1) > (d1) || (t0) >= (d0)) { (v0)++; __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((t1)), "=&r" ((t0)) : "0" ((USItype)((t1))), "g" ((USItype)((d1))), "1" ((USItype)((t0))), "g" ((USItype)((d0)))); } } } while (0);
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

      __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (r1), "=&r" (r0) : "0" ((USItype)(r1)), "g" ((USItype)(d1)), "1" ((USItype)(r0)), "g" ((USItype)(d0)));





      qh = 1;
    }

  for (i = nn - 2; i >= 2; i -= 2)
    {
      mp_limb_t n1, n0, q1, q0;
      n1 = np[i-1];
      n0 = np[i-2];
      do { mp_limb_t _q3, _q2a, _q2, _q1, _q2c, _q1c, _q1d, _q0; mp_limb_t _t1, _t0; mp_limb_t _c, _mask; __asm__ ("mull %3" : "=a" (_q2a), "=d" (_q3) : "%0" ((USItype)(r1)), "rm" ((USItype)(di1))); __asm__ ("mull %3" : "=a" (_q1), "=d" (_q2) : "%0" ((USItype)(r0)), "rm" ((USItype)(di1))); __asm__ ("mull %3" : "=a" (_q1c), "=d" (_q2c) : "%0" ((USItype)(r1)), "rm" ((USItype)(di0))); __asm__ ("add\t%7, %k2\n\tadc\t%5, %k1\n\tadc\t$0, %k0" : "=r" (_q3), "=&r" (_q2), "=&r" (_q1) : "0" ((USItype)(_q3)), "1" ((USItype)(_q2)), "g" ((USItype)(_q2c)), "%2" ((USItype)(_q1)), "g" ((USItype)(_q1c))); __asm__ ("mull %3" : "=a" (_q0), "=d" (_q1d) : "%0" ((USItype)(r0)), "rm" ((USItype)(di0))); __asm__ ("add\t%7, %k2\n\tadc\t%5, %k1\n\tadc\t$0, %k0" : "=r" (_q3), "=&r" (_q2), "=&r" (_q1) : "0" ((USItype)(_q3)), "1" ((USItype)(_q2)), "g" ((USItype)(_q2a)), "%2" ((USItype)(_q1)), "g" ((USItype)(_q1d))); __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (r1), "=&r" (r0) : "0" ((USItype)(r1)), "g" ((USItype)(((mp_limb_t) 0L))), "%1" ((USItype)(r0)), "g" ((USItype)(((mp_limb_t) 1L)))); __asm__ ("bt\t$0, %2\n\tadc\t%5, %k1\n\tadc\t%k0, %k0" : "=r" (_c), "=r" (_q0) : "rm" ((USItype)(((mp_limb_t) 0L))), "0" (((mp_limb_t) 0L)), "%1" ((USItype)(_q0)), "g" ((USItype)(n0))); __asm__ ("bt\t$0, %2\n\tadc\t%5, %k1\n\tadc\t%k0, %k0" : "=r" (_c), "=r" (_q1) : "rm" ((USItype)(_c)), "0" (((mp_limb_t) 0L)), "%1" ((USItype)(_q1)), "g" ((USItype)(n1))); __asm__ ("bt\t$0, %2\n\tadc\t%5, %k1\n\tadc\t%k0, %k0" : "=r" (_c), "=r" (_q2) : "rm" ((USItype)(_c)), "0" (((mp_limb_t) 0L)), "%1" ((USItype)(_q2)), "g" ((USItype)(r0))); _q3 = _q3 + r1 + _c; __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)(_q2)), "rm" ((USItype)(d0))); _t1 += _q2 * d1 + _q3 * d0; __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (r1), "=&r" (r0) : "0" ((USItype)(n1)), "g" ((USItype)(_t1)), "1" ((USItype)(n0)), "g" ((USItype)(_t0))); _mask = -(mp_limb_t) ((r1 >= _q1) & ((r1 > _q1) | (r0 >= _q0))); __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (r1), "=&r" (r0) : "0" ((USItype)(r1)), "g" ((USItype)(d1 & _mask)), "%1" ((USItype)(r0)), "g" ((USItype)(d0 & _mask))); __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (_q3), "=&r" (_q2) : "0" ((USItype)(_q3)), "g" ((USItype)(((mp_limb_t) 0L))), "1" ((USItype)(_q2)), "g" ((USItype)(-_mask))); if (__builtin_expect ((r1 >= d1) != 0, 0)) { if (r1 > d1 || r0 >= d0) { __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (r1), "=&r" (r0) : "0" ((USItype)(r1)), "g" ((USItype)(d1)), "1" ((USItype)(r0)), "g" ((USItype)(d0))); __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (_q3), "=&r" (_q2) : "0" ((USItype)(_q3)), "g" ((USItype)(((mp_limb_t) 0L))), "%1" ((USItype)(_q2)), "g" ((USItype)(((mp_limb_t) 1L)))); } } (q1) = _q3; (q0) = _q2; } while (0);
      qp[i-1] = q1;
      qp[i-2] = q0;
    }

  if (i > 0)
    {
      mp_limb_t q;
      do { mp_limb_t _q0, _t1, _t0, _mask; __asm__ ("mull %3" : "=a" (_q0), "=d" ((q)) : "%0" ((USItype)((r1))), "rm" ((USItype)((di1)))); __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" ((q)), "=&r" (_q0) : "0" ((USItype)((q))), "g" ((USItype)((r1))), "%1" ((USItype)(_q0)), "g" ((USItype)((r0)))); (r1) = (r0) - (d1) * (q); __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((r1)), "=&r" ((r0)) : "0" ((USItype)((r1))), "g" ((USItype)((d1))), "1" ((USItype)((np[0]))), "g" ((USItype)((d0)))); __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)((d0))), "rm" ((USItype)((q)))); __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((r1)), "=&r" ((r0)) : "0" ((USItype)((r1))), "g" ((USItype)(_t1)), "1" ((USItype)((r0))), "g" ((USItype)(_t0))); (q)++; _mask = - (mp_limb_t) ((r1) >= _q0); (q) += _mask; __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" ((r1)), "=&r" ((r0)) : "0" ((USItype)((r1))), "g" ((USItype)(_mask & (d1))), "%1" ((USItype)((r0))), "g" ((USItype)(_mask & (d0)))); if (__builtin_expect (((r1) >= (d1)) != 0, 0)) { if ((r1) > (d1) || (r0) >= (d0)) { (q)++; __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" ((r1)), "=&r" ((r0)) : "0" ((USItype)((r1))), "g" ((USItype)((d1))), "1" ((USItype)((r0))), "g" ((USItype)((d0)))); } } } while (0);
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
      if ((! ((__builtin_constant_p (2147483647L) && (2147483647L) == 0) || (!(__builtin_constant_p (2147483647L) && (2147483647L) == 2147483647L) && (nn) >= (2147483647L)))))
 {
   gmp_pi1_t dinv;
   do { mp_limb_t _v, _p, _t1, _t0, _mask; do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (_v), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(d1))), "rm" ((USItype)(d1))); } while (0); _p = (d1) * _v; _p += (d0); if (_p < (d0)) { _v--; _mask = -(mp_limb_t) (_p >= (d1)); _p -= (d1); _v += _mask; _p -= _mask & (d1); } __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)(d0)), "rm" ((USItype)(_v))); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (d1)) != 0, 0)) { if (_p > (d1) || _t0 >= (d0)) _v--; } } (dinv).inv32 = _v; } while (0);
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
      do { do {} while (0); (shift) = __builtin_clzl (d1); } while (0);
      d1 = (d1 << shift) | (d0 >> (32 - shift));
      d0 <<= shift;
      do { mp_limb_t _v, _p, _t1, _t0, _mask; do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (_v), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(d1))), "rm" ((USItype)(d1))); } while (0); _p = (d1) * _v; _p += (d0); if (_p < (d0)) { _v--; _mask = -(mp_limb_t) (_p >= (d1)); _p -= (d1); _v += _mask; _p -= _mask & (d1); } __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)(d0)), "rm" ((USItype)(_v))); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (d1)) != 0, 0)) { if (_p > (d1) || _t0 >= (d0)) _v--; } } (dinv).inv32 = _v; } while (0);
      return __gmpn_div_qr_2u_pi1 (qp, rp, np, nn, d1, d0, shift, dinv.inv32);
    }
}

# 48 "redc_2.c"
static mp_limb_t
mpn_addmul_2 (mp_ptr rp, mp_srcptr up, mp_size_t n, mp_srcptr vp)
{
  rp[n] = __gmpn_addmul_1 (rp, up, n, vp[0]);
  return __gmpn_addmul_1 (rp + 1, up, n, vp[1]);
}

# 82 "redc_2.c"
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
      do { mp_limb_t _ph, _pl; __asm__ ("mull %3" : "=a" (_pl), "=d" (_ph) : "%0" ((USItype)(mip[0])), "rm" ((USItype)(up[0]))); (q[1]) = _ph + (mip[0]) * (up[1]) + (mip[1]) * (up[0]); (q[0]) = _pl; } while (0);
      upn = up[n];
      up[1] = mpn_addmul_2 (up, mp, n, q);
      up[0] = up[n];
      up[n] = upn;
      up += 2;
    }

  cy = __gmpn_add_n (rp, up, up - n, n);
  return cy;
}

# 44 "mod_1_3.c"
void
__gmpn_mod_1s_3p_cps (mp_limb_t cps[6], mp_limb_t b)
{
  mp_limb_t bi;
  mp_limb_t B1modb, B2modb, B3modb, B4modb;
  int cnt;

  do {} while (0);

  do { do {} while (0); (cnt) = __builtin_clzl (b); } while (0);

  b <<= cnt;
  do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (bi), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(b))), "rm" ((USItype)(b))); } while (0);

  cps[0] = bi;
  cps[1] = cnt;

  B1modb = -b * ((bi >> (32 -cnt)) | (((mp_limb_t) 1L) << cnt));
  do {} while (0);
  cps[2] = B1modb >> cnt;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("mull %3" : "=a" (_ql), "=d" (_qh) : "%0" ((USItype)((B1modb))), "rm" ((USItype)((bi)))); if (__builtin_constant_p (((mp_limb_t) 0L)) && (((mp_limb_t) 0L)) == 0) { _r = ~(_qh + (B1modb)) * (b); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (b); } else { __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (_qh), "=&r" (_ql) : "0" ((USItype)(_qh)), "g" ((USItype)((B1modb) + 1)), "%1" ((USItype)(_ql)), "g" ((USItype)((((mp_limb_t) 0L))))); _r = (((mp_limb_t) 0L)) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (B2modb) = _r; } while (0);
  cps[3] = B2modb >> cnt;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("mull %3" : "=a" (_ql), "=d" (_qh) : "%0" ((USItype)((B2modb))), "rm" ((USItype)((bi)))); if (__builtin_constant_p (((mp_limb_t) 0L)) && (((mp_limb_t) 0L)) == 0) { _r = ~(_qh + (B2modb)) * (b); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (b); } else { __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (_qh), "=&r" (_ql) : "0" ((USItype)(_qh)), "g" ((USItype)((B2modb) + 1)), "%1" ((USItype)(_ql)), "g" ((USItype)((((mp_limb_t) 0L))))); _r = (((mp_limb_t) 0L)) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (B3modb) = _r; } while (0);
  cps[4] = B3modb >> cnt;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("mull %3" : "=a" (_ql), "=d" (_qh) : "%0" ((USItype)((B3modb))), "rm" ((USItype)((bi)))); if (__builtin_constant_p (((mp_limb_t) 0L)) && (((mp_limb_t) 0L)) == 0) { _r = ~(_qh + (B3modb)) * (b); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (b); } else { __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (_qh), "=&r" (_ql) : "0" ((USItype)(_qh)), "g" ((USItype)((B3modb) + 1)), "%1" ((USItype)(_ql)), "g" ((USItype)((((mp_limb_t) 0L))))); _r = (((mp_limb_t) 0L)) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (B4modb) = _r; } while (0);
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




  switch ((int) ((mp_limb_t) n * (((((~ ((mp_limb_t) (0))) >> 0) >> ((32 - 0) % 2)) / 3) * 2 + 1) >> ((32 - 0) - 2)))
    {
    case 0:
      __asm__ ("mull %3" : "=a" (pl), "=d" (ph) : "%0" ((USItype)(ap[n - 2])), "rm" ((USItype)(B1modb)));
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (ph), "=&r" (pl) : "0" ((USItype)(ph)), "g" ((USItype)(((mp_limb_t) 0L))), "%1" ((USItype)(pl)), "g" ((USItype)(ap[n - 3])));
      __asm__ ("mull %3" : "=a" (rl), "=d" (rh) : "%0" ((USItype)(ap[n - 1])), "rm" ((USItype)(B2modb)));
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (rh), "=&r" (rl) : "0" ((USItype)(rh)), "g" ((USItype)(ph)), "%1" ((USItype)(rl)), "g" ((USItype)(pl)));
      n -= 3;
      break;
    case 2:
      rh = 0;
      rl = ap[n - 1];
      n -= 1;
      break;
    case 1:
      rh = ap[n - 1];
      rl = ap[n - 2];
      n -= 2;
      break;
    }

  for (i = n - 3; i >= 0; i -= 3)
    {






      __asm__ ("mull %3" : "=a" (pl), "=d" (ph) : "%0" ((USItype)(ap[i + 1])), "rm" ((USItype)(B1modb)));
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (ph), "=&r" (pl) : "0" ((USItype)(ph)), "g" ((USItype)(((mp_limb_t) 0L))), "%1" ((USItype)(pl)), "g" ((USItype)(ap[i + 0])));

      __asm__ ("mull %3" : "=a" (cl), "=d" (ch) : "%0" ((USItype)(ap[i + 2])), "rm" ((USItype)(B2modb)));
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (ph), "=&r" (pl) : "0" ((USItype)(ph)), "g" ((USItype)(ch)), "%1" ((USItype)(pl)), "g" ((USItype)(cl)));

      __asm__ ("mull %3" : "=a" (cl), "=d" (ch) : "%0" ((USItype)(rl)), "rm" ((USItype)(B3modb)));
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (ph), "=&r" (pl) : "0" ((USItype)(ph)), "g" ((USItype)(ch)), "%1" ((USItype)(pl)), "g" ((USItype)(cl)));

      __asm__ ("mull %3" : "=a" (rl), "=d" (rh) : "%0" ((USItype)(rh)), "rm" ((USItype)(B4modb)));
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (rh), "=&r" (rl) : "0" ((USItype)(rh)), "g" ((USItype)(ph)), "%1" ((USItype)(rl)), "g" ((USItype)(pl)));
    }

  __asm__ ("mull %3" : "=a" (cl), "=d" (rh) : "%0" ((USItype)(rh)), "rm" ((USItype)(B1modb)));
  __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (rh), "=&r" (rl) : "0" ((USItype)(rh)), "g" ((USItype)(((mp_limb_t) 0L))), "%1" ((USItype)(rl)), "g" ((USItype)(cl)));

  cnt = cps[1];
  bi = cps[0];

  r = (rh << cnt) | (rl >> (32 - cnt));
  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("mull %3" : "=a" (_ql), "=d" (_qh) : "%0" ((USItype)((r))), "rm" ((USItype)((bi)))); if (__builtin_constant_p (rl << cnt) && (rl << cnt) == 0) { _r = ~(_qh + (r)) * (b); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (b); } else { __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (_qh), "=&r" (_ql) : "0" ((USItype)(_qh)), "g" ((USItype)((r) + 1)), "%1" ((USItype)(_ql)), "g" ((USItype)((rl << cnt)))); _r = (rl << cnt) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (r) = _r; } while (0);

  return r >> cnt;
}

# 44 "mod_1_2.c"
void
__gmpn_mod_1s_2p_cps (mp_limb_t cps[5], mp_limb_t b)
{
  mp_limb_t bi;
  mp_limb_t B1modb, B2modb, B3modb;
  int cnt;

  do {} while (0);

  do { do {} while (0); (cnt) = __builtin_clzl (b); } while (0);

  b <<= cnt;
  do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (bi), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(b))), "rm" ((USItype)(b))); } while (0);

  cps[0] = bi;
  cps[1] = cnt;

  B1modb = -b * ((bi >> (32 -cnt)) | (((mp_limb_t) 1L) << cnt));
  do {} while (0);
  cps[2] = B1modb >> cnt;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("mull %3" : "=a" (_ql), "=d" (_qh) : "%0" ((USItype)((B1modb))), "rm" ((USItype)((bi)))); if (__builtin_constant_p (((mp_limb_t) 0L)) && (((mp_limb_t) 0L)) == 0) { _r = ~(_qh + (B1modb)) * (b); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (b); } else { __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (_qh), "=&r" (_ql) : "0" ((USItype)(_qh)), "g" ((USItype)((B1modb) + 1)), "%1" ((USItype)(_ql)), "g" ((USItype)((((mp_limb_t) 0L))))); _r = (((mp_limb_t) 0L)) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (B2modb) = _r; } while (0);
  cps[3] = B2modb >> cnt;

  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("mull %3" : "=a" (_ql), "=d" (_qh) : "%0" ((USItype)((B2modb))), "rm" ((USItype)((bi)))); if (__builtin_constant_p (((mp_limb_t) 0L)) && (((mp_limb_t) 0L)) == 0) { _r = ~(_qh + (B2modb)) * (b); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (b); } else { __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (_qh), "=&r" (_ql) : "0" ((USItype)(_qh)), "g" ((USItype)((B2modb) + 1)), "%1" ((USItype)(_ql)), "g" ((USItype)((((mp_limb_t) 0L))))); _r = (((mp_limb_t) 0L)) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (B3modb) = _r; } while (0);
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
   do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("mull %3" : "=a" (_ql), "=d" (_qh) : "%0" ((USItype)((rl >> (32 - cnt)))), "rm" ((USItype)((bi)))); if (__builtin_constant_p (rl << cnt) && (rl << cnt) == 0) { _r = ~(_qh + (rl >> (32 - cnt))) * (b); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (b); } else { __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (_qh), "=&r" (_ql) : "0" ((USItype)(_qh)), "g" ((USItype)((rl >> (32 - cnt)) + 1)), "%1" ((USItype)(_ql)), "g" ((USItype)((rl << cnt)))); _r = (rl << cnt) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (r) = _r; } while (0)
                         ;
   return r >> cnt;
 }

      __asm__ ("mull %3" : "=a" (pl), "=d" (ph) : "%0" ((USItype)(ap[n - 2])), "rm" ((USItype)(B1modb)));
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (ph), "=&r" (pl) : "0" ((USItype)(ph)), "g" ((USItype)(((mp_limb_t) 0L))), "%1" ((USItype)(pl)), "g" ((USItype)(ap[n - 3])));
      __asm__ ("mull %3" : "=a" (rl), "=d" (rh) : "%0" ((USItype)(ap[n - 1])), "rm" ((USItype)(B2modb)));
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (rh), "=&r" (rl) : "0" ((USItype)(rh)), "g" ((USItype)(ph)), "%1" ((USItype)(rl)), "g" ((USItype)(pl)));
      n--;
    }
  else
    {
      rh = ap[n - 1];
      rl = ap[n - 2];
    }

  for (i = n - 4; i >= 0; i -= 2)
    {





      __asm__ ("mull %3" : "=a" (pl), "=d" (ph) : "%0" ((USItype)(ap[i + 1])), "rm" ((USItype)(B1modb)));
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (ph), "=&r" (pl) : "0" ((USItype)(ph)), "g" ((USItype)(((mp_limb_t) 0L))), "%1" ((USItype)(pl)), "g" ((USItype)(ap[i + 0])));

      __asm__ ("mull %3" : "=a" (cl), "=d" (ch) : "%0" ((USItype)(rl)), "rm" ((USItype)(B2modb)));
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (ph), "=&r" (pl) : "0" ((USItype)(ph)), "g" ((USItype)(ch)), "%1" ((USItype)(pl)), "g" ((USItype)(cl)));

      __asm__ ("mull %3" : "=a" (rl), "=d" (rh) : "%0" ((USItype)(rh)), "rm" ((USItype)(B3modb)));
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (rh), "=&r" (rl) : "0" ((USItype)(rh)), "g" ((USItype)(ph)), "%1" ((USItype)(rl)), "g" ((USItype)(pl)));
    }

  __asm__ ("mull %3" : "=a" (cl), "=d" (rh) : "%0" ((USItype)(rh)), "rm" ((USItype)(B1modb)));
  __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (rh), "=&r" (rl) : "0" ((USItype)(rh)), "g" ((USItype)(((mp_limb_t) 0L))), "%1" ((USItype)(rl)), "g" ((USItype)(cl)));

  cnt = cps[1];
  bi = cps[0];

  r = (rh << cnt) | (rl >> (32 - cnt));
  do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("mull %3" : "=a" (_ql), "=d" (_qh) : "%0" ((USItype)((r))), "rm" ((USItype)((bi)))); if (__builtin_constant_p (rl << cnt) && (rl << cnt) == 0) { _r = ~(_qh + (r)) * (b); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (b); } else { __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (_qh), "=&r" (_ql) : "0" ((USItype)(_qh)), "g" ((USItype)((r) + 1)), "%1" ((USItype)(_ql)), "g" ((USItype)((rl << cnt)))); _r = (rl << cnt) - _qh * (b); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (b); if (__builtin_expect ((_r >= (b)) != 0, 0)) _r -= (b); } (r) = _r; } while (0);

  return r >> cnt;
}

# 1565 "../gmp-impl.h"
void __gmpn_sec_pi1_div_r (mp_ptr, mp_size_t, mp_srcptr, mp_size_t, mp_limb_t, mp_ptr);

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
  do { do {} while (0); (cnt) = __builtin_clzl (d1); } while (0);

  if (cnt != 0)
    {
      mp_limb_t qh, cy;
      mp_ptr np2, dp2;
      dp2 = tp;
      __gmpn_lshift (dp2, dp, dn, cnt);

      np2 = tp + dn;
      cy = __gmpn_lshift (np2, np, nn, cnt);
      np2[nn++] = cy;

      d0 = dp2[dn - 1];
      d0 += (~d0 != 0);
      do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (inv32), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(d0))), "rm" ((USItype)(d0))); } while (0);
# 109 "sec_div_r.c"
      __gmpn_sec_pi1_div_r (np2, nn, dp2, dn, inv32, tp + nn + dn);


      __gmpn_rshift (np, np2, dn, cnt);




    }
  else
    {



      d0 = dp[dn - 1];
      d0 += (~d0 != 0);
      do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (inv32), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(d0))), "rm" ((USItype)(d0))); } while (0);




      __gmpn_sec_pi1_div_r (np, nn, dp, dn, inv32, tp);

    }
}

# 1543 "../gmp.h"
void __gmpn_mul_n (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);

# 1171 "../gmp-impl.h"
void __gmpn_mulmod_bnm1 (mp_ptr, mp_size_t, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t, mp_ptr);

# 1173 "../gmp-impl.h"
mp_size_t __gmpn_mulmod_bnm1_next_size (mp_size_t);

# 1174 "../gmp-impl.h"
static inline mp_size_t
mpn_mulmod_bnm1_itch (mp_size_t rn, mp_size_t an, mp_size_t bn) {
  mp_size_t n, itch;
  n = rn >> 1;
  itch = rn + 4 +
    (an > n ? (bn > n ? rn : n) : 0);
  return itch;
}

# 4663 "../gmp-impl.h"
mp_limb_t __gmpn_add_nc (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t, mp_limb_t);

# 87 "invertappr.c"
static mp_limb_t
mpn_bc_invertappr (mp_ptr ip, mp_srcptr dp, mp_size_t n, mp_ptr xp)
{
  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);


  if (n == 1)
    do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (*ip), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(*dp))), "rm" ((USItype)(*dp))); } while (0);
  else {
    mp_size_t i;


    i = n;
    do
      xp[--i] = ((~ ((mp_limb_t) (0))) >> 0);
    while (i);
    do { mp_ptr __d = (xp + n); mp_srcptr __s = (dp); mp_size_t __n = (n); do {} while (0); do {} while (0); do *__d++ = (~ *__s++) & ((~ ((mp_limb_t) (0))) >> 0); while (--__n); } while (0);




    if (n == 2) {
      __gmpn_divrem_2 (ip, 0, xp, 4, dp);
    } else {
      gmp_pi1_t inv;
      do { mp_limb_t _v, _p, _t1, _t0, _mask; do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (_v), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(dp[n-1]))), "rm" ((USItype)(dp[n-1]))); } while (0); _p = (dp[n-1]) * _v; _p += (dp[n-2]); if (_p < (dp[n-2])) { _v--; _mask = -(mp_limb_t) (_p >= (dp[n-1])); _p -= (dp[n-1]); _v += _mask; _p -= _mask & (dp[n-1]); } __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)(dp[n-2])), "rm" ((USItype)(_v))); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (dp[n-1])) != 0, 0)) { if (_p > (dp[n-1]) || _t0 >= (dp[n-2])) _v--; } } (inv).inv32 = _v; } while (0);
      if (! (14 < 43)
   || (! ((__builtin_constant_p (43) && (43) == 0) || (!(__builtin_constant_p (43) && (43) == 2147483647L) && (n) >= (43)))))
 __gmpn_sbpi1_divappr_q (ip, xp, 2 * n, dp, n, inv.inv32);
      else
 __gmpn_dcpi1_divappr_q (ip, xp, 2 * n, dp, n, &inv);
      do { mp_ptr __ptr_dummy; if (__builtin_constant_p (((mp_limb_t) 1L)) && (((mp_limb_t) 1L)) == 0) { } else if (__builtin_constant_p (((mp_limb_t) 1L)) && (((mp_limb_t) 1L)) == 1) { __asm__ __volatile__ ("\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, (%0)\n" "\tlea\t%c2(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" : "=r" (__ptr_dummy) : "0" (ip), "n" (sizeof(mp_limb_t)) : "memory"); } else { __asm__ __volatile__ ( "subl" "\t%2, (%0)\n" "\tjnc\t" ".L" "asm_%=_" "done" "\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, %c3(%0)\n" "\tlea\t%c3(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" "\n" ".L" "asm_%=_" "done" ":\n" : "=r" (__ptr_dummy) : "0" (ip), "re" ((mp_limb_t) (((mp_limb_t) 1L))), "n" (sizeof(mp_limb_t)) : "memory"); } } while (0);
      return 1;
    }
  }
  return 0;
}

# 157 "invertappr.c"
mp_limb_t
__gmpn_ni_invertappr (mp_ptr ip, mp_srcptr dp, mp_size_t n, mp_ptr scratch)
{
  mp_limb_t cy;
  mp_size_t rn, mn;
  mp_size_t sizes[((sizeof(mp_size_t) > 6 ? 48 : 8*sizeof(mp_size_t)) - (((14) >= 0x1) + ((14) >= 0x2) + ((14) >= 0x4) + ((14) >= 0x8) + ((14) >= 0x10) + ((14) >= 0x20) + ((14) >= 0x40) + ((14) >= 0x80) + ((14) >= 0x100) + ((14) >= 0x200) + ((14) >= 0x400) + ((14) >= 0x800) + ((14) >= 0x1000) + ((14) >= 0x2000) + ((14) >= 0x4000) + ((14) >= 0x8000)))], *sizp;
  mp_ptr tp;
  struct tmp_reentrant_t *__tmp_marker;


  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);



  sizp = sizes;
  rn = n;
  do {
    *sizp = rn;
    rn = (rn >> 1) + 1;
    ++sizp;
  } while (((__builtin_constant_p (14) && (14) == 0) || (!(__builtin_constant_p (14) && (14) == 2147483647L) && (rn) >= (14))));


  dp += n;
  ip += n;


  mpn_bc_invertappr (ip - rn, dp - rn, rn, scratch);

  __tmp_marker = 0;

  if (((__builtin_constant_p (54) && (54) == 0) || (!(__builtin_constant_p (54) && (54) == 2147483647L) && (n) >= (54))))
    {
      mn = __gmpn_mulmod_bnm1_next_size (n + 1);
      tp = ((mp_limb_t *) (__builtin_expect ((((mpn_mulmod_bnm1_itch (mn, n, (n >> 1) + 1)) * sizeof (mp_limb_t)) <= 0x7f00) != 0, 1) ? __builtin_alloca((mpn_mulmod_bnm1_itch (mn, n, (n >> 1) + 1)) * sizeof (mp_limb_t)) : __gmp_tmp_reentrant_alloc (&__tmp_marker, (mpn_mulmod_bnm1_itch (mn, n, (n >> 1) + 1)) * sizeof (mp_limb_t))));
    }


  while (1) {
    n = *--sizp;







    if ((! ((__builtin_constant_p (54) && (54) == 0) || (!(__builtin_constant_p (54) && (54) == 2147483647L) && (n) >= (54))))
 || ((mn = __gmpn_mulmod_bnm1_next_size (n + 1)) > (n + rn))) {

      __gmpn_mul (scratch, dp - n, n, ip - rn, rn);
      __gmpn_add_n (scratch + rn, scratch + rn, dp - n, n - rn + 1);
      cy = ((mp_limb_t) 1L);

    } else {
      __gmpn_mulmod_bnm1 (scratch, mn, dp - n, n, ip - rn, rn, tp);



      do {} while (0);
      cy = __gmpn_add_n (scratch + rn, scratch + rn, dp - n, mn - rn);
      cy = __gmpn_add_nc (scratch, scratch, dp - (n - (mn - rn)), n - (mn - rn), cy);

      scratch[mn] = ((mp_limb_t) 1L);
      do { mp_ptr __ptr_dummy; if (__builtin_constant_p (((mp_limb_t) 1L) - cy) && (((mp_limb_t) 1L) - cy) == 0) { } else if (__builtin_constant_p (((mp_limb_t) 1L) - cy) && (((mp_limb_t) 1L) - cy) == 1) { __asm__ __volatile__ ("\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, (%0)\n" "\tlea\t%c2(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" : "=r" (__ptr_dummy) : "0" (scratch + rn + n - mn), "n" (sizeof(mp_limb_t)) : "memory"); } else { __asm__ __volatile__ ( "subl" "\t%2, (%0)\n" "\tjnc\t" ".L" "asm_%=_" "done" "\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, %c3(%0)\n" "\tlea\t%c3(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" "\n" ".L" "asm_%=_" "done" ":\n" : "=r" (__ptr_dummy) : "0" (scratch + rn + n - mn), "re" ((mp_limb_t) (((mp_limb_t) 1L) - cy)), "n" (sizeof(mp_limb_t)) : "memory"); } } while (0);
      do { mp_ptr __ptr_dummy; if (__builtin_constant_p (((mp_limb_t) 1L) - scratch[mn]) && (((mp_limb_t) 1L) - scratch[mn]) == 0) { } else if (__builtin_constant_p (((mp_limb_t) 1L) - scratch[mn]) && (((mp_limb_t) 1L) - scratch[mn]) == 1) { __asm__ __volatile__ ("\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, (%0)\n" "\tlea\t%c2(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" : "=r" (__ptr_dummy) : "0" (scratch), "n" (sizeof(mp_limb_t)) : "memory"); } else { __asm__ __volatile__ ( "subl" "\t%2, (%0)\n" "\tjnc\t" ".L" "asm_%=_" "done" "\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, %c3(%0)\n" "\tlea\t%c3(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" "\n" ".L" "asm_%=_" "done" ":\n" : "=r" (__ptr_dummy) : "0" (scratch), "re" ((mp_limb_t) (((mp_limb_t) 1L) - scratch[mn])), "n" (sizeof(mp_limb_t)) : "memory"); } } while (0);
      cy = ((mp_limb_t) 0L);
    }

    if (scratch[n] < ((mp_limb_t) 2L)) {
      cy = scratch[n];
# 243 "invertappr.c"
      if (cy++ && !__gmpn_sub_n (scratch, scratch, dp - n, n)) {
 (__gmpn_sub_n (scratch, scratch, dp - n, n));
 ++cy;
      }
# 256 "invertappr.c"
      if (__gmpn_cmp (scratch, dp - n, n) > 0) {
 (__gmpn_sub_n (scratch, scratch, dp - n, n));
 ++cy;
      }
      (__gmpn_sub_nc (scratch + 2 * n - rn, dp - rn, scratch + n - rn, rn, __gmpn_cmp (scratch, dp - n, n - rn) > 0));

      do { mp_ptr __ptr_dummy; if (__builtin_constant_p (cy) && (cy) == 0) { } else if (__builtin_constant_p (cy) && (cy) == 1) { __asm__ __volatile__ ("\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, (%0)\n" "\tlea\t%c2(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" : "=r" (__ptr_dummy) : "0" (ip - rn), "n" (sizeof(mp_limb_t)) : "memory"); } else { __asm__ __volatile__ ( "subl" "\t%2, (%0)\n" "\tjnc\t" ".L" "asm_%=_" "done" "\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, %c3(%0)\n" "\tlea\t%c3(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" "\n" ".L" "asm_%=_" "done" ":\n" : "=r" (__ptr_dummy) : "0" (ip - rn), "re" ((mp_limb_t) (cy)), "n" (sizeof(mp_limb_t)) : "memory"); } } while (0);
    } else {
      do {} while (0);
      do { mp_ptr __ptr_dummy; if (__builtin_constant_p (cy) && (cy) == 0) { } else if (__builtin_constant_p (cy) && (cy) == 1) { __asm__ __volatile__ ("\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, (%0)\n" "\tlea\t%c2(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" : "=r" (__ptr_dummy) : "0" (scratch), "n" (sizeof(mp_limb_t)) : "memory"); } else { __asm__ __volatile__ ( "subl" "\t%2, (%0)\n" "\tjnc\t" ".L" "asm_%=_" "done" "\n" ".L" "asm_%=_" "top" ":\n" "\t" "subl" "\t$1, %c3(%0)\n" "\tlea\t%c3(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" "\n" ".L" "asm_%=_" "done" ":\n" : "=r" (__ptr_dummy) : "0" (scratch), "re" ((mp_limb_t) (cy)), "n" (sizeof(mp_limb_t)) : "memory"); } } while (0);
      if (scratch[n] != ((~ ((mp_limb_t) (0))) >> 0)) {
 do { mp_ptr __ptr_dummy; if (__builtin_constant_p (((mp_limb_t) 1L)) && (((mp_limb_t) 1L)) == 0) { } else if (__builtin_constant_p (((mp_limb_t) 1L)) && (((mp_limb_t) 1L)) == 1) { __asm__ __volatile__ ("\n" ".L" "asm_%=_" "top" ":\n" "\t" "addl" "\t$1, (%0)\n" "\tlea\t%c2(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" : "=r" (__ptr_dummy) : "0" (ip - rn), "n" (sizeof(mp_limb_t)) : "memory"); } else { __asm__ __volatile__ ( "addl" "\t%2, (%0)\n" "\tjnc\t" ".L" "asm_%=_" "done" "\n" ".L" "asm_%=_" "top" ":\n" "\t" "addl" "\t$1, %c3(%0)\n" "\tlea\t%c3(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" "\n" ".L" "asm_%=_" "done" ":\n" : "=r" (__ptr_dummy) : "0" (ip - rn), "re" ((mp_limb_t) (((mp_limb_t) 1L))), "n" (sizeof(mp_limb_t)) : "memory"); } } while (0);
 (__gmpn_add_n (scratch, scratch, dp - n, n));
      }
      do { mp_ptr __d = (scratch + 2 * n - rn); mp_srcptr __s = (scratch + n - rn); mp_size_t __n = (rn); do {} while (0); do {} while (0); do *__d++ = (~ *__s++) & ((~ ((mp_limb_t) (0))) >> 0); while (--__n); } while (0);
    }


    __gmpn_mul_n (scratch, scratch + 2 * n - rn, ip - rn, rn);
    cy = __gmpn_add_n (scratch + rn, scratch + rn, scratch + 2 * n - rn, 2 * rn - n);
    cy = __gmpn_add_nc (ip - n, scratch + 3 * rn - n, scratch + n + rn, n - rn, cy);
    do { mp_ptr __ptr_dummy; if (__builtin_constant_p (cy) && (cy) == 0) { } else if (__builtin_constant_p (cy) && (cy) == 1) { __asm__ __volatile__ ("\n" ".L" "asm_%=_" "top" ":\n" "\t" "addl" "\t$1, (%0)\n" "\tlea\t%c2(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" : "=r" (__ptr_dummy) : "0" (ip - rn), "n" (sizeof(mp_limb_t)) : "memory"); } else { __asm__ __volatile__ ( "addl" "\t%2, (%0)\n" "\tjnc\t" ".L" "asm_%=_" "done" "\n" ".L" "asm_%=_" "top" ":\n" "\t" "addl" "\t$1, %c3(%0)\n" "\tlea\t%c3(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" "\n" ".L" "asm_%=_" "done" ":\n" : "=r" (__ptr_dummy) : "0" (ip - rn), "re" ((mp_limb_t) (cy)), "n" (sizeof(mp_limb_t)) : "memory"); } } while (0);
    if (sizp == sizes) {

      cy = scratch[3 * rn - n - 1] > ((~ ((mp_limb_t) (0))) >> 0) - ((mp_limb_t) 7L);

      break;
    }
    rn = n;
  }
  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);

  return cy;

}

# 1516 "../gmp.h"
mp_limb_t __gmpn_gcd_1 (mp_srcptr, mp_size_t, mp_limb_t);

# 88 "gcd.c"
static inline mp_size_t
gcd_2 (mp_ptr gp, mp_srcptr up, mp_srcptr vp)
{
  mp_limb_t u0, u1, v0, v1;
  mp_size_t gn;

  u0 = up[0];
  u1 = up[1];
  v0 = vp[0];
  v1 = vp[1];

  do {} while (0);
  do {} while (0);



  while (u1 != v1 && u0 != v0)
    {
      unsigned long int r;
      if (u1 > v1)
 {
   __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (u1), "=&r" (u0) : "0" ((USItype)(u1)), "g" ((USItype)(v1)), "1" ((USItype)(u0)), "g" ((USItype)(v0)));
   do { do {} while (0); (r) = __builtin_ctzl (u0); } while (0);
   u0 = ((u1 << ((32 - 0) - r)) & ((~ ((mp_limb_t) (0))) >> 0)) | (u0 >> r);
   u1 >>= r;
 }
      else
 {
   __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (v1), "=&r" (v0) : "0" ((USItype)(v1)), "g" ((USItype)(u1)), "1" ((USItype)(v0)), "g" ((USItype)(u0)));
   do { do {} while (0); (r) = __builtin_ctzl (v0); } while (0);
   v0 = ((v1 << ((32 - 0) - r)) & ((~ ((mp_limb_t) (0))) >> 0)) | (v0 >> r);
   v1 >>= r;
 }
    }

  gp[0] = u0, gp[1] = u1, gn = 1 + (u1 != 0);


  if (u1 == v1 && u0 == v0)
    return gn;

  v0 = (u0 == v0) ? ((u1 > v1) ? u1-v1 : v1-u1) : ((u0 > v0) ? u0-v0 : v0-u0);
  gp[0] = __gmpn_gcd_1 (gp, gn, v0);

  return 1;
}

# 44 "sizeinbase.c"
size_t
__gmpn_sizeinbase (mp_srcptr xp, mp_size_t xsize, int base)
{
  size_t result;
  do { int __lb_base, __cnt; size_t __totbits; do {} while (0); do {} while (0); do {} while (0); if ((xsize) == 0) (result) = 1; else { do { do {} while (0); (__cnt) = __builtin_clzl ((xp)[(xsize)-1]); } while (0); __totbits = (size_t) (xsize) * (32 - 0) - (__cnt - 0); if ((((base) & ((base) - 1)) == 0)) { __lb_base = __gmpn_bases[base].big_base; (result) = (__totbits + __lb_base - 1) / __lb_base; } else { do { mp_limb_t _ph, _dummy; size_t _nbits = (__totbits); __asm__ ("mull %3" : "=a" (_dummy), "=d" (_ph) : "%0" ((USItype)(__gmpn_bases[base].logb2 + 1)), "rm" ((USItype)(_nbits))); result = _ph + 1; } while (0); } } } while (0);
  return result;
}

# 1588 "../gmp.h"
mp_size_t __gmpn_set_str (mp_ptr, const unsigned char *, size_t, int);

# 3875 "../gmp-impl.h"
/* extern */ const unsigned char __gmp_digit_value_tab[];

# 44 "set_str.c"
int
__gmpz_set_str (mpz_ptr x, const char *str, int base)
{
  size_t str_size;
  char *s, *begs;
  size_t i;
  mp_size_t xsize;
  int c;
  int negative;
  const unsigned char *digit_value;
  struct tmp_reentrant_t *__tmp_marker;

  digit_value = __gmp_digit_value_tab;
  if (base > 36)
    {


      digit_value += 208;
      if (base > 62)
 return -1;
    }


  do
    c = (unsigned char) *str++;
  while (isspace (c));

  negative = 0;
  if (c == '-')
    {
      negative = 1;
      c = (unsigned char) *str++;
    }

  if (digit_value[c] >= (base == 0 ? 10 : base))
    return -1;



  if (base == 0)
    {
      base = 10;
      if (c == '0')
 {
   base = 8;
   c = (unsigned char) *str++;
   if (c == 'x' || c == 'X')
     {
       base = 16;
       c = (unsigned char) *str++;
     }
   else if (c == 'b' || c == 'B')
     {
       base = 2;
       c = (unsigned char) *str++;
     }
 }
    }


  while (c == '0' || isspace (c))
    c = (unsigned char) *str++;

  if (c == 0)
    {
      ((x)->_mp_size) = 0;
      return 0;
    }

  __tmp_marker = 0;
  str_size = strlen (str - 1);
  s = begs = (char *) (__builtin_expect (((str_size + 1) <= 0x7f00) != 0, 1) ? __builtin_alloca(str_size + 1) : __gmp_tmp_reentrant_alloc (&__tmp_marker, str_size + 1));



  for (i = 0; i < str_size; i++)
    {
      if (!isspace (c))
 {
   int dig = digit_value[c];
   if (dig >= base)
     {
       do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
       return -1;
     }
   *s++ = dig;
 }
      c = (unsigned char) *str++;
    }

  str_size = s - begs;

  do { mp_limb_t _ph, _dummy; __asm__ ("mull %3" : "=a" (_dummy), "=d" (_ph) : "%0" ((USItype)(__gmpn_bases[base].log2b)), "rm" ((USItype)((mp_limb_t) (str_size)))); xsize = 8 * _ph / (32 - 0) + 2; } while (0);
  (__builtin_expect (((xsize) > ((x)->_mp_alloc)) != 0, 0) ? (mp_ptr) __gmpz_realloc(x,xsize) : ((x)->_mp_d));


  xsize = __gmpn_set_str (((x)->_mp_d), (unsigned char *) begs, str_size, base);
  ((x)->_mp_size) = negative ? -xsize : xsize;

  do { if (__builtin_expect ((__tmp_marker != 0) != 0, 0)) __gmp_tmp_reentrant_free (__tmp_marker); } while (0);
  return 0;
}

# 102 "sqrlo_basecase.c"
void
__gmpn_sqrlo_basecase (mp_ptr rp, mp_srcptr up, mp_size_t n)
{
  mp_limb_t ul;

  do {} while (0);
  do {} while (0);

  ul = up[0];

  if (n <= 2)
    {



      if (n == 1)
 rp[0] = (ul * ul) & ((~ ((mp_limb_t) (0))) >> 0);
      else
 {
   mp_limb_t hi, lo, ul1;
   __asm__ ("mull %3" : "=a" (lo), "=d" (hi) : "%0" ((USItype)(ul)), "rm" ((USItype)(ul << 0)));
   rp[0] = lo >> 0;
   ul1 = up[1];

   rp[1] = (hi + ul * ul1 * 2) & ((~ ((mp_limb_t) (0))) >> 0);
# 148 "sqrlo_basecase.c"
 }

    }
  else
    {
      mp_limb_t tp[((62) < 2 ? 1 : (62) - 1)];
      mp_size_t i;


      do {} while (0);

      --n;

      {
 mp_limb_t cy;

 cy = ul * up[n] + __gmpn_mul_1 (tp, up + 1, n - 1, ul);
 for (i = 1; 2 * i + 1 < n; ++i)
   {
     ul = up[i];
     cy += ul * up[n - i] + __gmpn_addmul_1 (tp + 2 * i, up + i + 1, n - 2 * i - 1, ul);
   }
 tp [n-1] = (cy + ((n & 1)?up[i] * up[i + 1]:0)) & ((~ ((mp_limb_t) (0))) >> 0);
      }






      do { do { mp_size_t nhalf; nhalf = ((n + 1)) >> 1; do { mp_size_t _i; for (_i = 0; _i < (nhalf); _i++) { mp_limb_t ul, lpl; ul = (((up)))[_i]; __asm__ ("mull %3" : "=a" (lpl), "=d" ((((rp)))[2 * _i + 1]) : "%0" ((USItype)(ul)), "rm" ((USItype)(ul << 0))); (((rp)))[2 * _i] = lpl >> 0; } } while (0); if ((((n + 1)) & 1) != 0) { mp_limb_t op; op = ((up))[nhalf]; ((rp))[((n + 1)) - 1] = (op * op) & ((~ ((mp_limb_t) (0))) >> 0); } } while (0); __gmpn_lshift ((tp), (tp), (n + 1) - 1, 1); __gmpn_add_n ((rp) + 1, (rp) + 1, (tp), (n + 1) - 1); } while (0);
    }
}

# 47 "mulmid_basecase.c"
void
__gmpn_mulmid_basecase (mp_ptr rp,
                     mp_srcptr up, mp_size_t un,
                     mp_srcptr vp, mp_size_t vn)
{
  mp_limb_t lo, hi;
  mp_limb_t cy;

  do {} while (0);
  do {} while (0);
  do {} while (0);
  do {} while (0);

  up += vn - 1;
  un -= vn - 1;


  lo = __gmpn_mul_1 (rp, up, un, vp[0]);
  hi = 0;


  for (vn--; vn; vn--)
    {
      up--, vp++;
      cy = __gmpn_addmul_1 (rp, up, un, vp[0]);
      __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (hi), "=&r" (lo) : "0" ((USItype)(hi)), "g" ((USItype)(((mp_limb_t) 0L))), "%1" ((USItype)(lo)), "g" ((USItype)(cy)));
    }







  rp[un] = lo;
  rp[un + 1] = hi;
}

# 4073 "../gmp-impl.h"
/* extern */ const unsigned char __gmp_jacobi_table[208];

# 4100 "../gmp-impl.h"
static inline unsigned
mpn_jacobi_update (unsigned bits, unsigned denominator, unsigned q)
{







  do {} while (0);
  do {} while (0);
  do {} while (0);
# 4132 "../gmp-impl.h"
  return bits = __gmp_jacobi_table[(bits << 3) + (denominator << 2) + q];
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
      __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (ah), "=&r" (al) : "0" ((USItype)(ah)), "g" ((USItype)(bh)), "1" ((USItype)(al)), "g" ((USItype)(bl)));
      if (ah < 2)
 return 0;

      u00 = u01 = u11 = 1;
      u10 = 0;
      bits = mpn_jacobi_update (bits, 1, 1);
    }
  else
    {
      __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (bh), "=&r" (bl) : "0" ((USItype)(bh)), "g" ((USItype)(ah)), "1" ((USItype)(bl)), "g" ((USItype)(al)));
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



      do {} while (0);
      __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (ah), "=&r" (al) : "0" ((USItype)(ah)), "g" ((USItype)(bh)), "1" ((USItype)(al)), "g" ((USItype)(bl)));

      if (ah < 2)
 goto done;

      if (ah <= bh)
 {

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



      __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (bh), "=&r" (bl) : "0" ((USItype)(bh)), "g" ((USItype)(ah)), "1" ((USItype)(bl)), "g" ((USItype)(al)));

      if (bh < 2)
 goto done;

      if (bh <= ah)
 {

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

# 1053 "../gmp-impl.h"
int __gmpn_jacobi_base (mp_limb_t, mp_limb_t, int);

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


  bit <<= 1;

  if (bh == 0 && bl == 1)

    return 1 - (bit & 2);

  if (al == 0)
    {
      if (ah == 0)

 return 0;

      do { do {} while (0); (c) = __builtin_ctzl (ah); } while (0);
      bit ^= (((32 - 0) + c) << 1) & (bl ^ (bl >> 1));

      al = bl;
      bl = ah >> c;

      if (bl == 1)

 return 1 - (bit & 2);

      ah = bh;

      bit ^= al & bl;

      goto b_reduced;
    }
  if ( (al & 1) == 0)
    {
      do { do {} while (0); (c) = __builtin_ctzl (al); } while (0);

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

      while (ah > bh)
 {
   __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (ah), "=&r" (al) : "0" ((USItype)(ah)), "g" ((USItype)(bh)), "1" ((USItype)(al)), "g" ((USItype)(bl)));
   if (al == 0)
     {
       do { do {} while (0); (c) = __builtin_ctzl (ah); } while (0);
       bit ^= (((32 - 0) + c) << 1) & (bl ^ (bl >> 1));

       al = bl;
       bl = ah >> c;
       ah = bh;

       bit ^= al & bl;
       goto b_reduced;
     }
   do { do {} while (0); (c) = __builtin_ctzl (al); } while (0);
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


      while (bh > ah)
 {
   __asm__ ("subl %5,%k1\n\tsbbl %3,%k0" : "=r" (bh), "=&r" (bl) : "0" ((USItype)(bh)), "g" ((USItype)(ah)), "1" ((USItype)(bl)), "g" ((USItype)(al)));
   if (bl == 0)
     {
       do { do {} while (0); (c) = __builtin_ctzl (bh); } while (0);
       bit ^= (((32 - 0) + c) << 1) & (al ^ (al >> 1));

       bl = bh >> c;
       bit ^= al & bl;
       goto b_reduced;
     }
   do { do {} while (0); (c) = __builtin_ctzl (bl); } while (0);
   bit ^= (c << 1) & (al ^ (al >> 1));
   bl = ((bh << ((32 - 0) - c)) & ((~ ((mp_limb_t) (0))) >> 0)) | (bl >> c);
   bh >>= c;
 }
      bit ^= al & bl;


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

   do { do {} while (0); (c) = __builtin_ctzl (al); } while (0);
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

  do {} while (0);

  if (bl == 1)

    return 1 - (bit & 2);

  while (ah > 0)
    {
      ah -= (al < bl);
      al -= bl;
      if (al == 0)
 {
   if (ah == 0)
     return 0;
   do { do {} while (0); (c) = __builtin_ctzl (ah); } while (0);
   bit ^= (((32 - 0) + c) << 1) & (bl ^ (bl >> 1));
   al = ah >> c;
   goto ab_reduced;
 }
      do { do {} while (0); (c) = __builtin_ctzl (al); } while (0);

      al = ((ah << ((32 - 0) - c)) & ((~ ((mp_limb_t) (0))) >> 0)) | (al >> c);
      ah >>= c;
      bit ^= (c << 1) & (bl ^ (bl >> 1));
    }
 ab_reduced:
  do {} while (0);
  do {} while (0);

  return __gmpn_jacobi_base (al, bl, bit);
}

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
  do { do {} while (0); (cnt) = __builtin_clzl (d1); } while (0);

  if (cnt != 0)
    {
      mp_limb_t qh, cy;
      mp_ptr np2, dp2;
      dp2 = tp;
      __gmpn_lshift (dp2, dp, dn, cnt);

      np2 = tp + dn;
      cy = __gmpn_lshift (np2, np, nn, cnt);
      np2[nn++] = cy;

      d0 = dp2[dn - 1];
      d0 += (~d0 != 0);
      do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (inv32), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(d0))), "rm" ((USItype)(d0))); } while (0);




      qh = __gmpn_sec_pi1_div_qr (np2 + dn, np2, nn, dp2, dn, inv32, tp + nn + dn);
      do {} while (0);
      do { do {} while (0); do { do {} while (0); do {} while (0); __gmpn_copyi (qp, np2 + dn, nn - dn - 1); } while (0); } while (0);
      qh = np2[nn - 1];




      __gmpn_rshift (np, np2, dn, cnt);


      return qh;

    }
  else
    {



      d0 = dp[dn - 1];
      d0 += (~d0 != 0);
      do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (inv32), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(d0))), "rm" ((USItype)(d0))); } while (0);


      return __gmpn_sec_pi1_div_qr (qp, np, nn, dp, dn, inv32, tp);



    }
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
      do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("mull %3" : "=a" (_ql), "=d" (_qh) : "%0" ((USItype)((r))), "rm" ((USItype)((dinv)))); if (__builtin_constant_p (n0) && (n0) == 0) { _r = ~(_qh + (r)) * (d); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (d); } else { __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (_qh), "=&r" (_ql) : "0" ((USItype)(_qh)), "g" ((USItype)((r) + 1)), "%1" ((USItype)(_ql)), "g" ((USItype)((n0)))); _r = (n0) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) _r -= (d); } (r) = _r; } while (0);
    }
  return r;
}

# 33 "/usr/local/share/frama-c/libc/__fc_define_file.h"
struct __fc_FILE {
  unsigned int __fc_FILE_id;
  unsigned int __fc_FILE_data;
};

# 37 "/usr/local/share/frama-c/libc/__fc_define_file.h"
typedef struct __fc_FILE FILE;

# 60 "/usr/local/share/frama-c/libc/stdio.h"
/* extern */ FILE * __fc_stdout;

# 258 "/usr/local/share/frama-c/libc/stdio.h"
/* extern */ size_t fwrite(const void * ptr,
     size_t size, size_t nmemb,
     FILE * stream);

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




   do
     {
       bp -= 4;
       xlimb = *xp;
       do { __asm__ ("bswap %0" : "=r" (*((mp_ptr) bp)) : "0" (xlimb)); } while (0);
       xp++;
     }
   while (--i > 0);


   do { do {} while (0); (zeros) = __builtin_clzl (xlimb); } while (0);
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


  ssize = 4 + bytes;


  bytes = (xsize >= 0 ? bytes : -bytes);


  do { if (__builtin_expect ((!(sizeof (bytes) >= 4)) != 0, 0)) __gmp_assert_fail ("out_raw.c", 158, "sizeof (bytes) >= 4"); } while (0);

  bp[-4] = bytes >> 24;
  bp[-3] = bytes >> 16;
  bp[-2] = bytes >> 8;
  bp[-1] = bytes;
  bp -= 4;

  if (fp == 0)
    fp = (__fc_stdout);
  if (fwrite (bp, ssize, 1, fp) != 1)
    ssize = 0;

  (*__gmp_free_func) (tp, tsize);
  return ssize;
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

      mp_limb_t dinv, q;

      uh = up[--n];

      q = (uh >= d);
      *qh = q;
      uh -= (-q) & d;

      if ((! ((__builtin_constant_p (16) && (16) == 0) || (!(__builtin_constant_p (16) && (16) == 2147483647L) && (n) >= (16)))))
 {
   cnt = 0;
 plain:
   while (n > 0)
     {
       mp_limb_t ul = up[--n];
       __asm__ ("divl %4" : "=a" (qp[n]), "=d" (uh) : "0" ((USItype)(ul)), "1" ((USItype)(uh)), "rm" ((USItype)(d)));
     }
   return uh >> cnt;
 }
      do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (dinv), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(d))), "rm" ((USItype)(d))); } while (0);
      return __gmpn_div_qr_1n_pi1 (qp, up, n, uh, d, dinv);
    }
  else
    {

      mp_limb_t dinv, ul;

      if (! 0
   && (! ((__builtin_constant_p (2147483647L) && (2147483647L) == 0) || (!(__builtin_constant_p (2147483647L) && (2147483647L) == 2147483647L) && (n) >= (2147483647L)))))
 {
   uh = up[--n];
   __asm__ ("divl %4" : "=a" (*qh), "=d" (uh) : "0" ((USItype)(uh)), "1" ((USItype)(((mp_limb_t) 0L))), "rm" ((USItype)(d)));
   cnt = 0;
   goto plain;
 }

      do { do {} while (0); (cnt) = __builtin_clzl (d); } while (0);
      d <<= cnt;
# 110 "div_qr_1.c"
      uh = up[--n];
      ul = (uh << cnt) | __gmpn_lshift (qp, up, n, cnt);
      uh >>= (32 - cnt);

      if (0
   && (! ((__builtin_constant_p (2147483647L) && (2147483647L) == 0) || (!(__builtin_constant_p (2147483647L) && (2147483647L) == 2147483647L) && (n) >= (2147483647L)))))
 {
   __asm__ ("divl %4" : "=a" (*qh), "=d" (uh) : "0" ((USItype)(ul)), "1" ((USItype)(uh)), "rm" ((USItype)(d)));
   up = qp;
   goto plain;
 }
      do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (dinv), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(d))), "rm" ((USItype)(d))); } while (0);

      do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("mull %3" : "=a" (_ql), "=d" (_qh) : "%0" ((USItype)((uh))), "rm" ((USItype)((dinv)))); if (__builtin_constant_p (ul) && (ul) == 0) { _qh += (uh) + 1; _r = - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); _qh += _mask; _r += _mask & (d); } else { __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (_qh), "=&r" (_ql) : "0" ((USItype)(_qh)), "g" ((USItype)((uh) + 1)), "%1" ((USItype)(_ql)), "g" ((USItype)((ul)))); _r = (ul) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); _qh += _mask; _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) { _r -= (d); _qh++; } } (uh) = _r; (*qh) = _qh; } while (0);
      return __gmpn_div_qr_1n_pi1 (qp, qp, n, uh, d, dinv) >> cnt;
    }
}

# 215 "/usr/local/share/frama-c/libc/stdio.h"
/* extern */ int getc(FILE *stream);

# 236 "/usr/local/share/frama-c/libc/stdio.h"
/* extern */ int ungetc(int c, FILE *stream);

# 697 "../gmp-impl.h"
/* extern */ void * (*__gmp_reallocate_func) (void *, size_t, size_t);

# 68 "inp_str.c"
size_t
__gmpz_inp_str_nowhite (mpz_ptr x, FILE *stream, int base, int c, size_t nread)
{
  char *str;
  size_t alloc_size, str_size;
  int negative;
  mp_size_t xsize;
  const unsigned char *digit_value;

  do { if (__builtin_expect ((!((-1) == -1)) != 0, 0)) __gmp_assert_fail ("inp_str.c", 77, "(-1) == -1"); } while (0);



  digit_value = __gmp_digit_value_tab;
  if (base > 36)
    {


      digit_value += 208;
      if (base > 62)
 return 0;
    }

  negative = 0;
  if (c == '-')
    {
      negative = 1;
      c = getc (stream);
      nread++;
    }

  if (c == (-1) || digit_value[c] >= (base == 0 ? 10 : base))
    return 0;



  if (base == 0)
    {
      base = 10;
      if (c == '0')
 {
   base = 8;
   c = getc (stream);
   nread++;
   if (c == 'x' || c == 'X')
     {
       base = 16;
       c = getc (stream);
       nread++;
     }
   else if (c == 'b' || c == 'B')
     {
       base = 2;
       c = getc (stream);
       nread++;
     }
 }
    }


  while (c == '0')
    {
      c = getc (stream);
      nread++;
    }

  alloc_size = 100;
  str = (char *) (*__gmp_allocate_func) (alloc_size);
  str_size = 0;

  while (c != (-1))
    {
      int dig;
      dig = digit_value[c];
      if (dig >= base)
 break;
      if (str_size >= alloc_size)
 {
   size_t old_alloc_size = alloc_size;
   alloc_size = alloc_size * 3 / 2;
   str = (char *) (*__gmp_reallocate_func) (str, old_alloc_size, alloc_size);
 }
      str[str_size++] = dig;
      c = getc (stream);
    }
  nread += str_size;

  ungetc (c, stream);
  nread--;


  if (str_size == 0)
    {
      ((x)->_mp_size) = 0;
    }
  else
    {
      do { mp_limb_t _ph, _dummy; __asm__ ("mull %3" : "=a" (_dummy), "=d" (_ph) : "%0" ((USItype)(__gmpn_bases[base].log2b)), "rm" ((USItype)((mp_limb_t) (str_size)))); xsize = 8 * _ph / (32 - 0) + 2; } while (0);
      (__builtin_expect (((xsize) > ((x)->_mp_alloc)) != 0, 0) ? (mp_ptr) __gmpz_realloc(x,xsize) : ((x)->_mp_d));


      xsize = __gmpn_set_str (((x)->_mp_d), (unsigned char *) str, str_size, base);
      ((x)->_mp_size) = negative ? -xsize : xsize;
    }
  (*__gmp_free_func) (str, alloc_size);
  return nread;
}

# 37 "sizeinbase.c"
size_t
__gmpz_sizeinbase (mpz_srcptr x, int base)
{
  size_t result;
  do { int __lb_base, __cnt; size_t __totbits; do {} while (0); do {} while (0); do {} while (0); if ((((((x)->_mp_size)) >= 0 ? (((x)->_mp_size)) : -(((x)->_mp_size)))) == 0) (result) = 1; else { do { do {} while (0); (__cnt) = __builtin_clzl ((((x)->_mp_d))[(((((x)->_mp_size)) >= 0 ? (((x)->_mp_size)) : -(((x)->_mp_size))))-1]); } while (0); __totbits = (size_t) (((((x)->_mp_size)) >= 0 ? (((x)->_mp_size)) : -(((x)->_mp_size)))) * (32 - 0) - (__cnt - 0); if ((((base) & ((base) - 1)) == 0)) { __lb_base = __gmpn_bases[base].big_base; (result) = (__totbits + __lb_base - 1) / __lb_base; } else { do { mp_limb_t _ph, _dummy; size_t _nbits = (__totbits); __asm__ ("mull %3" : "=a" (_dummy), "=d" (_ph) : "%0" ((USItype)(__gmpn_bases[base].logb2 + 1)), "rm" ((USItype)(_nbits))); result = _ph + 1; } while (0); } } } while (0);
  return result;
}

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
    do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (*ip), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(*dp))), "rm" ((USItype)(*dp))); } while (0);
  else if ((! ((__builtin_constant_p (13) && (13) == 0) || (!(__builtin_constant_p (13) && (13) == 2147483647L) && (n) >= (13)))))
    {

 mp_size_t i;
 mp_ptr xp;

 xp = scratch;

 i = n;
 do
   xp[--i] = ((~ ((mp_limb_t) (0))) >> 0);
 while (i);
 do { mp_ptr __d = (xp + n); mp_srcptr __s = (dp); mp_size_t __n = (n); do {} while (0); do {} while (0); do *__d++ = (~ *__s++) & ((~ ((mp_limb_t) (0))) >> 0); while (--__n); } while (0);
 if (n == 2) {
   __gmpn_divrem_2 (ip, 0, xp, 4, dp);
 } else {
   gmp_pi1_t inv;
   do { mp_limb_t _v, _p, _t1, _t0, _mask; do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (_v), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(dp[n-1]))), "rm" ((USItype)(dp[n-1]))); } while (0); _p = (dp[n-1]) * _v; _p += (dp[n-2]); if (_p < (dp[n-2])) { _v--; _mask = -(mp_limb_t) (_p >= (dp[n-1])); _p -= (dp[n-1]); _v += _mask; _p -= _mask & (dp[n-1]); } __asm__ ("mull %3" : "=a" (_t0), "=d" (_t1) : "%0" ((USItype)(dp[n-2])), "rm" ((USItype)(_v))); _p += _t1; if (_p < _t1) { _v--; if (__builtin_expect ((_p >= (dp[n-1])) != 0, 0)) { if (_p > (dp[n-1]) || _t0 >= (dp[n-2])) _v--; } } (inv).inv32 = _v; } while (0);

   __gmpn_sbpi1_div_q (ip, xp, 2 * n, dp, n, inv.inv32);
 }
    }
  else {
      mp_limb_t e;

      do {} while (0);
      e = __gmpn_ni_invertappr (ip, dp, n, scratch);

      if (__builtin_expect ((e) != 0, 0)) {

 __gmpn_mul_n (scratch, ip, dp, n);
 e = __gmpn_add_n (scratch, scratch, dp, n);
 if (__builtin_expect ((e) != 0, 1))
   e = __gmpn_add_nc (scratch + n, scratch + n, dp, n, e);

 e ^= ((mp_limb_t) 1L);
 do { mp_ptr __ptr_dummy; if (__builtin_constant_p (e) && (e) == 0) { } else if (__builtin_constant_p (e) && (e) == 1) { __asm__ __volatile__ ("\n" ".L" "asm_%=_" "top" ":\n" "\t" "addl" "\t$1, (%0)\n" "\tlea\t%c2(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" : "=r" (__ptr_dummy) : "0" (ip), "n" (sizeof(mp_limb_t)) : "memory"); } else { __asm__ __volatile__ ( "addl" "\t%2, (%0)\n" "\tjnc\t" ".L" "asm_%=_" "done" "\n" ".L" "asm_%=_" "top" ":\n" "\t" "addl" "\t$1, %c3(%0)\n" "\tlea\t%c3(%0), %0\n" "\tjc\t" ".L" "asm_%=_" "top" "\n" ".L" "asm_%=_" "done" ":\n" : "=r" (__ptr_dummy) : "0" (ip), "re" ((mp_limb_t) (e)), "n" (sizeof(mp_limb_t)) : "memory"); } } while (0);
      }
  }
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



  if (! 0
      && (! ((__builtin_constant_p (11) && (11) == 0) || (!(__builtin_constant_p (11) && (11) == 2147483647L) && (un) >= (11)))))
    {
      for (i = un - 1; i >= 0; i--)
 {
   n0 = up[i] << 0;
   __asm__ ("divl %4" : "=a" (dummy), "=d" (r) : "0" ((USItype)(n0)), "1" ((USItype)(r)), "rm" ((USItype)(d)));
   r >>= 0;
 }
      return r;
    }

  do { do {} while (0); (cnt) = __builtin_clzl (d); } while (0);
  d <<= cnt;

  n1 = up[un - 1] << 0;
  r = (r << cnt) | (n1 >> (32 - cnt));

  if (0
      && (! ((__builtin_constant_p (11) && (11) == 0) || (!(__builtin_constant_p (11) && (11) == 2147483647L) && (un) >= (11)))))
    {
      mp_limb_t nshift;
      for (i = un - 2; i >= 0; i--)
 {
   n0 = up[i] << 0;
   nshift = (n1 << cnt) | (n0 >> ((32 - 0) - cnt));
   __asm__ ("divl %4" : "=a" (dummy), "=d" (r) : "0" ((USItype)(nshift)), "1" ((USItype)(r)), "rm" ((USItype)(d)));
   r >>= 0;
   n1 = n0;
 }
      __asm__ ("divl %4" : "=a" (dummy), "=d" (r) : "0" ((USItype)(n1 << cnt)), "1" ((USItype)(r)), "rm" ((USItype)(d)));
      r >>= 0;
      return r >> cnt;
    }
  else
    {
      mp_limb_t inv, nshift;
      do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (inv), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(d))), "rm" ((USItype)(d))); } while (0);

      for (i = un - 2; i >= 0; i--)
 {
   n0 = up[i] << 0;
   nshift = (n1 << cnt) | (n0 >> ((32 - 0) - cnt));
   do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("mull %3" : "=a" (_ql), "=d" (_qh) : "%0" ((USItype)((r))), "rm" ((USItype)((inv)))); if (__builtin_constant_p (nshift) && (nshift) == 0) { _r = ~(_qh + (r)) * (d); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (d); } else { __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (_qh), "=&r" (_ql) : "0" ((USItype)(_qh)), "g" ((USItype)((r) + 1)), "%1" ((USItype)(_ql)), "g" ((USItype)((nshift)))); _r = (nshift) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) _r -= (d); } (r) = _r; } while (0);
   r >>= 0;
   n1 = n0;
 }
      do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("mull %3" : "=a" (_ql), "=d" (_qh) : "%0" ((USItype)((r))), "rm" ((USItype)((inv)))); if (__builtin_constant_p (n1 << cnt) && (n1 << cnt) == 0) { _r = ~(_qh + (r)) * (d); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (d); } else { __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (_qh), "=&r" (_ql) : "0" ((USItype)(_qh)), "g" ((USItype)((r) + 1)), "%1" ((USItype)(_ql)), "g" ((USItype)((n1 << cnt)))); _r = (n1 << cnt) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) _r -= (d); } (r) = _r; } while (0);
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



  r = up[un - 1] << 0;
  if (r >= d)
    r -= d;
  r >>= 0;
  un--;
  if (un == 0)
    return r;

  if ((! ((__builtin_constant_p (18) && (18) == 0) || (!(__builtin_constant_p (18) && (18) == 2147483647L) && (un) >= (18)))))
    {
      for (i = un - 1; i >= 0; i--)
 {
   n0 = up[i] << 0;
   __asm__ ("divl %4" : "=a" (dummy), "=d" (r) : "0" ((USItype)(n0)), "1" ((USItype)(r)), "rm" ((USItype)(d)));
   r >>= 0;
 }
      return r;
    }
  else
    {
      mp_limb_t inv;
      do { mp_limb_t _dummy; do {} while (0); __asm__ ("divl %4" : "=a" (inv), "=d" (_dummy) : "0" ((USItype)(~((mp_limb_t) 0L))), "1" ((USItype)(~(d))), "rm" ((USItype)(d))); } while (0);
      for (i = un - 1; i >= 0; i--)
 {
   n0 = up[i] << 0;
   do { mp_limb_t _qh, _ql, _r, _mask; __asm__ ("mull %3" : "=a" (_ql), "=d" (_qh) : "%0" ((USItype)((r))), "rm" ((USItype)((inv)))); if (__builtin_constant_p (n0) && (n0) == 0) { _r = ~(_qh + (r)) * (d); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (d); } else { __asm__ ("addl %5,%k1\n\tadcl %3,%k0" : "=r" (_qh), "=&r" (_ql) : "0" ((USItype)(_qh)), "g" ((USItype)((r) + 1)), "%1" ((USItype)(_ql)), "g" ((USItype)((n0)))); _r = (n0) - _qh * (d); _mask = -(mp_limb_t) (_r > _ql); _r += _mask & (d); if (__builtin_expect ((_r >= (d)) != 0, 0)) _r -= (d); } (r) = _r; } while (0);
   r >>= 0;
 }
      return r;
    }
}

