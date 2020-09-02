# 126 "../../src/DepthBufferRender.cpp"
__inline int idiv16(int x, int y) // (x << 16) / y
{
    //x = (((long long)x) << 16) / ((long long)y);
# 140 "../../src/DepthBufferRender.cpp"
    int reminder;
    asm ("idivl %[divisor]"
          : "=a" (x), "=d" (reminder)
          : [divisor] "g" (y), "d" (x >> 16), "a" (x << 16));

    return x;
}

# 38 "../../src/TexConv.h"
void TexConv_ARGB1555_ARGB4444 (unsigned char * _src, unsigned char * _dst, int width, int height)
{
    int _size = (width * height) << 1;
# 84 "../../src/TexConv.h"
   //printf("TexConv_ARGB1555_ARGB4444\n");
   asm volatile (
         //"tc1_loop2:             \n"
         "0: \n"
         "mov (%[_src]), %%eax     \n"
         "add $4, %[_src]          \n"

        // arrr rrgg gggb bbbb
        // aaaa rrrr gggg bbbb
         "mov %%eax, %%edx       \n"
         "and $0x80008000, %%eax \n"
         "mov %%eax, %%ecx       \n" // ecx = 0xa000000000000000
         "shr $1, %%eax          \n"
         "or %%eax, %%ecx        \n" // ecx = 0xaa00000000000000
         "shr $1, %%eax          \n"
         "or %%eax, %%ecx        \n" // ecx = 0xaaa0000000000000
         "shr $1, %%eax          \n"
         "or %%eax, %%ecx        \n" // ecx = 0xaaaa000000000000

         "mov %%edx, %%eax       \n"
         "and $0x78007800, %%eax \n" // eax = 0x0rrrr00000000000
         "shr $3, %%eax          \n" // eax = 0x0000rrrr00000000
         "or %%eax, %%ecx        \n" // ecx = 0xaaaarrrr00000000

         "mov %%edx, %%eax       \n"
         "and $0x03c003c0, %%eax \n" // eax = 0x000000gggg000000
         "shr $2, %%eax          \n" // eax = 0x00000000gggg0000
         "or %%eax, %%ecx        \n" // ecx = 0xaaaarrrrgggg0000

         "and $0x001e001e, %%edx \n" // edx = 0x00000000000bbbb0
         "shr $1, %%edx          \n" // edx = 0x000000000000bbbb
         "or %%edx, %%ecx        \n" // ecx = 0xaaaarrrrggggbbbb

         "mov %%ecx, (%[_dst])     \n"
         "add $4, %[_dst]          \n"

         "decl %[_size]            \n"
         "jnz 0b \n"
         : [_src]"+S"(_src), [_dst]"+D"(_dst), [_size]"+g"(_size)
         :
         : "memory", "cc", "eax", "edx", "ecx"
         );

}

# 129 "../../src/TexConv.h"
void TexConv_AI88_ARGB4444 (unsigned char * _src, unsigned char * _dst, int width, int height)
{
    int _size = (width * height) << 1;
# 163 "../../src/TexConv.h"
   //printf("TexConv_AI88_ARGB4444\n");
   asm volatile (
         //"tc1_loop3:              \n"
         "0: \n"
         "mov (%[_src]), %%eax     \n"
         "add $4, %[_src]          \n"

         // aaaa aaaa iiii iiii
         // aaaa rrrr gggg bbbb
         "mov %%eax, %%edx       \n"
         "and $0xF000F000, %%eax \n" // eax = 0xaaaa000000000000
         "mov %%eax, %%ecx       \n" // ecx = 0xaaaa000000000000

         "and $0x00F000F0, %%edx \n" // edx = 0x00000000iiii0000
         "shl $4, %%edx          \n" // edx = 0x0000iiii00000000
         "or %%edx, %%ecx        \n" // ecx = 0xaaaaiiii00000000
         "shr $4, %%edx          \n" // edx = 0x00000000iiii0000
         "or %%edx, %%ecx        \n" // ecx = 0xaaaaiiiiiiii0000
         "shr $4, %%edx          \n" // edx = 0x000000000000iiii
         "or %%edx, %%ecx        \n" // ecx = 0xaaaaiiiiiiiiiiii

         "mov %%ecx, (%[_dst])     \n"
         "add $4, %[_dst]          \n"

         "decl %[_size]            \n"
         "jnz 0b \n"
         : [_src]"+S"(_src), [_dst]"+D"(_dst), [_size]"+g"(_size)
         :
         : "memory", "cc", "eax", "edx", "ecx"
         );

}

