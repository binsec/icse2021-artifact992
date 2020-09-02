# 222 "../../include/windef.h"
typedef unsigned int DWORD;

# 441 "../../include/winnt.h"
typedef int LONG;

# 557 "../../include/winnt.h"
typedef void *HANDLE;

# 2258 "../../include/winnt.h"
struct _TEB;

# 2261 "../../include/winnt.h"
static inline struct _TEB * NtCurrentTeb(void)
{
    struct _TEB *teb;
    __asm__(".byte 0x64\n\tmovl (0x18),%0" : "=r" (teb));
    return teb;
}

# 2451 "../../include/winbase.h"
static inline LONG InterlockedCompareExchange( LONG volatile *dest, LONG xchg, LONG compare )
{
    LONG ret;
    __asm__ __volatile__( "lock; cmpxchgl %2,(%1)"
                          : "=a" (ret) : "r" (dest), "r" (xchg), "0" (compare) : "memory" );
    return ret;
}

# 2459 "../../include/winbase.h"
static inline LONG InterlockedExchange( LONG volatile *dest, LONG val )
{
    LONG ret;
    __asm__ __volatile__( "lock; xchgl %0,(%1)"
                          : "=r" (ret) :"r" (dest), "0" (val) : "memory" );
    return ret;
}

# 2467 "../../include/winbase.h"
static inline LONG InterlockedExchangeAdd( LONG volatile *dest, LONG incr )
{
    LONG ret;
    __asm__ __volatile__( "lock; xaddl %0,(%1)"
                          : "=r" (ret) : "r" (dest), "0" (incr) : "memory" );
    return ret;
}

# 2618 "../../include/winbase.h"
static inline DWORD GetLastError(void)
{
    DWORD ret;



    __asm__ __volatile__( ".byte 0x64\n\tmovl 0x34,%0" : "=r" (ret) );

    return ret;
}

# 2629 "../../include/winbase.h"
static inline DWORD GetCurrentProcessId(void)
{
    DWORD ret;



    __asm__ __volatile__( ".byte 0x64\n\tmovl 0x20,%0" : "=r" (ret) );

    return ret;
}

# 2640 "../../include/winbase.h"
static inline DWORD GetCurrentThreadId(void)
{
    DWORD ret;



    __asm__ __volatile__( ".byte 0x64\n\tmovl 0x24,%0" : "=r" (ret) );

    return ret;
}

# 2651 "../../include/winbase.h"
static inline void SetLastError( DWORD err )
{



    __asm__ __volatile__( ".byte 0x64\n\tmovl %0,0x34" : : "r" (err) : "memory" );

}

# 2660 "../../include/winbase.h"
static inline HANDLE GetProcessHeap(void)
{
    HANDLE *pdb;




    __asm__ __volatile__( ".byte 0x64\n\tmovl 0x30,%0" : "=r" (pdb) );
    return pdb[0x18 / sizeof(HANDLE)]; /* get dword at offset 0x18 in pdb */

}

# 366 "../../include/wine/port.h"
static inline int interlocked_cmpxchg( int *dest, int xchg, int compare )
{
    int ret;
    __asm__ __volatile__( "lock; cmpxchgl %2,(%1)"
                          : "=a" (ret) : "r" (dest), "r" (xchg), "0" (compare) : "memory" );
    return ret;
}

# 374 "../../include/wine/port.h"
static inline void *interlocked_cmpxchg_ptr( void **dest, void *xchg, void *compare )
{
    void *ret;




    __asm__ __volatile__( "lock; cmpxchgl %2,(%1)"
                          : "=a" (ret) : "r" (dest), "r" (xchg), "0" (compare) : "memory" );

    return ret;
}

# 387 "../../include/wine/port.h"
static inline int interlocked_xchg( int *dest, int val )
{
    int ret;
    __asm__ __volatile__( "lock; xchgl %0,(%1)"
                          : "=r" (ret) : "r" (dest), "0" (val) : "memory" );
    return ret;
}

