unsigned int __builtin_object_size (const void *, int);
void * __builtin___memset_chk (void *, int, unsigned int, unsigned int);
unsigned int __builtin_strlen (const char *);
int __builtin_strcmp (const char *, const char *);

# 118 "../../include/openssl/ossl_typ.h"
typedef struct bignum_st BIGNUM;

# 119 "../../include/openssl/ossl_typ.h"
typedef struct bignum_ctx BN_CTX;

# 331 "../../include/openssl/bn.h"
struct bignum_st {
    unsigned int *d; /* Pointer to an array of 'BN_BITS2' bit
                                 * chunks. */
    int top; /* Index of last used d +1. */
    /* The next are internal book keeping for bn_expand. */
    int dmax; /* Size of the d array. */
    int neg; /* one if the number is negative */
    int flags;
};

# 446 "../../include/openssl/bn.h"
void BN_CTX_start(BN_CTX *ctx);

# 447 "../../include/openssl/bn.h"
BIGNUM *BN_CTX_get(BN_CTX *ctx);

# 448 "../../include/openssl/bn.h"
void BN_CTX_end(BN_CTX *ctx);

# 453 "../../include/openssl/bn.h"
int BN_num_bits(const BIGNUM *a);

# 458 "../../include/openssl/bn.h"
BIGNUM *BN_copy(BIGNUM *a, const BIGNUM *b);

# 507 "../../include/openssl/bn.h"
int BN_set_word(BIGNUM *a, unsigned int w);

# 513 "../../include/openssl/bn.h"
int BN_lshift(BIGNUM *r, const BIGNUM *a, int n);

# 542 "../../include/openssl/bn.h"
int BN_rshift(BIGNUM *r, const BIGNUM *a, int n);

# 546 "../../include/openssl/bn.h"
int BN_ucmp(const BIGNUM *a, const BIGNUM *b);

# 755 "../../include/openssl/bn.h"
BIGNUM *bn_expand2(BIGNUM *a, int words);

# 868 "../../include/openssl/bn.h"
unsigned int bn_mul_words(unsigned int *rp, const unsigned int *ap, int num, unsigned int w);

# 871 "../../include/openssl/bn.h"
unsigned int bn_add_words(unsigned int *rp, const unsigned int *ap, const unsigned int *bp,
                      int num);

# 873 "../../include/openssl/bn.h"
unsigned int bn_sub_words(unsigned int *rp, const unsigned int *ap, const unsigned int *bp,
                      int num);

# 318 "../../include/openssl/err.h"
void ERR_put_error(int lib, int func, int reason, const char *file, int line);

