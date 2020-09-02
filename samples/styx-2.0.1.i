# 41 "../inc/sysbase0.h"
typedef void *StdCPtr;

# 534 "sysbase1.c"
typedef StdCPtr (*PCFUN)();

/*@ rustina_out_of_scope */
# 583 "sysbase1.c"
StdCPtr apply_fun(PCFUN f, int cnt, StdCPtr* args)
  { int i; StdCPtr arg;
    for( i=cnt-1; i >= 0; --i )
    {
      arg = args[i];
      __asm__ volatile ( "pushl %0" : : "r" (arg) );
    }
    return (*f)(/*args*/);
    /*return CALL_FUN(f); note that return is implied here. */
  }
