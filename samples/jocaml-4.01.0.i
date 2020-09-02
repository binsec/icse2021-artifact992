# 35 "config.h"
typedef long intnat;

# 76 "signals.c"
static intnat volatile caml_async_signal_mode = 0;

# 90 "signals.c"
static int caml_try_leave_blocking_section_default(void)
{
  intnat res;
  asm("xorl %0, %0; xchgl %0, %1" : "=r" (res), "=m" (caml_async_signal_mode) : "m" (caml_async_signal_mode));
  return res;
}