# 190 "bn_div.c"
int BN_div(BIGNUM *dv, BIGNUM *rm, const BIGNUM *num, const BIGNUM *divisor,
           BN_CTX *ctx)
{
    int norm_shift, i, loop;
    BIGNUM *tmp, wnum, *snum, *sdiv, *res;
    unsigned int *resp, *wnump;
    unsigned int d0, d1;
    int num_n, div_n;
    int no_branch = 0;

    /*
     * Invalid zero-padding would have particularly bad consequences so don't
     * just rely on bn_check_top() here (bn_check_top() works only for
     * BN_DEBUG builds)
     */
    if ((num->top > 0 && num->d[num->top - 1] == 0) ||
        (divisor->top > 0 && divisor->d[divisor->top - 1] == 0)) {
        ERR_put_error(3,(107),(107),"bn_div.c",207);
        return 0;
    }

    ;
    ;

    if ((((num)->flags&(0x04)) != 0)
        || (((divisor)->flags&(0x04)) != 0)) {
        no_branch = 1;
    }

    ;
    ;
    /*- bn_check_top(num); *//*
     * 'num' has been checked already
     */
    /*- bn_check_top(divisor); *//*
     * 'divisor' has been checked already
     */

    if (((divisor)->top == 0)) {
        ERR_put_error(3,(107),(103),"bn_div.c",229);
        return (0);
    }

    if (!no_branch && BN_ucmp(num, divisor) < 0) {
        if (rm != ((void *)0)) {
            if (BN_copy(rm, num) == ((void *)0))
                return (0);
        }
        if (dv != ((void *)0))
            (BN_set_word((dv),0));
        return (1);
    }

    BN_CTX_start(ctx);
    tmp = BN_CTX_get(ctx);
    snum = BN_CTX_get(ctx);
    sdiv = BN_CTX_get(ctx);
    if (dv == ((void *)0))
        res = BN_CTX_get(ctx);
    else
        res = dv;
    if (sdiv == ((void *)0) || res == ((void *)0) || tmp == ((void *)0) || snum == ((void *)0))
        goto err;

    /* First we normalise the numbers */
    norm_shift = 32 - ((BN_num_bits(divisor)) % 32);
    if (!(BN_lshift(sdiv, divisor, norm_shift)))
        goto err;
    sdiv->neg = 0;
    norm_shift += 32;
    if (!(BN_lshift(snum, num, norm_shift)))
        goto err;
    snum->neg = 0;

    if (no_branch) {
        /*
         * Since we don't know whether snum is larger than sdiv, we pad snum
         * with enough zeroes without changing its value.
         */
        if (snum->top <= sdiv->top + 1) {
            if ((((sdiv->top + 2) <= (snum)->dmax)?(snum):bn_expand2((snum),(sdiv->top + 2))) == ((void *)0))
                goto err;
            for (i = snum->top; i < sdiv->top + 2; i++)
                snum->d[i] = 0;
            snum->top = sdiv->top + 2;
        } else {
            if ((((snum->top + 1) <= (snum)->dmax)?(snum):bn_expand2((snum),(snum->top + 1))) == ((void *)0))
                goto err;
            snum->d[snum->top] = 0;
            snum->top++;
        }
    }

    div_n = sdiv->top;
    num_n = snum->top;
    loop = num_n - div_n;
    /*
     * Lets setup a 'window' into snum This is the part that corresponds to
     * the current 'area' being divided
     */
    wnum.neg = 0;
    wnum.d = &(snum->d[loop]);
    wnum.top = div_n;
    /*
     * only needed when BN_ucmp messes up the values between top and max
     */
    wnum.dmax = snum->dmax - loop; /* so we don't step out of bounds */

    /* Get the top 2 words of sdiv */
    /* div_n=sdiv->top; */
    d0 = sdiv->d[div_n - 1];
    d1 = (div_n == 1) ? 0 : sdiv->d[div_n - 2];

    /* pointer to the 'top' of snum */
    wnump = &(snum->d[num_n - 1]);

    /* Setup to 'res' */
    res->neg = (num->neg ^ divisor->neg);
    if (!((((loop + 1)) <= (res)->dmax)?(res):bn_expand2((res),((loop + 1)))))
        goto err;
    res->top = loop - no_branch;
    resp = &(res->d[loop - 1]);

    /* space for temp */
    if (!((((div_n + 1)) <= (tmp)->dmax)?(tmp):bn_expand2((tmp),((div_n + 1)))))
        goto err;

    if (!no_branch) {
        if (BN_ucmp(&wnum, sdiv) >= 0) {
            /*
             * If BN_DEBUG_RAND is defined BN_ucmp changes (via bn_pollute)
             * the const bignum arguments => clean the values between top and
             * max again
             */
            ;
            bn_sub_words(wnum.d, wnum.d, sdiv->d, div_n);
            *resp = 1;
        } else
            res->top--;
    }

    /*
     * if res->top == 0 then clear the neg value otherwise decrease the resp
     * pointer
     */
    if (res->top == 0)
        res->neg = 0;
    else
        resp--;

    for (i = 0; i < loop - 1; i++, wnump--, resp--) {
        unsigned int q, l0;
        /*
         * the first part of the loop uses the top two words of snum and sdiv
         * to calculate a BN_ULONG q such that | wnum - sdiv * q | < sdiv
         */




        unsigned int n0, n1, rem = 0;

        n0 = wnump[0];
        n1 = wnump[-1];
        if (n0 == d0)
            q = (0xffffffffL);
        else { /* n0 < d0 */


            unsigned long long t2;




            q = ({ asm volatile ( "divl   %4" : "=a"(q), "=d"(rem) : "a"(n1), "d"(n0), "g"(d0) : "cc"); q; });
# 378 "bn_div.c"
            t2 = (unsigned long long) d1 *q;

            for (;;) {
                if (t2 <= ((((unsigned long long) rem) << 32) | wnump[-2]))
                    break;
                q--;
                rem += d0;
                if (rem < d0)
                    break; /* don't let rem overflow */
                t2 -= d1;
            }
# 429 "bn_div.c"
        }


        l0 = bn_mul_words(tmp->d, sdiv->d, div_n, q);
        tmp->d[div_n] = l0;
        wnum.d--;
        /*
         * ingore top values of the bignums just sub the two BN_ULONG arrays
         * with bn_sub_words
         */
        if (bn_sub_words(wnum.d, wnum.d, tmp->d, div_n + 1)) {
            /*
             * Note: As we have considered only the leading two BN_ULONGs in
             * the calculation of q, sdiv * q might be greater than wnum (but
             * then (q-1) * sdiv is less or equal than wnum)
             */
            q--;
            if (bn_add_words(wnum.d, wnum.d, sdiv->d, div_n))
                /*
                 * we can't have an overflow here (assuming that q != 0, but
                 * if q == 0 then tmp is zero anyway)
                 */
                (*wnump)++;
        }
        /* store part of the result */
        *resp = q;
    }
    { unsigned int *ftl; int tmp_top = (snum)->top; if (tmp_top > 0) { for (ftl= &((snum)->d[tmp_top-1]); tmp_top > 0; tmp_top--) if (*(ftl--)) break; (snum)->top = tmp_top; } ; };
    if (rm != ((void *)0)) {
        /*
         * Keep a copy of the neg flag in num because if rm==num BN_rshift()
         * will overwrite it.
         */
        int neg = num->neg;
        BN_rshift(rm, snum, norm_shift);
        if (!((rm)->top == 0))
            rm->neg = neg;
        ;
    }
    if (no_branch)
        { unsigned int *ftl; int tmp_top = (res)->top; if (tmp_top > 0) { for (ftl= &((res)->d[tmp_top-1]); tmp_top > 0; tmp_top--) if (*(ftl--)) break; (res)->top = tmp_top; } ; };
    BN_CTX_end(ctx);
    return (1);
 err:
    ;
    BN_CTX_end(ctx);
    return (0);
}

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 78 "../include/openssl/aes.h"
struct aes_key_st {



