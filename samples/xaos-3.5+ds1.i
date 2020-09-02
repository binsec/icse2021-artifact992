double __builtin_sin (double);
double __builtin_cos (double);
long double __builtin_fabsl (long double);
double atan (double);
double atan2 (double, double);
double sqrt (double);
double log (double);

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 55 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long long int __quad_t;

# 131 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __off_t;

# 132 "/usr/include/i386-linux-gnu/bits/types.h"
typedef __quad_t __off64_t;

# 48 "/usr/include/stdio.h"
typedef struct _IO_FILE FILE;

# 154 "/usr/include/libio.h"
typedef void _IO_lock_t;

# 160 "/usr/include/libio.h"
struct _IO_marker {
  struct _IO_marker *_next;
  struct _IO_FILE *_sbuf;
  /* If _pos >= 0
 it points to _buf->Gbase()+_pos. FIXME comment */
  /* if _pos < 0, it points to _buf->eBptr()+_pos. FIXME comment */
  int _pos;
# 177 "/usr/include/libio.h" 3 4
};

# 245 "/usr/include/libio.h"
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
# 293 "/usr/include/libio.h" 3 4
  __off64_t _offset;
# 302 "/usr/include/libio.h" 3 4
  void *__pad1;
  void *__pad2;
  void *__pad3;
  void *__pad4;
  size_t __pad5;

  int _mode;
  /* Make sure we don't get into trouble again.  */
  char _unused2[15 * sizeof (int) - 4 * sizeof (void *) - sizeof (size_t)];

};

# 237 "/usr/include/stdio.h"
extern int fclose (FILE *__stream);

# 10 "conftest.c"
int
main ()
{

     int op = 0, eax, ebx, ecx, edx;
     FILE *f;
      __asm__("cpuid"
        : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx)
        : "a" (op));
     f = fopen("conftest_cpuid", "w"); if (!f) return 1;
     fprintf(f, "%x:%x:%x:%x\n", eax, ebx, ecx, edx);
     fclose(f);
     return 0;

  ;
  return 0;
}

# 53 "/vagrant/allpkg/xaos-3.5+ds1/src/include/fconfig.h"
typedef long double number_t;

# 8 "/vagrant/allpkg/xaos-3.5+ds1/src/include/filter.h"
typedef unsigned char pixel_t;

# 9 "/vagrant/allpkg/xaos-3.5+ds1/src/include/filter.h"
typedef unsigned char rgb_t[4];

# 10 "/vagrant/allpkg/xaos-3.5+ds1/src/include/filter.h"
struct truec {
 int rshift, gshift, bshift; /*the shift ammounts */
 int rprec, gprec, bprec; /*precisity - 0=8bit, 1=7bit, -1=9bit etc... */
 unsigned int rmask, gmask, bmask; /*masks */
 unsigned int mask1, mask2, allmask; /*Mask1 and mask2 are distinc color masks
						   allmask are mask for all colors */
 int byteexact; /*When every colors is at one byte */
 int missingbyte; /*for 32bit truecolor and exact byte places one byte is
				   unused... */
    };

# 20 "/vagrant/allpkg/xaos-3.5+ds1/src/include/filter.h"
union paletteinfo {
 struct truec truec;
    };

# 23 "/vagrant/allpkg/xaos-3.5+ds1/src/include/filter.h"
struct palette {
 int start;
 int end;
 int maxentries;
 int version;
 int type;
 unsigned int *pixels;
 int npreallocated;
 rgb_t *rgb;
 int flags;
 int (*alloccolor) (struct palette * pal, int init, int r, int g,
      int b);
 void (*setpalette) (struct palette * pal, int start, int end,
       rgb_t * rgb);
 void (*allocfinished) (struct palette * pal);
 void (*cyclecolors) (struct palette * pal, int direction);
 int size; /*number of allocated color entries */
 void *data; /*userdata */
 /*Preallocated palette cells */
 int ncells;
 unsigned int *index;
 const rgb_t *prergb;
 union paletteinfo info;
    };

# 47 "/vagrant/allpkg/xaos-3.5+ds1/src/include/filter.h"
struct image {
 float pixelwidth, pixelheight;
 pixel_t **oldlines;
 pixel_t **currlines;
 void (*flip) (struct image * img);
 int width, height, nimages;
 int bytesperpixel;
 int currimage;
 int flags;
 int scanline;
 int version;
 struct palette *palette;
 void *data; /*userdata */
    };

# 35 "/vagrant/allpkg/xaos-3.5+ds1/src/include/fractal.h"
typedef struct {
 number_t y0, k;
    } symetrytype;

# 39 "/vagrant/allpkg/xaos-3.5+ds1/src/include/fractal.h"
struct symetryinfo {
 number_t xsym, ysym;
 int nsymetries;
 const symetrytype *symetry;
    };

# 44 "/vagrant/allpkg/xaos-3.5+ds1/src/include/fractal.h"
typedef struct {
 number_t mc, nc;
 number_t mi, ni;
    } vrect;

# 48 "/vagrant/allpkg/xaos-3.5+ds1/src/include/fractal.h"
typedef struct {
 number_t cr, ci;
 number_t rr, ri;
    } vinfo;

# 52 "/vagrant/allpkg/xaos-3.5+ds1/src/include/fractal.h"
typedef unsigned int (*iterationfunc) (number_t, number_t, number_t,
        number_t);

# 54 "/vagrant/allpkg/xaos-3.5+ds1/src/include/fractal.h"
struct formula {
 int magic;

 iterationfunc calculate, calculate_periodicity, smooth_calculate,
     smooth_calculate_periodicity;

 void (*calculate_julia) (struct image * img, register number_t pre,
     register number_t pim);
 const char *name[2];
 const char *shortname;
 vinfo v;
 int hasperiodicity;
 int mandelbrot;
 number_t pre, pim;
 struct symetryinfo (out[11 + 1]);
 struct symetryinfo (in[11 + 1]);
 int flags;
    };

# 73 "/vagrant/allpkg/xaos-3.5+ds1/src/include/fractal.h"
struct fractal_context {
 number_t pre, pim;
 number_t bre, bim;
 const struct formula *currentformula;
 number_t angle;
 int periodicity;
 unsigned int maxiter;
 number_t bailout;
 int coloringmode, incoloringmode;
 int intcolor, outtcolor;
 int mandelbrot;
 int plane;
 int version;
 int range;
 float windowwidth, windowheight;
 vinfo s;
 vrect rs;
 number_t sin, cos;
 int slowmode; /* 1 in case we want to be exact, not fast */
 /*values temporary filled by set_fractal_context */
 iterationfunc calculate[2];
 number_t periodicity_limit;
 struct palette *palette; /*fractal's palette */
    };

# 131 "/vagrant/allpkg/xaos-3.5+ds1/src/include/fractal.h"
extern struct fractal_context cfractalc;

# 133 "/vagrant/allpkg/xaos-3.5+ds1/src/include/fractal.h"
extern struct palette cpalette;

# 195 "formulas.c"
static inline void
hsv_to_rgb(int h, int s, int v, int *red, int *green, int *blue)
{
    int hue;
    int f, p, q, t;

    if (s == 0) {
 *red = v;
 *green = v;
 *blue = v;
    } else {
 h %= 256;
 if (h < 0)
     h += 256;
 hue = h * 6;

 f = hue & 255;
 p = v * (256 - s) / 256;
 q = v * (256 - (s * f) / 256) >> 8;
 t = v * (256 * 256 - (s * (256 - f))) >> 16;

 switch ((int) (hue / 256)) {
 case 0:
     *red = v;
     *green = t;
     *blue = p;
     break;
 case 1:
     *red = q;
     *green = v;
     *blue = p;
     break;
 case 2:
     *red = p;
     *green = v;
     *blue = t;
     break;
 case 3:
     *red = p;
     *green = q;
     *blue = v;
     break;
 case 4:
     *red = t;
     *green = p;
     *blue = v;
     break;
 case 5:
     *red = v;
     *green = p;
     *blue = q;
     break;
 }
    }
}

