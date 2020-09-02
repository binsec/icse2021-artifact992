# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 2307 "tcctest.c"
static char * strncat1(char * dest,const char * src,size_t count)
{
char *d0, *d1;
int d2, d3;
__asm__ __volatile__(
 "repne\n\t"
 "scasb\n\t"
 "decl %1\n\t"
 "movl %8,%3\n"
 "1:\tdecl %3\n\t"
 "js 2f\n\t"
 "lodsb\n\t"
 "stosb\n\t"
 "testb %%al,%%al\n\t"
 "jne 1b\n"
 "2:\txorl %2,%2\n\t"
 "stosb"
 : "=&S" (d0), "=&D" (d1), "=&a" (d2), "=&c" (d3)
 : "0" (src),"1" (dest),"2" (0),"3" (0xffffffff), "g" (count)
 : "memory");
return dest;
}

# 2329 "tcctest.c"
static char * strncat2(char * dest,const char * src,size_t count)
{
char *d0, *d1;
int d2, d3;
__asm__ __volatile__(
 "repne scasb\n\t" /* one-line repne prefix + string op */
 "decl %1\n\t"
 "movl %8,%3\n"
 "1:\tdecl %3\n\t"
 "js 2f\n\t"
 "lodsb\n\t"
 "stosb\n\t"
 "testb %%al,%%al\n\t"
 "jne 1b\n"
 "2:\txorl %2,%2\n\t"
 "stosb"
 : "=&S" (d0), "=&D" (d1), "=&a" (d2), "=&c" (d3)
 : "0" (src),"1" (dest),"2" (0),"3" (0xffffffff), "g" (count)
 : "memory");
return dest;
}

# 2350 "tcctest.c"
static inline void * memcpy1(void * to, const void * from, size_t n)
{
int d0, d1, d2;
__asm__ __volatile__(
 "rep ; movsl\n\t"
 "testb $2,%b4\n\t"
 "je 1f\n\t"
 "movsw\n"
 "1:\ttestb $1,%b4\n\t"
 "je 2f\n\t"
 "movsb\n"
 "2:"
 : "=&c" (d0), "=&D" (d1), "=&S" (d2)
 :"0" (n/4), "q" (n),"1" ((long) to),"2" ((long) from)
 : "memory");
return (to);
}

# 2368 "tcctest.c"
static inline void * memcpy2(void * to, const void * from, size_t n)
{
int d0, d1, d2;
__asm__ __volatile__(
 "rep movsl\n\t" /* one-line rep prefix + string op */
 "testb $2,%b4\n\t"
 "je 1f\n\t"
 "movsw\n"
 "1:\ttestb $1,%b4\n\t"
 "je 2f\n\t"
 "movsb\n"
 "2:"
 : "=&c" (d0), "=&D" (d1), "=&S" (d2)
 :"0" (n/4), "q" (n),"1" ((long) to),"2" ((long) from)
 : "memory");
return (to);
}

# 2386 "tcctest.c"
static __inline__ void sigaddset1(unsigned int *set, int _sig)
{
 __asm__("btsl %1,%0" : "=m"(*set) : "Ir"(_sig - 1) : "cc");
}

# 2391 "tcctest.c"
static __inline__ void sigdelset1(unsigned int *set, int _sig)
{
 asm("btrl %1,%0" : "=m"(*set) : "Ir"(_sig - 1) : "cc");
}

# 2396 "tcctest.c"
static __inline__ __const__ unsigned int swab32(unsigned int x)
{
 __asm__("xchgb %b0,%h0\n\t" /* swap lower bytes	*/
  "rorl $16,%0\n\t" /* swap words		*/
  "xchgb %b0,%h0" /* swap higher bytes	*/
  :"=q" (x)
  : "0" (x));
 return x;
}

# 2406 "tcctest.c"
static __inline__ unsigned long long mul64(unsigned int a, unsigned int b)
{
    unsigned long long res;
    __asm__("mull %2" : "=A" (res) : "a" (a), "r" (b));
    return res;
}

# 2413 "tcctest.c"
static __inline__ unsigned long long inc64(unsigned long long a)
{
    unsigned long long res;
    __asm__("addl $1, %%eax ; adcl $0, %%edx" : "=A" (res) : "A" (a));
    return res;
}

# 2420 "tcctest.c"
unsigned int set;

# 36 "libtcc1.c"
typedef int Wtype;

# 37 "libtcc1.c"
typedef unsigned int UWtype;

# 38 "libtcc1.c"
typedef unsigned int USItype;

# 39 "libtcc1.c"
typedef long long DWtype;

# 40 "libtcc1.c"
typedef unsigned long long UDWtype;

# 42 "libtcc1.c"
struct DWstruct {
    Wtype low, high;
};

# 46 "libtcc1.c"
typedef union
{
  struct DWstruct s;
  DWtype ll;
} DWunion;

