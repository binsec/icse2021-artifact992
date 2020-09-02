# 62 "/usr/include/i386-linux-gnu/asm/vm86.h"
struct vm86_regs {
/*
 * normal regs, with special meaning for the segment descriptors..
 */
 long ebx;
 long ecx;
 long edx;
 long esi;
 long edi;
 long ebp;
 long eax;
 long __null_ds;
 long __null_es;
 long __null_fs;
 long __null_gs;
 long orig_eax;
 long eip;
 unsigned short cs, __csh;
 long eflags;
 long esp;
 unsigned short ss, __ssh;
/*
 * these are specific to v86 mode:
 */
 unsigned short es, __esh;
 unsigned short ds, __dsh;
 unsigned short fs, __fsh;
 unsigned short gs, __gsh;
};

# 92 "/usr/include/i386-linux-gnu/asm/vm86.h"
struct revectored_struct {
 unsigned long __map[8]; /* 256 bits */
};

# 96 "/usr/include/i386-linux-gnu/asm/vm86.h"
struct vm86_struct {
 struct vm86_regs regs;
 unsigned long flags;
 unsigned long screen_bitmap;
 unsigned long cpu_type;
 struct revectored_struct int_revectored;
 struct revectored_struct int21_revectored;
};

# 190 "lrmi.c"
static struct
 {
 int ready;
 unsigned short ret_seg, ret_off;
 unsigned short stack_seg, stack_off;
 struct vm86_struct vm;
 } context = { 0 };

# 348 "lrmi.c"
static void
em_ins(int size)
 {
 unsigned int edx, edi;

 edx = context.vm.regs.edx & 0xffff;
 edi = context.vm.regs.edi & 0xffff;
 edi += (unsigned int)context.vm.regs.ds << 4;

 if (context.vm.regs.eflags & (1 << 10))
  {
  if (size == 4)
   asm volatile ("std; insl; cld"
    : "=D" (edi) : "d" (edx), "0" (edi));
  else if (size == 2)
   asm volatile ("std; insw; cld"
    : "=D" (edi) : "d" (edx), "0" (edi));
  else
   asm volatile ("std; insb; cld"
    : "=D" (edi) : "d" (edx), "0" (edi));
  }
 else
  {
  if (size == 4)
   asm volatile ("cld; insl"
    : "=D" (edi) : "d" (edx), "0" (edi));
  else if (size == 2)
   asm volatile ("cld; insw"
    : "=D" (edi) : "d" (edx), "0" (edi));
  else
   asm volatile ("cld; insb"
    : "=D" (edi) : "d" (edx), "0" (edi));
  }

 edi -= (unsigned int)context.vm.regs.ds << 4;

 context.vm.regs.edi &= 0xffff0000;
 context.vm.regs.edi |= edi & 0xffff;
 }

# 388 "lrmi.c"
static void
em_rep_ins(int size)
 {
 unsigned int ecx, edx, edi;

 ecx = context.vm.regs.ecx & 0xffff;
 edx = context.vm.regs.edx & 0xffff;
 edi = context.vm.regs.edi & 0xffff;
 edi += (unsigned int)context.vm.regs.ds << 4;

 if (context.vm.regs.eflags & (1 << 10))
  {
  if (size == 4)
   asm volatile ("std; rep; insl; cld"
    : "=D" (edi), "=c" (ecx)
    : "d" (edx), "0" (edi), "1" (ecx));
  else if (size == 2)
   asm volatile ("std; rep; insw; cld"
    : "=D" (edi), "=c" (ecx)
    : "d" (edx), "0" (edi), "1" (ecx));
  else
   asm volatile ("std; rep; insb; cld"
    : "=D" (edi), "=c" (ecx)
    : "d" (edx), "0" (edi), "1" (ecx));
  }
 else
  {
  if (size == 4)
   asm volatile ("cld; rep; insl"
    : "=D" (edi), "=c" (ecx)
    : "d" (edx), "0" (edi), "1" (ecx));
  else if (size == 2)
   asm volatile ("cld; rep; insw"
    : "=D" (edi), "=c" (ecx)
    : "d" (edx), "0" (edi), "1" (ecx));
  else
   asm volatile ("cld; rep; insb"
    : "=D" (edi), "=c" (ecx)
    : "d" (edx), "0" (edi), "1" (ecx));
  }

 edi -= (unsigned int)context.vm.regs.ds << 4;

 context.vm.regs.edi &= 0xffff0000;
 context.vm.regs.edi |= edi & 0xffff;

 context.vm.regs.ecx &= 0xffff0000;
 context.vm.regs.ecx |= ecx & 0xffff;
 }

