unsigned int __builtin_object_size (const void *, int);
void * __builtin___memset_chk (void *, int, unsigned int, unsigned int);

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 101 "/usr/include/SDL/SDL_stdinc.h"
typedef uint16_t Uint16;

# 103 "/usr/include/SDL/SDL_stdinc.h"
typedef uint32_t Uint32;

# 108 "/usr/include/SDL/SDL_stdinc.h"
typedef uint64_t Uint64;

# 75 "/usr/include/SDL/SDL_endian.h"
static __inline__ Uint16 SDL_Swap16(Uint16 x)
{
 __asm__("xchgb %b0,%h0" : "=q" (x) : "0" (x));
 return x;
}

# 108 "/usr/include/SDL/SDL_endian.h"
static __inline__ Uint32 SDL_Swap32(Uint32 x)
{
 __asm__("bswap %0" : "=r" (x) : "0" (x));
 return x;
}

# 144 "/usr/include/SDL/SDL_endian.h"
static __inline__ Uint64 SDL_Swap64(Uint64 x)
{
 union {
  struct { Uint32 a,b; } s;
  Uint64 u;
 } v;
 v.u = x;
 __asm__("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
         : "=r" (v.s.a), "=r" (v.s.b)
         : "0" (v.s.a), "1" (v.s.b));
 return v.u;
}

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 22 "/usr/include/i386-linux-gnu/bits/string3.h"
extern void __warn_memset_zero_len (void);

# 75 "/usr/include/i386-linux-gnu/bits/string3.h"
extern __inline void *
 memset (void *__dest, int __ch, size_t __len)
{
  if (__builtin_constant_p (__len) && __len == 0
      && (!__builtin_constant_p (__ch) || __ch != 0))
    {
      __warn_memset_zero_len ();
      return __dest;
    }
  return __builtin___memset_chk (__dest, __ch, __len, __builtin_object_size (__dest, 0));
}

# 268 "/usr/include/SDL/SDL_audio.h"
extern void SDL_LockAudio(void);

# 269 "/usr/include/SDL/SDL_audio.h"
extern void SDL_UnlockAudio(void);

# 133 "linux/../cfg.h"
extern unsigned char soundon;

# 42 "linux/audio.c"
unsigned char *sdl_audio_buffer = 0;

# 43 "linux/audio.c"
int sdl_audio_buffer_len = 0, sdl_audio_buffer_fill = 0;

# 44 "linux/audio.c"
int sdl_audio_buffer_head = 0, sdl_audio_buffer_tail = 0;

# 207 "linux/audio.c"
void SoundWrite_sdl()
{
  extern int DSPBuffer[];
  extern unsigned char DSPDisable;
  extern unsigned int BufferSizeB, BufferSizeW, T36HZEnabled;

  // Process sound
  BufferSizeB = 256;
  BufferSizeW = BufferSizeB+BufferSizeB;

  // take care of the things we left behind last time
  SDL_LockAudio();
  while (sdl_audio_buffer_fill < sdl_audio_buffer_len)
  {
    short *p = (short*)&sdl_audio_buffer[sdl_audio_buffer_tail];

    if (soundon && !DSPDisable) { __asm__ __volatile__ ( "pushal""\n\t" "call ProcessSoundBuffer""\n\t" "popal""\n\t" );; }

    if (T36HZEnabled)
    {
      memset(p, 0, BufferSizeW);
    }
    else
    {
      int *d = DSPBuffer, *end_d = DSPBuffer+BufferSizeB;

      for (; d < end_d; d++, p++)
      {
        if ((unsigned int)(*d + 0x7fff) < 0xffff) { *p = *d; continue; }
        if (*d > 0x7fff) { *p = 0x7fff; }
        else { *p = 0x8001; }
      }
    }

    sdl_audio_buffer_fill += BufferSizeW;
    sdl_audio_buffer_tail += BufferSizeW;
    if (sdl_audio_buffer_tail >= sdl_audio_buffer_len) { sdl_audio_buffer_tail = 0; }
  }
  SDL_UnlockAudio();
}