    unsigned int rd_key[4 * (14 + 1)];

    int rounds;
};

# 86 "../include/openssl/aes.h"
typedef struct aes_key_st AES_KEY;

# 165 "e_padlock.c"
static int padlock_use_ace = 0;

# 166 "e_padlock.c"
static int padlock_use_rng = 0;

# 268 "e_padlock.c"
struct padlock_cipher_data {
    unsigned char iv[16]; /* Initialization vector */
    union {
        unsigned int pad[4];
        struct {
            int rounds:4;
            int dgst:1; /* n/a in C3 */
            int align:1; /* n/a in C3 */
            int ciphr:1; /* n/a in C3 */
            unsigned int keygen:1;
            int interm:1;
            unsigned int encdec:1;
            int ksize:2;
        } b;
    } cword; /* Control word */
    AES_KEY ks; /* Encryption key */
};

# 292 "e_padlock.c"
static volatile struct padlock_cipher_data *padlock_saved_context;

# 316 "e_padlock.c"
static int padlock_insn_cpuid_available(void)
{
    int result = -1;

    /*
     * We're checking if the bit #21 of EFLAGS can be toggled. If yes =
     * CPUID is available.
     */
    asm volatile ("pushf\n"
                  "popl %%eax\n"
                  "xorl $0x200000, %%eax\n"
                  "movl %%eax, %%ecx\n"
                  "andl $0x200000, %%ecx\n"
                  "pushl %%eax\n"
                  "popf\n"
                  "pushf\n"
                  "popl %%eax\n"
                  "andl $0x200000, %%eax\n"
                  "xorl %%eax, %%ecx\n"
                  "movl %%ecx, %0\n":"=r" (result)::"eax", "ecx");

    return (result == 0);
}

# 343 "e_padlock.c"
static int padlock_available(void)
{
    char vendor_string[16];
    unsigned int eax, edx;

    /* First check if the CPUID instruction is available at all... */
    if (!padlock_insn_cpuid_available())
        return 0;

    /* Are we running on the Centaur (VIA) CPU? */
    eax = 0x00000000;
    vendor_string[12] = 0;
    asm volatile ("pushl  %%ebx\n"
                  "cpuid\n"
                  "movl   %%ebx,(%%edi)\n"
                  "movl   %%edx,4(%%edi)\n"
                  "movl   %%ecx,8(%%edi)\n"
                  "popl   %%ebx":"+a" (eax):"D"(vendor_string):"ecx", "edx");
    if (__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (vendor_string) && __builtin_constant_p ("CentaurHauls") && (__s1_len = __builtin_strlen (vendor_string), __s2_len = __builtin_strlen ("CentaurHauls"), (!((size_t)(const void *)((vendor_string) + 1) - (size_t)(const void *)(vendor_string) == 1) || __s1_len >= 4) && (!((size_t)(const void *)(("CentaurHauls") + 1) - (size_t)(const void *)("CentaurHauls") == 1) || __s2_len >= 4)) ? __builtin_strcmp (vendor_string, "CentaurHauls") : (__builtin_constant_p (vendor_string) && ((size_t)(const void *)((vendor_string) + 1) - (size_t)(const void *)(vendor_string) == 1) && (__s1_len = __builtin_strlen (vendor_string), __s1_len < 4) ? (__builtin_constant_p ("CentaurHauls") && ((size_t)(const void *)(("CentaurHauls") + 1) - (size_t)(const void *)("CentaurHauls") == 1) ? __builtin_strcmp (vendor_string, "CentaurHauls") : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) ("CentaurHauls"); int __result = (((const unsigned char *) (const char *) (vendor_string))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (vendor_string))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (vendor_string))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (vendor_string))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p ("CentaurHauls") && ((size_t)(const void *)(("CentaurHauls") + 1) - (size_t)(const void *)("CentaurHauls") == 1) && (__s2_len = __builtin_strlen ("CentaurHauls"), __s2_len < 4) ? (__builtin_constant_p (vendor_string) && ((size_t)(const void *)((vendor_string) + 1) - (size_t)(const void *)(vendor_string) == 1) ? __builtin_strcmp (vendor_string, "CentaurHauls") : (- (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (vendor_string); int __result = (((const unsigned char *) (const char *) ("CentaurHauls"))[0] - __s2[0]); if (__s2_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) ("CentaurHauls"))[1] - __s2[1]); if (__s2_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) ("CentaurHauls"))[2] - __s2[2]); if (__s2_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) ("CentaurHauls"))[3] - __s2[3]); } } __result; })))) : __builtin_strcmp (vendor_string, "CentaurHauls")))); }) != 0)
        return 0;

    /* Check for Centaur Extended Feature Flags presence */
    eax = 0xC0000000;
    asm volatile ("pushl %%ebx; cpuid; popl %%ebx":"+a" (eax)::"ecx", "edx");
    if (eax < 0xC0000001)
        return 0;

    /* Read the Centaur Extended Feature Flags */
    eax = 0xC0000001;
    asm volatile ("pushl %%ebx; cpuid; popl %%ebx":"+a" (eax),
                  "=d"(edx)::"ecx");

    /* Fill up some flags */
    padlock_use_ace = ((edx & (0x3 << 6)) == (0x3 << 6));
    padlock_use_rng = ((edx & (0x3 << 2)) == (0x3 << 2));

    return padlock_use_ace + padlock_use_rng;
}

