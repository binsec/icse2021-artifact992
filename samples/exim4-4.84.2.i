;

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 43 "/usr/include/i386-linux-gnu/bits/uio.h"
struct iovec
  {
    void *iov_base; /* Pointer to data.  */
    size_t iov_len; /* Length of data.  */
  };

# 51 "../mytypes.h"
typedef unsigned char uschar;

# 73 "pwcheck.c"
static int retry_read(int, void *, unsigned );

# 74 "pwcheck.c"
static int retry_writev(int, struct iovec *, int );

# 289 "pwcheck.c"
static int read_string(int fd, uschar **retval) {
    unsigned short count;
    int rc;

    rc = (retry_read(fd, &count, sizeof(count)) < (int) sizeof(count));
    if (!rc) {
        count = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (count); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
        if (count > 1024) {
            return -1;
        } else {
            *retval = store_get_3(count + 1, "pwcheck.c", 299);
            rc = (retry_read(fd, *retval, count) < (int) count);
            (*retval)[count] = '\0';
            return count;
        }
    }
    return -1;
}

# 316 "pwcheck.c"
static int write_string(int fd, const uschar *string, int len) {
    unsigned short count;
    int rc;
    struct iovec iov[2];

    count = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (len); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

    iov[0].iov_base = (void *) &count;
    iov[0].iov_len = sizeof(count);
    iov[1].iov_base = (void *) string;
    iov[1].iov_len = len;

    rc = retry_writev(fd, iov, 2);

    return rc;
}