# 150 "libtcc1.c"
static UDWtype __udivmoddi4 (UDWtype n, UDWtype d, UDWtype *rp)
{
  DWunion ww;
  DWunion nn, dd;
  DWunion rr;
  UWtype d0, d1, n0, n1, n2;
  UWtype q0, q1;
  UWtype b, bm;

  nn.ll = n;
  dd.ll = d;

  d0 = dd.s.low;
  d1 = dd.s.high;
  n0 = nn.s.low;
  n1 = nn.s.high;


  if (d1 == 0)
    {
      if (d0 > n1)
 {
   /* 0q = nn / 0D */

   __asm__ ("divl %4" : "=a" (q0), "=d" (n0) : "0" ((USItype) n0), "1" ((USItype) (n1)), "rm" ((USItype) (d0)));
   q1 = 0;

   /* Remainder in n0.  */
 }
      else
 {
   /* qq = NN / 0d */

   if (d0 == 0)
     d0 = 1 / d0; /* Divide intentionally by zero.  */

   __asm__ ("divl %4" : "=a" (q1), "=d" (n1) : "0" ((USItype) (n1)), "1" ((USItype) (0)), "rm" ((USItype) (d0)));
   __asm__ ("divl %4" : "=a" (q0), "=d" (n0) : "0" ((USItype) (n0)), "1" ((USItype) (n1)), "rm" ((USItype) (d0)));

   /* Remainder in n0.  */
 }

      if (rp != 0)
 {
   rr.s.low = n0;
   rr.s.high = 0;
   *rp = rr.ll;
 }
    }
# 276 "libtcc1.c"
  else
    {
      if (d1 > n1)
 {
   /* 00 = nn / DD */

   q0 = 0;
   q1 = 0;

   /* Remainder in n1n0.  */
   if (rp != 0)
     {
       rr.s.low = n0;
       rr.s.high = n1;
       *rp = rr.ll;
     }
 }
      else
 {
   /* 0q = NN / dd */

   do { USItype __cbtmp; __asm__ ("bsrl %1,%0" : "=r" (__cbtmp) : "rm" ((USItype) (d1))); (bm) = __cbtmp ^ 31; } while (0);
   if (bm == 0)
     {
       /* From (n1 >= d1) /\ (the most significant bit of d1 is set),
		 conclude (the most significant bit of n1 is set) /\ (the
		 quotient digit q0 = 0 or 1).

		 This special case is necessary, not an optimization.  */

       /* The condition on the next line takes advantage of that
		 n1 >= d1 (true due to program flow).  */
       if (n1 > d1 || n0 >= d0)
  {
    q0 = 1;
    __asm__ ("subl %5,%1\n\tsbbl %3,%0" : "=r" (n1), "=&r" (n0) : "0" ((USItype) (n1)), "g" ((USItype) (d1)), "1" ((USItype) (n0)), "g" ((USItype) (d0)));
  }
       else
  q0 = 0;

       q1 = 0;

       if (rp != 0)
  {
    rr.s.low = n0;
    rr.s.high = n1;
    *rp = rr.ll;
  }
     }
   else
     {
       UWtype m1, m0;
       /* Normalize.  */

       b = 32 - bm;

       d1 = (d1 << bm) | (d0 >> b);
       d0 = d0 << bm;
       n2 = n1 >> b;
       n1 = (n1 << bm) | (n0 >> b);
       n0 = n0 << bm;

       __asm__ ("divl %4" : "=a" (q0), "=d" (n1) : "0" ((USItype) (n1)), "1" ((USItype) (n2)), "rm" ((USItype) (d1)));
       __asm__ ("mull %3" : "=a" (m0), "=d" (m1) : "%0" ((USItype) (q0)), "rm" ((USItype) (d0)));

       if (m1 > n1 || (m1 == n1 && m0 > n0))
  {
    q0--;
    __asm__ ("subl %5,%1\n\tsbbl %3,%0" : "=r" (m1), "=&r" (m0) : "0" ((USItype) (m1)), "g" ((USItype) (d1)), "1" ((USItype) (m0)), "g" ((USItype) (d0)));
  }

       q1 = 0;

       /* Remainder in (n1n0 - m1m0) >> bm.  */
       if (rp != 0)
  {
    __asm__ ("subl %5,%1\n\tsbbl %3,%0" : "=r" (n1), "=&r" (n0) : "0" ((USItype) (n1)), "g" ((USItype) (m1)), "1" ((USItype) (n0)), "g" ((USItype) (m0)));
    rr.s.low = (n1 << b) | (n0 >> bm);
    rr.s.high = n1 >> bm;
    *rp = rr.ll;
  }
     }
 }
    }

  ww.s.low = q0;
  ww.s.high = q1;
  return ww.ll;
}

