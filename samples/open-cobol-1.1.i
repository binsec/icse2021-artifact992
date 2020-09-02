# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 78 "/usr/include/i386-linux-gnu/bits/string.h"
extern __inline void *
__memcpy_by4 (void *__dest, const void *__src, size_t __n)
{
  register unsigned long int __d0, __d1;
  register void *__tmp = __dest;
  __asm__ __volatile__
    ("1:\n\t"
     "movl	(%2),%0\n\t"
     "leal	4(%2),%2\n\t"
     "movl	%0,(%1)\n\t"
     "leal	4(%1),%1\n\t"
     "decl	%3\n\t"
     "jnz	1b"
     : "=&r" (__d0), "=&r" (__tmp), "=&r" (__src), "=&r" (__d1)
     : "1" (__tmp), "2" (__src), "3" (__n / 4)
     : "memory", "cc");
  return __dest;
}

# 100 "/usr/include/i386-linux-gnu/bits/string.h"
extern __inline void *
__memcpy_by2 (void *__dest, const void *__src, size_t __n)
{
  register unsigned long int __d0, __d1;
  register void *__tmp = __dest;
  __asm__ __volatile__
    ("shrl	$1,%3\n\t"
     "jz	2f\n" /* only a word */
     "1:\n\t"
     "movl	(%2),%0\n\t"
     "leal	4(%2),%2\n\t"
     "movl	%0,(%1)\n\t"
     "leal	4(%1),%1\n\t"
     "decl	%3\n\t"
     "jnz	1b\n"
     "2:\n\t"
     "movw	(%2),%w0\n\t"
     "movw	%w0,(%1)"
     : "=&q" (__d0), "=&r" (__tmp), "=&r" (__src), "=&r" (__d1)
     : "1" (__tmp), "2" (__src), "3" (__n / 2)
     : "memory", "cc");
  return __dest;
}

# 942 "/usr/include/i386-linux-gnu/bits/string.h"
extern __inline char *
__strncpy_gg (char *__dest, const char *__src, size_t __n)
{
  register char *__tmp = __dest;
  register char __dummy;
  if (__n > 0)
    __asm__ __volatile__
      ("1:\n\t"
       "movb	(%0),%2\n\t"
       "incl	%0\n\t"
       "movb	%2,(%1)\n\t"
       "incl	%1\n\t"
       "decl	%3\n\t"
       "je	3f\n\t"
       "testb	%2,%2\n\t"
       "jne	1b\n\t"
       "2:\n\t"
       "movb	%2,(%1)\n\t"
       "incl	%1\n\t"
       "decl	%3\n\t"
       "jne	2b\n\t"
       "3:"
       : "=&r" (__src), "=&r" (__tmp), "=&q" (__dummy), "=&r" (__n)
       : "0" (__src), "1" (__tmp), "3" (__n)
       : "memory", "cc");

  return __dest;
}

# 1056 "/usr/include/i386-linux-gnu/bits/string.h"
extern __inline char *
__strncat_g (char *__dest, const char __src[], size_t __n)
{
  register char *__tmp = __dest;
  register char __dummy;

  __asm__ __volatile__
    ("repne; scasb\n"
     "movl %4, %3\n\t"
     "decl %1\n\t"
     "1:\n\t"
     "subl	$1,%3\n\t"
     "jc	2f\n\t"
     "movb	(%2),%b0\n\t"
     "movsb\n\t"
     "testb	%b0,%b0\n\t"
     "jne	1b\n\t"
     "decl	%1\n"
     "2:\n\t"
     "movb	$0,(%1)"
     : "=&a" (__dummy), "=&D" (__tmp), "=&S" (__src), "=&c" (__n)
     : "g" (__n), "0" (0), "1" (__tmp), "2" (__src), "3" (0xffffffff)
     : "memory", "cc");
# 1102 "/usr/include/i386-linux-gnu/bits/string.h" 3 4
  return __dest;
}

# 1540 "/usr/include/i386-linux-gnu/bits/string.h"
extern __inline size_t
__strcspn_cg (const char *__s, const char __reject[], size_t __reject_len)
{
  register unsigned long int __d0, __d1, __d2;
  register const char *__res;
  __asm__ __volatile__
    ("cld\n"
     "1:\n\t"
     "lodsb\n\t"
     "testb	%%al,%%al\n\t"
     "je	2f\n\t"
     "movl	%5,%%edi\n\t"
     "movl	%6,%%ecx\n\t"
     "repne; scasb\n\t"
     "jne	1b\n"
     "2:"
     : "=S" (__res), "=&a" (__d0), "=&c" (__d1), "=&D" (__d2)
     : "0" (__s), "d" (__reject), "g" (__reject_len)
     : "memory", "cc");
  return (__res - 1) - __s;
}

