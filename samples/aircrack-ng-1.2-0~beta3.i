;

# 34 "../../src/sha1-git.h"
typedef struct {
 unsigned long long size;
 unsigned int H[5];
 unsigned int W[16];
} blk_SHA_CTX;

# 69 "/usr/include/assert.h"
extern void __assert_fail (const char *__assertion, const char *__file,
      unsigned int __line, const char *__function);

# 441 "../../src/crypto.c"
int is_arp(void *wh, int len)
{
        int arpsize = 8 + 8 + 10*2;

        if(wh) {}
        /* remove non BROADCAST frames? could be anything, but
         * chances are good that we got an arp response tho.   */

        if (len == arpsize || len == 54)
            return 1;

        return 0;
}

# 455 "../../src/crypto.c"
int is_wlccp(void *wh, int len)
{
 int wlccpsize = 58;

 if(wh) {}

 if (len == wlccpsize)
  return 1;

 return 0;
}

# 487 "../../src/crypto.c"
int is_spantree(void *wh)
{
        if ( wh != ((void *)0) &&
      (memcmp( wh + 4, (unsigned char*)"\x01\x80\xC2\x00\x00\x00", 6 ) == 0 ||
              memcmp( wh + 16, (unsigned char*)"\x01\x80\xC2\x00\x00\x00", 6 ) == 0 ))
            return 1;

        return 0;
}

# 497 "../../src/crypto.c"
int is_cdp_vtp(void *wh)
{
        if ( memcmp( wh + 4, (unsigned char*)"\x01\x00\x0C\xCC\xCC\xCC", 6 ) == 0 ||
             memcmp( wh + 16, (unsigned char*)"\x01\x00\x0C\xCC\xCC\xCC", 6 ) == 0 )
            return 1;

        return 0;
}

# 509 "../../src/crypto.c"
int known_clear(void *clear, int *clen, int *weight, unsigned char *wh, int len)
{
        unsigned char *ptr = clear;
        int num;

        if(is_arp(wh, len)) /*arp*/
        {
            len = sizeof(("\xAA\xAA\x03\x00\x00\x00" "\x08\x06")) - 1;
            memcpy(ptr, ("\xAA\xAA\x03\x00\x00\x00" "\x08\x06"), len);
            ptr += len;

            /* arp hdr */
            len = 6;
            memcpy(ptr, "\x00\x01\x08\x00\x06\x04", len);
            ptr += len;

            /* type of arp */
            len = 2;
            if (memcmp(get_da(wh), "\xff\xff\xff\xff\xff\xff", 6) == 0)
                    memcpy(ptr, "\x00\x01", len);
            else
                    memcpy(ptr, "\x00\x02", len);
            ptr += len;

            /* src mac */
            len = 6;
            memcpy(ptr, get_sa(wh), len);
            ptr += len;

            len = ptr - ((unsigned char*)clear);
            *clen = len;
     if (weight)
                weight[0] = 256;
            return 1;

        }
        else if(is_wlccp(wh, len)) /*wlccp*/
        {
            len = sizeof("\xAA\xAA\x03\x00\x40\x96\x00\x00") - 1;
            memcpy(ptr, "\xAA\xAA\x03\x00\x40\x96\x00\x00", len);
            ptr += len;

            /* wlccp hdr */
            len = 4;
            memcpy(ptr, "\x00\x32\x40\x01", len);
            ptr += len;

            /* dst mac */
            len = 6;
            memcpy(ptr, get_da(wh), len);
            ptr += len;

            len = ptr - ((unsigned char*)clear);
            *clen = len;
     if (weight)
                weight[0] = 256;
            return 1;

        }
        else if(is_spantree(wh)) /*spantree*/
        {
            len = sizeof("\x42\x42\x03\x00\x00\x00\x00\x00") - 1;
            memcpy(ptr, "\x42\x42\x03\x00\x00\x00\x00\x00", len);
            ptr += len;

            len = ptr - ((unsigned char*)clear);
            *clen = len;
     if (weight)
                weight[0] = 256;
            return 1;
        }
        else if(is_cdp_vtp(wh)) /*spantree*/
        {
            len = sizeof("\xAA\xAA\x03\x00\x00\x0C\x20") - 1;
            memcpy(ptr, "\xAA\xAA\x03\x00\x00\x0C\x20", len);
            ptr += len;

            len = ptr - ((unsigned char*)clear);
            *clen = len;
     if (weight)
                weight[0] = 256;
            return 1;
        }
        else /* IP */
        {
                unsigned short iplen = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (len - 8); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

//                printf("Assuming IP %d\n", len);

                len = sizeof(("\xAA\xAA\x03\x00\x00\x00" "\x08\x00")) - 1;
                memcpy(ptr, ("\xAA\xAA\x03\x00\x00\x00" "\x08\x00"), len);
                ptr += len;

                //version=4; header_length=20; services=0
                len = 2;
                memcpy(ptr, "\x45\x00", len);
                ptr += len;

                //ip total length
                memcpy(ptr, &iplen, len);
                ptr += len;

  /* no guesswork */
  if (!weight) {
   *clen = ptr - ((unsigned char*)clear);
   return 1;
  }

  /* setting IP ID 0 is ok, as we
                 * bruteforce it later
		 */
                //ID=0
                len=2;
                memcpy(ptr, "\x00\x00", len);
                ptr += len;

                //ip flags=don't fragment
                len=2;
                memcpy(ptr, "\x40\x00", len);
                ptr += len;


                len = ptr - ((unsigned char*)clear);
                *clen = len;

                memcpy(clear+32, clear, len);
                memcpy(clear+32+14, "\x00\x00", 2); //ip flags=none

                num=2;
  ((weight) ? (void) (0) : __assert_fail ("weight", "../../src/crypto.c", 638, __PRETTY_FUNCTION__));
                weight[0] = 220;
                weight[1] = 36;

                return num;
        }
        *clen=0;
        return 1;
}

