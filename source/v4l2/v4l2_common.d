module v4l2.v4l2_common;
/* SPDX-License-Identifier: ((GPL-2.0+ WITH Linux-syscall-note) OR BSD-3-Clause) */
/*
 * include/linux/v4l2-common.h
 *
 * Common V4L2 and V4L2 subdev definitions.
 *
 * Users are advised to #include this file either through videodev2.h
 * (V4L2) or through v4l2-subdev.h (V4L2 subdev) rather than to refer
 * to this file directly.
 *
 * Copyright (C) 2012 Nokia Corporation
 * Contact: Sakari Ailus <sakari.ailus@iki.fi>
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
 */

extern (C):

/*
 *
 * Selection interface definitions
 *
 */

/* Current cropping area */
enum V4L2_SEL_TGT_CROP = 0x0000;
/* Default cropping area */
enum V4L2_SEL_TGT_CROP_DEFAULT = 0x0001;
/* Cropping bounds */
enum V4L2_SEL_TGT_CROP_BOUNDS = 0x0002;
/* Native frame size */
enum V4L2_SEL_TGT_NATIVE_SIZE = 0x0003;
/* Current composing area */
enum V4L2_SEL_TGT_COMPOSE = 0x0100;
/* Default composing area */
enum V4L2_SEL_TGT_COMPOSE_DEFAULT = 0x0101;
/* Composing bounds */
enum V4L2_SEL_TGT_COMPOSE_BOUNDS = 0x0102;
/* Current composing area plus all padding pixels */
enum V4L2_SEL_TGT_COMPOSE_PADDED = 0x0103;

/* Backward compatibility target definitions --- to be removed. */
enum V4L2_SEL_TGT_CROP_ACTIVE = V4L2_SEL_TGT_CROP;
enum V4L2_SEL_TGT_COMPOSE_ACTIVE = V4L2_SEL_TGT_COMPOSE;
enum V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL = V4L2_SEL_TGT_CROP;
enum V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL = V4L2_SEL_TGT_COMPOSE;
enum V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS = V4L2_SEL_TGT_CROP_BOUNDS;
enum V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS = V4L2_SEL_TGT_COMPOSE_BOUNDS;

/* Selection flags */
enum V4L2_SEL_FLAG_GE = 1 << 0;
enum V4L2_SEL_FLAG_LE = 1 << 1;
enum V4L2_SEL_FLAG_KEEP_CONFIG = 1 << 2;

/* Backward compatibility flag definitions --- to be removed. */
enum V4L2_SUBDEV_SEL_FLAG_SIZE_GE = V4L2_SEL_FLAG_GE;
enum V4L2_SUBDEV_SEL_FLAG_SIZE_LE = V4L2_SEL_FLAG_LE;
enum V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG = V4L2_SEL_FLAG_KEEP_CONFIG;

struct v4l2_edid {
    uint pad;
    uint start_block;
    uint blocks;
    uint[5] reserved;
    ubyte* edid;
}

/* __V4L2_COMMON__ */
