cdef extern from "Ethumb.h":
    ctypedef enum Ethumb_Thumb_Orientation:
        ETHUMB_THUMB_ORIENT_NONE     # keep orientation as pixel data is
        ETHUMB_THUMB_ROTATE_90_CW    # rotate 90° clockwise
        ETHUMB_THUMB_ROTATE_180      # rotate 180°
        ETHUMB_THUMB_ROTATE_90_CCW   # rotate 90° counter-clockwise
        ETHUMB_THUMB_FLIP_HORIZONTAL # flip horizontally
        ETHUMB_THUMB_FLIP_VERTICAL   # flip vertically
        ETHUMB_THUMB_FLIP_TRANSPOSE  # transpose
        ETHUMB_THUMB_FLIP_TRANSVERSE # transverse
        ETHUMB_THUMB_ORIENT_ORIGINAL  # use orientation from metadata (EXIF-only currently)

    ctypedef enum Ethumb_Thumb_FDO_Size:
        ETHUMB_THUMB_NORMAL # 128x128 as defined by FreeDesktop.Org standard
        ETHUMB_THUMB_LARGE   # 256x256 as defined by FreeDesktop.Org standard

    ctypedef enum Ethumb_Thumb_Format:
        ETHUMB_THUMB_FDO   # PNG as defined by FreeDesktop.Org standard
        ETHUMB_THUMB_JPEG  # JPEGs are often smaller and faster to read/write
        ETHUMB_THUMB_EET    # EFL's own storage system, supports key parameter

    ctypedef enum Ethumb_Thumb_Aspect:
        ETHUMB_THUMB_KEEP_ASPECT # keep original proportion between width and height
        ETHUMB_THUMB_IGNORE_ASPECT # ignore aspect and force it to match thumbnail's width and height
        ETHUMB_THUMB_CROP # keep aspect but crop (cut) the largest dimension

