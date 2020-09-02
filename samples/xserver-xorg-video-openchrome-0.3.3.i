# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 1461 "/usr/include/xorg/compiler.h"
static __inline__ void
outb(unsigned short port, unsigned char val)
{
    __asm__ __volatile__("out%B0 (%1)"::"a"(val), "d"(port));
}

# 1467 "/usr/include/xorg/compiler.h"
static __inline__ void
outw(unsigned short port, unsigned short val)
{
    __asm__ __volatile__("out%W0 (%1)"::"a"(val), "d"(port));
}

# 1473 "/usr/include/xorg/compiler.h"
static __inline__ void
outl(unsigned short port, unsigned int val)
{
    __asm__ __volatile__("out%L0 (%1)"::"a"(val), "d"(port));
}

# 1479 "/usr/include/xorg/compiler.h"
static __inline__ unsigned int
inb(unsigned short port)
{
    unsigned char ret;
    __asm__ __volatile__("in%B0 (%1)":"=a"(ret):"d"(port));

    return ret;
}

# 1488 "/usr/include/xorg/compiler.h"
static __inline__ unsigned int
inw(unsigned short port)
{
    unsigned short ret;
    __asm__ __volatile__("in%W0 (%1)":"=a"(ret):"d"(port));

    return ret;
}

# 1497 "/usr/include/xorg/compiler.h"
static __inline__ unsigned int
inl(unsigned short port)
{
    unsigned int ret;
    __asm__ __volatile__("in%L0 (%1)":"=a"(ret):"d"(port));

    return ret;
}

# 357 "../../src/via_memcpy.c"
static __inline void *
__memcpy(void *to, const void *from, size_t n)
{
    int d1, d2, d3;

    __asm__ __volatile__(
                         "rep ; movsl\n\t"
                         "testb $2,%b4\n\t"
                         "je 1f\n\t"
                         "movsw\n"
                         "1:\ttestb $1,%b4\n\t"
                         "je 2f\n\t"
                         "movsb\n"
                         "2:"
                         :"=&c"(d1), "=&D"(d2), "=&S"(d3)
                         :"0"(n >> 2), "q"(n), "1"((long)to), "2"((long)from)
                         :"memory");

    return (to);
}

