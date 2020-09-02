# 48 "../src/cim/cim_rtns.h"
extern unsigned char *cim_gp_ptr;

# 50 "../src/cim/cim_rtns.h"
extern unsigned char *cim_cmd_base_ptr;

# 51 "../src/cim/cim_rtns.h"
extern unsigned char *cim_cmd_ptr;

# 661 "../src/cim/cim_defs.h"
void
cim_outd(unsigned short port, unsigned long data)
{
    __asm__ __volatile__("outl %0,%w1"::"a"(data), "Nd"(port));
}

# 674 "../src/cim/cim_defs.h"
unsigned long
cim_ind(unsigned short port)
{
    unsigned long value;
    __asm__ __volatile__("inl %w1,%0":"=a"(value):"Nd"(port));

    return value;
}

# 690 "../src/cim/cim_defs.h"
void
cim_outw(unsigned short port, unsigned short data)
{
    __asm__ volatile ("out %0,%1"::"a" (data), "d"(port));
}

# 703 "../src/cim/cim_defs.h"
unsigned short
cim_inw(unsigned short port)
{
    unsigned short value;
    __asm__ volatile ("in %1,%0":"=a" (value):"d"(port));

    return value;
}

# 719 "../src/cim/cim_defs.h"
unsigned char
cim_inb(unsigned short port)
{
    unsigned char value;
    __asm__ volatile ("inb %1,%0":"=a" (value):"d"(port));

    return value;
}

# 735 "../src/cim/cim_defs.h"
void
cim_outb(unsigned short port, unsigned char data)
{
    __asm__ volatile ("outb %0,%1"::"a" (data), "d"(port));
}

# 36 "../src/cim/cim_gp.c"
static unsigned long gp3_bpp = 0;

# 37 "../src/cim/cim_gp.c"
static unsigned long gp3_ch3_bpp = 0;

# 38 "../src/cim/cim_gp.c"
static unsigned long gp3_pat_origin = 0;

# 39 "../src/cim/cim_gp.c"
static unsigned long gp3_buffer_lead = 0;

# 40 "../src/cim/cim_gp.c"
static unsigned long gp3_cmd_header;

# 41 "../src/cim/cim_gp.c"
static unsigned long gp3_cmd_top;

# 42 "../src/cim/cim_gp.c"
static unsigned long gp3_cmd_bottom;

# 43 "../src/cim/cim_gp.c"
static unsigned long gp3_cmd_current;

# 44 "../src/cim/cim_gp.c"
static unsigned long gp3_cmd_next;

# 45 "../src/cim/cim_gp.c"
static unsigned long gp3_blt_mode;

# 47 "../src/cim/cim_gp.c"
static unsigned long gp3_raster_mode;

# 48 "../src/cim/cim_gp.c"
static unsigned long gp3_pix_shift;

# 49 "../src/cim/cim_gp.c"
static unsigned long gp3_ch3_pat;

# 50 "../src/cim/cim_gp.c"
static unsigned long gp3_blt;

# 51 "../src/cim/cim_gp.c"
static unsigned long gp3_blt_flags;

# 52 "../src/cim/cim_gp.c"
static unsigned long gp3_src_stride;

# 53 "../src/cim/cim_gp.c"
static unsigned long gp3_dst_stride;

# 54 "../src/cim/cim_gp.c"
static unsigned long gp3_src_format;

# 55 "../src/cim/cim_gp.c"
static unsigned long gp3_src_pix_shift;

# 56 "../src/cim/cim_gp.c"
static unsigned long gp3_pat_format;

# 57 "../src/cim/cim_gp.c"
static unsigned long gp3_pat_pix_shift;

# 58 "../src/cim/cim_gp.c"
static unsigned long gp3_fb_base;

# 60 "../src/cim/cim_gp.c"
static unsigned long gp3_scratch_base;

# 61 "../src/cim/cim_gp.c"
static unsigned long gp3_base_register;

# 231 "../src/cim/cim_gp.c"
void
gp_declare_blt(unsigned long flags)
{
    unsigned long temp;

    gp3_blt = 1;
    gp3_blt_flags = flags;

    /* SET ADDRESS OF NEXT COMMAND */
    /* A summary of the command buffer logic is as follows:           */
    /*  - If after a basic BLT we will not have room for the largest  */
    /*    command (a full line of host source data), we set the wrap  */
    /*    bit.  This will waste up to a whopping 8K of command buffer */
    /*    space, but it simplifies the logic for all commands.        */
    /* -  If we are wrapping, we have extra logic to ensure that we   */
    /*    don't skip over the current GP read pointer.                */

    gp3_cmd_next = gp3_cmd_current + 68 /* 18 DWORDS */;

    /* CHECK WRAP CONDITION */

    if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 252 "../src/cim/cim_gp.c"
                                                               ) {
        gp3_cmd_next = gp3_cmd_top;
        gp3_cmd_header = 0x00000000 | 0x80000000;

        /* WAIT FOR HARDWARE */
        /* When wrapping, we must take steps to ensure that we do not    */
        /* wrap over the current hardware read pointer.  We do this by   */
        /* verifying that the hardware is not between us and the end of  */
        /* the command buffer.  We also have a special case to make sure */
        /* that the hardware is not currently reading the top of the     */
        /* command buffer.                                               */

        while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
    }
    else {
        gp3_cmd_header = 0x00000000;

        /* WAIT FOR AVAILABLE SPACE */

        while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
    }

    if (flags & 0x0020) {
        while (1) {
            temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)));
            if (((gp3_cmd_current >= temp)
                 && ((gp3_cmd_current - temp) <= gp3_buffer_lead))
                || ((gp3_cmd_current < temp)
                    && ((gp3_cmd_current + (gp3_cmd_bottom - temp)) <=
                        gp3_buffer_lead))) {
                break;
            }
        }
    }

    /* SET THE CURRENT BUFFER POINTER */
    /* We initialize a pointer to the current buffer base to avoid an */
    /* extra addition for every buffer write.                         */

    cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

    /* SET THE HAZARD BIT */

    if (flags & 0x0008)
        gp3_cmd_header |= 0x10000000;
}

# 618 "../src/cim/cim_gp.c"
void
gp_set_color_pattern(unsigned long *pattern, int format, int x, int y)
{
    unsigned long size_dwords, temp;

    gp3_ch3_pat = 1;

    /* SAVE COLOR PATTERN SOURCE INFO
     * Color patterns can be in a format different than the primary display.
     * 4BPP patterns are not supported.
     */

    gp3_pat_pix_shift = (unsigned long) ((format >> 2) & 3);
    gp3_pat_format = (((unsigned long) format & 0xF) << 24) |
        (((unsigned long) format & 0x10) << 17) |
        0x00200000 | 0x80000000;

    size_dwords = (64 << gp3_pat_pix_shift) >> 2;

    /* CHECK FOR WRAP AFTER LUT LOAD                 */
    /* Primitive size is 12 plus the amount of data. */

    gp3_cmd_next = gp3_cmd_current + (size_dwords << 2) + 12;

    if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 642 "../src/cim/cim_gp.c"
                                                               ) {
        gp3_cmd_next = gp3_cmd_top;
        gp3_cmd_header = 0x40000000 | 0x80000000 |
            0x00000003;

        /* WAIT FOR HARDWARE           */
        /* Same logic as BLT wrapping. */

        while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
    }
    else {
        gp3_cmd_header = 0x40000000 | 0x00000003;

        /* WAIT FOR AVAILABLE SPACE */

        while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
    }

    /* SAVE CURRENT BUFFER POINTER */

    cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

    /* PREPARE FOR COMMAND BUFFER DATA WRITES                 */
    /* Pattern data is contiguous DWORDs at LUT address 0x100 */

    (*(unsigned long *)(cim_cmd_ptr + (0))) = (gp3_cmd_header);
    (*(unsigned long *)(cim_cmd_ptr + (4))) = (0x100);
    (*(unsigned long *)(cim_cmd_ptr + (8))) = (size_dwords | 0x60000000);

    /* WRITE ALL DATA */

    { int d0, d1, d2; __asm__ __volatile__( " rep\n" " movsl\n" : "=&c" (d0), "=&S" (d1), "=&D" (d2) : "0" (size_dwords), "1" ((const char *)((unsigned long)(pattern)+(0))), "2" ((char *)cim_cmd_ptr+ ((unsigned long)(12))) : "memory"); };

    /* START OPERATION */

    (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
    gp3_cmd_current = gp3_cmd_next;

    /* SAVE PATTERN ORIGIN */

    gp3_pat_origin = ((unsigned long) y << 29) |
        (((unsigned long) x & 7) << 26);
}