# 402 "e_padlock.c"
static inline void padlock_reload_key(void)
{
    asm volatile ("pushfl; popfl");
}

/*@ rustina_out_of_scope */
# 417 "e_padlock.c"
static inline void padlock_verify_context(struct padlock_cipher_data *cdata)
{
    asm volatile ("pushfl\n"
                  "       btl     $30,(%%esp)\n"
                  "       jnc     1f\n"
                  "       cmpl    %2,%1\n"
                  "       je      1f\n"
                  "       popfl\n"
                  "       subl    $4,%%esp\n"
                  "1:     addl    $4,%%esp\n"
                  "       movl    %2,%0":"+m" (padlock_saved_context)
                  :"r"(padlock_saved_context), "r"(cdata):"cc");
}

# 454 "e_padlock.c"
static inline void *padlock_xcrypt_ecb(size_t cnt, struct padlock_cipher_data *cdata, void *out, const void *inp) { void *iv; asm volatile ( "pushl   %%ebx\n" "       leal    16(%0),%%edx\n" "       leal    32(%0),%%ebx\n" ".byte 0xf3,0x0f,0xa7,0xc8" "\n" "       popl    %%ebx" : "=a"(iv), "=c"(cnt), "=D"(out), "=S"(inp) : "0"(cdata), "1"(cnt), "2"(out), "3"(inp) : "edx", "cc", "memory"); return iv; }

# 456 "e_padlock.c"
static inline void *padlock_xcrypt_cbc(size_t cnt, struct padlock_cipher_data *cdata, void *out, const void *inp) { void *iv; asm volatile ( "pushl   %%ebx\n" "       leal    16(%0),%%edx\n" "       leal    32(%0),%%ebx\n" ".byte 0xf3,0x0f,0xa7,0xd0" "\n" "       popl    %%ebx" : "=a"(iv), "=c"(cnt), "=D"(out), "=S"(inp) : "0"(cdata), "1"(cnt), "2"(out), "3"(inp) : "edx", "cc", "memory"); return iv; }

# 458 "e_padlock.c"
static inline void *padlock_xcrypt_cfb(size_t cnt, struct padlock_cipher_data *cdata, void *out, const void *inp) { void *iv; asm volatile ( "pushl   %%ebx\n" "       leal    16(%0),%%edx\n" "       leal    32(%0),%%ebx\n" ".byte 0xf3,0x0f,0xa7,0xe0" "\n" "       popl    %%ebx" : "=a"(iv), "=c"(cnt), "=D"(out), "=S"(inp) : "0"(cdata), "1"(cnt), "2"(out), "3"(inp) : "edx", "cc", "memory"); return iv; }

# 460 "e_padlock.c"
static inline void *padlock_xcrypt_ofb(size_t cnt, struct padlock_cipher_data *cdata, void *out, const void *inp) { void *iv; asm volatile ( "pushl   %%ebx\n" "       leal    16(%0),%%edx\n" "       leal    32(%0),%%ebx\n" ".byte 0xf3,0x0f,0xa7,0xe8" "\n" "       popl    %%ebx" : "=a"(iv), "=c"(cnt), "=D"(out), "=S"(inp) : "0"(cdata), "1"(cnt), "2"(out), "3"(inp) : "edx", "cc", "memory"); return iv; }

# 463 "e_padlock.c"
static inline unsigned int padlock_xstore(void *addr, unsigned int edx_in)
{
    unsigned int eax_out;

    asm volatile (".byte 0x0f,0xa7,0xc0" /* xstore */
                  :"=a" (eax_out), "=m"(*(unsigned *)addr)
                  :"D"(addr), "d"(edx_in)
        );

    return eax_out;
}

# 100 "../../include/openssl/md4.h"
typedef struct MD4state_st {
    unsigned int A, B, C, D;
    unsigned int Nl, Nh;
    unsigned int data[(64/4)];
    unsigned int num;
} MD4_CTX;