# 419 "../../src/via_memcpy.c"
static void sse_YUV42X(unsigned char *to, const unsigned char *from, int dstPitch, int w, int h, int yuv422) { int dadd, rest, count, hc, lcnt; register int dummy; __asm__ __volatile__ ( "1:  " "  prefetchnta " "(%0)\n" "  prefetchnta " "32(%0)\n" "  prefetchnta " "64(%0)\n" "  prefetchnta " "96(%0)\n" "  prefetchnta " "128(%0)\n" "  prefetchnta " "160(%0)\n" "  prefetchnta " "192(%0)\n" "  prefetchnta " "256(%0)\n" "  prefetchnta " "288(%0)\n" "2:\n" : : "r" (from) );; ; count = 2; /* If destination pitch equals width, do it all in one go. */ if (yuv422) { w <<= 1; if (w == dstPitch) { w *= h; h = 1; dstPitch = w; count = 0; } else { h -= 1; count = 1; } } else if (w == dstPitch) { w = h*(w + (w >> 1)); count = 0; h = 1; dstPitch = w; } lcnt = w >> 6; rest = w & 63; while (count--) { hc = h; lcnt = w >> 6; rest = w & 63; dadd = dstPitch - w; while (hc--) { if (lcnt) { if ((unsigned long) from & 15) { __asm__ __volatile__ ( "1:\n" "  prefetchnta " "320(%1)\n" "  movups (%1), %%xmm0\n" "  movups 16(%1), %%xmm1\n" "  movntps %%xmm0, (%0)\n" "  movntps %%xmm1, 16(%0)\n" "  prefetchnta " "352(%1)\n" "  movups 32(%1), %%xmm2\n" "  movups 48(%1), %%xmm3\n" "  movntps %%xmm2, 32(%0)\n" "  movntps %%xmm3, 48(%0)\n" "  addl $64,%0\n" "  addl $64,%1\n" "  decl %2\n" "  jne 1b\n" :"=&D"(to), "=&S"(from), "=&r"(dummy) :"0" (to), "1" (from), "2" (lcnt): "memory"); } else { __asm__ __volatile__ ( "2:\n" "  prefetchnta " "320(%1)\n" "  movaps (%1), %%xmm0\n" "  movaps 16(%1), %%xmm1\n" "  movntps %%xmm0, (%0)\n" "  movntps %%xmm1, 16(%0)\n" "  prefetchnta " "352(%1)\n" "  movaps 32(%1), %%xmm2\n" "  movaps 48(%1), %%xmm3\n" "  movntps %%xmm2, 32(%0)\n" "  movntps %%xmm3, 48(%0)\n" "  addl $64,%0\n" "  addl $64,%1\n" "  decl %2\n" "  jne 2b\n" :"=&D"(to), "=&S"(from), "=&r"(dummy) :"0" (to), "1" (from), "2" (lcnt): "memory"); }; } if (rest) { __asm__ __volatile__ ( "  prefetchnta " "320(%0)\n" : : "r" (from) );; { __asm__ __volatile__( "movl %2,%%ecx\n\t" "sarl $2,%%ecx\n\t" "rep ; movsl\n\t" "testb $2,%b2\n\t" "je 1f\n\t" "movsw\n" "1:\ttestb $1,%b2\n\t" "je 2f\n\t" "movsb\n" "2:" :"=&D" (to), "=&S" (from) :"q" (rest),"0" ((long) to),"1" ((long) from) : "%ecx","memory"); }; __asm__ __volatile__ ( "  prefetchnta " "288(%0)\n" : : "r" (from) );; } to += dadd; } w >>= 1; dstPitch >>= 1; h -= 1; } if (lcnt > 5) { lcnt -= 5; if ((unsigned long) from & 15) { __asm__ __volatile__ ( "1:\n" "  prefetchnta " "320(%1)\n" "  movups (%1), %%xmm0\n" "  movups 16(%1), %%xmm1\n" "  movntps %%xmm0, (%0)\n" "  movntps %%xmm1, 16(%0)\n" "  prefetchnta " "352(%1)\n" "  movups 32(%1), %%xmm2\n" "  movups 48(%1), %%xmm3\n" "  movntps %%xmm2, 32(%0)\n" "  movntps %%xmm3, 48(%0)\n" "  addl $64,%0\n" "  addl $64,%1\n" "  decl %2\n" "  jne 1b\n" :"=&D"(to), "=&S"(from), "=&r"(dummy) :"0" (to), "1" (from), "2" (lcnt): "memory"); } else { __asm__ __volatile__ ( "2:\n" "  prefetchnta " "320(%1)\n" "  movaps (%1), %%xmm0\n" "  movaps 16(%1), %%xmm1\n" "  movntps %%xmm0, (%0)\n" "  movntps %%xmm1, 16(%0)\n" "  prefetchnta " "352(%1)\n" "  movaps 32(%1), %%xmm2\n" "  movaps 48(%1), %%xmm3\n" "  movntps %%xmm2, 32(%0)\n" "  movntps %%xmm3, 48(%0)\n" "  addl $64,%0\n" "  addl $64,%1\n" "  decl %2\n" "  jne 2b\n" :"=&D"(to), "=&S"(from), "=&r"(dummy) :"0" (to), "1" (from), "2" (lcnt): "memory"); }; lcnt = 5; } if (lcnt) { if ((unsigned long) from & 15) { __asm__ __volatile__ ( "1:\n" "#" "320(%1)\n" "  movups (%1), %%xmm0\n" "  movups 16(%1), %%xmm1\n" "  movntps %%xmm0, (%0)\n" "  movntps %%xmm1, 16(%0)\n" "#" "352(%1)\n" "  movups 32(%1), %%xmm2\n" "  movups 48(%1), %%xmm3\n" "  movntps %%xmm2, 32(%0)\n" "  movntps %%xmm3, 48(%0)\n" "  addl $64,%0\n" "  addl $64,%1\n" "  decl %2\n" "  jne 1b\n" :"=&D"(to), "=&S"(from), "=&r"(dummy) :"0" (to), "1" (from), "2" (lcnt): "memory"); } else { __asm__ __volatile__ ( "2:\n" "#" "320(%1)\n" "  movaps (%1), %%xmm0\n" "  movaps 16(%1), %%xmm1\n" "  movntps %%xmm0, (%0)\n" "  movntps %%xmm1, 16(%0)\n" "#" "352(%1)\n" "  movaps 32(%1), %%xmm2\n" "  movaps 48(%1), %%xmm3\n" "  movntps %%xmm2, 32(%0)\n" "  movntps %%xmm3, 48(%0)\n" "  addl $64,%0\n" "  addl $64,%1\n" "  decl %2\n" "  jne 2b\n" :"=&D"(to), "=&S"(from), "=&r"(dummy) :"0" (to), "1" (from), "2" (lcnt): "memory"); }; } if (rest) { __asm__ __volatile__( "movl %2,%%ecx\n\t" "sarl $2,%%ecx\n\t" "rep ; movsl\n\t" "testb $2,%b2\n\t" "je 1f\n\t" "movsw\n" "1:\ttestb $1,%b2\n\t" "je 2f\n\t" "movsb\n" "2:" :"=&D" (to), "=&S" (from) :"q" (rest),"0" ((long) to),"1" ((long) from) : "%ecx","memory"); }; __asm__ __volatile__ ("sfence":::"memory");; }