# 769 "../src/cim/cim_gp.c"
void
gp_program_lut(unsigned long *colors, int full_lut)
{
    unsigned long size_dwords, temp;

    /* SIZE IS EITHER 16 DWORDS (4BPP) or 256 DWORDS (8BPP) */

    if (full_lut)
        size_dwords = 256;
    else
        size_dwords = 16;

    /* CHECK FOR WRAP AFTER LUT LOAD                 */
    /* Primitive size is 12 plus the amount of data. */

    gp3_cmd_next = gp3_cmd_current + (size_dwords << 2) + 12;

    if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 786 "../src/cim/cim_gp.c"
                                                               ) {
        gp3_cmd_next = gp3_cmd_top;
        gp3_cmd_header = 0x40000000 | 0x80000000 |
            0x00000003;

        /* WAIT FOR HARDWARE           */
        /* Same logic as BLT wrapping. */

        while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
    }
    else {
        gp3_cmd_header = 0x40000000 | 0x00000003;

        /* WAIT FOR AVAILABLE SPACE */

        while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
    }

    /* SAVE CURRENT BUFFER POINTER */

    cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

    /* PREPARE FOR COMMAND BUFFER DATA WRITES             */
    /* Pattern data is contiguous DWORDs at LUT address 0 */

    (*(unsigned long *)(cim_cmd_ptr + (0))) = (gp3_cmd_header);
    (*(unsigned long *)(cim_cmd_ptr + (4))) = (0);
    (*(unsigned long *)(cim_cmd_ptr + (8))) = ((size_dwords | 0x60000000));

    /* WRITE ALL DATA */

    { int d0, d1, d2; __asm__ __volatile__( " rep\n" " movsl\n" : "=&c" (d0), "=&S" (d1), "=&D" (d2) : "0" (size_dwords), "1" ((const char *)((unsigned long)(colors)+(0))), "2" ((char *)cim_cmd_ptr+ ((unsigned long)(12))) : "memory"); };

    /* START OPERATION */

    (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
    gp3_cmd_current = gp3_cmd_next;
}

# 1238 "../src/cim/cim_gp.c"
void
gp_color_bitmap_to_screen_blt(unsigned long dstoffset, unsigned long srcx,
                              unsigned long width, unsigned long height,
                              unsigned char *data, long pitch)
{
    unsigned long indent, temp;
    unsigned long total_dwords, size_dwords;
    unsigned long dword_count, byte_count;
    unsigned long size = ((width << 16) | height);
    unsigned long srcoffset;

    /* ASSUME BITMAPS ARE DWORD ALIGNED */
    /* We will offset into the source data in DWORD increments.  We */
    /* set the source index to the remaining byte offset and        */
    /* increment the size of each line to account for the dont-care */
    /* pixel(s).                                                    */

    indent = srcx << gp3_pix_shift;
    srcoffset = (indent & ~3L);
    indent &= 3;

    /* PROGRAM THE NORMAL SOURCE CHANNEL REGISTERS                */
    /* We assume that a color pattern is being ROPed with source  */
    /* data if the pattern type is color and the preserve pattern */
    /* was set.                                                   */

    gp3_cmd_header |= 0x00000004 |
        0x00000002 |
        0x00000010 |
        0x00001000 |
        0x00004000 | 0x00008000;

    if (gp3_ch3_pat) {
        gp3_cmd_header |= 0x00000800 |
            0x00002000;

        (*(unsigned long *)(cim_cmd_ptr + (0x00000030))) = (gp3_pat_origin);
        (*(unsigned long *)(cim_cmd_ptr + (0x00000008))) = ((dstoffset & 0x3FFFFF));
        (*(unsigned long *)(cim_cmd_ptr + (0x00000034))) = (gp3_pat_format);
        (*(unsigned long *)(cim_cmd_ptr + (0x00000038))) = (size);
    }
    else {
        (*(unsigned long *)(cim_cmd_ptr + (0x00000008))) = (((dstoffset & 0x3FFFFF) | gp3_pat_origin))
                                                                  ;
        (*(unsigned long *)(cim_cmd_ptr + (0x00000034))) = (0);
    }

    (*(unsigned long *)(cim_cmd_ptr + (0x0000000C))) = (indent);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000014))) = (size);
    (*(unsigned long *)(cim_cmd_ptr + (0x0000003C))) = (((gp3_fb_base << 24) + (dstoffset & 0xFFC00000)))
                                                                     ;
    (*(unsigned long *)(cim_cmd_ptr + (0x00000040))) = (gp3_blt_mode | 0x00000002 /* src = host register      */);

    /* START THE BLT */

    (*(unsigned long *)(cim_cmd_ptr + (0x00000000))) = (gp3_cmd_header);
    (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
    gp3_cmd_current = gp3_cmd_next;

    /* CALCULATE THE SIZE OF ONE LINE */

    size = (width << gp3_pix_shift) + indent;
    total_dwords = (size + 3) >> 2;
    size_dwords = (total_dwords << 2) + 8;
    dword_count = (size >> 2);
    byte_count = (size & 3);

    /* CHECK FOR SMALL BLT CASE */

    if (((total_dwords << 2) * height) <= 0xC7F8 /* (50K - 8) is largest
                                                         * 1-Pass load size */
# 1307 "../src/cim/cim_gp.c"
                                                             &&
        (gp3_cmd_bottom - gp3_cmd_current) > (0xC7F8 /* (50K - 8) is largest
                                                         * 1-Pass load size */
# 1308 "../src/cim/cim_gp.c"
                                                                 + 72)) {
        /* UPDATE THE COMMAND POINTER */

        cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

        /* CHECK IF A WRAP WILL BE NEEDED */

        gp3_cmd_next = gp3_cmd_current + ((total_dwords << 2) * height) + 8;

        if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 1317 "../src/cim/cim_gp.c"
                                                                   ) {
            gp3_cmd_next = gp3_cmd_top;

            while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x80000000 | 0x00000001)

                                                     ;
        }
        else {
            while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x00000001)
                                                                              ;
        }

        /* WRITE DWORD COUNT */

        (*(unsigned long *)(cim_cmd_ptr + (4))) = (0x00000000 | (total_dwords * height));

        while (height--) {
            /* WRITE DATA */

            { int d0, d1, d2; __asm__ __volatile__( " rep\n" " movsl\n" : "=&c" (d0), "=&S" (d1), "=&D" (d2) : "0" (dword_count), "1" ((const char *)((unsigned long)(data)+(srcoffset))), "2" ((char *)cim_cmd_ptr+ ((unsigned long)(8))) : "memory"); };
            { unsigned long i; unsigned long array = (unsigned long)data + (srcoffset + (dword_count << 2)); for (i = 0; i < byte_count; i++) (*(unsigned char *)(cim_cmd_ptr + ((8 + (dword_count << 2)) + i))) = (*((unsigned char *)(array + i))); }
                                                                             ;

            srcoffset += pitch;
            cim_cmd_ptr += total_dwords << 2;
        }

        (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
        gp3_cmd_current = gp3_cmd_next;
    }
    else {
        /*
         * Each line will be created as a separate command buffer entry to
         * allow line-by-line wrapping and to allow simultaneous rendering
         * by the HW.
         */

        while (height--) {
            /* UPDATE THE COMMAND POINTER
             * The WRITE_COMMANDXX macros use a pointer to the current buffer
             * space.  This is created by adding gp3_cmd_current to the base
             * pointer.
             */

            cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

            /* CHECK IF A WRAP WILL BE NEEDED */

            gp3_cmd_next = gp3_cmd_current + size_dwords;
            if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 1368 "../src/cim/cim_gp.c"
                                                                       ) {
                gp3_cmd_next = gp3_cmd_top;

                /* WAIT FOR HARDWARE */

                while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
                (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x80000000 | 0x00000001)

                                                         ;
            }
            else {
                /* WAIT FOR AVAILABLE SPACE */

                while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
                (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x00000001)
                                                         ;
            }

            /* WRITE DWORD COUNT */

            (*(unsigned long *)(cim_cmd_ptr + (4))) = (0x00000000 | total_dwords);

            /* WRITE DATA */

            { int d0, d1, d2; __asm__ __volatile__( " rep\n" " movsl\n" : "=&c" (d0), "=&S" (d1), "=&D" (d2) : "0" (dword_count), "1" ((const char *)((unsigned long)(data)+(srcoffset))), "2" ((char *)cim_cmd_ptr+ ((unsigned long)(8))) : "memory"); };
            { unsigned long i; unsigned long array = (unsigned long)data + (srcoffset + (dword_count << 2)); for (i = 0; i < byte_count; i++) (*(unsigned char *)(cim_cmd_ptr + ((8 + (dword_count << 2)) + i))) = (*((unsigned char *)(array + i))); }
                                                                             ;

            /* UPDATE POINTERS */

            srcoffset += pitch;
            (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
            gp3_cmd_current = gp3_cmd_next;
        }
    }
}

