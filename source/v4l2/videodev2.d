module v4l2.videodev2;
/* SPDX-License-Identifier: ((GPL-2.0+ WITH Linux-syscall-note) OR BSD-3-Clause) */
/*
 *  Video for Linux Two header file
 *
 *  Copyright (C) 1999-2012 the contributors
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  Alternatively you can redistribute this file under the terms of the
 *  BSD license as stated below:
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *  1. Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *  3. The names of its contributors may not be used to endorse or promote
 *     products derived from this software without specific prior written
 *     permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 *  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *	Header file for v4l or V4L2 drivers and applications
 * with public API.
 * All kernel-specific stuff were moved to media/v4l2-dev.h, so
 * no #if __KERNEL tests are allowed here
 *
 *	See https://linuxtv.org for more info
 *
 *	Author: Bill Dirks <bill@thedirks.org>
 *		Justin Schoeman
 *              Hans Verkuil <hverkuil@xs4all.nl>
 *		et al.
 */

import core.stdc.config;
import core.sys.posix.sys.time;
import core.sys.posix.sys.ioctl;
import v4l2.v4l2_common;

alias __le32 = uint;

extern (C):

/*
 * Common stuff for both V4L1 and V4L2
 * Moved from videodev.h
 */
enum VIDEO_MAX_FRAME = 32;
enum VIDEO_MAX_PLANES = 8;

/*
 *	M I S C E L L A N E O U S
 */

/*  Four-character-code (FOURCC) */
extern (D) auto v4l2_fourcc(T0, T1, T2, T3)(auto ref T0 a, auto ref T1 b, auto ref T2 c, auto ref T3 d) {
    return cast(uint) a | (cast(uint) b << 8) | (cast(uint) c << 16) | (cast(uint) d << 24);
}

extern (D) auto v4l2_fourcc_be(T0, T1, T2, T3)(auto ref T0 a, auto ref T1 b, auto ref T2 c,
        auto ref T3 d) {
    return v4l2_fourcc(a, b, c, d) | (1 << 31);
}

/*
 *	E N U M S
 */
enum v4l2_field {
    V4L2_FIELD_ANY = 0, /* driver can choose from none,
    					 top, bottom, interlaced
    					 depending on whatever it thinks
    					 is approximate ... */
    V4L2_FIELD_NONE = 1, /* this device has no fields ... */
    V4L2_FIELD_TOP = 2, /* top field only */
    V4L2_FIELD_BOTTOM = 3, /* bottom field only */
    V4L2_FIELD_INTERLACED = 4, /* both fields interlaced */
    V4L2_FIELD_SEQ_TB = 5, /* both fields sequential into one
    					 buffer, top-bottom order */
    V4L2_FIELD_SEQ_BT = 6, /* same as above + bottom-top order */
    V4L2_FIELD_ALTERNATE = 7, /* both fields alternating into
    					 separate buffers */
    V4L2_FIELD_INTERLACED_TB = 8, /* both fields interlaced, top field
    					 first and the top field is
    					 transmitted first */
    V4L2_FIELD_INTERLACED_BT = 9 /* both fields interlaced, top field
    					 first and the bottom field is
    					 transmitted first */
}

extern (D) auto V4L2_FIELD_HAS_TOP(T)(auto ref T field) {
    return field == v4l2_field.V4L2_FIELD_TOP || field == v4l2_field.V4L2_FIELD_INTERLACED
        || field == v4l2_field.V4L2_FIELD_INTERLACED_TB
        || field == v4l2_field.V4L2_FIELD_INTERLACED_BT
        || field == v4l2_field.V4L2_FIELD_SEQ_TB || field == v4l2_field.V4L2_FIELD_SEQ_BT;
}

extern (D) auto V4L2_FIELD_HAS_BOTTOM(T)(auto ref T field) {
    return field == v4l2_field.V4L2_FIELD_BOTTOM || field == v4l2_field.V4L2_FIELD_INTERLACED
        || field == v4l2_field.V4L2_FIELD_INTERLACED_TB
        || field == v4l2_field.V4L2_FIELD_INTERLACED_BT
        || field == v4l2_field.V4L2_FIELD_SEQ_TB || field == v4l2_field.V4L2_FIELD_SEQ_BT;
}

extern (D) auto V4L2_FIELD_HAS_BOTH(T)(auto ref T field) {
    return field == v4l2_field.V4L2_FIELD_INTERLACED
        || field == v4l2_field.V4L2_FIELD_INTERLACED_TB || field == v4l2_field.V4L2_FIELD_INTERLACED_BT
        || field == v4l2_field.V4L2_FIELD_SEQ_TB || field == v4l2_field.V4L2_FIELD_SEQ_BT;
}

extern (D) auto V4L2_FIELD_HAS_T_OR_B(T)(auto ref T field) {
    return field == v4l2_field.V4L2_FIELD_BOTTOM
        || field == v4l2_field.V4L2_FIELD_TOP || field == v4l2_field.V4L2_FIELD_ALTERNATE;
}

enum v4l2_buf_type {
    V4L2_BUF_TYPE_VIDEO_CAPTURE = 1,
    V4L2_BUF_TYPE_VIDEO_OUTPUT = 2,
    V4L2_BUF_TYPE_VIDEO_OVERLAY = 3,
    V4L2_BUF_TYPE_VBI_CAPTURE = 4,
    V4L2_BUF_TYPE_VBI_OUTPUT = 5,
    V4L2_BUF_TYPE_SLICED_VBI_CAPTURE = 6,
    V4L2_BUF_TYPE_SLICED_VBI_OUTPUT = 7,
    V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY = 8,
    V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 9,
    V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE = 10,
    V4L2_BUF_TYPE_SDR_CAPTURE = 11,
    V4L2_BUF_TYPE_SDR_OUTPUT = 12,
    V4L2_BUF_TYPE_META_CAPTURE = 13,
    /* Deprecated, do not use */
    V4L2_BUF_TYPE_PRIVATE = 0x80
}

extern (D) auto V4L2_TYPE_IS_MULTIPLANAR(T)(auto ref T type) {
    return type == v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
        || type == v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
}

extern (D) auto V4L2_TYPE_IS_OUTPUT(T)(auto ref T type) {
    return type == v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_OUTPUT
        || type == v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE || type
        == v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_OVERLAY
        || type == v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY
        || type == v4l2_buf_type.V4L2_BUF_TYPE_VBI_OUTPUT
        || type == v4l2_buf_type.V4L2_BUF_TYPE_SLICED_VBI_OUTPUT
        || type == v4l2_buf_type.V4L2_BUF_TYPE_SDR_OUTPUT;
}

enum v4l2_tuner_type {
    V4L2_TUNER_RADIO = 1,
    V4L2_TUNER_ANALOG_TV = 2,
    V4L2_TUNER_DIGITAL_TV = 3,
    V4L2_TUNER_SDR = 4,
    V4L2_TUNER_RF = 5
}

/* Deprecated, do not use */
enum V4L2_TUNER_ADC = v4l2_tuner_type.V4L2_TUNER_SDR;

enum v4l2_memory {
    V4L2_MEMORY_MMAP = 1,
    V4L2_MEMORY_USERPTR = 2,
    V4L2_MEMORY_OVERLAY = 3,
    V4L2_MEMORY_DMABUF = 4
}

/* see also http://vektor.theorem.ca/graphics/ycbcr/ */
enum v4l2_colorspace {
    /*
    	 * Default colorspace, i.e. let the driver figure it out.
    	 * Can only be used with video capture.
    	 */
    V4L2_COLORSPACE_DEFAULT = 0,

    /* SMPTE 170M: used for broadcast NTSC/PAL SDTV */
    V4L2_COLORSPACE_SMPTE170M = 1,

    /* Obsolete pre-1998 SMPTE 240M HDTV standard, superseded by Rec 709 */
    V4L2_COLORSPACE_SMPTE240M = 2,

    /* Rec.709: used for HDTV */
    V4L2_COLORSPACE_REC709 = 3,

    /*
    	 * Deprecated, do not use. No driver will ever return this. This was
    	 * based on a misunderstanding of the bt878 datasheet.
    	 */
    V4L2_COLORSPACE_BT878 = 4,

    /*
    	 * NTSC 1953 colorspace. This only makes sense when dealing with
    	 * really, really old NTSC recordings. Superseded by SMPTE 170M.
    	 */
    V4L2_COLORSPACE_470_SYSTEM_M = 5,

    /*
    	 * EBU Tech 3213 PAL/SECAM colorspace. This only makes sense when
    	 * dealing with really old PAL/SECAM recordings. Superseded by
    	 * SMPTE 170M.
    	 */
    V4L2_COLORSPACE_470_SYSTEM_BG = 6,

    /*
    	 * Effectively shorthand for V4L2_COLORSPACE_SRGB, V4L2_YCBCR_ENC_601
    	 * and V4L2_QUANTIZATION_FULL_RANGE. To be used for (Motion-)JPEG.
    	 */
    V4L2_COLORSPACE_JPEG = 7,

    /* For RGB colorspaces such as produces by most webcams. */
    V4L2_COLORSPACE_SRGB = 8,

    /* opRGB colorspace */
    V4L2_COLORSPACE_OPRGB = 9,

    /* BT.2020 colorspace, used for UHDTV. */
    V4L2_COLORSPACE_BT2020 = 10,

    /* Raw colorspace: for RAW unprocessed images */
    V4L2_COLORSPACE_RAW = 11,

    /* DCI-P3 colorspace, used by cinema projectors */
    V4L2_COLORSPACE_DCI_P3 = 12
}

/*
 * Determine how COLORSPACE_DEFAULT should map to a proper colorspace.
 * This depends on whether this is a SDTV image (use SMPTE 170M), an
 * HDTV image (use Rec. 709), or something else (use sRGB).
 */
extern (D) auto V4L2_MAP_COLORSPACE_DEFAULT(T0, T1)(auto ref T0 is_sdtv, auto ref T1 is_hdtv) {
    return is_sdtv ? v4l2_colorspace.V4L2_COLORSPACE_SMPTE170M : (is_hdtv
            ? v4l2_colorspace.V4L2_COLORSPACE_REC709 : v4l2_colorspace.V4L2_COLORSPACE_SRGB);
}

enum v4l2_xfer_func {
    /*
    	 * Mapping of V4L2_XFER_FUNC_DEFAULT to actual transfer functions
    	 * for the various colorspaces:
    	 *
    	 * V4L2_COLORSPACE_SMPTE170M, V4L2_COLORSPACE_470_SYSTEM_M,
    	 * V4L2_COLORSPACE_470_SYSTEM_BG, V4L2_COLORSPACE_REC709 and
    	 * V4L2_COLORSPACE_BT2020: V4L2_XFER_FUNC_709
    	 *
    	 * V4L2_COLORSPACE_SRGB, V4L2_COLORSPACE_JPEG: V4L2_XFER_FUNC_SRGB
    	 *
    	 * V4L2_COLORSPACE_OPRGB: V4L2_XFER_FUNC_OPRGB
    	 *
    	 * V4L2_COLORSPACE_SMPTE240M: V4L2_XFER_FUNC_SMPTE240M
    	 *
    	 * V4L2_COLORSPACE_RAW: V4L2_XFER_FUNC_NONE
    	 *
    	 * V4L2_COLORSPACE_DCI_P3: V4L2_XFER_FUNC_DCI_P3
    	 */
    V4L2_XFER_FUNC_DEFAULT = 0,
    V4L2_XFER_FUNC_709 = 1,
    V4L2_XFER_FUNC_SRGB = 2,
    V4L2_XFER_FUNC_OPRGB = 3,
    V4L2_XFER_FUNC_SMPTE240M = 4,
    V4L2_XFER_FUNC_NONE = 5,
    V4L2_XFER_FUNC_DCI_P3 = 6,
    V4L2_XFER_FUNC_SMPTE2084 = 7
}

/*
 * Determine how XFER_FUNC_DEFAULT should map to a proper transfer function.
 * This depends on the colorspace.
 */
extern (D) auto V4L2_MAP_XFER_FUNC_DEFAULT(T)(auto ref T colsp) {
    return colsp == v4l2_colorspace.V4L2_COLORSPACE_OPRGB ? v4l2_xfer_func.V4L2_XFER_FUNC_OPRGB
        : (colsp == v4l2_colorspace.V4L2_COLORSPACE_SMPTE240M
                ? v4l2_xfer_func.V4L2_XFER_FUNC_SMPTE240M
                : (colsp == v4l2_colorspace.V4L2_COLORSPACE_DCI_P3
                    ? v4l2_xfer_func.V4L2_XFER_FUNC_DCI_P3 : (colsp == v4l2_colorspace.V4L2_COLORSPACE_RAW
                    ? v4l2_xfer_func.V4L2_XFER_FUNC_NONE
                    : (colsp == v4l2_colorspace.V4L2_COLORSPACE_SRGB || colsp == v4l2_colorspace.V4L2_COLORSPACE_JPEG
                    ? v4l2_xfer_func.V4L2_XFER_FUNC_SRGB : v4l2_xfer_func.V4L2_XFER_FUNC_709))));
}

enum v4l2_ycbcr_encoding {
    /*
    	 * Mapping of V4L2_YCBCR_ENC_DEFAULT to actual encodings for the
    	 * various colorspaces:
    	 *
    	 * V4L2_COLORSPACE_SMPTE170M, V4L2_COLORSPACE_470_SYSTEM_M,
    	 * V4L2_COLORSPACE_470_SYSTEM_BG, V4L2_COLORSPACE_SRGB,
    	 * V4L2_COLORSPACE_OPRGB and V4L2_COLORSPACE_JPEG: V4L2_YCBCR_ENC_601
    	 *
    	 * V4L2_COLORSPACE_REC709 and V4L2_COLORSPACE_DCI_P3: V4L2_YCBCR_ENC_709
    	 *
    	 * V4L2_COLORSPACE_BT2020: V4L2_YCBCR_ENC_BT2020
    	 *
    	 * V4L2_COLORSPACE_SMPTE240M: V4L2_YCBCR_ENC_SMPTE240M
    	 */
    V4L2_YCBCR_ENC_DEFAULT = 0,

    /* ITU-R 601 -- SDTV */
    V4L2_YCBCR_ENC_601 = 1,

    /* Rec. 709 -- HDTV */
    V4L2_YCBCR_ENC_709 = 2,

    /* ITU-R 601/EN 61966-2-4 Extended Gamut -- SDTV */
    V4L2_YCBCR_ENC_XV601 = 3,

    /* Rec. 709/EN 61966-2-4 Extended Gamut -- HDTV */
    V4L2_YCBCR_ENC_XV709 = 4,

    /*
    	 * sYCC (Y'CbCr encoding of sRGB), identical to ENC_601. It was added
    	 * originally due to a misunderstanding of the sYCC standard. It should
    	 * not be used, instead use V4L2_YCBCR_ENC_601.
    	 */
    V4L2_YCBCR_ENC_SYCC = 5,

