#!/usr/bin/env python

from efl import evas
from efl.edje import EDJE_PART_TYPE_RECTANGLE
from efl.edje_edit import EdjeEdit, Text_Style, Text_Style_Tag, Color_Class, \
                          Part, State, Program
import os, unittest, shutil
import logging


theme_path = os.path.dirname(os.path.abspath(__file__))
orig_theme_file = os.path.join(theme_path, "theme.edj")
theme_file = os.path.join(theme_path, "theme_working.edj")


class TestEdjeEditBase(unittest.TestCase):
    def setUp(self):
        # copy the edje file to a temp one as we are going to edit it
        shutil.copy(orig_theme_file, theme_file)

        self.canvas = evas.Canvas(method="buffer",
                                  size=(400, 500),
                                  viewport=(0, 0, 400, 500))
        self.canvas.engine_info_set(self.canvas.engine_info_get())

    def tearDown(self):
        self.canvas.delete()
        os.remove(theme_file)


    def testConstructor(self):
        o = EdjeEdit(self.canvas, file=theme_file, group="main")
        self.assertIsInstance(o, EdjeEdit)
        o.delete()
        self.assertTrue(o.is_deleted())


class TestEdjeEditGeneral(unittest.TestCase):
    def setUp(self):
        shutil.copy(orig_theme_file, theme_file)
        self.canvas = evas.Canvas(method="buffer",
                                  size=(400, 500),
                                  viewport=(0, 0, 400, 500))
        self.canvas.engine_info_set(self.canvas.engine_info_get())
        self.o = EdjeEdit(self.canvas, file=theme_file, group="main")

    def tearDown(self):
        self.o.delete()
        self.canvas.delete()
        os.remove(theme_file)

    def testGeneral(self):
        self.assertEqual(self.o.compiler_get(), "edje_cc")
        self.assertEqual(self.o.file_get(), (theme_file, "main"))
        # self.o.print_internal_status() # FIXME this crash badly

    def testGroup(self):
        g = self.o.current_group

        self.assertEqual((g.w_min, g.w_max), (200, 400))
        self.assertEqual((g.h_min, g.h_max), (200, 400))

        g.w_min = g.h_min = 201
        g.w_max = g.h_max = 401

        self.assertEqual((g.w_min, g.w_max), (201, 401))
        self.assertEqual((g.h_min, g.h_max), (201, 401))

        # TODO test g.rename

    def testGroupAddDel(self):
        self.assertFalse(self.o.group_exist("test_new_group"))
        self.o.group_add("test_new_group")
        self.assertTrue(self.o.group_exist("test_new_group"))
        self.o.group_del("test_new_group")
        self.assertFalse(self.o.group_exist("test_new_group"))

    def testData(self):
        self.assertIn("key1", self.o.data)
        self.assertIn("key2", self.o.data)

        self.assertEqual(self.o.data_get("key1"), "value1")
        self.assertEqual(self.o.data_get("key2"), "value2")

        self.o.data_set("key1", "new_value1")
        self.o.data_set("key2", "new_value2")
        self.assertEqual(self.o.data_get("key1"), "new_value1")
        self.assertEqual(self.o.data_get("key2"), "new_value2")

        self.o.data_add("key5", "value5")
        self.assertEqual(self.o.data_get("key5"), "value5")

        self.o.data_rename("key5", "key55")
        self.assertEqual(self.o.data_get("key55"), "value5")

        self.o.data_del("key44")       # FIXME this crash badly
        self.assertNotIn("key44", self.o.data)

    def testGroupData(self):
        self.assertIn("key3", self.o.group_data)
        self.assertIn("key4", self.o.group_data)

        self.assertEqual(self.o.group_data_get("key3"), "value3")
        self.assertEqual(self.o.group_data_get("key4"), "value4")

        self.o.group_data_set("key3", "new_value3")
        self.o.group_data_set("key4", "new_value4")
        self.assertEqual(self.o.group_data_get("key3"), "new_value3")
        self.assertEqual(self.o.group_data_get("key4"), "new_value4")

        self.o.group_data_add("key6", "value6")
        self.assertEqual(self.o.group_data_get("key6"), "value6")

        self.o.group_data_del("key6")
        self.assertNotIn("key6", self.o.group_data)

    def testTextStyles(self):
        self.assertIn("style1", self.o.text_styles)
        self.assertIn("style2", self.o.text_styles)
        self.assertNotIn("styleNOTEXISTS", self.o.text_styles)

        style = self.o.text_style_get("style1")
        self.assertIsInstance(style, Text_Style)
        self.assertIn("DEFAULT", style.tags)
        self.assertIn("br", style.tags)
        self.assertIn("tab", style.tags)
        self.assertNotIn("b", style.tags)

        tag = style.tag_get("DEFAULT")
        self.assertIsInstance(tag, Text_Style_Tag)

        # TODO more test for tags add/del

    def testColorClasses(self):
        self.assertIn("colorclass1", self.o.color_classes)
        self.assertIn("colorclass2", self.o.color_classes)
        self.assertNotIn("colorclassNOTEXISTS", self.o.color_classes)

        cc1 = self.o.color_class_get("colorclass1")
        cc2 = self.o.color_class_get("colorclass2")
        self.assertIsInstance(cc1, Color_Class)
        self.assertIsInstance(cc2, Color_Class)

        self.assertEqual(cc1.name, "colorclass1")
        self.assertEqual(cc2.name, "colorclass2")

        cc1.name = "colorclass1_new"
        self.assertEqual(cc1.name, "colorclass1_new")

        self.assertEqual(cc1.colors_get(), ((1,2,3,4),(5,6,7,8),(9,10,11,12)))
        self.assertEqual(cc2.colors_get(), ((13,14,15,16),(17,18,19,20),(21,22,23,24)))

        cc1.colors_set(50,51,52,53, 54,55,56,57, 58,59,60,61)
        cc2.colors_set(70,71,72,73, 74,75,76,77, 78,79,80,81)
        self.assertEqual(cc1.colors_get(), ((50,51,52,53),(54,55,56,57),(58,59,60,61)))
        self.assertEqual(cc2.colors_get(), ((70,71,72,73),(74,75,76,77),(78,79,80,81)))

        self.o.color_class_add("colorclass3")
        self.assertIn("colorclass3", self.o.color_classes)
        cc3 = self.o.color_class_get("colorclass3")
        self.assertIsInstance(cc3, Color_Class)

        cc3.colors_set(85,86,87,88, 89,90,91,92, 93,94,95,96)
        self.assertEqual(cc3.colors_get(), ((85,86,87,88),(89,90,91,92),(93,94,95,96)))

        self.o.color_class_del("colorclass3")
        self.assertNotIn("colorclass3", self.o.color_classes)

    # @unittest.skip("need to fix external_del to not leave a NULL element") # TODO FIXME
    # def testExternal(self):
        # self.assertEqual(self.o.externals, ['elm'])
        # self.o.external_add('emotion')
        # self.assertEqual(self.o.externals, ['elm', 'emotion'])
        # self.o.external_del('emotion')
        # self.assertEqual(self.o.externals, ['elm'])

    # TODO test for images, image_id_get, image_del

    def testScript(self):
        self.assertEqual(len(self.o.script), 104)
        # TODO test setting .script, compile and .script_errors