# 1413 "../src/cim/cim_gp.c"
void
gp_color_convert_blt(unsigned long dstoffset, unsigned long srcx,
                     unsigned long width, unsigned long height,
                     unsigned char *data, long pitch)
{
    unsigned long indent, temp;
    unsigned long total_dwords, size_dwords;
    unsigned long dword_count, byte_count;
    unsigned long size = ((width << 16) | height);
    unsigned long ch3_size;
    unsigned long ch3_offset, srcoffset;
    unsigned long base;

    /* ASSUME BITMAPS ARE DWORD ALIGNED */
    /* We will offset into the source data in DWORD increments.  We  */
    /* set the source index to the remaining byte offset and         */
    /* increment the size of each line to account for the dont-care  */
    /* pixel(s).   For 4BPP source data, we also set the appropriate */
    /* nibble index.                                                 */

    /* CALCULATE THE SIZE OF ONE LINE */

    if ((gp3_src_format & 0x0F000000) == 0x0B000000) {
        /* HANDLE 24BPP
         * Note that we do not do anything to guarantee that the source data
         * is DWORD aligned.  The logic here is that the source data will be
         * cacheable, in which case Geode LX will not lose any clocks for
         * unaligned moves.  Also note that the channel 3 width is
         * programmed as the number of dwords, while the normal width is
         * programmed as the number of pixels.
         */

        srcoffset = srcx * 3;
        ch3_offset = 0;
        temp = width * 3;
        ch3_size = (((temp + 3) >> 2) << 16) | height;
    }
    else {
        ch3_size = size;

        if (gp3_src_pix_shift == 3) {
            /* CALCULATE INDENT AND SOURCE OFFSET */

            indent = (srcx >> 1);
            srcoffset = (indent & ~3L);
            indent &= 3;
            ch3_offset = indent | ((srcx & 1) << 25);

            temp = ((width + (srcx & 1) + 1) >> 1) + indent;
        }
        else {
            indent = (srcx << gp3_src_pix_shift);
            srcoffset = (indent & ~3L);
            indent &= 3;
            ch3_offset = indent;

            temp = (width << gp3_src_pix_shift) + indent;
        }
    }

    total_dwords = (temp + 3) >> 2;
    size_dwords = (total_dwords << 2) + 8;
    dword_count = (temp >> 2);
    byte_count = (temp & 3);

    base = ((gp3_fb_base << 24) + (dstoffset & 0xFFC00000)) |
        (gp3_base_register & ~0xFFC00000);

    /* SET APPROPRIATE ENABLES */

    gp3_cmd_header |= 0x00000002 |
        0x00000010 |
        0x00001000 |
        0x00000800 |
        0x00002000 |
        0x00004000 | 0x00008000;

    (*(unsigned long *)(cim_cmd_ptr + (0x00000008))) = ((dstoffset & 0x3FFFFF) | gp3_pat_origin)
                                                            ;
    (*(unsigned long *)(cim_cmd_ptr + (0x00000030))) = (ch3_offset);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000014))) = (size);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000038))) = (ch3_size);
    (*(unsigned long *)(cim_cmd_ptr + (0x0000003C))) = (base);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000034))) = (0x80000000 | 0x40000000 | 0x00040000 | gp3_src_format | ((gp3_blt_flags & 0x0001) << 20))


                                             ;
    (*(unsigned long *)(cim_cmd_ptr + (0x00000040))) = (gp3_blt_mode);

    /* START THE BLT */

    (*(unsigned long *)(cim_cmd_ptr + (0x00000000))) = (gp3_cmd_header);
    (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
    gp3_cmd_current = gp3_cmd_next;

    if (((total_dwords << 2) * height) <= 0xC7F8 /* (50K - 8) is largest
                                                         * 1-Pass load size */
# 1508 "../src/cim/cim_gp.c"
                                                             &&
        (gp3_cmd_bottom - gp3_cmd_current) > (0xC7F8 /* (50K - 8) is largest
                                                         * 1-Pass load size */
# 1509 "../src/cim/cim_gp.c"
                                                                 + 72)) {
        /* UPDATE THE COMMAND POINTER */

        cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

        /* CHECK IF A WRAP WILL BE NEEDED */

        gp3_cmd_next = gp3_cmd_current + ((total_dwords << 2) * height) + 8;

        if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 1518 "../src/cim/cim_gp.c"
                                                                   ) {
            gp3_cmd_next = gp3_cmd_top;

            while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x80000000 | 0x00000001)
                                                                              ;
        }
        else {
            while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x00000001)
                                                                              ;
        }

        /* WRITE DWORD COUNT */

        (*(unsigned long *)(cim_cmd_ptr + (4))) = (0x20000000 | (total_dwords * height));

        while (height--) {
            /* WRITE DATA */

            { int d0, d1, d2; __asm__ __volatile__( " rep\n" " movsl\n" : "=&c" (d0), "=&S" (d1), "=&D" (d2) : "0" (dword_count), "1" ((const char *)((unsigned long)(data)+(srcoffset))), "2" ((char *)cim_cmd_ptr+ ((unsigned long)(8))) : "memory"); };
            { unsigned long i; unsigned long array = (unsigned long)data + (srcoffset + (dword_count << 2)); for (i = 0; i < byte_count; i++) (*(unsigned char *)(cim_cmd_ptr + ((8 + (dword_count << 2)) + i))) = (*((unsigned char *)(array + i))); }
                                                                             ;

            srcoffset += pitch;
            cim_cmd_ptr += total_dwords << 2;
        }

        (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
        gp3_cmd_current = gp3_cmd_next;
    }
    else {
        /* WRITE DATA LINE BY LINE
         * Each line will be created as a separate command buffer entry to
         * allow line-by-line wrapping and to allow simultaneous rendering
         * by the HW.
         */

        while (height--) {
            /* UPDATE THE COMMAND POINTER
             * The WRITE_COMMANDXX macros use a pointer to the current buffer
             * space. This is created by adding gp3_cmd_current to the base
             * pointer.
             */

            cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

            /* CHECK IF A WRAP WILL BE NEEDED */

            gp3_cmd_next = gp3_cmd_current + size_dwords;
            if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 1568 "../src/cim/cim_gp.c"
                                                                       ) {
                gp3_cmd_next = gp3_cmd_top;

                /* WAIT FOR HARDWARE */

                while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
                (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x80000000 | 0x00000001)

                                                         ;
            }
            else {
                /* WAIT FOR AVAILABLE SPACE */

                while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
                (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x00000001)
                                                         ;
            }

            /* WRITE DWORD COUNT */

            (*(unsigned long *)(cim_cmd_ptr + (4))) = (0x20000000 | total_dwords);

            /* WRITE DATA */

            { int d0, d1, d2; __asm__ __volatile__( " rep\n" " movsl\n" : "=&c" (d0), "=&S" (d1), "=&D" (d2) : "0" (dword_count), "1" ((const char *)((unsigned long)(data)+(srcoffset))), "2" ((char *)cim_cmd_ptr+ ((unsigned long)(8))) : "memory"); };
            { unsigned long i; unsigned long array = (unsigned long)data + (srcoffset + (dword_count << 2)); for (i = 0; i < byte_count; i++) (*(unsigned char *)(cim_cmd_ptr + ((8 + (dword_count << 2)) + i))) = (*((unsigned char *)(array + i))); }
                                                                             ;

            /* UPDATE POINTERS */

            srcoffset += pitch;
            (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
            gp3_cmd_current = gp3_cmd_next;
        }
    }
}

