# 42 "conftest.c"
int
main ()
{
unsigned long eax, ebx, ecx, edx;__asm__( "cpuid" : "=a"(eax), "=b"(ebx), "=c"(ecx), "=d"(edx) : "a"(0), "b"(0), "c"(0), "d"(0));
  ;
  return 0;
}

