# 210 "/usr/lib/gcc/i586-linux-gnu/4.9/include/cpuid.h"
static __inline unsigned int
__get_cpuid_max (unsigned int __ext, unsigned int *__sig)
{
  unsigned int __eax, __ebx, __ecx, __edx;


  /* See if we can use cpuid.  On AMD64 we always can.  */

  __asm__ ("pushf{l|d}\n\t"
    "pushf{l|d}\n\t"
    "pop{l}\t%0\n\t"
    "mov{l}\t{%0, %1|%1, %0}\n\t"
    "xor{l}\t{%2, %0|%0, %2}\n\t"
    "push{l}\t%0\n\t"
    "popf{l|d}\n\t"
    "pushf{l|d}\n\t"
    "pop{l}\t%0\n\t"
    "popf{l|d}\n\t"
    : "=&r" (__eax), "=&r" (__ebx)
    : "i" (0x00200000));
# 247 "/usr/lib/gcc/i586-linux-gnu/4.9/include/cpuid.h" 3 4
  if (!((__eax ^ __ebx) & 0x00200000))
    return 0;


  /* Host supports cpuid.  Return highest supported cpuid input value.  */
  __asm__ ("cpuid\n\t" : "=a" (__eax), "=b" (__ebx), "=c" (__ecx), "=d" (__edx) : "0" (__ext));

  if (__sig)
    *__sig = __ebx;

  return __eax;
}

# 265 "/usr/lib/gcc/i586-linux-gnu/4.9/include/cpuid.h"
static __inline int
__get_cpuid (unsigned int __level,
      unsigned int *__eax, unsigned int *__ebx,
      unsigned int *__ecx, unsigned int *__edx)
{
  unsigned int __ext = __level & 0x80000000;

  if (__get_cpuid_max (__ext, 0) < __level)
    return 0;

  __asm__ ("cpuid\n\t" : "=a" (*__eax), "=b" (*__ebx), "=c" (*__ecx), "=d" (*__edx) : "0" (__level));
  return 1;
}

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 55 "havege.h"
typedef int (*pRawIn)(volatile uint32_t *pData, uint32_t szData);

# 29 "havegecollect.h"
typedef struct h_collect {
   void *havege_app; /* Application block             */
   uint32_t havege_idx; /* Identifer                     */
   uint32_t havege_szCollect; /* Size of collection buffer     */
   uint32_t havege_raw; /* RAW mode control flags        */
   uint32_t havege_szFill; /* Fill size                     */
   uint32_t havege_nptr; /* Input pointer                 */
   pRawIn havege_rawInput; /* Injection function            */
   pRawIn havege_testInput; /* Injection function for test   */
   uint32_t havege_cdidx; /* normal mode control flags     */
   uint32_t *havege_pwalk; /* Instance variable             */
   uint32_t havege_andpt; /* Instance variable             */
   uint32_t havege_PT; /* Instance variable             */
   uint32_t havege_PT2; /* Instance variable             */
   uint32_t havege_pt2; /* Instance variable             */
   uint32_t havege_PTtest; /* Instance variable             */
   uint32_t havege_tic; /* Instance variable             */
   uint32_t *havege_tics; /* loop timer noise buffer       */
   uint32_t havege_err; /* H_ERR enum for status         */
   void *havege_tests; /* opague test context           */
   void *havege_extra; /* other allocations             */
   uint32_t havege_bigarray[1]; /* collection buffer             */
} volatile H_COLLECT;

# 68 "havegecollect.c"
typedef enum {
   LOOP_NEXT, /* Next loop  */
   LOOP_ENTER, /* First loop */
   LOOP_EXIT /* Last loop  */
} LOOP_BRANCH;

# 130 "havegecollect.c"
inline static uint32_t ror32(const uint32_t value, const uint32_t shift) {
   return (value >> shift) | (value << (32 - shift));
}