# 1565 "/usr/include/i386-linux-gnu/bits/string.h"
extern __inline size_t
__strcspn_g (const char *__s, const char *__reject)
{
  register unsigned long int __d0, __d1, __d2;
  register const char *__res;
  __asm__ __volatile__
    ("pushl	%%ebx\n\t"
     "movl	%4,%%edi\n\t"
     "cld\n\t"
     "repne; scasb\n\t"
     "notl	%%ecx\n\t"
     "leal	-1(%%ecx),%%ebx\n"
     "1:\n\t"
     "lodsb\n\t"
     "testb	%%al,%%al\n\t"
     "je	2f\n\t"
     "movl	%4,%%edi\n\t"
     "movl	%%ebx,%%ecx\n\t"
     "repne; scasb\n\t"
     "jne	1b\n"
     "2:\n\t"
     "popl	%%ebx"
     : "=S" (__res), "=&a" (__d0), "=&c" (__d1), "=&D" (__d2)
     : "r" (__reject), "0" (__s), "1" (0), "2" (0xffffffff)
     : "memory", "cc");
  return (__res - 1) - __s;
}

# 1688 "/usr/include/i386-linux-gnu/bits/string.h"
extern __inline size_t
__strspn_g (const char *__s, const char *__accept)
{
  register unsigned long int __d0, __d1, __d2;
  register const char *__res;
  __asm__ __volatile__
    ("pushl	%%ebx\n\t"
     "cld\n\t"
     "repne; scasb\n\t"
     "notl	%%ecx\n\t"
     "leal	-1(%%ecx),%%ebx\n"
     "1:\n\t"
     "lodsb\n\t"
     "testb	%%al,%%al\n\t"
     "je	2f\n\t"
     "movl	%%edx,%%edi\n\t"
     "movl	%%ebx,%%ecx\n\t"
     "repne; scasb\n\t"
     "je	1b\n"
     "2:\n\t"
     "popl	%%ebx"
     : "=S" (__res), "=&a" (__d0), "=&c" (__d1), "=&D" (__d2)
     : "d" (__accept), "0" (__s), "1" (0), "2" (0xffffffff), "3" (__accept)
     : "memory", "cc");
  return (__res - 1) - __s;
}

# 1756 "/usr/include/i386-linux-gnu/bits/string.h"
extern __inline char *
__strpbrk_cg (const char *__s, const char __accept[], size_t __accept_len)
{
  register unsigned long int __d0, __d1, __d2;
  register char *__res;
  __asm__ __volatile__
    ("cld\n"
     "1:\n\t"
     "lodsb\n\t"
     "testb	%%al,%%al\n\t"
     "je	2f\n\t"
     "movl	%5,%%edi\n\t"
     "movl	%6,%%ecx\n\t"
     "repne; scasb\n\t"
     "jne	1b\n\t"
     "decl	%0\n\t"
     "jmp	3f\n"
     "2:\n\t"
     "xorl	%0,%0\n"
     "3:"
     : "=S" (__res), "=&a" (__d0), "=&c" (__d1), "=&D" (__d2)
     : "0" (__s), "d" (__accept), "g" (__accept_len)
     : "memory", "cc");
  return __res;
}

# 1785 "/usr/include/i386-linux-gnu/bits/string.h"
extern __inline char *
__strpbrk_g (const char *__s, const char *__accept)
{
  register unsigned long int __d0, __d1, __d2;
  register char *__res;
  __asm__ __volatile__
    ("pushl	%%ebx\n\t"
     "movl	%%edx,%%edi\n\t"
     "cld\n\t"
     "repne; scasb\n\t"
     "notl	%%ecx\n\t"
     "leal	-1(%%ecx),%%ebx\n"
     "1:\n\t"
     "lodsb\n\t"
     "testb	%%al,%%al\n\t"
     "je	2f\n\t"
     "movl	%%edx,%%edi\n\t"
     "movl	%%ebx,%%ecx\n\t"
     "repne; scasb\n\t"
     "jne	1b\n\t"
     "decl	%0\n\t"
     "jmp	3f\n"
     "2:\n\t"
     "xorl	%0,%0\n"
     "3:\n\t"
     "popl	%%ebx"
     : "=S" (__res), "=&a" (__d0), "=&c" (__d1), "=&D" (__d2)
     : "d" (__accept), "0" (__s), "1" (0), "2" (0xffffffff)
     : "memory", "cc");
  return __res;
}

# 1867 "/usr/include/i386-linux-gnu/bits/string.h"
extern __inline char *
__strstr_cg (const char *__haystack, const char __needle[],
      size_t __needle_len)
{
  register unsigned long int __d0, __d1, __d2;
  register char *__res;
  __asm__ __volatile__
    ("cld\n"
     "1:\n\t"
     "movl	%6,%%edi\n\t"
     "movl	%5,%%eax\n\t"
     "movl	%4,%%ecx\n\t"
     "repe; cmpsb\n\t"
     "je	2f\n\t"
     "cmpb	$0,-1(%%esi)\n\t"
     "leal	1(%%eax),%5\n\t"
     "jne	1b\n\t"
     "xorl	%%eax,%%eax\n"
     "2:"
     : "=&a" (__res), "=&S" (__d0), "=&D" (__d1), "=&c" (__d2)
     : "g" (__needle_len), "1" (__haystack), "d" (__needle)
     : "memory", "cc");
  return __res;
}