# 89 "md4_dgst.c"
void md4_block_data_order(MD4_CTX *c, const void *data_, size_t num)
{
    const unsigned char *data = data_;
    register unsigned int A, B, C, D, l;

    /* See comment in crypto/sha/sha_locl.h for details. */
    unsigned int XX0, XX1, XX2, XX3, XX4, XX5, XX6, XX7,
        XX8, XX9, XX10, XX11, XX12, XX13, XX14, XX15;






    A = c->A;
    B = c->B;
    C = c->C;
    D = c->D;

    for (; num--;) {
        (void)((l)=*((const unsigned int *)(data)), (data)+=4, l);
        XX0 = l;
        (void)((l)=*((const unsigned int *)(data)), (data)+=4, l);
        XX1 = l;
        /* Round 0 */
        { A+=((XX0)+(0)+(((((C)) ^ ((D))) & ((B))) ^ ((D)))); A=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(3), "0"((unsigned int)(A)) : "cc"); ret; }); };;
        (void)((l)=*((const unsigned int *)(data)), (data)+=4, l);
        XX2 = l;
        { D+=((XX1)+(0)+(((((B)) ^ ((C))) & ((A))) ^ ((C)))); D=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(7), "0"((unsigned int)(D)) : "cc"); ret; }); };;
        (void)((l)=*((const unsigned int *)(data)), (data)+=4, l);
        XX3 = l;
        { C+=((XX2)+(0)+(((((A)) ^ ((B))) & ((D))) ^ ((B)))); C=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(11), "0"((unsigned int)(C)) : "cc"); ret; }); };;
        (void)((l)=*((const unsigned int *)(data)), (data)+=4, l);
        XX4 = l;
        { B+=((XX3)+(0)+(((((D)) ^ ((A))) & ((C))) ^ ((A)))); B=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(19), "0"((unsigned int)(B)) : "cc"); ret; }); };;
        (void)((l)=*((const unsigned int *)(data)), (data)+=4, l);
        XX5 = l;
        { A+=((XX4)+(0)+(((((C)) ^ ((D))) & ((B))) ^ ((D)))); A=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(3), "0"((unsigned int)(A)) : "cc"); ret; }); };;
        (void)((l)=*((const unsigned int *)(data)), (data)+=4, l);
        XX6 = l;
        { D+=((XX5)+(0)+(((((B)) ^ ((C))) & ((A))) ^ ((C)))); D=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(7), "0"((unsigned int)(D)) : "cc"); ret; }); };;
        (void)((l)=*((const unsigned int *)(data)), (data)+=4, l);
        XX7 = l;
        { C+=((XX6)+(0)+(((((A)) ^ ((B))) & ((D))) ^ ((B)))); C=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(11), "0"((unsigned int)(C)) : "cc"); ret; }); };;
        (void)((l)=*((const unsigned int *)(data)), (data)+=4, l);
        XX8 = l;
        { B+=((XX7)+(0)+(((((D)) ^ ((A))) & ((C))) ^ ((A)))); B=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(19), "0"((unsigned int)(B)) : "cc"); ret; }); };;
        (void)((l)=*((const unsigned int *)(data)), (data)+=4, l);
        XX9 = l;
        { A+=((XX8)+(0)+(((((C)) ^ ((D))) & ((B))) ^ ((D)))); A=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(3), "0"((unsigned int)(A)) : "cc"); ret; }); };;
        (void)((l)=*((const unsigned int *)(data)), (data)+=4, l);
        XX10 = l;
        { D+=((XX9)+(0)+(((((B)) ^ ((C))) & ((A))) ^ ((C)))); D=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(7), "0"((unsigned int)(D)) : "cc"); ret; }); };;
        (void)((l)=*((const unsigned int *)(data)), (data)+=4, l);
        XX11 = l;
        { C+=((XX10)+(0)+(((((A)) ^ ((B))) & ((D))) ^ ((B)))); C=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(11), "0"((unsigned int)(C)) : "cc"); ret; }); };;
        (void)((l)=*((const unsigned int *)(data)), (data)+=4, l);
        XX12 = l;
        { B+=((XX11)+(0)+(((((D)) ^ ((A))) & ((C))) ^ ((A)))); B=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(19), "0"((unsigned int)(B)) : "cc"); ret; }); };;
        (void)((l)=*((const unsigned int *)(data)), (data)+=4, l);
        XX13 = l;
        { A+=((XX12)+(0)+(((((C)) ^ ((D))) & ((B))) ^ ((D)))); A=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(3), "0"((unsigned int)(A)) : "cc"); ret; }); };;
        (void)((l)=*((const unsigned int *)(data)), (data)+=4, l);
        XX14 = l;
        { D+=((XX13)+(0)+(((((B)) ^ ((C))) & ((A))) ^ ((C)))); D=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(7), "0"((unsigned int)(D)) : "cc"); ret; }); };;
        (void)((l)=*((const unsigned int *)(data)), (data)+=4, l);
        XX15 = l;
        { C+=((XX14)+(0)+(((((A)) ^ ((B))) & ((D))) ^ ((B)))); C=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(11), "0"((unsigned int)(C)) : "cc"); ret; }); };;
        { B+=((XX15)+(0)+(((((D)) ^ ((A))) & ((C))) ^ ((A)))); B=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(19), "0"((unsigned int)(B)) : "cc"); ret; }); };;
        /* Round 1 */
        { A+=((XX0)+(0x5A827999L)+((((B)) & ((C))) | (((B)) & ((D))) | (((C)) & ((D))))); A=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(3), "0"((unsigned int)(A)) : "cc"); ret; }); };;
        { D+=((XX4)+(0x5A827999L)+((((A)) & ((B))) | (((A)) & ((C))) | (((B)) & ((C))))); D=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(5), "0"((unsigned int)(D)) : "cc"); ret; }); };;
        { C+=((XX8)+(0x5A827999L)+((((D)) & ((A))) | (((D)) & ((B))) | (((A)) & ((B))))); C=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(9), "0"((unsigned int)(C)) : "cc"); ret; }); };;
        { B+=((XX12)+(0x5A827999L)+((((C)) & ((D))) | (((C)) & ((A))) | (((D)) & ((A))))); B=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(13), "0"((unsigned int)(B)) : "cc"); ret; }); };;
        { A+=((XX1)+(0x5A827999L)+((((B)) & ((C))) | (((B)) & ((D))) | (((C)) & ((D))))); A=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(3), "0"((unsigned int)(A)) : "cc"); ret; }); };;
        { D+=((XX5)+(0x5A827999L)+((((A)) & ((B))) | (((A)) & ((C))) | (((B)) & ((C))))); D=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(5), "0"((unsigned int)(D)) : "cc"); ret; }); };;
        { C+=((XX9)+(0x5A827999L)+((((D)) & ((A))) | (((D)) & ((B))) | (((A)) & ((B))))); C=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(9), "0"((unsigned int)(C)) : "cc"); ret; }); };;
        { B+=((XX13)+(0x5A827999L)+((((C)) & ((D))) | (((C)) & ((A))) | (((D)) & ((A))))); B=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(13), "0"((unsigned int)(B)) : "cc"); ret; }); };;
        { A+=((XX2)+(0x5A827999L)+((((B)) & ((C))) | (((B)) & ((D))) | (((C)) & ((D))))); A=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(3), "0"((unsigned int)(A)) : "cc"); ret; }); };;
        { D+=((XX6)+(0x5A827999L)+((((A)) & ((B))) | (((A)) & ((C))) | (((B)) & ((C))))); D=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(5), "0"((unsigned int)(D)) : "cc"); ret; }); };;
        { C+=((XX10)+(0x5A827999L)+((((D)) & ((A))) | (((D)) & ((B))) | (((A)) & ((B))))); C=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(9), "0"((unsigned int)(C)) : "cc"); ret; }); };;
        { B+=((XX14)+(0x5A827999L)+((((C)) & ((D))) | (((C)) & ((A))) | (((D)) & ((A))))); B=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(13), "0"((unsigned int)(B)) : "cc"); ret; }); };;
        { A+=((XX3)+(0x5A827999L)+((((B)) & ((C))) | (((B)) & ((D))) | (((C)) & ((D))))); A=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(3), "0"((unsigned int)(A)) : "cc"); ret; }); };;
        { D+=((XX7)+(0x5A827999L)+((((A)) & ((B))) | (((A)) & ((C))) | (((B)) & ((C))))); D=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(5), "0"((unsigned int)(D)) : "cc"); ret; }); };;
        { C+=((XX11)+(0x5A827999L)+((((D)) & ((A))) | (((D)) & ((B))) | (((A)) & ((B))))); C=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(9), "0"((unsigned int)(C)) : "cc"); ret; }); };;
        { B+=((XX15)+(0x5A827999L)+((((C)) & ((D))) | (((C)) & ((A))) | (((D)) & ((A))))); B=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(13), "0"((unsigned int)(B)) : "cc"); ret; }); };;
        /* Round 2 */
        { A+=((XX0)+(0x6ED9EBA1L)+(((B)) ^ ((C)) ^ ((D)))); A=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(3), "0"((unsigned int)(A)) : "cc"); ret; }); };;
        { D+=((XX8)+(0x6ED9EBA1L)+(((A)) ^ ((B)) ^ ((C)))); D=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(9), "0"((unsigned int)(D)) : "cc"); ret; }); };;
        { C+=((XX4)+(0x6ED9EBA1L)+(((D)) ^ ((A)) ^ ((B)))); C=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(11), "0"((unsigned int)(C)) : "cc"); ret; }); };;
        { B+=((XX12)+(0x6ED9EBA1L)+(((C)) ^ ((D)) ^ ((A)))); B=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(15), "0"((unsigned int)(B)) : "cc"); ret; }); };;
        { A+=((XX2)+(0x6ED9EBA1L)+(((B)) ^ ((C)) ^ ((D)))); A=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(3), "0"((unsigned int)(A)) : "cc"); ret; }); };;
        { D+=((XX10)+(0x6ED9EBA1L)+(((A)) ^ ((B)) ^ ((C)))); D=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(9), "0"((unsigned int)(D)) : "cc"); ret; }); };;
        { C+=((XX6)+(0x6ED9EBA1L)+(((D)) ^ ((A)) ^ ((B)))); C=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(11), "0"((unsigned int)(C)) : "cc"); ret; }); };;
        { B+=((XX14)+(0x6ED9EBA1L)+(((C)) ^ ((D)) ^ ((A)))); B=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(15), "0"((unsigned int)(B)) : "cc"); ret; }); };;
        { A+=((XX1)+(0x6ED9EBA1L)+(((B)) ^ ((C)) ^ ((D)))); A=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(3), "0"((unsigned int)(A)) : "cc"); ret; }); };;
        { D+=((XX9)+(0x6ED9EBA1L)+(((A)) ^ ((B)) ^ ((C)))); D=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(9), "0"((unsigned int)(D)) : "cc"); ret; }); };;
        { C+=((XX5)+(0x6ED9EBA1L)+(((D)) ^ ((A)) ^ ((B)))); C=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(11), "0"((unsigned int)(C)) : "cc"); ret; }); };;
        { B+=((XX13)+(0x6ED9EBA1L)+(((C)) ^ ((D)) ^ ((A)))); B=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(15), "0"((unsigned int)(B)) : "cc"); ret; }); };;
        { A+=((XX3)+(0x6ED9EBA1L)+(((B)) ^ ((C)) ^ ((D)))); A=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(3), "0"((unsigned int)(A)) : "cc"); ret; }); };;
        { D+=((XX11)+(0x6ED9EBA1L)+(((A)) ^ ((B)) ^ ((C)))); D=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(9), "0"((unsigned int)(D)) : "cc"); ret; }); };;
        { C+=((XX7)+(0x6ED9EBA1L)+(((D)) ^ ((A)) ^ ((B)))); C=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(11), "0"((unsigned int)(C)) : "cc"); ret; }); };;
        { B+=((XX15)+(0x6ED9EBA1L)+(((C)) ^ ((D)) ^ ((A)))); B=({ register unsigned int ret; asm ( "roll %1,%0" : "=r"(ret) : "I"(15), "0"((unsigned int)(B)) : "cc"); ret; }); };;

        A = c->A += A;
        B = c->B += B;
        C = c->C += C;
        D = c->D += D;
    }
}

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