# 196 "../../src/TexConv.h"
void TexConv_AI44_ARGB4444 (unsigned char * _src, unsigned char * _dst, int width, int height)
{
    int _size = width * height;
# 261 "../../src/TexConv.h"
   //printf("TexConv_AI44_ARGB4444\n");
   asm volatile (
         //"tc1_loop4:             \n"
         "0: \n"
         "mov (%[_src]), %%eax     \n"
         "add $4, %[_src]          \n"

         // aaaa3 iiii3 aaaa2 iiii2 aaaa1 iiii1 aaaa0 iiii0
         // aaaa1 rrrr1 gggg1 bbbb1 aaaa0 rrrr0 gggg0 bbbb0
         // aaaa3 rrrr3 gggg3 bbbb3 aaaa2 rrrr2 gggg2 bbbb2
         "mov %%eax, %%edx       \n" // eax = aaaa3 iiii3 aaaa2 iiii2 aaaa1 iiii1 aaaa0 iiii0
         "shl $16, %%eax         \n" // eax = aaaa1 iiii1 aaaa0 iiii0 0000  0000  0000  0000
         "and $0xFF000000, %%eax \n" // eax = aaaa1 iiii1 0000  0000  0000  0000  0000  0000
         "mov %%eax, %%ecx       \n" // ecx = aaaa1 iiii1 0000  0000  0000  0000  0000  0000
         "and $0x0F000000, %%eax \n" // eax = 0000  iiii1 0000  0000  0000  0000  0000  0000
         "shr $4, %%eax          \n" // eax = 0000  0000  iiii1 0000  0000  0000  0000  0000
         "or %%eax, %%ecx        \n" // ecx = aaaa1 iiii1 iiii1 0000  0000  0000  0000  0000
         "shr $4, %%eax          \n" // eax = 0000  0000  0000  iiii1 0000  0000  0000  0000
         "or %%eax, %%ecx        \n" // ecx = aaaa1 iiii1 iiii1 iiii1 0000  0000  0000  0000

         "mov %%edx, %%eax       \n" // eax = aaaa3 iiii3 aaaa2 iiii2 aaaa1 iiii1 aaaa0 iiii0
         "shl $8, %%eax          \n" // eax = aaaa2 iiii2 aaaa1 iiii1 aaaa0 iiii0 0000  0000
         "and $0x0000FF00, %%eax \n" // eax = 0000  0000  0000  0000  aaaa0 iiii0 0000  0000
         "or %%eax, %%ecx        \n" // ecx = aaaa1 iiii1 iiii1 iiii1 aaaa0 iiii0 0000  0000
         "and $0x00000F00, %%eax \n" // eax = 0000  0000  0000  0000  0000  iiii0 0000  0000
         "shr $4, %%eax          \n" // eax = 0000  0000  0000  0000  0000  0000  iiii0 0000
         "or %%eax, %%ecx        \n" // ecx = aaaa1 iiii1 iiii1 iiii1 aaaa0 iiii0 iiii0 0000
         "shr $4, %%eax          \n" // eax = 0000  0000  0000  0000  0000  0000  0000  iiii0
         "or %%eax, %%ecx        \n" // ecx = aaaa1 iiii1 iiii1 iiii1 aaaa0 iiii0 iiii0 iiii0

         "mov %%ecx, (%[_dst])     \n"
         "add $4, %[_dst]          \n"

         "mov %%edx, %%eax       \n" // eax = aaaa3 iiii3 aaaa2 iiii2 aaaa1 iiii1 aaaa0 iiii0
         "and $0xFF000000, %%eax \n" // eax = aaaa3 iiii3 0000  0000  0000  0000  0000  0000
         "mov %%eax, %%ecx       \n" // ecx = aaaa3 iiii3 0000  0000  0000  0000  0000  0000
         "and $0x0F000000, %%eax \n" // eax = 0000  iiii3 0000  0000  0000  0000  0000  0000
         "shr $4, %%eax          \n" // eax = 0000  0000  iiii3 0000  0000  0000  0000  0000
         "or %%eax, %%ecx        \n" // ecx = aaaa3 iiii3 iiii3 0000  0000  0000  0000  0000
         "shr $4, %%eax          \n" // eax = 0000  0000  0000  iiii3 0000  0000  0000  0000
         "or %%eax, %%ecx        \n" // ecx = aaaa3 iiii3 iiii3 iiii3 0000  0000  0000  0000

                                                // edx = aaaa3 iiii3 aaaa2 iiii2 aaaa1 iiii1 aaaa0 iiii0
         "shr $8, %%edx          \n" // edx = 0000  0000  aaaa3 aaaa3 aaaa2 iiii2 aaaa1 iiii1
         "and $0x0000FF00, %%edx \n" // edx = 0000  0000  0000  0000  aaaa2 iiii2 0000  0000
         "or %%edx, %%ecx        \n" // ecx = aaaa3 iiii3 iiii3 iiii3 aaaa2 iiii2 0000  0000
         "and $0x00000F00, %%edx \n" // edx = 0000  0000  0000  0000  0000  iiii2 0000  0000
         "shr $4, %%edx          \n" // edx = 0000  0000  0000  0000  0000  0000  iiii2 0000
         "or %%edx, %%ecx        \n" // ecx = aaaa3 iiii3 iiii3 iiii3 aaaa2 iiii2 iiii2 0000
         "shr $4, %%edx          \n" // edx = 0000  0000  0000  0000  0000  0000  0000  iiii2
         "or %%edx, %%ecx        \n" // ecx = aaaa3 iiii3 iiii3 iiii3 aaaa2 iiii2 iiii2 iiii2

         "mov %%ecx, (%[_dst])     \n"
         "add $4, %[_dst]          \n"

         "decl %[_size]            \n"
         "jnz 0b \n"
         : [_src]"+S"(_src), [_dst]"+D"(_dst), [_size]"+g"(_size)
         :
         : "memory", "cc", "eax", "edx", "ecx"
         );

}