# 1615 "../src/cim/cim_gp.c"
void
gp_custom_convert_blt(unsigned long dstoffset, unsigned long srcx,
                      unsigned long width, unsigned long height,
                      unsigned char *data, long pitch)
{
    unsigned long indent, temp;
    unsigned long total_dwords, size_dwords;
    unsigned long dword_count, byte_count;
    unsigned long size = ((width << 16) | height);
    unsigned long ch3_offset, srcoffset;
    unsigned long ch3_size, base;

    /* ASSUME BITMAPS ARE DWORD ALIGNED */
    /* We will offset into the source data in DWORD increments.  We  */
    /* set the source index to the remaining byte offset and         */
    /* increment the size of each line to account for the dont-care  */
    /* pixel(s).   For 4BPP source data, we also set the appropriate */
    /* nibble index.                                                 */

    /* CALCULATE THE SIZE OF ONE LINE */

    if ((gp3_src_format & 0x0F000000) == 0x0B000000) {
        /* HANDLE 24BPP
         * Note that we do not do anything to guarantee that the source data
         * is DWORD aligned.  The logic here is that the source data will be
         * cacheable, in which case Geode LX will not lose any clocks for
         * unaligned moves.  Also note that the channel 3 width is programmed
         * as the number of dwords, while the normal width is programmed as
         * the number of pixels.
         */

        srcoffset = srcx * 3;
        ch3_offset = 0;
        temp = width * 3;
        ch3_size = (((temp + 3) >> 2) << 16) | height;
    }
    else {
        ch3_size = size;

        if (gp3_src_pix_shift == 3) {
            /* CALCULATE INDENT AND SOURCE OFFSET */

            indent = (srcx >> 1);
            srcoffset = (indent & ~3L);
            indent &= 3;
            ch3_offset = indent | ((srcx & 1) << 25);

            temp = ((width + (srcx & 1) + 1) >> 1) + indent;
        }
        else {
            indent = (srcx << gp3_src_pix_shift);
            srcoffset = (indent & ~3L);
            indent &= 3;
            ch3_offset = indent;

            temp = (width << gp3_src_pix_shift) + indent;
        }
    }

    total_dwords = (temp + 3) >> 2;
    size_dwords = (total_dwords << 2) + 8;
    dword_count = (temp >> 2);
    byte_count = (temp & 3);

    base = ((gp3_fb_base << 24) + (dstoffset & 0xFFC00000)) |
        (gp3_base_register & ~0xFFC00000);

    /* SET APPROPRIATE ENABLES */

    gp3_cmd_header |= 0x00000002 |
        0x00000010 |
        0x00001000 |
        0x00000800 |
        0x00002000 |
        0x00004000 | 0x00008000;

    (*(unsigned long *)(cim_cmd_ptr + (0x00000008))) = ((dstoffset & 0x3FFFFF) | gp3_pat_origin)
                                                            ;
    (*(unsigned long *)(cim_cmd_ptr + (0x00000030))) = (ch3_offset);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000014))) = (size);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000038))) = (ch3_size);
    (*(unsigned long *)(cim_cmd_ptr + (0x0000003C))) = (base);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000034))) = (0x80000000 | 0x40000000 | 0x00040000 | gp3_src_format | ((gp3_blt_flags & 0x0001) << 20))


                                             ;
    (*(unsigned long *)(cim_cmd_ptr + (0x00000040))) = (gp3_blt_mode);

    /* START THE BLT */

    (*(unsigned long *)(cim_cmd_ptr + (0x00000000))) = (gp3_cmd_header);
    (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
    gp3_cmd_current = gp3_cmd_next;

    if (((total_dwords << 2) * height) <= 0xC7F8 /* (50K - 8) is largest
                                                         * 1-Pass load size */
# 1709 "../src/cim/cim_gp.c"
                                                             &&
        (gp3_cmd_bottom - gp3_cmd_current) > (0xC7F8 /* (50K - 8) is largest
                                                         * 1-Pass load size */
# 1710 "../src/cim/cim_gp.c"
                                                                 + 72)) {
        /* UPDATE THE COMMAND POINTER */

        cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

        /* CHECK IF A WRAP WILL BE NEEDED */

        gp3_cmd_next = gp3_cmd_current + ((total_dwords << 2) * height) + 8;

        if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 1719 "../src/cim/cim_gp.c"
                                                                   ) {
            gp3_cmd_next = gp3_cmd_top;

            while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x80000000 | 0x00000001)

                                                     ;
        }
        else {
            while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x00000001)
                                                                              ;
        }

        /* WRITE DWORD COUNT */

        (*(unsigned long *)(cim_cmd_ptr + (4))) = (0x20000000 | (total_dwords * height));

        while (height--) {
            /* WRITE DATA */

            { int d0, d1, d2; __asm__ __volatile__( " rep\n" " movsl\n" : "=&c" (d0), "=&S" (d1), "=&D" (d2) : "0" (dword_count), "1" ((const char *)((unsigned long)(data)+(srcoffset))), "2" ((char *)cim_cmd_ptr+ ((unsigned long)(8))) : "memory"); };
            { unsigned long i; unsigned long array = (unsigned long)data + (srcoffset + (dword_count << 2)); for (i = 0; i < byte_count; i++) (*(unsigned char *)(cim_cmd_ptr + ((8 + (dword_count << 2)) + i))) = (*((unsigned char *)(array + i))); }

                                                    ;

            srcoffset += pitch;
            cim_cmd_ptr += total_dwords << 2;
        }

        (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
        gp3_cmd_current = gp3_cmd_next;
    }
    else {
        /* WRITE DATA LINE BY LINE
         * Each line will be created as a separate command buffer entry to
         * allow line-by-line wrapping and to allow simultaneous rendering
         * by the HW.
         */

        while (height--) {
            /* UPDATE THE COMMAND POINTER
             * The WRITE_COMMANDXX macros use a pointer to the current buffer
             * space. This is created by adding gp3_cmd_current to the base
             * pointer.
             */

            cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

            /* CHECK IF A WRAP WILL BE NEEDED */

            gp3_cmd_next = gp3_cmd_current + size_dwords;
            if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 1771 "../src/cim/cim_gp.c"
                                                                       ) {
                gp3_cmd_next = gp3_cmd_top;

                /* WAIT FOR HARDWARE */

                while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
                (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x80000000 | 0x00000001)

                                                           ;
            }
            else {
                /* WAIT FOR AVAILABLE SPACE */

                while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
                (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x00000001)

                                                         ;
            }

            /* WRITE DWORD COUNT */

            (*(unsigned long *)(cim_cmd_ptr + (4))) = (0x20000000 | total_dwords);

            /* WRITE DATA */

            { int d0, d1, d2; __asm__ __volatile__( " rep\n" " movsl\n" : "=&c" (d0), "=&S" (d1), "=&D" (d2) : "0" (dword_count), "1" ((const char *)((unsigned long)(data)+(srcoffset))), "2" ((char *)cim_cmd_ptr+ ((unsigned long)(8))) : "memory"); };
            { unsigned long i; unsigned long array = (unsigned long)data + (srcoffset + (dword_count << 2)); for (i = 0; i < byte_count; i++) (*(unsigned char *)(cim_cmd_ptr + ((8 + (dword_count << 2)) + i))) = (*((unsigned char *)(array + i))); }

                                                    ;

            /* UPDATE POINTERS */

            srcoffset += pitch;
            (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
            gp3_cmd_current = gp3_cmd_next;
        }
    }
}