# 100 "../../include/openssl/sha.h"
typedef struct SHAstate_st {
    unsigned int h0, h1, h2, h3, h4;
    unsigned int Nl, Nh;
    unsigned int data[16];
    unsigned int num;
} SHA_CTX;

# 111 "sha_locl.h"
void sha1_block_data_order(SHA_CTX *c, const void *p, size_t num);

# 343 "../md32_common.h"
int SHA1_Final(unsigned char *md, SHA_CTX *c)
{
    unsigned char *p = (unsigned char *)c->data;
    size_t n = c->num;

    p[n] = 0x80; /* there is always room for one */
    n++;

    if (n > ((16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 351 "../md32_common.h"
                         - 8)) {
        memset(p + n, 0, (16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 352 "../md32_common.h"
                                     - n);
        n = 0;
        sha1_block_data_order(c, p, 1);
    }
    memset(p + n, 0, (16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 356 "../md32_common.h"
                                 - 8 - n);

    p += (16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 358 "../md32_common.h"
                     - 8;

    (void)({ unsigned int r=(c->Nh); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)(p))=r; (p)+=4; r; });
    (void)({ unsigned int r=(c->Nl); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)(p))=r; (p)+=4; r; });




    p -= (16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 366 "../md32_common.h"
                    ;
    sha1_block_data_order(c, p, 1);
    c->num = 0;
    memset(p, 0, (16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 369 "../md32_common.h"
                            );




    do { unsigned long ll; ll=(c)->h0; (void)({ unsigned int r=(ll); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)((md)))=r; ((md))+=4; r; }); ll=(c)->h1; (void)({ unsigned int r=(ll); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)((md)))=r; ((md))+=4; r; }); ll=(c)->h2; (void)({ unsigned int r=(ll); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)((md)))=r; ((md))+=4; r; }); ll=(c)->h3; (void)({ unsigned int r=(ll); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)((md)))=r; ((md))+=4; r; }); ll=(c)->h4; (void)({ unsigned int r=(ll); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)((md)))=r; ((md))+=4; r; }); } while (0);


    return 1;
}

