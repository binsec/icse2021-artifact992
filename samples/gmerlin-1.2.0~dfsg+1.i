void * __builtin___memcpy_chk (void *, const void *, unsigned int, unsigned int);
unsigned int __builtin_object_size (const void *, int);

# 43 "/usr/include/stdint.h"
typedef long long int int64_t;

# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 43 "/usr/include/gavl/timecode.h"
typedef uint64_t gavl_timecode_t;

# 59 "/usr/include/gavl/timecode.h"
typedef struct
  {
  int int_framerate; //!< Integer framerate. A value of zero signals, that no timecodes are available.
  int flags; //!< Zero or more of the flags defined above
  } gavl_timecode_format_t;

# 64 "/usr/include/gavl/gavl.h"
typedef void (*gavl_video_process_func)(void * data, int start, int end);

# 79 "/usr/include/gavl/gavl.h"
typedef void (*gavl_video_run_func)(gavl_video_process_func func,
                                    void * gavl_data,
                                    int start, int end,
                                    void * client_data, int thread);

# 92 "/usr/include/gavl/gavl.h"
typedef void (*gavl_video_stop_func)(void * client_data, int thread);

# 102 "/usr/include/gavl/gavl.h"
typedef struct gavl_video_format_s gavl_video_format_t;

# 1675 "/usr/include/gavl/gavl.h"
typedef enum
  {
    /*! \brief Undefined 
     */
    GAVL_PIXELFORMAT_NONE = 0,

    /*! 8 bit gray, scaled 0x00..0xff
     */
    GAVL_GRAY_8 = 1 | (1<<13),

    /*! 16 bit gray, scaled 0x0000..0xffff
     */
    GAVL_GRAY_16 = 2 | (1<<13),

    /*! floating point gray, scaled 0.0..1.0
     */
    GAVL_GRAY_FLOAT = 3 | (1<<13),

    /*! 8 bit gray + alpha, scaled 0x00..0xff
     */
    GAVL_GRAYA_16 = 1 | (1<<13) | (1<<12),

    /*! 16 bit gray + alpha, scaled 0x0000..0xffff
     */
    GAVL_GRAYA_32 = 2 | (1<<13) | (1<<12),

    /*! floating point gray + alpha, scaled 0.0..1.0
     */
    GAVL_GRAYA_FLOAT = 3 | (1<<13) | (1<<12),

    /*! 15 bit RGB. Each pixel is a uint16_t in native byte order. Color masks are:
     * for red: 0x7C00, for green: 0x03e0, for blue: 0x001f
     */
    GAVL_RGB_15 = 1 | (1<<9),
    /*! 15 bit BGR. Each pixel is a uint16_t in native byte order. Color masks are:
     * for red: 0x001f, for green: 0x03e0, for blue: 0x7C00
     */
    GAVL_BGR_15 = 2 | (1<<9),
    /*! 16 bit RGB. Each pixel is a uint16_t in native byte order. Color masks are:
     * for red: 0xf800, for green: 0x07e0, for blue: 0x001f
     */
    GAVL_RGB_16 = 3 | (1<<9),
    /*! 16 bit BGR. Each pixel is a uint16_t in native byte order. Color masks are:
     * for red: 0x001f, for green: 0x07e0, for blue: 0xf800
     */
    GAVL_BGR_16 = 4 | (1<<9),
    /*! 24 bit RGB. Each color is an uint8_t. Color order is RGBRGB
     */
    GAVL_RGB_24 = 5 | (1<<9),
    /*! 24 bit BGR. Each color is an uint8_t. Color order is BGRBGR
     */
    GAVL_BGR_24 = 6 | (1<<9),
    /*! 32 bit RGB. Each color is an uint8_t. Color order is RGBXRGBX, where X is unused
     */
    GAVL_RGB_32 = 7 | (1<<9),
    /*! 32 bit BGR. Each color is an uint8_t. Color order is BGRXBGRX, where X is unused
     */
    GAVL_BGR_32 = 8 | (1<<9),
    /*! 32 bit RGBA. Each color is an uint8_t. Color order is RGBARGBA
     */
    GAVL_RGBA_32 = 9 | (1<<9) | (1<<12),

    /*! 48 bit RGB. Each color is an uint16_t in native byte order. Color order is RGBRGB
     */
    GAVL_RGB_48 = 10 | (1<<9),
    /*! 64 bit RGBA. Each color is an uint16_t in native byte order. Color order is RGBARGBA
     */
    GAVL_RGBA_64 = 11 | (1<<9) | (1<<12),

    /*! float RGB. Each color is a float (0.0 .. 1.0) in native byte order. Color order is RGBRGB
     */
    GAVL_RGB_FLOAT = 12 | (1<<9),
    /*! float RGBA. Each color is a float (0.0 .. 1.0) in native byte order. Color order is RGBARGBA
     */
    GAVL_RGBA_FLOAT = 13 | (1<<9) | (1<<12),

    /*! Packed YCbCr 4:2:2. Each component is an uint8_t. Component order is Y1 U1 Y2 V1
     */
    GAVL_YUY2 = 1 | (1<<10),
    /*! Packed YCbCr 4:2:2. Each component is an uint8_t. Component order is U1 Y1 V1 Y2
     */
    GAVL_UYVY = 2 | (1<<10),
    /*! Packed YCbCrA 4:4:4:4. Each component is an uint8_t. Component order is YUVA. Luma and chroma are video scaled, alpha is 0..255. */

    GAVL_YUVA_32 = 3 | (1<<10) | (1<<12),
    /*! Packed YCbCrA 4:4:4:4. Each component is an uint16_t. Component order is YUVA. Luma and chroma are video scaled, alpha is 0..65535. */

    GAVL_YUVA_64 = 4 | (1<<10) | (1<<12),
    /*!
     * Packed YCbCr 4:4:4. Each component is a float. Luma is scaled 0.0..1.0, chroma is -0.5..0.5 */
    GAVL_YUV_FLOAT = 5 | (1<<10),

    /*! Packed YCbCrA 4:4:4:4. Each component is a float. Luma is scaled 0.0..1.0, chroma is -0.5..0.5
     */
    GAVL_YUVA_FLOAT = 6 | (1<<10) | (1<<12),

    /*! Packed YCbCrA 4:4:4:4. Each component is an uint16_t. Component order is YUVA. Luma and chroma are video scaled, alpha is 0..65535.
     */

    GAVL_YUV_420_P = 1 | (1<<8) | (1<<10),
    /*! Planar YCbCr 4:2:2. Each component is an uint8_t
     */
    GAVL_YUV_422_P = 2 | (1<<8) | (1<<10),
    /*! Planar YCbCr 4:4:4. Each component is an uint8_t
     */
    GAVL_YUV_444_P = 3 | (1<<8) | (1<<10),
    /*! Planar YCbCr 4:1:1. Each component is an uint8_t
     */
    GAVL_YUV_411_P = 4 | (1<<8) | (1<<10),
    /*! Planar YCbCr 4:1:0. Each component is an uint8_t
     */
    GAVL_YUV_410_P = 5 | (1<<8) | (1<<10),

    /*! Planar YCbCr 4:2:0. Each component is an uint8_t, luma and chroma values are full range (0x00 .. 0xff)
     */
    GAVL_YUVJ_420_P = 6 | (1<<8) | (1<<10) | (1<<11),
    /*! Planar YCbCr 4:2:2. Each component is an uint8_t, luma and chroma values are full range (0x00 .. 0xff)
     */
    GAVL_YUVJ_422_P = 7 | (1<<8) | (1<<10) | (1<<11),
    /*! Planar YCbCr 4:4:4. Each component is an uint8_t, luma and chroma values are full range (0x00 .. 0xff)
     */
    GAVL_YUVJ_444_P = 8 | (1<<8) | (1<<10) | (1<<11),

    /*! 16 bit Planar YCbCr 4:4:4. Each component is an uint16_t in native byte order.
     */
    GAVL_YUV_444_P_16 = 9 | (1<<8) | (1<<10),
    /*! 16 bit Planar YCbCr 4:2:2. Each component is an uint16_t in native byte order.
     */
    GAVL_YUV_422_P_16 = 10 | (1<<8) | (1<<10),

  } gavl_pixelformat_t;