    /* BT.2020 Non-constant Luminance Y'CbCr */
    V4L2_YCBCR_ENC_BT2020 = 6,

    /* BT.2020 Constant Luminance Y'CbcCrc */
    V4L2_YCBCR_ENC_BT2020_CONST_LUM = 7,

    /* SMPTE 240M -- Obsolete HDTV */
    V4L2_YCBCR_ENC_SMPTE240M = 8
}

/*
 * enum v4l2_hsv_encoding values should not collide with the ones from
 * enum v4l2_ycbcr_encoding.
 */
enum v4l2_hsv_encoding {
    /* Hue mapped to 0 - 179 */
    V4L2_HSV_ENC_180 = 128,

    /* Hue mapped to 0-255 */
    V4L2_HSV_ENC_256 = 129
}

/*
 * Determine how YCBCR_ENC_DEFAULT should map to a proper Y'CbCr encoding.
 * This depends on the colorspace.
 */
extern (D) auto V4L2_MAP_YCBCR_ENC_DEFAULT(T)(auto ref T colsp) {
    return (colsp == v4l2_colorspace.V4L2_COLORSPACE_REC709
            || colsp == v4l2_colorspace.V4L2_COLORSPACE_DCI_P3) ? v4l2_ycbcr_encoding.V4L2_YCBCR_ENC_709
        : (colsp == v4l2_colorspace.V4L2_COLORSPACE_BT2020
                ? v4l2_ycbcr_encoding.V4L2_YCBCR_ENC_BT2020
                : (colsp == v4l2_colorspace.V4L2_COLORSPACE_SMPTE240M
                    ? v4l2_ycbcr_encoding.V4L2_YCBCR_ENC_SMPTE240M
                    : v4l2_ycbcr_encoding.V4L2_YCBCR_ENC_601));
}

enum v4l2_quantization {
    /*
    	 * The default for R'G'B' quantization is always full range, except
    	 * for the BT2020 colorspace. For Y'CbCr the quantization is always
    	 * limited range, except for COLORSPACE_JPEG: this is full range.
    	 */
    V4L2_QUANTIZATION_DEFAULT = 0,
    V4L2_QUANTIZATION_FULL_RANGE = 1,
    V4L2_QUANTIZATION_LIM_RANGE = 2
}

/*
 * Determine how QUANTIZATION_DEFAULT should map to a proper quantization.
 * This depends on whether the image is RGB or not, the colorspace and the
 * Y'CbCr encoding.
 */
extern (D) auto V4L2_MAP_QUANTIZATION_DEFAULT(T0, T1, T2)(auto ref T0 is_rgb_or_hsv,
        auto ref T1 colsp, auto ref T2 ycbcr_enc) {
    return (is_rgb_or_hsv && colsp == v4l2_colorspace.V4L2_COLORSPACE_BT2020) ? v4l2_quantization
        .V4L2_QUANTIZATION_LIM_RANGE : ((is_rgb_or_hsv
                || colsp == v4l2_colorspace.V4L2_COLORSPACE_JPEG)
                ? v4l2_quantization.V4L2_QUANTIZATION_FULL_RANGE
                : v4l2_quantization.V4L2_QUANTIZATION_LIM_RANGE);
}

/*
 * Deprecated names for opRGB colorspace (IEC 61966-2-5)
 *
 * WARNING: Please don't use these deprecated defines in your code, as
 * there is a chance we have to remove them in the future.
 */
enum V4L2_COLORSPACE_ADOBERGB = v4l2_colorspace.V4L2_COLORSPACE_OPRGB;
enum V4L2_XFER_FUNC_ADOBERGB = v4l2_xfer_func.V4L2_XFER_FUNC_OPRGB;

enum v4l2_priority {
    V4L2_PRIORITY_UNSET = 0, /* not initialized */
    V4L2_PRIORITY_BACKGROUND = 1,
    V4L2_PRIORITY_INTERACTIVE = 2,
    V4L2_PRIORITY_RECORD = 3,
    V4L2_PRIORITY_DEFAULT = V4L2_PRIORITY_INTERACTIVE
}

struct v4l2_rect {
    int left;
    int top;
    uint width;
    uint height;
}

struct v4l2_fract {
    uint numerator;
    uint denominator;
}

/**
  * struct v4l2_capability - Describes V4L2 device caps returned by VIDIOC_QUERYCAP
  *
  * @driver:	   name of the driver module (e.g. "bttv")
  * @card:	   name of the card (e.g. "Hauppauge WinTV")
  * @bus_info:	   name of the bus (e.g. "PCI:" + pci_name(pci_dev) )
  * @version:	   KERNEL_VERSION
  * @capabilities: capabilities of the physical device as a whole
  * @device_caps:  capabilities accessed via this particular device (node)
  * @reserved:	   reserved fields for future extensions
  */
struct v4l2_capability {
    ubyte[16] driver;
    ubyte[32] card;
    ubyte[32] bus_info;
    uint version_;
    uint capabilities;
    uint device_caps;
    uint[3] reserved;
}

/* Values for 'capabilities' field */
enum V4L2_CAP_VIDEO_CAPTURE = 0x00000001; /* Is a video capture device */
enum V4L2_CAP_VIDEO_OUTPUT = 0x00000002; /* Is a video output device */
enum V4L2_CAP_VIDEO_OVERLAY = 0x00000004; /* Can do video overlay */
enum V4L2_CAP_VBI_CAPTURE = 0x00000010; /* Is a raw VBI capture device */
enum V4L2_CAP_VBI_OUTPUT = 0x00000020; /* Is a raw VBI output device */
enum V4L2_CAP_SLICED_VBI_CAPTURE = 0x00000040; /* Is a sliced VBI capture device */
enum V4L2_CAP_SLICED_VBI_OUTPUT = 0x00000080; /* Is a sliced VBI output device */
enum V4L2_CAP_RDS_CAPTURE = 0x00000100; /* RDS data capture */
enum V4L2_CAP_VIDEO_OUTPUT_OVERLAY = 0x00000200; /* Can do video output overlay */
enum V4L2_CAP_HW_FREQ_SEEK = 0x00000400; /* Can do hardware frequency seek  */
enum V4L2_CAP_RDS_OUTPUT = 0x00000800; /* Is an RDS encoder */

/* Is a video capture device that supports multiplanar formats */
enum V4L2_CAP_VIDEO_CAPTURE_MPLANE = 0x00001000;
/* Is a video output device that supports multiplanar formats */
enum V4L2_CAP_VIDEO_OUTPUT_MPLANE = 0x00002000;
/* Is a video mem-to-mem device that supports multiplanar formats */
enum V4L2_CAP_VIDEO_M2M_MPLANE = 0x00004000;
/* Is a video mem-to-mem device */
enum V4L2_CAP_VIDEO_M2M = 0x00008000;

enum V4L2_CAP_TUNER = 0x00010000; /* has a tuner */
enum V4L2_CAP_AUDIO = 0x00020000; /* has audio support */
enum V4L2_CAP_RADIO = 0x00040000; /* is a radio device */
enum V4L2_CAP_MODULATOR = 0x00080000; /* has a modulator */

enum V4L2_CAP_SDR_CAPTURE = 0x00100000; /* Is a SDR capture device */
enum V4L2_CAP_EXT_PIX_FORMAT = 0x00200000; /* Supports the extended pixel format */
enum V4L2_CAP_SDR_OUTPUT = 0x00400000; /* Is a SDR output device */
enum V4L2_CAP_META_CAPTURE = 0x00800000; /* Is a metadata capture device */

enum V4L2_CAP_READWRITE = 0x01000000; /* read/write systemcalls */
enum V4L2_CAP_ASYNCIO = 0x02000000; /* async I/O */
enum V4L2_CAP_STREAMING = 0x04000000; /* streaming I/O ioctls */

enum V4L2_CAP_TOUCH = 0x10000000; /* Is a touch device */

enum V4L2_CAP_DEVICE_CAPS = 0x80000000; /* sets device capabilities field */

/*
 *	V I D E O   I M A G E   F O R M A T
 */
struct v4l2_pix_format {
    uint width;
    uint height;
    uint pixelformat;
    uint field; /* enum v4l2_field */
    uint bytesperline; /* for padding, zero if unused */
    uint sizeimage;
    uint colorspace; /* enum v4l2_colorspace */
    uint priv; /* private data, depends on pixelformat */
    uint flags; /* format flags (V4L2_PIX_FMT_FLAG_*) */
    union {
        /* enum v4l2_ycbcr_encoding */
        uint ycbcr_enc;
        /* enum v4l2_hsv_encoding */
        uint hsv_enc;
    }

    uint quantization; /* enum v4l2_quantization */
    uint xfer_func; /* enum v4l2_xfer_func */
}

/*      Pixel format         FOURCC                          depth  Description  */

/* RGB formats */
enum V4L2_PIX_FMT_RGB332 = v4l2_fourcc('R', 'G', 'B', '1'); /*  8  RGB-3-3-2     */
enum V4L2_PIX_FMT_RGB444 = v4l2_fourcc('R', '4', '4', '4'); /* 16  xxxxrrrr ggggbbbb */
enum V4L2_PIX_FMT_ARGB444 = v4l2_fourcc('A', 'R', '1', '2'); /* 16  aaaarrrr ggggbbbb */
enum V4L2_PIX_FMT_XRGB444 = v4l2_fourcc('X', 'R', '1', '2'); /* 16  xxxxrrrr ggggbbbb */
enum V4L2_PIX_FMT_RGB555 = v4l2_fourcc('R', 'G', 'B', 'O'); /* 16  RGB-5-5-5     */
enum V4L2_PIX_FMT_ARGB555 = v4l2_fourcc('A', 'R', '1', '5'); /* 16  ARGB-1-5-5-5  */
enum V4L2_PIX_FMT_XRGB555 = v4l2_fourcc('X', 'R', '1', '5'); /* 16  XRGB-1-5-5-5  */
enum V4L2_PIX_FMT_RGB565 = v4l2_fourcc('R', 'G', 'B', 'P'); /* 16  RGB-5-6-5     */
enum V4L2_PIX_FMT_RGB555X = v4l2_fourcc('R', 'G', 'B', 'Q'); /* 16  RGB-5-5-5 BE  */
enum V4L2_PIX_FMT_ARGB555X = v4l2_fourcc_be('A', 'R', '1', '5'); /* 16  ARGB-5-5-5 BE */
enum V4L2_PIX_FMT_XRGB555X = v4l2_fourcc_be('X', 'R', '1', '5'); /* 16  XRGB-5-5-5 BE */
enum V4L2_PIX_FMT_RGB565X = v4l2_fourcc('R', 'G', 'B', 'R'); /* 16  RGB-5-6-5 BE  */
enum V4L2_PIX_FMT_BGR666 = v4l2_fourcc('B', 'G', 'R', 'H'); /* 18  BGR-6-6-6	  */
enum V4L2_PIX_FMT_BGR24 = v4l2_fourcc('B', 'G', 'R', '3'); /* 24  BGR-8-8-8     */
enum V4L2_PIX_FMT_RGB24 = v4l2_fourcc('R', 'G', 'B', '3'); /* 24  RGB-8-8-8     */
enum V4L2_PIX_FMT_BGR32 = v4l2_fourcc('B', 'G', 'R', '4'); /* 32  BGR-8-8-8-8   */
enum V4L2_PIX_FMT_ABGR32 = v4l2_fourcc('A', 'R', '2', '4'); /* 32  BGRA-8-8-8-8  */
enum V4L2_PIX_FMT_XBGR32 = v4l2_fourcc('X', 'R', '2', '4'); /* 32  BGRX-8-8-8-8  */
enum V4L2_PIX_FMT_RGB32 = v4l2_fourcc('R', 'G', 'B', '4'); /* 32  RGB-8-8-8-8   */
enum V4L2_PIX_FMT_ARGB32 = v4l2_fourcc('B', 'A', '2', '4'); /* 32  ARGB-8-8-8-8  */
enum V4L2_PIX_FMT_XRGB32 = v4l2_fourcc('B', 'X', '2', '4'); /* 32  XRGB-8-8-8-8  */

/* Grey formats */
enum V4L2_PIX_FMT_GREY = v4l2_fourcc('G', 'R', 'E', 'Y'); /*  8  Greyscale     */
enum V4L2_PIX_FMT_Y4 = v4l2_fourcc('Y', '0', '4', ' '); /*  4  Greyscale     */
enum V4L2_PIX_FMT_Y6 = v4l2_fourcc('Y', '0', '6', ' '); /*  6  Greyscale     */
enum V4L2_PIX_FMT_Y10 = v4l2_fourcc('Y', '1', '0', ' '); /* 10  Greyscale     */
enum V4L2_PIX_FMT_Y12 = v4l2_fourcc('Y', '1', '2', ' '); /* 12  Greyscale     */
enum V4L2_PIX_FMT_Y16 = v4l2_fourcc('Y', '1', '6', ' '); /* 16  Greyscale     */
enum V4L2_PIX_FMT_Y16_BE = v4l2_fourcc_be('Y', '1', '6', ' '); /* 16  Greyscale BE  */

/* Grey bit-packed formats */
enum V4L2_PIX_FMT_Y10BPACK = v4l2_fourcc('Y', '1', '0', 'B'); /* 10  Greyscale bit-packed */

/* Palette formats */
enum V4L2_PIX_FMT_PAL8 = v4l2_fourcc('P', 'A', 'L', '8'); /*  8  8-bit palette */

/* Chrominance formats */
enum V4L2_PIX_FMT_UV8 = v4l2_fourcc('U', 'V', '8', ' '); /*  8  UV 4:4 */

/* Luminance+Chrominance formats */
enum V4L2_PIX_FMT_YUYV = v4l2_fourcc('Y', 'U', 'Y', 'V'); /* 16  YUV 4:2:2     */
enum V4L2_PIX_FMT_YYUV = v4l2_fourcc('Y', 'Y', 'U', 'V'); /* 16  YUV 4:2:2     */
enum V4L2_PIX_FMT_YVYU = v4l2_fourcc('Y', 'V', 'Y', 'U'); /* 16 YVU 4:2:2 */
enum V4L2_PIX_FMT_UYVY = v4l2_fourcc('U', 'Y', 'V', 'Y'); /* 16  YUV 4:2:2     */
enum V4L2_PIX_FMT_VYUY = v4l2_fourcc('V', 'Y', 'U', 'Y'); /* 16  YUV 4:2:2     */
enum V4L2_PIX_FMT_Y41P = v4l2_fourcc('Y', '4', '1', 'P'); /* 12  YUV 4:1:1     */
enum V4L2_PIX_FMT_YUV444 = v4l2_fourcc('Y', '4', '4', '4'); /* 16  xxxxyyyy uuuuvvvv */
enum V4L2_PIX_FMT_YUV555 = v4l2_fourcc('Y', 'U', 'V', 'O'); /* 16  YUV-5-5-5     */
enum V4L2_PIX_FMT_YUV565 = v4l2_fourcc('Y', 'U', 'V', 'P'); /* 16  YUV-5-6-5     */
enum V4L2_PIX_FMT_YUV32 = v4l2_fourcc('Y', 'U', 'V', '4'); /* 32  YUV-8-8-8-8   */
enum V4L2_PIX_FMT_HI240 = v4l2_fourcc('H', 'I', '2', '4'); /*  8  8-bit color   */
enum V4L2_PIX_FMT_HM12 = v4l2_fourcc('H', 'M', '1', '2'); /*  8  YUV 4:2:0 16x16 macroblocks */
enum V4L2_PIX_FMT_M420 = v4l2_fourcc('M', '4', '2', '0'); /* 12  YUV 4:2:0 2 lines y, 1 line uv interleaved */