# 1913 "../src/cim/cim_gp.c"
void
gp_mono_bitmap_to_screen_blt(unsigned long dstoffset, unsigned long srcx,
                             unsigned long width, unsigned long height,
                             unsigned char *data, long stride)
{
    unsigned long indent, temp;
    unsigned long total_dwords, size_dwords;
    unsigned long dword_count, byte_count;
    unsigned long size = ((width << 16) | height);
    unsigned long srcoffset, src_value;

    /* ASSUME BITMAPS ARE DWORD ALIGNED */
    /* We will offset into the source data in DWORD increments.  We */
    /* set the source index to the remaining byte offset and        */
    /* increment the size of each line to account for the dont-care */
    /* pixel(s).                                                    */

    indent = (srcx >> 3);
    srcoffset = (indent & ~3L);
    indent &= 3;
    src_value = (indent | ((srcx & 7) << 26));

    /* PROGRAM THE NORMAL SOURCE CHANNEL REGISTERS                */
    /* We assume that a color pattern is being ROPed with source  */
    /* data if the pattern type is color and the preserve pattern */
    /* was set.                                                   */

    gp3_cmd_header |= 0x00000004 |
        0x00000002 |
        0x00000010 |
        0x00001000 |
        0x00004000 |
        0x00000001 | 0x00008000;

    if (gp3_ch3_pat) {
        gp3_cmd_header |=
            0x00000800 | 0x00002000;

        (*(unsigned long *)(cim_cmd_ptr + (0x00000030))) = (gp3_pat_origin);
        (*(unsigned long *)(cim_cmd_ptr + (0x00000008))) = ((dstoffset & 0x3FFFFF));
        (*(unsigned long *)(cim_cmd_ptr + (0x00000034))) = (gp3_pat_format);
        (*(unsigned long *)(cim_cmd_ptr + (0x00000038))) = (size);
    }
    else {
        (*(unsigned long *)(cim_cmd_ptr + (0x00000008))) = (((dstoffset & 0x3FFFFF) | gp3_pat_origin))
                                                                  ;
        (*(unsigned long *)(cim_cmd_ptr + (0x00000034))) = (0);
    }
    if (gp3_blt_flags & 0x0010) {
        (*(unsigned long *)(cim_cmd_ptr + (0x00000004))) = (gp3_raster_mode | 0x00002000 /* Invert monochrome src    */)
                                                               ;
    }
    else {
        (*(unsigned long *)(cim_cmd_ptr + (0x00000004))) = (gp3_raster_mode & ~0x00002000 /* Invert monochrome src    */)
                                                                ;
    }
    (*(unsigned long *)(cim_cmd_ptr + (0x0000000C))) = (src_value);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000014))) = (size);
    (*(unsigned long *)(cim_cmd_ptr + (0x0000003C))) = (((gp3_fb_base << 24) + (dstoffset & 0xFFC00000)))
                                                                     ;
    (*(unsigned long *)(cim_cmd_ptr + (0x00000040))) = (gp3_blt_mode | 0x00000002 /* src = host register      */ | 0x00000040 /* monochrome source data   */)
                                                                     ;

    /* START THE BLT */

    (*(unsigned long *)(cim_cmd_ptr + (0x00000000))) = (gp3_cmd_header);
    (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
    gp3_cmd_current = gp3_cmd_next;

    /* CALCULATE THE SIZE OF ONE LINE */

    size = ((width + (srcx & 7) + 7) >> 3) + indent;
    total_dwords = (size + 3) >> 2;
    size_dwords = (total_dwords << 2) + 8;
    dword_count = (size >> 2);
    byte_count = (size & 3);

    /* CHECK FOR SMALL BLT CASE */
    /* If the total amount of monochrome data is less than 50K and we have */
    /* room in the command buffer, we will do all data writes in a single  */
    /* data packet.                                                        */

    if (((total_dwords << 2) * height) <= 0xC7F8 /* (50K - 8) is largest
                                                         * 1-Pass load size */
# 1995 "../src/cim/cim_gp.c"
                                                             &&
        (gp3_cmd_bottom - gp3_cmd_current) > (0xC7F8 /* (50K - 8) is largest
                                                         * 1-Pass load size */
# 1996 "../src/cim/cim_gp.c"
                                                                 + 72)) {
        /* UPDATE THE COMMAND POINTER */

        cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

        /* CHECK IF A WRAP WILL BE NEEDED */

        gp3_cmd_next = gp3_cmd_current + ((total_dwords << 2) * height) + 8;

        if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 2005 "../src/cim/cim_gp.c"
                                                                   ) {
            gp3_cmd_next = gp3_cmd_top;

            while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x80000000 | 0x00000001)

                                                     ;
        }
        else {
            while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x00000001)
                                                                              ;
        }

        /* WRITE DWORD COUNT */

        (*(unsigned long *)(cim_cmd_ptr + (4))) = (0x00000000 | (total_dwords * height));

        while (height--) {
            /* WRITE DATA */

            { int d0, d1, d2; __asm__ __volatile__( " rep\n" " movsl\n" : "=&c" (d0), "=&S" (d1), "=&D" (d2) : "0" (dword_count), "1" ((const char *)((unsigned long)(data)+(srcoffset))), "2" ((char *)cim_cmd_ptr+ ((unsigned long)(8))) : "memory"); };
            { unsigned long i; unsigned long array = (unsigned long)data + (srcoffset + (dword_count << 2)); for (i = 0; i < byte_count; i++) (*(unsigned char *)(cim_cmd_ptr + ((8 + (dword_count << 2)) + i))) = (*((unsigned char *)(array + i))); }
                                                                             ;

            srcoffset += stride;
            cim_cmd_ptr += total_dwords << 2;
        }

        (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
        gp3_cmd_current = gp3_cmd_next;
    }
    else {
        /* WRITE DATA LINE BY LINE
         * Each line will be created as a separate command buffer entry to
         * allow line-by-line wrapping and to allow simultaneous rendering
         * by the HW.
         */

        while (height--) {
            /* UPDATE THE COMMAND POINTER
             * The WRITE_COMMANDXX macros use a pointer to the current buffer
             * space.  This is created by adding gp3_cmd_current to the base
             * pointer.
             */

            cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

            /* CHECK IF A WRAP WILL BE NEEDED */

            gp3_cmd_next = gp3_cmd_current + size_dwords;
            if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 2056 "../src/cim/cim_gp.c"
                                                                       ) {
                gp3_cmd_next = gp3_cmd_top;

                /* WAIT FOR HARDWARE */

                while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
                (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x80000000 | 0x00000001)

                                                           ;
            }
            else {
                /* WAIT FOR AVAILABLE SPACE */

                while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
                (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x00000001)

                                                         ;
            }

            /* WRITE DWORD COUNT */

            (*(unsigned long *)(cim_cmd_ptr + (4))) = (0x00000000 | total_dwords);

            /* WRITE DATA */

            { int d0, d1, d2; __asm__ __volatile__( " rep\n" " movsl\n" : "=&c" (d0), "=&S" (d1), "=&D" (d2) : "0" (dword_count), "1" ((const char *)((unsigned long)(data)+(srcoffset))), "2" ((char *)cim_cmd_ptr+ ((unsigned long)(8))) : "memory"); };
            { unsigned long i; unsigned long array = (unsigned long)data + (srcoffset + (dword_count << 2)); for (i = 0; i < byte_count; i++) (*(unsigned char *)(cim_cmd_ptr + ((8 + (dword_count << 2)) + i))) = (*((unsigned char *)(array + i))); }
                                                                             ;

            /* UPDATE POINTERS */

            srcoffset += stride;
            (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
            gp3_cmd_current = gp3_cmd_next;
        }
    }
}

# 2101 "../src/cim/cim_gp.c"
void
gp_text_blt(unsigned long dstoffset, unsigned long width,
            unsigned long height, unsigned char *data)
{
    unsigned long temp, dwords_total;
    unsigned long dword_count, byte_count;
    unsigned long size = ((width << 16) | height);
    unsigned long srcoffset = 0;

    /* PROGRAM THE NORMAL SOURCE CHANNEL REGISTERS                */
    /* We assume that a color pattern is being ROPed with source  */
    /* data if the pattern type is color and the preserve pattern */
    /* was set.                                                   */

    gp3_cmd_header |= 0x00000004 |
        0x00000002 |
        0x00000010 |
        0x00001000 |
        0x00004000 |
        0x00000001 | 0x00008000;

    if (gp3_ch3_pat) {
        gp3_cmd_header |=
            0x00000800 | 0x00002000;

        (*(unsigned long *)(cim_cmd_ptr + (0x00000030))) = (gp3_pat_origin);
        (*(unsigned long *)(cim_cmd_ptr + (0x00000008))) = ((dstoffset & 0x3FFFFF));
        (*(unsigned long *)(cim_cmd_ptr + (0x00000034))) = (gp3_pat_format);
        (*(unsigned long *)(cim_cmd_ptr + (0x00000038))) = (size);
    }
    else {
        (*(unsigned long *)(cim_cmd_ptr + (0x00000008))) = (((dstoffset & 0x3FFFFF) | gp3_pat_origin))
                                                                  ;
        (*(unsigned long *)(cim_cmd_ptr + (0x00000034))) = (0);
    }
    if (gp3_blt_flags & 0x0010) {
        (*(unsigned long *)(cim_cmd_ptr + (0x00000004))) = (gp3_raster_mode | 0x00002000 /* Invert monochrome src    */)
                                                               ;
    }
    else {
        (*(unsigned long *)(cim_cmd_ptr + (0x00000004))) = (gp3_raster_mode & ~0x00002000 /* Invert monochrome src    */)
                                                                ;
    }

    (*(unsigned long *)(cim_cmd_ptr + (0x0000000C))) = (0);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000014))) = (size);
    (*(unsigned long *)(cim_cmd_ptr + (0x0000003C))) = (((gp3_fb_base << 24) + (dstoffset & 0xFFC00000)))
                                                                     ;
    (*(unsigned long *)(cim_cmd_ptr + (0x00000040))) = (gp3_blt_mode | 0x00000002 /* src = host register      */ | 0x00000080 /* Byte-packed monochrome   */)
                                                                        ;

    /* START THE BLT */

    (*(unsigned long *)(cim_cmd_ptr + (0x00000000))) = (gp3_cmd_header);
    (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
    gp3_cmd_current = gp3_cmd_next;

    /* CALCULATE THE TOTAL NUMBER OF BYTES */

    size = ((width + 7) >> 3) * height;

    /* WRITE ALL DATA IN CHUNKS */

    do {
        /* UPDATE THE COMMAND POINTER */

        cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

        if (size > 8192) {
            dword_count = 2048;
            byte_count = 0;
            dwords_total = 2048;
            size -= 8192;
        }
        else {
            dword_count = (size >> 2);
            byte_count = (size & 3);
            dwords_total = (size + 3) >> 2;
            size = 0;
        }
        gp3_cmd_next = gp3_cmd_current + (dwords_total << 2) + 8;

        /* CHECK IF A WRAP WILL BE NEEDED */

        if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 2185 "../src/cim/cim_gp.c"
                                                                   ) {
            gp3_cmd_next = gp3_cmd_top;

            /* WAIT FOR HARDWARE */

            while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x80000000 | 0x00000001)

                                                     ;
        }
        else {
            /* WAIT FOR AVAILABLE SPACE */

            while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x00000001)
                                                                              ;
        }

        /* WRITE DWORD COUNT */

        (*(unsigned long *)(cim_cmd_ptr + (4))) = (0x00000000 | dwords_total);

        /* WRITE DATA */

        { int d0, d1, d2; __asm__ __volatile__( " rep\n" " movsl\n" : "=&c" (d0), "=&S" (d1), "=&D" (d2) : "0" (dword_count), "1" ((const char *)((unsigned long)(data)+(srcoffset))), "2" ((char *)cim_cmd_ptr+ ((unsigned long)(8))) : "memory"); };
        { unsigned long i; unsigned long array = (unsigned long)data + (srcoffset + (dword_count << 2)); for (i = 0; i < byte_count; i++) (*(unsigned char *)(cim_cmd_ptr + ((8 + (dword_count << 2)) + i))) = (*((unsigned char *)(array + i))); }
                                                                         ;

        (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
        gp3_cmd_current = gp3_cmd_next;

        /* UPDATE THE SOURCE OFFSET */
        /* We add a constant value because the code will loop only if the */
        /* data exceeds 8192 bytes.                                       */

        srcoffset += 8192;

    } while (size);
}

