# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 1379 "misc.c"
void Xen_cpuid(uint32_t idx, uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx)

{
     asm (
        /* %ebx register need to be saved before usage and restored thereafter
         * for PIC-compliant code on i386 */

        "push %%ebx; cpuid; mov %%ebx,%1; pop %%ebx"



        : "=a" (*eax), "=r" (*ebx), "=c" (*ecx), "=d" (*edx)
        : "0" (idx), "2" (0)
    );
}

