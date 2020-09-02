# 69 "/usr/include/assert.h"
extern void __assert_fail (const char *__assertion, const char *__file,
      unsigned int __line, const char *__function);

# 28 "sshbn.c"
typedef unsigned long BignumInt;

# 29 "sshbn.c"
typedef unsigned long long BignumDblInt;

# 600 "sshbn.c"
static void internal_add_shifted(BignumInt *number,
     unsigned n, int shift)
{
    int word = 1 + (shift / 32);
    int bshift = shift % 32;
    BignumDblInt addend;

    addend = (BignumDblInt)n << bshift;

    while (addend) {
        ((word <= number[0]) ? (void) (0) : __assert_fail ("word <= number[0]", "sshbn.c", 610, __PRETTY_FUNCTION__));
 addend += number[word];
 number[word] = (BignumInt) addend & 0xFFFFFFFFUL;
 addend >>= 32;
 word++;
    }
}

# 628 "sshbn.c"
static void internal_mod(BignumInt *a, int alen,
    BignumInt *m, int mlen,
    BignumInt *quot, int qshift)
{
    BignumInt m0, m1;
    unsigned int h;
    int i, k;

    m0 = m[0];
    ((m0 >> (32 -1) == 1) ? (void) (0) : __assert_fail ("m0 >> (32-1) == 1", "sshbn.c", 637, __PRETTY_FUNCTION__));
    if (mlen > 1)
 m1 = m[1];
    else
 m1 = 0;

    for (i = 0; i <= alen - mlen; i++) {
 BignumDblInt t;
 unsigned int q, r, c, ai1;

 if (i == 0) {
     h = 0;
 } else {
     h = a[i - 1];
     a[i - 1] = 0;
 }

 if (i == alen - 1)
     ai1 = 0;
 else
     ai1 = a[i + 1];

 /* Find q = h:a[i] / m0 */
 if (h >= m0) {
     /*
	     * Special case.
	     * 
	     * To illustrate it, suppose a BignumInt is 8 bits, and
	     * we are dividing (say) A1:23:45:67 by A1:B2:C3. Then
	     * our initial division will be 0xA123 / 0xA1, which
	     * will give a quotient of 0x100 and a divide overflow.
	     * However, the invariants in this division algorithm
	     * are not violated, since the full number A1:23:... is
	     * _less_ than the quotient prefix A1:B2:... and so the
	     * following correction loop would have sorted it out.
	     * 
	     * In this situation we set q to be the largest
	     * quotient we _can_ stomach (0xFF, of course).
	     */
     q = 0xFFFFFFFFUL;
 } else {
     /* Macro doesn't want an array subscript expression passed
	     * into it (see definition), so use a temporary. */
     BignumInt tmplo = a[i];
     __asm__("div %2" : "=d" (r), "=a" (q) : "r" (m0), "d" (h), "a" (tmplo));

     /* Refine our estimate of q by looking at
	     h:a[i]:a[i+1] / m0:m1 */
     t = ((BignumDblInt)m1 * q);
     if (t > ((BignumDblInt) r << 32) + ai1) {
  q--;
  t -= m1;
  r = (r + m0) & 0xFFFFFFFFUL; /* overflow? */
  if (r >= (BignumDblInt) m0 &&
      t > ((BignumDblInt) r << 32) + ai1) q--;
     }
 }

 /* Subtract q * m from a[i...] */
 c = 0;
 for (k = mlen - 1; k >= 0; k--) {
     t = ((BignumDblInt)q * m[k]);
     t += c;
     c = (unsigned)(t >> 32);
     if ((BignumInt) t > a[i + k])
  c++;
     a[i + k] -= (BignumInt) t;
 }

 /* Add back m in case of borrow */
 if (c != h) {
     t = 0;
     for (k = mlen - 1; k >= 0; k--) {
  t += m[k];
  t += a[i + k];
  a[i + k] = (BignumInt) t;
  t = t >> 32;
     }
     q--;
 }
 if (quot)
     internal_add_shifted(quot, q, qshift + 32 * (alen - mlen - i));
    }
}

