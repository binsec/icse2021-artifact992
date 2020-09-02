# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 137 "/usr/include/SDL2/SDL_stdinc.h"
typedef uint16_t Uint16;

# 145 "/usr/include/SDL2/SDL_stdinc.h"
typedef uint32_t Uint32;

# 154 "/usr/include/SDL2/SDL_stdinc.h"
typedef uint64_t Uint64;

# 258 "/usr/include/SDL2/SDL_stdinc.h"
static __inline__ void SDL_memset4(void *dst, Uint32 val, size_t dwords)
{

    int u0, u1, u2;
    __asm__ __volatile__ (
        "cld \n\t"
        "rep ; stosl \n\t"
        : "=&D" (u0), "=&a" (u1), "=&c" (u2)
        : "0" (dst), "1" (val), "2" (((Uint32)(dwords)))
        : "memory"
    );
# 284 "/usr/include/SDL2/SDL_stdinc.h"
}

# 70 "/usr/include/SDL2/SDL_endian.h"
static __inline__ Uint16
SDL_Swap16(Uint16 x)
{
  __asm__("xchgb %b0,%h0": "=q"(x):"0"(x));
    return x;
}

# 108 "/usr/include/SDL2/SDL_endian.h"
static __inline__ Uint32
SDL_Swap32(Uint32 x)
{
  __asm__("bswap %0": "=r"(x):"0"(x));
    return x;
}

# 149 "/usr/include/SDL2/SDL_endian.h"
static __inline__ Uint64
SDL_Swap64(Uint64 x)
{
    union
    {
        struct
        {
            Uint32 a, b;
        } s;
        Uint64 u;
    } v;
    v.u = x;
  __asm__("bswapl %0 ; bswapl %1 ; xchgl %0,%1": "=r"(v.s.a), "=r"(v.s.b):"0"(v.s.a),
            "1"(v.s.
                b));
    return v.u;
}