class TestEdjeEditParts(unittest.TestCase):
    def setUp(self):
        shutil.copy(orig_theme_file, theme_file)
        self.canvas = evas.Canvas(method="buffer",
                                  size=(400, 500),
                                  viewport=(0, 0, 400, 500))
        self.canvas.engine_info_set(self.canvas.engine_info_get())
        self.o = EdjeEdit(self.canvas, file=theme_file, group="main")

    def tearDown(self):
        self.o.delete()
        self.canvas.delete()
        os.remove(theme_file)

    def testPart(self):
        self.assertEqual(len(self.o.parts), 6)
        self.assertTrue(self.o.part_exist("bg"))
        self.assertTrue(self.o.part_exist("rect"))
        self.assertFalse(self.o.part_exist("NOTEXIST"))

        p = self.o.part_get("rect")
        self.assertIsInstance(p, Part)
        self.assertEqual(p.type, EDJE_PART_TYPE_RECTANGLE)

    def testPartRename(self):
        p = self.o.part_get("rect")
        self.assertEqual(p.name, "rect")
        p.name = "rect_new_name"
        self.assertEqual(p.name, "rect_new_name")
        p.rename("rect")
        self.assertEqual(p.name, "rect")

    def testPartAdd(self):
        self.o.part_add("new_part", EDJE_PART_TYPE_RECTANGLE)
        self.assertTrue(self.o.part_exist("new_part"))
        self.assertEqual(len(self.o.parts), 7)

        p = self.o.part_get("new_part")
        self.assertIsInstance(p, Part)

    def testPartDel(self):
        self.assertTrue(self.o.part_exist("rect"))
        self.o.part_del("rect")
        self.assertFalse(self.o.part_exist("rect"))

    def testPartStacking(self):
        # print(self.o.parts)
        p = self.o.part_get("rect")
        self.assertEqual(p.below_get(), "bg")
        self.assertEqual(p.above_get(), "label")

        p.restack_below()
        p.restack_above()
        self.assertEqual(p.below_get(), "bg")
        self.assertEqual(p.above_get(), "label")

    def testPartClip(self):
        p = self.o.part_get("edit_test")
        self.assertEqual(p.clip_to, "test_clip")
        p.clip_to = "bg"
        self.assertEqual(p.clip_to, "bg")

    def testPartSource(self):
        p = self.o.part_get("edit_test")
        self.assertEqual(p.source, None)

    def testPartMouseEvents(self):
        p = self.o.part_get("edit_test")
        self.assertEqual(p.mouse_events, False)
        p.mouse_events = True
        self.assertEqual(p.mouse_events, True)

    def testPartRepeatEvents(self):
        p = self.o.part_get("edit_test")
        self.assertEqual(p.repeat_events, False)
        p.repeat_events = True
        self.assertEqual(p.repeat_events, True)

    # @unittest.expectedFailure
    # def testPartEffect(self):
        # p = self.o.part_get("edit_test")
        # self.assertEqual(p.effect, 18)
        # p.effect = 2
        # self.assertEqual(p.effect, 2)

    def testPartIgnoreFlags(self):
        p = self.o.part_get("edit_test")
        self.assertEqual(p.ignore_flags, 1)
        p.ignore_flags = 0
        self.assertEqual(p.ignore_flags, 0)

    def testPartScale(self):
        p = self.o.part_get("edit_test")
        self.assertEqual(p.scale, True)
        p.scale = False
        self.assertEqual(p.scale, False)

    def testPartDrag(self):
        p = self.o.part_get("edit_test")
        self.assertEqual(p.drag, (1,1))
        p.drag = (0,0)
        self.assertEqual(p.drag, (0,0))

    def testPartDragStep(self):
        p = self.o.part_get("edit_test")
        self.assertEqual(p.drag_step, (6,7))
        p.drag_step = (16,17)
        self.assertEqual(p.drag_step, (16,17))

    def testPartDragCount(self):
        p = self.o.part_get("edit_test")
        self.assertEqual(p.drag_count, (8,9))
        p.drag_count = (18,19)
        self.assertEqual(p.drag_count, (18,19))

    def testPartDragConfine(self):
        p = self.o.part_get("edit_test")
        self.assertEqual(p.drag_confine, "label")
        p.drag_confine = "bg"
        self.assertEqual(p.drag_confine, "bg")

    def testPartDragEvent(self):
        p = self.o.part_get("edit_test")
        self.assertEqual(p.drag_event, "edit_test_drag_event")
        p.drag_event = "edit_test_drag_event"
        self.assertEqual(p.drag_event, "edit_test_drag_event")

    def testPartApi(self):
        p = self.o.part_get("edit_test")
        self.assertEqual(p.api, ("api_name", "api_description"))
        p.api = ("new_api_name", "new_api_desc")
        self.assertEqual(p.api, ("new_api_name", "new_api_desc"))


