# 216 "/usr/lib/gcc/x86_64-linux-gnu/5/include/stddef.h"
typedef unsigned int size_t;

# 260 "pcm_dmix_generic.c"
static void generic_mix_areas_16_swap(unsigned int size,
          volatile signed short *dst,
          signed short *src,
          volatile signed int *sum,
          size_t dst_step,
          size_t src_step,
          size_t sum_step)
{
 register signed int sample;

 for (;;) {
  sample = (signed short) 
# 271 "pcm_dmix_generic.c" 3 4
                         (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (
# 271 "pcm_dmix_generic.c"
                         *src
# 271 "pcm_dmix_generic.c" 3 4
                         ); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))
# 271 "pcm_dmix_generic.c"
                                       ;
  if (! *dst) {
   *sum = sample;
   *dst = *src;
  } else {
   sample += *sum;
   *sum = sample;
   if (sample > 0x7fff)
    sample = 0x7fff;
   else if (sample < -0x8000)
    sample = -0x8000;
   *dst = (signed short) 
# 282 "pcm_dmix_generic.c" 3 4
                        (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (
# 282 "pcm_dmix_generic.c"
                        (signed short) sample
# 282 "pcm_dmix_generic.c" 3 4
                        ); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))
# 282 "pcm_dmix_generic.c"
                                                       ;
  }
  if (!--size)
   return;
  src = (signed short *) ((char *)src + src_step);
  dst = (signed short *) ((char *)dst + dst_step);
  sum = (signed int *) ((char *)sum + sum_step);
 }
}

# 292 "pcm_dmix_generic.c"
static void generic_remix_areas_16_swap(unsigned int size,
            volatile signed short *dst,
            signed short *src,
            volatile signed int *sum,
            size_t dst_step,
            size_t src_step,
            size_t sum_step)
{
 register signed int sample;

 for (;;) {
  sample = (signed short) 
# 303 "pcm_dmix_generic.c" 3 4
                         (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (
# 303 "pcm_dmix_generic.c"
                         *src
# 303 "pcm_dmix_generic.c" 3 4
                         ); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))
# 303 "pcm_dmix_generic.c"
                                       ;
  if (! *dst) {
   *sum = -sample;
   *dst = (signed short) 
# 306 "pcm_dmix_generic.c" 3 4
                        (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (
# 306 "pcm_dmix_generic.c"
                        (signed short) -sample
# 306 "pcm_dmix_generic.c" 3 4
                        ); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))
# 306 "pcm_dmix_generic.c"
                                                        ;
  } else {
   *sum = sample = *sum - sample;
   if (sample > 0x7fff)
    sample = 0x7fff;
   else if (sample < -0x8000)
    sample = -0x8000;
   *dst = (signed short) 
# 313 "pcm_dmix_generic.c" 3 4
                        (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (
# 313 "pcm_dmix_generic.c"
                        (signed short) sample
# 313 "pcm_dmix_generic.c" 3 4
                        ); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))
# 313 "pcm_dmix_generic.c"
                                                       ;
  }
  if (!--size)
   return;
  src = (signed short *) ((char *)src + src_step);
  dst = (signed short *) ((char *)dst + dst_step);
  sum = (signed int *) ((char *)sum + sum_step);
 }
}

