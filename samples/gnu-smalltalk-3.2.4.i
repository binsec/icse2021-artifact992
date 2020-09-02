# 186 "/usr/include/i386-linux-gnu/bits/types.h"
typedef int __intptr_t;

# 267 "/usr/include/unistd.h"
typedef __intptr_t intptr_t;

# 109 "gst.h"
typedef enum {
  false,
  true
} mst_Boolean;

# 116 "gst.h"
typedef struct oop_s *OOP;

# 119 "gst.h"
typedef struct object_s *gst_object;

# 122 "gst.h"
struct oop_s
{
  gst_object object;
  unsigned long flags; /* FIXME, use uintptr_t */
};

# 146 "gst.h"
struct object_s
{
  OOP objSize; OOP objClass;
  OOP data[1]; /* variable length, may not be objects, 
				   but will always be at least this
				   big.  */
};

# 111 "interp.inl"
OOP
add_with_check (OOP op1, OOP op2, mst_Boolean *overflow)
{
  intptr_t iop1 = (intptr_t) op1;
  intptr_t iop2 = (intptr_t) op2;
  intptr_t iresult;

  int of = 0;
  iop2--;
  asm ("add" "l" " %3, %2\n"
       "seto %b1" : "=r" (iresult), "+&q" (of) : "0" (iop1), "rmi" (iop2));

  *overflow = of;






  return (OOP) iresult;
}

# 133 "interp.inl"
OOP
sub_with_check (OOP op1, OOP op2, mst_Boolean *overflow)
{
  intptr_t iop1 = (intptr_t) op1;
  intptr_t iop2 = (intptr_t) op2;
  intptr_t iresult;

  int of = 0;
  iop2--;
  asm ("sub" "l" " %3, %2\n"
       "seto %b1" : "=r" (iresult), "+&q" (of) : "0" (iop1), "rmi" (iop2));

  *overflow = of;






  return (OOP) iresult;
}

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 101 "/usr/include/SDL/SDL_stdinc.h"
typedef uint16_t Uint16;

# 103 "/usr/include/SDL/SDL_stdinc.h"
typedef uint32_t Uint32;

# 108 "/usr/include/SDL/SDL_stdinc.h"
typedef uint64_t Uint64;

# 75 "/usr/include/SDL/SDL_endian.h"
static __inline__ Uint16 SDL_Swap16(Uint16 x)
{
 __asm__("xchgb %b0,%h0" : "=q" (x) : "0" (x));
 return x;
}

# 108 "/usr/include/SDL/SDL_endian.h"
static __inline__ Uint32 SDL_Swap32(Uint32 x)
{
 __asm__("bswap %0" : "=r" (x) : "0" (x));
 return x;
}

# 144 "/usr/include/SDL/SDL_endian.h"
static __inline__ Uint64 SDL_Swap64(Uint64 x)
{
 union {
  struct { Uint32 a,b; } s;
  Uint64 u;
 } v;
 v.u = x;
 __asm__("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
         : "=r" (v.s.a), "=r" (v.s.b)
         : "0" (v.s.a), "1" (v.s.b));
 return v.u;
}