# 256 "formulas.c"
static unsigned int
truecolor_output(number_t zre, number_t zim, number_t pre,
   number_t pim, int mode, int inset)
{
    /* WARNING: r and b fields are swapped for HISTORICAL REASONS (BUG :),
     * in other words: use r for blue and b for red. */
    int r = 0, g = 0, b = 0, w = 0;

    switch (mode) {
    case 0:
 break;
    case 1:
 b = (int) ((__builtin_sin((double) atan2((double) zre, (double) zim) * 20) +
      1) * 127);
 w = (int) ((__builtin_sin((double) zim / zre)) * 127);
 r = (int) ((int) (zre * zim));
 g = (int) ((__builtin_sin((double) (zre * zre) / 2) + 1) * 127);
 break;
    case 2:
 if (!inset) {
     r = (int) ((__builtin_sin((double) zre * 2) + 1) * 127);
     g = (int) ((__builtin_sin((double) zim * 2) + 1) * 127);
     b = (int) ((__builtin_sin((double) (zim * zim + zre * zre) / 2) +
   1) * 127);
 } else {
     r = (int) ((__builtin_sin((double) zre * 50) + 1) * 127);
     g = (int) ((__builtin_sin((double) zim * 50) + 1) * 127);
     b = (int) ((__builtin_sin((double) (zim * zim + zre * zre) * 50) +
   1) * 127);
 }
 w = (int) ((__builtin_sin((double) zim / zre)) * 127);
 break;
    case 3:
 if (inset)
     hsv_to_rgb((int)
         (atan2((double) zre, (double) zim) * 256 / 3.14159265358979323846 /* pi */),
         (int) ((__builtin_sin((double) (zre * 50)) + 1) * 128),
         (int) ((__builtin_sin((double) (zim * 50)) + 1) * 128), &r,
         &g, &b);
 else
     hsv_to_rgb((int)
         (atan2((double) zre, (double) zim) * 256 / 3.14159265358979323846 /* pi */),
         (int) ((__builtin_sin((double) zre) + 1) * 128),
         (int) ((__builtin_sin((double) zim) + 1) * 128), &r, &g, &b);
 break;
    case 4:
 if (inset)
     hsv_to_rgb((int)
         (__builtin_sin((double) (zre * zre + zim * zim) * 0.1) * 256),
         (int) (__builtin_sin(atan2((double) zre, (double) zim) * 10) *
         128 + 128),
         (int) ((__builtin_sin((double) (zre + zim) * 10)) * 65 + 128),
         &r, &g, &b);
 else
     hsv_to_rgb((int)
         (__builtin_sin((double) (zre * zre + zim * zim) * 0.01) *
   256),
         (int) (__builtin_sin(atan2((double) zre, (double) zim) * 10) *
         128 + 128),
         (int) ((__builtin_sin((double) (zre + zim) * 0.3)) * 65 +
         128), &r, &g, &b);
 break;
    case 5:
 {
     if (!inset) {
  r = (int) (__builtin_cos((double) __builtin_fabsl((number_t)(zre * zre))) * 128) + 128;
  g = (int) (__builtin_cos((double) __builtin_fabsl((number_t)(zre * zim))) * 128) + 128;
  b = (int) (__builtin_cos((double) __builtin_fabsl((number_t)(zim * zim + zre * zre))) *
      128) + 128;
     } else {
  r = (int) (__builtin_cos((double) __builtin_fabsl((number_t)(zre * zre)) * 10) * 128) +
      128;
  g = (int) (__builtin_cos((double) __builtin_fabsl((number_t)(zre * zim)) * 10) * 128) +
      128;
  b = (int) (__builtin_cos((double) __builtin_fabsl((number_t)(zim * zim + zre * zre)) * 10)
      * 128) + 128;
     }
 }
 break;
    case 6:
 {
     if (!inset) {
  r = (int) (zre * zim * 64);
  g = (int) (zre * zre * 64);
  b = (int) (zim * zim * 64);
     } else
  r = (int) (zre * zim * 256);
     g = (int) (zre * zre * 256);
     b = (int) (zim * zim * 256);
 }
 break;
    case 7:
 {
     if (!inset) {
  r = (int) ((zre * zre + zim * zim - pre * pre -
       pim * pim) * 16);
  g = (int) ((zre * zre * 2 - pre * pre - pim * pim) * 16);
  b = (int) ((zim * zim * 2 - pre * pre - pim * pim) * 16);
     } else {
  r = (int) ((zre * zre + zim * zim - pre * pre -
       pim * pim) * 256);
  g = (int) ((zre * zre * 2 - pre * pre - pim * pim) * 256);
  b = (int) ((zim * zim * 2 - pre * pre - pim * pim) * 256);
     }
 }
 break;
    case 8:
 {
     if (!inset) {
  r = (int) ((__builtin_fabsl((number_t)(zim * pim))) * 64);
  g = (int) ((__builtin_fabsl((number_t)(zre * pre))) * 64);
  b = (int) ((__builtin_fabsl((number_t)(zre * pim))) * 64);
     } else {
  r = (int) ((__builtin_fabsl((number_t)(zim * pim))) * 256);
  g = (int) ((__builtin_fabsl((number_t)(zre * pre))) * 256);
  b = (int) ((__builtin_fabsl((number_t)(zre * pim))) * 256);
     }
 }
 break;
    case 9:
 {
     if (!inset) {
  r = (int) ((__builtin_fabsl((number_t)(zre * zim - pre * pre - pim * pim))) *
      64);
  g = (int) ((__builtin_fabsl((number_t)(zre * zre - pre * pre - pim * pim))) *
      64);
  b = (int) ((__builtin_fabsl((number_t)(zim * zim - pre * pre - pim * pim))) *
      64);
     } else {
  r = (int) ((__builtin_fabsl((number_t)(zre * zim - pre * pre - pim * pim))) *
      256);
  g = (int) ((__builtin_fabsl((number_t)(zre * zre - pre * pre - pim * pim))) *
      256);
  b = (int) ((__builtin_fabsl((number_t)(zim * zim - pre * pre - pim * pim))) *
      256);
     }
 }
 break;
    case 10:
 {
     r = (int) (atan2((double) zre, (double) zim) * 128 / 3.14159265358979323846 /* pi */) +
  128;
     g = (int) (atan2((double) zre, (double) zim) * 128 / 3.14159265358979323846 /* pi */) +
  128;
     b = (int) (atan2((double) zim, (double) zre) * 128 / 3.14159265358979323846 /* pi */) +
  128;
 }
 break;
 // case 11 is for disabling truecolor mode
    case 12:
 {
     b = 255;
     g = 0;
     r = 0;
     w = 50;
 }
 break;
    case 13:
 {
     r = 255;
     g = 0;
     b = 0;
     w = 0;
 }
 break;
    }

    r += w;
    g += w;
    b += w;
    if (r < 0)
 r = 0;
    else if (r > 255)
 r = 255;
    if (g < 0)
 g = 0;
    else if (g > 255)
 g = 255;
    if (b < 0)
 b = 0;
    else if (b > 255)
 b = 255;

    switch (cpalette.type) {
    case 2:
 return ((unsigned int) (r * 76 + g * 151 + b * 29) *
  (cpalette.end - cpalette.start) >> 16) + cpalette.start;
    case 16:
    case 8:
    case 4:
 r >>= cpalette.info.truec.bprec;
 g >>= cpalette.info.truec.gprec;
 b >>= cpalette.info.truec.rprec;
 return ((r << cpalette.info.truec.bshift) +
  (g << cpalette.info.truec.gshift) +
  (b << cpalette.info.truec.rshift));
    }

    return cpalette.pixels[inset];
}