# 1896 "/usr/include/i386-linux-gnu/bits/string.h"
extern __inline char *
__strstr_g (const char *__haystack, const char *__needle)
{
  register unsigned long int __d0, __d1, __d2;
  register char *__res;
  __asm__ __volatile__
    ("cld\n\t"
     "repne; scasb\n\t"
     "notl	%%ecx\n\t"
     "pushl	%%ebx\n\t"
     "decl	%%ecx\n\t" /* NOTE! This also sets Z if searchstring='' */
     "movl	%%ecx,%%ebx\n"
     "1:\n\t"
     "movl	%%edx,%%edi\n\t"
     "movl	%%esi,%%eax\n\t"
     "movl	%%ebx,%%ecx\n\t"
     "repe; cmpsb\n\t"
     "je	2f\n\t" /* also works for empty string, see above */
     "cmpb	$0,-1(%%esi)\n\t"
     "leal	1(%%eax),%%esi\n\t"
     "jne	1b\n\t"
     "xorl	%%eax,%%eax\n"
     "2:\n\t"
     "popl	%%ebx"
     : "=&a" (__res), "=&c" (__d0), "=&S" (__d1), "=&D" (__d2)
     : "0" (0), "1" (0xffffffff), "2" (__haystack), "3" (__needle),
       "d" (__needle)
     : "memory", "cc");
  return __res;
}

# 155 "common.h"
typedef struct {
 unsigned char type;
 unsigned char digits;
 signed char scale;
 unsigned char flags;
 const char *pic;
} cob_field_attr;

# 165 "common.h"
typedef struct {
 size_t size;
 unsigned char *data;
 const cob_field_attr *attr;
} cob_field;

# 1570 "codegen.h"
int
cob_cmpswp_u16_binary (const unsigned char *p, const int n)
{



 unsigned short val;

 if (n < 0) {
  return 1;
 }

 val = ((__extension__ ({ register unsigned short int __v, __x = ((unsigned short) (*(unsigned short *)p)); if (__builtin_constant_p (__x)) __v = ((unsigned short) ( (unsigned short) ((unsigned short) (__x) >> 8) | (unsigned short) ((unsigned short) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));






 return (val < n) ? -1 : (val > n);
}

# 1592 "codegen.h"
int
cob_cmpswp_s16_binary (const unsigned char *p, const int n)
{
 short val;


 val = ((__extension__ ({ register unsigned short int __v, __x = ((unsigned short) (*(short *)p)); if (__builtin_constant_p (__x)) __v = ((unsigned short) ( (unsigned short) ((unsigned short) (__x) >> 8) | (unsigned short) ((unsigned short) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
# 1607 "codegen.h"
 return (val < n) ? -1 : (val > n);
}

# 1610 "codegen.h"
int
cob_cmpswp_u24_binary (const unsigned char *p, const int n)
{
 unsigned char *x;
 unsigned int val = 0;

 if (n < 0) {
  return 1;
 }
 x = ((unsigned char *)&val) + 1;
 *x = *p;
 *(x + 1) = *(p + 1);
 *(x + 2) = *(p + 2);
 val = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (val)); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; })));
 return (val < n) ? -1 : (val > n);
}

# 1627 "codegen.h"
int
cob_cmpswp_s24_binary (const unsigned char *p, const int n)
{
 unsigned char *x;
 int val = 0;

 x = (unsigned char *)&val;
 *x = *p;
 *(x + 1) = *(p + 1);
 *(x + 2) = *(p + 2);
 val = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (val)); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; })));
 val >>= 8; /* shift with sign */
 return (val < n) ? -1 : (val > n);
}

# 1642 "codegen.h"
int
cob_cmpswp_u32_binary (const unsigned char *p, const int n)
{



 unsigned int val;

 if (n < 0) {
  return 1;
 }

 val = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (*(const unsigned int *)p)); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; })));
# 1663 "codegen.h"
 return (val < n) ? -1 : (val > n);
}

# 1666 "codegen.h"
int
cob_cmpswp_s32_binary (const unsigned char *p, const int n)
{
 int val;


 val = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (*(const int *)p)); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; })));
# 1683 "codegen.h"
 return (val < n) ? -1 : (val > n);
}

# 1686 "codegen.h"
int
cob_cmpswp_u40_binary (const unsigned char *p, const int n)
{
 unsigned long long val = 0;
 unsigned char *x;

 if (n < 0) {
  return 1;
 }
 x = ((unsigned char *)&val) + 3;
 *x = *p;
 *(x + 1) = *(p + 1);
 *(x + 2) = *(p + 2);
 *(x + 3) = *(p + 3);
 *(x + 4) = *(p + 4);
 val = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (val)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
 return (val < n) ? -1 : (val > n);
}

# 1705 "codegen.h"
int
cob_cmpswp_s40_binary (const unsigned char *p, const int n)
{
 long long val = 0;
 unsigned char *x;

 x = (unsigned char *)&val;
 *x = *p;
 *(x + 1) = *(p + 1);
 *(x + 2) = *(p + 2);
 *(x + 3) = *(p + 3);
 *(x + 4) = *(p + 4);
 val = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (val)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
 val >>= 24; /* shift with sign */
 return (val < n) ? -1 : (val > n);
}

