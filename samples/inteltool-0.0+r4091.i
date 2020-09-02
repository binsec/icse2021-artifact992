# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 42 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline unsigned char
inb (unsigned short int __port)
{
  unsigned char _v;

  __asm__ __volatile__ ("inb %w1,%0":"=a" (_v):"Nd" (__port));
  return _v;
}

# 51 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline unsigned char
inb_p (unsigned short int __port)
{
  unsigned char _v;

  __asm__ __volatile__ ("inb %w1,%0\noutb %%al,$0x80":"=a" (_v):"Nd" (__port));
  return _v;
}

# 60 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline unsigned short int
inw (unsigned short int __port)
{
  unsigned short _v;

  __asm__ __volatile__ ("inw %w1,%0":"=a" (_v):"Nd" (__port));
  return _v;
}

# 69 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline unsigned short int
inw_p (unsigned short int __port)
{
  unsigned short int _v;

  __asm__ __volatile__ ("inw %w1,%0\noutb %%al,$0x80":"=a" (_v):"Nd" (__port));
  return _v;
}

# 78 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline unsigned int
inl (unsigned short int __port)
{
  unsigned int _v;

  __asm__ __volatile__ ("inl %w1,%0":"=a" (_v):"Nd" (__port));
  return _v;
}

# 87 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline unsigned int
inl_p (unsigned short int __port)
{
  unsigned int _v;
  __asm__ __volatile__ ("inl %w1,%0\noutb %%al,$0x80":"=a" (_v):"Nd" (__port));
  return _v;
}

# 95 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outb (unsigned char __value, unsigned short int __port)
{
  __asm__ __volatile__ ("outb %b0,%w1": :"a" (__value), "Nd" (__port));
}

# 101 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outb_p (unsigned char __value, unsigned short int __port)
{
  __asm__ __volatile__ ("outb %b0,%w1\noutb %%al,$0x80": :"a" (__value),
   "Nd" (__port));
}

# 108 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outw (unsigned short int __value, unsigned short int __port)
{
  __asm__ __volatile__ ("outw %w0,%w1": :"a" (__value), "Nd" (__port));

}

# 115 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outw_p (unsigned short int __value, unsigned short int __port)
{
  __asm__ __volatile__ ("outw %w0,%w1\noutb %%al,$0x80": :"a" (__value),
   "Nd" (__port));
}

# 122 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outl (unsigned int __value, unsigned short int __port)
{
  __asm__ __volatile__ ("outl %0,%w1": :"a" (__value), "Nd" (__port));
}

# 128 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outl_p (unsigned int __value, unsigned short int __port)
{
  __asm__ __volatile__ ("outl %0,%w1\noutb %%al,$0x80": :"a" (__value),
   "Nd" (__port));
}

# 135 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
insb (unsigned short int __port, void *__addr, unsigned long int __count)
{
  __asm__ __volatile__ ("cld ; rep ; insb":"=D" (__addr), "=c" (__count)
   :"d" (__port), "0" (__addr), "1" (__count));
}

# 142 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
insw (unsigned short int __port, void *__addr, unsigned long int __count)
{
  __asm__ __volatile__ ("cld ; rep ; insw":"=D" (__addr), "=c" (__count)
   :"d" (__port), "0" (__addr), "1" (__count));
}

# 149 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
insl (unsigned short int __port, void *__addr, unsigned long int __count)
{
  __asm__ __volatile__ ("cld ; rep ; insl":"=D" (__addr), "=c" (__count)
   :"d" (__port), "0" (__addr), "1" (__count));
}

# 156 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outsb (unsigned short int __port, const void *__addr,
       unsigned long int __count)
{
  __asm__ __volatile__ ("cld ; rep ; outsb":"=S" (__addr), "=c" (__count)
   :"d" (__port), "0" (__addr), "1" (__count));
}

# 164 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outsw (unsigned short int __port, const void *__addr,
       unsigned long int __count)
{
  __asm__ __volatile__ ("cld ; rep ; outsw":"=S" (__addr), "=c" (__count)
   :"d" (__port), "0" (__addr), "1" (__count));
}

# 172 "/usr/include/i386-linux-gnu/sys/io.h"
static __inline void
outsl (unsigned short int __port, const void *__addr,
       unsigned long int __count)
{
  __asm__ __volatile__ ("cld ; rep ; outsl":"=S" (__addr), "=c" (__count)
   :"d" (__port), "0" (__addr), "1" (__count));
}

# 31 "cpu.c"
unsigned int cpuid(unsigned int op)
{
 uint32_t ret;
# 43 "cpu.c"
 asm ("cpuid" : "=a" (ret) : "a" (op) : "%ebx", "%ecx", "%edx");


 return ret;
}

