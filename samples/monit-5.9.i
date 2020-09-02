# 56 "src/protocols/mysql.c"
static unsigned short B2(unsigned char *b) {
        unsigned short x;
        *(((char *)&x) + 0) = b[1];
        *(((char *)&x) + 1) = b[0];
        return (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (x); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

