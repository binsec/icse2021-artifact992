extern int printf(const char *format, ...);
void * __builtin___memcpy_chk (void *, const void *, unsigned int, unsigned int);
unsigned int __builtin_object_size (const void *, int);
unsigned int __builtin_strlen (const char *);
int __builtin_strcmp (const char *, const char *);

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 59 "vmware.c"
static void vmware_cmd(uint32_t cmd, uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx) {
    *eax = 0x564d5868;
    *ebx = 0xffffffff;
    *ecx = cmd;
    *edx = 0x5658;

    __asm__( "xchgl %%ebx, %1;" "inl (%%dx);" "xchgl %%ebx, %1" : "+a"(*eax), "+r"(*ebx), "+c"(*ecx), "+d"(*edx) );;
}

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 32 "pillbox.c"
void sidt() {
  volatile uint64_t idt = 0;

  asm("sidt %0" : :"m"(idt));
  volatile uint64_t old = idt;

  unsigned int i;
  for(i=0; i<0xffffff; i++) {
    asm("sidt %0" : :"m"(idt));

    if(old != idt) {
 printf(",idt,%" "ll" "u" ",idt2,%" "ll" "u", old, idt);
 return;
    }
  }

  printf(",idt,%" "ll" "u", old);
}

# 51 "pillbox.c"
void sgdt() {
  volatile uint64_t gdt = 0;

  asm("sgdt %0" : :"m"(gdt));
  volatile uint64_t old = gdt;

  unsigned int i;
  for(i=0; i<0xffffff; i++) {
    asm("sgdt %0" : :"m"(gdt));

    if(old != gdt) {
 printf(",gdt,%" "ll" "u" ",gdt2,%" "ll" "u", old, gdt);
 return;
    }
  }

  printf(",gdt,%" "ll" "u", old);
}

# 70 "pillbox.c"
void sldt() {
  volatile uint64_t ldt = 0;

  asm("sldt %0" : :"m"(ldt));

  printf(",ldt,%" "ll" "u", ldt);
}

# 78 "pillbox.c"
void str() {
  volatile uint64_t tr = 0;

  asm("str %0" : :"m"(tr));

  printf(",tr,%" "ll" "u", tr);
}

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 55 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long long int __quad_t;

# 131 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __off_t;

# 132 "/usr/include/i386-linux-gnu/bits/types.h"
typedef __quad_t __off64_t;

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

# 170 "/usr/include/stdio.h"
extern struct _IO_FILE *stderr;

# 47 "/usr/include/i386-linux-gnu/bits/string3.h"
extern __inline void *
 memcpy (void *__restrict __dest, const void *__restrict __src, size_t __len)

{
  return __builtin___memcpy_chk (__dest, __src, __len, __builtin_object_size (__dest, 0));
}

# 27 "detect.h"
extern int debug_cpuid;

# 29 "detect.h"
void helper_main(int, char **);

# 32 "hyperv.c"
int main(int argc, char **argv) {
    helper_main(argc, argv);

    uint32_t eax = 0, ebx = 0, ecx = 0, edx = 0;
    char signature[13];

    __asm__ ( "xchgl %%ebx, %1;" "cpuid;" "xchgl %%ebx, %1" : "=a" (eax), "=r" (ebx), "=c" (ecx), "=d" (edx) : "0" (0x40000000)); if(debug_cpuid) fprintf(stderr, "%s:%d\tCPUID[0x%x]: eax=%d ebx=%d ecx=%d edx=%d\n", "hyperv.c", 38, 0x40000000, eax, ebx, ecx, edx);
    memcpy(&signature[0], &ebx, 4);
    memcpy(&signature[4], &ecx, 4);
    memcpy(&signature[8], &edx, 4);
    signature[12] = 0;

    if(!__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (signature) && __builtin_constant_p ("Microsoft Hv") && (__s1_len = __builtin_strlen (signature), __s2_len = __builtin_strlen ("Microsoft Hv"), (!((size_t)(const void *)((signature) + 1) - (size_t)(const void *)(signature) == 1) || __s1_len >= 4) && (!((size_t)(const void *)(("Microsoft Hv") + 1) - (size_t)(const void *)("Microsoft Hv") == 1) || __s2_len >= 4)) ? __builtin_strcmp (signature, "Microsoft Hv") : (__builtin_constant_p (signature) && ((size_t)(const void *)((signature) + 1) - (size_t)(const void *)(signature) == 1) && (__s1_len = __builtin_strlen (signature), __s1_len < 4) ? (__builtin_constant_p ("Microsoft Hv") && ((size_t)(const void *)(("Microsoft Hv") + 1) - (size_t)(const void *)("Microsoft Hv") == 1) ? __builtin_strcmp (signature, "Microsoft Hv") : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) ("Microsoft Hv"); int __result = (((const unsigned char *) (const char *) (signature))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (signature))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (signature))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (signature))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p ("Microsoft Hv") && ((size_t)(const void *)(("Microsoft Hv") + 1) - (size_t)(const void *)("Microsoft Hv") == 1) && (__s2_len = __builtin_strlen ("Microsoft Hv"), __s2_len < 4) ? (__builtin_constant_p (signature) && ((size_t)(const void *)((signature) + 1) - (size_t)(const void *)(signature) == 1) ? __builtin_strcmp (signature, "Microsoft Hv") : (- (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (signature); int __result = (((const unsigned char *) (const char *) ("Microsoft Hv"))[0] - __s2[0]); if (__s2_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) ("Microsoft Hv"))[1] - __s2[1]); if (__s2_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) ("Microsoft Hv"))[2] - __s2[2]); if (__s2_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) ("Microsoft Hv"))[3] - __s2[3]); } } __result; })))) : __builtin_strcmp (signature, "Microsoft Hv")))); })) {
 printf("Virtual Machine\n");
 return 1;
    }

    return 0;
}