# 1722 "codegen.h"
int
cob_cmpswp_u48_binary (const unsigned char *p, const int n)
{
 unsigned long long val = 0;
 unsigned char *x;

 if (n < 0) {
  return 1;
 }
 x = ((unsigned char *)&val) + 2;
 *x = *p;
 *(x + 1) = *(p + 1);
 *(x + 2) = *(p + 2);
 *(x + 3) = *(p + 3);
 *(x + 4) = *(p + 4);
 *(x + 5) = *(p + 5);
 val = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (val)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
 return (val < n) ? -1 : (val > n);
}

# 1742 "codegen.h"
int
cob_cmpswp_s48_binary (const unsigned char *p, const int n)
{
 long long val = 0;
 unsigned char *x;

 x = (unsigned char *)&val;
 *x = *p;
 *(x + 1) = *(p + 1);
 *(x + 2) = *(p + 2);
 *(x + 3) = *(p + 3);
 *(x + 4) = *(p + 4);
 *(x + 5) = *(p + 5);
 val = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (val)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
 val >>= 16; /* shift with sign */
 return (val < n) ? -1 : (val > n);
}

# 1760 "codegen.h"
int
cob_cmpswp_u56_binary (const unsigned char *p, const int n)
{
 unsigned long long val = 0;
 unsigned char *x;

 if (n < 0) {
  return 1;
 }
 x = ((unsigned char *)&val) + 1;
 *x = *p;
 *(x + 1) = *(p + 1);
 *(x + 2) = *(p + 2);
 *(x + 3) = *(p + 3);
 *(x + 4) = *(p + 4);
 *(x + 5) = *(p + 5);
 *(x + 6) = *(p + 6);
 val = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (val)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
 return (val < n) ? -1 : (val > n);
}

# 1781 "codegen.h"
int
cob_cmpswp_s56_binary (const unsigned char *p, const int n)
{
 long long val = 0;
 unsigned char *x;

 x = (unsigned char *)&val;
 *x = *p;
 *(x + 1) = *(p + 1);
 *(x + 2) = *(p + 2);
 *(x + 3) = *(p + 3);
 *(x + 4) = *(p + 4);
 *(x + 5) = *(p + 5);
 *(x + 6) = *(p + 6);
 val = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (val)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
 val >>= 8; /* shift with sign */
 return (val < n) ? -1 : (val > n);
}

# 1800 "codegen.h"
int
cob_cmpswp_u64_binary (const unsigned char *p, const int n)
{



 unsigned long long val;

 if (n < 0) {
  return 1;
 }

 val = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (*(const unsigned long long *)p)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
# 1825 "codegen.h"
 return (val < n) ? -1 : (val > n);
}

# 1828 "codegen.h"
int
cob_cmpswp_s64_binary (const unsigned char *p, const int n)
{
 long long val;


 val = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (*(const long long *)p)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
# 1848 "codegen.h"
 return (val < n) ? -1 : (val > n);
}

