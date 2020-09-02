# 26 "mad_fixed.h"
typedef signed int mad_fixed_t;

# 28 "mad_fixed.h"
typedef signed int mad_fixed64hi_t;

# 29 "mad_fixed.h"
typedef unsigned int mad_fixed64lo_t;

# 25 "mad_timer.h"
typedef struct {
  signed long seconds; /* whole seconds */
  unsigned long fraction; /* 1/MAD_TIMER_RESOLUTION seconds */
} mad_timer_t;

# 29 "mad_frame.h"
enum mad_layer {
  MAD_LAYER_I = 1, /* Layer I */
  MAD_LAYER_II = 2, /* Layer II */
  MAD_LAYER_III = 3 /* Layer III */
};

# 35 "mad_frame.h"
enum mad_mode {
  MAD_MODE_SINGLE_CHANNEL = 0, /* single channel */
  MAD_MODE_DUAL_CHANNEL = 1, /* dual channel */
  MAD_MODE_JOINT_STEREO = 2, /* joint (MS/intensity) stereo */
  MAD_MODE_STEREO = 3 /* normal LR stereo */
};

# 42 "mad_frame.h"
enum mad_emphasis {
  MAD_EMPHASIS_NONE = 0, /* no emphasis */
  MAD_EMPHASIS_50_15_US = 1, /* 50/15 microseconds emphasis */
  MAD_EMPHASIS_CCITT_J_17 = 3, /* CCITT J.17 emphasis */
  MAD_EMPHASIS_RESERVED = 2 /* unknown emphasis */
};

# 49 "mad_frame.h"
struct mad_header {
  enum mad_layer layer; /* audio layer (1, 2, or 3) */
  enum mad_mode mode; /* channel mode (see above) */
  int mode_extension; /* additional mode info */
  enum mad_emphasis emphasis; /* de-emphasis to use (see above) */

  unsigned long bitrate; /* stream bitrate (bps) */
  unsigned int samplerate; /* sampling frequency (Hz) */

  unsigned short crc_check; /* frame CRC accumulator */
  unsigned short crc_target; /* final target CRC checksum */

  int flags; /* flags (see below) */
  int private_bits; /* private bits (see below) */

  mad_timer_t duration; /* audio playing time of frame */

  /* Erez Volk 2007-05-30: */
  unsigned long offset; /* Offset of frame in stream */
};

# 70 "mad_frame.h"
struct mad_frame {
  struct mad_header header; /* MPEG audio header */

  int options; /* decoding options (from stream) */

  mad_fixed_t sbsample[2][36][32]; /* synthesis subband filter samples */
  mad_fixed_t (*overlap)[2][32][18]; /* Layer III block overlap data */
};

# 28 "mad_synth.h"
struct mad_pcm {
  unsigned int samplerate; /* sampling frequency (Hz) */
  unsigned short channels; /* number of channels */
  unsigned short length; /* number of samples per channel */
  mad_fixed_t samples[2][1152]; /* PCM output samples [ch][sample] */
};

# 35 "mad_synth.h"
struct mad_synth {
  mad_fixed_t filter[2][2][2][16][8]; /* polyphase filterbank outputs */
       /* [ch][eo][peo][s][v] */

  unsigned int phase; /* current processing phase */

  struct mad_pcm pcm; /* PCM output */
};

