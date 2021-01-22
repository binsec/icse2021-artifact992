# Testing a chunk from **libc**

Some time ago, the hot functions were written with inline assembly to speedup execution time or reduce code size.
Browsing in the **Github** history of **libc** back to 1990's, we found an interesting [commit](https://github.com/bminor/glibc/commit/7c97addd6fbb44818b6e4d219cdbd189554a10f3) about *string* utils:
```
Update.

1999-01-13  Ulrich Drepper  <drepper@cygnus.com>

	* sysdeps/i386/bits/string.h: Correct several bugs in various
	functions which never worked.
	Patch by Maciej W. Rozycki <macro@ds2.pg.gda.pl>.
```
Let's try to figure out if ***RUSTInA*** would have helped to detect what issues were lurking around. We will focus on the function `strcspn`:
```c
/* Return the length of the initial segment of S which
   consists entirely of characters not in REJECT.  */
```
First step is to get the source code without the correction. We need to look at the parent [commit](https://github.com/bminor/glibc/commit/d731df03bd12beb674e07696f8dbc57a60421879) and browse to the file [sysdeps/i386/bits/string.h](https://github.com/bminor/glibc/blob/d731df03bd12beb674e07696f8dbc57a60421879/sysdeps/i386/bits/string.h#L518-L577):
```c
#define _HAVE_STRING_ARCH_strcspn 1
#ifdef __PIC__
__STRING_INLINE size_t
strcspn (__const char *__s, __const char *__reject)
{
  register unsigned long int __d0, __d1, __d2;
  register char *__res;
  __asm__ __volatile__
    ("pushl	%%ebx\n\t"
     "cld\n\t"
     "movl	%4,%%edi\n\t"
     "repne; scasb\n\t"
     "notl	%%ecx\n\t"
     "decl	%%ecx\n\t"
     "movl	%%ecx,%%ebx\n"
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
     : "=&S" (__res), "=&a" (__d0), "=&c" (__d1), "=&D" (__d2)
     : "r" (__reject), "1" (0), "2" (0xffffffff), "3" (__s),
     : "cc");
  return (__res - 1) - __s;
}
#else
__STRING_INLINE size_t
strcspn (__const char *__s, __const char *__reject)
{
  register unsigned long int __d0, __d1, __d2, __d3;
  register char *__res;
  __asm__ __volatile__
    ("cld\n\t"
     "movl	%5,%%edi\n\t"
     "repne; scasb\n\t"
     "notl	%%ecx\n\t"
     "decl	%%ecx\n\t"
     "movl	%%ecx,%%edx\n"
     "1:\n\t"
     "lodsb\n\t"
     "testb	%%al,%%al\n\t"
     "je	2f\n\t"
     "movl	%5,%%edi\n\t"
     "movl	%%edx,%%ecx\n\t"
     "repne; scasb\n\t"
     "jne	1b\n"
     "2:"
     : "=&S" (__res), "=&a" (__d0), "=&c" (__d1), "=&d" (__d2), "=&D" (__d3)
     : "g" (__reject), "0" (__s), "1" (0), "2" (0xffffffff)
     : "cc");
  return (__res - 1) - __s;
}
#endif
```
We can copy this snippet in a temporary file (*e.g.* `strcspn.c`) but, we can not use ***RUSTInA*** yet since there are macros (`__PIC__` & `__STRING_INLINE`) and the type `size_t` is undefined.
Running the following will do the trick by using the compiler preprocessor:
```shell
gcc -U__PIC__ -D__STRING_INLINE= -Dsize_t="unsigned long int" -E strcspn.c > strcspn.i
```
And then we can apply ***RUSTInA*** to the generated file with verbose output:
```shell
bin/rustina-x86_64.AppImage -v $(pwd)/strcspn.i
```
So, there is really nothing very interesting to say about this chunk, it reads memory from *string* inputs `__s` and `__reject` but misses the proper `memory` flag.

Let's try the **PIC** version:
```shell
gcc -D__PIC__ -D__STRING_INLINE= -Dsize_t="unsigned long int" -E strcspn.c > strcspn.i
bin/rustina-x86_64.AppImage -v $(pwd)/strcspn.i
```
It starts pretty bad, we are greeted by a syntax error message. There is a comma `,` that should not be there:
```c
: "r" (__reject), "1" (0), "2" (0xffffffff), "3" (__s),
```
We will cheat and remove the last comma in order to make the file syntactically correct:
```shell
gawk -i inplace 'substr($0,60,1)=="," {$0=substr($0,1,59)}32' strcspn.i
```
Once again, run ***RUSTInA*** to the file:
```shell
bin/rustina-x86_64.AppImage -v $(pwd)/strcspn.i
```
Let us take a closer look at some of these issues:
- **ebx** is pushed on the stack (**esp**). While it is not an error per se, ***RUSTInA*** do not handle the stack. It is done on purpose because using `push` and `pop` instruction in an inline assembly chunk is strongly discouraged;
- the register **esi** (`S`) is not initialized! It is used as base pointer and should be initialized with `__s`. Without proper initialization, the chunk is very likely to raise a `segmentation fault`. ***RUNSTInA*** do not know how the register should be initialized and so, only solves half of the problem by adding `__res` in the inputs. The compiler should now raise a warning that `__res` is used non-initialized. That should be enough to put us on the right track.
Maybe the additional coma comes from an unintended entry removal?
- there is a **unicity** issue! The compiler may choose **ecx** for the 4th entry (`%4`). If so, the pointer `__reject` would be clobbered before its 2nd use. Once again, clobbering a pointer is very likely to raise a `segmentation fault`!

### TLDR
*Ulrich Drepper* was right, this function can not have ever worked before. There are two main issues that can lead to a `segmentation fault`.
The chunk comes from too far to be automatically patched, but ***RUSTInA*** pointed out the main issues. Maybe the issues would not have waited so many years if the author benefited from the automatic *compliance check* offered by ***RUSTInA***.