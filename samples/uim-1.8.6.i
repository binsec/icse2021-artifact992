# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 89 "uim-scm.h"
typedef struct uim_opaque * uim_lisp;

# 147 "uim-scm.h"
long uim_scm_c_int(uim_lisp integer);

# 148 "uim-scm.h"
uim_lisp uim_scm_make_int(long integer);

# 215 "uim-scm.h"
uim_lisp uim_scm_list2(uim_lisp elm1, uim_lisp elm2);

# 224 "uim-scm.h"
uim_lisp uim_scm_car(uim_lisp pair);

# 225 "uim-scm.h"
uim_lisp uim_scm_cdr(uim_lisp pair);

# 302 "lolevel.c"
static uim_lisp
c_htons(uim_lisp u16_)
{
  return uim_scm_make_int((__extension__ ({ unsigned short int __v, __x = (unsigned short int) (uim_scm_c_int(u16_)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
}

# 313 "lolevel.c"
static uim_lisp
c_ntohs(uim_lisp u16_)
{
  return uim_scm_make_int((__extension__ ({ unsigned short int __v, __x = (unsigned short int) (uim_scm_c_int(u16_)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })));
}

# 325 "lolevel.c"
static uim_lisp
c_u16_to_u8list(uim_lisp u16_)
{
  uint16_t u16 = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (uim_scm_c_int(u16_)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

  return uim_scm_list2(uim_scm_make_int(u16 & 0xff),
        uim_scm_make_int((u16 >> 8) & 0xff));
}

# 359 "lolevel.c"
static uim_lisp
c_u8list_to_u16(uim_lisp u8list_)
{
  uint8_t u8_1, u8_2;

  u8_1 = uim_scm_c_int(uim_scm_car(u8list_));
  u8_2 = uim_scm_c_int(uim_scm_car(uim_scm_cdr(u8list_)));
  return uim_scm_make_int((__extension__ ({ unsigned short int __v, __x = (unsigned short int) (u8_1 | (u8_2 << 8)); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))
               );
}