# 1852 "codegen.h"
void
cob_addswp_u16_binary (unsigned char *p, const int val)
{
 unsigned short n;


 n = ((__extension__ ({ register unsigned short int __v, __x = ((unsigned short) (*(unsigned short *)p)); if (__builtin_constant_p (__x)) __v = ((unsigned short) ( (unsigned short) ((unsigned short) (__x) >> 8) | (unsigned short) ((unsigned short) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
 n += val;
 *(unsigned short *)p = ((__extension__ ({ register unsigned short int __v, __x = ((unsigned short) (n)); if (__builtin_constant_p (__x)) __v = ((unsigned short) ( (unsigned short) ((unsigned short) (__x) >> 8) | (unsigned short) ((unsigned short) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));






}

# 1869 "codegen.h"
void
cob_addswp_s16_binary (unsigned char *p, const int val)
{
 short n;


 n = ((__extension__ ({ register unsigned short int __v, __x = ((unsigned short) (*(short *)p)); if (__builtin_constant_p (__x)) __v = ((unsigned short) ( (unsigned short) ((unsigned short) (__x) >> 8) | (unsigned short) ((unsigned short) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
 n += val;
 *(short *)p = ((__extension__ ({ register unsigned short int __v, __x = ((unsigned short) (n)); if (__builtin_constant_p (__x)) __v = ((unsigned short) ( (unsigned short) ((unsigned short) (__x) >> 8) | (unsigned short) ((unsigned short) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));






}

# 1920 "codegen.h"
void
cob_addswp_u32_binary (unsigned char *p, const int val)
{
 unsigned int n;


 n = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (*(unsigned int *)p)); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; })));
 n += val;
 *(unsigned int *)p = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (n)); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; })));
# 1937 "codegen.h"
}

# 1939 "codegen.h"
void
cob_addswp_s32_binary (unsigned char *p, const int val)
{
 int n;


 n = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (*(int *)p)); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; })));
 n += val;
 *(int *)p = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (n)); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; })));
# 1956 "codegen.h"
}

# 2096 "codegen.h"
void
cob_addswp_u64_binary (unsigned char *p, const int val)
{

 unsigned long long n;

 n = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (*(unsigned long long *)p)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
 n += val;
 *(unsigned long long *)p = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (n)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
# 2120 "codegen.h"
}

# 2122 "codegen.h"
void
cob_addswp_s64_binary (unsigned char *p, const int val)
{

 long long n;

 n = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (*(long long *)p)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
 n += val;
 *(long long *)p = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (n)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
# 2146 "codegen.h"
}

# 2149 "codegen.h"
void
cob_subswp_u16_binary (unsigned char *p, const int val)
{
 unsigned short n;


 n = ((__extension__ ({ register unsigned short int __v, __x = ((unsigned short) (*(unsigned short *)p)); if (__builtin_constant_p (__x)) __v = ((unsigned short) ( (unsigned short) ((unsigned short) (__x) >> 8) | (unsigned short) ((unsigned short) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
 n -= val;
 *(unsigned short *)p = ((__extension__ ({ register unsigned short int __v, __x = ((unsigned short) (n)); if (__builtin_constant_p (__x)) __v = ((unsigned short) ( (unsigned short) ((unsigned short) (__x) >> 8) | (unsigned short) ((unsigned short) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));






}

# 2166 "codegen.h"
void
cob_subswp_s16_binary (unsigned char *p, const int val)
{
 short n;


 n = ((__extension__ ({ register unsigned short int __v, __x = ((unsigned short) (*(short *)p)); if (__builtin_constant_p (__x)) __v = ((unsigned short) ( (unsigned short) ((unsigned short) (__x) >> 8) | (unsigned short) ((unsigned short) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
 n -= val;
 *(short *)p = ((__extension__ ({ register unsigned short int __v, __x = ((unsigned short) (n)); if (__builtin_constant_p (__x)) __v = ((unsigned short) ( (unsigned short) ((unsigned short) (__x) >> 8) | (unsigned short) ((unsigned short) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));






}

# 2217 "codegen.h"
void
cob_subswp_u32_binary (unsigned char *p, const int val)
{
 unsigned int n;


 n = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (*(unsigned int *)p)); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; })));
 n -= val;
 *(unsigned int *)p = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (n)); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; })));
# 2234 "codegen.h"
}

# 2236 "codegen.h"
void
cob_subswp_s32_binary (unsigned char *p, const int val)
{
 int n;


 n = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (*(int *)p)); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; })));
 n -= val;
 *(int *)p = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (n)); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; })));
# 2253 "codegen.h"
}

# 2393 "codegen.h"
void
cob_subswp_u64_binary (unsigned char *p, const int val)
{

 unsigned long long n;

 n = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (*(unsigned long long *)p)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
 n -= val;
 *(unsigned long long *)p = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (n)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
# 2417 "codegen.h"
}

# 2419 "codegen.h"
void
cob_subswp_s64_binary (unsigned char *p, const int val)
{

 long long n;

 n = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (*(long long *)p)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
 n -= val;
 *(long long *)p = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (n)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
# 2443 "codegen.h"
}

# 2445 "codegen.h"
void
cob_setswp_u16_binary (unsigned char *p, const int val)
{
 unsigned short n;


 n = val;
 *(unsigned short *)p = ((__extension__ ({ register unsigned short int __v, __x = ((unsigned short) (n)); if (__builtin_constant_p (__x)) __v = ((unsigned short) ( (unsigned short) ((unsigned short) (__x) >> 8) | (unsigned short) ((unsigned short) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));





}

# 2460 "codegen.h"
void
cob_setswp_s16_binary (unsigned char *p, const int val)
{
 short n;


 n = val;
 *(short *)p = ((__extension__ ({ register unsigned short int __v, __x = ((unsigned short) (n)); if (__builtin_constant_p (__x)) __v = ((unsigned short) ( (unsigned short) ((unsigned short) (__x) >> 8) | (unsigned short) ((unsigned short) (__x) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));





}

# 2501 "codegen.h"
void
cob_setswp_u32_binary (unsigned char *p, const int val)
{
 unsigned int n;


 n = val;
 *(unsigned int *)p = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (n)); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; })));







}

# 2518 "codegen.h"
void
cob_setswp_s32_binary (unsigned char *p, const int val)
{
 int n;


 n = val;
 *(int *)p = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (n)); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; })));







}

# 2631 "codegen.h"
void
cob_setswp_u64_binary (unsigned char *p, const int val)
{

 unsigned long long n;

 n = val;
 *(unsigned long long *)p = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (n)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
# 2651 "codegen.h"
}

# 2653 "codegen.h"
void
cob_setswp_s64_binary (unsigned char *p, const int val)
{

 long long n;

 n = val;
 *(long long *)p = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (n)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
# 2673 "codegen.h"
}

# 156 "numeric.c"
static inline void
num_byte_memcpy (unsigned char *s1, const unsigned char *s2, size_t size)
{
 do {
  *s1++ = *s2++;
 } while (--size);
}

# 164 "numeric.c"
static long long
cob_binary_get_int64 (const cob_field * const f)
{
 long long n = 0;
 size_t fsiz = 8 - f->size;

/* Experimental code - not activated */
# 189 "numeric.c"
 if (((f)->attr->flags & 0x20)) {
  if (((f)->attr->flags & 0x01)) {
   num_byte_memcpy ((unsigned char *)&n, f->data, f->size);
   n = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (n)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
   n >>= 8 * fsiz; /* shift with sign */
  } else {
   num_byte_memcpy (((unsigned char *)&n) + fsiz, f->data, f->size);
   n = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (n)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
  }
 } else {
  if (((f)->attr->flags & 0x01)) {
   num_byte_memcpy (((unsigned char *)&n) + fsiz, f->data, f->size);
   n >>= 8 * fsiz; /* shift with sign */
  } else {
   num_byte_memcpy ((unsigned char *)&n, f->data, f->size);
  }
 }
# 214 "numeric.c"
 return n;
}

# 217 "numeric.c"
static unsigned long long
cob_binary_get_uint64 (const cob_field * const f)
{
 unsigned long long n = 0;
 size_t fsiz = 8 - f->size;


 if (((f)->attr->flags & 0x20)) {
  num_byte_memcpy (((unsigned char *)&n) + fsiz, f->data, f->size);
  n = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (n)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
 } else {
  num_byte_memcpy ((unsigned char *)&n, f->data, f->size);
 }



 return n;
}

# 236 "numeric.c"
static void
cob_binary_set_uint64 (cob_field *f, unsigned long long n)
{

 unsigned char *s;

 if (((f)->attr->flags & 0x20)) {
  n = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (n)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
  s = ((unsigned char *)&n) + 8 - f->size;
 } else {
  s = (unsigned char *)&n;
 }
 num_byte_memcpy (f->data, s, f->size);



}

# 254 "numeric.c"
static void
cob_binary_set_int64 (cob_field *f, long long n)
{

 unsigned char *s;

 if (((f)->attr->flags & 0x20)) {
  n = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (n)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
  s = ((unsigned char *)&n) + 8 - f->size;
 } else {
  s = (unsigned char *)&n;
 }
 num_byte_memcpy (f->data, s, f->size);



}

# 89 "move.c"
static inline void
own_byte_memcpy (unsigned char *s1, const unsigned char *s2, size_t size)
{
 do {
  *s1++ = *s2++;
 } while (--size);
}

# 129 "move.c"
static long long
cob_binary_mget_int64 (const cob_field * const f)
{
 long long n = 0;
 size_t fsiz = 8 - f->size;

/* Experimental code - not activated */
# 154 "move.c"
 if (((f)->attr->flags & 0x20)) {
  if (((f)->attr->flags & 0x01)) {
   own_byte_memcpy ((unsigned char *)&n, f->data, f->size);
   n = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (n)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
   n >>= 8 * fsiz; /* shift with sign */
  } else {
   own_byte_memcpy (((unsigned char *)&n) + fsiz, f->data, f->size);
   n = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (n)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
  }
 } else {
  if (((f)->attr->flags & 0x01)) {
   own_byte_memcpy (((unsigned char *)&n) + fsiz, f->data, f->size);
   n >>= 8 * fsiz; /* shift with sign */
  } else {
   own_byte_memcpy ((unsigned char *)&n, f->data, f->size);
  }
 }
# 179 "move.c"
 return n;
}

# 182 "move.c"
static void
cob_binary_mset_int64 (cob_field *f, long long n)
{

 unsigned char *s;

 if (((f)->attr->flags & 0x20)) {
  n = ((__extension__ ({ union { unsigned long long __ll; unsigned int __l[2]; } __w, __r; __w.__ll = ((unsigned long long) (n)); if (__builtin_constant_p (__w.__ll)) __r.__ll = ((unsigned long long) ( (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000000000ffULL) << 56) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000000000ff00ULL) << 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000000000ff0000ULL) << 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00000000ff000000ULL) << 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x000000ff00000000ULL) >> 8) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x0000ff0000000000ULL) >> 24) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0x00ff000000000000ULL) >> 40) | (((unsigned long long) (__w.__ll) & (unsigned long long) 0xff00000000000000ULL) >> 56))); else { __r.__l[0] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[1])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); __r.__l[1] = ((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (__w.__l[0])); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; }))); } __r.__ll; })));
  s = ((unsigned char *)&n) + 8 - f->size;
 } else {
  s = (unsigned char *)&n;
 }
 own_byte_memcpy (f->data, s, f->size);



}