# 122 "mad_synth.c"
static
void dct32(mad_fixed_t const in[32], unsigned int slot,
    mad_fixed_t lo[16][8], mad_fixed_t hi[16][8])
{
  mad_fixed_t t0, t1, t2, t3, t4, t5, t6, t7;
  mad_fixed_t t8, t9, t10, t11, t12, t13, t14, t15;
  mad_fixed_t t16, t17, t18, t19, t20, t21, t22, t23;
  mad_fixed_t t24, t25, t26, t27, t28, t29, t30, t31;
  mad_fixed_t t32, t33, t34, t35, t36, t37, t38, t39;
  mad_fixed_t t40, t41, t42, t43, t44, t45, t46, t47;
  mad_fixed_t t48, t49, t50, t51, t52, t53, t54, t55;
  mad_fixed_t t56, t57, t58, t59, t60, t61, t62, t63;
  mad_fixed_t t64, t65, t66, t67, t68, t69, t70, t71;
  mad_fixed_t t72, t73, t74, t75, t76, t77, t78, t79;
  mad_fixed_t t80, t81, t82, t83, t84, t85, t86, t87;
  mad_fixed_t t88, t89, t90, t91, t92, t93, t94, t95;
  mad_fixed_t t96, t97, t98, t99, t100, t101, t102, t103;
  mad_fixed_t t104, t105, t106, t107, t108, t109, t110, t111;
  mad_fixed_t t112, t113, t114, t115, t116, t117, t118, t119;
  mad_fixed_t t120, t121, t122, t123, t124, t125, t126, t127;
  mad_fixed_t t128, t129, t130, t131, t132, t133, t134, t135;
  mad_fixed_t t136, t137, t138, t139, t140, t141, t142, t143;
  mad_fixed_t t144, t145, t146, t147, t148, t149, t150, t151;
  mad_fixed_t t152, t153, t154, t155, t156, t157, t158, t159;
  mad_fixed_t t160, t161, t162, t163, t164, t165, t166, t167;
  mad_fixed_t t168, t169, t170, t171, t172, t173, t174, t175;
  mad_fixed_t t176;

  /* costab[i] = cos(PI / (2 * 32) * i) */
# 218 "mad_synth.c"
  t0 = in[0] + in[31]; t16 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((in[0] - in[31]))), "rm" (((((mad_fixed_t) (0x0ffb10f2L)) /* 0.998795456 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t1 = in[15] + in[16]; t17 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((in[15] - in[16]))), "rm" (((((mad_fixed_t) (0x00c8fb30L)) /* 0.049067674 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t41 = t16 + t17;
  t59 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t16 - t17))), "rm" (((((mad_fixed_t) (0x0fec46d2L)) /* 0.995184727 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t33 = t0 + t1;
  t50 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t0 - t1))), "rm" (((((mad_fixed_t) (0x0fec46d2L)) /* 0.995184727 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t2 = in[7] + in[24]; t18 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((in[7] - in[24]))), "rm" (((((mad_fixed_t) (0x0bdaef91L)) /* 0.740951125 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t3 = in[8] + in[23]; t19 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((in[8] - in[23]))), "rm" (((((mad_fixed_t) (0x0abeb49aL)) /* 0.671558955 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t42 = t18 + t19;
  t60 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t18 - t19))), "rm" (((((mad_fixed_t) (0x01917a6cL)) /* 0.098017140 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t34 = t2 + t3;
  t51 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t2 - t3))), "rm" (((((mad_fixed_t) (0x01917a6cL)) /* 0.098017140 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t4 = in[3] + in[28]; t20 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((in[3] - in[28]))), "rm" (((((mad_fixed_t) (0x0f109082L)) /* 0.941544065 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t5 = in[12] + in[19]; t21 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((in[12] - in[19]))), "rm" (((((mad_fixed_t) (0x0563e69dL)) /* 0.336889853 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t43 = t20 + t21;
  t61 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t20 - t21))), "rm" (((((mad_fixed_t) (0x0c5e4036L)) /* 0.773010453 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t35 = t4 + t5;
  t52 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t4 - t5))), "rm" (((((mad_fixed_t) (0x0c5e4036L)) /* 0.773010453 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t6 = in[4] + in[27]; t22 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((in[4] - in[27]))), "rm" (((((mad_fixed_t) (0x0e76bd7aL)) /* 0.903989293 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t7 = in[11] + in[20]; t23 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((in[11] - in[20]))), "rm" (((((mad_fixed_t) (0x06d74402L)) /* 0.427555093 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t44 = t22 + t23;
  t62 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t22 - t23))), "rm" (((((mad_fixed_t) (0x0a267993L)) /* 0.634393284 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t36 = t6 + t7;
  t53 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t6 - t7))), "rm" (((((mad_fixed_t) (0x0a267993L)) /* 0.634393284 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t8 = in[1] + in[30]; t24 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((in[1] - in[30]))), "rm" (((((mad_fixed_t) (0x0fd3aac0L)) /* 0.989176510 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t9 = in[14] + in[17]; t25 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((in[14] - in[17]))), "rm" (((((mad_fixed_t) (0x0259020eL)) /* 0.146730474 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t45 = t24 + t25;
  t63 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t24 - t25))), "rm" (((((mad_fixed_t) (0x0f4fa0abL)) /* 0.956940336 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t37 = t8 + t9;
  t54 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t8 - t9))), "rm" (((((mad_fixed_t) (0x0f4fa0abL)) /* 0.956940336 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t10 = in[6] + in[25]; t26 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((in[6] - in[25]))), "rm" (((((mad_fixed_t) (0x0cd9f024L)) /* 0.803207531 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t11 = in[9] + in[22]; t27 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((in[9] - in[22]))), "rm" (((((mad_fixed_t) (0x0987fbfeL)) /* 0.595699304 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t46 = t26 + t27;
  t64 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t26 - t27))), "rm" (((((mad_fixed_t) (0x04a5018cL)) /* 0.290284677 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t38 = t10 + t11;
  t55 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t10 - t11))), "rm" (((((mad_fixed_t) (0x04a5018cL)) /* 0.290284677 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t12 = in[2] + in[29]; t28 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((in[2] - in[29]))), "rm" (((((mad_fixed_t) (0x0f853f7eL)) /* 0.970031253 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t13 = in[13] + in[18]; t29 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((in[13] - in[18]))), "rm" (((((mad_fixed_t) (0x03e33f2fL)) /* 0.242980180 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t47 = t28 + t29;
  t65 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t28 - t29))), "rm" (((((mad_fixed_t) (0x0e1c5979L)) /* 0.881921264 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t39 = t12 + t13;
  t56 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t12 - t13))), "rm" (((((mad_fixed_t) (0x0e1c5979L)) /* 0.881921264 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t14 = in[5] + in[26]; t30 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((in[5] - in[26]))), "rm" (((((mad_fixed_t) (0x0db941a3L)) /* 0.857728610 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t15 = in[10] + in[21]; t31 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((in[10] - in[21]))), "rm" (((((mad_fixed_t) (0x0839c3cdL)) /* 0.514102744 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t48 = t30 + t31;
  t66 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t30 - t31))), "rm" (((((mad_fixed_t) (0x078ad74eL)) /* 0.471396737 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t40 = t14 + t15;
  t57 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t14 - t15))), "rm" (((((mad_fixed_t) (0x078ad74eL)) /* 0.471396737 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t69 = t33 + t34; t89 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t33 - t34))), "rm" (((((mad_fixed_t) (0x0fb14be8L)) /* 0.980785280 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t70 = t35 + t36; t90 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t35 - t36))), "rm" (((((mad_fixed_t) (0x031f1708L)) /* 0.195090322 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t71 = t37 + t38; t91 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t37 - t38))), "rm" (((((mad_fixed_t) (0x0d4db315L)) /* 0.831469612 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t72 = t39 + t40; t92 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t39 - t40))), "rm" (((((mad_fixed_t) (0x08e39d9dL)) /* 0.555570233 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t73 = t41 + t42; t94 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t41 - t42))), "rm" (((((mad_fixed_t) (0x0fb14be8L)) /* 0.980785280 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t74 = t43 + t44; t95 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t43 - t44))), "rm" (((((mad_fixed_t) (0x031f1708L)) /* 0.195090322 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t75 = t45 + t46; t96 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t45 - t46))), "rm" (((((mad_fixed_t) (0x0d4db315L)) /* 0.831469612 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t76 = t47 + t48; t97 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t47 - t48))), "rm" (((((mad_fixed_t) (0x08e39d9dL)) /* 0.555570233 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t78 = t50 + t51; t100 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t50 - t51))), "rm" (((((mad_fixed_t) (0x0fb14be8L)) /* 0.980785280 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t79 = t52 + t53; t101 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t52 - t53))), "rm" (((((mad_fixed_t) (0x031f1708L)) /* 0.195090322 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t80 = t54 + t55; t102 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t54 - t55))), "rm" (((((mad_fixed_t) (0x0d4db315L)) /* 0.831469612 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t81 = t56 + t57; t103 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t56 - t57))), "rm" (((((mad_fixed_t) (0x08e39d9dL)) /* 0.555570233 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t83 = t59 + t60; t106 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t59 - t60))), "rm" (((((mad_fixed_t) (0x0fb14be8L)) /* 0.980785280 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t84 = t61 + t62; t107 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t61 - t62))), "rm" (((((mad_fixed_t) (0x031f1708L)) /* 0.195090322 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t85 = t63 + t64; t108 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t63 - t64))), "rm" (((((mad_fixed_t) (0x0d4db315L)) /* 0.831469612 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t86 = t65 + t66; t109 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t65 - t66))), "rm" (((((mad_fixed_t) (0x08e39d9dL)) /* 0.555570233 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });

  t113 = t69 + t70;
  t114 = t71 + t72;

  /*  0 */ hi[15][slot] = (t113 + t114);
  /* 16 */ lo[ 0][slot] = (({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t113 - t114))), "rm" (((((mad_fixed_t) (0x0b504f33L)) /* 0.707106781 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); }));

  t115 = t73 + t74;
  t116 = t75 + t76;

  t32 = t115 + t116;

  /*  1 */ hi[14][slot] = (t32);

  t118 = t78 + t79;
  t119 = t80 + t81;

  t58 = t118 + t119;

  /*  2 */ hi[13][slot] = (t58);

  t121 = t83 + t84;
  t122 = t85 + t86;

  t67 = t121 + t122;

  t49 = (t67 * 2) - t32;

  /*  3 */ hi[12][slot] = (t49);

  t125 = t89 + t90;
  t126 = t91 + t92;

  t93 = t125 + t126;

  /*  4 */ hi[11][slot] = (t93);

  t128 = t94 + t95;
  t129 = t96 + t97;

  t98 = t128 + t129;

  t68 = (t98 * 2) - t49;

  /*  5 */ hi[10][slot] = (t68);

  t132 = t100 + t101;
  t133 = t102 + t103;

  t104 = t132 + t133;

  t82 = (t104 * 2) - t58;

  /*  6 */ hi[ 9][slot] = (t82);

  t136 = t106 + t107;
  t137 = t108 + t109;

  t110 = t136 + t137;

  t87 = (t110 * 2) - t67;

  t77 = (t87 * 2) - t68;

  /*  7 */ hi[ 8][slot] = (t77);

  t141 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t69 - t70))), "rm" (((((mad_fixed_t) (0x0ec835e8L)) /* 0.923879533 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t142 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t71 - t72))), "rm" (((((mad_fixed_t) (0x061f78aaL)) /* 0.382683432 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t143 = t141 + t142;

  /*  8 */ hi[ 7][slot] = (t143);
  /* 24 */ lo[ 8][slot] =
      ((({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t141 - t142))), "rm" (((((mad_fixed_t) (0x0b504f33L)) /* 0.707106781 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); }) * 2) - t143);

  t144 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t73 - t74))), "rm" (((((mad_fixed_t) (0x0ec835e8L)) /* 0.923879533 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t145 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t75 - t76))), "rm" (((((mad_fixed_t) (0x061f78aaL)) /* 0.382683432 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t146 = t144 + t145;

  t88 = (t146 * 2) - t77;

  /*  9 */ hi[ 6][slot] = (t88);

  t148 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t78 - t79))), "rm" (((((mad_fixed_t) (0x0ec835e8L)) /* 0.923879533 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t149 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t80 - t81))), "rm" (((((mad_fixed_t) (0x061f78aaL)) /* 0.382683432 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t150 = t148 + t149;

  t105 = (t150 * 2) - t82;

  /* 10 */ hi[ 5][slot] = (t105);

  t152 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t83 - t84))), "rm" (((((mad_fixed_t) (0x0ec835e8L)) /* 0.923879533 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t153 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t85 - t86))), "rm" (((((mad_fixed_t) (0x061f78aaL)) /* 0.382683432 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t154 = t152 + t153;

  t111 = (t154 * 2) - t87;

  t99 = (t111 * 2) - t88;

  /* 11 */ hi[ 4][slot] = (t99);

  t157 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t89 - t90))), "rm" (((((mad_fixed_t) (0x0ec835e8L)) /* 0.923879533 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t158 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t91 - t92))), "rm" (((((mad_fixed_t) (0x061f78aaL)) /* 0.382683432 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t159 = t157 + t158;

  t127 = (t159 * 2) - t93;

  /* 12 */ hi[ 3][slot] = (t127);

  t160 = (({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t125 - t126))), "rm" (((((mad_fixed_t) (0x0b504f33L)) /* 0.707106781 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); }) * 2) - t127;

  /* 20 */ lo[ 4][slot] = (t160);
  /* 28 */ lo[12][slot] =
      ((((({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t157 - t158))), "rm" (((((mad_fixed_t) (0x0b504f33L)) /* 0.707106781 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); }) * 2) - t159) * 2) - t160);

  t161 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t94 - t95))), "rm" (((((mad_fixed_t) (0x0ec835e8L)) /* 0.923879533 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t162 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t96 - t97))), "rm" (((((mad_fixed_t) (0x061f78aaL)) /* 0.382683432 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t163 = t161 + t162;

  t130 = (t163 * 2) - t98;

  t112 = (t130 * 2) - t99;

  /* 13 */ hi[ 2][slot] = (t112);

  t164 = (({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t128 - t129))), "rm" (((((mad_fixed_t) (0x0b504f33L)) /* 0.707106781 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); }) * 2) - t130;

  t166 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t100 - t101))), "rm" (((((mad_fixed_t) (0x0ec835e8L)) /* 0.923879533 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t167 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t102 - t103))), "rm" (((((mad_fixed_t) (0x061f78aaL)) /* 0.382683432 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t168 = t166 + t167;

  t134 = (t168 * 2) - t104;

  t120 = (t134 * 2) - t105;

  /* 14 */ hi[ 1][slot] = (t120);

  t135 = (({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t118 - t119))), "rm" (((((mad_fixed_t) (0x0b504f33L)) /* 0.707106781 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); }) * 2) - t120;

  /* 18 */ lo[ 2][slot] = (t135);

  t169 = (({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t132 - t133))), "rm" (((((mad_fixed_t) (0x0b504f33L)) /* 0.707106781 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); }) * 2) - t134;

  t151 = (t169 * 2) - t135;

  /* 22 */ lo[ 6][slot] = (t151);

  t170 = (((({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t148 - t149))), "rm" (((((mad_fixed_t) (0x0b504f33L)) /* 0.707106781 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); }) * 2) - t150) * 2) - t151;

  /* 26 */ lo[10][slot] = (t170);
  /* 30 */ lo[14][slot] =
      ((((((({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t166 - t167))), "rm" (((((mad_fixed_t) (0x0b504f33L)) /* 0.707106781 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); }) * 2) - t168) * 2) - t169) * 2) - t170)
                                        ;

  t171 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t106 - t107))), "rm" (((((mad_fixed_t) (0x0ec835e8L)) /* 0.923879533 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t172 = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t108 - t109))), "rm" (((((mad_fixed_t) (0x061f78aaL)) /* 0.382683432 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); });
  t173 = t171 + t172;

  t138 = (t173 * 2) - t110;

  t123 = (t138 * 2) - t111;

  t139 = (({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t121 - t122))), "rm" (((((mad_fixed_t) (0x0b504f33L)) /* 0.707106781 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); }) * 2) - t123;

  t117 = (t123 * 2) - t112;

  /* 15 */ hi[ 0][slot] = (t117);

  t124 = (({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t115 - t116))), "rm" (((((mad_fixed_t) (0x0b504f33L)) /* 0.707106781 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); }) * 2) - t117;

  /* 17 */ lo[ 1][slot] = (t124);

  t131 = (t139 * 2) - t124;

  /* 19 */ lo[ 3][slot] = (t131);

  t140 = (t164 * 2) - t131;

  /* 21 */ lo[ 5][slot] = (t140);

  t174 = (({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t136 - t137))), "rm" (((((mad_fixed_t) (0x0b504f33L)) /* 0.707106781 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); }) * 2) - t138;

  t155 = (t174 * 2) - t139;

  t147 = (t155 * 2) - t140;

  /* 23 */ lo[ 7][slot] = (t147);

  t156 = (((({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t144 - t145))), "rm" (((((mad_fixed_t) (0x0b504f33L)) /* 0.707106781 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); }) * 2) - t146) * 2) - t147;

  /* 25 */ lo[ 9][slot] = (t156);

  t175 = (((({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t152 - t153))), "rm" (((((mad_fixed_t) (0x0b504f33L)) /* 0.707106781 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); }) * 2) - t154) * 2) - t155;

  t165 = (t175 * 2) - t156;

  /* 27 */ lo[11][slot] = (t165);

  t176 = (((((({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t161 - t162))), "rm" (((((mad_fixed_t) (0x0b504f33L)) /* 0.707106781 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); }) * 2) -
      t163) * 2) - t164) * 2) - t165;

  /* 29 */ lo[13][slot] = (t176);
  /* 31 */ lo[15][slot] =
      ((((((((({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((t171 - t172))), "rm" (((((mad_fixed_t) (0x0b504f33L)) /* 0.707106781 */))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" (28) : "cc"); __result; }); }) * 2) - t173) * 2) - t174) * 2) - t175) * 2) - t176)
                                                ;

  /*
   * Totals:
   *  80 multiplies
   *  80 additions
   * 119 subtractions
   *  49 shifts (not counting SSO)
   */
}

# 544 "mad_synth.c"
static
mad_fixed_t const D[17][32] = {
# 1 "mad_D.dat" 1
/*
 * libmad - MPEG audio decoder library
 * Copyright (C) 2000-2004 Underbit Technologies, Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * $Id: D.dat,v 1.9 2004/01/23 09:41:32 rob Exp $
 */

/*
 * These are the coefficients for the subband synthesis window. This is a
 * reordered version of Table B.3 from ISO/IEC 11172-3.
 *
 * Every value is parameterized so that shift optimizations can be made at
 * compile-time. For example, every value can be right-shifted 12 bits to
 * minimize multiply instruction times without any loss of accuracy.
 */

  { (((mad_fixed_t) (0x00000000L)) >> 12) /*  0.000000000 */, /*  0 */
    -(((mad_fixed_t) (0x0001d000L)) >> 12) /* -0.000442505 */,
     (((mad_fixed_t) (0x000d5000L)) >> 12) /*  0.003250122 */,
    -(((mad_fixed_t) (0x001cb000L)) >> 12) /* -0.007003784 */,
     (((mad_fixed_t) (0x007f5000L)) >> 12) /*  0.031082153 */,
    -(((mad_fixed_t) (0x01421000L)) >> 12) /* -0.078628540 */,
     (((mad_fixed_t) (0x019ae000L)) >> 12) /*  0.100311279 */,
    -(((mad_fixed_t) (0x09271000L)) >> 12) /* -0.572036743 */,
     (((mad_fixed_t) (0x1251e000L)) >> 12) /*  1.144989014 */,
     (((mad_fixed_t) (0x09271000L)) >> 12) /*  0.572036743 */,
     (((mad_fixed_t) (0x019ae000L)) >> 12) /*  0.100311279 */,
     (((mad_fixed_t) (0x01421000L)) >> 12) /*  0.078628540 */,
     (((mad_fixed_t) (0x007f5000L)) >> 12) /*  0.031082153 */,
     (((mad_fixed_t) (0x001cb000L)) >> 12) /*  0.007003784 */,
     (((mad_fixed_t) (0x000d5000L)) >> 12) /*  0.003250122 */,
     (((mad_fixed_t) (0x0001d000L)) >> 12) /*  0.000442505 */,

     (((mad_fixed_t) (0x00000000L)) >> 12) /*  0.000000000 */,
    -(((mad_fixed_t) (0x0001d000L)) >> 12) /* -0.000442505 */,
     (((mad_fixed_t) (0x000d5000L)) >> 12) /*  0.003250122 */,
    -(((mad_fixed_t) (0x001cb000L)) >> 12) /* -0.007003784 */,
     (((mad_fixed_t) (0x007f5000L)) >> 12) /*  0.031082153 */,
    -(((mad_fixed_t) (0x01421000L)) >> 12) /* -0.078628540 */,
     (((mad_fixed_t) (0x019ae000L)) >> 12) /*  0.100311279 */,
    -(((mad_fixed_t) (0x09271000L)) >> 12) /* -0.572036743 */,
     (((mad_fixed_t) (0x1251e000L)) >> 12) /*  1.144989014 */,
     (((mad_fixed_t) (0x09271000L)) >> 12) /*  0.572036743 */,
     (((mad_fixed_t) (0x019ae000L)) >> 12) /*  0.100311279 */,
     (((mad_fixed_t) (0x01421000L)) >> 12) /*  0.078628540 */,
     (((mad_fixed_t) (0x007f5000L)) >> 12) /*  0.031082153 */,
     (((mad_fixed_t) (0x001cb000L)) >> 12) /*  0.007003784 */,
     (((mad_fixed_t) (0x000d5000L)) >> 12) /*  0.003250122 */,
     (((mad_fixed_t) (0x0001d000L)) >> 12) /*  0.000442505 */ },

  { -(((mad_fixed_t) (0x00001000L)) >> 12) /* -0.000015259 */, /*  1 */
    -(((mad_fixed_t) (0x0001f000L)) >> 12) /* -0.000473022 */,
     (((mad_fixed_t) (0x000da000L)) >> 12) /*  0.003326416 */,
    -(((mad_fixed_t) (0x00207000L)) >> 12) /* -0.007919312 */,
     (((mad_fixed_t) (0x007d0000L)) >> 12) /*  0.030517578 */,
    -(((mad_fixed_t) (0x0158d000L)) >> 12) /* -0.084182739 */,
     (((mad_fixed_t) (0x01747000L)) >> 12) /*  0.090927124 */,
    -(((mad_fixed_t) (0x099a8000L)) >> 12) /* -0.600219727 */,
     (((mad_fixed_t) (0x124f0000L)) >> 12) /*  1.144287109 */,
     (((mad_fixed_t) (0x08b38000L)) >> 12) /*  0.543823242 */,
     (((mad_fixed_t) (0x01bde000L)) >> 12) /*  0.108856201 */,
     (((mad_fixed_t) (0x012b4000L)) >> 12) /*  0.073059082 */,
     (((mad_fixed_t) (0x0080f000L)) >> 12) /*  0.031478882 */,
     (((mad_fixed_t) (0x00191000L)) >> 12) /*  0.006118774 */,
     (((mad_fixed_t) (0x000d0000L)) >> 12) /*  0.003173828 */,
     (((mad_fixed_t) (0x0001a000L)) >> 12) /*  0.000396729 */,

    -(((mad_fixed_t) (0x00001000L)) >> 12) /* -0.000015259 */,
    -(((mad_fixed_t) (0x0001f000L)) >> 12) /* -0.000473022 */,
     (((mad_fixed_t) (0x000da000L)) >> 12) /*  0.003326416 */,
    -(((mad_fixed_t) (0x00207000L)) >> 12) /* -0.007919312 */,
     (((mad_fixed_t) (0x007d0000L)) >> 12) /*  0.030517578 */,
    -(((mad_fixed_t) (0x0158d000L)) >> 12) /* -0.084182739 */,
     (((mad_fixed_t) (0x01747000L)) >> 12) /*  0.090927124 */,
    -(((mad_fixed_t) (0x099a8000L)) >> 12) /* -0.600219727 */,
     (((mad_fixed_t) (0x124f0000L)) >> 12) /*  1.144287109 */,
     (((mad_fixed_t) (0x08b38000L)) >> 12) /*  0.543823242 */,
     (((mad_fixed_t) (0x01bde000L)) >> 12) /*  0.108856201 */,
     (((mad_fixed_t) (0x012b4000L)) >> 12) /*  0.073059082 */,
     (((mad_fixed_t) (0x0080f000L)) >> 12) /*  0.031478882 */,
     (((mad_fixed_t) (0x00191000L)) >> 12) /*  0.006118774 */,
     (((mad_fixed_t) (0x000d0000L)) >> 12) /*  0.003173828 */,
     (((mad_fixed_t) (0x0001a000L)) >> 12) /*  0.000396729 */ },

  { -(((mad_fixed_t) (0x00001000L)) >> 12) /* -0.000015259 */, /*  2 */
    -(((mad_fixed_t) (0x00023000L)) >> 12) /* -0.000534058 */,
     (((mad_fixed_t) (0x000de000L)) >> 12) /*  0.003387451 */,
    -(((mad_fixed_t) (0x00245000L)) >> 12) /* -0.008865356 */,
     (((mad_fixed_t) (0x007a0000L)) >> 12) /*  0.029785156 */,
    -(((mad_fixed_t) (0x016f7000L)) >> 12) /* -0.089706421 */,
     (((mad_fixed_t) (0x014a8000L)) >> 12) /*  0.080688477 */,
    -(((mad_fixed_t) (0x0a0d8000L)) >> 12) /* -0.628295898 */,
     (((mad_fixed_t) (0x12468000L)) >> 12) /*  1.142211914 */,
     (((mad_fixed_t) (0x083ff000L)) >> 12) /*  0.515609741 */,
     (((mad_fixed_t) (0x01dd8000L)) >> 12) /*  0.116577148 */,
     (((mad_fixed_t) (0x01149000L)) >> 12) /*  0.067520142 */,
     (((mad_fixed_t) (0x00820000L)) >> 12) /*  0.031738281 */,
     (((mad_fixed_t) (0x0015b000L)) >> 12) /*  0.005294800 */,
     (((mad_fixed_t) (0x000ca000L)) >> 12) /*  0.003082275 */,
     (((mad_fixed_t) (0x00018000L)) >> 12) /*  0.000366211 */,

    -(((mad_fixed_t) (0x00001000L)) >> 12) /* -0.000015259 */,
    -(((mad_fixed_t) (0x00023000L)) >> 12) /* -0.000534058 */,
     (((mad_fixed_t) (0x000de000L)) >> 12) /*  0.003387451 */,
    -(((mad_fixed_t) (0x00245000L)) >> 12) /* -0.008865356 */,
     (((mad_fixed_t) (0x007a0000L)) >> 12) /*  0.029785156 */,
    -(((mad_fixed_t) (0x016f7000L)) >> 12) /* -0.089706421 */,
     (((mad_fixed_t) (0x014a8000L)) >> 12) /*  0.080688477 */,
    -(((mad_fixed_t) (0x0a0d8000L)) >> 12) /* -0.628295898 */,
     (((mad_fixed_t) (0x12468000L)) >> 12) /*  1.142211914 */,
     (((mad_fixed_t) (0x083ff000L)) >> 12) /*  0.515609741 */,
     (((mad_fixed_t) (0x01dd8000L)) >> 12) /*  0.116577148 */,
     (((mad_fixed_t) (0x01149000L)) >> 12) /*  0.067520142 */,
     (((mad_fixed_t) (0x00820000L)) >> 12) /*  0.031738281 */,
     (((mad_fixed_t) (0x0015b000L)) >> 12) /*  0.005294800 */,
     (((mad_fixed_t) (0x000ca000L)) >> 12) /*  0.003082275 */,
     (((mad_fixed_t) (0x00018000L)) >> 12) /*  0.000366211 */ },

  { -(((mad_fixed_t) (0x00001000L)) >> 12) /* -0.000015259 */, /*  3 */
    -(((mad_fixed_t) (0x00026000L)) >> 12) /* -0.000579834 */,
     (((mad_fixed_t) (0x000e1000L)) >> 12) /*  0.003433228 */,
    -(((mad_fixed_t) (0x00285000L)) >> 12) /* -0.009841919 */,
     (((mad_fixed_t) (0x00765000L)) >> 12) /*  0.028884888 */,
    -(((mad_fixed_t) (0x0185d000L)) >> 12) /* -0.095169067 */,
     (((mad_fixed_t) (0x011d1000L)) >> 12) /*  0.069595337 */,
    -(((mad_fixed_t) (0x0a7fe000L)) >> 12) /* -0.656219482 */,
     (((mad_fixed_t) (0x12386000L)) >> 12) /*  1.138763428 */,
     (((mad_fixed_t) (0x07ccb000L)) >> 12) /*  0.487472534 */,
     (((mad_fixed_t) (0x01f9c000L)) >> 12) /*  0.123474121 */,
     (((mad_fixed_t) (0x00fdf000L)) >> 12) /*  0.061996460 */,
     (((mad_fixed_t) (0x00827000L)) >> 12) /*  0.031845093 */,
     (((mad_fixed_t) (0x00126000L)) >> 12) /*  0.004486084 */,
     (((mad_fixed_t) (0x000c4000L)) >> 12) /*  0.002990723 */,
     (((mad_fixed_t) (0x00015000L)) >> 12) /*  0.000320435 */,

    -(((mad_fixed_t) (0x00001000L)) >> 12) /* -0.000015259 */,
    -(((mad_fixed_t) (0x00026000L)) >> 12) /* -0.000579834 */,
     (((mad_fixed_t) (0x000e1000L)) >> 12) /*  0.003433228 */,
    -(((mad_fixed_t) (0x00285000L)) >> 12) /* -0.009841919 */,
     (((mad_fixed_t) (0x00765000L)) >> 12) /*  0.028884888 */,
    -(((mad_fixed_t) (0x0185d000L)) >> 12) /* -0.095169067 */,
     (((mad_fixed_t) (0x011d1000L)) >> 12) /*  0.069595337 */,
    -(((mad_fixed_t) (0x0a7fe000L)) >> 12) /* -0.656219482 */,
     (((mad_fixed_t) (0x12386000L)) >> 12) /*  1.138763428 */,
     (((mad_fixed_t) (0x07ccb000L)) >> 12) /*  0.487472534 */,
     (((mad_fixed_t) (0x01f9c000L)) >> 12) /*  0.123474121 */,
     (((mad_fixed_t) (0x00fdf000L)) >> 12) /*  0.061996460 */,
     (((mad_fixed_t) (0x00827000L)) >> 12) /*  0.031845093 */,
     (((mad_fixed_t) (0x00126000L)) >> 12) /*  0.004486084 */,
     (((mad_fixed_t) (0x000c4000L)) >> 12) /*  0.002990723 */,
     (((mad_fixed_t) (0x00015000L)) >> 12) /*  0.000320435 */ },

  { -(((mad_fixed_t) (0x00001000L)) >> 12) /* -0.000015259 */, /*  4 */
    -(((mad_fixed_t) (0x00029000L)) >> 12) /* -0.000625610 */,
     (((mad_fixed_t) (0x000e3000L)) >> 12) /*  0.003463745 */,
    -(((mad_fixed_t) (0x002c7000L)) >> 12) /* -0.010848999 */,
     (((mad_fixed_t) (0x0071e000L)) >> 12) /*  0.027801514 */,
    -(((mad_fixed_t) (0x019bd000L)) >> 12) /* -0.100540161 */,
     (((mad_fixed_t) (0x00ec0000L)) >> 12) /*  0.057617187 */,
    -(((mad_fixed_t) (0x0af15000L)) >> 12) /* -0.683914185 */,
     (((mad_fixed_t) (0x12249000L)) >> 12) /*  1.133926392 */,
     (((mad_fixed_t) (0x075a0000L)) >> 12) /*  0.459472656 */,
     (((mad_fixed_t) (0x0212c000L)) >> 12) /*  0.129577637 */,
     (((mad_fixed_t) (0x00e79000L)) >> 12) /*  0.056533813 */,
     (((mad_fixed_t) (0x00825000L)) >> 12) /*  0.031814575 */,
     (((mad_fixed_t) (0x000f4000L)) >> 12) /*  0.003723145 */,
     (((mad_fixed_t) (0x000be000L)) >> 12) /*  0.002899170 */,
     (((mad_fixed_t) (0x00013000L)) >> 12) /*  0.000289917 */,

    -(((mad_fixed_t) (0x00001000L)) >> 12) /* -0.000015259 */,
    -(((mad_fixed_t) (0x00029000L)) >> 12) /* -0.000625610 */,
     (((mad_fixed_t) (0x000e3000L)) >> 12) /*  0.003463745 */,
    -(((mad_fixed_t) (0x002c7000L)) >> 12) /* -0.010848999 */,
     (((mad_fixed_t) (0x0071e000L)) >> 12) /*  0.027801514 */,
    -(((mad_fixed_t) (0x019bd000L)) >> 12) /* -0.100540161 */,
     (((mad_fixed_t) (0x00ec0000L)) >> 12) /*  0.057617187 */,
    -(((mad_fixed_t) (0x0af15000L)) >> 12) /* -0.683914185 */,
     (((mad_fixed_t) (0x12249000L)) >> 12) /*  1.133926392 */,
     (((mad_fixed_t) (0x075a0000L)) >> 12) /*  0.459472656 */,
     (((mad_fixed_t) (0x0212c000L)) >> 12) /*  0.129577637 */,
     (((mad_fixed_t) (0x00e79000L)) >> 12) /*  0.056533813 */,
     (((mad_fixed_t) (0x00825000L)) >> 12) /*  0.031814575 */,
     (((mad_fixed_t) (0x000f4000L)) >> 12) /*  0.003723145 */,
     (((mad_fixed_t) (0x000be000L)) >> 12) /*  0.002899170 */,
     (((mad_fixed_t) (0x00013000L)) >> 12) /*  0.000289917 */ },

  { -(((mad_fixed_t) (0x00001000L)) >> 12) /* -0.000015259 */, /*  5 */
    -(((mad_fixed_t) (0x0002d000L)) >> 12) /* -0.000686646 */,
     (((mad_fixed_t) (0x000e4000L)) >> 12) /*  0.003479004 */,
    -(((mad_fixed_t) (0x0030b000L)) >> 12) /* -0.011886597 */,
     (((mad_fixed_t) (0x006cb000L)) >> 12) /*  0.026535034 */,
    -(((mad_fixed_t) (0x01b17000L)) >> 12) /* -0.105819702 */,
     (((mad_fixed_t) (0x00b77000L)) >> 12) /*  0.044784546 */,
    -(((mad_fixed_t) (0x0b619000L)) >> 12) /* -0.711318970 */,
     (((mad_fixed_t) (0x120b4000L)) >> 12) /*  1.127746582 */,
     (((mad_fixed_t) (0x06e81000L)) >> 12) /*  0.431655884 */,
     (((mad_fixed_t) (0x02288000L)) >> 12) /*  0.134887695 */,
     (((mad_fixed_t) (0x00d17000L)) >> 12) /*  0.051132202 */,
     (((mad_fixed_t) (0x0081b000L)) >> 12) /*  0.031661987 */,
     (((mad_fixed_t) (0x000c5000L)) >> 12) /*  0.003005981 */,
     (((mad_fixed_t) (0x000b7000L)) >> 12) /*  0.002792358 */,
     (((mad_fixed_t) (0x00011000L)) >> 12) /*  0.000259399 */,

    -(((mad_fixed_t) (0x00001000L)) >> 12) /* -0.000015259 */,
    -(((mad_fixed_t) (0x0002d000L)) >> 12) /* -0.000686646 */,
     (((mad_fixed_t) (0x000e4000L)) >> 12) /*  0.003479004 */,
    -(((mad_fixed_t) (0x0030b000L)) >> 12) /* -0.011886597 */,
     (((mad_fixed_t) (0x006cb000L)) >> 12) /*  0.026535034 */,
    -(((mad_fixed_t) (0x01b17000L)) >> 12) /* -0.105819702 */,
     (((mad_fixed_t) (0x00b77000L)) >> 12) /*  0.044784546 */,
    -(((mad_fixed_t) (0x0b619000L)) >> 12) /* -0.711318970 */,
     (((mad_fixed_t) (0x120b4000L)) >> 12) /*  1.127746582 */,
     (((mad_fixed_t) (0x06e81000L)) >> 12) /*  0.431655884 */,
     (((mad_fixed_t) (0x02288000L)) >> 12) /*  0.134887695 */,
     (((mad_fixed_t) (0x00d17000L)) >> 12) /*  0.051132202 */,
     (((mad_fixed_t) (0x0081b000L)) >> 12) /*  0.031661987 */,
     (((mad_fixed_t) (0x000c5000L)) >> 12) /*  0.003005981 */,
     (((mad_fixed_t) (0x000b7000L)) >> 12) /*  0.002792358 */,
     (((mad_fixed_t) (0x00011000L)) >> 12) /*  0.000259399 */ },

  { -(((mad_fixed_t) (0x00001000L)) >> 12) /* -0.000015259 */, /*  6 */
    -(((mad_fixed_t) (0x00031000L)) >> 12) /* -0.000747681 */,
     (((mad_fixed_t) (0x000e4000L)) >> 12) /*  0.003479004 */,
    -(((mad_fixed_t) (0x00350000L)) >> 12) /* -0.012939453 */,
     (((mad_fixed_t) (0x0066c000L)) >> 12) /*  0.025085449 */,
    -(((mad_fixed_t) (0x01c67000L)) >> 12) /* -0.110946655 */,
     (((mad_fixed_t) (0x007f5000L)) >> 12) /*  0.031082153 */,
    -(((mad_fixed_t) (0x0bd06000L)) >> 12) /* -0.738372803 */,
     (((mad_fixed_t) (0x11ec7000L)) >> 12) /*  1.120223999 */,
     (((mad_fixed_t) (0x06772000L)) >> 12) /*  0.404083252 */,
     (((mad_fixed_t) (0x023b3000L)) >> 12) /*  0.139450073 */,
     (((mad_fixed_t) (0x00bbc000L)) >> 12) /*  0.045837402 */,
     (((mad_fixed_t) (0x00809000L)) >> 12) /*  0.031387329 */,
     (((mad_fixed_t) (0x00099000L)) >> 12) /*  0.002334595 */,
     (((mad_fixed_t) (0x000b0000L)) >> 12) /*  0.002685547 */,
     (((mad_fixed_t) (0x00010000L)) >> 12) /*  0.000244141 */,

    -(((mad_fixed_t) (0x00001000L)) >> 12) /* -0.000015259 */,
    -(((mad_fixed_t) (0x00031000L)) >> 12) /* -0.000747681 */,
     (((mad_fixed_t) (0x000e4000L)) >> 12) /*  0.003479004 */,
    -(((mad_fixed_t) (0x00350000L)) >> 12) /* -0.012939453 */,
     (((mad_fixed_t) (0x0066c000L)) >> 12) /*  0.025085449 */,
    -(((mad_fixed_t) (0x01c67000L)) >> 12) /* -0.110946655 */,
     (((mad_fixed_t) (0x007f5000L)) >> 12) /*  0.031082153 */,
    -(((mad_fixed_t) (0x0bd06000L)) >> 12) /* -0.738372803 */,
     (((mad_fixed_t) (0x11ec7000L)) >> 12) /*  1.120223999 */,
     (((mad_fixed_t) (0x06772000L)) >> 12) /*  0.404083252 */,
     (((mad_fixed_t) (0x023b3000L)) >> 12) /*  0.139450073 */,
     (((mad_fixed_t) (0x00bbc000L)) >> 12) /*  0.045837402 */,
     (((mad_fixed_t) (0x00809000L)) >> 12) /*  0.031387329 */,
     (((mad_fixed_t) (0x00099000L)) >> 12) /*  0.002334595 */,
     (((mad_fixed_t) (0x000b0000L)) >> 12) /*  0.002685547 */,
     (((mad_fixed_t) (0x00010000L)) >> 12) /*  0.000244141 */ },

  { -(((mad_fixed_t) (0x00002000L)) >> 12) /* -0.000030518 */, /*  7 */
    -(((mad_fixed_t) (0x00035000L)) >> 12) /* -0.000808716 */,
     (((mad_fixed_t) (0x000e3000L)) >> 12) /*  0.003463745 */,
    -(((mad_fixed_t) (0x00397000L)) >> 12) /* -0.014022827 */,
     (((mad_fixed_t) (0x005ff000L)) >> 12) /*  0.023422241 */,
    -(((mad_fixed_t) (0x01dad000L)) >> 12) /* -0.115921021 */,
     (((mad_fixed_t) (0x0043a000L)) >> 12) /*  0.016510010 */,
    -(((mad_fixed_t) (0x0c3d9000L)) >> 12) /* -0.765029907 */,
     (((mad_fixed_t) (0x11c83000L)) >> 12) /*  1.111373901 */,
     (((mad_fixed_t) (0x06076000L)) >> 12) /*  0.376800537 */,
     (((mad_fixed_t) (0x024ad000L)) >> 12) /*  0.143264771 */,
     (((mad_fixed_t) (0x00a67000L)) >> 12) /*  0.040634155 */,
     (((mad_fixed_t) (0x007f0000L)) >> 12) /*  0.031005859 */,
     (((mad_fixed_t) (0x0006f000L)) >> 12) /*  0.001693726 */,
     (((mad_fixed_t) (0x000a9000L)) >> 12) /*  0.002578735 */,
     (((mad_fixed_t) (0x0000e000L)) >> 12) /*  0.000213623 */,

    -(((mad_fixed_t) (0x00002000L)) >> 12) /* -0.000030518 */,
    -(((mad_fixed_t) (0x00035000L)) >> 12) /* -0.000808716 */,
     (((mad_fixed_t) (0x000e3000L)) >> 12) /*  0.003463745 */,
    -(((mad_fixed_t) (0x00397000L)) >> 12) /* -0.014022827 */,
     (((mad_fixed_t) (0x005ff000L)) >> 12) /*  0.023422241 */,
    -(((mad_fixed_t) (0x01dad000L)) >> 12) /* -0.115921021 */,
     (((mad_fixed_t) (0x0043a000L)) >> 12) /*  0.016510010 */,
    -(((mad_fixed_t) (0x0c3d9000L)) >> 12) /* -0.765029907 */,
     (((mad_fixed_t) (0x11c83000L)) >> 12) /*  1.111373901 */,
     (((mad_fixed_t) (0x06076000L)) >> 12) /*  0.376800537 */,
     (((mad_fixed_t) (0x024ad000L)) >> 12) /*  0.143264771 */,
     (((mad_fixed_t) (0x00a67000L)) >> 12) /*  0.040634155 */,
     (((mad_fixed_t) (0x007f0000L)) >> 12) /*  0.031005859 */,
     (((mad_fixed_t) (0x0006f000L)) >> 12) /*  0.001693726 */,
     (((mad_fixed_t) (0x000a9000L)) >> 12) /*  0.002578735 */,
     (((mad_fixed_t) (0x0000e000L)) >> 12) /*  0.000213623 */ },

  { -(((mad_fixed_t) (0x00002000L)) >> 12) /* -0.000030518 */, /*  8 */
    -(((mad_fixed_t) (0x0003a000L)) >> 12) /* -0.000885010 */,
     (((mad_fixed_t) (0x000e0000L)) >> 12) /*  0.003417969 */,
    -(((mad_fixed_t) (0x003df000L)) >> 12) /* -0.015121460 */,
     (((mad_fixed_t) (0x00586000L)) >> 12) /*  0.021575928 */,
    -(((mad_fixed_t) (0x01ee6000L)) >> 12) /* -0.120697021 */,
     (((mad_fixed_t) (0x00046000L)) >> 12) /*  0.001068115 */,
    -(((mad_fixed_t) (0x0ca8d000L)) >> 12) /* -0.791213989 */,
     (((mad_fixed_t) (0x119e9000L)) >> 12) /*  1.101211548 */,
     (((mad_fixed_t) (0x05991000L)) >> 12) /*  0.349868774 */,
     (((mad_fixed_t) (0x02578000L)) >> 12) /*  0.146362305 */,
     (((mad_fixed_t) (0x0091a000L)) >> 12) /*  0.035552979 */,
     (((mad_fixed_t) (0x007d1000L)) >> 12) /*  0.030532837 */,
     (((mad_fixed_t) (0x00048000L)) >> 12) /*  0.001098633 */,
     (((mad_fixed_t) (0x000a1000L)) >> 12) /*  0.002456665 */,
     (((mad_fixed_t) (0x0000d000L)) >> 12) /*  0.000198364 */,

    -(((mad_fixed_t) (0x00002000L)) >> 12) /* -0.000030518 */,
    -(((mad_fixed_t) (0x0003a000L)) >> 12) /* -0.000885010 */,
     (((mad_fixed_t) (0x000e0000L)) >> 12) /*  0.003417969 */,
    -(((mad_fixed_t) (0x003df000L)) >> 12) /* -0.015121460 */,
     (((mad_fixed_t) (0x00586000L)) >> 12) /*  0.021575928 */,
    -(((mad_fixed_t) (0x01ee6000L)) >> 12) /* -0.120697021 */,
     (((mad_fixed_t) (0x00046000L)) >> 12) /*  0.001068115 */,
    -(((mad_fixed_t) (0x0ca8d000L)) >> 12) /* -0.791213989 */,
     (((mad_fixed_t) (0x119e9000L)) >> 12) /*  1.101211548 */,
     (((mad_fixed_t) (0x05991000L)) >> 12) /*  0.349868774 */,
     (((mad_fixed_t) (0x02578000L)) >> 12) /*  0.146362305 */,
     (((mad_fixed_t) (0x0091a000L)) >> 12) /*  0.035552979 */,
     (((mad_fixed_t) (0x007d1000L)) >> 12) /*  0.030532837 */,
     (((mad_fixed_t) (0x00048000L)) >> 12) /*  0.001098633 */,
     (((mad_fixed_t) (0x000a1000L)) >> 12) /*  0.002456665 */,
     (((mad_fixed_t) (0x0000d000L)) >> 12) /*  0.000198364 */ },

  { -(((mad_fixed_t) (0x00002000L)) >> 12) /* -0.000030518 */, /*  9 */
    -(((mad_fixed_t) (0x0003f000L)) >> 12) /* -0.000961304 */,
     (((mad_fixed_t) (0x000dd000L)) >> 12) /*  0.003372192 */,
    -(((mad_fixed_t) (0x00428000L)) >> 12) /* -0.016235352 */,
     (((mad_fixed_t) (0x00500000L)) >> 12) /*  0.019531250 */,
    -(((mad_fixed_t) (0x02011000L)) >> 12) /* -0.125259399 */,
    -(((mad_fixed_t) (0x003e6000L)) >> 12) /* -0.015228271 */,
    -(((mad_fixed_t) (0x0d11e000L)) >> 12) /* -0.816864014 */,
     (((mad_fixed_t) (0x116fc000L)) >> 12) /*  1.089782715 */,
     (((mad_fixed_t) (0x052c5000L)) >> 12) /*  0.323318481 */,
     (((mad_fixed_t) (0x02616000L)) >> 12) /*  0.148773193 */,
     (((mad_fixed_t) (0x007d6000L)) >> 12) /*  0.030609131 */,
     (((mad_fixed_t) (0x007aa000L)) >> 12) /*  0.029937744 */,
     (((mad_fixed_t) (0x00024000L)) >> 12) /*  0.000549316 */,
     (((mad_fixed_t) (0x0009a000L)) >> 12) /*  0.002349854 */,
     (((mad_fixed_t) (0x0000b000L)) >> 12) /*  0.000167847 */,

    -(((mad_fixed_t) (0x00002000L)) >> 12) /* -0.000030518 */,
    -(((mad_fixed_t) (0x0003f000L)) >> 12) /* -0.000961304 */,
     (((mad_fixed_t) (0x000dd000L)) >> 12) /*  0.003372192 */,
    -(((mad_fixed_t) (0x00428000L)) >> 12) /* -0.016235352 */,
     (((mad_fixed_t) (0x00500000L)) >> 12) /*  0.019531250 */,
    -(((mad_fixed_t) (0x02011000L)) >> 12) /* -0.125259399 */,
    -(((mad_fixed_t) (0x003e6000L)) >> 12) /* -0.015228271 */,
    -(((mad_fixed_t) (0x0d11e000L)) >> 12) /* -0.816864014 */,
     (((mad_fixed_t) (0x116fc000L)) >> 12) /*  1.089782715 */,
     (((mad_fixed_t) (0x052c5000L)) >> 12) /*  0.323318481 */,
     (((mad_fixed_t) (0x02616000L)) >> 12) /*  0.148773193 */,
     (((mad_fixed_t) (0x007d6000L)) >> 12) /*  0.030609131 */,
     (((mad_fixed_t) (0x007aa000L)) >> 12) /*  0.029937744 */,
     (((mad_fixed_t) (0x00024000L)) >> 12) /*  0.000549316 */,
     (((mad_fixed_t) (0x0009a000L)) >> 12) /*  0.002349854 */,
     (((mad_fixed_t) (0x0000b000L)) >> 12) /*  0.000167847 */ },

  { -(((mad_fixed_t) (0x00002000L)) >> 12) /* -0.000030518 */, /* 10 */
    -(((mad_fixed_t) (0x00044000L)) >> 12) /* -0.001037598 */,
     (((mad_fixed_t) (0x000d7000L)) >> 12) /*  0.003280640 */,
    -(((mad_fixed_t) (0x00471000L)) >> 12) /* -0.017349243 */,
     (((mad_fixed_t) (0x0046b000L)) >> 12) /*  0.017257690 */,
    -(((mad_fixed_t) (0x0212b000L)) >> 12) /* -0.129562378 */,
    -(((mad_fixed_t) (0x0084a000L)) >> 12) /* -0.032379150 */,
    -(((mad_fixed_t) (0x0d78a000L)) >> 12) /* -0.841949463 */,
     (((mad_fixed_t) (0x113be000L)) >> 12) /*  1.077117920 */,
     (((mad_fixed_t) (0x04c16000L)) >> 12) /*  0.297210693 */,
     (((mad_fixed_t) (0x02687000L)) >> 12) /*  0.150497437 */,
     (((mad_fixed_t) (0x0069c000L)) >> 12) /*  0.025817871 */,
     (((mad_fixed_t) (0x0077f000L)) >> 12) /*  0.029281616 */,
     (((mad_fixed_t) (0x00002000L)) >> 12) /*  0.000030518 */,
     (((mad_fixed_t) (0x00093000L)) >> 12) /*  0.002243042 */,
     (((mad_fixed_t) (0x0000a000L)) >> 12) /*  0.000152588 */,

    -(((mad_fixed_t) (0x00002000L)) >> 12) /* -0.000030518 */,
    -(((mad_fixed_t) (0x00044000L)) >> 12) /* -0.001037598 */,
     (((mad_fixed_t) (0x000d7000L)) >> 12) /*  0.003280640 */,
    -(((mad_fixed_t) (0x00471000L)) >> 12) /* -0.017349243 */,
     (((mad_fixed_t) (0x0046b000L)) >> 12) /*  0.017257690 */,
    -(((mad_fixed_t) (0x0212b000L)) >> 12) /* -0.129562378 */,
    -(((mad_fixed_t) (0x0084a000L)) >> 12) /* -0.032379150 */,
    -(((mad_fixed_t) (0x0d78a000L)) >> 12) /* -0.841949463 */,
     (((mad_fixed_t) (0x113be000L)) >> 12) /*  1.077117920 */,
     (((mad_fixed_t) (0x04c16000L)) >> 12) /*  0.297210693 */,
     (((mad_fixed_t) (0x02687000L)) >> 12) /*  0.150497437 */,
     (((mad_fixed_t) (0x0069c000L)) >> 12) /*  0.025817871 */,
     (((mad_fixed_t) (0x0077f000L)) >> 12) /*  0.029281616 */,
     (((mad_fixed_t) (0x00002000L)) >> 12) /*  0.000030518 */,
     (((mad_fixed_t) (0x00093000L)) >> 12) /*  0.002243042 */,
     (((mad_fixed_t) (0x0000a000L)) >> 12) /*  0.000152588 */ },

  { -(((mad_fixed_t) (0x00003000L)) >> 12) /* -0.000045776 */, /* 11 */
    -(((mad_fixed_t) (0x00049000L)) >> 12) /* -0.001113892 */,
     (((mad_fixed_t) (0x000d0000L)) >> 12) /*  0.003173828 */,
    -(((mad_fixed_t) (0x004ba000L)) >> 12) /* -0.018463135 */,
     (((mad_fixed_t) (0x003ca000L)) >> 12) /*  0.014801025 */,
    -(((mad_fixed_t) (0x02233000L)) >> 12) /* -0.133590698 */,
    -(((mad_fixed_t) (0x00ce4000L)) >> 12) /* -0.050354004 */,
    -(((mad_fixed_t) (0x0ddca000L)) >> 12) /* -0.866363525 */,
     (((mad_fixed_t) (0x1102f000L)) >> 12) /*  1.063217163 */,
     (((mad_fixed_t) (0x04587000L)) >> 12) /*  0.271591187 */,
     (((mad_fixed_t) (0x026cf000L)) >> 12) /*  0.151596069 */,
     (((mad_fixed_t) (0x0056c000L)) >> 12) /*  0.021179199 */,
     (((mad_fixed_t) (0x0074e000L)) >> 12) /*  0.028533936 */,
    -(((mad_fixed_t) (0x0001d000L)) >> 12) /* -0.000442505 */,
     (((mad_fixed_t) (0x0008b000L)) >> 12) /*  0.002120972 */,
     (((mad_fixed_t) (0x00009000L)) >> 12) /*  0.000137329 */,

    -(((mad_fixed_t) (0x00003000L)) >> 12) /* -0.000045776 */,
    -(((mad_fixed_t) (0x00049000L)) >> 12) /* -0.001113892 */,
     (((mad_fixed_t) (0x000d0000L)) >> 12) /*  0.003173828 */,
    -(((mad_fixed_t) (0x004ba000L)) >> 12) /* -0.018463135 */,
     (((mad_fixed_t) (0x003ca000L)) >> 12) /*  0.014801025 */,
    -(((mad_fixed_t) (0x02233000L)) >> 12) /* -0.133590698 */,
    -(((mad_fixed_t) (0x00ce4000L)) >> 12) /* -0.050354004 */,
    -(((mad_fixed_t) (0x0ddca000L)) >> 12) /* -0.866363525 */,
     (((mad_fixed_t) (0x1102f000L)) >> 12) /*  1.063217163 */,
     (((mad_fixed_t) (0x04587000L)) >> 12) /*  0.271591187 */,
     (((mad_fixed_t) (0x026cf000L)) >> 12) /*  0.151596069 */,
     (((mad_fixed_t) (0x0056c000L)) >> 12) /*  0.021179199 */,
     (((mad_fixed_t) (0x0074e000L)) >> 12) /*  0.028533936 */,
    -(((mad_fixed_t) (0x0001d000L)) >> 12) /* -0.000442505 */,
     (((mad_fixed_t) (0x0008b000L)) >> 12) /*  0.002120972 */,
     (((mad_fixed_t) (0x00009000L)) >> 12) /*  0.000137329 */ },

  { -(((mad_fixed_t) (0x00003000L)) >> 12) /* -0.000045776 */, /* 12 */
    -(((mad_fixed_t) (0x0004f000L)) >> 12) /* -0.001205444 */,
     (((mad_fixed_t) (0x000c8000L)) >> 12) /*  0.003051758 */,
    -(((mad_fixed_t) (0x00503000L)) >> 12) /* -0.019577026 */,
     (((mad_fixed_t) (0x0031a000L)) >> 12) /*  0.012115479 */,
    -(((mad_fixed_t) (0x02326000L)) >> 12) /* -0.137298584 */,
    -(((mad_fixed_t) (0x011b5000L)) >> 12) /* -0.069168091 */,
    -(((mad_fixed_t) (0x0e3dd000L)) >> 12) /* -0.890090942 */,
     (((mad_fixed_t) (0x10c54000L)) >> 12) /*  1.048156738 */,
     (((mad_fixed_t) (0x03f1b000L)) >> 12) /*  0.246505737 */,
     (((mad_fixed_t) (0x026ee000L)) >> 12) /*  0.152069092 */,
     (((mad_fixed_t) (0x00447000L)) >> 12) /*  0.016708374 */,
     (((mad_fixed_t) (0x00719000L)) >> 12) /*  0.027725220 */,
    -(((mad_fixed_t) (0x00039000L)) >> 12) /* -0.000869751 */,
     (((mad_fixed_t) (0x00084000L)) >> 12) /*  0.002014160 */,
     (((mad_fixed_t) (0x00008000L)) >> 12) /*  0.000122070 */,

    -(((mad_fixed_t) (0x00003000L)) >> 12) /* -0.000045776 */,
    -(((mad_fixed_t) (0x0004f000L)) >> 12) /* -0.001205444 */,
     (((mad_fixed_t) (0x000c8000L)) >> 12) /*  0.003051758 */,
    -(((mad_fixed_t) (0x00503000L)) >> 12) /* -0.019577026 */,
     (((mad_fixed_t) (0x0031a000L)) >> 12) /*  0.012115479 */,
    -(((mad_fixed_t) (0x02326000L)) >> 12) /* -0.137298584 */,
    -(((mad_fixed_t) (0x011b5000L)) >> 12) /* -0.069168091 */,
    -(((mad_fixed_t) (0x0e3dd000L)) >> 12) /* -0.890090942 */,
     (((mad_fixed_t) (0x10c54000L)) >> 12) /*  1.048156738 */,
     (((mad_fixed_t) (0x03f1b000L)) >> 12) /*  0.246505737 */,
     (((mad_fixed_t) (0x026ee000L)) >> 12) /*  0.152069092 */,
     (((mad_fixed_t) (0x00447000L)) >> 12) /*  0.016708374 */,
     (((mad_fixed_t) (0x00719000L)) >> 12) /*  0.027725220 */,
    -(((mad_fixed_t) (0x00039000L)) >> 12) /* -0.000869751 */,
     (((mad_fixed_t) (0x00084000L)) >> 12) /*  0.002014160 */,
     (((mad_fixed_t) (0x00008000L)) >> 12) /*  0.000122070 */ },

  { -(((mad_fixed_t) (0x00004000L)) >> 12) /* -0.000061035 */, /* 13 */
    -(((mad_fixed_t) (0x00055000L)) >> 12) /* -0.001296997 */,
     (((mad_fixed_t) (0x000bd000L)) >> 12) /*  0.002883911 */,
    -(((mad_fixed_t) (0x0054c000L)) >> 12) /* -0.020690918 */,
     (((mad_fixed_t) (0x0025d000L)) >> 12) /*  0.009231567 */,
    -(((mad_fixed_t) (0x02403000L)) >> 12) /* -0.140670776 */,
    -(((mad_fixed_t) (0x016ba000L)) >> 12) /* -0.088775635 */,
    -(((mad_fixed_t) (0x0e9be000L)) >> 12) /* -0.913055420 */,
     (((mad_fixed_t) (0x1082d000L)) >> 12) /*  1.031936646 */,
     (((mad_fixed_t) (0x038d4000L)) >> 12) /*  0.221984863 */,
     (((mad_fixed_t) (0x026e7000L)) >> 12) /*  0.151962280 */,
     (((mad_fixed_t) (0x0032e000L)) >> 12) /*  0.012420654 */,
     (((mad_fixed_t) (0x006df000L)) >> 12) /*  0.026840210 */,
    -(((mad_fixed_t) (0x00053000L)) >> 12) /* -0.001266479 */,
     (((mad_fixed_t) (0x0007d000L)) >> 12) /*  0.001907349 */,
     (((mad_fixed_t) (0x00007000L)) >> 12) /*  0.000106812 */,

    -(((mad_fixed_t) (0x00004000L)) >> 12) /* -0.000061035 */,
    -(((mad_fixed_t) (0x00055000L)) >> 12) /* -0.001296997 */,
     (((mad_fixed_t) (0x000bd000L)) >> 12) /*  0.002883911 */,
    -(((mad_fixed_t) (0x0054c000L)) >> 12) /* -0.020690918 */,
     (((mad_fixed_t) (0x0025d000L)) >> 12) /*  0.009231567 */,
    -(((mad_fixed_t) (0x02403000L)) >> 12) /* -0.140670776 */,
    -(((mad_fixed_t) (0x016ba000L)) >> 12) /* -0.088775635 */,
    -(((mad_fixed_t) (0x0e9be000L)) >> 12) /* -0.913055420 */,
     (((mad_fixed_t) (0x1082d000L)) >> 12) /*  1.031936646 */,
     (((mad_fixed_t) (0x038d4000L)) >> 12) /*  0.221984863 */,
     (((mad_fixed_t) (0x026e7000L)) >> 12) /*  0.151962280 */,
     (((mad_fixed_t) (0x0032e000L)) >> 12) /*  0.012420654 */,
     (((mad_fixed_t) (0x006df000L)) >> 12) /*  0.026840210 */,
    -(((mad_fixed_t) (0x00053000L)) >> 12) /* -0.001266479 */,
     (((mad_fixed_t) (0x0007d000L)) >> 12) /*  0.001907349 */,
     (((mad_fixed_t) (0x00007000L)) >> 12) /*  0.000106812 */ },

  { -(((mad_fixed_t) (0x00004000L)) >> 12) /* -0.000061035 */, /* 14 */
    -(((mad_fixed_t) (0x0005b000L)) >> 12) /* -0.001388550 */,
     (((mad_fixed_t) (0x000b1000L)) >> 12) /*  0.002700806 */,
    -(((mad_fixed_t) (0x00594000L)) >> 12) /* -0.021789551 */,
     (((mad_fixed_t) (0x00192000L)) >> 12) /*  0.006134033 */,
    -(((mad_fixed_t) (0x024c8000L)) >> 12) /* -0.143676758 */,
    -(((mad_fixed_t) (0x01bf2000L)) >> 12) /* -0.109161377 */,
    -(((mad_fixed_t) (0x0ef69000L)) >> 12) /* -0.935195923 */,
     (((mad_fixed_t) (0x103be000L)) >> 12) /*  1.014617920 */,
     (((mad_fixed_t) (0x032b4000L)) >> 12) /*  0.198059082 */,
     (((mad_fixed_t) (0x026bc000L)) >> 12) /*  0.151306152 */,
     (((mad_fixed_t) (0x00221000L)) >> 12) /*  0.008316040 */,
     (((mad_fixed_t) (0x006a2000L)) >> 12) /*  0.025909424 */,
    -(((mad_fixed_t) (0x0006a000L)) >> 12) /* -0.001617432 */,
     (((mad_fixed_t) (0x00075000L)) >> 12) /*  0.001785278 */,
     (((mad_fixed_t) (0x00007000L)) >> 12) /*  0.000106812 */,

    -(((mad_fixed_t) (0x00004000L)) >> 12) /* -0.000061035 */,
    -(((mad_fixed_t) (0x0005b000L)) >> 12) /* -0.001388550 */,
     (((mad_fixed_t) (0x000b1000L)) >> 12) /*  0.002700806 */,
    -(((mad_fixed_t) (0x00594000L)) >> 12) /* -0.021789551 */,
     (((mad_fixed_t) (0x00192000L)) >> 12) /*  0.006134033 */,
    -(((mad_fixed_t) (0x024c8000L)) >> 12) /* -0.143676758 */,
    -(((mad_fixed_t) (0x01bf2000L)) >> 12) /* -0.109161377 */,
    -(((mad_fixed_t) (0x0ef69000L)) >> 12) /* -0.935195923 */,
     (((mad_fixed_t) (0x103be000L)) >> 12) /*  1.014617920 */,
     (((mad_fixed_t) (0x032b4000L)) >> 12) /*  0.198059082 */,
     (((mad_fixed_t) (0x026bc000L)) >> 12) /*  0.151306152 */,
     (((mad_fixed_t) (0x00221000L)) >> 12) /*  0.008316040 */,
     (((mad_fixed_t) (0x006a2000L)) >> 12) /*  0.025909424 */,
    -(((mad_fixed_t) (0x0006a000L)) >> 12) /* -0.001617432 */,
     (((mad_fixed_t) (0x00075000L)) >> 12) /*  0.001785278 */,
     (((mad_fixed_t) (0x00007000L)) >> 12) /*  0.000106812 */ },

  { -(((mad_fixed_t) (0x00005000L)) >> 12) /* -0.000076294 */, /* 15 */
    -(((mad_fixed_t) (0x00061000L)) >> 12) /* -0.001480103 */,
     (((mad_fixed_t) (0x000a3000L)) >> 12) /*  0.002487183 */,
    -(((mad_fixed_t) (0x005da000L)) >> 12) /* -0.022857666 */,
     (((mad_fixed_t) (0x000b9000L)) >> 12) /*  0.002822876 */,
    -(((mad_fixed_t) (0x02571000L)) >> 12) /* -0.146255493 */,
    -(((mad_fixed_t) (0x0215c000L)) >> 12) /* -0.130310059 */,
    -(((mad_fixed_t) (0x0f4dc000L)) >> 12) /* -0.956481934 */,
     (((mad_fixed_t) (0x0ff0a000L)) >> 12) /*  0.996246338 */,
     (((mad_fixed_t) (0x02cbf000L)) >> 12) /*  0.174789429 */,
     (((mad_fixed_t) (0x0266e000L)) >> 12) /*  0.150115967 */,
     (((mad_fixed_t) (0x00120000L)) >> 12) /*  0.004394531 */,
     (((mad_fixed_t) (0x00662000L)) >> 12) /*  0.024932861 */,
    -(((mad_fixed_t) (0x0007f000L)) >> 12) /* -0.001937866 */,
     (((mad_fixed_t) (0x0006f000L)) >> 12) /*  0.001693726 */,
     (((mad_fixed_t) (0x00006000L)) >> 12) /*  0.000091553 */,

    -(((mad_fixed_t) (0x00005000L)) >> 12) /* -0.000076294 */,
    -(((mad_fixed_t) (0x00061000L)) >> 12) /* -0.001480103 */,
     (((mad_fixed_t) (0x000a3000L)) >> 12) /*  0.002487183 */,
    -(((mad_fixed_t) (0x005da000L)) >> 12) /* -0.022857666 */,
     (((mad_fixed_t) (0x000b9000L)) >> 12) /*  0.002822876 */,
    -(((mad_fixed_t) (0x02571000L)) >> 12) /* -0.146255493 */,
    -(((mad_fixed_t) (0x0215c000L)) >> 12) /* -0.130310059 */,
    -(((mad_fixed_t) (0x0f4dc000L)) >> 12) /* -0.956481934 */,
     (((mad_fixed_t) (0x0ff0a000L)) >> 12) /*  0.996246338 */,
     (((mad_fixed_t) (0x02cbf000L)) >> 12) /*  0.174789429 */,
     (((mad_fixed_t) (0x0266e000L)) >> 12) /*  0.150115967 */,
     (((mad_fixed_t) (0x00120000L)) >> 12) /*  0.004394531 */,
     (((mad_fixed_t) (0x00662000L)) >> 12) /*  0.024932861 */,
    -(((mad_fixed_t) (0x0007f000L)) >> 12) /* -0.001937866 */,
     (((mad_fixed_t) (0x0006f000L)) >> 12) /*  0.001693726 */,
     (((mad_fixed_t) (0x00006000L)) >> 12) /*  0.000091553 */ },

  { -(((mad_fixed_t) (0x00005000L)) >> 12) /* -0.000076294 */, /* 16 */
    -(((mad_fixed_t) (0x00068000L)) >> 12) /* -0.001586914 */,
     (((mad_fixed_t) (0x00092000L)) >> 12) /*  0.002227783 */,
    -(((mad_fixed_t) (0x0061f000L)) >> 12) /* -0.023910522 */,
    -(((mad_fixed_t) (0x0002d000L)) >> 12) /* -0.000686646 */,
    -(((mad_fixed_t) (0x025ff000L)) >> 12) /* -0.148422241 */,
    -(((mad_fixed_t) (0x026f7000L)) >> 12) /* -0.152206421 */,
    -(((mad_fixed_t) (0x0fa13000L)) >> 12) /* -0.976852417 */,
     (((mad_fixed_t) (0x0fa13000L)) >> 12) /*  0.976852417 */,
     (((mad_fixed_t) (0x026f7000L)) >> 12) /*  0.152206421 */,
     (((mad_fixed_t) (0x025ff000L)) >> 12) /*  0.148422241 */,
     (((mad_fixed_t) (0x0002d000L)) >> 12) /*  0.000686646 */,
     (((mad_fixed_t) (0x0061f000L)) >> 12) /*  0.023910522 */,
    -(((mad_fixed_t) (0x00092000L)) >> 12) /* -0.002227783 */,
     (((mad_fixed_t) (0x00068000L)) >> 12) /*  0.001586914 */,
     (((mad_fixed_t) (0x00005000L)) >> 12) /*  0.000076294 */,

    -(((mad_fixed_t) (0x00005000L)) >> 12) /* -0.000076294 */,
    -(((mad_fixed_t) (0x00068000L)) >> 12) /* -0.001586914 */,
     (((mad_fixed_t) (0x00092000L)) >> 12) /*  0.002227783 */,
    -(((mad_fixed_t) (0x0061f000L)) >> 12) /* -0.023910522 */,
    -(((mad_fixed_t) (0x0002d000L)) >> 12) /* -0.000686646 */,
    -(((mad_fixed_t) (0x025ff000L)) >> 12) /* -0.148422241 */,
    -(((mad_fixed_t) (0x026f7000L)) >> 12) /* -0.152206421 */,
    -(((mad_fixed_t) (0x0fa13000L)) >> 12) /* -0.976852417 */,
     (((mad_fixed_t) (0x0fa13000L)) >> 12) /*  0.976852417 */,
     (((mad_fixed_t) (0x026f7000L)) >> 12) /*  0.152206421 */,
     (((mad_fixed_t) (0x025ff000L)) >> 12) /*  0.148422241 */,
     (((mad_fixed_t) (0x0002d000L)) >> 12) /*  0.000686646 */,
     (((mad_fixed_t) (0x0061f000L)) >> 12) /*  0.023910522 */,
    -(((mad_fixed_t) (0x00092000L)) >> 12) /* -0.002227783 */,
     (((mad_fixed_t) (0x00068000L)) >> 12) /*  0.001586914 */,
     (((mad_fixed_t) (0x00005000L)) >> 12) /*  0.000076294 */ }
# 547 "mad_synth.c" 2
};

# 557 "mad_synth.c"
static
void synth_full(struct mad_synth *synth, struct mad_frame const *frame,
  unsigned int nch, unsigned int ns)
{
  unsigned int phase, ch, s, sb, pe, po;
  mad_fixed_t *pcm1, *pcm2, (*filter)[2][2][16][8];
  mad_fixed_t const (*sbsample)[36][32];
  register mad_fixed_t (*fe)[8], (*fx)[8], (*fo)[8];
  register mad_fixed_t const (*Dptr)[32], *ptr;
  register mad_fixed64hi_t hi;
  register mad_fixed64lo_t lo;

  for (ch = 0; ch < nch; ++ch) {
    sbsample = &frame->sbsample[ch];
    filter = &synth->filter[ch];
    phase = synth->phase;
    pcm1 = synth->pcm.samples[ch];

    for (s = 0; s < ns; ++s) {
      dct32((*sbsample)[s], phase >> 1,
     (*filter)[0][phase & 1], (*filter)[1][phase & 1]);

      pe = phase & ~1;
      po = ((phase - 1) & 0xf) | 1;

      /* calculate 32 samples */

      fe = &(*filter)[0][ phase & 1][0];
      fx = &(*filter)[0][~phase & 1][0];
      fo = &(*filter)[1][~phase & 1][0];

      Dptr = &D[0];

      ptr = *Dptr + po;
      (((lo)) = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fx)[0])))), "rm" ((((ptr[ 0])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fx)[1])))), "rm" ((((ptr[14])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fx)[2])))), "rm" ((((ptr[12])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fx)[3])))), "rm" ((((ptr[10])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fx)[4])))), "rm" ((((ptr[ 8])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fx)[5])))), "rm" ((((ptr[ 6])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fx)[6])))), "rm" ((((ptr[ 4])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fx)[7])))), "rm" ((((ptr[ 2])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) = -((lo)));

      ptr = *Dptr + pe;
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[0])))), "rm" ((((ptr[ 0])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[1])))), "rm" ((((ptr[14])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[2])))), "rm" ((((ptr[12])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[3])))), "rm" ((((ptr[10])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[4])))), "rm" ((((ptr[ 8])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[5])))), "rm" ((((ptr[ 6])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[6])))), "rm" ((((ptr[ 4])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[7])))), "rm" ((((ptr[ 2])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));

      *pcm1++ = (((void) ((hi)), (mad_fixed_t) ((lo))));

      pcm2 = pcm1 + 30;

      for (sb = 1; sb < 16; ++sb) {
 ++fe;
 ++Dptr;

 /* D[32 - sb][i] == -D[sb][31 - i] */

 ptr = *Dptr + po;
 (((lo)) = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[0])))), "rm" ((((ptr[ 0])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[1])))), "rm" ((((ptr[14])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[2])))), "rm" ((((ptr[12])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[3])))), "rm" ((((ptr[10])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[4])))), "rm" ((((ptr[ 8])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[5])))), "rm" ((((ptr[ 6])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[6])))), "rm" ((((ptr[ 4])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[7])))), "rm" ((((ptr[ 2])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) = -((lo)));

 ptr = *Dptr + pe;
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[7])))), "rm" ((((ptr[ 2])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[6])))), "rm" ((((ptr[ 4])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[5])))), "rm" ((((ptr[ 6])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[4])))), "rm" ((((ptr[ 8])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[3])))), "rm" ((((ptr[10])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[2])))), "rm" ((((ptr[12])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[1])))), "rm" ((((ptr[14])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[0])))), "rm" ((((ptr[ 0])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));

 *pcm1++ = (((void) ((hi)), (mad_fixed_t) ((lo))));

 ptr = *Dptr - pe;
 (((lo)) = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[0])))), "rm" ((((ptr[31 - 16])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[1])))), "rm" ((((ptr[31 - 14])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[2])))), "rm" ((((ptr[31 - 12])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[3])))), "rm" ((((ptr[31 - 10])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[4])))), "rm" ((((ptr[31 - 8])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[5])))), "rm" ((((ptr[31 - 6])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[6])))), "rm" ((((ptr[31 - 4])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[7])))), "rm" ((((ptr[31 - 2])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));

 ptr = *Dptr - po;
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[7])))), "rm" ((((ptr[31 - 2])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[6])))), "rm" ((((ptr[31 - 4])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[5])))), "rm" ((((ptr[31 - 6])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[4])))), "rm" ((((ptr[31 - 8])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[3])))), "rm" ((((ptr[31 - 10])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[2])))), "rm" ((((ptr[31 - 12])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[1])))), "rm" ((((ptr[31 - 14])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
 (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[0])))), "rm" ((((ptr[31 - 16])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));

 *pcm2-- = (((void) ((hi)), (mad_fixed_t) ((lo))));

 ++fo;
      }

      ++Dptr;

      ptr = *Dptr + po;
      (((lo)) = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[0])))), "rm" ((((ptr[ 0])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[1])))), "rm" ((((ptr[14])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[2])))), "rm" ((((ptr[12])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[3])))), "rm" ((((ptr[10])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[4])))), "rm" ((((ptr[ 8])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[5])))), "rm" ((((ptr[ 6])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[6])))), "rm" ((((ptr[ 4])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[7])))), "rm" ((((ptr[ 2])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));

      *pcm1 = (-((void) ((hi)), (mad_fixed_t) ((lo))));
      pcm1 += 16;

      phase = (phase + 1) % 16;
    }
  }
}

