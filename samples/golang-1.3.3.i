# 813 "cmd/dist/unix.c"
static void
__cpuid(int dst[4], int ax)
{

 // we need to avoid ebx on i386 (esp. when -fPIC).
 asm volatile(
  "mov %%ebx, %%edi\n\t"
  "cpuid\n\t"
  "xchgl %%ebx, %%edi"
  : "=a" (dst[0]), "=D" (dst[1]), "=c" (dst[2]), "=d" (dst[3])
  : "0" (ax));







}