# 463 "formulas.c"
static unsigned int
 color_output(number_t zre, number_t zim, unsigned int iter)
{
    int i;
    iter <<= 8;
    i = iter;

    switch (cfractalc.coloringmode) {
    case 9:
 break;
    case 1: /* real */
 i = (int) (iter + zre * 256);
 break;
    case 2: /* imag */
 i = (int) (iter + zim * 256);
 break;
    case 3: /* real / imag */



     i = (int) (iter + (zre / zim) * 256);
 break;
    case 4: /* all of the above */



     i = (int) (iter + (zre + zim + zre / zim) * 256);
 break;
    case 5:
 if (zim > 0)
     i = ((cfractalc.maxiter << 8) - iter);
 break;
    case 6:
 if (__builtin_fabsl((number_t)(zim)) < 2.0 || __builtin_fabsl((number_t)(zre)) < 2.0)
     i = ((cfractalc.maxiter << 8) - iter);
 break;
    case 7:
 zre = zre * zre + zim * zim;





     i = (int) (sqrt(log((double) zre) / i) * 256 * 256);
 break;
    default:
    case 8:
 i = (int) ((atan2((double) zre, (double) zim) / (3.14159265358979323846 /* pi */ + 3.14159265358979323846 /* pi */) +
      0.75) * 20000);
 break;
    }

    if (i < 0) {
 i = (((unsigned int) (cpalette.size - 1)) << 8) -
     ((-i) % (((unsigned int) (cpalette.size - 1) << 8))) - 1;
 if (i < 0)
     i = 0;
    }
    iter = ((unsigned int) i) % ((cpalette.size - 1) << 8);
    if ((cpalette.type & (1 | 64)) || !(iter & 255))
 return (cpalette.pixels[1 + (iter >> 8)]);
    {
 unsigned int i1, i2;

 i1 = cpalette.pixels[1 + (iter >> 8)];

 if ((int) (iter >> 8) == cpalette.size - 2)
     i2 = cpalette.pixels[1];
 else
     i2 = cpalette.pixels[2 + (iter >> 8)];

 iter &= 255;
 return (((cpalette).type==2 || (cpalette).type == 32?(((i2)*iter+(i1)*(256-(iter)))>>8):(((((cpalette).info.truec.rmask)|((cpalette).info.truec.gmask)|((cpalette).info.truec.bmask))&0xff000000)?((((((((i2)>>8)&(((cpalette).info.truec.rmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.rmask)>>8))*(256-(iter)))&((((cpalette).info.truec.rmask)>>8)<<8))+(((((i2)>>8)&(((cpalette).info.truec.gmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.gmask)>>8))*(256-(iter)))&((((cpalette).info.truec.gmask)>>8)<<8))+(((((i2)>>8)&(((cpalette).info.truec.bmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.bmask)>>8))*(256-(iter)))&((((cpalette).info.truec.bmask)>>8)<<8)))>>8)<<8):((((((i2)&((cpalette).info.truec.rmask))*(iter)+((i1)&((cpalette).info.truec.rmask))*(256-(iter)))&(((cpalette).info.truec.rmask)<<8))+((((i2)&((cpalette).info.truec.gmask))*(iter)+((i1)&((cpalette).info.truec.gmask))*(256-(iter)))&(((cpalette).info.truec.gmask)<<8))+((((i2)&((cpalette).info.truec.bmask))*(iter)+((i1)&((cpalette).info.truec.bmask))*(256-(iter)))&(((cpalette).info.truec.bmask)<<8)))>>8))));
    }

}

# 545 "formulas.c"
static unsigned int
incolor_output(number_t zre, number_t zim, number_t pre, number_t pim,
        unsigned int iter)
{
    int i = iter;
    switch (cfractalc.incoloringmode) {
    case 1: /* zmag */
 i = (int) (((zre * zre + zim * zim) *
      (number_t) (cfractalc.maxiter >> 1) * 256 + 256));
 break;
    case 2: /* real */
 i = (int) (((atan2((double) zre, (double) zim) / (3.14159265358979323846 /* pi */ + 3.14159265358979323846 /* pi */) +
       0.75) * 20000));
 break;
    default:
 break;
    case 3: /* real / imag */
 i = (int) (100 + (zre / zim) * 256 * 10);
 break;
    case 4:
 zre = __builtin_fabsl((number_t)(zre));
 zim = __builtin_fabsl((number_t)(zim));
 pre = __builtin_fabsl((number_t)(pre));
 pre = __builtin_fabsl((number_t)(pim));
 i += (int) (__builtin_fabsl((number_t)(pre - zre)) * 256 * 64);
 i += (int) (__builtin_fabsl((number_t)(pim - zim)) * 256 * 64);
 break;
    case 5:
 if (((int) ((zre * zre + zim * zim) * 10)) % 2)
     i = (int) (__builtin_cos((double) (zre * zim * pre * pim)) * 256 * 256);
 else
     i = (int) (__builtin_sin((double) (zre * zim * pre * pim)) * 256 * 256);
 break;
    case 6:
 i = (int) ((zre * zre +
      zim * zim) * __builtin_cos((double) (zre * zre)) * 256 * 256);
 break;
    case 7:
 i = (int) (__builtin_sin((double) (zre * zre - zim * zim)) * 256 * 256);
 break;
    case 8:
 i = (int) (atan((double) (zre * zim * pre * pim)) * 256 * 64);
 break;
    case 9:
 if ((abs((int) (zre * 40)) % 2) ^ (abs((int) (zim * 40)) % 2))
     i = (int) (((atan2((double) zre, (double) zim) /
    (3.14159265358979323846 /* pi */ + 3.14159265358979323846 /* pi */) + 0.75)
   * 20000));
 else
     i = (int) (((atan2((double) zim, (double) zre) /
    (3.14159265358979323846 /* pi */ + 3.14159265358979323846 /* pi */) + 0.75)
   * 20000));
 break;
    };

    if (i < 0) {
 i = (((unsigned int) (cpalette.size - 1)) << 8) -
     ((-i) % (((unsigned int) (cpalette.size - 1) << 8))) - 1;
 if (i < 0)
     i = 0;
    }
    iter = ((unsigned int) i) % ((cpalette.size - 1) << 8);

    if ((cpalette.type & (1 | 64)) || !(iter & 255))
 return (cpalette.pixels[1 + ((unsigned int) iter >> 8)]);
    {
 unsigned int i1, i2;
 i1 = cpalette.pixels[1 + ((unsigned int) iter >> 8)];
 if (((unsigned int) iter >> 8) ==
     (unsigned int) (cpalette.size - 2))
     i2 = cpalette.pixels[1];
 else
     i2 = cpalette.pixels[2 + ((unsigned int) iter >> 8)];
 iter &= 255;
 return (((cpalette).type==2 || (cpalette).type == 32?(((i2)*iter+(i1)*(256-(iter)))>>8):(((((cpalette).info.truec.rmask)|((cpalette).info.truec.gmask)|((cpalette).info.truec.bmask))&0xff000000)?((((((((i2)>>8)&(((cpalette).info.truec.rmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.rmask)>>8))*(256-(iter)))&((((cpalette).info.truec.rmask)>>8)<<8))+(((((i2)>>8)&(((cpalette).info.truec.gmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.gmask)>>8))*(256-(iter)))&((((cpalette).info.truec.gmask)>>8)<<8))+(((((i2)>>8)&(((cpalette).info.truec.bmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.bmask)>>8))*(256-(iter)))&((((cpalette).info.truec.bmask)>>8)<<8)))>>8)<<8):((((((i2)&((cpalette).info.truec.rmask))*(iter)+((i1)&((cpalette).info.truec.rmask))*(256-(iter)))&(((cpalette).info.truec.rmask)<<8))+((((i2)&((cpalette).info.truec.gmask))*(iter)+((i1)&((cpalette).info.truec.gmask))*(256-(iter)))&(((cpalette).info.truec.gmask)<<8))+((((i2)&((cpalette).info.truec.bmask))*(iter)+((i1)&((cpalette).info.truec.bmask))*(256-(iter)))&(((cpalette).info.truec.bmask)<<8)))>>8))));
    }

}