# 2047 "/usr/include/gavl/gavl.h"
typedef enum
  {
    GAVL_CHROMA_PLACEMENT_DEFAULT = 0, /*!< MPEG-1/JPEG */
    GAVL_CHROMA_PLACEMENT_MPEG2, /*!< MPEG-2 */
    GAVL_CHROMA_PLACEMENT_DVPAL /*!< DV PAL */
  } gavl_chroma_placement_t;

# 2069 "/usr/include/gavl/gavl.h"
typedef enum
  {
    GAVL_FRAMERATE_UNKNOWN = -1, /*!< Unknown (never use in public APIs) */
    GAVL_FRAMERATE_CONSTANT = 0, /*!< Constant framerate */
    GAVL_FRAMERATE_VARIABLE = 1, /*!< Variable framerate */
    GAVL_FRAMERATE_STILL = 2, /*!< Still image */
  } gavl_framerate_mode_t;

# 2092 "/usr/include/gavl/gavl.h"
typedef enum
  {
    GAVL_INTERLACE_UNKNOWN = -1,/*!< Unknown interlacing (never use in public APIs) */
    GAVL_INTERLACE_NONE = 0, /*!< Progressive */
    GAVL_INTERLACE_TOP_FIRST = 1, /*!< Top field first */
    GAVL_INTERLACE_BOTTOM_FIRST = 2, /*!< Bottom field first */
    GAVL_INTERLACE_MIXED = 3, /*!< Use interlace_mode of the frames */
    GAVL_INTERLACE_MIXED_TOP = 4, /*!< Progressive + top    */
    GAVL_INTERLACE_MIXED_BOTTOM = 5, /*!< Progressive + bottom */
  } gavl_interlace_mode_t;

# 2119 "/usr/include/gavl/gavl.h"
struct gavl_video_format_s
  {
  int frame_width;/*!< Width of the frame buffer in pixels, might be larger than image_width */
  int frame_height;/*!< Height of the frame buffer in pixels, might be larger than image_height */

  int image_width;/*!< Width of the image in pixels */
  int image_height;/*!< Height of the image in pixels */

  /* Support for nonsquare pixels */

  int pixel_width;/*!< Relative width of a pixel (pixel aspect ratio is pixel_width/pixel_height) */
  int pixel_height;/*!< Relative height of a pixel (pixel aspect ratio is pixel_width/pixel_height) */

  gavl_pixelformat_t pixelformat;/*!< Pixelformat */

  int frame_duration;/*!< Duration of a frame in timescale tics. Meaningful only if framerate_mode is
                       GAVL_FRAMERATE_CONSTANT */
  int timescale;/*!< Timescale in tics per second */

  gavl_framerate_mode_t framerate_mode;/*!< Framerate mode */
  gavl_chroma_placement_t chroma_placement;/*!< Chroma placement */

  gavl_interlace_mode_t interlace_mode;/*!< Interlace mode */

  gavl_timecode_format_t timecode_format;/*!< Optional timecode format */
  };

# 2284 "/usr/include/gavl/gavl.h"
typedef struct
  {
  uint8_t * planes[4 /*!< Maximum number of planes */]; /*!< Pointers to the planes */
  int strides[4 /*!< Maximum number of planes */]; /*!< For each plane, this stores the byte offset between the scanlines */

  void * user_data; /*!< For storing user data (e.g. the corresponding XImage) */
  int64_t timestamp; /*!< Timestamp in stream specific units (see \ref video_format) */
  int64_t duration; /*!< Duration in stream specific units (see \ref video_format) */
  gavl_interlace_mode_t interlace_mode;/*!< Interlace mode */
  gavl_timecode_t timecode; /*!< Timecode associated with this frame */
  } gavl_video_frame_t;

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 90 "../../include/gmerlin/plugin.h"
typedef int (*bg_read_video_func_t)(void * priv, gavl_video_frame_t* frame,
                                    int stream);

# 22 "./bgyadif.h"
typedef struct bg_yadif_s bg_yadif_t;

# 45 "/usr/include/gavl/gavldsp.h"
typedef struct gavl_dsp_context_s gavl_dsp_context_t;

