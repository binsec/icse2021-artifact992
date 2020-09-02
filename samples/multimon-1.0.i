# 35 "filter-i386.h"
extern inline float __mac_g(const float *a, const float *b, unsigned int size)
{
 float sum = 0;
 unsigned int i;

 for (i = 0; i < size; i++)
  sum += (*a++) * (*b++);
 return sum;
}

# 45 "filter-i386.h"
extern inline float __mac_c(const float *a, const float *b, unsigned int size)
{
 float f;

 /*
	 * inspired from Phil Karn, KA9Q's home page
	 */
 switch (size) {
 case 9:
  asm volatile ("flds (%1);\n\t"
         "fmuls (%2);\n\t"
         "flds 4(%1);\n\t"
         "fmuls 4(%2);\n\t"
         "flds 8(%1);\n\t"
         "fmuls 8(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 12(%1);\n\t"
         "fmuls 12(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 16(%1);\n\t"
         "fmuls 16(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 20(%1);\n\t"
         "fmuls 20(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 24(%1);\n\t"
         "fmuls 24(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 28(%1);\n\t"
         "fmuls 28(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 32(%1);\n\t"
         "fmuls 32(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "faddp;\n\t" :
         "=t" (f) :
         "r" (a),
         "r" (b) : "memory");
  return f;

 case 18:
  asm volatile ("flds (%1);\n\t"
         "fmuls (%2);\n\t"
         "flds 4(%1);\n\t"
         "fmuls 4(%2);\n\t"
         "flds 8(%1);\n\t"
         "fmuls 8(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 12(%1);\n\t"
         "fmuls 12(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 16(%1);\n\t"
         "fmuls 16(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 20(%1);\n\t"
         "fmuls 20(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 24(%1);\n\t"
         "fmuls 24(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 28(%1);\n\t"
         "fmuls 28(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 32(%1);\n\t"
         "fmuls 32(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 36(%1);\n\t"
         "fmuls 36(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 40(%1);\n\t"
         "fmuls 40(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 44(%1);\n\t"
         "fmuls 44(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 48(%1);\n\t"
         "fmuls 48(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 52(%1);\n\t"
         "fmuls 52(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 56(%1);\n\t"
         "fmuls 56(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 60(%1);\n\t"
         "fmuls 60(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 64(%1);\n\t"
         "fmuls 64(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 68(%1);\n\t"
         "fmuls 68(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "faddp;\n\t" :
         "=t" (f) :
         "r" (a),
         "r" (b) : "memory");
  return f;

 case 24:
  asm volatile ("flds (%1);\n\t"
         "fmuls (%2);\n\t"
         "flds 4(%1);\n\t"
         "fmuls 4(%2);\n\t"
         "flds 8(%1);\n\t"
         "fmuls 8(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 12(%1);\n\t"
         "fmuls 12(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 16(%1);\n\t"
         "fmuls 16(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 20(%1);\n\t"
         "fmuls 20(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 24(%1);\n\t"
         "fmuls 24(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 28(%1);\n\t"
         "fmuls 28(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 32(%1);\n\t"
         "fmuls 32(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 36(%1);\n\t"
         "fmuls 36(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 40(%1);\n\t"
         "fmuls 40(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 44(%1);\n\t"
         "fmuls 44(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 48(%1);\n\t"
         "fmuls 48(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 52(%1);\n\t"
         "fmuls 52(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 56(%1);\n\t"
         "fmuls 56(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 60(%1);\n\t"
         "fmuls 60(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 64(%1);\n\t"
         "fmuls 64(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 68(%1);\n\t"
         "fmuls 68(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 72(%1);\n\t"
         "fmuls 72(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 76(%1);\n\t"
         "fmuls 76(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 80(%1);\n\t"
         "fmuls 80(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 84(%1);\n\t"
         "fmuls 84(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 88(%1);\n\t"
         "fmuls 88(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "flds 92(%1);\n\t"
         "fmuls 92(%2);\n\t"
         "fxch %%st(2);\n\t"
         "faddp;\n\t"
         "faddp;\n\t" :
         "=t" (f) :
         "r" (a),
         "r" (b) : "memory");
  return f;

 case 42:
  /* Thomas, Help! EAS needs this optimized. -Maitland */
  return __mac_g(a, b, size);

 default:
  printf("Warning: optimize __mac_c(..., ..., %d)\n", size);
  return __mac_g(a, b, size);
 }
}

