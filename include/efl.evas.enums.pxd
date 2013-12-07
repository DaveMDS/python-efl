# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.

cdef extern from "Evas.h":
    ctypedef enum:
        EVAS_LAYER_MIN        # bottom-most layer number
        EVAS_LAYER_MAX        # top-most layer number

        EVAS_COLOR_SPACE_ARGB # Not used for anything
        EVAS_COLOR_SPACE_AHSV # Not used for anything
        EVAS_TEXT_INVALID     # Not used for anything
        EVAS_TEXT_SPECIAL     # Not used for anything

        EVAS_HINT_EXPAND             # Use with evas_object_size_hint_weight_set(),
                                     #   evas_object_size_hint_weight_get(),
                                     #   evas_object_size_hint_expand_set(),
                                     #   evas_object_size_hint_expand_get()
        EVAS_HINT_FILL               # Use with evas_object_size_hint_align_set(),
                                     #   evas_object_size_hint_align_get(),
                                     #   evas_object_size_hint_fill_set(),
                                     #   evas_object_size_hint_fill_get()

        EVAS_SMART_CLASS_VERSION

    ctypedef enum Evas_BiDi_Direction:
        EVAS_BIDI_DIRECTION_NATURAL
        EVAS_BIDI_DIRECTION_NEUTRAL
        EVAS_BIDI_DIRECTION_LTR
        EVAS_BIDI_DIRECTION_RTL

    ctypedef enum Evas_Callback_Type:
        # The types of events triggering a callback
        #
        # The following events are only for use with Evas objects, with
        # evas_object_event_callback_add():
        EVAS_CALLBACK_MOUSE_IN # Mouse In Event
        EVAS_CALLBACK_MOUSE_OUT # Mouse Out Event
        EVAS_CALLBACK_MOUSE_DOWN # Mouse Button Down Event
        EVAS_CALLBACK_MOUSE_UP # Mouse Button Up Event
        EVAS_CALLBACK_MOUSE_MOVE # Mouse Move Event
        EVAS_CALLBACK_MOUSE_WHEEL # Mouse Wheel Event
        EVAS_CALLBACK_MULTI_DOWN # Multi-touch Down Event
        EVAS_CALLBACK_MULTI_UP # Multi-touch Up Event
        EVAS_CALLBACK_MULTI_MOVE # Multi-touch Move Event
        EVAS_CALLBACK_FREE # Object Being Freed (Called after Del)
        EVAS_CALLBACK_KEY_DOWN # Key Press Event
        EVAS_CALLBACK_KEY_UP # Key Release Event
        EVAS_CALLBACK_FOCUS_IN # Focus In Event
        EVAS_CALLBACK_FOCUS_OUT # Focus Out Event
        EVAS_CALLBACK_SHOW # Show Event
        EVAS_CALLBACK_HIDE # Hide Event
        EVAS_CALLBACK_MOVE # Move Event
        EVAS_CALLBACK_RESIZE # Resize Event
        EVAS_CALLBACK_RESTACK # Restack Event
        EVAS_CALLBACK_DEL # Object Being Deleted (called before Free)
        EVAS_CALLBACK_HOLD # Events go on/off hold
        EVAS_CALLBACK_CHANGED_SIZE_HINTS # Size hints changed event
        EVAS_CALLBACK_IMAGE_PRELOADED # Image has been preloaded

        # The following events are only for use with Evas canvases, with
        # evas_event_callback_add():
        EVAS_CALLBACK_CANVAS_FOCUS_IN # Canvas got focus as a whole
        EVAS_CALLBACK_CANVAS_FOCUS_OUT # Canvas lost focus as a whole
        EVAS_CALLBACK_RENDER_FLUSH_PRE # Called just before rendering is updated on the canvas target
        EVAS_CALLBACK_RENDER_FLUSH_POST # Called just after rendering is updated on the canvas target
        EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_IN # Canvas object got focus
        EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_OUT # Canvas object lost focus

        # More Evas object event types - see evas_object_event_callback_add():
        EVAS_CALLBACK_IMAGE_UNLOADED # Image data has been unloaded (by some mechanism in Evas that throw out original image data)

        EVAS_CALLBACK_RENDER_PRE # Called just before rendering starts on the canvas target @since 1.2
        EVAS_CALLBACK_RENDER_POST # Called just after rendering stops on the canvas target @since 1.2

        EVAS_CALLBACK_IMAGE_RESIZE # Image size is changed @since 1.8
        EVAS_CALLBACK_DEVICE_CHANGED # Devices added, removed or changed on canvas @since 1.8
        EVAS_CALLBACK_LAST # kept as last element/sentinel -- not really an event

    ctypedef enum Evas_Button_Flags:
        # Flags for Mouse Button events
        EVAS_BUTTON_NONE # No extra mouse button data
        EVAS_BUTTON_DOUBLE_CLICK # This mouse button press was the 2nd press of a double click
        EVAS_BUTTON_TRIPLE_CLICK # This mouse button press was the 3rd press of a triple click

    ctypedef enum Evas_Event_Flags:
        # Flags for Events
        EVAS_EVENT_FLAG_NONE # No fancy flags set
        EVAS_EVENT_FLAG_ON_HOLD # This event is being delivered but should be put "on hold" until the on hold flag is unset. the event should be used for informational purposes and maybe some indications visually, but not actually perform anything
        EVAS_EVENT_FLAG_ON_SCROLL # This event flag indicates the event occurs while scrolling; for example, DOWN event occurs during scrolling; the event should be used for informational purposes and maybe some indications visually, but not actually perform anything

    ctypedef enum Evas_Touch_Point_State:
        EVAS_TOUCH_POINT_DOWN # Touch point is pressed down
        EVAS_TOUCH_POINT_UP # Touch point is released
        EVAS_TOUCH_POINT_MOVE # Touch point is moved
        EVAS_TOUCH_POINT_STILL # Touch point is not moved after pressed
        EVAS_TOUCH_POINT_CANCEL # Touch point is cancelled

    ctypedef enum Evas_Font_Hinting_Flags:
        # Flags for Font Hinting
        EVAS_FONT_HINTING_NONE # No font hinting
        EVAS_FONT_HINTING_AUTO # Automatic font hinting
        EVAS_FONT_HINTING_BYTECODE # Bytecode font hinting

    ctypedef enum Evas_Colorspace:
        # Colorspaces for pixel data supported by Evas
        EVAS_COLORSPACE_ARGB8888 # ARGB 32 bits per pixel, high-byte is Alpha, accessed 1 32bit word at a time
        # these are not currently supported - but planned for the future
        EVAS_COLORSPACE_YCBCR422P601_PL # YCbCr 4:2:2 Planar, ITU.BT-601 specifications. The data pointed to is just an array of row pointer, pointing to the Y rows, then the Cb, then Cr rows
        EVAS_COLORSPACE_YCBCR422P709_PL # YCbCr 4:2:2 Planar, ITU.BT-709 specifications. The data pointed to is just an array of row pointer, pointing to the Y rows, then the Cb, then Cr rows
        EVAS_COLORSPACE_RGB565_A5P # 16bit rgb565 + Alpha plane at end - 5 bits of the 8 being used per alpha byte
        EVAS_COLORSPACE_GRY8 # 8bit grayscale
        EVAS_COLORSPACE_YCBCR422601_PL #  YCbCr 4:2:2, ITU.BT-601 specifications. The data pointed to is just an array of row pointer, pointing to line of Y,Cb,Y,Cr bytes
        EVAS_COLORSPACE_YCBCR420NV12601_PL # YCbCr 4:2:0, ITU.BT-601 specification. The data pointed to is just an array of row pointer, pointing to the Y rows, then the Cb,Cr rows.
        EVAS_COLORSPACE_YCBCR420TM12601_PL # YCbCr 4:2:0, ITU.BT-601 specification. The data pointed to is just an array of tiled row pointer, pointing to the Y rows, then the Cb,Cr rows.

    ctypedef enum Evas_Object_Table_Homogeneous_Mode:
        # Table cell pack mode.
        EVAS_OBJECT_TABLE_HOMOGENEOUS_NONE
        EVAS_OBJECT_TABLE_HOMOGENEOUS_TABLE
        EVAS_OBJECT_TABLE_HOMOGENEOUS_ITEM

    ctypedef enum Evas_Aspect_Control:
        # Aspect types/policies for scaling size hints, used for evas_object_size_hint_aspect_set()
        EVAS_ASPECT_CONTROL_NONE # Preference on scaling unset
        EVAS_ASPECT_CONTROL_NEITHER # Same effect as unset preference on scaling
        EVAS_ASPECT_CONTROL_HORIZONTAL # Use all horizontal container space to place an object, using the given aspect
        EVAS_ASPECT_CONTROL_VERTICAL # Use all vertical container space to place an object, using the given aspect
        EVAS_ASPECT_CONTROL_BOTH # Use all horizontal @b and vertical container spaces to place an object (never growing it out of those bounds), using the given aspect

    ctypedef enum Evas_Display_Mode:
        # object's display mode type related with compress/expand or etc mode
        EVAS_DISPLAY_MODE_NONE # Default mode
        EVAS_DISPLAY_MODE_COMPRESS # Use this mode want to give comppress display mode hint to object
        EVAS_DISPLAY_MODE_EXPAND # Use this mode want to give expand display mode hint to object
        EVAS_DISPLAY_MODE_DONT_CHANGE # Use this mode when object should not change display mode

    ctypedef enum Evas_Load_Error:
        # Evas image load error codes one can get - see evas_load_error_str() too.
        EVAS_LOAD_ERROR_NONE # No error on load
        EVAS_LOAD_ERROR_GENERIC # A non-specific error occurred
        EVAS_LOAD_ERROR_DOES_NOT_EXIST # File (or file path) does not exist
        EVAS_LOAD_ERROR_PERMISSION_DENIED # Permission denied to an existing file (or path)
        EVAS_LOAD_ERROR_RESOURCE_ALLOCATION_FAILED # Allocation of resources failure prevented load
        EVAS_LOAD_ERROR_CORRUPT_FILE # File corrupt (but was detected as a known format)
        EVAS_LOAD_ERROR_UNKNOWN_FORMAT # File is not a known format

    ctypedef enum Evas_Alloc_Error:
        # Possible allocation errors returned by evas_alloc_error()
        EVAS_ALLOC_ERROR_NONE # No allocation error
        EVAS_ALLOC_ERROR_FATAL # Allocation failed despite attempts to free up memory
        EVAS_ALLOC_ERROR_RECOVERED # Allocation succeeded, but extra memory had to be found by freeing up speculative resources

    ctypedef enum Evas_Fill_Spread:
        # Fill types used for evas_object_image_fill_spread_set()
        EVAS_TEXTURE_REFLECT # image fill tiling mode - tiling reflects
        EVAS_TEXTURE_REPEAT # tiling repeats
        EVAS_TEXTURE_RESTRICT # tiling clamps - range offset ignored
        EVAS_TEXTURE_RESTRICT_REFLECT # tiling clamps and any range offset reflects
        EVAS_TEXTURE_RESTRICT_REPEAT # tiling clamps and any range offset repeats
        EVAS_TEXTURE_PAD # tiling extends with end values

    ctypedef enum Evas_Pixel_Import_Pixel_Format:
        # Pixel format for import call. See evas_object_image_pixels_import()
        EVAS_PIXEL_FORMAT_NONE # No pixel format
        EVAS_PIXEL_FORMAT_ARGB32 # ARGB 32bit pixel format with A in the high byte per 32bit pixel word
        EVAS_PIXEL_FORMAT_YUV420P_601 # YUV 420 Planar format with CCIR 601 color encoding with contiguous planes in the order Y, U and V

    ctypedef enum Evas_Native_Surface_Type:
        EVAS_NATIVE_SURFACE_NONE
        EVAS_NATIVE_SURFACE_X11
        EVAS_NATIVE_SURFACE_OPENGL

    ctypedef enum Evas_Render_Op:
        # How the object should be rendered to output.
        EVAS_RENDER_BLEND # default op: d = d*(1-sa) + s
        EVAS_RENDER_BLEND_REL # d = d*(1 - sa) + s*da
        EVAS_RENDER_COPY # d = s
        EVAS_RENDER_COPY_REL # d = s*da
        EVAS_RENDER_ADD # d = d + s
        EVAS_RENDER_ADD_REL # d = d + s*da
        EVAS_RENDER_SUB # d = d - s
        EVAS_RENDER_SUB_REL # d = d - s*da
        EVAS_RENDER_TINT # d = d*s + d*(1 - sa) + s*(1 - da)
        EVAS_RENDER_TINT_REL # d = d*(1 - sa + s)
        EVAS_RENDER_MASK # d = d*sa
        EVAS_RENDER_MUL # d = d*s

    ctypedef enum Evas_Border_Fill_Mode:
        # How an image's center region (the complement to the border region) should be rendered by Evas
        EVAS_BORDER_FILL_NONE # Image's center region is @b not to be rendered
        EVAS_BORDER_FILL_DEFAULT # Image's center region is to be @b blended with objects underneath it, if it has transparency. This is the default behavior for image objects
        EVAS_BORDER_FILL_SOLID # Image's center region is to be made solid, even if it has transparency on it

    ctypedef enum Evas_Image_Scale_Hint:
        # How an image's data is to be treated by Evas, with regard to scaling cache
        EVAS_IMAGE_SCALE_HINT_NONE # No scale hint at all
        EVAS_IMAGE_SCALE_HINT_DYNAMIC # Image is being re-scaled over time, thus turning scaling cache @b off for its data
        EVAS_IMAGE_SCALE_HINT_STATIC # Image is not being re-scaled over time, thus turning scaling cache @b on for its data

    ctypedef enum Evas_Image_Animated_Loop_Hint:
        EVAS_IMAGE_ANIMATED_HINT_NONE
        EVAS_IMAGE_ANIMATED_HINT_LOOP # Image's animation mode is loop like 1->2->3->1->2->3
        EVAS_IMAGE_ANIMATED_HINT_PINGPONG # Image's animation mode is pingpong like 1->2->3->2->1-> ...

    ctypedef enum Evas_Engine_Render_Mode:
        EVAS_RENDER_MODE_BLOCKING
        EVAS_RENDER_MODE_NONBLOCKING

    ctypedef enum Evas_Image_Content_Hint:
        # How an image's data is to be treated by Evas, for optimization
        EVAS_IMAGE_CONTENT_HINT_NONE # No hint at all
        EVAS_IMAGE_CONTENT_HINT_DYNAMIC # The contents will change over time
        EVAS_IMAGE_CONTENT_HINT_STATIC # The contents won't change over time

    ctypedef enum Evas_Device_Class:
        EVAS_DEVICE_CLASS_NONE # Not a device @since 1.8
        EVAS_DEVICE_CLASS_SEAT # The user/seat (the user themselves) @since 1.8
        EVAS_DEVICE_CLASS_KEYBOARD # A regular keyboard, numberpad or attached buttons @since 1.8
        EVAS_DEVICE_CLASS_MOUSE # A mouse, trackball or touchpad relative motion device @since 1.8
        EVAS_DEVICE_CLASS_TOUCH # A touchscreen with fingers or stylus @since 1.8
        EVAS_DEVICE_CLASS_PEN # A special pen device @since 1.8
        EVAS_DEVICE_CLASS_POINTER # A laser pointer, wii-style or "minority report" pointing device @since 1.8
        EVAS_DEVICE_CLASS_GAMEPAD #  A gamepad controller or joystick @since 1.8

    ctypedef enum Evas_Object_Pointer_Mode:
        # How the mouse pointer should be handled by Evas.
        EVAS_OBJECT_POINTER_MODE_AUTOGRAB # default, X11-like
        EVAS_OBJECT_POINTER_MODE_NOGRAB # pointer always bound to the object right below it
        EVAS_OBJECT_POINTER_MODE_NOGRAB_NO_REPEAT_UPDOWN # useful on object with "repeat events" enabled, where mouse/touch up and down events WONT be repeated to objects and these objects wont be auto-grabbed. @since 1.2

    ctypedef enum Evas_Text_Style_Type:
        # Types of styles to be applied on text objects. The @c EVAS_TEXT_STYLE_SHADOW_DIRECTION_* ones are to be ORed together with others imposing shadow, to change shadow's direction
        EVAS_TEXT_STYLE_PLAIN      # plain, standard text
        EVAS_TEXT_STYLE_SHADOW      # text with shadow underneath
        EVAS_TEXT_STYLE_OUTLINE      # text with an outline
        EVAS_TEXT_STYLE_SOFT_OUTLINE      # text with a soft outline
        EVAS_TEXT_STYLE_GLOW      # text with a glow effect
        EVAS_TEXT_STYLE_OUTLINE_SHADOW      # text with both outline and shadow effects
        EVAS_TEXT_STYLE_FAR_SHADOW      # text with (far) shadow underneath
        EVAS_TEXT_STYLE_OUTLINE_SOFT_SHADOW      # text with outline and soft shadow effects combined
        EVAS_TEXT_STYLE_SOFT_SHADOW      # text with (soft) shadow underneath
        EVAS_TEXT_STYLE_FAR_SOFT_SHADOW      # text with (far soft) shadow underneath

        # OR these to modify shadow direction (3 bits needed)
        EVAS_TEXT_STYLE_SHADOW_DIRECTION_BOTTOM_RIGHT      # shadow growing to bottom right
        EVAS_TEXT_STYLE_SHADOW_DIRECTION_BOTTOM            # shadow growing to the bottom
        EVAS_TEXT_STYLE_SHADOW_DIRECTION_BOTTOM_LEFT       # shadow growing to bottom left
        EVAS_TEXT_STYLE_SHADOW_DIRECTION_LEFT              # shadow growing to the left
        EVAS_TEXT_STYLE_SHADOW_DIRECTION_TOP_LEFT          # shadow growing to top left
        EVAS_TEXT_STYLE_SHADOW_DIRECTION_TOP               # shadow growing to the top
        EVAS_TEXT_STYLE_SHADOW_DIRECTION_TOP_RIGHT         # shadow growing to top right
        EVAS_TEXT_STYLE_SHADOW_DIRECTION_RIGHT             # shadow growing to the right

    ctypedef enum Evas_Textblock_Text_Type:
        EVAS_TEXTBLOCK_TEXT_RAW
        EVAS_TEXTBLOCK_TEXT_PLAIN
        EVAS_TEXTBLOCK_TEXT_MARKUP

    ctypedef enum Evas_Textblock_Cursor_Type:
        EVAS_TEXTBLOCK_CURSOR_UNDER
        EVAS_TEXTBLOCK_CURSOR_BEFORE

    ctypedef enum Evas_Textgrid_Palette:
        EVAS_TEXTGRID_PALETTE_NONE     # No palette is used
        EVAS_TEXTGRID_PALETTE_STANDARD # standard palette (around 16 colors)
        EVAS_TEXTGRID_PALETTE_EXTENDED # extended palette (at max 256 colors)
        EVAS_TEXTGRID_PALETTE_LAST     # ignore it

    ctypedef enum Evas_Textgrid_Font_Style:
        EVAS_TEXTGRID_FONT_STYLE_NORMAL # Normal style
        EVAS_TEXTGRID_FONT_STYLE_BOLD   # Bold style
        EVAS_TEXTGRID_FONT_STYLE_ITALIC # Oblique style