# 420 "../../src/via_memcpy.c"
static void mmxext_YUV42X(unsigned char *to, const unsigned char *from, int dstPitch, int w, int h, int yuv422) { int dadd, rest, count, hc, lcnt; register int dummy; __asm__ __volatile__ ( "1:  " "  prefetchnta " "(%0)\n" "  prefetchnta " "32(%0)\n" "  prefetchnta " "64(%0)\n" "  prefetchnta " "96(%0)\n" "  prefetchnta " "128(%0)\n" "  prefetchnta " "160(%0)\n" "  prefetchnta " "192(%0)\n" "  prefetchnta " "256(%0)\n" "  prefetchnta " "288(%0)\n" "2:\n" : : "r" (from) );; __asm__ __volatile__("emms":::"memory");; count = 2; /* If destination pitch equals width, do it all in one go. */ if (yuv422) { w <<= 1; if (w == dstPitch) { w *= h; h = 1; dstPitch = w; count = 0; } else { h -= 1; count = 1; } } else if (w == dstPitch) { w = h*(w + (w >> 1)); count = 0; h = 1; dstPitch = w; } lcnt = w >> 6; rest = w & 63; while (count--) { hc = h; lcnt = w >> 6; rest = w & 63; dadd = dstPitch - w; while (hc--) { if (lcnt) { __asm__ __volatile__ ( ".p2align 4,,7\n" "1:\n" "  prefetchnta " "320(%1)\n" "  movq (%1), %%mm0\n" "  movq 8(%1), %%mm1\n" "  movq 16(%1), %%mm2\n" "  movq 24(%1), %%mm3\n" "  movntq %%mm0, (%0)\n" "  movntq %%mm1, 8(%0)\n" "  movntq %%mm2, 16(%0)\n" "  movntq %%mm3, 24(%0)\n" "  prefetchnta " "352(%1)\n" "  movq 32(%1), %%mm0\n" "  movq 40(%1), %%mm1\n" "  movq 48(%1), %%mm2\n" "  movq 56(%1), %%mm3\n" "  movntq %%mm0, 32(%0)\n" "  movntq %%mm1, 40(%0)\n" "  movntq %%mm2, 48(%0)\n" "  movntq %%mm3, 56(%0)\n" "  addl $64,%0\n" "  addl $64,%1\n" "  decl %2\n" "  jne 1b\n" :"=&D"(to), "=&S"(from), "=&r"(dummy) :"0" (to), "1" (from), "2" (lcnt) : "memory");; } if (rest) { __asm__ __volatile__ ( "  prefetchnta " "320(%0)\n" : : "r" (from) );; { __asm__ __volatile__( "movl %2,%%ecx\n\t" "sarl $2,%%ecx\n\t" "rep ; movsl\n\t" "testb $2,%b2\n\t" "je 1f\n\t" "movsw\n" "1:\ttestb $1,%b2\n\t" "je 2f\n\t" "movsb\n" "2:" :"=&D" (to), "=&S" (from) :"q" (rest),"0" ((long) to),"1" ((long) from) : "%ecx","memory"); }; __asm__ __volatile__ ( "  prefetchnta " "288(%0)\n" : : "r" (from) );; } to += dadd; } w >>= 1; dstPitch >>= 1; h -= 1; } if (lcnt > 5) { lcnt -= 5; __asm__ __volatile__ ( ".p2align 4,,7\n" "1:\n" "  prefetchnta " "320(%1)\n" "  movq (%1), %%mm0\n" "  movq 8(%1), %%mm1\n" "  movq 16(%1), %%mm2\n" "  movq 24(%1), %%mm3\n" "  movntq %%mm0, (%0)\n" "  movntq %%mm1, 8(%0)\n" "  movntq %%mm2, 16(%0)\n" "  movntq %%mm3, 24(%0)\n" "  prefetchnta " "352(%1)\n" "  movq 32(%1), %%mm0\n" "  movq 40(%1), %%mm1\n" "  movq 48(%1), %%mm2\n" "  movq 56(%1), %%mm3\n" "  movntq %%mm0, 32(%0)\n" "  movntq %%mm1, 40(%0)\n" "  movntq %%mm2, 48(%0)\n" "  movntq %%mm3, 56(%0)\n" "  addl $64,%0\n" "  addl $64,%1\n" "  decl %2\n" "  jne 1b\n" :"=&D"(to), "=&S"(from), "=&r"(dummy) :"0" (to), "1" (from), "2" (lcnt) : "memory");; lcnt = 5; } if (lcnt) { __asm__ __volatile__ ( ".p2align 4,,7\n" "1:\n" "#" "320(%1)\n" "  movq (%1), %%mm0\n" "  movq 8(%1), %%mm1\n" "  movq 16(%1), %%mm2\n" "  movq 24(%1), %%mm3\n" "  movntq %%mm0, (%0)\n" "  movntq %%mm1, 8(%0)\n" "  movntq %%mm2, 16(%0)\n" "  movntq %%mm3, 24(%0)\n" "#" "352(%1)\n" "  movq 32(%1), %%mm0\n" "  movq 40(%1), %%mm1\n" "  movq 48(%1), %%mm2\n" "  movq 56(%1), %%mm3\n" "  movntq %%mm0, 32(%0)\n" "  movntq %%mm1, 40(%0)\n" "  movntq %%mm2, 48(%0)\n" "  movntq %%mm3, 56(%0)\n" "  addl $64,%0\n" "  addl $64,%1\n" "  decl %2\n" "  jne 1b\n" :"=&D"(to), "=&S"(from), "=&r"(dummy) :"0" (to), "1" (from), "2" (lcnt) : "memory");; } if (rest) { __asm__ __volatile__( "movl %2,%%ecx\n\t" "sarl $2,%%ecx\n\t" "rep ; movsl\n\t" "testb $2,%b2\n\t" "je 1f\n\t" "movsw\n" "1:\ttestb $1,%b2\n\t" "je 2f\n\t" "movsb\n" "2:" :"=&D" (to), "=&S" (from) :"q" (rest),"0" ((long) to),"1" ((long) from) : "%ecx","memory"); }; __asm__ __volatile__ ("\t" "sfence\n\t" "emms\n\t" :::"memory");; }

