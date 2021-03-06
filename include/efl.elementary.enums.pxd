cdef extern from "Edje.h":
    # used in configuration
    ctypedef enum Edje_Channel:
        EDJE_CHANNEL_EFFECT
        EDJE_CHANNEL_BACKGROUND
        EDJE_CHANNEL_MUSIC
        EDJE_CHANNEL_FOREGROUND
        EDJE_CHANNEL_INTERFACE
        EDJE_CHANNEL_INPUT
        EDJE_CHANNEL_ALERT
        EDJE_CHANNEL_ALL


cdef extern from "Elementary.h":
    #define
    cdef enum:
        ELM_ECORE_EVENT_ETHUMB_CONNECT
        ELM_EVENT_CONFIG_ALL_CHANGED
        ELM_EVENT_POLICY_CHANGED
        ELM_EVENT_PROCESS_BACKGROUND
        ELM_EVENT_PROCESS_FOREGROUND
        ELM_EVENT_SYS_NOTIFY_NOTIFICATION_CLOSED
        ELM_EVENT_SYS_NOTIFY_ACTION_INVOKED

    #enums
    ctypedef enum Elm_Focus_Direction:
        ELM_FOCUS_PREVIOUS
        ELM_FOCUS_NEXT
        ELM_FOCUS_UP
        ELM_FOCUS_DOWN
        ELM_FOCUS_RIGHT
        ELM_FOCUS_LEFT

    ctypedef enum Elm_Focus_Move_Policy:
        ELM_FOCUS_MOVE_POLICY_CLICK
        ELM_FOCUS_MOVE_POLICY_IN
        ELM_FOCUS_MOVE_POLICY_KEY_ONLY

    ctypedef enum Elm_Focus_Region_Show_Mode:
        ELM_FOCUS_REGION_SHOW_WIDGET
        ELM_FOCUS_REGION_SHOW_ITEM

    ctypedef enum Elm_Focus_Autoscroll_Mode:
        ELM_FOCUS_AUTOSCROLL_MODE_SHOW
        ELM_FOCUS_AUTOSCROLL_MODE_NONE
        ELM_FOCUS_AUTOSCROLL_MODE_BRING_IN

    ctypedef enum Elm_Sel_Type:
        ELM_SEL_TYPE_PRIMARY
        ELM_SEL_TYPE_SECONDARY
        ELM_SEL_TYPE_XDND
        ELM_SEL_TYPE_CLIPBOARD

    ctypedef enum Elm_Sel_Format:
        ELM_SEL_FORMAT_TARGETS
        ELM_SEL_FORMAT_NONE
        ELM_SEL_FORMAT_TEXT
        ELM_SEL_FORMAT_MARKUP
        ELM_SEL_FORMAT_IMAGE
        ELM_SEL_FORMAT_VCARD
        ELM_SEL_FORMAT_HTML

    ctypedef enum Elm_Xdnd_Action:
        ELM_XDND_ACTION_UNKNOWN
        ELM_XDND_ACTION_COPY
        ELM_XDND_ACTION_MOVE
        ELM_XDND_ACTION_PRIVATE
        ELM_XDND_ACTION_ASK
        ELM_XDND_ACTION_LIST
        ELM_XDND_ACTION_LINK
        ELM_XDND_ACTION_DESCRIPTION

    ctypedef enum Elm_Tooltip_Orient:
        ELM_TOOLTIP_ORIENT_NONE
        ELM_TOOLTIP_ORIENT_TOP_LEFT
        ELM_TOOLTIP_ORIENT_TOP
        ELM_TOOLTIP_ORIENT_TOP_RIGHT
        ELM_TOOLTIP_ORIENT_LEFT
        ELM_TOOLTIP_ORIENT_CENTER
        ELM_TOOLTIP_ORIENT_RIGHT
        ELM_TOOLTIP_ORIENT_BOTTOM_LEFT
        ELM_TOOLTIP_ORIENT_BOTTOM
        ELM_TOOLTIP_ORIENT_BOTTOM_RIGHT
        ELM_TOOLTIP_ORIENT_LAST

    ctypedef enum Elm_Policy:
        ELM_POLICY_QUIT
        ELM_POLICY_EXIT
        ELM_POLICY_THROTTLE
        ELM_POLICY_LAST

    ctypedef enum Elm_Policy_Quit:
        ELM_POLICY_QUIT_NONE
        ELM_POLICY_QUIT_LAST_WINDOW_CLOSED
        ELM_POLICY_QUIT_LAST_WINDOW_HIDDEN

    ctypedef enum Elm_Policy_Exit:
        ELM_POLICY_EXIT_NONE
        ELM_POLICY_EXIT_WINDOWS_DEL

    ctypedef enum Elm_Policy_Throttle:
        ELM_POLICY_THROTTLE_CONFIG
        ELM_POLICY_THROTTLE_HIDDEN_ALWAYS
        ELM_POLICY_THROTTLE_NEVER

    ctypedef enum Elm_Sys_Notify_Urgency:
        ELM_SYS_NOTIFY_URGENCY_LOW
        ELM_SYS_NOTIFY_URGENCY_NORMAL
        ELM_SYS_NOTIFY_URGENCY_CRITICAL

    ctypedef enum Elm_Glob_Match_Flags:
        ELM_GLOB_MATCH_NO_ESCAPE
        ELM_GLOB_MATCH_PATH
        ELM_GLOB_MATCH_PERIOD
        ELM_GLOB_MATCH_NOCASE

    ctypedef enum Elm_Process_State:
        ELM_PROCESS_STATE_FOREGROUND
        ELM_PROCESS_STATE_BACKGROUND

    # actionslider
    ctypedef enum Elm_Actionslider_Pos:
        ELM_ACTIONSLIDER_NONE
        ELM_ACTIONSLIDER_LEFT
        ELM_ACTIONSLIDER_CENTER
        ELM_ACTIONSLIDER_RIGHT
        ELM_ACTIONSLIDER_ALL

    # background
    ctypedef enum Elm_Bg_Option:
        ELM_BG_OPTION_CENTER
        ELM_BG_OPTION_SCALE
        ELM_BG_OPTION_STRETCH
        ELM_BG_OPTION_TILE
        ELM_BG_OPTION_LAST

    # bubble
    ctypedef enum Elm_Bubble_Pos:
        ELM_BUBBLE_POS_TOP_LEFT
        ELM_BUBBLE_POS_TOP_RIGHT
        ELM_BUBBLE_POS_BOTTOM_LEFT
        ELM_BUBBLE_POS_BOTTOM_RIGHT

    # calendar
    ctypedef enum Elm_Calendar_Mark_Repeat_Type:
        ELM_CALENDAR_UNIQUE
        ELM_CALENDAR_DAILY
        ELM_CALENDAR_WEEKLY
        ELM_CALENDAR_MONTHLY
        ELM_CALENDAR_ANNUALLY
        ELM_CALENDAR_LAST_DAY_OF_MONTH
        ELM_CALENDAR_REVERSE_DAILY

    ctypedef enum Elm_Calendar_Select_Mode:
        ELM_CALENDAR_SELECT_MODE_DEFAULT
        ELM_CALENDAR_SELECT_MODE_ALWAYS
        ELM_CALENDAR_SELECT_MODE_NONE
        ELM_CALENDAR_SELECT_MODE_ONDEMAND

    ctypedef enum Elm_Calendar_Selectable:
        ELM_CALENDAR_SELECTABLE_NONE
        ELM_CALENDAR_SELECTABLE_YEAR
        ELM_CALENDAR_SELECTABLE_MONTH
        ELM_CALENDAR_SELECTABLE_DAY

    ctypedef enum Elm_Calendar_Weekday:
        ELM_DAY_SUNDAY
        ELM_DAY_MONDAY
        ELM_DAY_TUESDAY
        ELM_DAY_WEDNESDAY
        ELM_DAY_THURSDAY
        ELM_DAY_FRIDAY
        ELM_DAY_SATURDAY
        ELM_DAY_LAST

    # clock
    ctypedef enum Elm_Clock_Edit_Mode:
        ELM_CLOCK_EDIT_DEFAULT
        ELM_CLOCK_EDIT_HOUR_DECIMAL
        ELM_CLOCK_EDIT_HOUR_UNIT
        ELM_CLOCK_EDIT_MIN_DECIMAL
        ELM_CLOCK_EDIT_MIN_UNIT
        ELM_CLOCK_EDIT_SEC_DECIMAL
        ELM_CLOCK_EDIT_SEC_UNIT
        ELM_CLOCK_EDIT_ALL

    # colorselector
    ctypedef enum Elm_Colorselector_Mode:
        ELM_COLORSELECTOR_PALETTE
        ELM_COLORSELECTOR_COMPONENTS
        ELM_COLORSELECTOR_BOTH

    # configuration
    ctypedef enum Elm_Softcursor_Mode:
        ELM_SOFTCURSOR_MODE_AUTO
        ELM_SOFTCURSOR_MODE_ON
        ELM_SOFTCURSOR_MODE_OFF

    # ctxpopup
    ctypedef enum Elm_Ctxpopup_Direction:
        ELM_CTXPOPUP_DIRECTION_DOWN
        ELM_CTXPOPUP_DIRECTION_RIGHT
        ELM_CTXPOPUP_DIRECTION_LEFT
        ELM_CTXPOPUP_DIRECTION_UP
        ELM_CTXPOPUP_DIRECTION_UNKNOWN

    # datetime
    ctypedef enum Elm_Datetime_Field_Type:
        ELM_DATETIME_YEAR
        ELM_DATETIME_MONTH
        ELM_DATETIME_DATE
        ELM_DATETIME_HOUR
        ELM_DATETIME_MINUTE
        ELM_DATETIME_AMPM

    # dayselector
    ctypedef enum Elm_Dayselector_Day:
        ELM_DAYSELECTOR_SUN
        ELM_DAYSELECTOR_MON
        ELM_DAYSELECTOR_TUE
        ELM_DAYSELECTOR_WED
        ELM_DAYSELECTOR_THU
        ELM_DAYSELECTOR_FRI
        ELM_DAYSELECTOR_SAT
        ELM_DAYSELECTOR_MAX

    # entry
    ctypedef enum Elm_Autocapital_Type:
        ELM_AUTOCAPITAL_TYPE_NONE
        ELM_AUTOCAPITAL_TYPE_WORD
        ELM_AUTOCAPITAL_TYPE_SENTENCE
        ELM_AUTOCAPITAL_TYPE_ALLCHARACTER

    ctypedef enum Elm_Cnp_Mode:
        ELM_CNP_MODE_MARKUP
        ELM_CNP_MODE_NO_IMAGE
        ELM_CNP_MODE_PLAINTEXT

    ctypedef enum Elm_Input_Hints:
        ELM_INPUT_HINT_NONE
        ELM_INPUT_HINT_AUTO_COMPLETE
        ELM_INPUT_HINT_SENSITIVE_DATA

    ctypedef enum Elm_Input_Panel_Lang:
        ELM_INPUT_PANEL_LANG_AUTOMATIC
        ELM_INPUT_PANEL_LANG_ALPHABET

    ctypedef enum Elm_Input_Panel_Layout:
        ELM_INPUT_PANEL_LAYOUT_NORMAL
        ELM_INPUT_PANEL_LAYOUT_NUMBER
        ELM_INPUT_PANEL_LAYOUT_EMAIL
        ELM_INPUT_PANEL_LAYOUT_URL
        ELM_INPUT_PANEL_LAYOUT_PHONENUMBER
        ELM_INPUT_PANEL_LAYOUT_IP
        ELM_INPUT_PANEL_LAYOUT_MONTH
        ELM_INPUT_PANEL_LAYOUT_NUMBERONLY
        ELM_INPUT_PANEL_LAYOUT_INVALID
        ELM_INPUT_PANEL_LAYOUT_HEX
        ELM_INPUT_PANEL_LAYOUT_TERMINAL
        ELM_INPUT_PANEL_LAYOUT_PASSWORD
        ELM_INPUT_PANEL_LAYOUT_DATETIME
        ELM_INPUT_PANEL_LAYOUT_EMOTICON
        ELM_INPUT_PANEL_LAYOUT_VOICE

    cdef enum:
        ELM_INPUT_PANEL_LAYOUT_NORMAL_VARIATION_NORMAL
        ELM_INPUT_PANEL_LAYOUT_NORMAL_VARIATION_FILENAME
        ELM_INPUT_PANEL_LAYOUT_NORMAL_VARIATION_PERSON_NAME

    cdef enum:
        ELM_INPUT_PANEL_LAYOUT_NUMBERONLY_VARIATION_NORMAL
        ELM_INPUT_PANEL_LAYOUT_NUMBERONLY_VARIATION_SIGNED
        ELM_INPUT_PANEL_LAYOUT_NUMBERONLY_VARIATION_DECIMAL
        ELM_INPUT_PANEL_LAYOUT_NUMBERONLY_VARIATION_SIGNED_AND_DECIMAL

    cdef enum:
        ELM_INPUT_PANEL_LAYOUT_PASSWORD_VARIATION_NORMAL
        ELM_INPUT_PANEL_LAYOUT_PASSWORD_VARIATION_NUMBERONLY

    ctypedef enum Elm_Input_Panel_Return_Key_Type:
        ELM_INPUT_PANEL_RETURN_KEY_TYPE_DEFAULT
        ELM_INPUT_PANEL_RETURN_KEY_TYPE_DONE
        ELM_INPUT_PANEL_RETURN_KEY_TYPE_GO
        ELM_INPUT_PANEL_RETURN_KEY_TYPE_JOIN
        ELM_INPUT_PANEL_RETURN_KEY_TYPE_LOGIN
        ELM_INPUT_PANEL_RETURN_KEY_TYPE_NEXT
        ELM_INPUT_PANEL_RETURN_KEY_TYPE_SEARCH
        ELM_INPUT_PANEL_RETURN_KEY_TYPE_SEND
        ELM_INPUT_PANEL_RETURN_KEY_TYPE_SIGNIN

    ctypedef enum Elm_Text_Format:
        ELM_TEXT_FORMAT_PLAIN_UTF8
        ELM_TEXT_FORMAT_MARKUP_UTF8

    ctypedef enum Elm_Wrap_Type:
        ELM_WRAP_NONE
        ELM_WRAP_CHAR
        ELM_WRAP_WORD
        ELM_WRAP_MIXED

    # fileselector
    ctypedef enum Elm_Fileselector_Mode:
        ELM_FILESELECTOR_LIST
        ELM_FILESELECTOR_GRID

    ctypedef enum Elm_Fileselector_Sort:
        ELM_FILESELECTOR_SORT_BY_FILENAME_ASC
        ELM_FILESELECTOR_SORT_BY_FILENAME_DESC
        ELM_FILESELECTOR_SORT_BY_TYPE_ASC
        ELM_FILESELECTOR_SORT_BY_TYPE_DESC
        ELM_FILESELECTOR_SORT_BY_SIZE_ASC
        ELM_FILESELECTOR_SORT_BY_SIZE_DESC
        ELM_FILESELECTOR_SORT_BY_MODIFIED_ASC
        ELM_FILESELECTOR_SORT_BY_MODIFIED_DESC
        ELM_FILESELECTOR_SORT_LAST

    # flip
    ctypedef enum Elm_Flip_Direction:
        ELM_FLIP_DIRECTION_UP
        ELM_FLIP_DIRECTION_DOWN
        ELM_FLIP_DIRECTION_LEFT
        ELM_FLIP_DIRECTION_RIGHT

    ctypedef enum Elm_Flip_Interaction:
        ELM_FLIP_INTERACTION_NONE
        ELM_FLIP_INTERACTION_ROTATE
        ELM_FLIP_INTERACTION_CUBE
        ELM_FLIP_INTERACTION_PAGE

    ctypedef enum Elm_Flip_Mode:
        ELM_FLIP_ROTATE_Y_CENTER_AXIS
        ELM_FLIP_ROTATE_X_CENTER_AXIS
        ELM_FLIP_ROTATE_XZ_CENTER_AXIS
        ELM_FLIP_ROTATE_YZ_CENTER_AXIS
        ELM_FLIP_CUBE_LEFT
        ELM_FLIP_CUBE_RIGHT
        ELM_FLIP_CUBE_UP
        ELM_FLIP_CUBE_DOWN
        ELM_FLIP_PAGE_LEFT
        ELM_FLIP_PAGE_RIGHT
        ELM_FLIP_PAGE_UP
        ELM_FLIP_PAGE_DOWN

    # gengrid
    ctypedef enum Elm_Gengrid_Item_Scrollto_Type:
        ELM_GENGRID_ITEM_SCROLLTO_NONE
        ELM_GENGRID_ITEM_SCROLLTO_IN
        ELM_GENGRID_ITEM_SCROLLTO_TOP
        ELM_GENGRID_ITEM_SCROLLTO_MIDDLE
        ELM_GENGRID_ITEM_SCROLLTO_BOTTOM

    ctypedef enum Elm_Gengrid_Reorder_Type:
        ELM_GENGRID_REORDER_TYPE_NORMAL
        ELM_GENGRID_REORDER_TYPE_SWAP

    # genlist
    ctypedef enum Elm_Genlist_Item_Type:
        ELM_GENLIST_ITEM_NONE
        ELM_GENLIST_ITEM_TREE
        ELM_GENLIST_ITEM_GROUP
        ELM_GENLIST_ITEM_MAX

    ctypedef enum Elm_Genlist_Item_Field_Type:
        ELM_GENLIST_ITEM_FIELD_ALL
        ELM_GENLIST_ITEM_FIELD_TEXT
        ELM_GENLIST_ITEM_FIELD_CONTENT
        ELM_GENLIST_ITEM_FIELD_STATE

    ctypedef enum Elm_Genlist_Item_Scrollto_Type:
        ELM_GENLIST_ITEM_SCROLLTO_NONE
        ELM_GENLIST_ITEM_SCROLLTO_IN
        ELM_GENLIST_ITEM_SCROLLTO_TOP
        ELM_GENLIST_ITEM_SCROLLTO_MIDDLE
        ELM_GENLIST_ITEM_SCROLLTO_BOTTOM

    # gesture_layer
    ctypedef enum Elm_Gesture_State:
        ELM_GESTURE_STATE_UNDEFINED
        ELM_GESTURE_STATE_START
        ELM_GESTURE_STATE_MOVE
        ELM_GESTURE_STATE_END
        ELM_GESTURE_STATE_ABORT

    ctypedef enum Elm_Gesture_Type:
        ELM_GESTURE_FIRST
        ELM_GESTURE_N_TAPS
        ELM_GESTURE_N_LONG_TAPS
        ELM_GESTURE_N_DOUBLE_TAPS
        ELM_GESTURE_N_TRIPLE_TAPS
        ELM_GESTURE_MOMENTUM
        ELM_GESTURE_N_LINES
        ELM_GESTURE_N_FLICKS
        ELM_GESTURE_ZOOM
        ELM_GESTURE_ROTATE
        ELM_GESTURE_LAST

    # hover
    ctypedef enum Elm_Hover_Axis:
        ELM_HOVER_AXIS_NONE
        ELM_HOVER_AXIS_HORIZONTAL
        ELM_HOVER_AXIS_VERTICAL
        ELM_HOVER_AXIS_BOTH

    # icon
    ctypedef enum Elm_Icon_Lookup_Order:
        ELM_ICON_LOOKUP_FDO_THEME
        ELM_ICON_LOOKUP_THEME_FDO
        ELM_ICON_LOOKUP_FDO
        ELM_ICON_LOOKUP_THEME

    ctypedef enum Elm_Icon_Type:
        ELM_ICON_NONE
        ELM_ICON_FILE
        ELM_ICON_STANDARD

    # image
    ctypedef enum Elm_Image_Orient:
        ELM_IMAGE_ORIENT_NONE
        ELM_IMAGE_ORIENT_0
        ELM_IMAGE_ROTATE_90
        ELM_IMAGE_ROTATE_180
        ELM_IMAGE_ROTATE_270
        ELM_IMAGE_FLIP_HORIZONTAL
        ELM_IMAGE_FLIP_VERTICAL
        ELM_IMAGE_FLIP_TRANSPOSE
        ELM_IMAGE_FLIP_TRANSVERSE

    # label

    ctypedef enum Elm_Label_Slide_Mode:
        ELM_LABEL_SLIDE_MODE_NONE
        ELM_LABEL_SLIDE_MODE_AUTO
        ELM_LABEL_SLIDE_MODE_ALWAYS

    # list
    ctypedef enum Elm_List_Mode:
        ELM_LIST_COMPRESS
        ELM_LIST_SCROLL
        ELM_LIST_LIMIT
        ELM_LIST_EXPAND

    # map
    ctypedef enum Elm_Map_Overlay_Type:
        ELM_MAP_OVERLAY_TYPE_NONE
        ELM_MAP_OVERLAY_TYPE_DEFAULT
        ELM_MAP_OVERLAY_TYPE_CLASS
        ELM_MAP_OVERLAY_TYPE_GROUP
        ELM_MAP_OVERLAY_TYPE_BUBBLE
        ELM_MAP_OVERLAY_TYPE_ROUTE
        ELM_MAP_OVERLAY_TYPE_LINE
        ELM_MAP_OVERLAY_TYPE_POLYGON
        ELM_MAP_OVERLAY_TYPE_CIRCLE
        ELM_MAP_OVERLAY_TYPE_SCALE

    ctypedef enum Elm_Map_Route_Method:
        ELM_MAP_ROUTE_METHOD_FASTEST
        ELM_MAP_ROUTE_METHOD_SHORTEST
        ELM_MAP_ROUTE_METHOD_LAST

    ctypedef enum Elm_Map_Route_Type:
        ELM_MAP_ROUTE_TYPE_MOTOCAR
        ELM_MAP_ROUTE_TYPE_BICYCLE
        ELM_MAP_ROUTE_TYPE_FOOT
        ELM_MAP_ROUTE_TYPE_LAST

    ctypedef enum Elm_Map_Source_Type:
        ELM_MAP_SOURCE_TYPE_TILE
        ELM_MAP_SOURCE_TYPE_ROUTE
        ELM_MAP_SOURCE_TYPE_NAME
        ELM_MAP_SOURCE_TYPE_LAST

    ctypedef enum Elm_Map_Zoom_Mode:
        ELM_MAP_ZOOM_MODE_MANUAL
        ELM_MAP_ZOOM_MODE_AUTO_FIT
        ELM_MAP_ZOOM_MODE_AUTO_FILL
        ELM_MAP_ZOOM_MODE_LAST

    # need
    ctypedef enum Elm_Sys_Notify_Closed_Reason:
        ELM_SYS_NOTIFY_CLOSED_EXPIRED
        ELM_SYS_NOTIFY_CLOSED_DISMISSED
        ELM_SYS_NOTIFY_CLOSED_REQUESTED
        ELM_SYS_NOTIFY_CLOSED_UNDEFINED

    # notify
    ctypedef enum Elm_Notify_Orient:
        ELM_NOTIFY_ORIENT_TOP
        ELM_NOTIFY_ORIENT_CENTER
        ELM_NOTIFY_ORIENT_BOTTOM
        ELM_NOTIFY_ORIENT_LEFT
        ELM_NOTIFY_ORIENT_RIGHT
        ELM_NOTIFY_ORIENT_TOP_LEFT
        ELM_NOTIFY_ORIENT_TOP_RIGHT
        ELM_NOTIFY_ORIENT_BOTTOM_LEFT
        ELM_NOTIFY_ORIENT_BOTTOM_RIGHT
        ELM_NOTIFY_ORIENT_LAST

    # object
    ctypedef enum Elm_Object_Select_Mode:
        ELM_OBJECT_SELECT_MODE_DEFAULT
        ELM_OBJECT_SELECT_MODE_ALWAYS
        ELM_OBJECT_SELECT_MODE_NONE
        ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY
        ELM_OBJECT_SELECT_MODE_MAX

    ctypedef enum Elm_Object_Multi_Select_Mode:
        ELM_OBJECT_MULTI_SELECT_MODE_DEFAULT
        ELM_OBJECT_MULTI_SELECT_MODE_WITH_CONTROL
        ELM_OBJECT_MULTI_SELECT_MODE_MAX

    ctypedef enum Elm_Object_Layer:
        ELM_OBJECT_LAYER_BACKGROUND # where to place backgrounds
        ELM_OBJECT_LAYER_DEFAULT # Evas_Object default layer (and thus for Elementary)
        ELM_OBJECT_LAYER_FOCUS # where focus object visualization is
        ELM_OBJECT_LAYER_TOOLTIP # where to show tooltips
        ELM_OBJECT_LAYER_CURSOR # where to show cursors
        ELM_OBJECT_LAYER_LAST # last layer known by Elementary

    # panel
    ctypedef enum Elm_Panel_Orient:
        ELM_PANEL_ORIENT_TOP
        ELM_PANEL_ORIENT_BOTTOM
        ELM_PANEL_ORIENT_LEFT
        ELM_PANEL_ORIENT_RIGHT

    # photocam
    ctypedef enum Elm_Photocam_Zoom_Mode:
        ELM_PHOTOCAM_ZOOM_MODE_MANUAL
        ELM_PHOTOCAM_ZOOM_MODE_AUTO_FIT
        ELM_PHOTOCAM_ZOOM_MODE_AUTO_FILL
        ELM_PHOTOCAM_ZOOM_MODE_AUTO_FIT_IN
        ELM_PHOTOCAM_ZOOM_MODE_LAST

    # popup
    ctypedef enum Elm_Popup_Orient:
        ELM_POPUP_ORIENT_TOP
        ELM_POPUP_ORIENT_CENTER
        ELM_POPUP_ORIENT_BOTTOM
        ELM_POPUP_ORIENT_LEFT
        ELM_POPUP_ORIENT_RIGHT
        ELM_POPUP_ORIENT_TOP_LEFT
        ELM_POPUP_ORIENT_TOP_RIGHT
        ELM_POPUP_ORIENT_BOTTOM_LEFT
        ELM_POPUP_ORIENT_BOTTOM_RIGHT
        ELM_POPUP_ORIENT_LAST

    # scroller
    ctypedef enum Elm_Scroller_Policy:
        ELM_SCROLLER_POLICY_AUTO
        ELM_SCROLLER_POLICY_ON
        ELM_SCROLLER_POLICY_OFF

    ctypedef enum Elm_Scroller_Single_Direction:
        ELM_SCROLLER_SINGLE_DIRECTION_NONE
        ELM_SCROLLER_SINGLE_DIRECTION_SOFT
        ELM_SCROLLER_SINGLE_DIRECTION_HARD
        ELM_SCROLLER_SINGLE_DIRECTION_LAST

    ctypedef enum Elm_Scroller_Movement_Block:
        ELM_SCROLLER_MOVEMENT_NO_BLOCK
        ELM_SCROLLER_MOVEMENT_BLOCK_VERTICAL
        ELM_SCROLLER_MOVEMENT_BLOCK_HORIZONTAL

    # slider
    ctypedef enum Elm_Slider_Indicator_Visible_Mode:
        ELM_SLIDER_INDICATOR_VISIBLE_MODE_DEFAULT
        ELM_SLIDER_INDICATOR_VISIBLE_MODE_ALWAYS
        ELM_SLIDER_INDICATOR_VISIBLE_MODE_ON_FOCUS
        ELM_SLIDER_INDICATOR_VISIBLE_MODE_NONE

    # thumb
    ctypedef enum Elm_Thumb_Animation_Setting:
        ELM_THUMB_ANIMATION_START
        ELM_THUMB_ANIMATION_LOOP
        ELM_THUMB_ANIMATION_STOP
        ELM_THUMB_ANIMATION_LAST

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

    # toolbar
    ctypedef enum Elm_Toolbar_Item_Scrollto_Type:
        ELM_TOOLBAR_ITEM_SCROLLTO_NONE
        ELM_TOOLBAR_ITEM_SCROLLTO_IN
        ELM_TOOLBAR_ITEM_SCROLLTO_FIRST
        ELM_TOOLBAR_ITEM_SCROLLTO_MIDDLE
        ELM_TOOLBAR_ITEM_SCROLLTO_LAST

    ctypedef enum Elm_Toolbar_Shrink_Mode:
        ELM_TOOLBAR_SHRINK_NONE
        ELM_TOOLBAR_SHRINK_HIDE
        ELM_TOOLBAR_SHRINK_SCROLL
        ELM_TOOLBAR_SHRINK_MENU
        ELM_TOOLBAR_SHRINK_EXPAND
        ELM_TOOLBAR_SHRINK_LAST

    # transit
    ctypedef enum Elm_Transit_Effect_Flip_Axis:
        ELM_TRANSIT_EFFECT_FLIP_AXIS_X
        ELM_TRANSIT_EFFECT_FLIP_AXIS_Y

    ctypedef enum Elm_Transit_Effect_Wipe_Dir:
        ELM_TRANSIT_EFFECT_WIPE_DIR_LEFT
        ELM_TRANSIT_EFFECT_WIPE_DIR_RIGHT
        ELM_TRANSIT_EFFECT_WIPE_DIR_UP
        ELM_TRANSIT_EFFECT_WIPE_DIR_DOWN

    ctypedef enum Elm_Transit_Effect_Wipe_Type:
        ELM_TRANSIT_EFFECT_WIPE_TYPE_HIDE
        ELM_TRANSIT_EFFECT_WIPE_TYPE_SHOW

    ctypedef enum Elm_Transit_Tween_Mode:
        ELM_TRANSIT_TWEEN_MODE_LINEAR
        ELM_TRANSIT_TWEEN_MODE_SINUSOIDAL
        ELM_TRANSIT_TWEEN_MODE_DECELERATE
        ELM_TRANSIT_TWEEN_MODE_ACCELERATE
        ELM_TRANSIT_TWEEN_MODE_DIVISOR_INTERP
        ELM_TRANSIT_TWEEN_MODE_BOUNCE
        ELM_TRANSIT_TWEEN_MODE_SPRING
        ELM_TRANSIT_TWEEN_MODE_BEZIER_CURVE

    # web
    ctypedef enum Elm_Web_Window_Feature_Flag:
        ELM_WEB_WINDOW_FEATURE_TOOLBAR
        ELM_WEB_WINDOW_FEATURE_STATUSBAR
        ELM_WEB_WINDOW_FEATURE_SCROLLBARS
        ELM_WEB_WINDOW_FEATURE_MENUBAR
        ELM_WEB_WINDOW_FEATURE_LOCATIONBAR
        ELM_WEB_WINDOW_FEATURE_FULLSCREEN

    ctypedef enum Elm_Web_Zoom_Mode:
        ELM_WEB_ZOOM_MODE_MANUAL
        ELM_WEB_ZOOM_MODE_AUTO_FIT
        ELM_WEB_ZOOM_MODE_AUTO_FILL

    # window
    ctypedef enum Elm_Win_Type:
        ELM_WIN_UNKNOWN
        ELM_WIN_BASIC
        ELM_WIN_DIALOG_BASIC
        ELM_WIN_DESKTOP
        ELM_WIN_DOCK
        ELM_WIN_TOOLBAR
        ELM_WIN_MENU
        ELM_WIN_UTILITY
        ELM_WIN_SPLASH
        ELM_WIN_DROPDOWN_MENU
        ELM_WIN_POPUP_MENU
        ELM_WIN_TOOLTIP
        ELM_WIN_NOTIFICATION
        ELM_WIN_COMBO
        ELM_WIN_DND
        ELM_WIN_INLINED_IMAGE
        ELM_WIN_SOCKET_IMAGE

    ctypedef enum Elm_Win_Indicator_Mode:
        ELM_WIN_INDICATOR_UNKNOWN
        ELM_WIN_INDICATOR_HIDE
        ELM_WIN_INDICATOR_SHOW

    ctypedef enum Elm_Win_Indicator_Opacity_Mode:
        ELM_WIN_INDICATOR_OPACITY_UNKNOWN
        ELM_WIN_INDICATOR_OPAQUE
        ELM_WIN_INDICATOR_TRANSLUCENT
        ELM_WIN_INDICATOR_TRANSPARENT

    ctypedef enum Elm_Win_Keyboard_Mode:
        ELM_WIN_KEYBOARD_UNKNOWN
        ELM_WIN_KEYBOARD_OFF
        ELM_WIN_KEYBOARD_ON
        ELM_WIN_KEYBOARD_ALPHA
        ELM_WIN_KEYBOARD_NUMERIC
        ELM_WIN_KEYBOARD_PIN
        ELM_WIN_KEYBOARD_PHONE_NUMBER
        ELM_WIN_KEYBOARD_HEX
        ELM_WIN_KEYBOARD_TERMINAL
        ELM_WIN_KEYBOARD_PASSWORD
        ELM_WIN_KEYBOARD_IP
        ELM_WIN_KEYBOARD_HOST
        ELM_WIN_KEYBOARD_FILE
        ELM_WIN_KEYBOARD_URL
        ELM_WIN_KEYBOARD_KEYPAD
        ELM_WIN_KEYBOARD_J2ME

    ctypedef enum Elm_Illume_Command:
        ELM_ILLUME_COMMAND_FOCUS_BACK
        ELM_ILLUME_COMMAND_FOCUS_FORWARD
        ELM_ILLUME_COMMAND_FOCUS_HOME
        ELM_ILLUME_COMMAND_CLOSE