# 66 "/usr/include/string.h"
extern void *memset (void *__s, int __c, size_t __n);

# 201 "/vagrant/allpkg/open-cobol-1.1/tests/../libcob/common.h"
struct cob_module {
 struct cob_module *next;
 const unsigned char *collating_sequence;
 cob_field *crt_status;
 cob_field *cursor_pos;
 cob_field **cob_procedure_parameters;
 const unsigned char display_sign;
 const unsigned char decimal_point;
 const unsigned char currency_symbol;
 const unsigned char numeric_separator;
 const unsigned char flag_filename_mapping;
 const unsigned char flag_binary_truncate;
 const unsigned char flag_pretty_display;
 const unsigned char spare8;
};

# 246 "/vagrant/allpkg/open-cobol-1.1/tests/../libcob/common.h"
extern int cob_initialized;

# 249 "/vagrant/allpkg/open-cobol-1.1/tests/../libcob/common.h"
extern struct cob_module *cob_current_module;

# 251 "/vagrant/allpkg/open-cobol-1.1/tests/../libcob/common.h"
extern int cob_call_params;

# 252 "/vagrant/allpkg/open-cobol-1.1/tests/../libcob/common.h"
extern int cob_save_call_params;

# 281 "/vagrant/allpkg/open-cobol-1.1/tests/../libcob/common.h"
extern void cob_stop_run (const int);