# 325 "../../src/TexConv.h"
void TexConv_A8_ARGB4444 (unsigned char * _src, unsigned char * _dst, int width, int height)
{
    int _size = (width * height) << 1;
# 393 "../../src/TexConv.h"
   //printf("TexConv_A8_ARGB4444\n");
   asm volatile (
         //"tc1_loop:              \n"
         "0: \n"
         "mov (%[src]), %%eax     \n"
         "add $4, %[src]          \n"

         // aaaa3 aaaa3 aaaa2 aaaa2 aaaa1 aaaa1 aaaa0 aaaa0
         // aaaa1 rrrr1 gggg1 bbbb1 aaaa0 rrrr0 gggg0 bbbb0
         // aaaa3 rrrr3 gggg3 bbbb3 aaaa2 rrrr2 gggg2 bbbb2
         "mov %%eax, %%edx       \n"
         "and $0x0000F000, %%eax \n" // eax = 00 00 00 00 a1 00 00 00
         "shl $16, %%eax         \n" // eax = a1 00 00 00 00 00 00 00
         "mov %%eax, %%ecx       \n" // ecx = a1 00 00 00 00 00 00 00
         "shr $4, %%eax          \n"
         "or %%eax, %%ecx        \n" // ecx = a1 a1 00 00 00 00 00 00
         "shr $4, %%eax          \n"
         "or %%eax, %%ecx        \n" // ecx = a1 a1 a1 00 00 00 00 00
         "shr $4, %%eax          \n"
         "or %%eax, %%ecx        \n" // ecx = a1 a1 a1 a1 00 00 00 00

         "mov %%edx, %%eax       \n"
         "and $0x000000F0, %%eax \n" // eax = 00 00 00 00 00 00 a0 00
         "shl $8, %%eax          \n" // eax = 00 00 00 00 a0 00 00 00
         "or %%eax, %%ecx        \n"
         "shr $4, %%eax          \n"
         "or %%eax, %%ecx        \n"
         "shr $4, %%eax          \n"
         "or %%eax, %%ecx        \n"
         "shr $4, %%eax          \n"
         "or %%eax, %%ecx        \n" // ecx = a1 a1 a1 a1 a0 a0 a0 a0

         "mov %%ecx, (%[_dst])     \n"
         "add $4, %[_dst]          \n"

         "mov %%edx, %%eax       \n" // eax = a3 a3 a2 a2 a1 a1 a0 a0
         "and $0xF0000000, %%eax \n" // eax = a3 00 00 00 00 00 00 00
         "mov %%eax, %%ecx       \n" // ecx = a3 00 00 00 00 00 00 00
         "shr $4, %%eax          \n"
         "or %%eax, %%ecx        \n" // ecx = a3 a3 00 00 00 00 00 00
         "shr $4, %%eax          \n"
         "or %%eax, %%ecx        \n" // ecx = a3 a3 a3 00 00 00 00 00
         "shr $4, %%eax          \n"
         "or %%eax, %%ecx        \n" // ecx = a3 a3 a3 a3 00 00 00 00

         "and $0x00F00000, %%edx \n" // eax = 00 00 a2 00 00 00 00 00
         "shr $8, %%edx          \n" // eax = 00 00 00 00 a2 00 00 00
         "or %%edx, %%ecx        \n"
         "shr $4, %%edx          \n"
         "or %%edx, %%ecx        \n"
         "shr $4, %%edx          \n"
         "or %%edx, %%ecx        \n"
         "shr $4, %%edx          \n"
         "or %%edx, %%ecx        \n" // ecx = a3 a3 a3 a3 a2 a2 a2 a2

         "mov %%ecx, (%[_dst])     \n"
         "add $4, %[_dst]          \n"

         "decl %[_size]            \n"
         "jnz 0b \n"
         : [src]"+S"(_src), [_dst]"+D"(_dst), [_size]"+g"(_size)
         :
         : "memory", "cc", "eax", "ecx", "edx"
         );

}

