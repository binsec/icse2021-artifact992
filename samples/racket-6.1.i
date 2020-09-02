# 275 "/vagrant/allpkg/racket-6.1/src/racket/gc2/../src/number.c"
static void to_double_prec (void )
{
  /* No conversion */
# 277 "/vagrant/allpkg/racket-6.1/src/racket/gc2/../src/number.c"
  int _dblprec = 0x27F ;
  asm ("fldcw %0" : : "m" (_dblprec ) ) ;
}

# 282 "/vagrant/allpkg/racket-6.1/src/racket/gc2/../src/number.c"
static void to_extended_prec (void )
{
  /* No conversion */
# 284 "/vagrant/allpkg/racket-6.1/src/racket/gc2/../src/number.c"
  int _extprec = 0x37F ;
  asm ("fldcw %0" : : "m" (_extprec ) ) ;
}