# 2436 "../src/cim/cim_gp.c"
void
gp_antialiased_text(unsigned long dstoffset, unsigned long srcx,
                    unsigned long width, unsigned long height,
                    unsigned char *data, long stride, int fourbpp)
{
    unsigned long indent, temp;
    unsigned long total_dwords, size_dwords;
    unsigned long dword_count, byte_count;
    unsigned long size = ((width << 16) | height);
    unsigned long ch3_offset, srcoffset;
    unsigned long base, depth_flag;

    base = ((gp3_fb_base << 24) + (dstoffset & 0xFFC00000)) |
        (gp3_base_register & ~0xFFC00000);

    /* ENABLE ALL RELEVANT REGISTERS */
    /* We override the raster mode register to force the */
    /* correct alpha blend                               */

    gp3_cmd_header |= 0x00000001 |
        0x00000002 |
        0x00000010 |
        0x00000800 |
        0x00001000 |
        0x00002000 |
        0x00004000 | 0x00008000;

    /* CALCULATIONS BASED ON ALPHA DEPTH */
    /* Although most antialiased text is 4BPP, the hardware supports */
    /* a full 8BPP.  Either case is supported by this routine.       */

    if (fourbpp) {
        depth_flag = 0x0E000000;
        indent = (srcx >> 1);
        srcoffset = (indent & ~3L);
        indent &= 3;
        ch3_offset = indent | ((srcx & 1) << 25);

        temp = ((width + (srcx & 1) + 1) >> 1) + indent;
    }
    else {
        depth_flag = 0x02000000;
        indent = srcx;
        srcoffset = (indent & ~3L);
        indent &= 3;
        ch3_offset = indent;

        temp = width + indent;
    }

    total_dwords = (temp + 3) >> 2;
    size_dwords = (total_dwords << 2) + 8;
    dword_count = (temp >> 2);
    byte_count = (temp & 3);

    /* SET RASTER MODE REGISTER */
    /* Alpha blending will only apply to RGB when no alpha component is present. */
    /* As 8BPP is not supported for this routine, the only alpha-less mode is    */
    /* 5:6:5.                                                                    */

    if (gp3_bpp == 0x60000000 /* 16 BPP, 5:6:5            */) {
        (*(unsigned long *)(cim_cmd_ptr + (0x00000004))) = (gp3_bpp | 0x00400000 /* Alpha applies to RGB     */ | 0x00300000 /* alpha * A + (1 - alpha)B */ | 0x000C0000 /* Alpha from channel 3     */)



                                                   ;
    }
    else {
        (*(unsigned long *)(cim_cmd_ptr + (0x00000004))) = (gp3_bpp | 0x00C00000 /* Alpha enable             */ | 0x00300000 /* alpha * A + (1 - alpha)B */ | 0x000C0000 /* Alpha from channel 3     */)



                                                   ;
    }

    /* WRITE ALL REMAINING REGISTERS */

    (*(unsigned long *)(cim_cmd_ptr + (0x00000008))) = ((dstoffset & 0x3FFFFF));
    (*(unsigned long *)(cim_cmd_ptr + (0x00000030))) = (ch3_offset);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000014))) = (size);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000038))) = (size);
    (*(unsigned long *)(cim_cmd_ptr + (0x0000003C))) = (base);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000034))) = (0x80000000 | 0x00040000 | depth_flag | ((gp3_blt_flags & 0x0001) << 20))


                                      ;
    (*(unsigned long *)(cim_cmd_ptr + (0x00000040))) = (gp3_blt_mode | 0x00000004 /* dst data required        */);

    /* START THE BLT */

    (*(unsigned long *)(cim_cmd_ptr + (0x00000000))) = (gp3_cmd_header);
    (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
    gp3_cmd_current = gp3_cmd_next;

    /* WRITE DATA LINE BY LINE
     * Each line will be created as a separate command buffer entry to allow
     * line-by-line wrapping and to allow simultaneous rendering by the HW.
     */

    if (((total_dwords << 2) * height) <= 0xC7F8 /* (50K - 8) is largest
                                                         * 1-Pass load size */
# 2535 "../src/cim/cim_gp.c"
                                                             &&
        (gp3_cmd_bottom - gp3_cmd_current) > (0xC7F8 /* (50K - 8) is largest
                                                         * 1-Pass load size */
# 2536 "../src/cim/cim_gp.c"
                                                                 + 72)) {
        /* UPDATE THE COMMAND POINTER */

        cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

        /* CHECK IF A WRAP WILL BE NEEDED */

        gp3_cmd_next = gp3_cmd_current + ((total_dwords << 2) * height) + 8;

        if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 2545 "../src/cim/cim_gp.c"
                                                                   ) {
            gp3_cmd_next = gp3_cmd_top;

            while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x80000000 | 0x00000001)

                                                     ;
        }
        else {
            while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x00000001)
                                                                              ;
        }

        /* WRITE DWORD COUNT */

        (*(unsigned long *)(cim_cmd_ptr + (4))) = (0x20000000 | (total_dwords * height));

        while (height--) {
            /* WRITE DATA */

            { int d0, d1, d2; __asm__ __volatile__( " rep\n" " movsl\n" : "=&c" (d0), "=&S" (d1), "=&D" (d2) : "0" (dword_count), "1" ((const char *)((unsigned long)(data)+(srcoffset))), "2" ((char *)cim_cmd_ptr+ ((unsigned long)(8))) : "memory"); };
            { unsigned long i; unsigned long array = (unsigned long)data + (srcoffset + (dword_count << 2)); for (i = 0; i < byte_count; i++) (*(unsigned char *)(cim_cmd_ptr + ((8 + (dword_count << 2)) + i))) = (*((unsigned char *)(array + i))); }
                                                                             ;

            srcoffset += stride;
            cim_cmd_ptr += total_dwords << 2;
        }

        (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
        gp3_cmd_current = gp3_cmd_next;
    }
    else {
        while (height--) {
            /* UPDATE THE COMMAND POINTER
             * The WRITE_COMMANDXX macros use a pointer to the current buffer
             * space.  This is created by adding gp3_cmd_current to the base
             * pointer.
             */

            cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

            /* CHECK IF A WRAP WILL BE NEEDED */

            gp3_cmd_next = gp3_cmd_current + size_dwords;
            if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 2590 "../src/cim/cim_gp.c"
                                                                       ) {
                gp3_cmd_next = gp3_cmd_top;

                /* WAIT FOR HARDWARE */

                while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
                (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x80000000 | 0x00000001)

                                                           ;
            }
            else {
                /* WAIT FOR AVAILABLE SPACE */

                while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
                (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x00000001)

                                                         ;
            }

            /* WRITE DWORD COUNT */

            (*(unsigned long *)(cim_cmd_ptr + (4))) = (0x20000000 | total_dwords);

            /* WRITE DATA */

            { int d0, d1, d2; __asm__ __volatile__( " rep\n" " movsl\n" : "=&c" (d0), "=&S" (d1), "=&D" (d2) : "0" (dword_count), "1" ((const char *)((unsigned long)(data)+(srcoffset))), "2" ((char *)cim_cmd_ptr+ ((unsigned long)(8))) : "memory"); };
            { unsigned long i; unsigned long array = (unsigned long)data + (srcoffset + (dword_count << 2)); for (i = 0; i < byte_count; i++) (*(unsigned char *)(cim_cmd_ptr + ((8 + (dword_count << 2)) + i))) = (*((unsigned char *)(array + i))); }
                                                                             ;

            /* UPDATE POINTERS */

            srcoffset += stride;
            (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
            gp3_cmd_current = gp3_cmd_next;
        }
    }
}