# 20 "../../include/openssl/modes.h"
typedef void (*ctr128_f) (const unsigned char *in, unsigned char *out,
                          size_t blocks, const void *key,
                          const unsigned char ivec[16]);

# 24 "modes_lcl.h"
typedef unsigned int u32;

# 25 "modes_lcl.h"
typedef unsigned char u8;

# 186 "ctr128.c"
static void ctr96_inc(unsigned char *counter)
{
    u32 n = 12, c = 1;

    do {
        --n;
        c += counter[n];
        counter[n] = (u8)c;
        c >>= 8;
    } while (n);
}

# 198 "ctr128.c"
void CRYPTO_ctr128_encrypt_ctr32(const unsigned char *in, unsigned char *out,
                                 size_t len, const void *key,
                                 unsigned char ivec[16],
                                 unsigned char ecount_buf[16],
                                 unsigned int *num, ctr128_f func)
{
    unsigned int n, ctr32;

    ((void) (0));
    ((void) (0));

    n = *num;

    while (n && len) {
        *(out++) = *(in++) ^ ecount_buf[n];
        --len;
        n = (n + 1) % 16;
    }

    ctr32 = ({ u32 ret=(*(const u32 *)(ivec + 12)); asm ("bswapl %0" : "+r"(ret)); ret; });
    while (len >= 16) {
        size_t blocks = len / 16;
        /*
         * 1<<28 is just a not-so-small yet not-so-large number...
         * Below condition is practically never met, but it has to
         * be checked for code correctness.
         */
        if (sizeof(size_t) > sizeof(unsigned int) && blocks > (1U << 28))
            blocks = (1U << 28);
        /*
         * As (*func) operates on 32-bit counter, caller
         * has to handle overflow. 'if' below detects the
         * overflow, which is then handled by limiting the
         * amount of blocks to the exact overflow point...
         */
        ctr32 += (u32)blocks;
        if (ctr32 < blocks) {
            blocks -= ctr32;
            ctr32 = 0;
        }
        (*func) (in, out, blocks, key, ivec);
        /* (*ctr) does not update ivec, caller does: */
        *(u32 *)(ivec + 12) = ({ u32 ret=(ctr32); asm ("bswapl %0" : "+r"(ret)); ret; });
        /* ... overflow was detected, propogate carry. */
        if (ctr32 == 0)
            ctr96_inc(ivec);
        blocks *= 16;
        len -= blocks;
        out += blocks;
        in += blocks;
    }
    if (len) {
        memset(ecount_buf, 0, 16);
        (*func) (ecount_buf, ecount_buf, 1, key, ivec);
        ++ctr32;
        *(u32 *)(ivec + 12) = ({ u32 ret=(ctr32); asm ("bswapl %0" : "+r"(ret)); ret; });
        if (ctr32 == 0)
            ctr96_inc(ivec);
        while (len--) {
            out[n] = in[n] ^ ecount_buf[n];
            ++n;
        }
    }

    *num = n;
}

