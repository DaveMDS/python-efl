import efl.emotion
from efl.emotion import *

class Emotion(efl.emotion.Emotion):
    def __init__(self, *args, **kwargs):
        if "module_filename" in kwargs.keys():
            kwargs["module_name"] = kwargs.pop("module_filename")
        efl.emotion.Emotion.__init__(self, *args, **kwargs)