# 282 "/vagrant/allpkg/open-cobol-1.1/tests/../libcob/common.h"
extern void cob_fatal_error (const unsigned int);

# 297 "/vagrant/allpkg/open-cobol-1.1/tests/../libcob/common.h"
extern void cob_check_version (const char *, const char *, const int);

# 354 "/vagrant/allpkg/open-cobol-1.1/tests/../libcob/common.h"
extern void cob_set_location (const char *, const char *,
       const unsigned int, const char *,
       const char *, const char *);

# 36 "/vagrant/allpkg/open-cobol-1.1/tests/../libcob/call.h"
extern void *cob_resolve_1 (const char *);

# 9 "/tmp/cob16411_0.c.h"
struct cob_frame {
 int perform_through;
 void *return_address;
};

# 15 "/tmp/cob16411_0.c.h"
union cob_call_union {
 void *(*funcptr)();
 int (*funcint)();
 void *func_void;
};

# 26 "/tmp/cob16411_0.c.h"
static unsigned char b_1[4];

# 27 "/tmp/cob16411_0.c.h"
static unsigned char b_5[4];

# 28 "/tmp/cob16411_0.c.h"
static unsigned char b_6[20];

# 29 "/tmp/cob16411_0.c.h"
static unsigned char b_9[4];

# 36 "/tmp/cob16411_0.c.h"
static const cob_field_attr a_1 = {16, 1, 0, 0, ((void *)0)};

# 37 "/tmp/cob16411_0.c.h"
static const cob_field_attr a_2 = {17, 9, 0, 1, ((void *)0)};

# 42 "/tmp/cob16411_0.c.h"
static cob_field f_9 = {4, b_9, &a_2};

# 47 "/tmp/cob16411_0.c.h"
static cob_field c_1 = {1, (unsigned char *)"1", &a_1};

# 48 "/tmp/cob16411_0.c.h"
static cob_field c_2 = {1, (unsigned char *)"4", &a_1};

