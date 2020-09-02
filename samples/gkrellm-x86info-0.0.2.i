# 18 "MHz.c"
__inline__ unsigned long long int rdtsc()
{
 unsigned long long int x;
 __asm__ volatile (".byte 0x0f, 0x31" : "=A" (x));
 return x;
}