# 438 "lrmi.c"
static void
em_outs(int size)
 {
 unsigned int edx, esi;

 edx = context.vm.regs.edx & 0xffff;
 esi = context.vm.regs.esi & 0xffff;
 esi += (unsigned int)context.vm.regs.ds << 4;

 if (context.vm.regs.eflags & (1 << 10))
  {
  if (size == 4)
   asm volatile ("std; outsl; cld"
    : "=S" (esi) : "d" (edx), "0" (esi));
  else if (size == 2)
   asm volatile ("std; outsw; cld"
    : "=S" (esi) : "d" (edx), "0" (esi));
  else
   asm volatile ("std; outsb; cld"
    : "=S" (esi) : "d" (edx), "0" (esi));
  }
 else
  {
  if (size == 4)
   asm volatile ("cld; outsl"
    : "=S" (esi) : "d" (edx), "0" (esi));
  else if (size == 2)
   asm volatile ("cld; outsw"
    : "=S" (esi) : "d" (edx), "0" (esi));
  else
   asm volatile ("cld; outsb"
    : "=S" (esi) : "d" (edx), "0" (esi));
  }

 esi -= (unsigned int)context.vm.regs.ds << 4;

 context.vm.regs.esi &= 0xffff0000;
 context.vm.regs.esi |= esi & 0xffff;
 }

# 478 "lrmi.c"
static void
em_rep_outs(int size)
 {
 unsigned int ecx, edx, esi;

 ecx = context.vm.regs.ecx & 0xffff;
 edx = context.vm.regs.edx & 0xffff;
 esi = context.vm.regs.esi & 0xffff;
 esi += (unsigned int)context.vm.regs.ds << 4;

 if (context.vm.regs.eflags & (1 << 10))
  {
  if (size == 4)
   asm volatile ("std; rep; outsl; cld"
    : "=S" (esi), "=c" (ecx)
    : "d" (edx), "0" (esi), "1" (ecx));
  else if (size == 2)
   asm volatile ("std; rep; outsw; cld"
    : "=S" (esi), "=c" (ecx)
    : "d" (edx), "0" (esi), "1" (ecx));
  else
   asm volatile ("std; rep; outsb; cld"
    : "=S" (esi), "=c" (ecx)
    : "d" (edx), "0" (esi), "1" (ecx));
  }
 else
  {
  if (size == 4)
   asm volatile ("cld; rep; outsl"
    : "=S" (esi), "=c" (ecx)
    : "d" (edx), "0" (esi), "1" (ecx));
  else if (size == 2)
   asm volatile ("cld; rep; outsw"
    : "=S" (esi), "=c" (ecx)
    : "d" (edx), "0" (esi), "1" (ecx));
  else
   asm volatile ("cld; rep; outsb"
    : "=S" (esi), "=c" (ecx)
    : "d" (edx), "0" (esi), "1" (ecx));
  }

 esi -= (unsigned int)context.vm.regs.ds << 4;

 context.vm.regs.esi &= 0xffff0000;
 context.vm.regs.esi |= esi & 0xffff;

 context.vm.regs.ecx &= 0xffff0000;
 context.vm.regs.ecx |= ecx & 0xffff;
 }

# 528 "lrmi.c"
static void
em_inb(void)
 {
 asm volatile ("inb (%w1), %b0"
  : "=a" (context.vm.regs.eax)
  : "d" (context.vm.regs.edx), "0" (context.vm.regs.eax));
 }

# 536 "lrmi.c"
static void
em_inw(void)
 {
 asm volatile ("inw (%w1), %w0"
  : "=a" (context.vm.regs.eax)
  : "d" (context.vm.regs.edx), "0" (context.vm.regs.eax));
 }

# 544 "lrmi.c"
static void
em_inl(void)
 {
 asm volatile ("inl (%w1), %0"
  : "=a" (context.vm.regs.eax)
  : "d" (context.vm.regs.edx));
 }

# 552 "lrmi.c"
static void
em_outb(void)
 {
 asm volatile ("outb %b0, (%w1)"
  : : "a" (context.vm.regs.eax),
  "d" (context.vm.regs.edx));
 }

# 560 "lrmi.c"
static void
em_outw(void)
 {
 asm volatile ("outw %w0, (%w1)"
  : : "a" (context.vm.regs.eax),
  "d" (context.vm.regs.edx));
 }

# 568 "lrmi.c"
static void
em_outl(void)
 {
 asm volatile ("outl %0, (%w1)"
  : : "a" (context.vm.regs.eax),
  "d" (context.vm.regs.edx));
 }

# 717 "lrmi.c"
static int
lrmi_vm86(struct vm86_struct *vm)
 {
 int r;
# 730 "lrmi.c"
 asm volatile (
  "int $0x80"
  : "=a" (r)
  : "0" (113), "b" (vm));

 return r;
 }