# 421 "../../src/via_memcpy.c"
static void now_YUV42X(unsigned char *to, const unsigned char *from, int dstPitch, int w, int h, int yuv422) { int dadd, rest, count, hc, lcnt; register int dummy; __asm__ __volatile__ ( "1:  " "  prefetch " "(%0)\n" "  prefetch " "32(%0)\n" "  prefetch " "64(%0)\n" "  prefetch " "96(%0)\n" "  prefetch " "128(%0)\n" "  prefetch " "160(%0)\n" "  prefetch " "192(%0)\n" "  prefetch " "256(%0)\n" "  prefetch " "288(%0)\n" "2:\n" : : "r" (from) );; __asm__ __volatile__("femms":::"memory");; count = 2; /* If destination pitch equals width, do it all in one go. */ if (yuv422) { w <<= 1; if (w == dstPitch) { w *= h; h = 1; dstPitch = w; count = 0; } else { h -= 1; count = 1; } } else if (w == dstPitch) { w = h*(w + (w >> 1)); count = 0; h = 1; dstPitch = w; } lcnt = w >> 6; rest = w & 63; while (count--) { hc = h; lcnt = w >> 6; rest = w & 63; dadd = dstPitch - w; while (hc--) { if (lcnt) { __asm__ __volatile__ ( "1:\n" "  prefetch " "320(%1)\n" "2:  movq (%1), %%mm0\n" "  movq 8(%1), %%mm1\n" "  movq 16(%1), %%mm2\n" "  movq 24(%1), %%mm3\n" "  movq %%mm0, (%0)\n" "  movq %%mm1, 8(%0)\n" "  movq %%mm2, 16(%0)\n" "  movq %%mm3, 24(%0)\n" "  prefetch " "352(%1)\n" "  movq 32(%1), %%mm0\n" "  movq 40(%1), %%mm1\n" "  movq 48(%1), %%mm2\n" "  movq 56(%1), %%mm3\n" "  movq %%mm0, 32(%0)\n" "  movq %%mm1, 40(%0)\n" "  movq %%mm2, 48(%0)\n" "  movq %%mm3, 56(%0)\n" "  addl $64,%0\n" "  addl $64,%1\n" "  decl %2\n" "  jne 1b\n" :"=&D"(to), "=&S"(from), "=&r"(dummy) :"0" (to), "1" (from), "2" (lcnt) : "memory");; } if (rest) { __asm__ __volatile__ ( "  prefetch " "320(%0)\n" : : "r" (from) );; { __asm__ __volatile__( "movl %2,%%ecx\n\t" "sarl $2,%%ecx\n\t" "rep ; movsl\n\t" "testb $2,%b2\n\t" "je 1f\n\t" "movsw\n" "1:\ttestb $1,%b2\n\t" "je 2f\n\t" "movsb\n" "2:" :"=&D" (to), "=&S" (from) :"q" (rest),"0" ((long) to),"1" ((long) from) : "%ecx","memory"); }; __asm__ __volatile__ ( "  prefetch " "288(%0)\n" : : "r" (from) );; } to += dadd; } w >>= 1; dstPitch >>= 1; h -= 1; } if (lcnt > 5) { lcnt -= 5; __asm__ __volatile__ ( "1:\n" "  prefetch " "320(%1)\n" "2:  movq (%1), %%mm0\n" "  movq 8(%1), %%mm1\n" "  movq 16(%1), %%mm2\n" "  movq 24(%1), %%mm3\n" "  movq %%mm0, (%0)\n" "  movq %%mm1, 8(%0)\n" "  movq %%mm2, 16(%0)\n" "  movq %%mm3, 24(%0)\n" "  prefetch " "352(%1)\n" "  movq 32(%1), %%mm0\n" "  movq 40(%1), %%mm1\n" "  movq 48(%1), %%mm2\n" "  movq 56(%1), %%mm3\n" "  movq %%mm0, 32(%0)\n" "  movq %%mm1, 40(%0)\n" "  movq %%mm2, 48(%0)\n" "  movq %%mm3, 56(%0)\n" "  addl $64,%0\n" "  addl $64,%1\n" "  decl %2\n" "  jne 1b\n" :"=&D"(to), "=&S"(from), "=&r"(dummy) :"0" (to), "1" (from), "2" (lcnt) : "memory");; lcnt = 5; } if (lcnt) { __asm__ __volatile__ ( "1:\n" "#" "320(%1)\n" "2:  movq (%1), %%mm0\n" "  movq 8(%1), %%mm1\n" "  movq 16(%1), %%mm2\n" "  movq 24(%1), %%mm3\n" "  movq %%mm0, (%0)\n" "  movq %%mm1, 8(%0)\n" "  movq %%mm2, 16(%0)\n" "  movq %%mm3, 24(%0)\n" "#" "352(%1)\n" "  movq 32(%1), %%mm0\n" "  movq 40(%1), %%mm1\n" "  movq 48(%1), %%mm2\n" "  movq 56(%1), %%mm3\n" "  movq %%mm0, 32(%0)\n" "  movq %%mm1, 40(%0)\n" "  movq %%mm2, 48(%0)\n" "  movq %%mm3, 56(%0)\n" "  addl $64,%0\n" "  addl $64,%1\n" "  decl %2\n" "  jne 1b\n" :"=&D"(to), "=&S"(from), "=&r"(dummy) :"0" (to), "1" (from), "2" (lcnt) : "memory");; } if (rest) { __asm__ __volatile__( "movl %2,%%ecx\n\t" "sarl $2,%%ecx\n\t" "rep ; movsl\n\t" "testb $2,%b2\n\t" "je 1f\n\t" "movsw\n" "1:\ttestb $1,%b2\n\t" "je 2f\n\t" "movsb\n" "2:" :"=&D" (to), "=&S" (from) :"q" (rest),"0" ((long) to),"1" ((long) from) : "%ecx","memory"); }; __asm__ __volatile__("femms":::"memory");; }