# 395 "../../include/wine/port.h"
static inline void *interlocked_xchg_ptr( void **dest, void *val )
{
    void *ret;




    __asm__ __volatile__( "lock; xchgl %0,(%1)"
                          : "=r" (ret) : "r" (dest), "0" (val) : "memory" );

    return ret;
}

# 408 "../../include/wine/port.h"
static inline int interlocked_xchg_add( int *dest, int incr )
{
    int ret;
    __asm__ __volatile__( "lock; xaddl %0,(%1)"
                          : "=r" (ret) : "r" (dest), "0" (incr) : "memory" );
    return ret;
}

# 182 "../../include/wine/library.h"
static inline unsigned short wine_get_cs(void) { unsigned short res; __asm__ __volatile__("movw %%" "cs" ",%w0" : "=r"(res)); return res; }

# 183 "../../include/wine/library.h"
static inline unsigned short wine_get_ds(void) { unsigned short res; __asm__ __volatile__("movw %%" "ds" ",%w0" : "=r"(res)); return res; }

# 184 "../../include/wine/library.h"
static inline unsigned short wine_get_es(void) { unsigned short res; __asm__ __volatile__("movw %%" "es" ",%w0" : "=r"(res)); return res; }

# 185 "../../include/wine/library.h"
static inline unsigned short wine_get_fs(void) { unsigned short res; __asm__ __volatile__("movw %%" "fs" ",%w0" : "=r"(res)); return res; }

# 186 "../../include/wine/library.h"
static inline unsigned short wine_get_gs(void) { unsigned short res; __asm__ __volatile__("movw %%" "gs" ",%w0" : "=r"(res)); return res; }

# 187 "../../include/wine/library.h"
static inline unsigned short wine_get_ss(void) { unsigned short res; __asm__ __volatile__("movw %%" "ss" ",%w0" : "=r"(res)); return res; }

# 188 "../../include/wine/library.h"
static inline void wine_set_fs(int val) { __asm__("movw %w0,%%" "fs" : : "r" (val)); }

# 189 "../../include/wine/library.h"
static inline void wine_set_gs(int val) { __asm__("movw %w0,%%" "gs" : : "r" (val)); }

# 26 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned int __u32;

# 30 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned long long __u64;

# 7 "/usr/include/i386-linux-gnu/asm/swab.h"
static __inline__ __u32 __arch_swab32(__u32 val)
{
 __asm__("bswapl %0" : "=r" (val) : "0" (val));
 return val;
}

# 14 "/usr/include/i386-linux-gnu/asm/swab.h"
static __inline__ __u64 __arch_swab64(__u64 val)
{

 union {
  struct {
   __u32 a;
   __u32 b;
  } s;
  __u64 u;
 } v;
 v.u = val;
 __asm__("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
     : "=r" (v.s.a), "=r" (v.s.b)
     : "0" (v.s.a), "1" (v.s.b));
 return v.u;




}

# 208 "../../include/windef.h"
typedef unsigned char BYTE;

# 130 "../../include/basetsd.h"
typedef unsigned long ULONG_PTR;

# 433 "../../include/winnt.h"
typedef void *PVOID;

# 882 "../../include/winnt.h"
typedef struct _FLOATING_SAVE_AREA
{
    DWORD ControlWord;
    DWORD StatusWord;
    DWORD TagWord;
    DWORD ErrorOffset;
    DWORD ErrorSelector;
    DWORD DataOffset;
    DWORD DataSelector;
    BYTE RegisterArea[80];
    DWORD Cr0NpxState;
} FLOATING_SAVE_AREA;

