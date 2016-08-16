cdef extern from "Edje_Edit.h":
    ####################################################################
    # Enums
    #
    ctypedef enum Edje_Edit_Image_Comp:
        EDJE_EDIT_IMAGE_COMP_RAW
        EDJE_EDIT_IMAGE_COMP_USER
        EDJE_EDIT_IMAGE_COMP_COMP
        EDJE_EDIT_IMAGE_COMP_LOSSY
