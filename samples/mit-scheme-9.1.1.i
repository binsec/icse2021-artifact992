# 140 "uxsock.c"
unsigned long
OS_get_service_by_number (const unsigned long port_number)
{
  return ((unsigned long) ((__extension__ ({ unsigned short int __v, __x = (unsigned short int) ((unsigned short) port_number); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }))));
}