# 88 "sha_locl.h"
static void sha_block_data_order(SHA_CTX *c, const void *p, size_t num);

# 343 "../md32_common.h"
int SHA_Final(unsigned char *md, SHA_CTX *c)
{
    unsigned char *p = (unsigned char *)c->data;
    size_t n = c->num;

    p[n] = 0x80; /* there is always room for one */
    n++;

    if (n > ((16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 351 "../md32_common.h"
                         - 8)) {
        memset(p + n, 0, (16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 352 "../md32_common.h"
                                     - n);
        n = 0;
        sha_block_data_order(c, p, 1);
    }
    memset(p + n, 0, (16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 356 "../md32_common.h"
                                 - 8 - n);

    p += (16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 358 "../md32_common.h"
                     - 8;

    (void)({ unsigned int r=(c->Nh); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)(p))=r; (p)+=4; r; });
    (void)({ unsigned int r=(c->Nl); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)(p))=r; (p)+=4; r; });




    p -= (16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 366 "../md32_common.h"
                    ;
    sha_block_data_order(c, p, 1);
    c->num = 0;
    memset(p, 0, (16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 369 "../md32_common.h"
                            );




    do { unsigned long ll; ll=(c)->h0; (void)({ unsigned int r=(ll); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)((md)))=r; ((md))+=4; r; }); ll=(c)->h1; (void)({ unsigned int r=(ll); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)((md)))=r; ((md))+=4; r; }); ll=(c)->h2; (void)({ unsigned int r=(ll); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)((md)))=r; ((md))+=4; r; }); ll=(c)->h3; (void)({ unsigned int r=(ll); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)((md)))=r; ((md))+=4; r; }); ll=(c)->h4; (void)({ unsigned int r=(ll); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)((md)))=r; ((md))+=4; r; }); } while (0);


    return 1;
}

# 134 "../../include/openssl/sha.h"
typedef struct SHA256state_st {
    unsigned int h[8];
    unsigned int Nl, Nh;
    unsigned int data[16];
    unsigned int num, md_len;
} SHA256_CTX;

# 128 "sha256.c"
void sha256_block_data_order(SHA256_CTX *ctx, const void *in, size_t num);

# 343 "../md32_common.h"
int SHA256_Final(unsigned char *md, SHA256_CTX *c)
{
    unsigned char *p = (unsigned char *)c->data;
    size_t n = c->num;

    p[n] = 0x80; /* there is always room for one */
    n++;

    if (n > ((16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 351 "../md32_common.h"
                         - 8)) {
        memset(p + n, 0, (16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 352 "../md32_common.h"
                                     - n);
        n = 0;
        sha256_block_data_order(c, p, 1);
    }
    memset(p + n, 0, (16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 356 "../md32_common.h"
                                 - 8 - n);

    p += (16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 358 "../md32_common.h"
                     - 8;

    (void)({ unsigned int r=(c->Nh); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)(p))=r; (p)+=4; r; });
    (void)({ unsigned int r=(c->Nl); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)(p))=r; (p)+=4; r; });




    p -= (16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 366 "../md32_common.h"
                    ;
    sha256_block_data_order(c, p, 1);
    c->num = 0;
    memset(p, 0, (16*4)/* SHA treats input data as a
                                        * contiguous array of 32 bit wide
                                        * big-endian values. */
# 369 "../md32_common.h"
                            );




    do { unsigned long ll; unsigned int nn; switch ((c)->md_len) { case 28: for (nn=0;nn<28/4;nn++) { ll=(c)->h[nn]; (void)({ unsigned int r=(ll); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)((md)))=r; ((md))+=4; r; }); } break; case 32: for (nn=0;nn<32/4;nn++) { ll=(c)->h[nn]; (void)({ unsigned int r=(ll); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)((md)))=r; ((md))+=4; r; }); } break; default: if ((c)->md_len > 32) return 0; for (nn=0;nn<(c)->md_len/4;nn++) { ll=(c)->h[nn]; (void)({ unsigned int r=(ll); asm ("bswapl %0":"=r"(r):"0"(r)); *((unsigned int *)((md)))=r; ((md))+=4; r; }); } break; } } while (0);


    return 1;
}
