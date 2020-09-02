# 95 "../../src/RDP_Texture.h"
inline void UnswapCopy( void *src, void *dest, unsigned int numBytes )
{
# 215 "../../src/RDP_Texture.h"
   unsigned int saveEBX;
   asm volatile ("mov           %%ebx, %2         \n"
         "mov       $0, %%ecx         \n"
         "mov       %0, %%esi         \n"
         "mov       %1, %%edi         \n"

         "mov       %%esi, %%ebx      \n"
         "and       $3, %%ebx         \n" // ebx = number of leading bytes

         "cmp       $0, %%ebx         \n"
         "jz            2f                \n" //jz      StartDWordLoop
         "neg       %%ebx             \n"
         "add       $4, %%ebx         \n"

         "cmp       %3, %%ebx         \n"
         "jle           0f                \n" //jle     NotGreater
         "mov       %3, %%ebx         \n"
         "0:                              \n" //NotGreater:
         "mov       %%ebx, %%ecx      \n"
         "xor       $3, %%esi         \n"
         "1:                              \n" //LeadingLoop:                // Copies leading bytes, in reverse order (un-swaps)
         "mov       (%%esi), %%al     \n"
         "mov       %%al, (%%edi)     \n"
         "sub       $1, %%esi         \n"
         "add       $1, %%edi         \n"
         "loop          1b                \n" //loop     LeadingLoop
         "add       $5, %%esi         \n"

         "2:                              \n" //StartDWordLoop:
         "mov       %3, %%ecx         \n"
         "sub       %%ebx, %%ecx      \n" // Don't copy what's already been copied

         "mov       %%ecx, %%ebx      \n"
         "and       $3, %%ebx         \n"
         //     add     ecx, 3          // Round up to nearest dword
         "shr       $2, %%ecx         \n"

         "cmp       $0, %%ecx         \n" // If there's nothing to do, don't do it
         "jle           4f                \n" //jle     StartTrailingLoop

         // Copies from source to destination, bswap-ing first
         "3:                              \n" //DWordLoop:
         "mov       (%%esi), %%eax    \n"
         "bswap %%eax                     \n"
         "mov       %%eax, (%%edi)    \n"
         "add       $4, %%esi         \n"
         "add       $4, %%edi         \n"
         "loop          3b                \n" //loop    DWordLoop
         "4:                              \n" //StartTrailingLoop:
         "cmp       $0, %%ebx         \n"
         "jz            6f                \n" //jz      Done
         "mov       %%ebx, %%ecx      \n"
         "xor       $3, %%esi         \n"

         "5:                              \n" //TrailingLoop:
         "mov       (%%esi), %%al     \n"
         "mov       %%al, (%%edi)     \n"
         "sub       $1, %%esi         \n"
         "add       $1, %%edi         \n"
         "loop          5b                \n" //loop    TrailingLoop
         "6:                              \n" //Done:
         "mov           %2, %%ebx         \n"
         :
         : "m"(src), "m"(dest), "m"(saveEBX), "m"(numBytes)
         : "memory", "cc", "%ecx", "%esi", "%edi", "%eax"
         );

}

# 284 "../../src/RDP_Texture.h"
inline void DWordInterleave( void *mem, unsigned int numDWords )
{
# 315 "../../src/RDP_Texture.h"
   unsigned int saveEBX;
   asm volatile ("mov           %%ebx, %2          \n"
         "mov       %0, %%esi          \n"
         "mov       %0, %%edi          \n"
         "add       $4, %%edi          \n"
         "mov       %1, %%ecx          \n"
         "0:                               \n" //DWordInterleaveLoop:
         "mov       (%%esi), %%eax     \n"
         "mov       (%%edi), %%ebx     \n"
         "mov       %%ebx, (%%esi)     \n"
         "mov       %%eax, (%%edi)     \n"
         "add       $8, %%esi          \n"
         "add       $8, %%edi          \n"
         "loop          0b                 \n" //loop   DWordInterleaveLoop
         "mov           %2, %%ebx          \n"
         :
         : "m"(mem), "m"(numDWords), "m"(saveEBX)
         : "memory", "cc", "%esi", "%edi", "%ecx", "%eax"
         );

}

# 337 "../../src/RDP_Texture.h"
inline void QWordInterleave( void *mem, unsigned int numDWords )
{
# 379 "../../src/RDP_Texture.h"
   unsigned int saveEBX;
   asm volatile("mov            %%ebx, %2          \n"
        // Interleave the line on the qword
        "mov        %0, %%esi          \n"
        "mov        %0, %%edi          \n"
        "add        $8, %%edi          \n"
        "mov        %1, %%ecx          \n"
        "shr        $1, %%ecx          \n"
        "0:                                \n" //QWordInterleaveLoop:
        "mov        (%%esi), %%eax     \n"
        "mov        (%%edi), %%ebx     \n"
        "mov        %%ebx, (%%esi)     \n"
        "mov        %%eax, (%%edi)     \n"
        "add        $4, %%esi          \n"
        "add        $4, %%edi          \n"
        "mov        (%%esi), %%eax     \n"
        "mov        (%%edi), %%ebx     \n"
        "mov        %%ebx, (%%esi)     \n"
        "mov        %%eax, (%%edi)     \n"
        "add        $12, %%esi         \n"
        "add        $12, %%edi         \n"
        "loop           0b                 \n" //loop   QWordInterleaveLoop
        "mov            %2, %%ebx          \n"
        :
        : "m"(mem), "m"(numDWords), "m"(saveEBX)
        : "memory", "cc", "%esi", "%edi", "%ecx", "%eax"
        );

}

# 409 "../../src/RDP_Texture.h"
inline unsigned int swapdword( unsigned int value )
{
# 425 "../../src/RDP_Texture.h"
  asm volatile("bswapl %0 \n"
               : "+r"(value)
               :
               :
               );
   return value;






}

# 439 "../../src/RDP_Texture.h"
inline unsigned short swapword( unsigned short value )
{







  asm volatile("xchg  %%al, %%ah    \n"
               : "+a"(value)
               :
               :
               );
  return value;




}