/* two planes -- one Y, one Cr + Cb interleaved  */
enum V4L2_PIX_FMT_NV12 = v4l2_fourcc('N', 'V', '1', '2'); /* 12  Y/CbCr 4:2:0  */
enum V4L2_PIX_FMT_NV21 = v4l2_fourcc('N', 'V', '2', '1'); /* 12  Y/CrCb 4:2:0  */
enum V4L2_PIX_FMT_NV16 = v4l2_fourcc('N', 'V', '1', '6'); /* 16  Y/CbCr 4:2:2  */
enum V4L2_PIX_FMT_NV61 = v4l2_fourcc('N', 'V', '6', '1'); /* 16  Y/CrCb 4:2:2  */
enum V4L2_PIX_FMT_NV24 = v4l2_fourcc('N', 'V', '2', '4'); /* 24  Y/CbCr 4:4:4  */
enum V4L2_PIX_FMT_NV42 = v4l2_fourcc('N', 'V', '4', '2'); /* 24  Y/CrCb 4:4:4  */

/* two non contiguous planes - one Y, one Cr + Cb interleaved  */
enum V4L2_PIX_FMT_NV12M = v4l2_fourcc('N', 'M', '1', '2'); /* 12  Y/CbCr 4:2:0  */
enum V4L2_PIX_FMT_NV21M = v4l2_fourcc('N', 'M', '2', '1'); /* 21  Y/CrCb 4:2:0  */
enum V4L2_PIX_FMT_NV16M = v4l2_fourcc('N', 'M', '1', '6'); /* 16  Y/CbCr 4:2:2  */
enum V4L2_PIX_FMT_NV61M = v4l2_fourcc('N', 'M', '6', '1'); /* 16  Y/CrCb 4:2:2  */
enum V4L2_PIX_FMT_NV12MT = v4l2_fourcc('T', 'M', '1', '2'); /* 12  Y/CbCr 4:2:0 64x32 macroblocks */
enum V4L2_PIX_FMT_NV12MT_16X16 = v4l2_fourcc('V', 'M', '1', '2'); /* 12  Y/CbCr 4:2:0 16x16 macroblocks */

/* three planes - Y Cb, Cr */
enum V4L2_PIX_FMT_YUV410 = v4l2_fourcc('Y', 'U', 'V', '9'); /*  9  YUV 4:1:0     */
enum V4L2_PIX_FMT_YVU410 = v4l2_fourcc('Y', 'V', 'U', '9'); /*  9  YVU 4:1:0     */
enum V4L2_PIX_FMT_YUV411P = v4l2_fourcc('4', '1', '1', 'P'); /* 12  YVU411 planar */
enum V4L2_PIX_FMT_YUV420 = v4l2_fourcc('Y', 'U', '1', '2'); /* 12  YUV 4:2:0     */
enum V4L2_PIX_FMT_YVU420 = v4l2_fourcc('Y', 'V', '1', '2'); /* 12  YVU 4:2:0     */
enum V4L2_PIX_FMT_YUV422P = v4l2_fourcc('4', '2', '2', 'P'); /* 16  YVU422 planar */

/* three non contiguous planes - Y, Cb, Cr */
enum V4L2_PIX_FMT_YUV420M = v4l2_fourcc('Y', 'M', '1', '2'); /* 12  YUV420 planar */
enum V4L2_PIX_FMT_YVU420M = v4l2_fourcc('Y', 'M', '2', '1'); /* 12  YVU420 planar */
enum V4L2_PIX_FMT_YUV422M = v4l2_fourcc('Y', 'M', '1', '6'); /* 16  YUV422 planar */
enum V4L2_PIX_FMT_YVU422M = v4l2_fourcc('Y', 'M', '6', '1'); /* 16  YVU422 planar */
enum V4L2_PIX_FMT_YUV444M = v4l2_fourcc('Y', 'M', '2', '4'); /* 24  YUV444 planar */
enum V4L2_PIX_FMT_YVU444M = v4l2_fourcc('Y', 'M', '4', '2'); /* 24  YVU444 planar */

/* Bayer formats - see http://www.siliconimaging.com/RGB%20Bayer.htm */
enum V4L2_PIX_FMT_SBGGR8 = v4l2_fourcc('B', 'A', '8', '1'); /*  8  BGBG.. GRGR.. */
enum V4L2_PIX_FMT_SGBRG8 = v4l2_fourcc('G', 'B', 'R', 'G'); /*  8  GBGB.. RGRG.. */
enum V4L2_PIX_FMT_SGRBG8 = v4l2_fourcc('G', 'R', 'B', 'G'); /*  8  GRGR.. BGBG.. */
enum V4L2_PIX_FMT_SRGGB8 = v4l2_fourcc('R', 'G', 'G', 'B'); /*  8  RGRG.. GBGB.. */
enum V4L2_PIX_FMT_SBGGR10 = v4l2_fourcc('B', 'G', '1', '0'); /* 10  BGBG.. GRGR.. */
enum V4L2_PIX_FMT_SGBRG10 = v4l2_fourcc('G', 'B', '1', '0'); /* 10  GBGB.. RGRG.. */
enum V4L2_PIX_FMT_SGRBG10 = v4l2_fourcc('B', 'A', '1', '0'); /* 10  GRGR.. BGBG.. */
enum V4L2_PIX_FMT_SRGGB10 = v4l2_fourcc('R', 'G', '1', '0'); /* 10  RGRG.. GBGB.. */
/* 10bit raw bayer packed, 5 bytes for every 4 pixels */
enum V4L2_PIX_FMT_SBGGR10P = v4l2_fourcc('p', 'B', 'A', 'A');
enum V4L2_PIX_FMT_SGBRG10P = v4l2_fourcc('p', 'G', 'A', 'A');
enum V4L2_PIX_FMT_SGRBG10P = v4l2_fourcc('p', 'g', 'A', 'A');
enum V4L2_PIX_FMT_SRGGB10P = v4l2_fourcc('p', 'R', 'A', 'A');
/* 10bit raw bayer a-law compressed to 8 bits */
enum V4L2_PIX_FMT_SBGGR10ALAW8 = v4l2_fourcc('a', 'B', 'A', '8');
enum V4L2_PIX_FMT_SGBRG10ALAW8 = v4l2_fourcc('a', 'G', 'A', '8');
enum V4L2_PIX_FMT_SGRBG10ALAW8 = v4l2_fourcc('a', 'g', 'A', '8');
enum V4L2_PIX_FMT_SRGGB10ALAW8 = v4l2_fourcc('a', 'R', 'A', '8');
/* 10bit raw bayer DPCM compressed to 8 bits */
enum V4L2_PIX_FMT_SBGGR10DPCM8 = v4l2_fourcc('b', 'B', 'A', '8');
enum V4L2_PIX_FMT_SGBRG10DPCM8 = v4l2_fourcc('b', 'G', 'A', '8');
enum V4L2_PIX_FMT_SGRBG10DPCM8 = v4l2_fourcc('B', 'D', '1', '0');
enum V4L2_PIX_FMT_SRGGB10DPCM8 = v4l2_fourcc('b', 'R', 'A', '8');
enum V4L2_PIX_FMT_SBGGR12 = v4l2_fourcc('B', 'G', '1', '2'); /* 12  BGBG.. GRGR.. */
enum V4L2_PIX_FMT_SGBRG12 = v4l2_fourcc('G', 'B', '1', '2'); /* 12  GBGB.. RGRG.. */
enum V4L2_PIX_FMT_SGRBG12 = v4l2_fourcc('B', 'A', '1', '2'); /* 12  GRGR.. BGBG.. */
enum V4L2_PIX_FMT_SRGGB12 = v4l2_fourcc('R', 'G', '1', '2'); /* 12  RGRG.. GBGB.. */
/* 12bit raw bayer packed, 6 bytes for every 4 pixels */
enum V4L2_PIX_FMT_SBGGR12P = v4l2_fourcc('p', 'B', 'C', 'C');
enum V4L2_PIX_FMT_SGBRG12P = v4l2_fourcc('p', 'G', 'C', 'C');
enum V4L2_PIX_FMT_SGRBG12P = v4l2_fourcc('p', 'g', 'C', 'C');
enum V4L2_PIX_FMT_SRGGB12P = v4l2_fourcc('p', 'R', 'C', 'C');
enum V4L2_PIX_FMT_SBGGR16 = v4l2_fourcc('B', 'Y', 'R', '2'); /* 16  BGBG.. GRGR.. */
enum V4L2_PIX_FMT_SGBRG16 = v4l2_fourcc('G', 'B', '1', '6'); /* 16  GBGB.. RGRG.. */
enum V4L2_PIX_FMT_SGRBG16 = v4l2_fourcc('G', 'R', '1', '6'); /* 16  GRGR.. BGBG.. */
enum V4L2_PIX_FMT_SRGGB16 = v4l2_fourcc('R', 'G', '1', '6'); /* 16  RGRG.. GBGB.. */

/* HSV formats */
enum V4L2_PIX_FMT_HSV24 = v4l2_fourcc('H', 'S', 'V', '3');
enum V4L2_PIX_FMT_HSV32 = v4l2_fourcc('H', 'S', 'V', '4');

/* compressed formats */
enum V4L2_PIX_FMT_MJPEG = v4l2_fourcc('M', 'J', 'P', 'G'); /* Motion-JPEG   */
enum V4L2_PIX_FMT_JPEG = v4l2_fourcc('J', 'P', 'E', 'G'); /* JFIF JPEG     */
enum V4L2_PIX_FMT_DV = v4l2_fourcc('d', 'v', 's', 'd'); /* 1394          */
enum V4L2_PIX_FMT_MPEG = v4l2_fourcc('M', 'P', 'E', 'G'); /* MPEG-1/2/4 Multiplexed */
enum V4L2_PIX_FMT_H264 = v4l2_fourcc('H', '2', '6', '4'); /* H264 with start codes */
enum V4L2_PIX_FMT_H264_NO_SC = v4l2_fourcc('A', 'V', 'C', '1'); /* H264 without start codes */
enum V4L2_PIX_FMT_H264_MVC = v4l2_fourcc('M', '2', '6', '4'); /* H264 MVC */
enum V4L2_PIX_FMT_H263 = v4l2_fourcc('H', '2', '6', '3'); /* H263          */
enum V4L2_PIX_FMT_MPEG1 = v4l2_fourcc('M', 'P', 'G', '1'); /* MPEG-1 ES     */
enum V4L2_PIX_FMT_MPEG2 = v4l2_fourcc('M', 'P', 'G', '2'); /* MPEG-2 ES     */
enum V4L2_PIX_FMT_MPEG4 = v4l2_fourcc('M', 'P', 'G', '4'); /* MPEG-4 part 2 ES */
enum V4L2_PIX_FMT_XVID = v4l2_fourcc('X', 'V', 'I', 'D'); /* Xvid           */
enum V4L2_PIX_FMT_VC1_ANNEX_G = v4l2_fourcc('V', 'C', '1', 'G'); /* SMPTE 421M Annex G compliant stream */
enum V4L2_PIX_FMT_VC1_ANNEX_L = v4l2_fourcc('V', 'C', '1', 'L'); /* SMPTE 421M Annex L compliant stream */
enum V4L2_PIX_FMT_VP8 = v4l2_fourcc('V', 'P', '8', '0'); /* VP8 */
enum V4L2_PIX_FMT_VP9 = v4l2_fourcc('V', 'P', '9', '0'); /* VP9 */

/*  Vendor-specific formats   */
enum V4L2_PIX_FMT_CPIA1 = v4l2_fourcc('C', 'P', 'I', 'A'); /* cpia1 YUV */
enum V4L2_PIX_FMT_WNVA = v4l2_fourcc('W', 'N', 'V', 'A'); /* Winnov hw compress */
enum V4L2_PIX_FMT_SN9C10X = v4l2_fourcc('S', '9', '1', '0'); /* SN9C10x compression */
enum V4L2_PIX_FMT_SN9C20X_I420 = v4l2_fourcc('S', '9', '2', '0'); /* SN9C20x YUV 4:2:0 */
enum V4L2_PIX_FMT_PWC1 = v4l2_fourcc('P', 'W', 'C', '1'); /* pwc older webcam */
enum V4L2_PIX_FMT_PWC2 = v4l2_fourcc('P', 'W', 'C', '2'); /* pwc newer webcam */
enum V4L2_PIX_FMT_ET61X251 = v4l2_fourcc('E', '6', '2', '5'); /* ET61X251 compression */
enum V4L2_PIX_FMT_SPCA501 = v4l2_fourcc('S', '5', '0', '1'); /* YUYV per line */
enum V4L2_PIX_FMT_SPCA505 = v4l2_fourcc('S', '5', '0', '5'); /* YYUV per line */
enum V4L2_PIX_FMT_SPCA508 = v4l2_fourcc('S', '5', '0', '8'); /* YUVY per line */
enum V4L2_PIX_FMT_SPCA561 = v4l2_fourcc('S', '5', '6', '1'); /* compressed GBRG bayer */
enum V4L2_PIX_FMT_PAC207 = v4l2_fourcc('P', '2', '0', '7'); /* compressed BGGR bayer */
enum V4L2_PIX_FMT_MR97310A = v4l2_fourcc('M', '3', '1', '0'); /* compressed BGGR bayer */
enum V4L2_PIX_FMT_JL2005BCD = v4l2_fourcc('J', 'L', '2', '0'); /* compressed RGGB bayer */
enum V4L2_PIX_FMT_SN9C2028 = v4l2_fourcc('S', 'O', 'N', 'X'); /* compressed GBRG bayer */
enum V4L2_PIX_FMT_SQ905C = v4l2_fourcc('9', '0', '5', 'C'); /* compressed RGGB bayer */
enum V4L2_PIX_FMT_PJPG = v4l2_fourcc('P', 'J', 'P', 'G'); /* Pixart 73xx JPEG */
enum V4L2_PIX_FMT_OV511 = v4l2_fourcc('O', '5', '1', '1'); /* ov511 JPEG */
enum V4L2_PIX_FMT_OV518 = v4l2_fourcc('O', '5', '1', '8'); /* ov518 JPEG */
enum V4L2_PIX_FMT_STV0680 = v4l2_fourcc('S', '6', '8', '0'); /* stv0680 bayer */
enum V4L2_PIX_FMT_TM6000 = v4l2_fourcc('T', 'M', '6', '0'); /* tm5600/tm60x0 */
enum V4L2_PIX_FMT_CIT_YYVYUY = v4l2_fourcc('C', 'I', 'T', 'V'); /* one line of Y then 1 line of VYUY */
enum V4L2_PIX_FMT_KONICA420 = v4l2_fourcc('K', 'O', 'N', 'I'); /* YUV420 planar in blocks of 256 pixels */
enum V4L2_PIX_FMT_JPGL = v4l2_fourcc('J', 'P', 'G', 'L'); /* JPEG-Lite */
enum V4L2_PIX_FMT_SE401 = v4l2_fourcc('S', '4', '0', '1'); /* se401 janggu compressed rgb */
enum V4L2_PIX_FMT_S5C_UYVY_JPG = v4l2_fourcc('S', '5', 'C', 'I'); /* S5C73M3 interleaved UYVY/JPEG */
enum V4L2_PIX_FMT_Y8I = v4l2_fourcc('Y', '8', 'I', ' '); /* Greyscale 8-bit L/R interleaved */
enum V4L2_PIX_FMT_Y12I = v4l2_fourcc('Y', '1', '2', 'I'); /* Greyscale 12-bit L/R interleaved */
enum V4L2_PIX_FMT_Z16 = v4l2_fourcc('Z', '1', '6', ' '); /* Depth data 16-bit */
enum V4L2_PIX_FMT_MT21C = v4l2_fourcc('M', 'T', '2', '1'); /* Mediatek compressed block mode  */
enum V4L2_PIX_FMT_INZI = v4l2_fourcc('I', 'N', 'Z', 'I'); /* Intel Planar Greyscale 10-bit and Depth 16-bit */