# 53 "/usr/include/gavl/gavldsp.h"
typedef struct
  {
  /** \brief Get the sum of absolute differences (RGB/BGR15)
   *  \param src_1 Plane 1
   *  \param src_2 Plane 2
   *  \param stride_1 Byte distance between scanlines for src_1
   *  \param stride_2 Byte distance between scanlines for src_2
   *  \param w Width
   *  \param h Height
   *  \returns The sum of absolute differences
   *
   *  The RGB values will be scaled to 8 bit before the
   *  differences are calculated.
   */

  int (*sad_rgb15)(const uint8_t * src_1, const uint8_t * src_2,
                   int stride_1, int stride_2,
                   int w, int h);

  /** \brief Get the sum of absolute differences (RGB/BGR16)
   *  \param src_1 Plane 1
   *  \param src_2 Plane 2
   *  \param stride_1 Byte distance between scanlines for src_1
   *  \param stride_2 Byte distance between scanlines for src_2
   *  \param w Width
   *  \param h Height
   *  \returns The sum of absolute differences
   *
   *  The RGB values will be scaled to 8 bit before the
   *  differences are calculated.
   */

  int (*sad_rgb16)(const uint8_t * src_1, const uint8_t * src_2,
                   int stride_1, int stride_2,
                   int w, int h);

  /** \brief Get the sum of absolute differences (8 bit)
   *  \param src_1 Plane 1
   *  \param src_2 Plane 2
   *  \param stride_1 Byte distance between scanlines for src_1
   *  \param stride_2 Byte distance between scanlines for src_2
   *  \param w Width
   *  \param h Height
   *  \returns The sum of absolute differences
   */

  int (*sad_8)(const uint8_t * src_1, const uint8_t * src_2,
               int stride_1, int stride_2,
               int w, int h);

  /** \brief Get the sum of absolute differences (16 bit)
   *  \param src_1 Plane 1
   *  \param src_2 Plane 2
   *  \param stride_1 Byte distance between scanlines for src_1
   *  \param stride_2 Byte distance between scanlines for src_2
   *  \param w Width
   *  \param h Height
   *  \returns The sum of absolute differences
   */

  int (*sad_16)(const uint8_t * src_1, const uint8_t * src_2,
               int stride_1, int stride_2,
               int w, int h);

  /** \brief Get the sum of absolute differences (float)
   *  \param src_1 Plane 1
   *  \param src_2 Plane 2
   *  \param stride_1 Byte distance between scanlines for src_1
   *  \param stride_2 Byte distance between scanlines for src_2
   *  \param w Width
   *  \param h Height
   *  \returns The sum of absolute differences
   */
  float (*sad_f)(const uint8_t * src_1, const uint8_t * src_2,
                 int stride_1, int stride_2,
                 int w, int h);

  /** \brief Average 2 scanlines (RGB/BGR15)
   *  \param src_1 Scanline 1
   *  \param src_2 Scanline 2
   *  \param dst Destination
   *  \param num Number of pixels
   */

  void (*average_rgb15)(const uint8_t * src_1, const uint8_t * src_2,
                        uint8_t * dst, int num);

  /** \brief Average 2 scanlines (RGB/BGR16)
   *  \param src_1 Scanline 1
   *  \param src_2 Scanline 2
   *  \param dst Destination
   *  \param num Number of pixels
   */
  void (*average_rgb16)(const uint8_t * src_1, const uint8_t * src_2,
                        uint8_t * dst, int num);

  /** \brief Average 2 scanlines (8 bit)
   *  \param src_1 Scanline 1
   *  \param src_2 Scanline 2
   *  \param dst Destination
   *  \param num Number of bytes
   */
  void (*average_8)(const uint8_t * src_1, const uint8_t * src_2,
                    uint8_t * dst, int num);

  /** \brief Average 2 scanlines (16 bit)
   *  \param src_1 Scanline 1
   *  \param src_2 Scanline 2
   *  \param dst Destination
   *  \param num Number of shorts
   */
  void (*average_16)(const uint8_t * src_1, const uint8_t * src_2,
                     uint8_t * dst, int num);

  /** \brief Average 2 scanlines (float)
   *  \param src_1 Scanline 1
   *  \param src_2 Scanline 2
   *  \param dst Destination
   *  \param num Number of floats
   */

  void (*average_f)(const uint8_t * src_1, const uint8_t * src_2,
                    uint8_t * dst, int num);


  /** \brief Interpolate 2 scanlines (RGB/BGR15)
   *  \param src_1 Scanline 1
   *  \param src_2 Scanline 2
   *  \param dst Destination
   *  \param num Number of pixels
   *  \param fac Factor for src_1 (0.0 .. 1.0)
   *
   *  Sets the destination to src_1 * fac + src_2 * (1.0-fac)
   */

  void (*interpolate_rgb15)(const uint8_t * src_1, const uint8_t * src_2,
                            uint8_t * dst, int num, float);

  /** \brief Interpolate 2 scanlines (RGB/BGR16)
   *  \param src_1 Scanline 1
   *  \param src_2 Scanline 2
   *  \param dst Destination
   *  \param num Number of pixels
   *  \param fac Factor for src_1 (0.0 .. 1.0)
   *
   *  Sets the destination to src_1 * fac + src_2 * (1.0-fac)
   */
  void (*interpolate_rgb16)(const uint8_t * src_1, const uint8_t * src_2,
                            uint8_t * dst, int num, float fac);

  /** \brief Interpolate 2 scanlines (8 bit)
   *  \param src_1 Scanline 1
   *  \param src_2 Scanline 2
   *  \param dst Destination
   *  \param num Number of bytes
   *  \param fac Factor for src_1 (0.0 .. 1.0)
   *
   *  Sets the destination to src_1 * fac + src_2 * (1.0-fac)
   */
  void (*interpolate_8)(const uint8_t * src_1, const uint8_t * src_2,
                        uint8_t * dst, int num, float fac);

  /** \brief Interpolate 2 scanlines (16 bit)
   *  \param src_1 Scanline 1
   *  \param src_2 Scanline 2
   *  \param dst Destination
   *  \param num Number of shorts
   *  \param fac Factor for src_1 (0.0 .. 1.0)
   *
   *  Sets the destination to src_1 * fac + src_2 * (1.0-fac)
   */
  void (*interpolate_16)(const uint8_t * src_1, const uint8_t * src_2,
                         uint8_t * dst, int num, float fac);

  /** \brief Interpolate 2 scanlines (float)
   *  \param src_1 Scanline 1
   *  \param src_2 Scanline 2
   *  \param dst Destination
   *  \param num Number of floats
   *  \param fac Factor for src_1 (0.0 .. 1.0)
   *
   *  Sets the destination to src_1 * fac + src_2 * (1.0-fac)
   */

  void (*interpolate_f)(const uint8_t * src_1, const uint8_t * src_2,
                        uint8_t * dst, int num, float fac);

  /** \brief Do 16 bit endian swapping
   * \param ptr Pointer to the data
   * \param len Len in 16 bit words
   */
  void (*bswap_16)(void * ptr, int len);

  /** \brief Do 32 byte endian swapping
   * \param ptr Pointer to the data
   * \param len Len in 32 bit doublewords
   */
  void (*bswap_32)(void * ptr, int len);

  /** \brief Do 64 byte endian swapping
   * \param ptr Pointer to the data
   * \param len Len in 64 bit quadwords
   */
  void (*bswap_64)(void * ptr, int len);

  /** \brief Add 2 uint8_t vectors
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */

  void (*add_u8)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Add 2 uint8_t vectors (for audio stored as unsigned)
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */
  void (*add_u8_s)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Add 2 int8_t vectors
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */
  void (*add_s8)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Add 2 uint16_t vectors
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */
  void (*add_u16)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Add 2 uint16_t vectors (for audio stored as unsigned)
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */
  void (*add_u16_s)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Add 2 int16_t vectors
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */
  void (*add_s16)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Add 2 int32_t vectors
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */
  void (*add_s32)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Add 2 float vectors
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */
  void (*add_float)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Add 2 float vectors
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */
  void (*add_double)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Subtract 2 uint8_t vectors
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */

  void (*sub_u8)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Subtract 2 uint8_t vectors (for audio stored as unsigned)
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */
  void (*sub_u8_s)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Subtract 2 int8_t vectors
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */
  void (*sub_s8)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Subtract 2 uint16_t vectors
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */
  void (*sub_u16)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Subtract 2 uint16_t vectors (for audio stored as unsigned)
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */
  void (*sub_u16_s)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Subtract 2 int16_t vectors
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */
  void (*sub_s16)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Subtract 2 int32_t vectors
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */
  void (*sub_s32)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Subtract 2 float vectors
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */
  void (*sub_float)(const void * src1, const void * src2, void * dst, int num);

  /** \brief Subtract 2 float vectors
   *  \param src1 Source 1
   *  \param src2 Source 2
   *  \param dst  Destination
   *  \param num  Number of entries
   *
   *  src1 and/or src2 can be identical to dst
   */
  void (*sub_double)(const void * src1, const void * src2, void * dst, int num);


  } gavl_dsp_funcs_t;

# 47 "/usr/include/i386-linux-gnu/bits/string3.h"
extern __inline void *
 memcpy (void *__restrict __dest, const void *__restrict __src, size_t __len)

{
  return __builtin___memcpy_chk (__dest, __src, __len, __builtin_object_size (__dest, 0));
}

# 42 "bgyadif.c"
typedef struct
  {
  int w;
  int h;
  int plane;
  int offset;
  int advance;
  } component_t;

# 51 "bgyadif.c"
struct bg_yadif_s
  {
  gavl_dsp_context_t * dsp_ctx;
  gavl_dsp_funcs_t * dsp_funcs;

  int parity;
  int accel_flags;

  /* Where to get data */
  bg_read_video_func_t read_func;
  void * read_data;
  int read_stream;

  gavl_video_format_t in_format;
  gavl_video_format_t out_format;

  void (*filter_line)(int mode, uint8_t *dst, const uint8_t *prev,
                      const uint8_t *cur, const uint8_t *next,
                      int w, int src_stride, int parity, int advance);

  component_t components[4];
  component_t * comp;
  int current_parity;
  int tff;

  int num_components;

  gavl_video_frame_t * cur;
  gavl_video_frame_t * prev;
  gavl_video_frame_t * next;

  gavl_video_frame_t * dst;

  int64_t frame;
  int64_t field;
  int eof;

  int mode;

  int luma_shift;
  int chroma_shift;

  int mmx;


  /* Multithreading stuff */

  gavl_video_run_func run_func;
  void * run_data;
  gavl_video_stop_func stop_func;
  void * stop_data;
  int num_threads;
  };