class TestEdjeEditPrograms(unittest.TestCase):
    def setUp(self):
        shutil.copy(orig_theme_file, theme_file)
        self.canvas = evas.Canvas(method="buffer",
                                  size=(400, 500),
                                  viewport=(0, 0, 400, 500))
        self.canvas.engine_info_set(self.canvas.engine_info_get())
        self.o = EdjeEdit(self.canvas, file=theme_file, group="main")

    def tearDown(self):
        self.o.delete()
        self.canvas.delete()
        os.remove(theme_file)

    def testProgram(self):
        o = self.o
        self.assertIn("prog1", o.programs)
        self.assertIn("prog2", o.programs)
        self.assertIn("prog3", o.programs)
        self.assertNotIn("progNOTIN", o.programs)

        pr1 = o.program_get("prog1")
        self.assertIsInstance(pr1, Program)
        self.assertEqual(pr1.edje_get(), self.o)

        o.program_add("prog5")
        pr5 = o.program_get("prog5")
        self.assertIsInstance(pr5, Program)
        self.assertTrue(o.program_exist("prog5"))

        pr5.name = "prog10"
        self.assertTrue(o.program_exist("prog10"))
        self.assertFalse(o.program_exist("prog5"))

        pr5.rename("prog5")
        o.program_del("prog5")
        self.assertFalse(o.program_exist("prog5"))
        self.assertNotIn("prog5", o.programs)

        # TODO test Program.run()

    def testProgramSource(self):
        p = self.o.program_get("prog1")
        self.assertEqual(p.source_get(), "edit_test")
        p.source_set("edit_*")
        self.assertEqual(p.source_get(), "edit_*")

    def testProgramSignal(self):
        p = self.o.program_get("prog1")
        self.assertEqual(p.signal_get(), "mouse,down,1")
        p.signal_set("mouse,down,2")
        self.assertEqual(p.signal_get(), "mouse,down,2")

    def testProgramIn(self):
        p = self.o.program_get("prog1")
        self.assertEqual(p.in_from_get(), 1.1)
        self.assertEqual(p.in_range_get(), 2.2)
        p.in_from_set(3.3)
        p.in_range_set(4.4)
        self.assertEqual(p.in_from_get(), 3.3)
        self.assertEqual(p.in_range_get(), 4.4)

    def testProgramAction(self):
        p = self.o.program_get("prog1")
        self.assertEqual(p.action_get(), 1)
        p.action_set(2)
        self.assertEqual(p.action_get(), 2)
        # restore the original to not mess stuff
        p.action_set(1)

    def testProgramTargets(self):
        p = self.o.program_get("prog1")
        self.assertEqual(p.targets_get(), ["edit_test", "test_clip"])
        p.target_del("test_clip")
        self.assertEqual(p.targets_get(), ["edit_test"])
        p.target_add("test_clip")
        self.assertEqual(p.targets_get(), ["edit_test", "test_clip"])
        p.targets_clear()
        self.assertEqual(p.targets_get(), [])

    def testProgramAfters(self):
        p = self.o.program_get("prog1")
        self.assertEqual(p.afters_get(), ["prog2", "prog3"])
        p.after_del("prog2")
        self.assertEqual(p.afters_get(), ["prog3"])
        p.after_add("prog4")
        self.assertEqual(p.afters_get(), ["prog3", "prog4"])
        p.afters_clear()
        self.assertEqual(p.afters_get(), [])

    def testProgramState(self):
        p = self.o.program_get("prog1")
        self.assertEqual(p.state_get(), "state2")
        self.assertEqual(p.value_get(), 0.1)
        p.state_set("state1")
        p.value_set(0.0)
        self.assertEqual(p.state_get(), "state1")
        self.assertEqual(p.value_get(), 0.0)

    def testProgramApi(self):
        p = self.o.program_get("prog1")
        self.assertEqual(p.api, ("p_api_name", "p_api_desc"))
        p.api = ("new_name", "new_desc")
        self.assertEqual(p.api, ("new_name", "new_desc"))

    def testProgramScript(self):
        p = self.o.program_get("emit_back_message")
        self.assertIsInstance(p, Program)
        self.assertEqual(p.script.strip(), "send_message(MSG_INT, 1, 33);")