/* SDR formats - used only for Software Defined Radio devices */
enum V4L2_SDR_FMT_CU8 = v4l2_fourcc('C', 'U', '0', '8'); /* IQ u8 */
enum V4L2_SDR_FMT_CU16LE = v4l2_fourcc('C', 'U', '1', '6'); /* IQ u16le */
enum V4L2_SDR_FMT_CS8 = v4l2_fourcc('C', 'S', '0', '8'); /* complex s8 */
enum V4L2_SDR_FMT_CS14LE = v4l2_fourcc('C', 'S', '1', '4'); /* complex s14le */
enum V4L2_SDR_FMT_RU12LE = v4l2_fourcc('R', 'U', '1', '2'); /* real u12le */
enum V4L2_SDR_FMT_PCU16BE = v4l2_fourcc('P', 'C', '1', '6'); /* planar complex u16be */
enum V4L2_SDR_FMT_PCU18BE = v4l2_fourcc('P', 'C', '1', '8'); /* planar complex u18be */
enum V4L2_SDR_FMT_PCU20BE = v4l2_fourcc('P', 'C', '2', '0'); /* planar complex u20be */

/* Touch formats - used for Touch devices */
enum V4L2_TCH_FMT_DELTA_TD16 = v4l2_fourcc('T', 'D', '1', '6'); /* 16-bit signed deltas */
enum V4L2_TCH_FMT_DELTA_TD08 = v4l2_fourcc('T', 'D', '0', '8'); /* 8-bit signed deltas */
enum V4L2_TCH_FMT_TU16 = v4l2_fourcc('T', 'U', '1', '6'); /* 16-bit unsigned touch data */
enum V4L2_TCH_FMT_TU08 = v4l2_fourcc('T', 'U', '0', '8'); /* 8-bit unsigned touch data */

/* Meta-data formats */
enum V4L2_META_FMT_VSP1_HGO = v4l2_fourcc('V', 'S', 'P', 'H'); /* R-Car VSP1 1-D Histogram */
enum V4L2_META_FMT_VSP1_HGT = v4l2_fourcc('V', 'S', 'P', 'T'); /* R-Car VSP1 2-D Histogram */

/* priv field value to indicates that subsequent fields are valid. */
enum V4L2_PIX_FMT_PRIV_MAGIC = 0xfeedcafe;

/* Flags */
enum V4L2_PIX_FMT_FLAG_PREMUL_ALPHA = 0x00000001;

/*
 *	F O R M A T   E N U M E R A T I O N
 */
struct v4l2_fmtdesc {
    uint index; /* Format number      */
    uint type; /* enum v4l2_buf_type */
    uint flags;
    ubyte[32] description; /* Description string */
    uint pixelformat; /* Format fourcc      */
    uint[4] reserved;
}

enum V4L2_FMT_FLAG_COMPRESSED = 0x0001;
enum V4L2_FMT_FLAG_EMULATED = 0x0002;

/* Frame Size and frame rate enumeration */
/*
 *	F R A M E   S I Z E   E N U M E R A T I O N
 */
enum v4l2_frmsizetypes {
    V4L2_FRMSIZE_TYPE_DISCRETE = 1,
    V4L2_FRMSIZE_TYPE_CONTINUOUS = 2,
    V4L2_FRMSIZE_TYPE_STEPWISE = 3
}

struct v4l2_frmsize_discrete {
    uint width; /* Frame width [pixel] */
    uint height; /* Frame height [pixel] */
}

struct v4l2_frmsize_stepwise {
    uint min_width; /* Minimum frame width [pixel] */
    uint max_width; /* Maximum frame width [pixel] */
    uint step_width; /* Frame width step size [pixel] */
    uint min_height; /* Minimum frame height [pixel] */
    uint max_height; /* Maximum frame height [pixel] */
    uint step_height; /* Frame height step size [pixel] */
}

struct v4l2_frmsizeenum {
    uint index; /* Frame size number */
    uint pixel_format; /* Pixel format */
    uint type; /* Frame size type the device supports. */

    union {
        /* Frame size */
        v4l2_frmsize_discrete discrete;
        v4l2_frmsize_stepwise stepwise;
    }

    uint[2] reserved; /* Reserved space for future use */
}

/*
 *	F R A M E   R A T E   E N U M E R A T I O N
 */
enum v4l2_frmivaltypes {
    V4L2_FRMIVAL_TYPE_DISCRETE = 1,
    V4L2_FRMIVAL_TYPE_CONTINUOUS = 2,
    V4L2_FRMIVAL_TYPE_STEPWISE = 3
}

struct v4l2_frmival_stepwise {
    v4l2_fract min; /* Minimum frame interval [s] */
    v4l2_fract max; /* Maximum frame interval [s] */
    v4l2_fract step; /* Frame interval step size [s] */
}

struct v4l2_frmivalenum {
    uint index; /* Frame format index */
    uint pixel_format; /* Pixel format */
    uint width; /* Frame width */
    uint height; /* Frame height */
    uint type; /* Frame interval type the device supports. */

    union {
        /* Frame interval */
        v4l2_fract discrete;
        v4l2_frmival_stepwise stepwise;
    }

    uint[2] reserved; /* Reserved space for future use */
}

/*
 *	T I M E C O D E
 */
struct v4l2_timecode {
    uint type;
    uint flags;
    ubyte frames;
    ubyte seconds;
    ubyte minutes;
    ubyte hours;
    ubyte[4] userbits;
}

/*  Type  */
enum V4L2_TC_TYPE_24FPS = 1;
enum V4L2_TC_TYPE_25FPS = 2;
enum V4L2_TC_TYPE_30FPS = 3;
enum V4L2_TC_TYPE_50FPS = 4;
enum V4L2_TC_TYPE_60FPS = 5;

/*  Flags  */
enum V4L2_TC_FLAG_DROPFRAME = 0x0001; /* "drop-frame" mode */
enum V4L2_TC_FLAG_COLORFRAME = 0x0002;
enum V4L2_TC_USERBITS_field = 0x000C;
enum V4L2_TC_USERBITS_USERDEFINED = 0x0000;
enum V4L2_TC_USERBITS_8BITCHARS = 0x0008;
/* The above is based on SMPTE timecodes */

struct v4l2_jpegcompression {
    int quality;

    int APPn; /* Number of APP segment to be written,
    				 * must be 0..15 */
    int APP_len; /* Length of data in JPEG APPn segment */
    char[60] APP_data; /* Data in the JPEG APPn segment. */

    int COM_len; /* Length of data in JPEG COM segment */
    char[60] COM_data; /* Data in JPEG COM segment */

    uint jpeg_markers; /* Which markers should go into the JPEG
    				 * output. Unless you exactly know what
    				 * you do, leave them untouched.
    				 * Including less markers will make the
    				 * resulting code smaller, but there will
    				 * be fewer applications which can read it.
    				 * The presence of the APP and COM marker
    				 * is influenced by APP_len and COM_len
    				 * ONLY, not by this property! */

    /* Define Huffman Tables */
    /* Define Quantization Tables */
    /* Define Restart Interval */
    /* Comment segment */
    /* App segment, driver will
    					* always use APP0 */
}

enum V4L2_JPEG_MARKER_DHT = 1 << 3;
enum V4L2_JPEG_MARKER_DQT = 1 << 4;
enum V4L2_JPEG_MARKER_DRI = 1 << 5;
enum V4L2_JPEG_MARKER_COM = 1 << 6;
enum V4L2_JPEG_MARKER_APP = 1 << 7;

/*
 *	M E M O R Y - M A P P I N G   B U F F E R S
 */
struct v4l2_requestbuffers {
    uint count;
    uint type; /* enum v4l2_buf_type */
    uint memory; /* enum v4l2_memory */
    uint[2] reserved;
}

/**
 * struct v4l2_plane - plane info for multi-planar buffers
 * @bytesused:		number of bytes occupied by data in the plane (payload)
 * @length:		size of this plane (NOT the payload) in bytes
 * @mem_offset:		when memory in the associated struct v4l2_buffer is
 *			V4L2_MEMORY_MMAP, equals the offset from the start of
 *			the device memory for this plane (or is a "cookie" that
 *			should be passed to mmap() called on the video node)
 * @userptr:		when memory is V4L2_MEMORY_USERPTR, a userspace pointer
 *			pointing to this plane
 * @fd:			when memory is V4L2_MEMORY_DMABUF, a userspace file
 *			descriptor associated with this plane
 * @data_offset:	offset in the plane to the start of data; usually 0,
 *			unless there is a header in front of the data
 *
 * Multi-planar buffers consist of one or more planes, e.g. an YCbCr buffer
 * with two planes can have one plane for Y, and another for interleaved CbCr
 * components. Each plane can reside in a separate memory buffer, or even in
 * a completely separate memory node (e.g. in embedded devices).
 */
struct v4l2_plane {
    uint bytesused;
    uint length;

    union _Anonymous_0 {
        uint mem_offset;
        c_ulong userptr;
        int fd;
    }

    _Anonymous_0 m;
    uint data_offset;
    uint[11] reserved;
}

/**
 * struct v4l2_buffer - video buffer info
 * @index:	id number of the buffer
 * @type:	enum v4l2_buf_type; buffer type (type == *_MPLANE for
 *		multiplanar buffers);
 * @bytesused:	number of bytes occupied by data in the buffer (payload);
 *		unused (set to 0) for multiplanar buffers
 * @flags:	buffer informational flags
 * @field:	enum v4l2_field; field order of the image in the buffer
 * @timestamp:	frame timestamp
 * @timecode:	frame timecode
 * @sequence:	sequence count of this frame
 * @memory:	enum v4l2_memory; the method, in which the actual video data is
 *		passed
 * @offset:	for non-multiplanar buffers with memory == V4L2_MEMORY_MMAP;
 *		offset from the start of the device memory for this plane,
 *		(or a "cookie" that should be passed to mmap() as offset)
 * @userptr:	for non-multiplanar buffers with memory == V4L2_MEMORY_USERPTR;
 *		a userspace pointer pointing to this buffer
 * @fd:		for non-multiplanar buffers with memory == V4L2_MEMORY_DMABUF;
 *		a userspace file descriptor associated with this buffer
 * @planes:	for multiplanar buffers; userspace pointer to the array of plane
 *		info structs for this buffer
 * @length:	size in bytes of the buffer (NOT its payload) for single-plane
 *		buffers (when type != *_MPLANE); number of elements in the
 *		planes array for multi-plane buffers
 *
 * Contains data exchanged by application and driver using one of the Streaming
 * I/O methods.
 */
struct v4l2_buffer {
    uint index;
    uint type;
    uint bytesused;
    uint flags;
    uint field;
    timeval timestamp;
    v4l2_timecode timecode;
    uint sequence;

    /* memory location */
    uint memory;

    union _Anonymous_1 {
        uint offset;
        c_ulong userptr;
        v4l2_plane* planes;
        int fd;
    }

    _Anonymous_1 m;
    uint length;
    uint reserved2;
    uint reserved;
}

/*  Flags for 'flags' field */
/* Buffer is mapped (flag) */
enum V4L2_BUF_FLAG_MAPPED = 0x00000001;
/* Buffer is queued for processing */
enum V4L2_BUF_FLAG_QUEUED = 0x00000002;
/* Buffer is ready */
enum V4L2_BUF_FLAG_DONE = 0x00000004;
/* Image is a keyframe (I-frame) */
enum V4L2_BUF_FLAG_KEYFRAME = 0x00000008;
/* Image is a P-frame */
enum V4L2_BUF_FLAG_PFRAME = 0x00000010;
/* Image is a B-frame */
enum V4L2_BUF_FLAG_BFRAME = 0x00000020;
/* Buffer is ready, but the data contained within is corrupted. */
enum V4L2_BUF_FLAG_ERROR = 0x00000040;
/* timecode field is valid */
enum V4L2_BUF_FLAG_TIMECODE = 0x00000100;
/* Buffer is prepared for queuing */
enum V4L2_BUF_FLAG_PREPARED = 0x00000400;
/* Cache handling flags */
enum V4L2_BUF_FLAG_NO_CACHE_INVALIDATE = 0x00000800;
enum V4L2_BUF_FLAG_NO_CACHE_CLEAN = 0x00001000;
/* Timestamp type */
enum V4L2_BUF_FLAG_TIMESTAMP_MASK = 0x0000e000;
enum V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN = 0x00000000;
enum V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC = 0x00002000;
enum V4L2_BUF_FLAG_TIMESTAMP_COPY = 0x00004000;
/* Timestamp sources. */
enum V4L2_BUF_FLAG_TSTAMP_SRC_MASK = 0x00070000;
enum V4L2_BUF_FLAG_TSTAMP_SRC_EOF = 0x00000000;
enum V4L2_BUF_FLAG_TSTAMP_SRC_SOE = 0x00010000;
/* mem2mem encoder/decoder */
enum V4L2_BUF_FLAG_LAST = 0x00100000;