# 301 "bgyadif.c"
static void filter_plane(void * priv, int start, int end)
  {
  int y;

  uint8_t *dst;
  int dst_stride;
  const uint8_t *prev0;
  const uint8_t *cur0;
  const uint8_t *next0;
  int src_stride;
  int w;
  bg_yadif_t * di = priv;
  dst_stride = di->dst->strides[di->comp->plane];
  src_stride = di->prev->strides[di->comp->plane];

  dst = di->dst->planes[di->comp->plane] + di->comp->offset;
  prev0 = di->prev->planes[di->comp->plane] + di->comp->offset;
  cur0 = di->cur->planes[di->comp->plane] + di->comp->offset;
  next0 = di->next->planes[di->comp->plane] + di->comp->offset;

  w = di->comp->w;

  for(y=start; y<end; y++)
    {
    if(((y ^ di->current_parity) & 1))
      {
      const uint8_t *prev= prev0 + y*src_stride;
      const uint8_t *cur = cur0 + y*src_stride;
      const uint8_t *next= next0 + y*src_stride;
      uint8_t *dst2= dst + y*dst_stride;
      di->filter_line(di->mode, dst2, prev, cur, next, w, src_stride, (di->current_parity ^ di->tff),
                      di->comp->advance);
      }
    else
      {
      memcpy(dst + y*dst_stride, cur0 + y*src_stride, w); // copy original
      }
    }


  if (di->mmx)
    asm volatile("emms");

  }

