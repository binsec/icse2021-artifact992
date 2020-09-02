# 156 "/vagrant/allpkg/bmagic-3.7.0/src/bmutil.h"
inline
unsigned bsf_asm32(unsigned int v)
{
    unsigned r;
    asm volatile(" bsfl %1, %0": "=r"(r): "rm"(v) );
    return r;
}

# 164 "/vagrant/allpkg/bmagic-3.7.0/src/bmutil.h"
inline unsigned bsr_asm32(register unsigned int v)
{
    unsigned r;
    asm volatile(" bsrl %1, %0": "=r"(r): "rm"(v) );
    return r;
}