# 694 "mad_synth.c"
static
void synth_half(struct mad_synth *synth, struct mad_frame const *frame,
  unsigned int nch, unsigned int ns)
{
  unsigned int phase, ch, s, sb, pe, po;
  mad_fixed_t *pcm1, *pcm2, (*filter)[2][2][16][8];
  mad_fixed_t const (*sbsample)[36][32];
  register mad_fixed_t (*fe)[8], (*fx)[8], (*fo)[8];
  register mad_fixed_t const (*Dptr)[32], *ptr;
  register mad_fixed64hi_t hi;
  register mad_fixed64lo_t lo;

  for (ch = 0; ch < nch; ++ch) {
    sbsample = &frame->sbsample[ch];
    filter = &synth->filter[ch];
    phase = synth->phase;
    pcm1 = synth->pcm.samples[ch];

    for (s = 0; s < ns; ++s) {
      dct32((*sbsample)[s], phase >> 1,
     (*filter)[0][phase & 1], (*filter)[1][phase & 1]);

      pe = phase & ~1;
      po = ((phase - 1) & 0xf) | 1;

      /* calculate 16 samples */

      fe = &(*filter)[0][ phase & 1][0];
      fx = &(*filter)[0][~phase & 1][0];
      fo = &(*filter)[1][~phase & 1][0];

      Dptr = &D[0];

      ptr = *Dptr + po;
      (((lo)) = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fx)[0])))), "rm" ((((ptr[ 0])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fx)[1])))), "rm" ((((ptr[14])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fx)[2])))), "rm" ((((ptr[12])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fx)[3])))), "rm" ((((ptr[10])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fx)[4])))), "rm" ((((ptr[ 8])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fx)[5])))), "rm" ((((ptr[ 6])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fx)[6])))), "rm" ((((ptr[ 4])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fx)[7])))), "rm" ((((ptr[ 2])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) = -((lo)));

      ptr = *Dptr + pe;
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[0])))), "rm" ((((ptr[ 0])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[1])))), "rm" ((((ptr[14])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[2])))), "rm" ((((ptr[12])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[3])))), "rm" ((((ptr[10])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[4])))), "rm" ((((ptr[ 8])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[5])))), "rm" ((((ptr[ 6])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[6])))), "rm" ((((ptr[ 4])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[7])))), "rm" ((((ptr[ 2])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));

      *pcm1++ = (((void) ((hi)), (mad_fixed_t) ((lo))));

      pcm2 = pcm1 + 14;

      for (sb = 1; sb < 16; ++sb) {
 ++fe;
 ++Dptr;

 /* D[32 - sb][i] == -D[sb][31 - i] */

 if (!(sb & 1)) {
   ptr = *Dptr + po;
   (((lo)) = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[0])))), "rm" ((((ptr[ 0])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[1])))), "rm" ((((ptr[14])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[2])))), "rm" ((((ptr[12])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[3])))), "rm" ((((ptr[10])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[4])))), "rm" ((((ptr[ 8])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[5])))), "rm" ((((ptr[ 6])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[6])))), "rm" ((((ptr[ 4])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[7])))), "rm" ((((ptr[ 2])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) = -((lo)));

   ptr = *Dptr + pe;
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[7])))), "rm" ((((ptr[ 2])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[6])))), "rm" ((((ptr[ 4])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[5])))), "rm" ((((ptr[ 6])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[4])))), "rm" ((((ptr[ 8])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[3])))), "rm" ((((ptr[10])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[2])))), "rm" ((((ptr[12])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[1])))), "rm" ((((ptr[14])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[0])))), "rm" ((((ptr[ 0])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));

   *pcm1++ = (((void) ((hi)), (mad_fixed_t) ((lo))));

   ptr = *Dptr - po;
   (((lo)) = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[7])))), "rm" ((((ptr[31 - 2])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[6])))), "rm" ((((ptr[31 - 4])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[5])))), "rm" ((((ptr[31 - 6])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[4])))), "rm" ((((ptr[31 - 8])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[3])))), "rm" ((((ptr[31 - 10])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[2])))), "rm" ((((ptr[31 - 12])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[1])))), "rm" ((((ptr[31 - 14])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[0])))), "rm" ((((ptr[31 - 16])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));

   ptr = *Dptr - pe;
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[0])))), "rm" ((((ptr[31 - 16])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[1])))), "rm" ((((ptr[31 - 14])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[2])))), "rm" ((((ptr[31 - 12])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[3])))), "rm" ((((ptr[31 - 10])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[4])))), "rm" ((((ptr[31 - 8])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[5])))), "rm" ((((ptr[31 - 6])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[6])))), "rm" ((((ptr[31 - 4])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
   (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fe)[7])))), "rm" ((((ptr[31 - 2])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));

   *pcm2-- = (((void) ((hi)), (mad_fixed_t) ((lo))));
 }

 ++fo;
      }

      ++Dptr;

      ptr = *Dptr + po;
      (((lo)) = ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[0])))), "rm" ((((ptr[ 0])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[1])))), "rm" ((((ptr[14])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[2])))), "rm" ((((ptr[12])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[3])))), "rm" ((((ptr[10])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[4])))), "rm" ((((ptr[ 8])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[5])))), "rm" ((((ptr[ 6])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[6])))), "rm" ((((ptr[ 4])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));
      (((lo)) += ({ register mad_fixed64hi_t __hi; register mad_fixed64lo_t __lo; asm ("imull %3" : "=a" (__lo), "=d" (__hi) : "%a" (((((*fo)[7])))), "rm" ((((ptr[ 2])))) : "cc"); ({ mad_fixed_t __result; asm ("shrdl %3,%2,%1" : "=rm" (__result) : "0" (__lo), "r" (__hi), "I" ((28 - 12)) : "cc"); __result; }); }));

      *pcm1 = (-((void) ((hi)), (mad_fixed_t) ((lo))));
      pcm1 += 8;

      phase = (phase + 1) % 16;
    }
  }
}