/**
 * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
 *
 * @index:	id number of the buffer
 * @type:	enum v4l2_buf_type; buffer type (type == *_MPLANE for
 *		multiplanar buffers);
 * @plane:	index of the plane to be exported, 0 for single plane queues
 * @flags:	flags for newly created file, currently only O_CLOEXEC is
 *		supported, refer to manual of open syscall for more details
 * @fd:		file descriptor associated with DMABUF (set by driver)
 *
 * Contains data used for exporting a video buffer as DMABUF file descriptor.
 * The buffer is identified by a 'cookie' returned by VIDIOC_QUERYBUF
 * (identical to the cookie used to mmap() the buffer to userspace). All
 * reserved fields must be set to zero. The field reserved0 is expected to
 * become a structure 'type' allowing an alternative layout of the structure
 * content. Therefore this field should not be used for any other extensions.
 */
struct v4l2_exportbuffer {
    uint type; /* enum v4l2_buf_type */
    uint index;
    uint plane;
    uint flags;
    int fd;
    uint[11] reserved;
}

/*
 *	O V E R L A Y   P R E V I E W
 */
struct v4l2_framebuffer {
    uint capability;
    uint flags;
    /* FIXME: in theory we should pass something like PCI device + memory
     * region + offset instead of some physical address */
    void* base;

    /* enum v4l2_field */
    /* for padding, zero if unused */

    /* enum v4l2_colorspace */
    /* reserved field, set to 0 */
    struct _Anonymous_2 {
        uint width;
        uint height;
        uint pixelformat;
        uint field;
        uint bytesperline;
        uint sizeimage;
        uint colorspace;
        uint priv;
    }

    _Anonymous_2 fmt;
}

/*  Flags for the 'capability' field. Read only */
enum V4L2_FBUF_CAP_EXTERNOVERLAY = 0x0001;
enum V4L2_FBUF_CAP_CHROMAKEY = 0x0002;
enum V4L2_FBUF_CAP_LIST_CLIPPING = 0x0004;
enum V4L2_FBUF_CAP_BITMAP_CLIPPING = 0x0008;
enum V4L2_FBUF_CAP_LOCAL_ALPHA = 0x0010;
enum V4L2_FBUF_CAP_GLOBAL_ALPHA = 0x0020;
enum V4L2_FBUF_CAP_LOCAL_INV_ALPHA = 0x0040;
enum V4L2_FBUF_CAP_SRC_CHROMAKEY = 0x0080;
/*  Flags for the 'flags' field. */
enum V4L2_FBUF_FLAG_PRIMARY = 0x0001;
enum V4L2_FBUF_FLAG_OVERLAY = 0x0002;
enum V4L2_FBUF_FLAG_CHROMAKEY = 0x0004;
enum V4L2_FBUF_FLAG_LOCAL_ALPHA = 0x0008;
enum V4L2_FBUF_FLAG_GLOBAL_ALPHA = 0x0010;
enum V4L2_FBUF_FLAG_LOCAL_INV_ALPHA = 0x0020;
enum V4L2_FBUF_FLAG_SRC_CHROMAKEY = 0x0040;

struct v4l2_clip {
    v4l2_rect c;
    v4l2_clip* next;
}

struct v4l2_window {
    v4l2_rect w;
    uint field; /* enum v4l2_field */
    uint chromakey;
    v4l2_clip* clips;
    uint clipcount;
    void* bitmap;
    ubyte global_alpha;
}

/*
 *	C A P T U R E   P A R A M E T E R S
 */
struct v4l2_captureparm {
    uint capability; /*  Supported modes */
    uint capturemode; /*  Current mode */
    v4l2_fract timeperframe; /*  Time per frame in seconds */
    uint extendedmode; /*  Driver-specific extensions */
    uint readbuffers; /*  # of buffers for read */
    uint[4] reserved;
}

/*  Flags for 'capability' and 'capturemode' fields */
enum V4L2_MODE_HIGHQUALITY = 0x0001; /*  High quality imaging mode */
enum V4L2_CAP_TIMEPERFRAME = 0x1000; /*  timeperframe field is supported */

struct v4l2_outputparm {
    uint capability; /*  Supported modes */
    uint outputmode; /*  Current mode */
    v4l2_fract timeperframe; /*  Time per frame in seconds */
    uint extendedmode; /*  Driver-specific extensions */
    uint writebuffers; /*  # of buffers for write */
    uint[4] reserved;
}

/*
 *	I N P U T   I M A G E   C R O P P I N G
 */
struct v4l2_cropcap {
    uint type; /* enum v4l2_buf_type */
    v4l2_rect bounds;
    v4l2_rect defrect;
    v4l2_fract pixelaspect;
}

struct v4l2_crop {
    uint type; /* enum v4l2_buf_type */
    v4l2_rect c;
}

/**
 * struct v4l2_selection - selection info
 * @type:	buffer type (do not use *_MPLANE types)
 * @target:	Selection target, used to choose one of possible rectangles;
 *		defined in v4l2-common.h; V4L2_SEL_TGT_* .
 * @flags:	constraints flags, defined in v4l2-common.h; V4L2_SEL_FLAG_*.
 * @r:		coordinates of selection window
 * @reserved:	for future use, rounds structure size to 64 bytes, set to zero
 *
 * Hardware may use multiple helper windows to process a video stream.
 * The structure is used to exchange this selection areas between
 * an application and a driver.
 */
struct v4l2_selection {
    uint type;
    uint target;
    uint flags;
    v4l2_rect r;
    uint[9] reserved;
}

/*
 *      A N A L O G   V I D E O   S T A N D A R D
 */

alias v4l2_std_id = ulong;

/* one bit for each */
enum V4L2_STD_PAL_B = cast(v4l2_std_id) 0x00000001;
enum V4L2_STD_PAL_B1 = cast(v4l2_std_id) 0x00000002;
enum V4L2_STD_PAL_G = cast(v4l2_std_id) 0x00000004;
enum V4L2_STD_PAL_H = cast(v4l2_std_id) 0x00000008;
enum V4L2_STD_PAL_I = cast(v4l2_std_id) 0x00000010;
enum V4L2_STD_PAL_D = cast(v4l2_std_id) 0x00000020;
enum V4L2_STD_PAL_D1 = cast(v4l2_std_id) 0x00000040;
enum V4L2_STD_PAL_K = cast(v4l2_std_id) 0x00000080;

enum V4L2_STD_PAL_M = cast(v4l2_std_id) 0x00000100;
enum V4L2_STD_PAL_N = cast(v4l2_std_id) 0x00000200;
enum V4L2_STD_PAL_Nc = cast(v4l2_std_id) 0x00000400;
enum V4L2_STD_PAL_60 = cast(v4l2_std_id) 0x00000800;

enum V4L2_STD_NTSC_M = cast(v4l2_std_id) 0x00001000; /* BTSC */
enum V4L2_STD_NTSC_M_JP = cast(v4l2_std_id) 0x00002000; /* EIA-J */
enum V4L2_STD_NTSC_443 = cast(v4l2_std_id) 0x00004000;
enum V4L2_STD_NTSC_M_KR = cast(v4l2_std_id) 0x00008000; /* FM A2 */

enum V4L2_STD_SECAM_B = cast(v4l2_std_id) 0x00010000;
enum V4L2_STD_SECAM_D = cast(v4l2_std_id) 0x00020000;
enum V4L2_STD_SECAM_G = cast(v4l2_std_id) 0x00040000;
enum V4L2_STD_SECAM_H = cast(v4l2_std_id) 0x00080000;
enum V4L2_STD_SECAM_K = cast(v4l2_std_id) 0x00100000;
enum V4L2_STD_SECAM_K1 = cast(v4l2_std_id) 0x00200000;
enum V4L2_STD_SECAM_L = cast(v4l2_std_id) 0x00400000;
enum V4L2_STD_SECAM_LC = cast(v4l2_std_id) 0x00800000;

/* ATSC/HDTV */
enum V4L2_STD_ATSC_8_VSB = cast(v4l2_std_id) 0x01000000;
enum V4L2_STD_ATSC_16_VSB = cast(v4l2_std_id) 0x02000000;

/* FIXME:
   Although std_id is 64 bits, there is an issue on PPC32 architecture that
   makes switch(__u64) to break. So, there's a hack on v4l2-common.c rounding
   this value to 32 bits.
   As, currently, the max value is for V4L2_STD_ATSC_16_VSB (30 bits wide),
   it should work fine. However, if needed to add more than two standards,
   v4l2-common.c should be fixed.
 */

/*
 * Some macros to merge video standards in order to make live easier for the
 * drivers and V4L2 applications
 */

/*
 * "Common" NTSC/M - It should be noticed that V4L2_STD_NTSC_443 is
 * Missing here.
 */
enum V4L2_STD_NTSC = V4L2_STD_NTSC_M | V4L2_STD_NTSC_M_JP | V4L2_STD_NTSC_M_KR;
/* Secam macros */
enum V4L2_STD_SECAM_DK = V4L2_STD_SECAM_D | V4L2_STD_SECAM_K | V4L2_STD_SECAM_K1;
/* All Secam Standards */
enum V4L2_STD_SECAM = V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H
    | V4L2_STD_SECAM_DK | V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC;
/* PAL macros */
enum V4L2_STD_PAL_BG = V4L2_STD_PAL_B | V4L2_STD_PAL_B1 | V4L2_STD_PAL_G;
enum V4L2_STD_PAL_DK = V4L2_STD_PAL_D | V4L2_STD_PAL_D1 | V4L2_STD_PAL_K;
/*
 * "Common" PAL - This macro is there to be compatible with the old
 * V4L1 concept of "PAL": /BGDKHI.
 * Several PAL standards are missing here: /M, /N and /Nc
 */
enum V4L2_STD_PAL = V4L2_STD_PAL_BG | V4L2_STD_PAL_DK | V4L2_STD_PAL_H | V4L2_STD_PAL_I;
/* Chroma "agnostic" standards */
enum V4L2_STD_B = V4L2_STD_PAL_B | V4L2_STD_PAL_B1 | V4L2_STD_SECAM_B;
enum V4L2_STD_G = V4L2_STD_PAL_G | V4L2_STD_SECAM_G;
enum V4L2_STD_H = V4L2_STD_PAL_H | V4L2_STD_SECAM_H;
enum V4L2_STD_L = V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC;
enum V4L2_STD_GH = V4L2_STD_G | V4L2_STD_H;
enum V4L2_STD_DK = V4L2_STD_PAL_DK | V4L2_STD_SECAM_DK;
enum V4L2_STD_BG = V4L2_STD_B | V4L2_STD_G;
enum V4L2_STD_MN = V4L2_STD_PAL_M | V4L2_STD_PAL_N | V4L2_STD_PAL_Nc | V4L2_STD_NTSC;

/* Standards where MTS/BTSC stereo could be found */
enum V4L2_STD_MTS = V4L2_STD_NTSC_M | V4L2_STD_PAL_M | V4L2_STD_PAL_N | V4L2_STD_PAL_Nc;

/* Standards for Countries with 60Hz Line frequency */
enum V4L2_STD_525_60 = V4L2_STD_PAL_M | V4L2_STD_PAL_60 | V4L2_STD_NTSC | V4L2_STD_NTSC_443;
/* Standards for Countries with 50Hz Line frequency */
enum V4L2_STD_625_50 = V4L2_STD_PAL | V4L2_STD_PAL_N | V4L2_STD_PAL_Nc | V4L2_STD_SECAM;

enum V4L2_STD_ATSC = V4L2_STD_ATSC_8_VSB | V4L2_STD_ATSC_16_VSB;
/* Macros with none and all analog standards */
enum V4L2_STD_UNKNOWN = 0;
enum V4L2_STD_ALL = V4L2_STD_525_60 | V4L2_STD_625_50;

struct v4l2_standard {
    uint index;
    v4l2_std_id id;
    ubyte[24] name;
    v4l2_fract frameperiod; /* Frames, not fields */
    uint framelines;
    uint[4] reserved;
}

/*
 *	D V 	B T	T I M I N G S
 */

/** struct v4l2_bt_timings - BT.656/BT.1120 timing data
 * @width:	total width of the active video in pixels
 * @height:	total height of the active video in lines
 * @interlaced:	Interlaced or progressive
 * @polarities:	Positive or negative polarities
 * @pixelclock:	Pixel clock in HZ. Ex. 74.25MHz->74250000
 * @hfrontporch:Horizontal front porch in pixels
 * @hsync:	Horizontal Sync length in pixels
 * @hbackporch:	Horizontal back porch in pixels
 * @vfrontporch:Vertical front porch in lines
 * @vsync:	Vertical Sync length in lines
 * @vbackporch:	Vertical back porch in lines
 * @il_vfrontporch:Vertical front porch for the even field
 *		(aka field 2) of interlaced field formats
 * @il_vsync:	Vertical Sync length for the even field
 *		(aka field 2) of interlaced field formats
 * @il_vbackporch:Vertical back porch for the even field
 *		(aka field 2) of interlaced field formats
 * @standards:	Standards the timing belongs to
 * @flags:	Flags
 * @picture_aspect: The picture aspect ratio (hor/vert).
 * @cea861_vic:	VIC code as per the CEA-861 standard.
 * @hdmi_vic:	VIC code as per the HDMI standard.
 * @reserved:	Reserved fields, must be zeroed.
 *
 * A note regarding vertical interlaced timings: height refers to the total
 * height of the active video frame (= two fields). The blanking timings refer
 * to the blanking of each field. So the height of the total frame is
 * calculated as follows:
 *
 * tot_height = height + vfrontporch + vsync + vbackporch +
 *                       il_vfrontporch + il_vsync + il_vbackporch
 *
 * The active height of each field is height / 2.
 */
struct v4l2_bt_timings {
align(1):

    uint width;
    uint height;
    uint interlaced;
    uint polarities;
    ulong pixelclock;
    uint hfrontporch;
    uint hsync;
    uint hbackporch;
    uint vfrontporch;
    uint vsync;
    uint vbackporch;
    uint il_vfrontporch;
    uint il_vsync;
    uint il_vbackporch;
    uint standards;
    uint flags;
    v4l2_fract picture_aspect;
    ubyte cea861_vic;
    ubyte hdmi_vic;
    ubyte[46] reserved;
}

/* Interlaced or progressive format */
enum V4L2_DV_PROGRESSIVE = 0;
enum V4L2_DV_INTERLACED = 1;

/* Polarities. If bit is not set, it is assumed to be negative polarity */
enum V4L2_DV_VSYNC_POS_POL = 0x00000001;
enum V4L2_DV_HSYNC_POS_POL = 0x00000002;

/* Timings standards */
enum V4L2_DV_BT_STD_CEA861 = 1 << 0; /* CEA-861 Digital TV Profile */
enum V4L2_DV_BT_STD_DMT = 1 << 1; /* VESA Discrete Monitor Timings */
enum V4L2_DV_BT_STD_CVT = 1 << 2; /* VESA Coordinated Video Timings */
enum V4L2_DV_BT_STD_GTF = 1 << 3; /* VESA Generalized Timings Formula */
enum V4L2_DV_BT_STD_SDI = 1 << 4; /* SDI Timings */