# 43 "/tmp/cob16411_0.c"
static int
prog_ (const int entry)
{
  /* Local variables */
# 1 "/tmp/cob16411_0.c.l.h" 1
/* Generated by            cobc 1.1.0 */
/* Generated from          prog.cob */
/* Generated at            Jul 17 2018 02:07:34 PDT */
/* OpenCOBOL build date    Jul 17 2018 02:06:15 */
/* OpenCOBOL package date  Feb 06 2009 10:30:55 CET */
/* Compile command         /vagrant/allpkg/open-cobol-1.1/tests/.././cobc/cobc -x -std=cobol2002 -debug -Wall -o prog prog.cob */


/* Define perform frame stack */

struct cob_frame *frame_overflow;
struct cob_frame *frame_ptr;
struct cob_frame frame_stack[255];


/* Call pointers */
static union cob_call_union call_dump = { ((void *)0) };
# 48 "/tmp/cob16411_0.c" 2

  static int initialized = 0;
  static cob_field *cob_user_parameters[64];
  static struct cob_module module = { ((void *)0), ((void *)0), ((void *)0), ((void *)0), cob_user_parameters, 0, '.', '$', ',', 1, 1, 1, 0 };

  /* Start of function code */

  /* CANCEL callback handling */
  if (__builtin_expect(!!(entry < 0), 0)) {
   if (!initialized) {
    return 0;
   }
   initialized = 0;
   return 0;
  }

  /* Initialize frame stack */
  frame_ptr = &frame_stack[0];
  frame_ptr->perform_through = 0;
  frame_overflow = &frame_stack[255 - 1];

  /* Push module stack */
  module.next = cob_current_module;
  cob_current_module = &module;

  /* Initialize program */
  if (__builtin_expect(!!(initialized == 0), 0))
    {
      if (!cob_initialized) {
        cob_fatal_error (0);
      }
      cob_check_version ("prog.cob", "1.1", 0);
      (*(int *) (b_1)) = 0;
      memset (b_5, 0, 4);
      memset (b_6, 32, 20);
      memset (b_9, 0, 4);
      initialized = 1;
    }

  cob_save_call_params = cob_call_params;

  /* Entry dispatch */
  goto l_2;

  /* PROCEDURE DIVISION */

  /* Entry prog */

  l_2:;

  /* MAIN SECTION */

  /* MAIN PARAGRAPH */

  /* prog.cob:11: MOVE */
  cob_set_location ("prog", "prog.cob", 11, "MAIN SECTION", "MAIN PARAGRAPH", "MOVE");
  {
    cob_setswp_u32_binary (b_5, 9);
  }
  /* prog.cob:12: CALL */
  cob_set_location ("prog", "prog.cob", 12, "MAIN SECTION", "MAIN PARAGRAPH", "CALL");
  {
    {
      union {
 unsigned char data[8];
       long long datall;
       int dataint;
      } content_1;

      content_1.dataint = 1;
      module.cob_procedure_parameters[0] = &c_1;
      module.cob_procedure_parameters[1] = ((void *)0);
      module.cob_procedure_parameters[2] = ((void *)0);
      module.cob_procedure_parameters[3] = ((void *)0);
      module.cob_procedure_parameters[4] = ((void *)0);
      cob_call_params = 1;
      if (__builtin_expect(!!(call_dump.func_void == ((void *)0)), 0)) {
        call_dump.func_void = cob_resolve_1 ((const char *)"dump");
      }
      (*(int *) (b_1)) = call_dump.funcint (content_1.data);
    }
  }
  /* prog.cob:14: CALL */
  cob_set_location ("prog", "prog.cob", 14, "MAIN SECTION", "MAIN PARAGRAPH", "CALL");
  {
    (*(int *) (b_9)) = (1 * ((unsigned int)((__extension__ ({ register unsigned int __v, __x = ((unsigned int) (*(int *)(b_5))); if (__builtin_constant_p (__x)) __v = ((unsigned int) ( (((unsigned int) (__x) & (unsigned int) 0x000000ffU) << 24) | (((unsigned int) (__x) & (unsigned int) 0x0000ff00U) << 8) | (((unsigned int) (__x) & (unsigned int) 0x00ff0000U) >> 8) | (((unsigned int) (__x) & (unsigned int) 0xff000000U) >> 24))); else __asm__ ("bswap %0" : "=r" (__v) : "0" (__x)); __v; })))));
    {
      union {
 unsigned char data[4];
       long long datall;
       int dataint;
      } content_1;

      content_1.dataint = (*(int *) (b_9));
      module.cob_procedure_parameters[0] = &f_9;
      module.cob_procedure_parameters[1] = ((void *)0);
      module.cob_procedure_parameters[2] = ((void *)0);
      module.cob_procedure_parameters[3] = ((void *)0);
      module.cob_procedure_parameters[4] = ((void *)0);
      cob_call_params = 1;
      if (__builtin_expect(!!(call_dump.func_void == ((void *)0)), 0)) {
        call_dump.func_void = cob_resolve_1 ((const char *)"dump");
      }
      (*(int *) (b_1)) = call_dump.funcint (content_1.data);
    }
  }
  /* prog.cob:16: CALL */
  cob_set_location ("prog", "prog.cob", 16, "MAIN SECTION", "MAIN PARAGRAPH", "CALL");
  {
    {
      union {
 unsigned char data[8];
       long long datall;
       int dataint;
      } content_1;

      content_1.dataint = 4;
      module.cob_procedure_parameters[0] = &c_2;
      module.cob_procedure_parameters[1] = ((void *)0);
      module.cob_procedure_parameters[2] = ((void *)0);
      module.cob_procedure_parameters[3] = ((void *)0);
      module.cob_procedure_parameters[4] = ((void *)0);
      cob_call_params = 1;
      if (__builtin_expect(!!(call_dump.func_void == ((void *)0)), 0)) {
        call_dump.func_void = cob_resolve_1 ((const char *)"dump");
      }
      (*(int *) (b_1)) = call_dump.funcint (content_1.data);
    }
  }
  /* prog.cob:18: STOP */
  cob_set_location ("prog", "prog.cob", 18, "MAIN SECTION", "MAIN PARAGRAPH", "STOP");
  {
    cob_stop_run ((*(int *) (b_1)));
  }

  /* Program exit */

  /* Pop module stack */
  cob_current_module = cob_current_module->next;

  /* Program return */
  return (*(int *) (b_1));
}

# 4 "./cpucheck.c"
int
main ()
{



 char *ctune = "-mtune=";



 char vendor_string[16];
 int eax, ebx, edx, ecx;
 int i, hv;
 int family, model, stepping;

 __asm__ (".byte 0x0f,0xa2"
 : "=a" (hv), "=b" (ebx), "=d" (edx), "=c" (ecx) : "0" (0));

 *(int *) (vendor_string + 0) = ebx;
 *(int *) (vendor_string + 4) = edx;
 *(int *) (vendor_string + 8) = ecx;
 vendor_string[12] = 0;
 i = 1;

 __asm__ (".byte 0x0f,0xa2"
 : "=a" (eax), "=b" (ebx), "=d" (edx), "=c" (ecx) : "0" (i));

 family = (eax >> 8) & 0xf;
 model = (eax >> 4) & 0xf;
 stepping = eax & 0xf;
 if (family == 0xf) {
  /* "extended" mode. */
  family += (eax >> 20) & 0xff;
  model += (eax >> 12) & 0xf0;
 }

 if (strcmp (vendor_string, "GenuineIntel") == 0) {
  if (family == 5) {
   printf ("-march=i686 %spentium", ctune);
  } else if (family == 6) {
   if (model <= 2) {
    printf ("-march=i686 %spentiumpro",ctune);
   } else if (model >= 3 && model <= 6) {
    printf ("-march=i686 %spentium2",ctune);
   } else if (model <= 11) {
    printf ("-march=i686 %spentium3", ctune);
   } else {
    printf ("-march=i686 %spentium4", ctune);
   }
  }
  else if (family == 15) {
   printf ("-march=i686 %spentium4", ctune);
  }
 } else if (strcmp (vendor_string, "AuthenticAMD") == 0) {
  if (family == 6) {
   printf ("-march=i686 %sathlon", ctune);
  }
 }


 return 0;
}