# 897 "../../include/winnt.h"
typedef struct _CONTEXT
{
    DWORD ContextFlags;

    /* These are selected by CONTEXT_DEBUG_REGISTERS */
    DWORD Dr0;
    DWORD Dr1;
    DWORD Dr2;
    DWORD Dr3;
    DWORD Dr6;
    DWORD Dr7;

    /* These are selected by CONTEXT_FLOATING_POINT */
    FLOATING_SAVE_AREA FloatSave;

    /* These are selected by CONTEXT_SEGMENTS */
    DWORD SegGs;
    DWORD SegFs;
    DWORD SegEs;
    DWORD SegDs;

    /* These are selected by CONTEXT_INTEGER */
    DWORD Edi;
    DWORD Esi;
    DWORD Ebx;
    DWORD Edx;
    DWORD Ecx;
    DWORD Eax;

    /* These are selected by CONTEXT_CONTROL */
    DWORD Ebp;
    DWORD Eip;
    DWORD SegCs;
    DWORD EFlags;
    DWORD Esp;
    DWORD SegSs;

    BYTE ExtendedRegisters[512];
} CONTEXT;

# 2023 "../../include/winnt.h"
typedef CONTEXT *PCONTEXT;

# 2198 "../../include/winnt.h"
typedef struct _EXCEPTION_RECORD
{
    DWORD ExceptionCode;
    DWORD ExceptionFlags;
    struct _EXCEPTION_RECORD *ExceptionRecord;

    PVOID ExceptionAddress;
    DWORD NumberParameters;
    ULONG_PTR ExceptionInformation[15];
} EXCEPTION_RECORD, *PEXCEPTION_RECORD;

# 2229 "../../include/winnt.h"
typedef DWORD (*PEXCEPTION_HANDLER)(PEXCEPTION_RECORD,struct _EXCEPTION_REGISTRATION_RECORD*,
                                    PCONTEXT,struct _EXCEPTION_REGISTRATION_RECORD **);

# 2232 "../../include/winnt.h"
typedef struct _EXCEPTION_REGISTRATION_RECORD
{
  struct _EXCEPTION_REGISTRATION_RECORD *Prev;
  PEXCEPTION_HANDLER Handler;
} EXCEPTION_REGISTRATION_RECORD;

# 204 "../../include/wine/exception.h"
static inline EXCEPTION_REGISTRATION_RECORD *__wine_push_frame( EXCEPTION_REGISTRATION_RECORD *frame )
{

    EXCEPTION_REGISTRATION_RECORD *prev;
    __asm__ __volatile__(".byte 0x64\n\tmovl (0),%0"
                         "\n\tmovl %0,(%1)"
                         "\n\t.byte 0x64\n\tmovl %1,(0)"
                         : "=&r" (prev) : "r" (frame) : "memory" );
    return prev;






}

# 221 "../../include/wine/exception.h"
static inline EXCEPTION_REGISTRATION_RECORD *__wine_pop_frame( EXCEPTION_REGISTRATION_RECORD *frame )
{

    __asm__ __volatile__(".byte 0x64\n\tmovl %0,(0)"
                         : : "r" (frame->Prev) : "memory" );
    return frame->Prev;






}

# 235 "../../include/wine/exception.h"
static inline EXCEPTION_REGISTRATION_RECORD *__wine_get_frame(void)
{

    EXCEPTION_REGISTRATION_RECORD *ret;
    __asm__ __volatile__(".byte 0x64\n\tmovl (0),%0" : "=r" (ret) );
    return ret;




}

# 264 "/usr/include/freetype2/config/ftconfig.h"
typedef signed int FT_Int32;

# 449 "/usr/include/freetype2/config/ftconfig.h"
static __inline__ FT_Int32
  FT_MulFix_i386( FT_Int32 a,
                  FT_Int32 b )
  {
    register FT_Int32 result;


    __asm__ __volatile__ (
      "imul  %%edx\n"
      "movl  %%edx, %%ecx\n"
      "sarl  $31, %%ecx\n"
      "addl  $0x8000, %%ecx\n"
      "addl  %%ecx, %%eax\n"
      "adcl  $0, %%edx\n"
      "shrl  $16, %%eax\n"
      "shll  $16, %%edx\n"
      "addl  %%edx, %%eax\n"
      : "=a"(result), "=d"(b)
      : "a"(a), "d"(b)
      : "%ecx", "cc" );
    return result;
  }