/* Flags */

/*
 * CVT/GTF specific: timing uses reduced blanking (CVT) or the 'Secondary
 * GTF' curve (GTF). In both cases the horizontal and/or vertical blanking
 * intervals are reduced, allowing a higher resolution over the same
 * bandwidth. This is a read-only flag.
 */
enum V4L2_DV_FL_REDUCED_BLANKING = 1 << 0;
/*
 * CEA-861 specific: set for CEA-861 formats with a framerate of a multiple
 * of six. These formats can be optionally played at 1 / 1.001 speed.
 * This is a read-only flag.
 */
enum V4L2_DV_FL_CAN_REDUCE_FPS = 1 << 1;
/*
 * CEA-861 specific: only valid for video transmitters, the flag is cleared
 * by receivers.
 * If the framerate of the format is a multiple of six, then the pixelclock
 * used to set up the transmitter is divided by 1.001 to make it compatible
 * with 60 Hz based standards such as NTSC and PAL-M that use a framerate of
 * 29.97 Hz. Otherwise this flag is cleared. If the transmitter can't generate
 * such frequencies, then the flag will also be cleared.
 */
enum V4L2_DV_FL_REDUCED_FPS = 1 << 2;
/*
 * Specific to interlaced formats: if set, then field 1 is really one half-line
 * longer and field 2 is really one half-line shorter, so each field has
 * exactly the same number of half-lines. Whether half-lines can be detected
 * or used depends on the hardware.
 */
enum V4L2_DV_FL_HALF_LINE = 1 << 3;
/*
 * If set, then this is a Consumer Electronics (CE) video format. Such formats
 * differ from other formats (commonly called IT formats) in that if RGB
 * encoding is used then by default the RGB values use limited range (i.e.
 * use the range 16-235) as opposed to 0-255. All formats defined in CEA-861
 * except for the 640x480 format are CE formats.
 */
enum V4L2_DV_FL_IS_CE_VIDEO = 1 << 4;
/* Some formats like SMPTE-125M have an interlaced signal with a odd
 * total height. For these formats, if this flag is set, the first
 * field has the extra line. If not, it is the second field.
 */
enum V4L2_DV_FL_FIRST_FIELD_EXTRA_LINE = 1 << 5;
/*
 * If set, then the picture_aspect field is valid. Otherwise assume that the
 * pixels are square, so the picture aspect ratio is the same as the width to
 * height ratio.
 */
enum V4L2_DV_FL_HAS_PICTURE_ASPECT = 1 << 6;
/*
 * If set, then the cea861_vic field is valid and contains the Video
 * Identification Code as per the CEA-861 standard.
 */
enum V4L2_DV_FL_HAS_CEA861_VIC = 1 << 7;
/*
 * If set, then the hdmi_vic field is valid and contains the Video
 * Identification Code as per the HDMI standard (HDMI Vendor Specific
 * InfoFrame).
 */
enum V4L2_DV_FL_HAS_HDMI_VIC = 1 << 8;

/* A few useful defines to calculate the total blanking and frame sizes */
extern (D) auto V4L2_DV_BT_BLANKING_WIDTH(T)(auto ref T bt) {
    return bt.hfrontporch + bt.hsync + bt.hbackporch;
}

extern (D) auto V4L2_DV_BT_FRAME_WIDTH(T)(auto ref T bt) {
    return bt.width + V4L2_DV_BT_BLANKING_WIDTH(bt);
}

extern (D) auto V4L2_DV_BT_BLANKING_HEIGHT(T)(auto ref T bt) {
    return bt.vfrontporch + bt.vsync + bt.vbackporch + bt.il_vfrontporch
        + bt.il_vsync + bt.il_vbackporch;
}

extern (D) auto V4L2_DV_BT_FRAME_HEIGHT(T)(auto ref T bt) {
    return bt.height + V4L2_DV_BT_BLANKING_HEIGHT(bt);
}

/** struct v4l2_dv_timings - DV timings
 * @type:	the type of the timings
 * @bt:	BT656/1120 timings
 */
struct v4l2_dv_timings {
align(1):

    uint type;

    union {
        v4l2_bt_timings bt;
        uint[32] reserved;
    }
}

/* Values for the type field */
enum V4L2_DV_BT_656_1120 = 0; /* BT.656/1120 timing type */

/** struct v4l2_enum_dv_timings - DV timings enumeration
 * @index:	enumeration index
 * @pad:	the pad number for which to enumerate timings (used with
 *		v4l-subdev nodes only)
 * @reserved:	must be zeroed
 * @timings:	the timings for the given index
 */
struct v4l2_enum_dv_timings {
    uint index;
    uint pad;
    uint[2] reserved;
    v4l2_dv_timings timings;
}

/** struct v4l2_bt_timings_cap - BT.656/BT.1120 timing capabilities
 * @min_width:		width in pixels
 * @max_width:		width in pixels
 * @min_height:		height in lines
 * @max_height:		height in lines
 * @min_pixelclock:	Pixel clock in HZ. Ex. 74.25MHz->74250000
 * @max_pixelclock:	Pixel clock in HZ. Ex. 74.25MHz->74250000
 * @standards:		Supported standards
 * @capabilities:	Supported capabilities
 * @reserved:		Must be zeroed
 */
struct v4l2_bt_timings_cap {
align(1):

    uint min_width;
    uint max_width;
    uint min_height;
    uint max_height;
    ulong min_pixelclock;
    ulong max_pixelclock;
    uint standards;
    uint capabilities;
    uint[16] reserved;
}

/* Supports interlaced formats */
enum V4L2_DV_BT_CAP_INTERLACED = 1 << 0;
/* Supports progressive formats */
enum V4L2_DV_BT_CAP_PROGRESSIVE = 1 << 1;
/* Supports CVT/GTF reduced blanking */
enum V4L2_DV_BT_CAP_REDUCED_BLANKING = 1 << 2;
/* Supports custom formats */
enum V4L2_DV_BT_CAP_CUSTOM = 1 << 3;

/** struct v4l2_dv_timings_cap - DV timings capabilities
 * @type:	the type of the timings (same as in struct v4l2_dv_timings)
 * @pad:	the pad number for which to query capabilities (used with
 *		v4l-subdev nodes only)
 * @bt:		the BT656/1120 timings capabilities
 */
struct v4l2_dv_timings_cap {
    uint type;
    uint pad;
    uint[2] reserved;

    union {
        v4l2_bt_timings_cap bt;
        uint[32] raw_data;
    }
}

/*
 *	V I D E O   I N P U T S
 */
struct v4l2_input {
    uint index; /*  Which input */
    ubyte[32] name; /*  Label */
    uint type; /*  Type of input */
    uint audioset; /*  Associated audios (bitfield) */
    uint tuner; /*  enum v4l2_tuner_type */
    v4l2_std_id std;
    uint status;
    uint capabilities;
    uint[3] reserved;
}

/*  Values for the 'type' field */
enum V4L2_INPUT_TYPE_TUNER = 1;
enum V4L2_INPUT_TYPE_CAMERA = 2;
enum V4L2_INPUT_TYPE_TOUCH = 3;

/* field 'status' - general */
enum V4L2_IN_ST_NO_POWER = 0x00000001; /* Attached device is off */
enum V4L2_IN_ST_NO_SIGNAL = 0x00000002;
enum V4L2_IN_ST_NO_COLOR = 0x00000004;

/* field 'status' - sensor orientation */
/* If sensor is mounted upside down set both bits */
enum V4L2_IN_ST_HFLIP = 0x00000010; /* Frames are flipped horizontally */
enum V4L2_IN_ST_VFLIP = 0x00000020; /* Frames are flipped vertically */

/* field 'status' - analog */
enum V4L2_IN_ST_NO_H_LOCK = 0x00000100; /* No horizontal sync lock */
enum V4L2_IN_ST_COLOR_KILL = 0x00000200; /* Color killer is active */
enum V4L2_IN_ST_NO_V_LOCK = 0x00000400; /* No vertical sync lock */
enum V4L2_IN_ST_NO_STD_LOCK = 0x00000800; /* No standard format lock */

/* field 'status' - digital */
enum V4L2_IN_ST_NO_SYNC = 0x00010000; /* No synchronization lock */
enum V4L2_IN_ST_NO_EQU = 0x00020000; /* No equalizer lock */
enum V4L2_IN_ST_NO_CARRIER = 0x00040000; /* Carrier recovery failed */

/* field 'status' - VCR and set-top box */
enum V4L2_IN_ST_MACROVISION = 0x01000000; /* Macrovision detected */
enum V4L2_IN_ST_NO_ACCESS = 0x02000000; /* Conditional access denied */
enum V4L2_IN_ST_VTR = 0x04000000; /* VTR time constant */

/* capabilities flags */
enum V4L2_IN_CAP_DV_TIMINGS = 0x00000002; /* Supports S_DV_TIMINGS */
enum V4L2_IN_CAP_CUSTOM_TIMINGS = V4L2_IN_CAP_DV_TIMINGS; /* For compatibility */
enum V4L2_IN_CAP_STD = 0x00000004; /* Supports S_STD */
enum V4L2_IN_CAP_NATIVE_SIZE = 0x00000008; /* Supports setting native size */

/*
 *	V I D E O   O U T P U T S
 */
struct v4l2_output {
    uint index; /*  Which output */
    ubyte[32] name; /*  Label */
    uint type; /*  Type of output */
    uint audioset; /*  Associated audios (bitfield) */
    uint modulator; /*  Associated modulator */
    v4l2_std_id std;
    uint capabilities;
    uint[3] reserved;
}

/*  Values for the 'type' field */
enum V4L2_OUTPUT_TYPE_MODULATOR = 1;
enum V4L2_OUTPUT_TYPE_ANALOG = 2;
enum V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY = 3;

/* capabilities flags */
enum V4L2_OUT_CAP_DV_TIMINGS = 0x00000002; /* Supports S_DV_TIMINGS */
enum V4L2_OUT_CAP_CUSTOM_TIMINGS = V4L2_OUT_CAP_DV_TIMINGS; /* For compatibility */
enum V4L2_OUT_CAP_STD = 0x00000004; /* Supports S_STD */
enum V4L2_OUT_CAP_NATIVE_SIZE = 0x00000008; /* Supports setting native size */

/*
 *	C O N T R O L S
 */
struct v4l2_control {
    uint id;
    int value;
}

struct v4l2_ext_control {
align(1):

    uint id;
    uint size;
    uint[1] reserved2;

    union {
        int value;
        long value64;
        char* string;
        ubyte* p_u8;
        ushort* p_u16;
        uint* p_u32;
        void* ptr;
    }
}

struct v4l2_ext_controls {
    union {
        uint ctrl_class;
        uint which;
    }

    uint count;
    uint error_idx;
    uint[2] reserved;
    v4l2_ext_control* controls;
}

enum V4L2_CTRL_ID_MASK = 0x0fffffff;

extern (D) auto V4L2_CTRL_ID2CLASS(T)(auto ref T id) {
    return id & 0x0fff0000UL;
}

extern (D) auto V4L2_CTRL_ID2WHICH(T)(auto ref T id) {
    return id & 0x0fff0000UL;
}

extern (D) auto V4L2_CTRL_DRIVER_PRIV(T)(auto ref T id) {
    return (id & 0xffff) >= 0x1000;
}

enum V4L2_CTRL_MAX_DIMS = 4;
enum V4L2_CTRL_WHICH_CUR_VAL = 0;
enum V4L2_CTRL_WHICH_DEF_VAL = 0x0f000000;

enum v4l2_ctrl_type {
    V4L2_CTRL_TYPE_INTEGER = 1,
    V4L2_CTRL_TYPE_BOOLEAN = 2,
    V4L2_CTRL_TYPE_MENU = 3,
    V4L2_CTRL_TYPE_BUTTON = 4,
    V4L2_CTRL_TYPE_INTEGER64 = 5,
    V4L2_CTRL_TYPE_CTRL_CLASS = 6,
    V4L2_CTRL_TYPE_STRING = 7,
    V4L2_CTRL_TYPE_BITMASK = 8,
    V4L2_CTRL_TYPE_INTEGER_MENU = 9,

    /* Compound types are >= 0x0100 */
    V4L2_CTRL_COMPOUND_TYPES = 0x0100,
    V4L2_CTRL_TYPE_U8 = 0x0100,
    V4L2_CTRL_TYPE_U16 = 0x0101,
    V4L2_CTRL_TYPE_U32 = 0x0102
}

/*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
struct v4l2_queryctrl {
    uint id;
    uint type; /* enum v4l2_ctrl_type */
    ubyte[32] name; /* Whatever */
    int minimum; /* Note signedness */
    int maximum;
    int step;
    int default_value;
    uint flags;
    uint[2] reserved;
}

/*  Used in the VIDIOC_QUERY_EXT_CTRL ioctl for querying extended controls */
struct v4l2_query_ext_ctrl {
    uint id;
    uint type;
    char[32] name;
    long minimum;
    long maximum;
    ulong step;
    long default_value;
    uint flags;
    uint elem_size;
    uint elems;
    uint nr_of_dims;
    uint[4] dims;
    uint[32] reserved;
}

/*  Used in the VIDIOC_QUERYMENU ioctl for querying menu items */
struct v4l2_querymenu {
align(1):

    uint id;
    uint index;

    union {
        ubyte[32] name; /* Whatever */
        long value;
    }

    uint reserved;
}

/*  Control flags  */
enum V4L2_CTRL_FLAG_DISABLED = 0x0001;
enum V4L2_CTRL_FLAG_GRABBED = 0x0002;
enum V4L2_CTRL_FLAG_READ_ONLY = 0x0004;
enum V4L2_CTRL_FLAG_UPDATE = 0x0008;
enum V4L2_CTRL_FLAG_INACTIVE = 0x0010;
enum V4L2_CTRL_FLAG_SLIDER = 0x0020;
enum V4L2_CTRL_FLAG_WRITE_ONLY = 0x0040;
enum V4L2_CTRL_FLAG_VOLATILE = 0x0080;
enum V4L2_CTRL_FLAG_HAS_PAYLOAD = 0x0100;
enum V4L2_CTRL_FLAG_EXECUTE_ON_WRITE = 0x0200;
enum V4L2_CTRL_FLAG_MODIFY_LAYOUT = 0x0400;

/*  Query flags, to be ORed with the control ID */
enum V4L2_CTRL_FLAG_NEXT_CTRL = 0x80000000;
enum V4L2_CTRL_FLAG_NEXT_COMPOUND = 0x40000000;

/*  User-class control IDs defined by V4L2 */
enum V4L2_CID_MAX_CTRLS = 1024;
/*  IDs reserved for driver specific controls */
enum V4L2_CID_PRIVATE_BASE = 0x08000000;

