# 29 "/vagrant/allpkg/gforth-0.7.2+dfsg1/include/gforth/0.7.2/libcc.h"
typedef int Cell;

# 30 "/vagrant/allpkg/gforth-0.7.2+dfsg1/include/gforth/0.7.2/libcc.h"
typedef double Float;

# 36 "/vagrant/allpkg/gforth-0.7.2+dfsg1/include/gforth/0.7.2/libcc.h"
extern Cell *gforth_SP;

# 37 "/vagrant/allpkg/gforth-0.7.2+dfsg1/include/gforth/0.7.2/libcc.h"
extern Float *gforth_FP;

# 106 "/vagrant/allpkg/gforth-0.7.2+dfsg1/lib/gforth/0.7.2/libcc-named/socket.c"
void socket_LTX_gforth_c_htons_n_n(void)
{
  Cell *sp = gforth_SP;
  Float *fp = gforth_FP;
  sp[0]=(__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sp[0]); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

