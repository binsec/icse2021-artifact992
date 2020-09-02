# 41 "dzcomm/include/dzcomm/dzunix.h"
static inline void outportb(unsigned short port, unsigned char value)
{
   __asm__ volatile ("outb %0, %1" : : "a" (value), "d" (port));
}

# 46 "dzcomm/include/dzcomm/dzunix.h"
static inline void outportw(unsigned short port, unsigned short value)
{
   __asm__ volatile ("outw %0, %1" : : "a" (value), "d" (port));
}

# 51 "dzcomm/include/dzcomm/dzunix.h"
static inline void outportl(unsigned short port, unsigned long value)
{
   __asm__ volatile ("outl %0, %1" : : "a" (value), "d" (port));
}

# 56 "dzcomm/include/dzcomm/dzunix.h"
static inline unsigned char inportb(unsigned short port)
{
   unsigned char value;
   __asm__ volatile ("inb %1, %0" : "=a" (value) : "d" (port));
   return value;
}

# 63 "dzcomm/include/dzcomm/dzunix.h"
static inline unsigned short inportw(unsigned short port)
{
   unsigned short value;
   __asm__ volatile ("inw %1, %0" : "=a" (value) : "d" (port));
   return value;
}

# 70 "dzcomm/include/dzcomm/dzunix.h"
static inline unsigned long inportl(unsigned short port)
{
   unsigned long value;
   __asm__ volatile ("inl %1, %0" : "=a" (value) : "d" (port));
   return value;
}