/*
 *	T U N I N G
 */
struct v4l2_tuner {
    uint index;
    ubyte[32] name;
    uint type; /* enum v4l2_tuner_type */
    uint capability;
    uint rangelow;
    uint rangehigh;
    uint rxsubchans;
    uint audmode;
    int signal;
    int afc;
    uint[4] reserved;
}

struct v4l2_modulator {
    uint index;
    ubyte[32] name;
    uint capability;
    uint rangelow;
    uint rangehigh;
    uint txsubchans;
    uint type; /* enum v4l2_tuner_type */
    uint[3] reserved;
}

/*  Flags for the 'capability' field */
enum V4L2_TUNER_CAP_LOW = 0x0001;
enum V4L2_TUNER_CAP_NORM = 0x0002;
enum V4L2_TUNER_CAP_HWSEEK_BOUNDED = 0x0004;
enum V4L2_TUNER_CAP_HWSEEK_WRAP = 0x0008;
enum V4L2_TUNER_CAP_STEREO = 0x0010;
enum V4L2_TUNER_CAP_LANG2 = 0x0020;
enum V4L2_TUNER_CAP_SAP = 0x0020;
enum V4L2_TUNER_CAP_LANG1 = 0x0040;
enum V4L2_TUNER_CAP_RDS = 0x0080;
enum V4L2_TUNER_CAP_RDS_BLOCK_IO = 0x0100;
enum V4L2_TUNER_CAP_RDS_CONTROLS = 0x0200;
enum V4L2_TUNER_CAP_FREQ_BANDS = 0x0400;
enum V4L2_TUNER_CAP_HWSEEK_PROG_LIM = 0x0800;
enum V4L2_TUNER_CAP_1HZ = 0x1000;

/*  Flags for the 'rxsubchans' field */
enum V4L2_TUNER_SUB_MONO = 0x0001;
enum V4L2_TUNER_SUB_STEREO = 0x0002;
enum V4L2_TUNER_SUB_LANG2 = 0x0004;
enum V4L2_TUNER_SUB_SAP = 0x0004;
enum V4L2_TUNER_SUB_LANG1 = 0x0008;
enum V4L2_TUNER_SUB_RDS = 0x0010;

/*  Values for the 'audmode' field */
enum V4L2_TUNER_MODE_MONO = 0x0000;
enum V4L2_TUNER_MODE_STEREO = 0x0001;
enum V4L2_TUNER_MODE_LANG2 = 0x0002;
enum V4L2_TUNER_MODE_SAP = 0x0002;
enum V4L2_TUNER_MODE_LANG1 = 0x0003;
enum V4L2_TUNER_MODE_LANG1_LANG2 = 0x0004;

struct v4l2_frequency {
    uint tuner;
    uint type; /* enum v4l2_tuner_type */
    uint frequency;
    uint[8] reserved;
}

enum V4L2_BAND_MODULATION_VSB = 1 << 1;
enum V4L2_BAND_MODULATION_FM = 1 << 2;
enum V4L2_BAND_MODULATION_AM = 1 << 3;

struct v4l2_frequency_band {
    uint tuner;
    uint type; /* enum v4l2_tuner_type */
    uint index;
    uint capability;
    uint rangelow;
    uint rangehigh;
    uint modulation;
    uint[9] reserved;
}

struct v4l2_hw_freq_seek {
    uint tuner;
    uint type; /* enum v4l2_tuner_type */
    uint seek_upward;
    uint wrap_around;
    uint spacing;
    uint rangelow;
    uint rangehigh;
    uint[5] reserved;
}

/*
 *	R D S
 */

struct v4l2_rds_data {
align(1):

    ubyte lsb;
    ubyte msb;
    ubyte block;
}

enum V4L2_RDS_BLOCK_MSK = 0x7;
enum V4L2_RDS_BLOCK_A = 0;
enum V4L2_RDS_BLOCK_B = 1;
enum V4L2_RDS_BLOCK_C = 2;
enum V4L2_RDS_BLOCK_D = 3;
enum V4L2_RDS_BLOCK_C_ALT = 4;
enum V4L2_RDS_BLOCK_INVALID = 7;

enum V4L2_RDS_BLOCK_CORRECTED = 0x40;
enum V4L2_RDS_BLOCK_ERROR = 0x80;

/*
 *	A U D I O
 */
struct v4l2_audio {
    uint index;
    ubyte[32] name;
    uint capability;
    uint mode;
    uint[2] reserved;
}

/*  Flags for the 'capability' field */
enum V4L2_AUDCAP_STEREO = 0x00001;
enum V4L2_AUDCAP_AVL = 0x00002;

/*  Flags for the 'mode' field */
enum V4L2_AUDMODE_AVL = 0x00001;

struct v4l2_audioout {
    uint index;
    ubyte[32] name;
    uint capability;
    uint mode;
    uint[2] reserved;
}

/*
 *	M P E G   S E R V I C E S
 */

enum V4L2_ENC_IDX_FRAME_I = 0;
enum V4L2_ENC_IDX_FRAME_P = 1;
enum V4L2_ENC_IDX_FRAME_B = 2;
enum V4L2_ENC_IDX_FRAME_MASK = 0xf;

struct v4l2_enc_idx_entry {
    ulong offset;
    ulong pts;
    uint length;
    uint flags;
    uint[2] reserved;
}

enum V4L2_ENC_IDX_ENTRIES = 64;

struct v4l2_enc_idx {
    uint entries;
    uint entries_cap;
    uint[4] reserved;
    v4l2_enc_idx_entry[64] entry;
}

enum V4L2_ENC_CMD_START = 0;
enum V4L2_ENC_CMD_STOP = 1;
enum V4L2_ENC_CMD_PAUSE = 2;
enum V4L2_ENC_CMD_RESUME = 3;

/* Flags for V4L2_ENC_CMD_STOP */
enum V4L2_ENC_CMD_STOP_AT_GOP_END = 1 << 0;

struct v4l2_encoder_cmd {
    uint cmd;
    uint flags;

    union {
        struct _Anonymous_3 {
            uint[8] data;
        }

        _Anonymous_3 raw;
    }
}

/* Decoder commands */
enum V4L2_DEC_CMD_START = 0;
enum V4L2_DEC_CMD_STOP = 1;
enum V4L2_DEC_CMD_PAUSE = 2;
enum V4L2_DEC_CMD_RESUME = 3;

/* Flags for V4L2_DEC_CMD_START */
enum V4L2_DEC_CMD_START_MUTE_AUDIO = 1 << 0;

/* Flags for V4L2_DEC_CMD_PAUSE */
enum V4L2_DEC_CMD_PAUSE_TO_BLACK = 1 << 0;

/* Flags for V4L2_DEC_CMD_STOP */
enum V4L2_DEC_CMD_STOP_TO_BLACK = 1 << 0;
enum V4L2_DEC_CMD_STOP_IMMEDIATELY = 1 << 1;

/* Play format requirements (returned by the driver): */

/* The decoder has no special format requirements */
enum V4L2_DEC_START_FMT_NONE = 0;
/* The decoder requires full GOPs */
enum V4L2_DEC_START_FMT_GOP = 1;

/* The structure must be zeroed before use by the application
   This ensures it can be extended safely in the future. */
struct v4l2_decoder_cmd {
    uint cmd;
    uint flags;

    union {
        struct _Anonymous_4 {
            ulong pts;
        }

        _Anonymous_4 stop;

        /* 0 or 1000 specifies normal speed,
        			   1 specifies forward single stepping,
        			   -1 specifies backward single stepping,
        			   >1: playback at speed/1000 of the normal speed,
        			   <-1: reverse playback at (-speed/1000) of the normal speed. */
        struct _Anonymous_5 {
            int speed;
            uint format;
        }

        _Anonymous_5 start;

        struct _Anonymous_6 {
            uint[16] data;
        }

        _Anonymous_6 raw;
    }
}

/*
 *	D A T A   S E R V I C E S   ( V B I )
 *
 *	Data services API by Michael Schimek
 */

/* Raw VBI */
struct v4l2_vbi_format {
    uint sampling_rate; /* in 1 Hz */
    uint offset;
    uint samples_per_line;
    uint sample_format; /* V4L2_PIX_FMT_* */
    int[2] start;
    uint[2] count;
    uint flags; /* V4L2_VBI_* */
    uint[2] reserved; /* must be zero */
}

/*  VBI flags  */
enum V4L2_VBI_UNSYNC = 1 << 0;
enum V4L2_VBI_INTERLACED = 1 << 1;

/* ITU-R start lines for each field */
enum V4L2_VBI_ITU_525_F1_START = 1;
enum V4L2_VBI_ITU_525_F2_START = 264;
enum V4L2_VBI_ITU_625_F1_START = 1;
enum V4L2_VBI_ITU_625_F2_START = 314;

/* Sliced VBI
 *
 *    This implements is a proposal V4L2 API to allow SLICED VBI
 * required for some hardware encoders. It should change without
 * notice in the definitive implementation.
 */

struct v4l2_sliced_vbi_format {
    ushort service_set;
    /* service_lines[0][...] specifies lines 0-23 (1-23 used) of the first field
    	   service_lines[1][...] specifies lines 0-23 (1-23 used) of the second field
    				 (equals frame lines 313-336 for 625 line video
    				  standards, 263-286 for 525 line standards) */
    ushort[24][2] service_lines;
    uint io_size;
    uint[2] reserved; /* must be zero */
}

/* Teletext World System Teletext
   (WST), defined on ITU-R BT.653-2 */
enum V4L2_SLICED_TELETEXT_B = 0x0001;
/* Video Program System, defined on ETS 300 231*/
enum V4L2_SLICED_VPS = 0x0400;
/* Closed Caption, defined on EIA-608 */
enum V4L2_SLICED_CAPTION_525 = 0x1000;
/* Wide Screen System, defined on ITU-R BT1119.1 */
enum V4L2_SLICED_WSS_625 = 0x4000;

enum V4L2_SLICED_VBI_525 = V4L2_SLICED_CAPTION_525;
enum V4L2_SLICED_VBI_625 = V4L2_SLICED_TELETEXT_B | V4L2_SLICED_VPS | V4L2_SLICED_WSS_625;

struct v4l2_sliced_vbi_cap {
    ushort service_set;
    /* service_lines[0][...] specifies lines 0-23 (1-23 used) of the first field
    	   service_lines[1][...] specifies lines 0-23 (1-23 used) of the second field
    				 (equals frame lines 313-336 for 625 line video
    				  standards, 263-286 for 525 line standards) */
    ushort[24][2] service_lines;
    uint type; /* enum v4l2_buf_type */
    uint[3] reserved; /* must be 0 */
}

struct v4l2_sliced_vbi_data {
    uint id;
    uint field; /* 0: first field, 1: second field */
    uint line; /* 1-23 */
    uint reserved; /* must be 0 */
    ubyte[48] data;
}

/*
 * Sliced VBI data inserted into MPEG Streams
 */

/*
 * V4L2_MPEG_STREAM_VBI_FMT_IVTV:
 *
 * Structure of payload contained in an MPEG 2 Private Stream 1 PES Packet in an
 * MPEG-2 Program Pack that contains V4L2_MPEG_STREAM_VBI_FMT_IVTV Sliced VBI
 * data
 *
 * Note, the MPEG-2 Program Pack and Private Stream 1 PES packet header
 * definitions are not included here.  See the MPEG-2 specifications for details
 * on these headers.
 */

/* Line type IDs */
enum V4L2_MPEG_VBI_IVTV_TELETEXT_B = 1;
enum V4L2_MPEG_VBI_IVTV_CAPTION_525 = 4;
enum V4L2_MPEG_VBI_IVTV_WSS_625 = 5;
enum V4L2_MPEG_VBI_IVTV_VPS = 7;

struct v4l2_mpeg_vbi_itv0_line {
align(1):

    ubyte id; /* One of V4L2_MPEG_VBI_IVTV_* above */
    ubyte[42] data; /* Sliced VBI data for the line */
}

struct v4l2_mpeg_vbi_itv0 {
align(1):

    __le32[2] linemask; /* Bitmasks of VBI service lines present */
    v4l2_mpeg_vbi_itv0_line[35] line;
}

struct v4l2_mpeg_vbi_ITV0 {
align(1):

    v4l2_mpeg_vbi_itv0_line[36] line;
}

enum V4L2_MPEG_VBI_IVTV_MAGIC0 = "itv0";
enum V4L2_MPEG_VBI_IVTV_MAGIC1 = "ITV0";

struct v4l2_mpeg_vbi_fmt_ivtv {
align(1):

    ubyte[4] magic;

    union {
        v4l2_mpeg_vbi_itv0 itv0;
        v4l2_mpeg_vbi_ITV0 ITV0;
    }
}

/*
 *	A G G R E G A T E   S T R U C T U R E S
 */

/**
 * struct v4l2_plane_pix_format - additional, per-plane format definition
 * @sizeimage:		maximum size in bytes required for data, for which
 *			this plane will be used
 * @bytesperline:	distance in bytes between the leftmost pixels in two
 *			adjacent lines
 */
struct v4l2_plane_pix_format {
align(1):

    uint sizeimage;
    uint bytesperline;
    ushort[6] reserved;
}

/**
 * struct v4l2_pix_format_mplane - multiplanar format definition
 * @width:		image width in pixels
 * @height:		image height in pixels
 * @pixelformat:	little endian four character code (fourcc)
 * @field:		enum v4l2_field; field order (for interlaced video)
 * @colorspace:		enum v4l2_colorspace; supplemental to pixelformat
 * @plane_fmt:		per-plane information
 * @num_planes:		number of planes for this format
 * @flags:		format flags (V4L2_PIX_FMT_FLAG_*)
 * @ycbcr_enc:		enum v4l2_ycbcr_encoding, Y'CbCr encoding
 * @quantization:	enum v4l2_quantization, colorspace quantization
 * @xfer_func:		enum v4l2_xfer_func, colorspace transfer function
 */
struct v4l2_pix_format_mplane {
align(1):

    uint width;
    uint height;
    uint pixelformat;
    uint field;
    uint colorspace;

    v4l2_plane_pix_format[VIDEO_MAX_PLANES] plane_fmt;
    ubyte num_planes;
    ubyte flags;

    union {
        ubyte ycbcr_enc;
        ubyte hsv_enc;
    }

    ubyte quantization;
    ubyte xfer_func;
    ubyte[7] reserved;
}

/**
 * struct v4l2_sdr_format - SDR format definition
 * @pixelformat:	little endian four character code (fourcc)
 * @buffersize:		maximum size in bytes required for data
 */
struct v4l2_sdr_format {
align(1):

    uint pixelformat;
    uint buffersize;
    ubyte[24] reserved;
}

/**
 * struct v4l2_meta_format - metadata format definition
 * @dataformat:		little endian four character code (fourcc)
 * @buffersize:		maximum size in bytes required for data
 */