# 2635 "../src/cim/cim_gp.c"
void
gp_masked_blt(unsigned long dstoffset, unsigned long width,
              unsigned long height, unsigned long mono_srcx,
              unsigned long color_srcx, unsigned char *mono_mask,
              unsigned char *color_data, long mono_pitch, long color_pitch)
{
    unsigned long indent, temp;
    unsigned long total_dwords, size_dwords;
    unsigned long dword_count, byte_count;
    unsigned long srcoffset, size;
    unsigned long i, ch3_offset, base;
    unsigned long flags = 0;

    if (gp3_blt_flags & 0x0010)
        flags = 0x00002000 /* Invert monochrome src    */;

    /* MONO CALCULATIONS */

    indent = (mono_srcx >> 3);
    srcoffset = (indent & ~3L);
    indent &= 3;

    size = ((width + (mono_srcx & 7) + 7) >> 3) + indent;
    total_dwords = (size + 3) >> 2;
    size_dwords = (total_dwords << 2) + 8;
    dword_count = (size >> 2);
    byte_count = (size & 3);

    base = ((gp3_fb_base << 24) + (gp3_scratch_base & 0xFFC00000)) |
        (gp3_base_register & ~0xFFC00000);

    gp3_cmd_header |= 0x00000001 |
        0x00000008 | 0x00000002 |
        0x00000010 | 0x00001000 |
        0x00000800 | 0x00002000 |
        0x00004000 | 0x00008000;

    (*(unsigned long *)(cim_cmd_ptr + (0x00000004))) = (0x80000000 /* 32 BPP, 8:8:8:8          */ | 0xCC);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000010))) = ((total_dwords << 2));
    (*(unsigned long *)(cim_cmd_ptr + (0x00000008))) = (gp3_scratch_base & 0x3FFFFF);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000014))) = ((total_dwords << 16) | height);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000038))) = ((total_dwords << 16) | height);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000030))) = (0);
    (*(unsigned long *)(cim_cmd_ptr + (0x0000003C))) = (base);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000034))) = (0x80000000 | 0x40000000 | 0x00040000 | 0x08000000 | ((gp3_blt_flags & 0x0001) << 20))


                                                                      ;
    (*(unsigned long *)(cim_cmd_ptr + (0x00000040))) = (0);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000000))) = (gp3_cmd_header);

    /* START THE BLT */

    (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
    gp3_cmd_current = gp3_cmd_next;

    for (i = 0; i < height; i++) {
        /* UPDATE THE COMMAND POINTER
         * The WRITE_COMMANDXX macros use a pointer to the current buffer
         * space.  This is created by adding gp3_cmd_current to the base
         * pointer.
         */

        cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

        /* CHECK IF A WRAP WILL BE NEEDED */

        gp3_cmd_next = gp3_cmd_current + size_dwords;
        if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 2703 "../src/cim/cim_gp.c"
                                                                   ) {
            gp3_cmd_next = gp3_cmd_top;

            /* WAIT FOR HARDWARE */

            while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x80000000 | 0x00000001)

                                                     ;
        }
        else {
            /* WAIT FOR AVAILABLE SPACE */

            while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x00000001)
                                                     ;
        }

        /* WRITE DWORD COUNT */

        (*(unsigned long *)(cim_cmd_ptr + (4))) = (0x20000000 | total_dwords);

        /* WRITE DATA */

        { int d0, d1, d2; __asm__ __volatile__( " rep\n" " movsl\n" : "=&c" (d0), "=&S" (d1), "=&D" (d2) : "0" (dword_count), "1" ((const char *)((unsigned long)(mono_mask)+(srcoffset))), "2" ((char *)cim_cmd_ptr+ ((unsigned long)(8))) : "memory"); };
        { unsigned long i; unsigned long array = (unsigned long)mono_mask + (srcoffset + (dword_count << 2)); for (i = 0; i < byte_count; i++) (*(unsigned char *)(cim_cmd_ptr + ((8 + (dword_count << 2)) + i))) = (*((unsigned char *)(array + i))); }
                                                                         ;

        /* UPDATE POINTERS */

        srcoffset += mono_pitch;
        (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
        gp3_cmd_current = gp3_cmd_next;
    }

    /* SECOND BLT */

    gp_declare_blt(gp3_blt_flags | 0x0008);

    base = ((gp3_fb_base << 24) + (dstoffset & 0xFFC00000)) |
        ((gp3_fb_base << 14) + (((gp3_scratch_base +
                                  indent) & 0xFFC00000) >> 10)) |
        (gp3_base_register & 0x00000FFC);

    gp3_cmd_header |= 0x00000001 |
        0x00000008 | 0x00000002 |
        0x00000004 | 0x00000010 |
        0x00001000 |
        0x00002000 |
        0x00004000 |
        0x00000800 | 0x00008000;

    /* ENABLE TRANSPARENCY AND PATTERN COPY ROP
     * The monochrome data is used as a mask but is otherwise not involved in
     * the BLT.  The color data is routed through the pattern channel.
     */

    (*(unsigned long *)(cim_cmd_ptr + (0x00000004))) = (gp3_bpp | 0xF0 | 0x00000800 /* source transparency      */ | flags)
                                                              ;
    (*(unsigned long *)(cim_cmd_ptr + (0x00000010))) = ((total_dwords << 18) | gp3_dst_stride);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000008))) = (dstoffset & 0x3FFFFF);
    (*(unsigned long *)(cim_cmd_ptr + (0x0000000C))) = (((gp3_scratch_base + indent) & 0x3FFFFF) | ((mono_srcx & 7) << 26))

                                                                    ;
    (*(unsigned long *)(cim_cmd_ptr + (0x00000014))) = ((width << 16) | height);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000038))) = ((width << 16) | height);
    (*(unsigned long *)(cim_cmd_ptr + (0x0000003C))) = (base);

    /* PROGRAM PARAMETERS FOR COLOR SOURCE DATA        */
    /* Data may be color converted along the way.      */

    if ((gp3_src_format & 0x0F000000) == 0x0B000000) {
        srcoffset = color_srcx * 3;
        ch3_offset = 0;
        size = width * 3;

        (*(unsigned long *)(cim_cmd_ptr + (0x00000038))) = ((((size + 3) >> 2) << 16) | height);
    }
    else if (gp3_src_pix_shift == 3) {
        /* CALCULATE INDENT AND SOURCE OFFSET */

        indent = (color_srcx >> 1);
        srcoffset = (indent & ~3L);
        indent &= 3;
        ch3_offset = indent | ((color_srcx & 1) << 25);

        size = ((width + (color_srcx & 1) + 1) >> 1) + indent;
    }
    else {
        indent = (color_srcx << gp3_src_pix_shift);
        srcoffset = (indent & ~3L);
        indent &= 3;
        ch3_offset = indent;

        size = (width << gp3_src_pix_shift) + indent;
    }

    total_dwords = (size + 3) >> 2;
    size_dwords = (total_dwords << 2) + 8;
    dword_count = (size >> 2);
    byte_count = (size & 3);

    (*(unsigned long *)(cim_cmd_ptr + (0x00000030))) = (ch3_offset);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000034))) = (0x80000000 | 0x00040000 | gp3_src_format | ((gp3_blt_flags & 0x0001) << 20))


                                             ;
    (*(unsigned long *)(cim_cmd_ptr + (0x00000040))) = (gp3_blt_mode | 0x00000040 /* monochrome source data   */ | 0x00000001 /* src = frame buffer       */)
                                                                   ;

    /* START THE BLT */

    (*(unsigned long *)(cim_cmd_ptr + (0x00000000))) = (gp3_cmd_header);
    (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
    gp3_cmd_current = gp3_cmd_next;

    /* WRITE DATA LINE BY LINE */

    while (height--) {
        /* UPDATE THE COMMAND POINTER */

        cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

        /* CHECK IF A WRAP WILL BE NEEDED */

        gp3_cmd_next = gp3_cmd_current + size_dwords;
        if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 2829 "../src/cim/cim_gp.c"
                                                                   ) {
            gp3_cmd_next = gp3_cmd_top;

            while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x80000000 | 0x00000001)

                                                     ;
        }
        else {
            while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x00000001)
                                                                              ;
        }

        /* WRITE DWORD COUNT */

        (*(unsigned long *)(cim_cmd_ptr + (4))) = (0x20000000 | total_dwords);

        /* WRITE COLOR DATA TO THE COMMAND BUFFER */

        { int d0, d1, d2; __asm__ __volatile__( " rep\n" " movsl\n" : "=&c" (d0), "=&S" (d1), "=&D" (d2) : "0" (dword_count), "1" ((const char *)((unsigned long)(color_data)+(srcoffset))), "2" ((char *)cim_cmd_ptr+ ((unsigned long)(8))) : "memory"); };
        { unsigned long i; unsigned long array = (unsigned long)color_data + (srcoffset + (dword_count << 2)); for (i = 0; i < byte_count; i++) (*(unsigned char *)(cim_cmd_ptr + ((8 + (dword_count << 2)) + i))) = (*((unsigned char *)(array + i))); }
                                                                         ;

        /* UPDATE COMMAND BUFFER POINTERS */
        /* We do this before writing the monochrome data because otherwise */
        /* the GP could throttle the writes to the host source register    */
        /* waiting for color data.  If the command buffer has not been     */
        /* updated to load the color data...                               */

        srcoffset += color_pitch;
        (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
        gp3_cmd_current = gp3_cmd_next;
    }
}

