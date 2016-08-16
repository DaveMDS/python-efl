cdef extern from "Ethumb.h":
    ####################################################################
    # Enums
    #

    ctypedef enum Ethumb_Thumb_Orientation:
        ETHUMB_THUMB_ORIENT_NONE
        ETHUMB_THUMB_ROTATE_90_CW
        ETHUMB_THUMB_ROTATE_180
        ETHUMB_THUMB_ROTATE_90_CCW
        ETHUMB_THUMB_FLIP_HORIZONTAL
        ETHUMB_THUMB_FLIP_VERTICAL
        ETHUMB_THUMB_FLIP_TRANSPOSE
        ETHUMB_THUMB_FLIP_TRANSVERSE
        ETHUMB_THUMB_ORIENT_ORIGINAL

    ctypedef enum Ethumb_Thumb_FDO_Size:
        ETHUMB_THUMB_NORMAL
        ETHUMB_THUMB_LARGE

    ctypedef enum Ethumb_Thumb_Format:
        ETHUMB_THUMB_FDO
        ETHUMB_THUMB_JPEG
        ETHUMB_THUMB_EET

    ctypedef enum Ethumb_Thumb_Aspect:
        ETHUMB_THUMB_KEEP_ASPECT
        ETHUMB_THUMB_IGNORE_ASPECT
        ETHUMB_THUMB_CROP