struct v4l2_meta_format {
align(1):

    uint dataformat;
    uint buffersize;
}

/**
 * struct v4l2_format - stream data format
 * @type:	enum v4l2_buf_type; type of the data stream
 * @pix:	definition of an image format
 * @pix_mp:	definition of a multiplanar image format
 * @win:	definition of an overlaid image
 * @vbi:	raw VBI capture or output parameters
 * @sliced:	sliced VBI capture or output parameters
 * @raw_data:	placeholder for future extensions and custom formats
 */
struct v4l2_format {
    uint type;

    /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
    /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
    /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
    /* V4L2_BUF_TYPE_VBI_CAPTURE */
    /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
    /* V4L2_BUF_TYPE_SDR_CAPTURE */
    /* V4L2_BUF_TYPE_META_CAPTURE */
    /* user-defined */
    union _Anonymous_7 {
        v4l2_pix_format pix;
        v4l2_pix_format_mplane pix_mp;
        v4l2_window win;
        v4l2_vbi_format vbi;
        v4l2_sliced_vbi_format sliced;
        v4l2_sdr_format sdr;
        v4l2_meta_format meta;
        ubyte[200] raw_data;
    }

    _Anonymous_7 fmt;
}

/*	Stream type-dependent parameters
 */
struct v4l2_streamparm {
    uint type; /* enum v4l2_buf_type */

    /* user-defined */
    union _Anonymous_8 {
        v4l2_captureparm capture;
        v4l2_outputparm output;
        ubyte[200] raw_data;
    }

    _Anonymous_8 parm;
}

/*
 *	E V E N T S
 */

enum V4L2_EVENT_ALL = 0;
enum V4L2_EVENT_VSYNC = 1;
enum V4L2_EVENT_EOS = 2;
enum V4L2_EVENT_CTRL = 3;
enum V4L2_EVENT_FRAME_SYNC = 4;
enum V4L2_EVENT_SOURCE_CHANGE = 5;
enum V4L2_EVENT_MOTION_DET = 6;
enum V4L2_EVENT_PRIVATE_START = 0x08000000;

/* Payload for V4L2_EVENT_VSYNC */
struct v4l2_event_vsync {
align(1):

    /* Can be V4L2_FIELD_ANY, _NONE, _TOP or _BOTTOM */
    ubyte field;
}

/* Payload for V4L2_EVENT_CTRL */
enum V4L2_EVENT_CTRL_CH_VALUE = 1 << 0;
enum V4L2_EVENT_CTRL_CH_FLAGS = 1 << 1;
enum V4L2_EVENT_CTRL_CH_RANGE = 1 << 2;

struct v4l2_event_ctrl {
    uint changes;
    uint type;

    union {
        int value;
        long value64;
    }

    uint flags;
    int minimum;
    int maximum;
    int step;
    int default_value;
}

struct v4l2_event_frame_sync {
    uint frame_sequence;
}

enum V4L2_EVENT_SRC_CH_RESOLUTION = 1 << 0;

struct v4l2_event_src_change {
    uint changes;
}

enum V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ = 1 << 0;

/**
 * struct v4l2_event_motion_det - motion detection event
 * @flags:             if V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ is set, then the
 *                     frame_sequence field is valid.
 * @frame_sequence:    the frame sequence number associated with this event.
 * @region_mask:       which regions detected motion.
 */
struct v4l2_event_motion_det {
    uint flags;
    uint frame_sequence;
    uint region_mask;
}

struct v4l2_event {
    uint type;

    union _Anonymous_9 {
        v4l2_event_vsync vsync;
        v4l2_event_ctrl ctrl;
        v4l2_event_frame_sync frame_sync;
        v4l2_event_src_change src_change;
        v4l2_event_motion_det motion_det;
        ubyte[64] data;
    }

    _Anonymous_9 u;
    uint pending;
    uint sequence;
    timespec timestamp;
    uint id;
    uint[8] reserved;
}

enum V4L2_EVENT_SUB_FL_SEND_INITIAL = 1 << 0;
enum V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK = 1 << 1;

struct v4l2_event_subscription {
    uint type;
    uint id;
    uint flags;
    uint[5] reserved;
}

/*
 *	A D V A N C E D   D E B U G G I N G
 *
 *	NOTE: EXPERIMENTAL API, NEVER RELY ON THIS IN APPLICATIONS!
 *	FOR DEBUGGING, TESTING AND INTERNAL USE ONLY!
 */

/* VIDIOC_DBG_G_REGISTER and VIDIOC_DBG_S_REGISTER */

enum V4L2_CHIP_MATCH_BRIDGE = 0; /* Match against chip ID on the bridge (0 for the bridge) */
enum V4L2_CHIP_MATCH_SUBDEV = 4; /* Match against subdev index */

/* The following four defines are no longer in use */
enum V4L2_CHIP_MATCH_HOST = V4L2_CHIP_MATCH_BRIDGE;
enum V4L2_CHIP_MATCH_I2C_DRIVER = 1; /* Match against I2C driver name */
enum V4L2_CHIP_MATCH_I2C_ADDR = 2; /* Match against I2C 7-bit address */
enum V4L2_CHIP_MATCH_AC97 = 3; /* Match against ancillary AC97 chip */

struct v4l2_dbg_match {
align(1):

    uint type; /* Match type */
    union {
        /* Match this chip, meaning determined by type */
        uint addr;
        char[32] name;
    }
}

struct v4l2_dbg_register {
align(1):

    v4l2_dbg_match match;
    uint size; /* register size in bytes */
    ulong reg;
    ulong val;
}

enum V4L2_CHIP_FL_READABLE = 1 << 0;
enum V4L2_CHIP_FL_WRITABLE = 1 << 1;

/* VIDIOC_DBG_G_CHIP_INFO */
struct v4l2_dbg_chip_info {
align(1):

    v4l2_dbg_match match;
    char[32] name;
    uint flags;
    uint[32] reserved;
}

/**
 * struct v4l2_create_buffers - VIDIOC_CREATE_BUFS argument
 * @index:	on return, index of the first created buffer
 * @count:	entry: number of requested buffers,
 *		return: number of created buffers
 * @memory:	enum v4l2_memory; buffer memory type
 * @format:	frame format, for which buffers are requested
 * @reserved:	future extensions
 */
struct v4l2_create_buffers {
    uint index;
    uint count;
    uint memory;
    v4l2_format format;
    uint[8] reserved;
}

/*
 *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
 *
 */
enum VIDIOC_QUERYCAP = _IOR!v4l2_capability('V', 0);
enum VIDIOC_RESERVED = _IO('V', 1);
enum VIDIOC_ENUM_FMT = _IOWR!v4l2_fmtdesc('V', 2);
enum VIDIOC_G_FMT = _IOWR!v4l2_format('V', 4);
enum VIDIOC_S_FMT = _IOWR!v4l2_format('V', 5);
enum VIDIOC_REQBUFS = _IOWR!v4l2_requestbuffers('V', 8);
enum VIDIOC_QUERYBUF = _IOWR!v4l2_buffer('V', 9);
enum VIDIOC_G_FBUF = _IOR!v4l2_framebuffer('V', 10);
enum VIDIOC_S_FBUF = _IOW!v4l2_framebuffer('V', 11);
enum VIDIOC_OVERLAY = _IOW!int('V', 14);
enum VIDIOC_QBUF = _IOWR!v4l2_buffer('V', 15);
enum VIDIOC_EXPBUF = _IOWR!v4l2_exportbuffer('V', 16);
enum VIDIOC_DQBUF = _IOWR!v4l2_buffer('V', 17);
enum VIDIOC_STREAMON = _IOW!int('V', 18);
enum VIDIOC_STREAMOFF = _IOW!int('V', 19);
enum VIDIOC_G_PARM = _IOWR!v4l2_streamparm('V', 21);
enum VIDIOC_S_PARM = _IOWR!v4l2_streamparm('V', 22);
enum VIDIOC_G_STD = _IOR!v4l2_std_id('V', 23);
enum VIDIOC_S_STD = _IOW!v4l2_std_id('V', 24);
enum VIDIOC_ENUMSTD = _IOWR!v4l2_standard('V', 25);
enum VIDIOC_ENUMINPUT = _IOWR!v4l2_input('V', 26);
enum VIDIOC_G_CTRL = _IOWR!v4l2_control('V', 27);
enum VIDIOC_S_CTRL = _IOWR!v4l2_control('V', 28);
enum VIDIOC_G_TUNER = _IOWR!v4l2_tuner('V', 29);
enum VIDIOC_S_TUNER = _IOW!v4l2_tuner('V', 30);
enum VIDIOC_G_AUDIO = _IOR!v4l2_audio('V', 33);
enum VIDIOC_S_AUDIO = _IOW!v4l2_audio('V', 34);
enum VIDIOC_QUERYCTRL = _IOWR!v4l2_queryctrl('V', 36);
enum VIDIOC_QUERYMENU = _IOWR!v4l2_querymenu('V', 37);
enum VIDIOC_G_INPUT = _IOR!int('V', 38);
enum VIDIOC_S_INPUT = _IOWR!int('V', 39);
enum VIDIOC_G_EDID = _IOWR!v4l2_edid('V', 40);
enum VIDIOC_S_EDID = _IOWR!v4l2_edid('V', 41);
enum VIDIOC_G_OUTPUT = _IOR!int('V', 46);
enum VIDIOC_S_OUTPUT = _IOWR!int('V', 47);
enum VIDIOC_ENUMOUTPUT = _IOWR!v4l2_output('V', 48);
enum VIDIOC_G_AUDOUT = _IOR!v4l2_audioout('V', 49);
enum VIDIOC_S_AUDOUT = _IOW!v4l2_audioout('V', 50);
enum VIDIOC_G_MODULATOR = _IOWR!v4l2_modulator('V', 54);
enum VIDIOC_S_MODULATOR = _IOW!v4l2_modulator('V', 55);
enum VIDIOC_G_FREQUENCY = _IOWR!v4l2_frequency('V', 56);
enum VIDIOC_S_FREQUENCY = _IOW!v4l2_frequency('V', 57);
enum VIDIOC_CROPCAP = _IOWR!v4l2_cropcap('V', 58);
enum VIDIOC_G_CROP = _IOWR!v4l2_crop('V', 59);
enum VIDIOC_S_CROP = _IOW!v4l2_crop('V', 60);
enum VIDIOC_G_JPEGCOMP = _IOR!v4l2_jpegcompression('V', 61);
enum VIDIOC_S_JPEGCOMP = _IOW!v4l2_jpegcompression('V', 62);
enum VIDIOC_QUERYSTD = _IOR!v4l2_std_id('V', 63);
enum VIDIOC_TRY_FMT = _IOWR!v4l2_format('V', 64);
enum VIDIOC_ENUMAUDIO = _IOWR!v4l2_audio('V', 65);
enum VIDIOC_ENUMAUDOUT = _IOWR!v4l2_audioout('V', 66);
enum VIDIOC_G_PRIORITY = _IOR!uint('V', 67); /* enum v4l2_priority */
enum VIDIOC_S_PRIORITY = _IOW!uint('V', 68); /* enum v4l2_priority */
enum VIDIOC_G_SLICED_VBI_CAP = _IOWR!v4l2_sliced_vbi_cap('V', 69);
enum VIDIOC_LOG_STATUS = _IO('V', 70);
enum VIDIOC_G_EXT_CTRLS = _IOWR!v4l2_ext_controls('V', 71);
enum VIDIOC_S_EXT_CTRLS = _IOWR!v4l2_ext_controls('V', 72);
enum VIDIOC_TRY_EXT_CTRLS = _IOWR!v4l2_ext_controls('V', 73);
enum VIDIOC_ENUM_FRAMESIZES = _IOWR!v4l2_frmsizeenum('V', 74);
enum VIDIOC_ENUM_FRAMEINTERVALS = _IOWR!v4l2_frmivalenum('V', 75);
enum VIDIOC_G_ENC_INDEX = _IOR!v4l2_enc_idx('V', 76);
enum VIDIOC_ENCODER_CMD = _IOWR!v4l2_encoder_cmd('V', 77);
enum VIDIOC_TRY_ENCODER_CMD = _IOWR!v4l2_encoder_cmd('V', 78);

/*
 * Experimental, meant for debugging, testing and internal use.
 * Only implemented if CONFIG_VIDEO_ADV_DEBUG is defined.
 * You must be root to use these ioctls. Never use these in applications!
 */
enum VIDIOC_DBG_S_REGISTER = _IOW!v4l2_dbg_register('V', 79);
enum VIDIOC_DBG_G_REGISTER = _IOWR!v4l2_dbg_register('V', 80);

enum VIDIOC_S_HW_FREQ_SEEK = _IOW!v4l2_hw_freq_seek('V', 82);
enum VIDIOC_S_DV_TIMINGS = _IOWR!v4l2_dv_timings('V', 87);
enum VIDIOC_G_DV_TIMINGS = _IOWR!v4l2_dv_timings('V', 88);
enum VIDIOC_DQEVENT = _IOR!v4l2_event('V', 89);
enum VIDIOC_SUBSCRIBE_EVENT = _IOW!v4l2_event_subscription('V', 90);
enum VIDIOC_UNSUBSCRIBE_EVENT = _IOW!v4l2_event_subscription('V', 91);
enum VIDIOC_CREATE_BUFS = _IOWR!v4l2_create_buffers('V', 92);
enum VIDIOC_PREPARE_BUF = _IOWR!v4l2_buffer('V', 93);
enum VIDIOC_G_SELECTION = _IOWR!v4l2_selection('V', 94);
enum VIDIOC_S_SELECTION = _IOWR!v4l2_selection('V', 95);
enum VIDIOC_DECODER_CMD = _IOWR!v4l2_decoder_cmd('V', 96);
enum VIDIOC_TRY_DECODER_CMD = _IOWR!v4l2_decoder_cmd('V', 97);
enum VIDIOC_ENUM_DV_TIMINGS = _IOWR!v4l2_enum_dv_timings('V', 98);
enum VIDIOC_QUERY_DV_TIMINGS = _IOR!v4l2_dv_timings('V', 99);
enum VIDIOC_DV_TIMINGS_CAP = _IOWR!v4l2_dv_timings_cap('V', 100);
enum VIDIOC_ENUM_FREQ_BANDS = _IOWR!v4l2_frequency_band('V', 101);

/*
 * Experimental, meant for debugging, testing and internal use.
 * Never use this in applications!
 */
enum VIDIOC_DBG_G_CHIP_INFO = _IOWR!v4l2_dbg_chip_info('V', 102);

enum VIDIOC_QUERY_EXT_CTRL = _IOWR!v4l2_query_ext_ctrl('V', 103);

/* Reminder: when adding new ioctls please add support for them to
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c as well! */

enum BASE_VIDIOC_PRIVATE = 192; /* 192-255 are private */

/* __LINUX_VIDEODEV2_H */