# 32 "pcm_dmix_i386.h"
static void mix_areas_16(unsigned int size,
    volatile signed short *dst, signed short *src,
    volatile signed int *sum, size_t dst_step,
    size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 47 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjnz 2f\n"
  "\tjmp 7f\n"





  "\t.p2align 4,,15\n"
  "1:"
  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"
# 79 "pcm_dmix_i386.h"
  "2:"
  "\tmovw $0, %%ax\n"
  "\tmovw $1, %%cx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\t" "" "cmpxchgw %%cx, (%%edi)\n"
  "\tmovswl (%%esi), %%ecx\n"
  "\tjnz 3f\n"
  "\t" "subl" " %%edx, %%ecx\n"
  "3:"
  "\t" "" "addl" " %%ecx, (%%ebx)\n"
# 98 "pcm_dmix_i386.h"
  "4:"
  "\tmovl (%%ebx), %%ecx\n"
  "\tcmpl $0x7fff,%%ecx\n"
  "\tjg 5f\n"
  "\tcmpl $-0x8000,%%ecx\n"
  "\tjl 6f\n"
  "\tmovw %%cx, (%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 4b\n"




  "\tdecl %0\n"
  "\tjnz 1b\n"
  "\tjmp 7f\n"





  "\t.p2align 4,,15\n"

  "5:"
  "\tmovw $0x7fff, (%%edi)\n"
  "\tcmpl %%ecx,(%%ebx)\n"
  "\tjnz 4b\n"
  "\tdecl %0\n"
  "\tjnz 1b\n"
  "\tjmp 7f\n"





  "\t.p2align 4,,15\n"

  "6:"
  "\tmovw $-0x8000, (%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 4b\n"
  "\tdecl %0\n"
  "\tjnz 1b\n"

  "7:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 156 "pcm_dmix_i386.h"
static void mix_areas_16_mmx(unsigned int size,
        volatile signed short *dst, signed short *src,
        volatile signed int *sum, size_t dst_step,
        size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 171 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjnz 2f\n"
  "\tjmp 5f\n"

  "\t.p2align 4,,15\n"
  "1:"
  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"

  "2:"







  "\tmovw $0, %%ax\n"
  "\tmovw $1, %%cx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\t" "" "cmpxchgw %%cx, (%%edi)\n"
  "\tmovswl (%%esi), %%ecx\n"
  "\tjnz 3f\n"
  "\t" "subl" " %%edx, %%ecx\n"
  "3:"
  "\t" "" "addl" " %%ecx, (%%ebx)\n"
# 217 "pcm_dmix_i386.h"
  "4:"
  "\tmovl (%%ebx), %%ecx\n"
  "\tmovd %%ecx, %%mm0\n"
  "\tpackssdw %%mm1, %%mm0\n"
  "\tmovd %%mm0, %%eax\n"
  "\tmovw %%ax, (%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 4b\n"




  "\tdecl %0\n"
  "\tjnz 1b\n"
  "\temms\n"
                "5:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 246 "pcm_dmix_i386.h"
static void mix_areas_32(unsigned int size,
    volatile signed int *dst, signed int *src,
    volatile signed int *sum, size_t dst_step,
    size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 261 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjnz 1f\n"
  "\tjmp 6f\n"

  "\t.p2align 4,,15\n"

  "1:"
# 286 "pcm_dmix_i386.h"
  "\tmovl $0, %%eax\n"
  "\tmovl $1, %%ecx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\t" "" "cmpxchgl %%ecx, (%%edi)\n"
  "\tjnz 2f\n"
  "\tmovl (%%esi), %%ecx\n"

  "\tsarl $8, %%ecx\n"
  "\t" "subl" " %%edx, %%ecx\n"
  "\tjmp 21f\n"
  "2:"
  "\tmovl (%%esi), %%ecx\n"

  "\tsarl $8, %%ecx\n"
  "21:"
  "\t" "" "addl" " %%ecx, (%%ebx)\n"
# 311 "pcm_dmix_i386.h"
  "3:"
  "\tmovl (%%ebx), %%ecx\n"



  "\tmovl $0x7fffff, %%eax\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tjg 4f\n"



  "\tmovl $-0x800000, %%eax\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tjl 4f\n"
  "\tmovl %%ecx, %%eax\n"
  "4:"



  "\tsall $8, %%eax\n"
  "\tmovl %%eax, (%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 3b\n"




  "\tdecl %0\n"
  "\tjz 6f\n"
  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"
  "\tjmp 1b\n"

  "6:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 359 "pcm_dmix_i386.h"
static void mix_areas_24(unsigned int size,
    volatile unsigned char *dst, unsigned char *src,
    volatile signed int *sum, size_t dst_step,
    size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 374 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjnz 1f\n"
  "\tjmp 6f\n"

  "\t.p2align 4,,15\n"

  "1:"
# 399 "pcm_dmix_i386.h"
  "\tmovsbl 2(%%esi), %%eax\n"
  "\tmovzwl (%%esi), %%ecx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\tsall $16, %%eax\n"
  "\torl %%eax, %%ecx\n"
  "\t" "" "btsw $0, (%%edi)\n"
  "\tjc 2f\n"
  "\t" "subl" " %%edx, %%ecx\n"
  "2:"
  "\t" "" "addl" " %%ecx, (%%ebx)\n"
# 418 "pcm_dmix_i386.h"
  "3:"
  "\tmovl (%%ebx), %%ecx\n"



  "\tmovl $0x7fffff, %%eax\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tjg 4f\n"



  "\tmovl $-0x7fffff, %%eax\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tjl 4f\n"
  "\tmovl %%ecx, %%eax\n"
  "\torl $1, %%eax\n"
  "4:"
  "\tmovw %%ax, (%%edi)\n"
  "\tshrl $16, %%eax\n"
  "\tmovb %%al, 2(%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 3b\n"




  "\tdecl %0\n"
  "\tjz 6f\n"
  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"
  "\tjmp 1b\n"

  "6:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 465 "pcm_dmix_i386.h"
static void mix_areas_24_cmov(unsigned int size,
         volatile unsigned char *dst, unsigned char *src,
         volatile signed int *sum, size_t dst_step,
         size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 480 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjz 6f\n"

  "\t.p2align 4,,15\n"

  "1:"
# 504 "pcm_dmix_i386.h"
  "\tmovsbl 2(%%esi), %%eax\n"
  "\tmovzwl (%%esi), %%ecx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\tsall $16, %%eax\n"
  "\t" "" "btsw $0, (%%edi)\n"
  "\tleal (%%ecx,%%eax,1), %%ecx\n"
  "\tjc 2f\n"
  "\t" "subl" " %%edx, %%ecx\n"
  "2:"
  "\t" "" "addl" " %%ecx, (%%ebx)\n"
# 523 "pcm_dmix_i386.h"
  "3:"
  "\tmovl (%%ebx), %%ecx\n"

  "\tmovl $0x7fffff, %%eax\n"
  "\tmovl $-0x7fffff, %%edx\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tcmovng %%ecx, %%eax\n"
  "\tcmpl %%edx, %%ecx\n"
  "\tcmovl %%edx, %%eax\n"

  "\torl $1, %%eax\n"
  "\tmovw %%ax, (%%edi)\n"
  "\tshrl $16, %%eax\n"
  "\tmovb %%al, 2(%%edi)\n"

  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 3b\n"




  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"
  "\tdecl %0\n"
  "\tjnz 1b\n"

  "6:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 32 "pcm_dmix_i386.h"
static void remix_areas_16(unsigned int size,
    volatile signed short *dst, signed short *src,
    volatile signed int *sum, size_t dst_step,
    size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 47 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjnz 2f\n"
  "\tjmp 7f\n"





  "\t.p2align 4,,15\n"
  "1:"
  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"
# 79 "pcm_dmix_i386.h"
  "2:"
  "\tmovw $0, %%ax\n"
  "\tmovw $1, %%cx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\t" "" "cmpxchgw %%cx, (%%edi)\n"
  "\tmovswl (%%esi), %%ecx\n"
  "\tjnz 3f\n"
  "\t" "addl" " %%edx, %%ecx\n"
  "3:"
  "\t" "" "subl" " %%ecx, (%%ebx)\n"
# 98 "pcm_dmix_i386.h"
  "4:"
  "\tmovl (%%ebx), %%ecx\n"
  "\tcmpl $0x7fff,%%ecx\n"
  "\tjg 5f\n"
  "\tcmpl $-0x8000,%%ecx\n"
  "\tjl 6f\n"
  "\tmovw %%cx, (%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 4b\n"




  "\tdecl %0\n"
  "\tjnz 1b\n"
  "\tjmp 7f\n"





  "\t.p2align 4,,15\n"

  "5:"
  "\tmovw $0x7fff, (%%edi)\n"
  "\tcmpl %%ecx,(%%ebx)\n"
  "\tjnz 4b\n"
  "\tdecl %0\n"
  "\tjnz 1b\n"
  "\tjmp 7f\n"





  "\t.p2align 4,,15\n"

  "6:"
  "\tmovw $-0x8000, (%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 4b\n"
  "\tdecl %0\n"
  "\tjnz 1b\n"

  "7:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 156 "pcm_dmix_i386.h"
static void remix_areas_16_mmx(unsigned int size,
        volatile signed short *dst, signed short *src,
        volatile signed int *sum, size_t dst_step,
        size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 171 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjnz 2f\n"
  "\tjmp 5f\n"

  "\t.p2align 4,,15\n"
  "1:"
  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"

  "2:"







  "\tmovw $0, %%ax\n"
  "\tmovw $1, %%cx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\t" "" "cmpxchgw %%cx, (%%edi)\n"
  "\tmovswl (%%esi), %%ecx\n"
  "\tjnz 3f\n"
  "\t" "addl" " %%edx, %%ecx\n"
  "3:"
  "\t" "" "subl" " %%ecx, (%%ebx)\n"
# 217 "pcm_dmix_i386.h"
  "4:"
  "\tmovl (%%ebx), %%ecx\n"
  "\tmovd %%ecx, %%mm0\n"
  "\tpackssdw %%mm1, %%mm0\n"
  "\tmovd %%mm0, %%eax\n"
  "\tmovw %%ax, (%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 4b\n"




  "\tdecl %0\n"
  "\tjnz 1b\n"
  "\temms\n"
                "5:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 246 "pcm_dmix_i386.h"
static void remix_areas_32(unsigned int size,
    volatile signed int *dst, signed int *src,
    volatile signed int *sum, size_t dst_step,
    size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 261 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjnz 1f\n"
  "\tjmp 6f\n"

  "\t.p2align 4,,15\n"

  "1:"
# 286 "pcm_dmix_i386.h"
  "\tmovl $0, %%eax\n"
  "\tmovl $1, %%ecx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\t" "" "cmpxchgl %%ecx, (%%edi)\n"
  "\tjnz 2f\n"
  "\tmovl (%%esi), %%ecx\n"

  "\tsarl $8, %%ecx\n"
  "\t" "addl" " %%edx, %%ecx\n"
  "\tjmp 21f\n"
  "2:"
  "\tmovl (%%esi), %%ecx\n"

  "\tsarl $8, %%ecx\n"
  "21:"
  "\t" "" "subl" " %%ecx, (%%ebx)\n"
# 311 "pcm_dmix_i386.h"
  "3:"
  "\tmovl (%%ebx), %%ecx\n"



  "\tmovl $0x7fffff, %%eax\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tjg 4f\n"



  "\tmovl $-0x800000, %%eax\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tjl 4f\n"
  "\tmovl %%ecx, %%eax\n"
  "4:"



  "\tsall $8, %%eax\n"
  "\tmovl %%eax, (%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 3b\n"




  "\tdecl %0\n"
  "\tjz 6f\n"
  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"
  "\tjmp 1b\n"

  "6:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 359 "pcm_dmix_i386.h"
static void remix_areas_24(unsigned int size,
    volatile unsigned char *dst, unsigned char *src,
    volatile signed int *sum, size_t dst_step,
    size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 374 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjnz 1f\n"
  "\tjmp 6f\n"

  "\t.p2align 4,,15\n"

  "1:"
# 399 "pcm_dmix_i386.h"
  "\tmovsbl 2(%%esi), %%eax\n"
  "\tmovzwl (%%esi), %%ecx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\tsall $16, %%eax\n"
  "\torl %%eax, %%ecx\n"
  "\t" "" "btsw $0, (%%edi)\n"
  "\tjc 2f\n"
  "\t" "addl" " %%edx, %%ecx\n"
  "2:"
  "\t" "" "subl" " %%ecx, (%%ebx)\n"
# 418 "pcm_dmix_i386.h"
  "3:"
  "\tmovl (%%ebx), %%ecx\n"



  "\tmovl $0x7fffff, %%eax\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tjg 4f\n"



  "\tmovl $-0x7fffff, %%eax\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tjl 4f\n"
  "\tmovl %%ecx, %%eax\n"
  "\torl $1, %%eax\n"
  "4:"
  "\tmovw %%ax, (%%edi)\n"
  "\tshrl $16, %%eax\n"
  "\tmovb %%al, 2(%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 3b\n"




  "\tdecl %0\n"
  "\tjz 6f\n"
  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"
  "\tjmp 1b\n"

  "6:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 465 "pcm_dmix_i386.h"
static void remix_areas_24_cmov(unsigned int size,
         volatile unsigned char *dst, unsigned char *src,
         volatile signed int *sum, size_t dst_step,
         size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 480 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjz 6f\n"

  "\t.p2align 4,,15\n"

  "1:"
# 504 "pcm_dmix_i386.h"
  "\tmovsbl 2(%%esi), %%eax\n"
  "\tmovzwl (%%esi), %%ecx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\tsall $16, %%eax\n"
  "\t" "" "btsw $0, (%%edi)\n"
  "\tleal (%%ecx,%%eax,1), %%ecx\n"
  "\tjc 2f\n"
  "\t" "addl" " %%edx, %%ecx\n"
  "2:"
  "\t" "" "subl" " %%ecx, (%%ebx)\n"
# 523 "pcm_dmix_i386.h"
  "3:"
  "\tmovl (%%ebx), %%ecx\n"

  "\tmovl $0x7fffff, %%eax\n"
  "\tmovl $-0x7fffff, %%edx\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tcmovng %%ecx, %%eax\n"
  "\tcmpl %%edx, %%ecx\n"
  "\tcmovl %%edx, %%eax\n"

  "\torl $1, %%eax\n"
  "\tmovw %%ax, (%%edi)\n"
  "\tshrl $16, %%eax\n"
  "\tmovb %%al, 2(%%edi)\n"

  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 3b\n"




  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"
  "\tdecl %0\n"
  "\tjnz 1b\n"

  "6:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 32 "pcm_dmix_i386.h"
static void mix_areas_16_smp(unsigned int size,
    volatile signed short *dst, signed short *src,
    volatile signed int *sum, size_t dst_step,
    size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 47 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjnz 2f\n"
  "\tjmp 7f\n"





  "\t.p2align 4,,15\n"
  "1:"
  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"
# 79 "pcm_dmix_i386.h"
  "2:"
  "\tmovw $0, %%ax\n"
  "\tmovw $1, %%cx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\t" "lock ; " "cmpxchgw %%cx, (%%edi)\n"
  "\tmovswl (%%esi), %%ecx\n"
  "\tjnz 3f\n"
  "\t" "subl" " %%edx, %%ecx\n"
  "3:"
  "\t" "lock ; " "addl" " %%ecx, (%%ebx)\n"
# 98 "pcm_dmix_i386.h"
  "4:"
  "\tmovl (%%ebx), %%ecx\n"
  "\tcmpl $0x7fff,%%ecx\n"
  "\tjg 5f\n"
  "\tcmpl $-0x8000,%%ecx\n"
  "\tjl 6f\n"
  "\tmovw %%cx, (%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 4b\n"




  "\tdecl %0\n"
  "\tjnz 1b\n"
  "\tjmp 7f\n"





  "\t.p2align 4,,15\n"

  "5:"
  "\tmovw $0x7fff, (%%edi)\n"
  "\tcmpl %%ecx,(%%ebx)\n"
  "\tjnz 4b\n"
  "\tdecl %0\n"
  "\tjnz 1b\n"
  "\tjmp 7f\n"





  "\t.p2align 4,,15\n"

  "6:"
  "\tmovw $-0x8000, (%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 4b\n"
  "\tdecl %0\n"
  "\tjnz 1b\n"

  "7:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 156 "pcm_dmix_i386.h"
static void mix_areas_16_smp_mmx(unsigned int size,
        volatile signed short *dst, signed short *src,
        volatile signed int *sum, size_t dst_step,
        size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 171 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjnz 2f\n"
  "\tjmp 5f\n"

  "\t.p2align 4,,15\n"
  "1:"
  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"

  "2:"







  "\tmovw $0, %%ax\n"
  "\tmovw $1, %%cx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\t" "lock ; " "cmpxchgw %%cx, (%%edi)\n"
  "\tmovswl (%%esi), %%ecx\n"
  "\tjnz 3f\n"
  "\t" "subl" " %%edx, %%ecx\n"
  "3:"
  "\t" "lock ; " "addl" " %%ecx, (%%ebx)\n"
# 217 "pcm_dmix_i386.h"
  "4:"
  "\tmovl (%%ebx), %%ecx\n"
  "\tmovd %%ecx, %%mm0\n"
  "\tpackssdw %%mm1, %%mm0\n"
  "\tmovd %%mm0, %%eax\n"
  "\tmovw %%ax, (%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 4b\n"




  "\tdecl %0\n"
  "\tjnz 1b\n"
  "\temms\n"
                "5:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 246 "pcm_dmix_i386.h"
static void mix_areas_32_smp(unsigned int size,
    volatile signed int *dst, signed int *src,
    volatile signed int *sum, size_t dst_step,
    size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 261 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjnz 1f\n"
  "\tjmp 6f\n"

  "\t.p2align 4,,15\n"

  "1:"
# 286 "pcm_dmix_i386.h"
  "\tmovl $0, %%eax\n"
  "\tmovl $1, %%ecx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\t" "lock ; " "cmpxchgl %%ecx, (%%edi)\n"
  "\tjnz 2f\n"
  "\tmovl (%%esi), %%ecx\n"

  "\tsarl $8, %%ecx\n"
  "\t" "subl" " %%edx, %%ecx\n"
  "\tjmp 21f\n"
  "2:"
  "\tmovl (%%esi), %%ecx\n"

  "\tsarl $8, %%ecx\n"
  "21:"
  "\t" "lock ; " "addl" " %%ecx, (%%ebx)\n"
# 311 "pcm_dmix_i386.h"
  "3:"
  "\tmovl (%%ebx), %%ecx\n"



  "\tmovl $0x7fffff, %%eax\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tjg 4f\n"



  "\tmovl $-0x800000, %%eax\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tjl 4f\n"
  "\tmovl %%ecx, %%eax\n"
  "4:"



  "\tsall $8, %%eax\n"
  "\tmovl %%eax, (%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 3b\n"




  "\tdecl %0\n"
  "\tjz 6f\n"
  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"
  "\tjmp 1b\n"

  "6:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 359 "pcm_dmix_i386.h"
static void mix_areas_24_smp(unsigned int size,
    volatile unsigned char *dst, unsigned char *src,
    volatile signed int *sum, size_t dst_step,
    size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 374 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjnz 1f\n"
  "\tjmp 6f\n"

  "\t.p2align 4,,15\n"

  "1:"
# 399 "pcm_dmix_i386.h"
  "\tmovsbl 2(%%esi), %%eax\n"
  "\tmovzwl (%%esi), %%ecx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\tsall $16, %%eax\n"
  "\torl %%eax, %%ecx\n"
  "\t" "lock ; " "btsw $0, (%%edi)\n"
  "\tjc 2f\n"
  "\t" "subl" " %%edx, %%ecx\n"
  "2:"
  "\t" "lock ; " "addl" " %%ecx, (%%ebx)\n"
# 418 "pcm_dmix_i386.h"
  "3:"
  "\tmovl (%%ebx), %%ecx\n"



  "\tmovl $0x7fffff, %%eax\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tjg 4f\n"



  "\tmovl $-0x7fffff, %%eax\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tjl 4f\n"
  "\tmovl %%ecx, %%eax\n"
  "\torl $1, %%eax\n"
  "4:"
  "\tmovw %%ax, (%%edi)\n"
  "\tshrl $16, %%eax\n"
  "\tmovb %%al, 2(%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 3b\n"




  "\tdecl %0\n"
  "\tjz 6f\n"
  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"
  "\tjmp 1b\n"

  "6:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 465 "pcm_dmix_i386.h"
static void mix_areas_24_smp_cmov(unsigned int size,
         volatile unsigned char *dst, unsigned char *src,
         volatile signed int *sum, size_t dst_step,
         size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 480 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjz 6f\n"

  "\t.p2align 4,,15\n"

  "1:"
# 504 "pcm_dmix_i386.h"
  "\tmovsbl 2(%%esi), %%eax\n"
  "\tmovzwl (%%esi), %%ecx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\tsall $16, %%eax\n"
  "\t" "lock ; " "btsw $0, (%%edi)\n"
  "\tleal (%%ecx,%%eax,1), %%ecx\n"
  "\tjc 2f\n"
  "\t" "subl" " %%edx, %%ecx\n"
  "2:"
  "\t" "lock ; " "addl" " %%ecx, (%%ebx)\n"
# 523 "pcm_dmix_i386.h"
  "3:"
  "\tmovl (%%ebx), %%ecx\n"

  "\tmovl $0x7fffff, %%eax\n"
  "\tmovl $-0x7fffff, %%edx\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tcmovng %%ecx, %%eax\n"
  "\tcmpl %%edx, %%ecx\n"
  "\tcmovl %%edx, %%eax\n"

  "\torl $1, %%eax\n"
  "\tmovw %%ax, (%%edi)\n"
  "\tshrl $16, %%eax\n"
  "\tmovb %%al, 2(%%edi)\n"

  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 3b\n"




  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"
  "\tdecl %0\n"
  "\tjnz 1b\n"

  "6:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 32 "pcm_dmix_i386.h"
static void remix_areas_16_smp(unsigned int size,
    volatile signed short *dst, signed short *src,
    volatile signed int *sum, size_t dst_step,
    size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 47 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjnz 2f\n"
  "\tjmp 7f\n"





  "\t.p2align 4,,15\n"
  "1:"
  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"
# 79 "pcm_dmix_i386.h"
  "2:"
  "\tmovw $0, %%ax\n"
  "\tmovw $1, %%cx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\t" "lock ; " "cmpxchgw %%cx, (%%edi)\n"
  "\tmovswl (%%esi), %%ecx\n"
  "\tjnz 3f\n"
  "\t" "addl" " %%edx, %%ecx\n"
  "3:"
  "\t" "lock ; " "subl" " %%ecx, (%%ebx)\n"
# 98 "pcm_dmix_i386.h"
  "4:"
  "\tmovl (%%ebx), %%ecx\n"
  "\tcmpl $0x7fff,%%ecx\n"
  "\tjg 5f\n"
  "\tcmpl $-0x8000,%%ecx\n"
  "\tjl 6f\n"
  "\tmovw %%cx, (%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 4b\n"




  "\tdecl %0\n"
  "\tjnz 1b\n"
  "\tjmp 7f\n"





  "\t.p2align 4,,15\n"

  "5:"
  "\tmovw $0x7fff, (%%edi)\n"
  "\tcmpl %%ecx,(%%ebx)\n"
  "\tjnz 4b\n"
  "\tdecl %0\n"
  "\tjnz 1b\n"
  "\tjmp 7f\n"





  "\t.p2align 4,,15\n"

  "6:"
  "\tmovw $-0x8000, (%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 4b\n"
  "\tdecl %0\n"
  "\tjnz 1b\n"

  "7:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 156 "pcm_dmix_i386.h"
static void remix_areas_16_smp_mmx(unsigned int size,
        volatile signed short *dst, signed short *src,
        volatile signed int *sum, size_t dst_step,
        size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 171 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjnz 2f\n"
  "\tjmp 5f\n"

  "\t.p2align 4,,15\n"
  "1:"
  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"

  "2:"







  "\tmovw $0, %%ax\n"
  "\tmovw $1, %%cx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\t" "lock ; " "cmpxchgw %%cx, (%%edi)\n"
  "\tmovswl (%%esi), %%ecx\n"
  "\tjnz 3f\n"
  "\t" "addl" " %%edx, %%ecx\n"
  "3:"
  "\t" "lock ; " "subl" " %%ecx, (%%ebx)\n"
# 217 "pcm_dmix_i386.h"
  "4:"
  "\tmovl (%%ebx), %%ecx\n"
  "\tmovd %%ecx, %%mm0\n"
  "\tpackssdw %%mm1, %%mm0\n"
  "\tmovd %%mm0, %%eax\n"
  "\tmovw %%ax, (%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 4b\n"




  "\tdecl %0\n"
  "\tjnz 1b\n"
  "\temms\n"
                "5:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 246 "pcm_dmix_i386.h"
static void remix_areas_32_smp(unsigned int size,
    volatile signed int *dst, signed int *src,
    volatile signed int *sum, size_t dst_step,
    size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 261 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjnz 1f\n"
  "\tjmp 6f\n"

  "\t.p2align 4,,15\n"

  "1:"
# 286 "pcm_dmix_i386.h"
  "\tmovl $0, %%eax\n"
  "\tmovl $1, %%ecx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\t" "lock ; " "cmpxchgl %%ecx, (%%edi)\n"
  "\tjnz 2f\n"
  "\tmovl (%%esi), %%ecx\n"

  "\tsarl $8, %%ecx\n"
  "\t" "addl" " %%edx, %%ecx\n"
  "\tjmp 21f\n"
  "2:"
  "\tmovl (%%esi), %%ecx\n"

  "\tsarl $8, %%ecx\n"
  "21:"
  "\t" "lock ; " "subl" " %%ecx, (%%ebx)\n"
# 311 "pcm_dmix_i386.h"
  "3:"
  "\tmovl (%%ebx), %%ecx\n"



  "\tmovl $0x7fffff, %%eax\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tjg 4f\n"



  "\tmovl $-0x800000, %%eax\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tjl 4f\n"
  "\tmovl %%ecx, %%eax\n"
  "4:"



  "\tsall $8, %%eax\n"
  "\tmovl %%eax, (%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 3b\n"




  "\tdecl %0\n"
  "\tjz 6f\n"
  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"
  "\tjmp 1b\n"

  "6:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 359 "pcm_dmix_i386.h"
static void remix_areas_24_smp(unsigned int size,
    volatile unsigned char *dst, unsigned char *src,
    volatile signed int *sum, size_t dst_step,
    size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 374 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjnz 1f\n"
  "\tjmp 6f\n"

  "\t.p2align 4,,15\n"

  "1:"
# 399 "pcm_dmix_i386.h"
  "\tmovsbl 2(%%esi), %%eax\n"
  "\tmovzwl (%%esi), %%ecx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\tsall $16, %%eax\n"
  "\torl %%eax, %%ecx\n"
  "\t" "lock ; " "btsw $0, (%%edi)\n"
  "\tjc 2f\n"
  "\t" "addl" " %%edx, %%ecx\n"
  "2:"
  "\t" "lock ; " "subl" " %%ecx, (%%ebx)\n"
# 418 "pcm_dmix_i386.h"
  "3:"
  "\tmovl (%%ebx), %%ecx\n"



  "\tmovl $0x7fffff, %%eax\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tjg 4f\n"



  "\tmovl $-0x7fffff, %%eax\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tjl 4f\n"
  "\tmovl %%ecx, %%eax\n"
  "\torl $1, %%eax\n"
  "4:"
  "\tmovw %%ax, (%%edi)\n"
  "\tshrl $16, %%eax\n"
  "\tmovb %%al, 2(%%edi)\n"
  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 3b\n"




  "\tdecl %0\n"
  "\tjz 6f\n"
  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"
  "\tjmp 1b\n"

  "6:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

# 465 "pcm_dmix_i386.h"
static void remix_areas_24_smp_cmov(unsigned int size,
         volatile unsigned char *dst, unsigned char *src,
         volatile signed int *sum, size_t dst_step,
         size_t src_step, size_t sum_step)
{
 unsigned int old_ebx;
# 480 "pcm_dmix_i386.h"
 __asm__ __volatile__ (
  "\n"

  "\tmovl %%ebx, %7\n"



  "\tmovl %1, %%edi\n"
  "\tmovl %2, %%esi\n"
  "\tmovl %3, %%ebx\n"
  "\tcmpl $0, %0\n"
  "\tjz 6f\n"

  "\t.p2align 4,,15\n"

  "1:"
# 504 "pcm_dmix_i386.h"
  "\tmovsbl 2(%%esi), %%eax\n"
  "\tmovzwl (%%esi), %%ecx\n"
  "\tmovl (%%ebx), %%edx\n"
  "\tsall $16, %%eax\n"
  "\t" "lock ; " "btsw $0, (%%edi)\n"
  "\tleal (%%ecx,%%eax,1), %%ecx\n"
  "\tjc 2f\n"
  "\t" "addl" " %%edx, %%ecx\n"
  "2:"
  "\t" "lock ; " "subl" " %%ecx, (%%ebx)\n"
# 523 "pcm_dmix_i386.h"
  "3:"
  "\tmovl (%%ebx), %%ecx\n"

  "\tmovl $0x7fffff, %%eax\n"
  "\tmovl $-0x7fffff, %%edx\n"
  "\tcmpl %%eax, %%ecx\n"
  "\tcmovng %%ecx, %%eax\n"
  "\tcmpl %%edx, %%ecx\n"
  "\tcmovl %%edx, %%eax\n"

  "\torl $1, %%eax\n"
  "\tmovw %%ax, (%%edi)\n"
  "\tshrl $16, %%eax\n"
  "\tmovb %%al, 2(%%edi)\n"

  "\tcmpl %%ecx, (%%ebx)\n"
  "\tjnz 3b\n"




  "\tadd %4, %%edi\n"
  "\tadd %5, %%esi\n"
  "\tadd %6, %%ebx\n"
  "\tdecl %0\n"
  "\tjnz 1b\n"

  "6:"
  "\tmovl %7, %%ebx\n"

  :
  : "m" (size), "m" (dst), "m" (src),
    "m" (sum), "m" (dst_step), "m" (src_step),
    "m" (sum_step), "m" (old_ebx)
  : "esi", "edi", "edx", "ecx", "eax"
 );
}

