# 1 "/vagrant/allpkg/gromacs-5.0.2/cmake/TestInlineASM_gcc_x86.c"
int
main()
{
  unsigned int _eax,_ebx,_ecx,_edx;
  unsigned int level = 0;

  /* Test gcc inline asm for x86. Note that we CANNOT plainly use __x86_64__
   * to correspond to a 64-bit environment without also checking that __ILP32__
   * is NOT set, since x32 uses __x86_64__.
   */







    __asm__("push %%ebx       \n\t"
            "cpuid            \n\t"
            "movl %%ebx, %1   \n\t"
            "pop %%ebx        \n\t"
            : "=a"(_eax), "=r"(_ebx), "=c"(_ecx), "=d"(_edx) : "0"(level));




  return 0;
}