# 422 "../../src/via_memcpy.c"
static void mmx_YUV42X(unsigned char *to, const unsigned char *from, int dstPitch, int w, int h, int yuv422) { int dadd, rest, count, hc, lcnt; register int dummy; __asm__ __volatile__("emms":::"memory");; count = 2; /* If destination pitch equals width, do it all in one go. */ if (yuv422) { w <<= 1; count = 1; if (w == dstPitch) { w *= h; h = 1; dstPitch = w; } } else if (w == dstPitch) { w = h*(w + (w >> 1)); count = 1; h = 1; dstPitch = w; } lcnt = w >> 6; rest = w & 63; while (count--) { hc = h; dadd = dstPitch - w; lcnt = w >> 6; rest = w & 63; while (hc--) { if (lcnt) { __asm__ __volatile__ ( "1:\n" "#" "320(%1)\n" "2:  movq (%1), %%mm0\n" "  movq 8(%1), %%mm1\n" "  movq 16(%1), %%mm2\n" "  movq 24(%1), %%mm3\n" "  movq %%mm0, (%0)\n" "  movq %%mm1, 8(%0)\n" "  movq %%mm2, 16(%0)\n" "  movq %%mm3, 24(%0)\n" "#" "352(%1)\n" "  movq 32(%1), %%mm0\n" "  movq 40(%1), %%mm1\n" "  movq 48(%1), %%mm2\n" "  movq 56(%1), %%mm3\n" "  movq %%mm0, 32(%0)\n" "  movq %%mm1, 40(%0)\n" "  movq %%mm2, 48(%0)\n" "  movq %%mm3, 56(%0)\n" "  addl $64,%0\n" "  addl $64,%1\n" "  decl %2\n" "  jne 1b\n" :"=&D"(to), "=&S"(from), "=&r"(dummy) :"0" (to), "1" (from), "2" (lcnt) : "memory");; } if (rest) { __asm__ __volatile__( "movl %2,%%ecx\n\t" "sarl $2,%%ecx\n\t" "rep ; movsl\n\t" "testb $2,%b2\n\t" "je 1f\n\t" "movsw\n" "1:\ttestb $1,%b2\n\t" "je 2f\n\t" "movsb\n" "2:" :"=&D" (to), "=&S" (from) :"q" (rest),"0" ((long) to),"1" ((long) from) : "%ecx","memory"); }; to += dadd; } w >>= 1; dstPitch >>= 1; } __asm__ __volatile__("emms":::"memory");; }

# 430 "../../src/via_memcpy.c"
static unsigned
fastrdtsc(void)
{
    unsigned eax;

    __asm__ volatile ("\t"
                      "pushl %%ebx\n\t"
                      "cpuid\n\t"
                      ".byte 0x0f, 0x31\n\t"
                      "popl %%ebx\n"
                      :"=a" (eax)
                      :"0"(0)
                      :"ecx", "edx", "cc");

    return eax;
}