# 2873 "../src/cim/cim_gp.c"
void
gp_screen_to_screen_masked(unsigned long dstoffset, unsigned long srcoffset,
                           unsigned long width, unsigned long height,
                           unsigned long mono_srcx, unsigned char *mono_mask,
                           long mono_pitch)
{
    unsigned long indent, temp;
    unsigned long total_dwords, size_dwords;
    unsigned long dword_count, byte_count;
    unsigned long srcoff, size;
    unsigned long i, base;
    unsigned long flags = 0;

    if (gp3_blt_flags & 0x0010)
        flags = 0x00002000 /* Invert monochrome src    */;

    /* MONO CALCULATIONS */

    indent = (mono_srcx >> 3);
    srcoff = (indent & ~3L);
    indent &= 3;

    size = ((width + (mono_srcx & 7) + 7) >> 3) + indent;
    total_dwords = (size + 3) >> 2;
    size_dwords = (total_dwords << 2) + 8;
    dword_count = (size >> 2);
    byte_count = (size & 3);

    base = ((gp3_fb_base << 24) + (gp3_scratch_base & 0xFFC00000)) |
        (gp3_base_register & ~0xFFC00000);

    gp3_cmd_header |= 0x00000001 | 0x00000008 |
        0x00000002 | 0x00000010 |
        0x00001000 | 0x00000800 |
        0x00002000 |
        0x00004000 | 0x00008000;

    (*(unsigned long *)(cim_cmd_ptr + (0x00000004))) = (0x80000000 /* 32 BPP, 8:8:8:8          */ | 0xCC);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000010))) = ((total_dwords << 2));
    (*(unsigned long *)(cim_cmd_ptr + (0x00000008))) = (gp3_scratch_base & 0x3FFFFF);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000014))) = ((total_dwords << 16) | height);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000038))) = ((total_dwords << 16) | height);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000030))) = (0);
    (*(unsigned long *)(cim_cmd_ptr + (0x0000003C))) = (base);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000034))) = (0x80000000 | 0x40000000 | 0x00040000 | 0x08000000 | ((gp3_blt_flags & 0x0001) << 20))


                                                                      ;
    (*(unsigned long *)(cim_cmd_ptr + (0x00000040))) = (0);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000000))) = (gp3_cmd_header);

    /* START THE BLT */

    (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
    gp3_cmd_current = gp3_cmd_next;

    for (i = 0; i < height; i++) {
        /* UPDATE THE COMMAND POINTER
         * The WRITE_COMMANDXX macros use a pointer to the current buffer
         * space. This is created by adding gp3_cmd_current to the base
         * pointer.
         */

        cim_cmd_ptr = cim_cmd_base_ptr + gp3_cmd_current;

        /* CHECK IF A WRAP WILL BE NEEDED */

        gp3_cmd_next = gp3_cmd_current + size_dwords;
        if ((gp3_cmd_bottom - gp3_cmd_next) <= 9000 /* 8K +
                                                         * WORKAROUND SPACE */
# 2941 "../src/cim/cim_gp.c"
                                                                   ) {
            gp3_cmd_next = gp3_cmd_top;

            /* WAIT FOR HARDWARE */

            while(((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) || (temp <= (gp3_cmd_top + 68 /* 18 DWORDS */ + 68 /* 18 DWORDS */ + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x80000000 | 0x00000001)
                                                                              ;
        }
        else {
            /* WAIT FOR AVAILABLE SPACE */

            while (((temp = (*(volatile unsigned long *)(cim_gp_ptr + (0x00000058)))) > gp3_cmd_current) && (temp <= (gp3_cmd_next + 96)));
            (*(unsigned long *)(cim_cmd_ptr + (0))) = (0x60000000 | 0x00000001)
                                                     ;
        }

        /* WRITE DWORD COUNT */

        (*(unsigned long *)(cim_cmd_ptr + (4))) = (0x20000000 | total_dwords);

        /* WRITE DATA */

        { int d0, d1, d2; __asm__ __volatile__( " rep\n" " movsl\n" : "=&c" (d0), "=&S" (d1), "=&D" (d2) : "0" (dword_count), "1" ((const char *)((unsigned long)(mono_mask)+(srcoff))), "2" ((char *)cim_cmd_ptr+ ((unsigned long)(8))) : "memory"); };
        { unsigned long i; unsigned long array = (unsigned long)mono_mask + (srcoff + (dword_count << 2)); for (i = 0; i < byte_count; i++) (*(unsigned char *)(cim_cmd_ptr + ((8 + (dword_count << 2)) + i))) = (*((unsigned char *)(array + i))); }
                                                                      ;

        /* UPDATE POINTERS */

        srcoff += mono_pitch;
        (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
        gp3_cmd_current = gp3_cmd_next;
    }

    /* SECOND BLT */

    gp_declare_blt(gp3_blt_flags | 0x0008);

    base = ((gp3_fb_base << 24) + (dstoffset & 0xFFC00000)) |
        ((gp3_fb_base << 14) + (((gp3_scratch_base +
                                  indent) & 0xFFC00000) >> 10)) | ((gp3_fb_base
                                                                    << 4) +
                                                                   ((srcoffset &
                                                                     0xFFC00000)
                                                                    >> 20));

    gp3_cmd_header |= 0x00000001 |
        0x00000008 | 0x00000002 |
        0x00000004 | 0x00000010 |
        0x00001000 |
        0x00002000 |
        0x00004000 |
        0x00000800 | 0x00008000;

    /* ENABLE TRANSPARENCY AND PATTERN COPY ROP
     * The monochrome data is used as a mask but is otherwise not involved
     * in the BLT.  The color data is routed through the pattern channel.
     */

    (*(unsigned long *)(cim_cmd_ptr + (0x00000004))) = (gp3_bpp | 0xF0 | 0x00000800 /* source transparency      */ | flags)
                                                              ;
    (*(unsigned long *)(cim_cmd_ptr + (0x00000010))) = ((total_dwords << 18) | gp3_dst_stride);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000008))) = (dstoffset & 0x3FFFFF);
    (*(unsigned long *)(cim_cmd_ptr + (0x0000000C))) = (((gp3_scratch_base + indent) & 0x3FFFFF) | ((mono_srcx & 7) << 26))

                                                                    ;
    (*(unsigned long *)(cim_cmd_ptr + (0x00000014))) = ((width << 16) | height);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000038))) = ((width << 16) | height);
    (*(unsigned long *)(cim_cmd_ptr + (0x0000003C))) = (base);

    /* PROGRAM PARAMETERS FOR COLOR SOURCE DATA  */

    (*(unsigned long *)(cim_cmd_ptr + (0x00000030))) = (srcoffset & 0x3FFFFF);
    (*(unsigned long *)(cim_cmd_ptr + (0x00000034))) = (0x80000000 | gp3_ch3_bpp | gp3_src_stride | ((gp3_blt_flags & 0x0001) << 20))

                                             ;
    (*(unsigned long *)(cim_cmd_ptr + (0x00000040))) = (gp3_blt_mode | 0x00000040 /* monochrome source data   */ | 0x00000001 /* src = frame buffer       */)
                                                                   ;

    /* START THE BLT */

    (*(unsigned long *)(cim_cmd_ptr + (0x00000000))) = (gp3_cmd_header);
    (*(volatile unsigned long *)(cim_gp_ptr + (0x0000005C))) = (gp3_cmd_next);
    gp3_cmd_current = gp3_cmd_next;
}