# 132 "docalc.c"
static unsigned
mand_calc(register number_t zre, register number_t zim,
     register number_t pre, register number_t pim)

{
    register unsigned int iter = cfractalc.maxiter;
    number_t szre = 0, szim = 0;

    register number_t rp = 0, ip;




    ;
    ;
    if (0)
 iter = 0;
    else {

 rp = zre * zre;
 ip = zim * zim;

 if (iter < 16) {
     __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
     __asm__ ("#HACK" : : "f" (zre), "f" (zim) );;

     /*try first 8 iterations */
     if (((rp+ip)<cfractalc.bailout) && iter) {
  do { /*try first 8 iterations */ zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
     }
     /*
	       while (BTEST && iter)
	       {  
	       SAVEZMAG;
	       FORMULA;
	       iter--;
	       } */
 } else {
     iter = 8 + (cfractalc.maxiter & 7);
     __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
     __asm__ ("#HACK" : : "f" (zre), "f" (zim) );;

     /*try first 8 iterations */
     if (((rp+ip)<cfractalc.bailout) && iter) {
  do { /*try first 8 iterations */ zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
     }
     /*
	       while (BTEST && iter)
	       {  
	       SAVEZMAG;
	       FORMULA;
	       iter--;
	       } */
     if (((rp+ip)<cfractalc.bailout)) {
  iter = (cfractalc.maxiter - 8) & (~7);
  iter >>= 3;
  __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
  __asm__ ("#HACK" : : "f" (zre), "f" (zim) );; /*do next 8 iteration w/o out of bounds checking */
  do {
      /*hmm..we are probably in some deep area. */
      szre = zre; /*save current possition */
      szim = zim;
      ;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      ;
      iter--;
  }
  while (((rp+ip)<cfractalc.bailout) && iter);
  if (!(((rp+ip)<cfractalc.bailout))) { /*we got out of bounds */
      iter <<= 3;
      iter += 8; /*restore saved possition */
      ;
      zre = szre;
      zim = szim;

      rp = zre * zre;
      ip = zim * zim;

      __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
      __asm__ ("#HACK" : : "f" (zre), "f" (zim) );;
      do { /*try first 8 iterations */ zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
      /*
		       do
		       {
		       SAVEZMAG
		       FORMULA;
		       iter--;
		       }
		       while (BTEST && iter); */
  }
     } else
  iter += cfractalc.maxiter - 8 - (cfractalc.maxiter & 7);
 }
    }







    ;
    iter = cfractalc.maxiter - iter;
    if(iter>=(unsigned int)cfractalc.maxiter) { if(cfractalc.incoloringmode==10) return(truecolor_output(zre,zim,pre,pim,cfractalc.intcolor,1)); ;return(cfractalc.incoloringmode?incolor_output(zre,zim,pre,pim,iter):cpalette.pixels[0]); } else { if(cfractalc.coloringmode==10) return(truecolor_output(zre,zim,pre,pim,cfractalc.outtcolor,0)); ;return(!cfractalc.coloringmode?cpalette.pixels[(iter%(cpalette.size-1))+1]:color_output(zre,zim,iter)); };

}

# 467 "docalc.c"
static unsigned int
mand_peri(register number_t zre, register number_t zim,
     register number_t pre, register number_t pim)

{
    register unsigned int iter = cfractalc.maxiter /*& (~(int) 3) */ ;
    register number_t r1 = zre, s1 = zim;
    number_t szre = 0, szim = 0; /*F. : Didn't declared register, cause they are few used */
    unsigned int whensavenew, whenincsave;

    register number_t rp = 0, ip;




    ;
    ;
    if (0)
 iter = 0;
    else {
 if (cfractalc.maxiter <= 16) {
     __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
     /*I386HACK; */

     rp = zre * zre;
     ip = zim * zim;

     /*F. : Added iter&7 to be sure we'll be on a 8 multiple */
     if (((rp+ip)<cfractalc.bailout) && iter) {
  do { /*try first 8 iterations */ zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
     }
     /*
	       while (BTEST && iter)
	       {
	       SAVEZMAG
	       FORMULA;
	       iter--;
	       } */
 } else {
     whensavenew = 7; /*You should adapt theese values */
     /*F. : We should always define whensavenew as 2^N-1, so we could use a AND instead of % */

     whenincsave = 10;

     rp = zre * zre;
     ip = zim * zim;

     /*F. : problem is that after deep zooming, peiodicity is never detected early, cause is is
	       quite slow before going in a periodic loop.
	       So, we should start checking periodicity only after some times */
     __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
     /*I386HACK; */
     iter = 8 + (cfractalc.maxiter & 7);
     while (((rp+ip)<cfractalc.bailout) && iter) { /*F. : Added iter&7 to be sure we'll be on a 8 multiple */
  zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
  iter--;
     }
     if (((rp+ip)<cfractalc.bailout)) { /*F. : BTEST is calculed two times here, isn't it ? */
  /*H. : No gcc is clever and adds test to the end :) */
  iter = (cfractalc.maxiter - 8) & (~7);
  do {
      szre = zre, szim = zim;
      ;
     
   /*I386HACK; */
   __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;; /*F. : Calculate one time */
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      iter -= 8;
      /*F. : We only test this now, as it can't be true before */
      if ((iter & whensavenew) == 0) { /*F. : changed % to & */
   r1 = zre, s1 = zim; /*F. : Save new values */
   whenincsave--;
   if (!whenincsave) {
       whensavenew = ((whensavenew + 1) << 1) - 1; /*F. : Changed to define a new AND mask */
       whenincsave = 10; /*F. : Start back */
   }
      }
  }
  while (((rp+ip)<cfractalc.bailout) && iter);
  if (!((rp+ip)<cfractalc.bailout)) { /*we got out of bounds */
      iter += 8; /*restore saved possition */
      ;
      zre = szre;
      zim = szim;

      rp = zre * zre;
      ip = zim * zim;

      __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
      /*I386HACK; */
      do { /*try first 8 iterations */ zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
      /*
		       do
		       {
		       SAVEZMAG
		       FORMULA;
		       iter--;
		       }
		       while (BTEST && iter); */
  }
     } else
  iter += cfractalc.maxiter - 8 - (cfractalc.maxiter & 7);
 }
    }







    ;
    iter = cfractalc.maxiter - iter;
    if(iter>=(unsigned int)cfractalc.maxiter) { if(cfractalc.incoloringmode==10) return(truecolor_output(zre,zim,pre,pim,cfractalc.intcolor,1)); ;return(cfractalc.incoloringmode?incolor_output(zre,zim,pre,pim,iter):cpalette.pixels[0]); } else { if(cfractalc.coloringmode==10) return(truecolor_output(zre,zim,pre,pim,cfractalc.outtcolor,0)); ;return(!cfractalc.coloringmode?cpalette.pixels[(iter%(cpalette.size-1))+1]:color_output(zre,zim,iter)); };

  periodicity:
    ;return(cpalette.pixels[0]);
}

# 123 "docalc.c"
static unsigned int
smand_calc(register number_t zre, register number_t zim,
      register number_t pre, register number_t pim)
# 136 "docalc.c"
{
    register unsigned int iter = cfractalc.maxiter;
    number_t szre = 0, szim = 0;

    register number_t rp = 0, ip;


    number_t szmag = 0;

    ;
    ;
    if (0)
 iter = 0;
    else {

 rp = zre * zre;
 ip = zim * zim;

 if (iter < 16) {
     __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
     __asm__ ("#HACK" : : "f" (zre), "f" (zim) );;

     /*try first 8 iterations */
     if (((rp+ip)<cfractalc.bailout) && iter) {
  do { /*try first 8 iterations */ szmag=rp+ip;; zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
     }
     /*
	       while (BTEST && iter)
	       {  
	       SAVEZMAG;
	       FORMULA;
	       iter--;
	       } */
 } else {
     iter = 8 + (cfractalc.maxiter & 7);
     __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
     __asm__ ("#HACK" : : "f" (zre), "f" (zim) );;

     /*try first 8 iterations */
     if (((rp+ip)<cfractalc.bailout) && iter) {
  do { /*try first 8 iterations */ szmag=rp+ip;; zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
     }
     /*
	       while (BTEST && iter)
	       {  
	       SAVEZMAG;
	       FORMULA;
	       iter--;
	       } */
     if (((rp+ip)<cfractalc.bailout)) {
  iter = (cfractalc.maxiter - 8) & (~7);
  iter >>= 3;
  __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
  __asm__ ("#HACK" : : "f" (zre), "f" (zim) );; /*do next 8 iteration w/o out of bounds checking */
  do {
      /*hmm..we are probably in some deep area. */
      szre = zre; /*save current possition */
      szim = zim;
      ;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      ;
      iter--;
  }
  while (((rp+ip)<cfractalc.bailout) && iter);
  if (!(((rp+ip)<cfractalc.bailout))) { /*we got out of bounds */
      iter <<= 3;
      iter += 8; /*restore saved possition */
      ;
      zre = szre;
      zim = szim;

      rp = zre * zre;
      ip = zim * zim;

      __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
      __asm__ ("#HACK" : : "f" (zre), "f" (zim) );;
      do { /*try first 8 iterations */ szmag=rp+ip;; zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
      /*
		       do
		       {
		       SAVEZMAG
		       FORMULA;
		       iter--;
		       }
		       while (BTEST && iter); */
  }
     } else
  iter += cfractalc.maxiter - 8 - (cfractalc.maxiter & 7);
 }
    }

    if (iter)
 {zre=rp+ip;zre+=0.000001;szmag+=0.000001; iter=(int)(((cfractalc.maxiter-iter)*256+log((double)(cfractalc.bailout/(szmag)))/log((double)((zre)/(szmag)))*256)); if (iter < 0) { iter = (((unsigned int)(cpalette.size - 1)) << 8) - ((-iter) % (((unsigned int)(cpalette.size - 1)) << 8))-1; if (iter < 0) iter=0; } iter %= ((unsigned int)(cpalette.size - 1)) << 8; if ((cpalette.type & (1 | 64)) || !(iter & 255)) return (cpalette.pixels[1 + (iter >> 8)]); { unsigned int i1, i2; i1 = cpalette.pixels[1 + (iter >> 8)]; if ((iter >> 8) == (unsigned int)(cpalette.size - 2)) i2 = cpalette.pixels[1]; else i2 = cpalette.pixels[2 + (iter >> 8)]; iter &= 255; return (((cpalette).type==2 || (cpalette).type == 32?(((i2)*iter+(i1)*(256-(iter)))>>8):(((((cpalette).info.truec.rmask)|((cpalette).info.truec.gmask)|((cpalette).info.truec.bmask))&0xff000000)?((((((((i2)>>8)&(((cpalette).info.truec.rmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.rmask)>>8))*(256-(iter)))&((((cpalette).info.truec.rmask)>>8)<<8))+(((((i2)>>8)&(((cpalette).info.truec.gmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.gmask)>>8))*(256-(iter)))&((((cpalette).info.truec.gmask)>>8)<<8))+(((((i2)>>8)&(((cpalette).info.truec.bmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.bmask)>>8))*(256-(iter)))&((((cpalette).info.truec.bmask)>>8)<<8)))>>8)<<8):((((((i2)&((cpalette).info.truec.rmask))*(iter)+((i1)&((cpalette).info.truec.rmask))*(256-(iter)))&(((cpalette).info.truec.rmask)<<8))+((((i2)&((cpalette).info.truec.gmask))*(iter)+((i1)&((cpalette).info.truec.gmask))*(256-(iter)))&(((cpalette).info.truec.gmask)<<8))+((((i2)&((cpalette).info.truec.bmask))*(iter)+((i1)&((cpalette).info.truec.bmask))*(256-(iter)))&(((cpalette).info.truec.bmask)<<8)))>>8)))); } };
    ;
    iter = cfractalc.maxiter - iter;
    ;return(cfractalc.incoloringmode?incolor_output(zre,zim,pre,pim,iter):cpalette.pixels[0]);





}

# 458 "docalc.c"
static unsigned int
smand_peri(register number_t zre, register number_t zim,
      register number_t pre, register number_t pim)
# 471 "docalc.c"
{
    register unsigned int iter = cfractalc.maxiter /*& (~(int) 3) */ ;
    register number_t r1 = zre, s1 = zim;
    number_t szre = 0, szim = 0; /*F. : Didn't declared register, cause they are few used */
    unsigned int whensavenew, whenincsave;

    register number_t rp = 0, ip;


    number_t szmag = 0;

    ;
    ;
    if (0)
 iter = 0;
    else {
 if (cfractalc.maxiter <= 16) {
     __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
     /*I386HACK; */

     rp = zre * zre;
     ip = zim * zim;

     /*F. : Added iter&7 to be sure we'll be on a 8 multiple */
     if (((rp+ip)<cfractalc.bailout) && iter) {
  do { /*try first 8 iterations */ szmag=rp+ip;; zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
     }
     /*
	       while (BTEST && iter)
	       {
	       SAVEZMAG
	       FORMULA;
	       iter--;
	       } */
 } else {
     whensavenew = 7; /*You should adapt theese values */
     /*F. : We should always define whensavenew as 2^N-1, so we could use a AND instead of % */

     whenincsave = 10;

     rp = zre * zre;
     ip = zim * zim;

     /*F. : problem is that after deep zooming, peiodicity is never detected early, cause is is
	       quite slow before going in a periodic loop.
	       So, we should start checking periodicity only after some times */
     __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
     /*I386HACK; */
     iter = 8 + (cfractalc.maxiter & 7);
     while (((rp+ip)<cfractalc.bailout) && iter) { /*F. : Added iter&7 to be sure we'll be on a 8 multiple */
  szmag=rp+ip; zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
  iter--;
     }
     if (((rp+ip)<cfractalc.bailout)) { /*F. : BTEST is calculed two times here, isn't it ? */
  /*H. : No gcc is clever and adds test to the end :) */
  iter = (cfractalc.maxiter - 8) & (~7);
  do {
      szre = zre, szim = zim;
      ;
      szmag=rp+ip;
   /*I386HACK; */
   __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;; /*F. : Calculate one time */
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      iter -= 8;
      /*F. : We only test this now, as it can't be true before */
      if ((iter & whensavenew) == 0) { /*F. : changed % to & */
   r1 = zre, s1 = zim; /*F. : Save new values */
   whenincsave--;
   if (!whenincsave) {
       whensavenew = ((whensavenew + 1) << 1) - 1; /*F. : Changed to define a new AND mask */
       whenincsave = 10; /*F. : Start back */
   }
      }
  }
  while (((rp+ip)<cfractalc.bailout) && iter);
  if (!((rp+ip)<cfractalc.bailout)) { /*we got out of bounds */
      iter += 8; /*restore saved possition */
      ;
      zre = szre;
      zim = szim;

      rp = zre * zre;
      ip = zim * zim;

      __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
      /*I386HACK; */
      do { /*try first 8 iterations */ szmag=rp+ip;; zim=(zim*zre)*2+pim; zre = rp - ip + pre; ip=zim*zim; rp=zre*zre;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
      /*
		       do
		       {
		       SAVEZMAG
		       FORMULA;
		       iter--;
		       }
		       while (BTEST && iter); */
  }
     } else
  iter += cfractalc.maxiter - 8 - (cfractalc.maxiter & 7);
 }
    }

    if (iter)
 {zre=rp+ip;zre+=0.000001;szmag+=0.000001; iter=(int)(((cfractalc.maxiter-iter)*256+log((double)(cfractalc.bailout/(szmag)))/log((double)((zre)/(szmag)))*256)); if (iter < 0) { iter = (((unsigned int)(cpalette.size - 1)) << 8) - ((-iter) % (((unsigned int)(cpalette.size - 1)) << 8))-1; if (iter < 0) iter=0; } iter %= ((unsigned int)(cpalette.size - 1)) << 8; if ((cpalette.type & (1 | 64)) || !(iter & 255)) return (cpalette.pixels[1 + (iter >> 8)]); { unsigned int i1, i2; i1 = cpalette.pixels[1 + (iter >> 8)]; if ((iter >> 8) == (unsigned int)(cpalette.size - 2)) i2 = cpalette.pixels[1]; else i2 = cpalette.pixels[2 + (iter >> 8)]; iter &= 255; return (((cpalette).type==2 || (cpalette).type == 32?(((i2)*iter+(i1)*(256-(iter)))>>8):(((((cpalette).info.truec.rmask)|((cpalette).info.truec.gmask)|((cpalette).info.truec.bmask))&0xff000000)?((((((((i2)>>8)&(((cpalette).info.truec.rmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.rmask)>>8))*(256-(iter)))&((((cpalette).info.truec.rmask)>>8)<<8))+(((((i2)>>8)&(((cpalette).info.truec.gmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.gmask)>>8))*(256-(iter)))&((((cpalette).info.truec.gmask)>>8)<<8))+(((((i2)>>8)&(((cpalette).info.truec.bmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.bmask)>>8))*(256-(iter)))&((((cpalette).info.truec.bmask)>>8)<<8)))>>8)<<8):((((((i2)&((cpalette).info.truec.rmask))*(iter)+((i1)&((cpalette).info.truec.rmask))*(256-(iter)))&(((cpalette).info.truec.rmask)<<8))+((((i2)&((cpalette).info.truec.gmask))*(iter)+((i1)&((cpalette).info.truec.gmask))*(256-(iter)))&(((cpalette).info.truec.gmask)<<8))+((((i2)&((cpalette).info.truec.bmask))*(iter)+((i1)&((cpalette).info.truec.bmask))*(256-(iter)))&(((cpalette).info.truec.bmask)<<8)))>>8)))); } };
    ;
    iter = cfractalc.maxiter - iter;
    ;return(cfractalc.incoloringmode?incolor_output(zre,zim,pre,pim,iter):cpalette.pixels[0]);





  periodicity:
    ;return(cpalette.pixels[0]);
}

# 132 "docalc.c"
static unsigned
mand3_calc(register number_t zre, register number_t zim,
     register number_t pre, register number_t pim)

{
    register unsigned int iter = cfractalc.maxiter;
    number_t szre = 0, szim = 0;

    register number_t rp = 0, ip;




    ;
    ;
    if (0)
 iter = 0;
    else {

 rp = zre * zre;
 ip = zim * zim;

 if (iter < 16) {
     __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
     __asm__ ("#HACK" : : "f" (zre), "f" (zim) );;

     /*try first 8 iterations */
     if (((rp+ip)<cfractalc.bailout) && iter) {
  do { /*try first 8 iterations */ rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
     }
     /*
	       while (BTEST && iter)
	       {  
	       SAVEZMAG;
	       FORMULA;
	       iter--;
	       } */
 } else {
     iter = 8 + (cfractalc.maxiter & 7);
     __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
     __asm__ ("#HACK" : : "f" (zre), "f" (zim) );;

     /*try first 8 iterations */
     if (((rp+ip)<cfractalc.bailout) && iter) {
  do { /*try first 8 iterations */ rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
     }
     /*
	       while (BTEST && iter)
	       {  
	       SAVEZMAG;
	       FORMULA;
	       iter--;
	       } */
     if (((rp+ip)<cfractalc.bailout)) {
  iter = (cfractalc.maxiter - 8) & (~7);
  iter >>= 3;
  __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
  __asm__ ("#HACK" : : "f" (zre), "f" (zim) );; /*do next 8 iteration w/o out of bounds checking */
  do {
      /*hmm..we are probably in some deep area. */
      szre = zre; /*save current possition */
      szim = zim;
      ;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      ;
      iter--;
  }
  while (((rp+ip)<cfractalc.bailout) && iter);
  if (!(((rp+ip)<cfractalc.bailout))) { /*we got out of bounds */
      iter <<= 3;
      iter += 8; /*restore saved possition */
      ;
      zre = szre;
      zim = szim;

      rp = zre * zre;
      ip = zim * zim;

      __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
      __asm__ ("#HACK" : : "f" (zre), "f" (zim) );;
      do { /*try first 8 iterations */ rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
      /*
		       do
		       {
		       SAVEZMAG
		       FORMULA;
		       iter--;
		       }
		       while (BTEST && iter); */
  }
     } else
  iter += cfractalc.maxiter - 8 - (cfractalc.maxiter & 7);
 }
    }







    ;
    iter = cfractalc.maxiter - iter;
    if(iter>=(unsigned int)cfractalc.maxiter) { if(cfractalc.incoloringmode==10) return(truecolor_output(zre,zim,pre,pim,cfractalc.intcolor,1)); ;return(cfractalc.incoloringmode?incolor_output(zre,zim,pre,pim,iter):cpalette.pixels[0]); } else { if(cfractalc.coloringmode==10) return(truecolor_output(zre,zim,pre,pim,cfractalc.outtcolor,0)); ;return(!cfractalc.coloringmode?cpalette.pixels[(iter%(cpalette.size-1))+1]:color_output(zre,zim,iter)); };

}

# 467 "docalc.c"
static unsigned int
mand3_peri(register number_t zre, register number_t zim,
     register number_t pre, register number_t pim)

{
    register unsigned int iter = cfractalc.maxiter /*& (~(int) 3) */ ;
    register number_t r1 = zre, s1 = zim;
    number_t szre = 0, szim = 0; /*F. : Didn't declared register, cause they are few used */
    unsigned int whensavenew, whenincsave;

    register number_t rp = 0, ip;




    ;
    ;
    if (0)
 iter = 0;
    else {
 if (cfractalc.maxiter <= 16) {
     __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
     /*I386HACK; */

     rp = zre * zre;
     ip = zim * zim;

     /*F. : Added iter&7 to be sure we'll be on a 8 multiple */
     if (((rp+ip)<cfractalc.bailout) && iter) {
  do { /*try first 8 iterations */ rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
     }
     /*
	       while (BTEST && iter)
	       {
	       SAVEZMAG
	       FORMULA;
	       iter--;
	       } */
 } else {
     whensavenew = 7; /*You should adapt theese values */
     /*F. : We should always define whensavenew as 2^N-1, so we could use a AND instead of % */

     whenincsave = 10;

     rp = zre * zre;
     ip = zim * zim;

     /*F. : problem is that after deep zooming, peiodicity is never detected early, cause is is
	       quite slow before going in a periodic loop.
	       So, we should start checking periodicity only after some times */
     __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
     /*I386HACK; */
     iter = 8 + (cfractalc.maxiter & 7);
     while (((rp+ip)<cfractalc.bailout) && iter) { /*F. : Added iter&7 to be sure we'll be on a 8 multiple */
  rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
  iter--;
     }
     if (((rp+ip)<cfractalc.bailout)) { /*F. : BTEST is calculed two times here, isn't it ? */
  /*H. : No gcc is clever and adds test to the end :) */
  iter = (cfractalc.maxiter - 8) & (~7);
  do {
      szre = zre, szim = zim;
      ;
     
   /*I386HACK; */
   __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;; /*F. : Calculate one time */
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      iter -= 8;
      /*F. : We only test this now, as it can't be true before */
      if ((iter & whensavenew) == 0) { /*F. : changed % to & */
   r1 = zre, s1 = zim; /*F. : Save new values */
   whenincsave--;
   if (!whenincsave) {
       whensavenew = ((whensavenew + 1) << 1) - 1; /*F. : Changed to define a new AND mask */
       whenincsave = 10; /*F. : Start back */
   }
      }
  }
  while (((rp+ip)<cfractalc.bailout) && iter);
  if (!((rp+ip)<cfractalc.bailout)) { /*we got out of bounds */
      iter += 8; /*restore saved possition */
      ;
      zre = szre;
      zim = szim;

      rp = zre * zre;
      ip = zim * zim;

      __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
      /*I386HACK; */
      do { /*try first 8 iterations */ rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
      /*
		       do
		       {
		       SAVEZMAG
		       FORMULA;
		       iter--;
		       }
		       while (BTEST && iter); */
  }
     } else
  iter += cfractalc.maxiter - 8 - (cfractalc.maxiter & 7);
 }
    }







    ;
    iter = cfractalc.maxiter - iter;
    if(iter>=(unsigned int)cfractalc.maxiter) { if(cfractalc.incoloringmode==10) return(truecolor_output(zre,zim,pre,pim,cfractalc.intcolor,1)); ;return(cfractalc.incoloringmode?incolor_output(zre,zim,pre,pim,iter):cpalette.pixels[0]); } else { if(cfractalc.coloringmode==10) return(truecolor_output(zre,zim,pre,pim,cfractalc.outtcolor,0)); ;return(!cfractalc.coloringmode?cpalette.pixels[(iter%(cpalette.size-1))+1]:color_output(zre,zim,iter)); };

  periodicity:
    ;return(cpalette.pixels[0]);
}

# 123 "docalc.c"
static unsigned int
smand3_calc(register number_t zre, register number_t zim,
      register number_t pre, register number_t pim)
# 136 "docalc.c"
{
    register unsigned int iter = cfractalc.maxiter;
    number_t szre = 0, szim = 0;

    register number_t rp = 0, ip;


    number_t szmag = 0;

    ;
    ;
    if (0)
 iter = 0;
    else {

 rp = zre * zre;
 ip = zim * zim;

 if (iter < 16) {
     __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
     __asm__ ("#HACK" : : "f" (zre), "f" (zim) );;

     /*try first 8 iterations */
     if (((rp+ip)<cfractalc.bailout) && iter) {
  do { /*try first 8 iterations */ szmag=rp+ip;; rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
     }
     /*
	       while (BTEST && iter)
	       {  
	       SAVEZMAG;
	       FORMULA;
	       iter--;
	       } */
 } else {
     iter = 8 + (cfractalc.maxiter & 7);
     __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
     __asm__ ("#HACK" : : "f" (zre), "f" (zim) );;

     /*try first 8 iterations */
     if (((rp+ip)<cfractalc.bailout) && iter) {
  do { /*try first 8 iterations */ szmag=rp+ip;; rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
     }
     /*
	       while (BTEST && iter)
	       {  
	       SAVEZMAG;
	       FORMULA;
	       iter--;
	       } */
     if (((rp+ip)<cfractalc.bailout)) {
  iter = (cfractalc.maxiter - 8) & (~7);
  iter >>= 3;
  __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
  __asm__ ("#HACK" : : "f" (zre), "f" (zim) );; /*do next 8 iteration w/o out of bounds checking */
  do {
      /*hmm..we are probably in some deep area. */
      szre = zre; /*save current possition */
      szim = zim;
      ;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      ;
      iter--;
  }
  while (((rp+ip)<cfractalc.bailout) && iter);
  if (!(((rp+ip)<cfractalc.bailout))) { /*we got out of bounds */
      iter <<= 3;
      iter += 8; /*restore saved possition */
      ;
      zre = szre;
      zim = szim;

      rp = zre * zre;
      ip = zim * zim;

      __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
      __asm__ ("#HACK" : : "f" (zre), "f" (zim) );;
      do { /*try first 8 iterations */ szmag=rp+ip;; rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
      /*
		       do
		       {
		       SAVEZMAG
		       FORMULA;
		       iter--;
		       }
		       while (BTEST && iter); */
  }
     } else
  iter += cfractalc.maxiter - 8 - (cfractalc.maxiter & 7);
 }
    }

    if (iter)
 {zre=rp+ip;zre+=0.000001;szmag+=0.000001; iter=(int)(((cfractalc.maxiter-iter)*256+log((double)(cfractalc.bailout/(szmag)))/log((double)((zre)/(szmag)))*256)); if (iter < 0) { iter = (((unsigned int)(cpalette.size - 1)) << 8) - ((-iter) % (((unsigned int)(cpalette.size - 1)) << 8))-1; if (iter < 0) iter=0; } iter %= ((unsigned int)(cpalette.size - 1)) << 8; if ((cpalette.type & (1 | 64)) || !(iter & 255)) return (cpalette.pixels[1 + (iter >> 8)]); { unsigned int i1, i2; i1 = cpalette.pixels[1 + (iter >> 8)]; if ((iter >> 8) == (unsigned int)(cpalette.size - 2)) i2 = cpalette.pixels[1]; else i2 = cpalette.pixels[2 + (iter >> 8)]; iter &= 255; return (((cpalette).type==2 || (cpalette).type == 32?(((i2)*iter+(i1)*(256-(iter)))>>8):(((((cpalette).info.truec.rmask)|((cpalette).info.truec.gmask)|((cpalette).info.truec.bmask))&0xff000000)?((((((((i2)>>8)&(((cpalette).info.truec.rmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.rmask)>>8))*(256-(iter)))&((((cpalette).info.truec.rmask)>>8)<<8))+(((((i2)>>8)&(((cpalette).info.truec.gmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.gmask)>>8))*(256-(iter)))&((((cpalette).info.truec.gmask)>>8)<<8))+(((((i2)>>8)&(((cpalette).info.truec.bmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.bmask)>>8))*(256-(iter)))&((((cpalette).info.truec.bmask)>>8)<<8)))>>8)<<8):((((((i2)&((cpalette).info.truec.rmask))*(iter)+((i1)&((cpalette).info.truec.rmask))*(256-(iter)))&(((cpalette).info.truec.rmask)<<8))+((((i2)&((cpalette).info.truec.gmask))*(iter)+((i1)&((cpalette).info.truec.gmask))*(256-(iter)))&(((cpalette).info.truec.gmask)<<8))+((((i2)&((cpalette).info.truec.bmask))*(iter)+((i1)&((cpalette).info.truec.bmask))*(256-(iter)))&(((cpalette).info.truec.bmask)<<8)))>>8)))); } };
    ;
    iter = cfractalc.maxiter - iter;
    ;return(cfractalc.incoloringmode?incolor_output(zre,zim,pre,pim,iter):cpalette.pixels[0]);





}

# 458 "docalc.c"
static unsigned int
smand3_peri(register number_t zre, register number_t zim,
      register number_t pre, register number_t pim)
# 471 "docalc.c"
{
    register unsigned int iter = cfractalc.maxiter /*& (~(int) 3) */ ;
    register number_t r1 = zre, s1 = zim;
    number_t szre = 0, szim = 0; /*F. : Didn't declared register, cause they are few used */
    unsigned int whensavenew, whenincsave;

    register number_t rp = 0, ip;


    number_t szmag = 0;

    ;
    ;
    if (0)
 iter = 0;
    else {
 if (cfractalc.maxiter <= 16) {
     __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
     /*I386HACK; */

     rp = zre * zre;
     ip = zim * zim;

     /*F. : Added iter&7 to be sure we'll be on a 8 multiple */
     if (((rp+ip)<cfractalc.bailout) && iter) {
  do { /*try first 8 iterations */ szmag=rp+ip;; rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
     }
     /*
	       while (BTEST && iter)
	       {
	       SAVEZMAG
	       FORMULA;
	       iter--;
	       } */
 } else {
     whensavenew = 7; /*You should adapt theese values */
     /*F. : We should always define whensavenew as 2^N-1, so we could use a AND instead of % */

     whenincsave = 10;

     rp = zre * zre;
     ip = zim * zim;

     /*F. : problem is that after deep zooming, peiodicity is never detected early, cause is is
	       quite slow before going in a periodic loop.
	       So, we should start checking periodicity only after some times */
     __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
     /*I386HACK; */
     iter = 8 + (cfractalc.maxiter & 7);
     while (((rp+ip)<cfractalc.bailout) && iter) { /*F. : Added iter&7 to be sure we'll be on a 8 multiple */
  szmag=rp+ip; rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
  iter--;
     }
     if (((rp+ip)<cfractalc.bailout)) { /*F. : BTEST is calculed two times here, isn't it ? */
  /*H. : No gcc is clever and adds test to the end :) */
  iter = (cfractalc.maxiter - 8) & (~7);
  do {
      szre = zre, szim = zim;
      ;
      szmag=rp+ip;
   /*I386HACK; */
   __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;; /*F. : Calculate one time */
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;;
      if (((__builtin_fabsl((number_t)(r1 - zre))<cfractalc.periodicity_limit) && (__builtin_fabsl((number_t)(s1 - zim))<cfractalc.periodicity_limit)))
   goto periodicity;
      iter -= 8;
      /*F. : We only test this now, as it can't be true before */
      if ((iter & whensavenew) == 0) { /*F. : changed % to & */
   r1 = zre, s1 = zim; /*F. : Save new values */
   whenincsave--;
   if (!whenincsave) {
       whensavenew = ((whensavenew + 1) << 1) - 1; /*F. : Changed to define a new AND mask */
       whenincsave = 10; /*F. : Start back */
   }
      }
  }
  while (((rp+ip)<cfractalc.bailout) && iter);
  if (!((rp+ip)<cfractalc.bailout)) { /*we got out of bounds */
      iter += 8; /*restore saved possition */
      ;
      zre = szre;
      zim = szim;

      rp = zre * zre;
      ip = zim * zim;

      __asm__ ("#HACK1" : : "m" (szre), "m" (szim) );;
      /*I386HACK; */
      do { /*try first 8 iterations */ szmag=rp+ip;; rp = zre * (rp - 3 * ip); zim = zim * (3 * zre * zre - ip) + pim; zre = rp + pre; rp = zre * zre; ip = zim * zim;; iter--; } while (((rp+ip)<cfractalc.bailout) && iter);
      /*
		       do
		       {
		       SAVEZMAG
		       FORMULA;
		       iter--;
		       }
		       while (BTEST && iter); */
  }
     } else
  iter += cfractalc.maxiter - 8 - (cfractalc.maxiter & 7);
 }
    }

    if (iter)
 {zre=rp+ip;zre+=0.000001;szmag+=0.000001; iter=(int)(((cfractalc.maxiter-iter)*256+log((double)(cfractalc.bailout/(szmag)))/log((double)((zre)/(szmag)))*256)); if (iter < 0) { iter = (((unsigned int)(cpalette.size - 1)) << 8) - ((-iter) % (((unsigned int)(cpalette.size - 1)) << 8))-1; if (iter < 0) iter=0; } iter %= ((unsigned int)(cpalette.size - 1)) << 8; if ((cpalette.type & (1 | 64)) || !(iter & 255)) return (cpalette.pixels[1 + (iter >> 8)]); { unsigned int i1, i2; i1 = cpalette.pixels[1 + (iter >> 8)]; if ((iter >> 8) == (unsigned int)(cpalette.size - 2)) i2 = cpalette.pixels[1]; else i2 = cpalette.pixels[2 + (iter >> 8)]; iter &= 255; return (((cpalette).type==2 || (cpalette).type == 32?(((i2)*iter+(i1)*(256-(iter)))>>8):(((((cpalette).info.truec.rmask)|((cpalette).info.truec.gmask)|((cpalette).info.truec.bmask))&0xff000000)?((((((((i2)>>8)&(((cpalette).info.truec.rmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.rmask)>>8))*(256-(iter)))&((((cpalette).info.truec.rmask)>>8)<<8))+(((((i2)>>8)&(((cpalette).info.truec.gmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.gmask)>>8))*(256-(iter)))&((((cpalette).info.truec.gmask)>>8)<<8))+(((((i2)>>8)&(((cpalette).info.truec.bmask)>>8))*(iter)+(((i1)>>8)&(((cpalette).info.truec.bmask)>>8))*(256-(iter)))&((((cpalette).info.truec.bmask)>>8)<<8)))>>8)<<8):((((((i2)&((cpalette).info.truec.rmask))*(iter)+((i1)&((cpalette).info.truec.rmask))*(256-(iter)))&(((cpalette).info.truec.rmask)<<8))+((((i2)&((cpalette).info.truec.gmask))*(iter)+((i1)&((cpalette).info.truec.gmask))*(256-(iter)))&(((cpalette).info.truec.gmask)<<8))+((((i2)&((cpalette).info.truec.bmask))*(iter)+((i1)&((cpalette).info.truec.bmask))*(256-(iter)))&(((cpalette).info.truec.bmask)<<8)))>>8)))); } };
    ;
    iter = cfractalc.maxiter - iter;
    ;return(cfractalc.incoloringmode?incolor_output(zre,zim,pre,pim,iter):cpalette.pixels[0]);





  periodicity:
    ;return(cpalette.pixels[0]);
}

# 18 "i386.c"
unsigned short _control87(unsigned short newcw, unsigned short mask)
{
    unsigned short cw;

    asm volatile ("                                                    \n      wait                                                          \n      fstcw  %0                                                       ":

                                                                         /* outputs */ "=m" (cw)
    : /* inputs */
 );

    if (mask) { /* mask is not 0 */
 asm volatile ("                                                  \n        mov    %2, %%ax                                             \n        mov    %3, %%cx                                             \n        and    %%cx, %%ax                                           \n        not    %%cx                                                 \n        nop                                                         \n        wait                                                        \n        mov    %1, %%dx                                             \n        and    %%cx, %%dx                                           \n        or     %%ax, %%dx                                           \n        mov    %%dx, %0                                             \n        wait                                                        \n        fldcw  %1                                                     ":
# 42 "i386.c"
        /* outputs */ "=m" (cw)
        : /* inputs */ "m"(cw), "m"(newcw), "m"(mask)
        : /* registers */ "ax", "cx", "dx"
     );
    }
    return cw;

}

