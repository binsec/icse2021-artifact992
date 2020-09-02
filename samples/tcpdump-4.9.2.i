# 300 "./netdissect-stdinc.h"
static __inline__ unsigned long __ntohl (unsigned long x)
  {
    __asm__ ("xchgb %b0, %h0\n\t" /* swap lower bytes  */
             "rorl  $16, %0\n\t" /* swap words        */
             "xchgb %b0, %h0" /* swap higher bytes */
            : "=q" (x) : "0" (x));
    return (x);
  }

# 309 "./netdissect-stdinc.h"
static __inline__ unsigned short __ntohs (unsigned short x)
  {
    __asm__ ("xchgb %b0, %h0" /* swap bytes */
            : "=q" (x) : "0" (x));
    return (x);
  }