# 302 "havegecollect.c"
static LOOP_BRANCH havege_cp( /* RETURN: branch to take */
   H_COLLECT *h_ctxt, /* IN: collection context */
   uint32_t i, /* IN: collection offset  */
   uint32_t n, /* IN: iteration index    */
   char *p) /* IN: code pointer       */
{

   if (h_ctxt->havege_cdidx <= 40 /* Max interations per collection loop       */)
      return i < h_ctxt->havege_szCollect? LOOP_ENTER : LOOP_EXIT;
   ((char **)(h_ctxt->havege_bigarray))[n] = p;
   if (n==0) h_ctxt->havege_cdidx = 0;
   return LOOP_NEXT;
}

# 320 "havegecollect.c"
static int havege_gather( /* RETURN: 1 if initialized    */
   H_COLLECT * h_ctxt) /* IN:     collector context  */
{
   uint32_t i=0,pt=0,inter=0;
   uint32_t *Pt0, *Pt1, *Pt2, *Pt3, *Ptinter;
# 336 "havegecollect.c"
loop_enter:
loop40: if (40 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,40,&&loop40)) { case LOOP_NEXT: goto loop39; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 339 "havegecollect.c" 2
loop39: if (39 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,39,&&loop39)) { case LOOP_NEXT: goto loop38; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 341 "havegecollect.c" 2
loop38: if (38 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,38,&&loop38)) { case LOOP_NEXT: goto loop37; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 343 "havegecollect.c" 2
loop37: if (37 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,37,&&loop37)) { case LOOP_NEXT: goto loop36; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 345 "havegecollect.c" 2
loop36: if (36 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,36,&&loop36)) { case LOOP_NEXT: goto loop35; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 347 "havegecollect.c" 2
loop35: if (35 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,35,&&loop35)) { case LOOP_NEXT: goto loop34; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 349 "havegecollect.c" 2
loop34: if (34 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,34,&&loop34)) { case LOOP_NEXT: goto loop33; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 351 "havegecollect.c" 2
loop33: if (33 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,33,&&loop33)) { case LOOP_NEXT: goto loop32; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 353 "havegecollect.c" 2
loop32: if (32 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,32,&&loop32)) { case LOOP_NEXT: goto loop31; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 355 "havegecollect.c" 2
loop31: if (31 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,31,&&loop31)) { case LOOP_NEXT: goto loop30; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 357 "havegecollect.c" 2
loop30: if (30 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,30,&&loop30)) { case LOOP_NEXT: goto loop29; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 359 "havegecollect.c" 2
loop29: if (29 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,29,&&loop29)) { case LOOP_NEXT: goto loop28; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 361 "havegecollect.c" 2
loop28: if (28 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,28,&&loop28)) { case LOOP_NEXT: goto loop27; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 363 "havegecollect.c" 2
loop27: if (27 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,27,&&loop27)) { case LOOP_NEXT: goto loop26; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 365 "havegecollect.c" 2
loop26: if (26 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,26,&&loop26)) { case LOOP_NEXT: goto loop25; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 367 "havegecollect.c" 2
loop25: if (25 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,25,&&loop25)) { case LOOP_NEXT: goto loop24; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 369 "havegecollect.c" 2
loop24: if (24 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,24,&&loop24)) { case LOOP_NEXT: goto loop23; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 371 "havegecollect.c" 2
loop23: if (23 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,23,&&loop23)) { case LOOP_NEXT: goto loop22; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 373 "havegecollect.c" 2
loop22: if (22 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,22,&&loop22)) { case LOOP_NEXT: goto loop21; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 375 "havegecollect.c" 2
loop21: if (21 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,21,&&loop21)) { case LOOP_NEXT: goto loop20; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 377 "havegecollect.c" 2
loop20: if (20 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,20,&&loop20)) { case LOOP_NEXT: goto loop19; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 379 "havegecollect.c" 2
loop19: if (19 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,19,&&loop19)) { case LOOP_NEXT: goto loop18; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 381 "havegecollect.c" 2
loop18: if (18 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,18,&&loop18)) { case LOOP_NEXT: goto loop17; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 383 "havegecollect.c" 2
loop17: if (17 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,17,&&loop17)) { case LOOP_NEXT: goto loop16; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 385 "havegecollect.c" 2
loop16: if (16 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,16,&&loop16)) { case LOOP_NEXT: goto loop15; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 387 "havegecollect.c" 2
loop15: if (15 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,15,&&loop15)) { case LOOP_NEXT: goto loop14; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 389 "havegecollect.c" 2
loop14: if (14 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,14,&&loop14)) { case LOOP_NEXT: goto loop13; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 391 "havegecollect.c" 2
loop13: if (13 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,13,&&loop13)) { case LOOP_NEXT: goto loop12; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 393 "havegecollect.c" 2
loop12: if (12 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,12,&&loop12)) { case LOOP_NEXT: goto loop11; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 395 "havegecollect.c" 2
loop11: if (11 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,11,&&loop11)) { case LOOP_NEXT: goto loop10; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 397 "havegecollect.c" 2
loop10: if (10 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,10,&&loop10)) { case LOOP_NEXT: goto loop9; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 399 "havegecollect.c" 2
loop9: if (9 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,9,&&loop9)) { case LOOP_NEXT: goto loop8; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 401 "havegecollect.c" 2
loop8: if (8 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,8,&&loop8)) { case LOOP_NEXT: goto loop7; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 403 "havegecollect.c" 2
loop7: if (7 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,7,&&loop7)) { case LOOP_NEXT: goto loop6; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 405 "havegecollect.c" 2
loop6: if (6 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,6,&&loop6)) { case LOOP_NEXT: goto loop5; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 407 "havegecollect.c" 2
loop5: if (5 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,5,&&loop5)) { case LOOP_NEXT: goto loop4; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 409 "havegecollect.c" 2
loop4: if (4 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,4,&&loop4)) { case LOOP_NEXT: goto loop3; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 411 "havegecollect.c" 2
loop3: if (3 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,3,&&loop3)) { case LOOP_NEXT: goto loop2; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 413 "havegecollect.c" 2
loop2: if (2 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,2,&&loop2)) { case LOOP_NEXT: goto loop1; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 415 "havegecollect.c" 2
loop1: if (1 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,1,&&loop1)) { case LOOP_NEXT: goto loop0; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
# 1 "oneiteration.h" 1
/**
 ** Simple entropy harvester based upon the havege RNG
 **
 ** Copyright 2009-2013 Gary Wuertz gary@issiweb.com
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, either version 3 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ** This source is an adaptation of work released as
 **
 ** Copyright (C) 2006 - André Seznec - Olivier Rochecouste
 **
 ** under version 2.1 of the GNU Lesser General Public License
 **
 ** The original form is retained with minor variable renames for
 ** more consistent macro itilization. See havegecollect.c for
 ** details.
 */

/* ------------------------------------------------------------------------
 * On average, one iteration accesses two 8-word blocks in the PWALK
 * table, and generates 16 words in the RESULT array.
 *
 * The data read in the Walk table are updated and permuted after each use.
 * The result of the hardware clock counter read is used for this update.
 *
 * 21 conditional tests are present. The conditional tests are grouped in
 * two nested  groups of 10 conditional tests and 1 test that controls the
 * permutation.
 *
 * In average, there should be 4 tests executed and, in average, 2 of them
 * should be mispredicted.
 * ------------------------------------------------------------------------
 */

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PT) >> 20;

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
  pt = ((h_ctxt->havege_PT) >> 18) & 7;

  (h_ctxt->havege_PT) = (h_ctxt->havege_PT) & (h_ctxt->havege_andpt);

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT)];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2)];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 1];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 4];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 1) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 2) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 3) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 4) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 2];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 2];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 3];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 6];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  if ((h_ctxt->havege_PTtest) & 1) {
    Ptinter = Pt0;
    Pt2 = Pt0;
    Pt0 = Ptinter;
  }

  (h_ctxt->havege_PTtest) = ((h_ctxt->havege_PT2) >> 18);
  inter = ror32(*Pt0, 5) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 6) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;

  __asm__ volatile("rdtsc;movl %%eax,%0":"=m"((h_ctxt->havege_tic))::"ax","dx");

  *Pt2 = ror32(*Pt2, 7) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 8) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 4];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 1];

  (h_ctxt->havege_PT2) = ((h_ctxt->havege_bigarray)[(i - 8) ^ (h_ctxt->havege_pt2)] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ (h_ctxt->havege_pt2) ^ 7]);
  (h_ctxt->havege_PT2) = (((h_ctxt->havege_PT2) & (h_ctxt->havege_andpt)) & (0xfffffff7)) ^ (((h_ctxt->havege_PT) ^ 8) & 0x8);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_pt2) = (((h_ctxt->havege_PT2) >> 28) & 7);

  if ((h_ctxt->havege_PTtest) & 1) {
    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
    if ((h_ctxt->havege_PTtest) & 1) {
      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
      if ((h_ctxt->havege_PTtest) & 1) {
        (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
        if ((h_ctxt->havege_PTtest) & 1) {
          (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
          if ((h_ctxt->havege_PTtest) & 1) {
            (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
            if ((h_ctxt->havege_PTtest) & 1) {
              (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
              if ((h_ctxt->havege_PTtest) & 1) {
                (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                if ((h_ctxt->havege_PTtest) & 1) {
                  (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                  if ((h_ctxt->havege_PTtest) & 1) {
                    (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    if ((h_ctxt->havege_PTtest) & 1) {
                      (h_ctxt->havege_PTtest) ^= 3; (h_ctxt->havege_PTtest) = (h_ctxt->havege_PTtest) >> 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  };

  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 5];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 5];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 9) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 10) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 11) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 12) ^ (h_ctxt->havege_tic);

  Pt0 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 6];
  Pt1 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 3];
  Pt2 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ 7];
  Pt3 = &(h_ctxt->havege_pwalk)[(h_ctxt->havege_PT2) ^ 7];

  (h_ctxt->havege_bigarray)[i++] ^= *Pt0;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt1;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt2;
  (h_ctxt->havege_bigarray)[i++] ^= *Pt3;

  inter = ror32(*Pt0, 13) ^ (h_ctxt->havege_tic);
  *Pt0 = ror32(*Pt1, 14) ^ (h_ctxt->havege_tic);
  *Pt1 = inter;
  *Pt2 = ror32(*Pt2, 15) ^ (h_ctxt->havege_tic);
  *Pt3 = ror32(*Pt3, 16) ^ (h_ctxt->havege_tic);

  /* avoid PT and PT2 to point on the same cache block */
  (h_ctxt->havege_PT) = ((((h_ctxt->havege_bigarray)[(i - 8) ^ pt] ^ (h_ctxt->havege_pwalk)[(h_ctxt->havege_PT) ^ pt ^ 7])) &
        (0xffffffef)) ^ (((h_ctxt->havege_PT2) ^ 0x10) & 0x10);
# 417 "havegecollect.c" 2
loop0: if (0 < h_ctxt->havege_cdidx) { switch(havege_cp(h_ctxt,i,0,&&loop0)) { case LOOP_NEXT: goto loop0; case LOOP_ENTER: goto loop_enter; case LOOP_EXIT: goto loop_exit; } }
   (void)havege_cp(h_ctxt, i,0,&&loop0);
loop_exit:
   return (h_ctxt->havege_andpt)==0? 0 : 1;
}

# 459 "havegetune.c"
static void cpuid( /* RETURN: none               */
   int fn, /* IN: function code          */
   int sfn, /* IN: subfunction            */
   uint32_t *regs) /* IN-OUT: Workspace          */
{
   regs[2] = sfn;
   { register int ecx asm ("ecx") = regs[2]; __asm__ ("cpuid\n\t" : "=a" (regs[0]), "=b" (regs[1]), "=c" (regs[2]), "=d" (regs[3]) : "0" (fn)); (void) ecx; };
}