class TestEdjeEditPartStates(unittest.TestCase):
    def setUp(self):
        shutil.copy(orig_theme_file, theme_file)
        self.canvas = evas.Canvas(method="buffer",
                                  size=(400, 500),
                                  viewport=(0, 0, 400, 500))
        self.canvas.engine_info_set(self.canvas.engine_info_get())
        self.o = EdjeEdit(self.canvas, file=theme_file, group="main")

    def tearDown(self):
        self.o.delete()
        self.canvas.delete()
        os.remove(theme_file)

    #@unittest.skip("segfault") # FIXME
    def testPartStates(self):
        p = self.o.part_get("edit_test")
        self.assertEqual(p.states, ["default 0.00","state1 0.00","state2 0.00","state2 0.10"])

        # state_add()
        p.state_add("state9", 0.1)
        self.assertEqual(p.states, ["default 0.00","state1 0.00","state2 0.00","state2 0.10","state9 0.10"])

        # state_selected      TODO FIXME state_selected_set does not work
        self.assertEqual(p.state_selected_get(), ("default", 0.0))
        p.state_selected_set("state2", 0.1)
        self.assertEqual(p.state_selected_get(), ("state2", 0.1))

        # state del()         TODO FIXME state_del does not work
        p.state_del("state9", 0.1)
        self.assertEqual(p.states, ["default 0.00","state1 0.00","state2 0.00","state2 0.10"])

    # TODO test state_copy

    def testPartStateExist(self):
        p = self.o.part_get("edit_test")
        self.assertFalse(p.state_exist("stateNOTEXISTS", 0.1))
        self.assertTrue(p.state_exist("state1", 0.0))
        self.assertTrue(p.state_exist("state2", 0.1))

    def testPartStateProps(self):
        p = self.o.part_get("edit_test")
        s = p.state_get("state1", 0.0)
        self.assertIsInstance(s, State)
        # TODO test more State properties

if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
