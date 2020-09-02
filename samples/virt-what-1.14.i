# 28 "virt-what-cpuid-helper.c"
static unsigned int
cpuid (unsigned int eax, char *sig)
{
  unsigned int *sig32 = (unsigned int *) sig;

  asm volatile (
        "xchgl %%ebx,%1; xor %%ebx,%%ebx; cpuid; xchgl %%ebx,%1"
        : "=a" (eax), "+r" (sig32[0]), "=c" (sig32[1]), "=d" (sig32[2])
        : "0" (eax));
  sig[12] = 0;

  return eax;
}