# 633 "bgyadif.c"
static void filter_line_mmx2(int mode, uint8_t *dst, const uint8_t *prev, const uint8_t *cur, const uint8_t *next, int w, int refs, int parity, int advance){
    static const uint64_t pw_1 = 0x0001000100010001ULL;
    static const uint64_t pb_1 = 0x0101010101010101ULL;
//    const int mode = p->mode;
    uint64_t tmp0, tmp1, tmp2, tmp3;
    int x;
# 766 "bgyadif.c"
    if(parity){


        for(x=0; x<w; x+=4){ asm volatile( "pxor      %%mm7, %%mm7 \n\t" "movd      ""(%[cur],%[mrefs])"", ""%%mm0"" \n\t" "punpcklbw %%mm7, ""%%mm0"" \n\t" /* c = cur[x-refs] */ "movd      ""(%[cur],%[prefs])"", ""%%mm1"" \n\t" "punpcklbw %%mm7, ""%%mm1"" \n\t" /* e = cur[x+refs] */ "movd      ""(%[""prev""])"", ""%%mm2"" \n\t" "punpcklbw %%mm7, ""%%mm2"" \n\t" /* prev2[x] */ "movd      ""(%[""cur""])"", ""%%mm3"" \n\t" "punpcklbw %%mm7, ""%%mm3"" \n\t" /* next2[x] */ "movq      %%mm3, %%mm4 \n\t" "paddw     %%mm2, %%mm3 \n\t" "psraw     $1,    %%mm3 \n\t" /* d = (prev2[x] + next2[x])>>1 */ "movq      %%mm0, %[tmp0] \n\t" /* c */ "movq      %%mm3, %[tmp1] \n\t" /* d */ "movq      %%mm1, %[tmp2] \n\t" /* e */ "psubw     %%mm4, %%mm2 \n\t" "pxor     ""%%mm4"", ""%%mm4"" \n\t" "psubw    ""%%mm2"", ""%%mm4"" \n\t" "pmaxsw   ""%%mm4"", ""%%mm2"" \n\t" /* temporal_diff0 */ "movd      ""(%[prev],%[mrefs])"", ""%%mm3"" \n\t" "punpcklbw %%mm7, ""%%mm3"" \n\t" /* prev[x-refs] */ "movd      ""(%[prev],%[prefs])"", ""%%mm4"" \n\t" "punpcklbw %%mm7, ""%%mm4"" \n\t" /* prev[x+refs] */ "psubw     %%mm0, %%mm3 \n\t" "psubw     %%mm1, %%mm4 \n\t" "pxor     ""%%mm5"", ""%%mm5"" \n\t" "psubw    ""%%mm3"", ""%%mm5"" \n\t" "pmaxsw   ""%%mm5"", ""%%mm3"" \n\t" "pxor     ""%%mm5"", ""%%mm5"" \n\t" "psubw    ""%%mm4"", ""%%mm5"" \n\t" "pmaxsw   ""%%mm5"", ""%%mm4"" \n\t" "paddw     %%mm4, %%mm3 \n\t" /* temporal_diff1 */ "psrlw     $1,    %%mm2 \n\t" "psrlw     $1,    %%mm3 \n\t" "pmaxsw    %%mm3, %%mm2 \n\t" "movd      ""(%[next],%[mrefs])"", ""%%mm3"" \n\t" "punpcklbw %%mm7, ""%%mm3"" \n\t" /* next[x-refs] */ "movd      ""(%[next],%[prefs])"", ""%%mm4"" \n\t" "punpcklbw %%mm7, ""%%mm4"" \n\t" /* next[x+refs] */ "psubw     %%mm0, %%mm3 \n\t" "psubw     %%mm1, %%mm4 \n\t" "pxor     ""%%mm5"", ""%%mm5"" \n\t" "psubw    ""%%mm3"", ""%%mm5"" \n\t" "pmaxsw   ""%%mm5"", ""%%mm3"" \n\t" "pxor     ""%%mm5"", ""%%mm5"" \n\t" "psubw    ""%%mm4"", ""%%mm5"" \n\t" "pmaxsw   ""%%mm5"", ""%%mm4"" \n\t" "paddw     %%mm4, %%mm3 \n\t" /* temporal_diff2 */ "psrlw     $1,    %%mm3 \n\t" "pmaxsw    %%mm3, %%mm2 \n\t" "movq      %%mm2, %[tmp3] \n\t" /* diff */ "paddw     %%mm0, %%mm1 \n\t" "paddw     %%mm0, %%mm0 \n\t" "psubw     %%mm1, %%mm0 \n\t" "psrlw     $1,    %%mm1 \n\t" /* spatial_pred */ "pxor     ""%%mm2"", ""%%mm2"" \n\t" "psubw    ""%%mm0"", ""%%mm2"" \n\t" "pmaxsw   ""%%mm2"", ""%%mm0"" \n\t" /* ABS(c-e) */ "movq -1(%[cur],%[mrefs]), %%mm2 \n\t" /* cur[x-refs-1] */ "movq -1(%[cur],%[prefs]), %%mm3 \n\t" /* cur[x+refs-1] */ "movq      %%mm2, %%mm4 \n\t" "psubusb   %%mm3, %%mm2 \n\t" "psubusb   %%mm4, %%mm3 \n\t" "pmaxub    %%mm3, %%mm2 \n\t" "pshufw $9,%%mm2, %%mm3 \n\t" "punpcklbw %%mm7, %%mm2 \n\t" /* ABS(cur[x-refs-1] - cur[x+refs-1]) */ "punpcklbw %%mm7, %%mm3 \n\t" /* ABS(cur[x-refs+1] - cur[x+refs+1]) */ "paddw     %%mm2, %%mm0 \n\t" "paddw     %%mm3, %%mm0 \n\t" "psubw    %[pw1], %%mm0 \n\t" /* spatial_score */ "movq ""-2""(%[cur],%[mrefs]), %%mm2 \n\t" /* cur[x-refs-1+j] */ "movq ""0""(%[cur],%[prefs]), %%mm3 \n\t" /* cur[x+refs-1-j] */ "movq      %%mm2, %%mm4 \n\t" "movq      %%mm2, %%mm5 \n\t" "pxor      %%mm3, %%mm4 \n\t" "pavgb     %%mm3, %%mm5 \n\t" "pand     %[pb1], %%mm4 \n\t" "psubusb   %%mm4, %%mm5 \n\t" "psrlq     $8,    %%mm5 \n\t" "punpcklbw %%mm7, %%mm5 \n\t" /* (cur[x-refs+j] + cur[x+refs-j])>>1 */ "movq      %%mm2, %%mm4 \n\t" "psubusb   %%mm3, %%mm2 \n\t" "psubusb   %%mm4, %%mm3 \n\t" "pmaxub    %%mm3, %%mm2 \n\t" "movq      %%mm2, %%mm3 \n\t" "movq      %%mm2, %%mm4 \n\t" /* ABS(cur[x-refs-1+j] - cur[x+refs-1-j]) */ "psrlq      $8,   %%mm3 \n\t" /* ABS(cur[x-refs  +j] - cur[x+refs  -j]) */ "psrlq     $16,   %%mm4 \n\t" /* ABS(cur[x-refs+1+j] - cur[x+refs+1-j]) */ "punpcklbw %%mm7, %%mm2 \n\t" "punpcklbw %%mm7, %%mm3 \n\t" "punpcklbw %%mm7, %%mm4 \n\t" "paddw     %%mm3, %%mm2 \n\t" "paddw     %%mm4, %%mm2 \n\t" /* score */ "movq      %%mm0, %%mm3 \n\t" "pcmpgtw   %%mm2, %%mm3 \n\t" /* if(score < spatial_score) */ "pminsw    %%mm2, %%mm0 \n\t" /* spatial_score= score; */ "movq      %%mm3, %%mm6 \n\t" "pand      %%mm3, %%mm5 \n\t" "pandn     %%mm1, %%mm3 \n\t" "por       %%mm5, %%mm3 \n\t" "movq      %%mm3, %%mm1 \n\t" /* spatial_pred= (cur[x-refs+j] + cur[x+refs-j])>>1; */ "movq ""-3""(%[cur],%[mrefs]), %%mm2 \n\t" /* cur[x-refs-1+j] */ "movq ""1""(%[cur],%[prefs]), %%mm3 \n\t" /* cur[x+refs-1-j] */ "movq      %%mm2, %%mm4 \n\t" "movq      %%mm2, %%mm5 \n\t" "pxor      %%mm3, %%mm4 \n\t" "pavgb     %%mm3, %%mm5 \n\t" "pand     %[pb1], %%mm4 \n\t" "psubusb   %%mm4, %%mm5 \n\t" "psrlq     $8,    %%mm5 \n\t" "punpcklbw %%mm7, %%mm5 \n\t" /* (cur[x-refs+j] + cur[x+refs-j])>>1 */ "movq      %%mm2, %%mm4 \n\t" "psubusb   %%mm3, %%mm2 \n\t" "psubusb   %%mm4, %%mm3 \n\t" "pmaxub    %%mm3, %%mm2 \n\t" "movq      %%mm2, %%mm3 \n\t" "movq      %%mm2, %%mm4 \n\t" /* ABS(cur[x-refs-1+j] - cur[x+refs-1-j]) */ "psrlq      $8,   %%mm3 \n\t" /* ABS(cur[x-refs  +j] - cur[x+refs  -j]) */ "psrlq     $16,   %%mm4 \n\t" /* ABS(cur[x-refs+1+j] - cur[x+refs+1-j]) */ "punpcklbw %%mm7, %%mm2 \n\t" "punpcklbw %%mm7, %%mm3 \n\t" "punpcklbw %%mm7, %%mm4 \n\t" "paddw     %%mm3, %%mm2 \n\t" "paddw     %%mm4, %%mm2 \n\t" /* score */ /* pretend not to have checked dir=2 if dir=1 was bad.                  hurts both quality and speed, but matches the C version. */ "paddw    %[pw1], %%mm6 \n\t" "psllw     $14,   %%mm6 \n\t" "paddsw    %%mm6, %%mm2 \n\t" "movq      %%mm0, %%mm3 \n\t" "pcmpgtw   %%mm2, %%mm3 \n\t" "pminsw    %%mm2, %%mm0 \n\t" "pand      %%mm3, %%mm5 \n\t" "pandn     %%mm1, %%mm3 \n\t" "por       %%mm5, %%mm3 \n\t" "movq      %%mm3, %%mm1 \n\t" "movq ""0""(%[cur],%[mrefs]), %%mm2 \n\t" /* cur[x-refs-1+j] */ "movq ""-2""(%[cur],%[prefs]), %%mm3 \n\t" /* cur[x+refs-1-j] */ "movq      %%mm2, %%mm4 \n\t" "movq      %%mm2, %%mm5 \n\t" "pxor      %%mm3, %%mm4 \n\t" "pavgb     %%mm3, %%mm5 \n\t" "pand     %[pb1], %%mm4 \n\t" "psubusb   %%mm4, %%mm5 \n\t" "psrlq     $8,    %%mm5 \n\t" "punpcklbw %%mm7, %%mm5 \n\t" /* (cur[x-refs+j] + cur[x+refs-j])>>1 */ "movq      %%mm2, %%mm4 \n\t" "psubusb   %%mm3, %%mm2 \n\t" "psubusb   %%mm4, %%mm3 \n\t" "pmaxub    %%mm3, %%mm2 \n\t" "movq      %%mm2, %%mm3 \n\t" "movq      %%mm2, %%mm4 \n\t" /* ABS(cur[x-refs-1+j] - cur[x+refs-1-j]) */ "psrlq      $8,   %%mm3 \n\t" /* ABS(cur[x-refs  +j] - cur[x+refs  -j]) */ "psrlq     $16,   %%mm4 \n\t" /* ABS(cur[x-refs+1+j] - cur[x+refs+1-j]) */ "punpcklbw %%mm7, %%mm2 \n\t" "punpcklbw %%mm7, %%mm3 \n\t" "punpcklbw %%mm7, %%mm4 \n\t" "paddw     %%mm3, %%mm2 \n\t" "paddw     %%mm4, %%mm2 \n\t" /* score */ "movq      %%mm0, %%mm3 \n\t" "pcmpgtw   %%mm2, %%mm3 \n\t" /* if(score < spatial_score) */ "pminsw    %%mm2, %%mm0 \n\t" /* spatial_score= score; */ "movq      %%mm3, %%mm6 \n\t" "pand      %%mm3, %%mm5 \n\t" "pandn     %%mm1, %%mm3 \n\t" "por       %%mm5, %%mm3 \n\t" "movq      %%mm3, %%mm1 \n\t" /* spatial_pred= (cur[x-refs+j] + cur[x+refs-j])>>1; */ "movq ""1""(%[cur],%[mrefs]), %%mm2 \n\t" /* cur[x-refs-1+j] */ "movq ""-3""(%[cur],%[prefs]), %%mm3 \n\t" /* cur[x+refs-1-j] */ "movq      %%mm2, %%mm4 \n\t" "movq      %%mm2, %%mm5 \n\t" "pxor      %%mm3, %%mm4 \n\t" "pavgb     %%mm3, %%mm5 \n\t" "pand     %[pb1], %%mm4 \n\t" "psubusb   %%mm4, %%mm5 \n\t" "psrlq     $8,    %%mm5 \n\t" "punpcklbw %%mm7, %%mm5 \n\t" /* (cur[x-refs+j] + cur[x+refs-j])>>1 */ "movq      %%mm2, %%mm4 \n\t" "psubusb   %%mm3, %%mm2 \n\t" "psubusb   %%mm4, %%mm3 \n\t" "pmaxub    %%mm3, %%mm2 \n\t" "movq      %%mm2, %%mm3 \n\t" "movq      %%mm2, %%mm4 \n\t" /* ABS(cur[x-refs-1+j] - cur[x+refs-1-j]) */ "psrlq      $8,   %%mm3 \n\t" /* ABS(cur[x-refs  +j] - cur[x+refs  -j]) */ "psrlq     $16,   %%mm4 \n\t" /* ABS(cur[x-refs+1+j] - cur[x+refs+1-j]) */ "punpcklbw %%mm7, %%mm2 \n\t" "punpcklbw %%mm7, %%mm3 \n\t" "punpcklbw %%mm7, %%mm4 \n\t" "paddw     %%mm3, %%mm2 \n\t" "paddw     %%mm4, %%mm2 \n\t" /* score */ /* pretend not to have checked dir=2 if dir=1 was bad.                  hurts both quality and speed, but matches the C version. */ "paddw    %[pw1], %%mm6 \n\t" "psllw     $14,   %%mm6 \n\t" "paddsw    %%mm6, %%mm2 \n\t" "movq      %%mm0, %%mm3 \n\t" "pcmpgtw   %%mm2, %%mm3 \n\t" "pminsw    %%mm2, %%mm0 \n\t" "pand      %%mm3, %%mm5 \n\t" "pandn     %%mm1, %%mm3 \n\t" "por       %%mm5, %%mm3 \n\t" "movq      %%mm3, %%mm1 \n\t" /* if(p->mode<2) ... */ "movq    %[tmp3], %%mm6 \n\t" /* diff */ "cmp       $2, %[mode] \n\t" "jge       1f \n\t" "movd      ""(%[""prev""],%[mrefs],2)"", ""%%mm2"" \n\t" "punpcklbw %%mm7, ""%%mm2"" \n\t" /* prev2[x-2*refs] */ "movd      ""(%[""cur""],%[mrefs],2)"", ""%%mm4"" \n\t" "punpcklbw %%mm7, ""%%mm4"" \n\t" /* next2[x-2*refs] */ "movd      ""(%[""prev""],%[prefs],2)"", ""%%mm3"" \n\t" "punpcklbw %%mm7, ""%%mm3"" \n\t" /* prev2[x+2*refs] */ "movd      ""(%[""cur""],%[prefs],2)"", ""%%mm5"" \n\t" "punpcklbw %%mm7, ""%%mm5"" \n\t" /* next2[x+2*refs] */ "paddw     %%mm4, %%mm2 \n\t" "paddw     %%mm5, %%mm3 \n\t" "psrlw     $1,    %%mm2 \n\t" /* b */ "psrlw     $1,    %%mm3 \n\t" /* f */ "movq    %[tmp0], %%mm4 \n\t" /* c */ "movq    %[tmp1], %%mm5 \n\t" /* d */ "movq    %[tmp2], %%mm7 \n\t" /* e */ "psubw     %%mm4, %%mm2 \n\t" /* b-c */ "psubw     %%mm7, %%mm3 \n\t" /* f-e */ "movq      %%mm5, %%mm0 \n\t" "psubw     %%mm4, %%mm5 \n\t" /* d-c */ "psubw     %%mm7, %%mm0 \n\t" /* d-e */ "movq      %%mm2, %%mm4 \n\t" "pminsw    %%mm3, %%mm2 \n\t" "pmaxsw    %%mm4, %%mm3 \n\t" "pmaxsw    %%mm5, %%mm2 \n\t" "pminsw    %%mm5, %%mm3 \n\t" "pmaxsw    %%mm0, %%mm2 \n\t" /* max */ "pminsw    %%mm0, %%mm3 \n\t" /* min */ "pxor      %%mm4, %%mm4 \n\t" "pmaxsw    %%mm3, %%mm6 \n\t" "psubw     %%mm2, %%mm4 \n\t" /* -max */ "pmaxsw    %%mm4, %%mm6 \n\t" /* diff= MAX3(diff, min, -max); */ "1: \n\t" "movq    %[tmp1], %%mm2 \n\t" /* d */ "movq      %%mm2, %%mm3 \n\t" "psubw     %%mm6, %%mm2 \n\t" /* d-diff */ "paddw     %%mm6, %%mm3 \n\t" /* d+diff */ "pmaxsw    %%mm2, %%mm1 \n\t" "pminsw    %%mm3, %%mm1 \n\t" /* d = clip(spatial_pred, d-diff, d+diff); */ "packuswb  %%mm1, %%mm1 \n\t" :[tmp0]"=m"(tmp0), [tmp1]"=m"(tmp1), [tmp2]"=m"(tmp2), [tmp3]"=m"(tmp3) :[prev] "r"(prev), [cur] "r"(cur), [next] "r"(next), [prefs]"r"((long)refs), [mrefs]"r"((long)-refs), [pw1] "m"(pw_1), [pb1] "m"(pb_1), [mode] "g"(mode) ); asm volatile("movd %%mm1, %0" :"=m"(*dst)); dst += 4; prev+= 4; cur += 4; next+= 4; }


    }else{


        for(x=0; x<w; x+=4){ asm volatile( "pxor      %%mm7, %%mm7 \n\t" "movd      ""(%[cur],%[mrefs])"", ""%%mm0"" \n\t" "punpcklbw %%mm7, ""%%mm0"" \n\t" /* c = cur[x-refs] */ "movd      ""(%[cur],%[prefs])"", ""%%mm1"" \n\t" "punpcklbw %%mm7, ""%%mm1"" \n\t" /* e = cur[x+refs] */ "movd      ""(%[""cur""])"", ""%%mm2"" \n\t" "punpcklbw %%mm7, ""%%mm2"" \n\t" /* prev2[x] */ "movd      ""(%[""next""])"", ""%%mm3"" \n\t" "punpcklbw %%mm7, ""%%mm3"" \n\t" /* next2[x] */ "movq      %%mm3, %%mm4 \n\t" "paddw     %%mm2, %%mm3 \n\t" "psraw     $1,    %%mm3 \n\t" /* d = (prev2[x] + next2[x])>>1 */ "movq      %%mm0, %[tmp0] \n\t" /* c */ "movq      %%mm3, %[tmp1] \n\t" /* d */ "movq      %%mm1, %[tmp2] \n\t" /* e */ "psubw     %%mm4, %%mm2 \n\t" "pxor     ""%%mm4"", ""%%mm4"" \n\t" "psubw    ""%%mm2"", ""%%mm4"" \n\t" "pmaxsw   ""%%mm4"", ""%%mm2"" \n\t" /* temporal_diff0 */ "movd      ""(%[prev],%[mrefs])"", ""%%mm3"" \n\t" "punpcklbw %%mm7, ""%%mm3"" \n\t" /* prev[x-refs] */ "movd      ""(%[prev],%[prefs])"", ""%%mm4"" \n\t" "punpcklbw %%mm7, ""%%mm4"" \n\t" /* prev[x+refs] */ "psubw     %%mm0, %%mm3 \n\t" "psubw     %%mm1, %%mm4 \n\t" "pxor     ""%%mm5"", ""%%mm5"" \n\t" "psubw    ""%%mm3"", ""%%mm5"" \n\t" "pmaxsw   ""%%mm5"", ""%%mm3"" \n\t" "pxor     ""%%mm5"", ""%%mm5"" \n\t" "psubw    ""%%mm4"", ""%%mm5"" \n\t" "pmaxsw   ""%%mm5"", ""%%mm4"" \n\t" "paddw     %%mm4, %%mm3 \n\t" /* temporal_diff1 */ "psrlw     $1,    %%mm2 \n\t" "psrlw     $1,    %%mm3 \n\t" "pmaxsw    %%mm3, %%mm2 \n\t" "movd      ""(%[next],%[mrefs])"", ""%%mm3"" \n\t" "punpcklbw %%mm7, ""%%mm3"" \n\t" /* next[x-refs] */ "movd      ""(%[next],%[prefs])"", ""%%mm4"" \n\t" "punpcklbw %%mm7, ""%%mm4"" \n\t" /* next[x+refs] */ "psubw     %%mm0, %%mm3 \n\t" "psubw     %%mm1, %%mm4 \n\t" "pxor     ""%%mm5"", ""%%mm5"" \n\t" "psubw    ""%%mm3"", ""%%mm5"" \n\t" "pmaxsw   ""%%mm5"", ""%%mm3"" \n\t" "pxor     ""%%mm5"", ""%%mm5"" \n\t" "psubw    ""%%mm4"", ""%%mm5"" \n\t" "pmaxsw   ""%%mm5"", ""%%mm4"" \n\t" "paddw     %%mm4, %%mm3 \n\t" /* temporal_diff2 */ "psrlw     $1,    %%mm3 \n\t" "pmaxsw    %%mm3, %%mm2 \n\t" "movq      %%mm2, %[tmp3] \n\t" /* diff */ "paddw     %%mm0, %%mm1 \n\t" "paddw     %%mm0, %%mm0 \n\t" "psubw     %%mm1, %%mm0 \n\t" "psrlw     $1,    %%mm1 \n\t" /* spatial_pred */ "pxor     ""%%mm2"", ""%%mm2"" \n\t" "psubw    ""%%mm0"", ""%%mm2"" \n\t" "pmaxsw   ""%%mm2"", ""%%mm0"" \n\t" /* ABS(c-e) */ "movq -1(%[cur],%[mrefs]), %%mm2 \n\t" /* cur[x-refs-1] */ "movq -1(%[cur],%[prefs]), %%mm3 \n\t" /* cur[x+refs-1] */ "movq      %%mm2, %%mm4 \n\t" "psubusb   %%mm3, %%mm2 \n\t" "psubusb   %%mm4, %%mm3 \n\t" "pmaxub    %%mm3, %%mm2 \n\t" "pshufw $9,%%mm2, %%mm3 \n\t" "punpcklbw %%mm7, %%mm2 \n\t" /* ABS(cur[x-refs-1] - cur[x+refs-1]) */ "punpcklbw %%mm7, %%mm3 \n\t" /* ABS(cur[x-refs+1] - cur[x+refs+1]) */ "paddw     %%mm2, %%mm0 \n\t" "paddw     %%mm3, %%mm0 \n\t" "psubw    %[pw1], %%mm0 \n\t" /* spatial_score */ "movq ""-2""(%[cur],%[mrefs]), %%mm2 \n\t" /* cur[x-refs-1+j] */ "movq ""0""(%[cur],%[prefs]), %%mm3 \n\t" /* cur[x+refs-1-j] */ "movq      %%mm2, %%mm4 \n\t" "movq      %%mm2, %%mm5 \n\t" "pxor      %%mm3, %%mm4 \n\t" "pavgb     %%mm3, %%mm5 \n\t" "pand     %[pb1], %%mm4 \n\t" "psubusb   %%mm4, %%mm5 \n\t" "psrlq     $8,    %%mm5 \n\t" "punpcklbw %%mm7, %%mm5 \n\t" /* (cur[x-refs+j] + cur[x+refs-j])>>1 */ "movq      %%mm2, %%mm4 \n\t" "psubusb   %%mm3, %%mm2 \n\t" "psubusb   %%mm4, %%mm3 \n\t" "pmaxub    %%mm3, %%mm2 \n\t" "movq      %%mm2, %%mm3 \n\t" "movq      %%mm2, %%mm4 \n\t" /* ABS(cur[x-refs-1+j] - cur[x+refs-1-j]) */ "psrlq      $8,   %%mm3 \n\t" /* ABS(cur[x-refs  +j] - cur[x+refs  -j]) */ "psrlq     $16,   %%mm4 \n\t" /* ABS(cur[x-refs+1+j] - cur[x+refs+1-j]) */ "punpcklbw %%mm7, %%mm2 \n\t" "punpcklbw %%mm7, %%mm3 \n\t" "punpcklbw %%mm7, %%mm4 \n\t" "paddw     %%mm3, %%mm2 \n\t" "paddw     %%mm4, %%mm2 \n\t" /* score */ "movq      %%mm0, %%mm3 \n\t" "pcmpgtw   %%mm2, %%mm3 \n\t" /* if(score < spatial_score) */ "pminsw    %%mm2, %%mm0 \n\t" /* spatial_score= score; */ "movq      %%mm3, %%mm6 \n\t" "pand      %%mm3, %%mm5 \n\t" "pandn     %%mm1, %%mm3 \n\t" "por       %%mm5, %%mm3 \n\t" "movq      %%mm3, %%mm1 \n\t" /* spatial_pred= (cur[x-refs+j] + cur[x+refs-j])>>1; */ "movq ""-3""(%[cur],%[mrefs]), %%mm2 \n\t" /* cur[x-refs-1+j] */ "movq ""1""(%[cur],%[prefs]), %%mm3 \n\t" /* cur[x+refs-1-j] */ "movq      %%mm2, %%mm4 \n\t" "movq      %%mm2, %%mm5 \n\t" "pxor      %%mm3, %%mm4 \n\t" "pavgb     %%mm3, %%mm5 \n\t" "pand     %[pb1], %%mm4 \n\t" "psubusb   %%mm4, %%mm5 \n\t" "psrlq     $8,    %%mm5 \n\t" "punpcklbw %%mm7, %%mm5 \n\t" /* (cur[x-refs+j] + cur[x+refs-j])>>1 */ "movq      %%mm2, %%mm4 \n\t" "psubusb   %%mm3, %%mm2 \n\t" "psubusb   %%mm4, %%mm3 \n\t" "pmaxub    %%mm3, %%mm2 \n\t" "movq      %%mm2, %%mm3 \n\t" "movq      %%mm2, %%mm4 \n\t" /* ABS(cur[x-refs-1+j] - cur[x+refs-1-j]) */ "psrlq      $8,   %%mm3 \n\t" /* ABS(cur[x-refs  +j] - cur[x+refs  -j]) */ "psrlq     $16,   %%mm4 \n\t" /* ABS(cur[x-refs+1+j] - cur[x+refs+1-j]) */ "punpcklbw %%mm7, %%mm2 \n\t" "punpcklbw %%mm7, %%mm3 \n\t" "punpcklbw %%mm7, %%mm4 \n\t" "paddw     %%mm3, %%mm2 \n\t" "paddw     %%mm4, %%mm2 \n\t" /* score */ /* pretend not to have checked dir=2 if dir=1 was bad.                  hurts both quality and speed, but matches the C version. */ "paddw    %[pw1], %%mm6 \n\t" "psllw     $14,   %%mm6 \n\t" "paddsw    %%mm6, %%mm2 \n\t" "movq      %%mm0, %%mm3 \n\t" "pcmpgtw   %%mm2, %%mm3 \n\t" "pminsw    %%mm2, %%mm0 \n\t" "pand      %%mm3, %%mm5 \n\t" "pandn     %%mm1, %%mm3 \n\t" "por       %%mm5, %%mm3 \n\t" "movq      %%mm3, %%mm1 \n\t" "movq ""0""(%[cur],%[mrefs]), %%mm2 \n\t" /* cur[x-refs-1+j] */ "movq ""-2""(%[cur],%[prefs]), %%mm3 \n\t" /* cur[x+refs-1-j] */ "movq      %%mm2, %%mm4 \n\t" "movq      %%mm2, %%mm5 \n\t" "pxor      %%mm3, %%mm4 \n\t" "pavgb     %%mm3, %%mm5 \n\t" "pand     %[pb1], %%mm4 \n\t" "psubusb   %%mm4, %%mm5 \n\t" "psrlq     $8,    %%mm5 \n\t" "punpcklbw %%mm7, %%mm5 \n\t" /* (cur[x-refs+j] + cur[x+refs-j])>>1 */ "movq      %%mm2, %%mm4 \n\t" "psubusb   %%mm3, %%mm2 \n\t" "psubusb   %%mm4, %%mm3 \n\t" "pmaxub    %%mm3, %%mm2 \n\t" "movq      %%mm2, %%mm3 \n\t" "movq      %%mm2, %%mm4 \n\t" /* ABS(cur[x-refs-1+j] - cur[x+refs-1-j]) */ "psrlq      $8,   %%mm3 \n\t" /* ABS(cur[x-refs  +j] - cur[x+refs  -j]) */ "psrlq     $16,   %%mm4 \n\t" /* ABS(cur[x-refs+1+j] - cur[x+refs+1-j]) */ "punpcklbw %%mm7, %%mm2 \n\t" "punpcklbw %%mm7, %%mm3 \n\t" "punpcklbw %%mm7, %%mm4 \n\t" "paddw     %%mm3, %%mm2 \n\t" "paddw     %%mm4, %%mm2 \n\t" /* score */ "movq      %%mm0, %%mm3 \n\t" "pcmpgtw   %%mm2, %%mm3 \n\t" /* if(score < spatial_score) */ "pminsw    %%mm2, %%mm0 \n\t" /* spatial_score= score; */ "movq      %%mm3, %%mm6 \n\t" "pand      %%mm3, %%mm5 \n\t" "pandn     %%mm1, %%mm3 \n\t" "por       %%mm5, %%mm3 \n\t" "movq      %%mm3, %%mm1 \n\t" /* spatial_pred= (cur[x-refs+j] + cur[x+refs-j])>>1; */ "movq ""1""(%[cur],%[mrefs]), %%mm2 \n\t" /* cur[x-refs-1+j] */ "movq ""-3""(%[cur],%[prefs]), %%mm3 \n\t" /* cur[x+refs-1-j] */ "movq      %%mm2, %%mm4 \n\t" "movq      %%mm2, %%mm5 \n\t" "pxor      %%mm3, %%mm4 \n\t" "pavgb     %%mm3, %%mm5 \n\t" "pand     %[pb1], %%mm4 \n\t" "psubusb   %%mm4, %%mm5 \n\t" "psrlq     $8,    %%mm5 \n\t" "punpcklbw %%mm7, %%mm5 \n\t" /* (cur[x-refs+j] + cur[x+refs-j])>>1 */ "movq      %%mm2, %%mm4 \n\t" "psubusb   %%mm3, %%mm2 \n\t" "psubusb   %%mm4, %%mm3 \n\t" "pmaxub    %%mm3, %%mm2 \n\t" "movq      %%mm2, %%mm3 \n\t" "movq      %%mm2, %%mm4 \n\t" /* ABS(cur[x-refs-1+j] - cur[x+refs-1-j]) */ "psrlq      $8,   %%mm3 \n\t" /* ABS(cur[x-refs  +j] - cur[x+refs  -j]) */ "psrlq     $16,   %%mm4 \n\t" /* ABS(cur[x-refs+1+j] - cur[x+refs+1-j]) */ "punpcklbw %%mm7, %%mm2 \n\t" "punpcklbw %%mm7, %%mm3 \n\t" "punpcklbw %%mm7, %%mm4 \n\t" "paddw     %%mm3, %%mm2 \n\t" "paddw     %%mm4, %%mm2 \n\t" /* score */ /* pretend not to have checked dir=2 if dir=1 was bad.                  hurts both quality and speed, but matches the C version. */ "paddw    %[pw1], %%mm6 \n\t" "psllw     $14,   %%mm6 \n\t" "paddsw    %%mm6, %%mm2 \n\t" "movq      %%mm0, %%mm3 \n\t" "pcmpgtw   %%mm2, %%mm3 \n\t" "pminsw    %%mm2, %%mm0 \n\t" "pand      %%mm3, %%mm5 \n\t" "pandn     %%mm1, %%mm3 \n\t" "por       %%mm5, %%mm3 \n\t" "movq      %%mm3, %%mm1 \n\t" /* if(p->mode<2) ... */ "movq    %[tmp3], %%mm6 \n\t" /* diff */ "cmp       $2, %[mode] \n\t" "jge       1f \n\t" "movd      ""(%[""cur""],%[mrefs],2)"", ""%%mm2"" \n\t" "punpcklbw %%mm7, ""%%mm2"" \n\t" /* prev2[x-2*refs] */ "movd      ""(%[""next""],%[mrefs],2)"", ""%%mm4"" \n\t" "punpcklbw %%mm7, ""%%mm4"" \n\t" /* next2[x-2*refs] */ "movd      ""(%[""cur""],%[prefs],2)"", ""%%mm3"" \n\t" "punpcklbw %%mm7, ""%%mm3"" \n\t" /* prev2[x+2*refs] */ "movd      ""(%[""next""],%[prefs],2)"", ""%%mm5"" \n\t" "punpcklbw %%mm7, ""%%mm5"" \n\t" /* next2[x+2*refs] */ "paddw     %%mm4, %%mm2 \n\t" "paddw     %%mm5, %%mm3 \n\t" "psrlw     $1,    %%mm2 \n\t" /* b */ "psrlw     $1,    %%mm3 \n\t" /* f */ "movq    %[tmp0], %%mm4 \n\t" /* c */ "movq    %[tmp1], %%mm5 \n\t" /* d */ "movq    %[tmp2], %%mm7 \n\t" /* e */ "psubw     %%mm4, %%mm2 \n\t" /* b-c */ "psubw     %%mm7, %%mm3 \n\t" /* f-e */ "movq      %%mm5, %%mm0 \n\t" "psubw     %%mm4, %%mm5 \n\t" /* d-c */ "psubw     %%mm7, %%mm0 \n\t" /* d-e */ "movq      %%mm2, %%mm4 \n\t" "pminsw    %%mm3, %%mm2 \n\t" "pmaxsw    %%mm4, %%mm3 \n\t" "pmaxsw    %%mm5, %%mm2 \n\t" "pminsw    %%mm5, %%mm3 \n\t" "pmaxsw    %%mm0, %%mm2 \n\t" /* max */ "pminsw    %%mm0, %%mm3 \n\t" /* min */ "pxor      %%mm4, %%mm4 \n\t" "pmaxsw    %%mm3, %%mm6 \n\t" "psubw     %%mm2, %%mm4 \n\t" /* -max */ "pmaxsw    %%mm4, %%mm6 \n\t" /* diff= MAX3(diff, min, -max); */ "1: \n\t" "movq    %[tmp1], %%mm2 \n\t" /* d */ "movq      %%mm2, %%mm3 \n\t" "psubw     %%mm6, %%mm2 \n\t" /* d-diff */ "paddw     %%mm6, %%mm3 \n\t" /* d+diff */ "pmaxsw    %%mm2, %%mm1 \n\t" "pminsw    %%mm3, %%mm1 \n\t" /* d = clip(spatial_pred, d-diff, d+diff); */ "packuswb  %%mm1, %%mm1 \n\t" :[tmp0]"=m"(tmp0), [tmp1]"=m"(tmp1), [tmp2]"=m"(tmp2), [tmp3]"=m"(tmp3) :[prev] "r"(prev), [cur] "r"(cur), [next] "r"(next), [prefs]"r"((long)refs), [mrefs]"r"((long)-refs), [pw1] "m"(pw_1), [pb1] "m"(pb_1), [mode] "g"(mode) ); asm volatile("movd %%mm1, %0" :"=m"(*dst)); dst += 4; prev+= 4; cur += 4; next+= 4; }


    }
}