# 149 "../../src/sha1-git.c"
static void blk_SHA1_Block(blk_SHA_CTX *ctx, const unsigned int *data)
{
 unsigned int A,B,C,D,E;
 unsigned int array[16];

 A = ctx->H[0];
 B = ctx->H[1];
 C = ctx->H[2];
 D = ctx->H[3];
 E = ctx->H[4];

 /* Round 1 - iterations 0-16 take their input from 'data' */
 do { unsigned int TEMP = __bswap_32 (*(unsigned int *)(data + 0)); (*(volatile unsigned int *)&(array[(0)&15]) = (TEMP)); E += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (A)); __res; }) + ((((C^D)&B)^D)) + (0x5a827999); B = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (B)); __res; }); } while (0);
 do { unsigned int TEMP = __bswap_32 (*(unsigned int *)(data + 1)); (*(volatile unsigned int *)&(array[(1)&15]) = (TEMP)); D += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (E)); __res; }) + ((((B^C)&A)^C)) + (0x5a827999); A = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (A)); __res; }); } while (0);
 do { unsigned int TEMP = __bswap_32 (*(unsigned int *)(data + 2)); (*(volatile unsigned int *)&(array[(2)&15]) = (TEMP)); C += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (D)); __res; }) + ((((A^B)&E)^B)) + (0x5a827999); E = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (E)); __res; }); } while (0);
 do { unsigned int TEMP = __bswap_32 (*(unsigned int *)(data + 3)); (*(volatile unsigned int *)&(array[(3)&15]) = (TEMP)); B += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (C)); __res; }) + ((((E^A)&D)^A)) + (0x5a827999); D = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (D)); __res; }); } while (0);
 do { unsigned int TEMP = __bswap_32 (*(unsigned int *)(data + 4)); (*(volatile unsigned int *)&(array[(4)&15]) = (TEMP)); A += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (B)); __res; }) + ((((D^E)&C)^E)) + (0x5a827999); C = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (C)); __res; }); } while (0);
 do { unsigned int TEMP = __bswap_32 (*(unsigned int *)(data + 5)); (*(volatile unsigned int *)&(array[(5)&15]) = (TEMP)); E += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (A)); __res; }) + ((((C^D)&B)^D)) + (0x5a827999); B = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (B)); __res; }); } while (0);
 do { unsigned int TEMP = __bswap_32 (*(unsigned int *)(data + 6)); (*(volatile unsigned int *)&(array[(6)&15]) = (TEMP)); D += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (E)); __res; }) + ((((B^C)&A)^C)) + (0x5a827999); A = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (A)); __res; }); } while (0);
 do { unsigned int TEMP = __bswap_32 (*(unsigned int *)(data + 7)); (*(volatile unsigned int *)&(array[(7)&15]) = (TEMP)); C += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (D)); __res; }) + ((((A^B)&E)^B)) + (0x5a827999); E = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (E)); __res; }); } while (0);
 do { unsigned int TEMP = __bswap_32 (*(unsigned int *)(data + 8)); (*(volatile unsigned int *)&(array[(8)&15]) = (TEMP)); B += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (C)); __res; }) + ((((E^A)&D)^A)) + (0x5a827999); D = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (D)); __res; }); } while (0);
 do { unsigned int TEMP = __bswap_32 (*(unsigned int *)(data + 9)); (*(volatile unsigned int *)&(array[(9)&15]) = (TEMP)); A += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (B)); __res; }) + ((((D^E)&C)^E)) + (0x5a827999); C = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (C)); __res; }); } while (0);
 do { unsigned int TEMP = __bswap_32 (*(unsigned int *)(data + 10)); (*(volatile unsigned int *)&(array[(10)&15]) = (TEMP)); E += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (A)); __res; }) + ((((C^D)&B)^D)) + (0x5a827999); B = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (B)); __res; }); } while (0);
 do { unsigned int TEMP = __bswap_32 (*(unsigned int *)(data + 11)); (*(volatile unsigned int *)&(array[(11)&15]) = (TEMP)); D += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (E)); __res; }) + ((((B^C)&A)^C)) + (0x5a827999); A = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (A)); __res; }); } while (0);
 do { unsigned int TEMP = __bswap_32 (*(unsigned int *)(data + 12)); (*(volatile unsigned int *)&(array[(12)&15]) = (TEMP)); C += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (D)); __res; }) + ((((A^B)&E)^B)) + (0x5a827999); E = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (E)); __res; }); } while (0);
 do { unsigned int TEMP = __bswap_32 (*(unsigned int *)(data + 13)); (*(volatile unsigned int *)&(array[(13)&15]) = (TEMP)); B += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (C)); __res; }) + ((((E^A)&D)^A)) + (0x5a827999); D = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (D)); __res; }); } while (0);
 do { unsigned int TEMP = __bswap_32 (*(unsigned int *)(data + 14)); (*(volatile unsigned int *)&(array[(14)&15]) = (TEMP)); A += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (B)); __res; }) + ((((D^E)&C)^E)) + (0x5a827999); C = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (C)); __res; }); } while (0);
 do { unsigned int TEMP = __bswap_32 (*(unsigned int *)(data + 15)); (*(volatile unsigned int *)&(array[(15)&15]) = (TEMP)); E += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (A)); __res; }) + ((((C^D)&B)^D)) + (0x5a827999); B = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (B)); __res; }); } while (0);

 /* Round 1 - tail. Input from 512-bit mixing array */
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(16 +13)&15]) ^ (array[(16 +8)&15]) ^ (array[(16 +2)&15]) ^ (array[(16)&15]))); __res; }); (*(volatile unsigned int *)&(array[(16)&15]) = (TEMP)); D += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (E)); __res; }) + ((((B^C)&A)^C)) + (0x5a827999); A = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (A)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(17 +13)&15]) ^ (array[(17 +8)&15]) ^ (array[(17 +2)&15]) ^ (array[(17)&15]))); __res; }); (*(volatile unsigned int *)&(array[(17)&15]) = (TEMP)); C += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (D)); __res; }) + ((((A^B)&E)^B)) + (0x5a827999); E = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (E)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(18 +13)&15]) ^ (array[(18 +8)&15]) ^ (array[(18 +2)&15]) ^ (array[(18)&15]))); __res; }); (*(volatile unsigned int *)&(array[(18)&15]) = (TEMP)); B += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (C)); __res; }) + ((((E^A)&D)^A)) + (0x5a827999); D = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (D)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(19 +13)&15]) ^ (array[(19 +8)&15]) ^ (array[(19 +2)&15]) ^ (array[(19)&15]))); __res; }); (*(volatile unsigned int *)&(array[(19)&15]) = (TEMP)); A += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (B)); __res; }) + ((((D^E)&C)^E)) + (0x5a827999); C = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (C)); __res; }); } while (0);

 /* Round 2 */
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(20 +13)&15]) ^ (array[(20 +8)&15]) ^ (array[(20 +2)&15]) ^ (array[(20)&15]))); __res; }); (*(volatile unsigned int *)&(array[(20)&15]) = (TEMP)); E += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (A)); __res; }) + ((B^C^D)) + (0x6ed9eba1); B = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (B)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(21 +13)&15]) ^ (array[(21 +8)&15]) ^ (array[(21 +2)&15]) ^ (array[(21)&15]))); __res; }); (*(volatile unsigned int *)&(array[(21)&15]) = (TEMP)); D += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (E)); __res; }) + ((A^B^C)) + (0x6ed9eba1); A = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (A)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(22 +13)&15]) ^ (array[(22 +8)&15]) ^ (array[(22 +2)&15]) ^ (array[(22)&15]))); __res; }); (*(volatile unsigned int *)&(array[(22)&15]) = (TEMP)); C += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (D)); __res; }) + ((E^A^B)) + (0x6ed9eba1); E = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (E)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(23 +13)&15]) ^ (array[(23 +8)&15]) ^ (array[(23 +2)&15]) ^ (array[(23)&15]))); __res; }); (*(volatile unsigned int *)&(array[(23)&15]) = (TEMP)); B += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (C)); __res; }) + ((D^E^A)) + (0x6ed9eba1); D = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (D)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(24 +13)&15]) ^ (array[(24 +8)&15]) ^ (array[(24 +2)&15]) ^ (array[(24)&15]))); __res; }); (*(volatile unsigned int *)&(array[(24)&15]) = (TEMP)); A += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (B)); __res; }) + ((C^D^E)) + (0x6ed9eba1); C = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (C)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(25 +13)&15]) ^ (array[(25 +8)&15]) ^ (array[(25 +2)&15]) ^ (array[(25)&15]))); __res; }); (*(volatile unsigned int *)&(array[(25)&15]) = (TEMP)); E += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (A)); __res; }) + ((B^C^D)) + (0x6ed9eba1); B = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (B)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(26 +13)&15]) ^ (array[(26 +8)&15]) ^ (array[(26 +2)&15]) ^ (array[(26)&15]))); __res; }); (*(volatile unsigned int *)&(array[(26)&15]) = (TEMP)); D += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (E)); __res; }) + ((A^B^C)) + (0x6ed9eba1); A = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (A)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(27 +13)&15]) ^ (array[(27 +8)&15]) ^ (array[(27 +2)&15]) ^ (array[(27)&15]))); __res; }); (*(volatile unsigned int *)&(array[(27)&15]) = (TEMP)); C += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (D)); __res; }) + ((E^A^B)) + (0x6ed9eba1); E = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (E)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(28 +13)&15]) ^ (array[(28 +8)&15]) ^ (array[(28 +2)&15]) ^ (array[(28)&15]))); __res; }); (*(volatile unsigned int *)&(array[(28)&15]) = (TEMP)); B += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (C)); __res; }) + ((D^E^A)) + (0x6ed9eba1); D = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (D)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(29 +13)&15]) ^ (array[(29 +8)&15]) ^ (array[(29 +2)&15]) ^ (array[(29)&15]))); __res; }); (*(volatile unsigned int *)&(array[(29)&15]) = (TEMP)); A += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (B)); __res; }) + ((C^D^E)) + (0x6ed9eba1); C = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (C)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(30 +13)&15]) ^ (array[(30 +8)&15]) ^ (array[(30 +2)&15]) ^ (array[(30)&15]))); __res; }); (*(volatile unsigned int *)&(array[(30)&15]) = (TEMP)); E += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (A)); __res; }) + ((B^C^D)) + (0x6ed9eba1); B = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (B)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(31 +13)&15]) ^ (array[(31 +8)&15]) ^ (array[(31 +2)&15]) ^ (array[(31)&15]))); __res; }); (*(volatile unsigned int *)&(array[(31)&15]) = (TEMP)); D += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (E)); __res; }) + ((A^B^C)) + (0x6ed9eba1); A = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (A)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(32 +13)&15]) ^ (array[(32 +8)&15]) ^ (array[(32 +2)&15]) ^ (array[(32)&15]))); __res; }); (*(volatile unsigned int *)&(array[(32)&15]) = (TEMP)); C += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (D)); __res; }) + ((E^A^B)) + (0x6ed9eba1); E = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (E)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(33 +13)&15]) ^ (array[(33 +8)&15]) ^ (array[(33 +2)&15]) ^ (array[(33)&15]))); __res; }); (*(volatile unsigned int *)&(array[(33)&15]) = (TEMP)); B += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (C)); __res; }) + ((D^E^A)) + (0x6ed9eba1); D = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (D)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(34 +13)&15]) ^ (array[(34 +8)&15]) ^ (array[(34 +2)&15]) ^ (array[(34)&15]))); __res; }); (*(volatile unsigned int *)&(array[(34)&15]) = (TEMP)); A += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (B)); __res; }) + ((C^D^E)) + (0x6ed9eba1); C = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (C)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(35 +13)&15]) ^ (array[(35 +8)&15]) ^ (array[(35 +2)&15]) ^ (array[(35)&15]))); __res; }); (*(volatile unsigned int *)&(array[(35)&15]) = (TEMP)); E += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (A)); __res; }) + ((B^C^D)) + (0x6ed9eba1); B = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (B)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(36 +13)&15]) ^ (array[(36 +8)&15]) ^ (array[(36 +2)&15]) ^ (array[(36)&15]))); __res; }); (*(volatile unsigned int *)&(array[(36)&15]) = (TEMP)); D += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (E)); __res; }) + ((A^B^C)) + (0x6ed9eba1); A = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (A)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(37 +13)&15]) ^ (array[(37 +8)&15]) ^ (array[(37 +2)&15]) ^ (array[(37)&15]))); __res; }); (*(volatile unsigned int *)&(array[(37)&15]) = (TEMP)); C += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (D)); __res; }) + ((E^A^B)) + (0x6ed9eba1); E = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (E)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(38 +13)&15]) ^ (array[(38 +8)&15]) ^ (array[(38 +2)&15]) ^ (array[(38)&15]))); __res; }); (*(volatile unsigned int *)&(array[(38)&15]) = (TEMP)); B += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (C)); __res; }) + ((D^E^A)) + (0x6ed9eba1); D = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (D)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(39 +13)&15]) ^ (array[(39 +8)&15]) ^ (array[(39 +2)&15]) ^ (array[(39)&15]))); __res; }); (*(volatile unsigned int *)&(array[(39)&15]) = (TEMP)); A += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (B)); __res; }) + ((C^D^E)) + (0x6ed9eba1); C = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (C)); __res; }); } while (0);

 /* Round 3 */
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(40 +13)&15]) ^ (array[(40 +8)&15]) ^ (array[(40 +2)&15]) ^ (array[(40)&15]))); __res; }); (*(volatile unsigned int *)&(array[(40)&15]) = (TEMP)); E += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (A)); __res; }) + (((B&C)+(D&(B^C)))) + (0x8f1bbcdc); B = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (B)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(41 +13)&15]) ^ (array[(41 +8)&15]) ^ (array[(41 +2)&15]) ^ (array[(41)&15]))); __res; }); (*(volatile unsigned int *)&(array[(41)&15]) = (TEMP)); D += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (E)); __res; }) + (((A&B)+(C&(A^B)))) + (0x8f1bbcdc); A = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (A)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(42 +13)&15]) ^ (array[(42 +8)&15]) ^ (array[(42 +2)&15]) ^ (array[(42)&15]))); __res; }); (*(volatile unsigned int *)&(array[(42)&15]) = (TEMP)); C += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (D)); __res; }) + (((E&A)+(B&(E^A)))) + (0x8f1bbcdc); E = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (E)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(43 +13)&15]) ^ (array[(43 +8)&15]) ^ (array[(43 +2)&15]) ^ (array[(43)&15]))); __res; }); (*(volatile unsigned int *)&(array[(43)&15]) = (TEMP)); B += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (C)); __res; }) + (((D&E)+(A&(D^E)))) + (0x8f1bbcdc); D = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (D)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(44 +13)&15]) ^ (array[(44 +8)&15]) ^ (array[(44 +2)&15]) ^ (array[(44)&15]))); __res; }); (*(volatile unsigned int *)&(array[(44)&15]) = (TEMP)); A += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (B)); __res; }) + (((C&D)+(E&(C^D)))) + (0x8f1bbcdc); C = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (C)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(45 +13)&15]) ^ (array[(45 +8)&15]) ^ (array[(45 +2)&15]) ^ (array[(45)&15]))); __res; }); (*(volatile unsigned int *)&(array[(45)&15]) = (TEMP)); E += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (A)); __res; }) + (((B&C)+(D&(B^C)))) + (0x8f1bbcdc); B = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (B)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(46 +13)&15]) ^ (array[(46 +8)&15]) ^ (array[(46 +2)&15]) ^ (array[(46)&15]))); __res; }); (*(volatile unsigned int *)&(array[(46)&15]) = (TEMP)); D += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (E)); __res; }) + (((A&B)+(C&(A^B)))) + (0x8f1bbcdc); A = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (A)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(47 +13)&15]) ^ (array[(47 +8)&15]) ^ (array[(47 +2)&15]) ^ (array[(47)&15]))); __res; }); (*(volatile unsigned int *)&(array[(47)&15]) = (TEMP)); C += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (D)); __res; }) + (((E&A)+(B&(E^A)))) + (0x8f1bbcdc); E = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (E)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(48 +13)&15]) ^ (array[(48 +8)&15]) ^ (array[(48 +2)&15]) ^ (array[(48)&15]))); __res; }); (*(volatile unsigned int *)&(array[(48)&15]) = (TEMP)); B += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (C)); __res; }) + (((D&E)+(A&(D^E)))) + (0x8f1bbcdc); D = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (D)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(49 +13)&15]) ^ (array[(49 +8)&15]) ^ (array[(49 +2)&15]) ^ (array[(49)&15]))); __res; }); (*(volatile unsigned int *)&(array[(49)&15]) = (TEMP)); A += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (B)); __res; }) + (((C&D)+(E&(C^D)))) + (0x8f1bbcdc); C = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (C)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(50 +13)&15]) ^ (array[(50 +8)&15]) ^ (array[(50 +2)&15]) ^ (array[(50)&15]))); __res; }); (*(volatile unsigned int *)&(array[(50)&15]) = (TEMP)); E += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (A)); __res; }) + (((B&C)+(D&(B^C)))) + (0x8f1bbcdc); B = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (B)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(51 +13)&15]) ^ (array[(51 +8)&15]) ^ (array[(51 +2)&15]) ^ (array[(51)&15]))); __res; }); (*(volatile unsigned int *)&(array[(51)&15]) = (TEMP)); D += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (E)); __res; }) + (((A&B)+(C&(A^B)))) + (0x8f1bbcdc); A = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (A)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(52 +13)&15]) ^ (array[(52 +8)&15]) ^ (array[(52 +2)&15]) ^ (array[(52)&15]))); __res; }); (*(volatile unsigned int *)&(array[(52)&15]) = (TEMP)); C += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (D)); __res; }) + (((E&A)+(B&(E^A)))) + (0x8f1bbcdc); E = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (E)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(53 +13)&15]) ^ (array[(53 +8)&15]) ^ (array[(53 +2)&15]) ^ (array[(53)&15]))); __res; }); (*(volatile unsigned int *)&(array[(53)&15]) = (TEMP)); B += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (C)); __res; }) + (((D&E)+(A&(D^E)))) + (0x8f1bbcdc); D = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (D)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(54 +13)&15]) ^ (array[(54 +8)&15]) ^ (array[(54 +2)&15]) ^ (array[(54)&15]))); __res; }); (*(volatile unsigned int *)&(array[(54)&15]) = (TEMP)); A += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (B)); __res; }) + (((C&D)+(E&(C^D)))) + (0x8f1bbcdc); C = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (C)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(55 +13)&15]) ^ (array[(55 +8)&15]) ^ (array[(55 +2)&15]) ^ (array[(55)&15]))); __res; }); (*(volatile unsigned int *)&(array[(55)&15]) = (TEMP)); E += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (A)); __res; }) + (((B&C)+(D&(B^C)))) + (0x8f1bbcdc); B = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (B)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(56 +13)&15]) ^ (array[(56 +8)&15]) ^ (array[(56 +2)&15]) ^ (array[(56)&15]))); __res; }); (*(volatile unsigned int *)&(array[(56)&15]) = (TEMP)); D += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (E)); __res; }) + (((A&B)+(C&(A^B)))) + (0x8f1bbcdc); A = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (A)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(57 +13)&15]) ^ (array[(57 +8)&15]) ^ (array[(57 +2)&15]) ^ (array[(57)&15]))); __res; }); (*(volatile unsigned int *)&(array[(57)&15]) = (TEMP)); C += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (D)); __res; }) + (((E&A)+(B&(E^A)))) + (0x8f1bbcdc); E = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (E)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(58 +13)&15]) ^ (array[(58 +8)&15]) ^ (array[(58 +2)&15]) ^ (array[(58)&15]))); __res; }); (*(volatile unsigned int *)&(array[(58)&15]) = (TEMP)); B += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (C)); __res; }) + (((D&E)+(A&(D^E)))) + (0x8f1bbcdc); D = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (D)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(59 +13)&15]) ^ (array[(59 +8)&15]) ^ (array[(59 +2)&15]) ^ (array[(59)&15]))); __res; }); (*(volatile unsigned int *)&(array[(59)&15]) = (TEMP)); A += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (B)); __res; }) + (((C&D)+(E&(C^D)))) + (0x8f1bbcdc); C = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (C)); __res; }); } while (0);

 /* Round 4 */
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(60 +13)&15]) ^ (array[(60 +8)&15]) ^ (array[(60 +2)&15]) ^ (array[(60)&15]))); __res; }); (*(volatile unsigned int *)&(array[(60)&15]) = (TEMP)); E += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (A)); __res; }) + ((B^C^D)) + (0xca62c1d6); B = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (B)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(61 +13)&15]) ^ (array[(61 +8)&15]) ^ (array[(61 +2)&15]) ^ (array[(61)&15]))); __res; }); (*(volatile unsigned int *)&(array[(61)&15]) = (TEMP)); D += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (E)); __res; }) + ((A^B^C)) + (0xca62c1d6); A = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (A)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(62 +13)&15]) ^ (array[(62 +8)&15]) ^ (array[(62 +2)&15]) ^ (array[(62)&15]))); __res; }); (*(volatile unsigned int *)&(array[(62)&15]) = (TEMP)); C += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (D)); __res; }) + ((E^A^B)) + (0xca62c1d6); E = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (E)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(63 +13)&15]) ^ (array[(63 +8)&15]) ^ (array[(63 +2)&15]) ^ (array[(63)&15]))); __res; }); (*(volatile unsigned int *)&(array[(63)&15]) = (TEMP)); B += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (C)); __res; }) + ((D^E^A)) + (0xca62c1d6); D = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (D)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(64 +13)&15]) ^ (array[(64 +8)&15]) ^ (array[(64 +2)&15]) ^ (array[(64)&15]))); __res; }); (*(volatile unsigned int *)&(array[(64)&15]) = (TEMP)); A += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (B)); __res; }) + ((C^D^E)) + (0xca62c1d6); C = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (C)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(65 +13)&15]) ^ (array[(65 +8)&15]) ^ (array[(65 +2)&15]) ^ (array[(65)&15]))); __res; }); (*(volatile unsigned int *)&(array[(65)&15]) = (TEMP)); E += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (A)); __res; }) + ((B^C^D)) + (0xca62c1d6); B = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (B)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(66 +13)&15]) ^ (array[(66 +8)&15]) ^ (array[(66 +2)&15]) ^ (array[(66)&15]))); __res; }); (*(volatile unsigned int *)&(array[(66)&15]) = (TEMP)); D += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (E)); __res; }) + ((A^B^C)) + (0xca62c1d6); A = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (A)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(67 +13)&15]) ^ (array[(67 +8)&15]) ^ (array[(67 +2)&15]) ^ (array[(67)&15]))); __res; }); (*(volatile unsigned int *)&(array[(67)&15]) = (TEMP)); C += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (D)); __res; }) + ((E^A^B)) + (0xca62c1d6); E = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (E)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(68 +13)&15]) ^ (array[(68 +8)&15]) ^ (array[(68 +2)&15]) ^ (array[(68)&15]))); __res; }); (*(volatile unsigned int *)&(array[(68)&15]) = (TEMP)); B += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (C)); __res; }) + ((D^E^A)) + (0xca62c1d6); D = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (D)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(69 +13)&15]) ^ (array[(69 +8)&15]) ^ (array[(69 +2)&15]) ^ (array[(69)&15]))); __res; }); (*(volatile unsigned int *)&(array[(69)&15]) = (TEMP)); A += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (B)); __res; }) + ((C^D^E)) + (0xca62c1d6); C = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (C)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(70 +13)&15]) ^ (array[(70 +8)&15]) ^ (array[(70 +2)&15]) ^ (array[(70)&15]))); __res; }); (*(volatile unsigned int *)&(array[(70)&15]) = (TEMP)); E += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (A)); __res; }) + ((B^C^D)) + (0xca62c1d6); B = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (B)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(71 +13)&15]) ^ (array[(71 +8)&15]) ^ (array[(71 +2)&15]) ^ (array[(71)&15]))); __res; }); (*(volatile unsigned int *)&(array[(71)&15]) = (TEMP)); D += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (E)); __res; }) + ((A^B^C)) + (0xca62c1d6); A = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (A)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(72 +13)&15]) ^ (array[(72 +8)&15]) ^ (array[(72 +2)&15]) ^ (array[(72)&15]))); __res; }); (*(volatile unsigned int *)&(array[(72)&15]) = (TEMP)); C += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (D)); __res; }) + ((E^A^B)) + (0xca62c1d6); E = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (E)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(73 +13)&15]) ^ (array[(73 +8)&15]) ^ (array[(73 +2)&15]) ^ (array[(73)&15]))); __res; }); (*(volatile unsigned int *)&(array[(73)&15]) = (TEMP)); B += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (C)); __res; }) + ((D^E^A)) + (0xca62c1d6); D = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (D)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(74 +13)&15]) ^ (array[(74 +8)&15]) ^ (array[(74 +2)&15]) ^ (array[(74)&15]))); __res; }); (*(volatile unsigned int *)&(array[(74)&15]) = (TEMP)); A += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (B)); __res; }) + ((C^D^E)) + (0xca62c1d6); C = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (C)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(75 +13)&15]) ^ (array[(75 +8)&15]) ^ (array[(75 +2)&15]) ^ (array[(75)&15]))); __res; }); (*(volatile unsigned int *)&(array[(75)&15]) = (TEMP)); E += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (A)); __res; }) + ((B^C^D)) + (0xca62c1d6); B = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (B)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(76 +13)&15]) ^ (array[(76 +8)&15]) ^ (array[(76 +2)&15]) ^ (array[(76)&15]))); __res; }); (*(volatile unsigned int *)&(array[(76)&15]) = (TEMP)); D += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (E)); __res; }) + ((A^B^C)) + (0xca62c1d6); A = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (A)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(77 +13)&15]) ^ (array[(77 +8)&15]) ^ (array[(77 +2)&15]) ^ (array[(77)&15]))); __res; }); (*(volatile unsigned int *)&(array[(77)&15]) = (TEMP)); C += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (D)); __res; }) + ((E^A^B)) + (0xca62c1d6); E = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (E)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(78 +13)&15]) ^ (array[(78 +8)&15]) ^ (array[(78 +2)&15]) ^ (array[(78)&15]))); __res; }); (*(volatile unsigned int *)&(array[(78)&15]) = (TEMP)); B += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (C)); __res; }) + ((D^E^A)) + (0xca62c1d6); D = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (D)); __res; }); } while (0);
 do { unsigned int TEMP = ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (1), "0" ((array[(79 +13)&15]) ^ (array[(79 +8)&15]) ^ (array[(79 +2)&15]) ^ (array[(79)&15]))); __res; }); (*(volatile unsigned int *)&(array[(79)&15]) = (TEMP)); A += TEMP + ({ unsigned int __res; __asm__("rol" " %1,%0":"=r" (__res):"i" (5), "0" (B)); __res; }) + ((C^D^E)) + (0xca62c1d6); C = ({ unsigned int __res; __asm__("ror" " %1,%0":"=r" (__res):"i" (2), "0" (C)); __res; }); } while (0);

 ctx->H[0] += A;
 ctx->H[1] += B;
 ctx->H[2] += C;
 ctx->H[3] += D;
 ctx->H[4] += E;
}

