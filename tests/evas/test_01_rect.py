#!/usr/bin/env python

from efl import evas
import unittest
import logging


class TestRectBasics(unittest.TestCase):
    def _test_values(self, r):
        self.assertEqual(r.x, 1)
        self.assertEqual(r.y, 2)
        self.assertEqual(r.w, 3)
        self.assertEqual(r.h, 4)

    def testConstructorList(self):
        r = evas.Rect(1, 2, 3, 4)
        self._test_values(r)

    def testConstructorTuple(self):
        r = evas.Rect((1, 2, 3, 4))
        self._test_values(r)

    def testConstructorRect(self):
        r = evas.Rect(evas.Rect(1, 2, 3, 4))
        self._test_values(r)

    def testConstructorKeywordsExplicit1(self):
        r = evas.Rect(x=1, y=2, w=3, h=4)
        self._test_values(r)

    def testConstructorKeywordsExplicit2(self):
        r = evas.Rect(left=1, top=2, width=3, height=4)
        self._test_values(r)

    def testConstructorKeywordsExplicit3(self):
        r = evas.Rect(left=1, right=4, top=2, bottom=6)
        self._test_values(r)

    def testConstructorKeywordsExplicit4(self):
        r = evas.Rect(right=4, bottom=6, width=3, height=4)
        self._test_values(r)

    def testConstructorKeywordsPosSize(self):
        r = evas.Rect(pos=(1, 2), size=(3, 4))
        self._test_values(r)

    def testConstructorKeywordsGeometry(self):
        r = evas.Rect(geometry=(1, 2, 3, 4))
        self._test_values(r)

    def testConstructorKeywordsRect(self):
        r = evas.Rect(rect=evas.Rect(1, 2, 3, 4))
        self._test_values(r)


class TestRectOperations(unittest.TestCase):
    def setUp(self):
        self.r = evas.Rect(10, 20, 30, 40)

    def testContains(self):
        r2 = evas.Rect(11, 21, 5, 5)
        self.assertEqual(r2 in self.r, True)

    def testContainsExactly(self):
        r2 = evas.Rect(self.r)
        self.assertEqual(r2 in self.r, True)

    def testContainsLarger(self):
        r2 = evas.Rect(0, 0, 100, 100)
        self.assertEqual(r2 in self.r, False)

    def testContainsOverlap1(self):
        r2 = evas.Rect(0, 0, 20, 30)
        self.assertEqual(r2 in self.r, False)

    def testContainsOverlap2(self):
        r2 = evas.Rect(15, 25, 50, 50)
        self.assertEqual(r2 in self.r, False)

    def testContainsTuple(self):
        self.assertEqual((11, 21, 5, 5) in self.r, True)

    def testContainsTupleLarger(self):
        self.assertEqual((0, 0, 100, 100) in self.r, False)

    def testContainsPoint(self):
        self.assertEqual((15, 25) in self.r, True)

    def testContainsPointNo(self):
        self.assertEqual((0, 0) in self.r, False)

    def testEqual(self):
        self.assertEqual(self.r == self.r, True)

    def testEqualOther(self):
        self.assertEqual(self.r == evas.Rect(self.r), True)

    def testEqualTuple(self):
        self.assertEqual(self.r == (10, 20, 30, 40), True)

    def testEqualOtherNo(self):
        self.assertEqual(self.r == evas.Rect(1, 2, 3, 4), False)

    def testEqualTupleNo(self):
        self.assertEqual(self.r == (1, 2, 3, 4), False)

    def testNotEqual(self):
        self.assertEqual(self.r != self.r, False)

    def testNotEqualOther(self):
        self.assertEqual(self.r != evas.Rect(self.r), False)

    def testNotEqualTuple(self):
        self.assertEqual(self.r != (10, 20, 30, 40), False)

    def testNotEqualOtherNo(self):
        self.assertEqual(self.r != evas.Rect(1, 2, 3, 4), True)

    def testNotEqualTupleNo(self):
        self.assertEqual(self.r != (1, 2, 3, 4), True)

    def testNormalize(self):
        r2 = evas.Rect(left=10, right=0, top=20, bottom=0)
        self.assertEqual(r2.left, 10)
        self.assertEqual(r2.right, 0)
        self.assertEqual(r2.top, 20)
        self.assertEqual(r2.bottom, 0)
        self.assertEqual(r2.w, -10)
        self.assertEqual(r2.h, -20)
        r2.normalize()
        self.assertEqual(r2.left, 0)
        self.assertEqual(r2.right, 10)
        self.assertEqual(r2.top, 0)
        self.assertEqual(r2.bottom, 20)
        self.assertEqual(r2.w, 10)
        self.assertEqual(r2.h, 20)

    def testNonZero(self):
        self.assertEqual(bool(self.r), True)

    def testNonZero2(self):
        self.assertEqual(bool(evas.Rect(0, 0, 0, 0)), False)


class TestRectIntersects(unittest.TestCase):
    def setUp(self):
        self.r = evas.Rect(0, 0, 10, 10)

    def testOver(self):
        r2 = evas.Rect(self.r)
        self.assert_(self.r.intersects(r2))

    def testCross(self):
        r2 = evas.Rect(2, -2, 6, 14)
        self.assert_(self.r.intersects(r2))

    def testIntersectTopLeft(self):
        r2 = evas.Rect(-5, -5, 10, 10)
        self.assert_(self.r.intersects(r2))

    def testIntersectTopRight(self):
        r2 = evas.Rect(5, -5, 10, 10)
        self.assert_(self.r.intersects(r2))

    def testIntersectBottomLeft(self):
        r2 = evas.Rect(-5, 5, 10, 10)
        self.assert_(self.r.intersects(r2))

    def testIntersectBottomRight(self):
        r2 = evas.Rect(5, 5, 10, 10)
        self.assert_(self.r.intersects(r2))

    def testIntersectLeft1(self):
        r2 = evas.Rect(-5, 0, 10, 10)
        self.assert_(self.r.intersects(r2))

    def testIntersectLeft2(self):
        r2 = evas.Rect(-5, 2, 10, 5)
        self.assert_(self.r.intersects(r2))

    def testIntersectLeft3(self):
        r2 = evas.Rect(-5, 5, 30, 5)
        self.assert_(self.r.intersects(r2))

    def testIntersectRight1(self):
        r2 = evas.Rect(5, 0, 10, 10)
        self.assert_(self.r.intersects(r2))

    def testIntersectRight2(self):
        r2 = evas.Rect(5, 2, 10, 5)
        self.assert_(self.r.intersects(r2))

    def testIntersectRight3(self):
        r2 = evas.Rect(5, 5, 30, 5)
        self.assert_(self.r.intersects(r2))

    def testIntersectTop1(self):
        r2 = evas.Rect(0, -5, 10, 10)
        self.assert_(self.r.intersects(r2))

    def testIntersectTop2(self):
        r2 = evas.Rect(2, -5, 5, 10)
        self.assert_(self.r.intersects(r2))

    def testIntersectTop3(self):
        r2 = evas.Rect(5, -5, 5, 30)
        self.assert_(self.r.intersects(r2))

    def testIntersectBottom1(self):
        r2 = evas.Rect(0, 5, 10, 10)
        self.assert_(self.r.intersects(r2))

    def testIntersectBottom2(self):
        r2 = evas.Rect(2, 5, 5, 10)
        self.assert_(self.r.intersects(r2))

    def testIntersectBottom3(self):
        r2 = evas.Rect(5, 5, 5, 30)
        self.assert_(self.r.intersects(r2))

    def testNoIntersect1(self):
        r2 = evas.Rect(-10, -10, 5, 5)
        self.assert_(not self.r.intersects(r2))

    def testNoIntersect2(self):
        r2 = evas.Rect(0, -10, 5, 5)
        self.assert_(not self.r.intersects(r2))

    def testNoIntersect3(self):
        r2 = evas.Rect(10, -10, 5, 5)
        self.assert_(not self.r.intersects(r2))

    def testNoIntersect4(self):
        r2 = evas.Rect(-10, -10, 30, 5)
        self.assert_(not self.r.intersects(r2))

    def testNoIntersect5(self):
        r2 = evas.Rect(-10, 15, 5, 5)
        self.assert_(not self.r.intersects(r2))

    def testNoIntersect6(self):
        r2 = evas.Rect(0, 15, 5, 5)
        self.assert_(not self.r.intersects(r2))

    def testNoIntersect7(self):
        r2 = evas.Rect(10, 15, 5, 5)
        self.assert_(not self.r.intersects(r2))

    def testNoIntersect8(self):
        r2 = evas.Rect(-10, 15, 30, 5)
        self.assert_(not self.r.intersects(r2))

    def testNoIntersect9(self):
        r2 = evas.Rect(-10, 5, 5, 5)
        self.assert_(not self.r.intersects(r2))

    def testNoIntersect10(self):
        r2 = evas.Rect(15, 5, 5, 5)
        self.assert_(not self.r.intersects(r2))

    def testNoIntersect11(self):
        r2 = evas.Rect(15, 15, 5, 5)
        self.assert_(not self.r.intersects(r2))


class TestRectClip(unittest.TestCase):
    def setUp(self):
        self.r = evas.Rect(0, 0, 10, 10)

    def testClipContained(self):
        r2 = evas.Rect(-10, -10, 30, 30)
        self.assertEqual(self.r.clip(r2), self.r)

    def testClipContains(self):
        r2 = evas.Rect(5, 5, 2, 2)
        self.assertEqual(self.r.clip(r2), r2)

    def testClipOutside1(self):
        r2 = evas.Rect(-10, -10, 5, 5)
        self.assertEqual(self.r.clip(r2), evas.Rect(0, 0, 0, 0))

    def testClipOutside2(self):
        r2 = evas.Rect(15, 15, 5, 5)
        self.assertEqual(self.r.clip(r2), evas.Rect(0, 0, 0, 0))

    def testClipOutside3(self):
        r2 = evas.Rect(-10, -10, 30, 5)
        self.assertEqual(self.r.clip(r2), evas.Rect(0, 0, 0, 0))

    def testClipTopLeft(self):
        r2 = evas.Rect(-5, -5, 10, 10)
        self.assertEqual(self.r.clip(r2), evas.Rect(0, 0, 5, 5))

    def testClipTopRight(self):
        r2 = evas.Rect(5, -5, 10, 10)
        self.assertEqual(self.r.clip(r2), evas.Rect(5, 0, 5, 5))

    def testClipBottomLeft(self):
        r2 = evas.Rect(-5, 5, 10, 10)
        self.assertEqual(self.r.clip(r2), evas.Rect(0, 5, 5, 5))

    def testClipBottomRight(self):
        r2 = evas.Rect(5, 5, 10, 10)
        self.assertEqual(self.r.clip(r2), evas.Rect(5, 5, 5, 5))

    def testClipLeft(self):
        r2 = evas.Rect(-5, 2, 10, 5)
        self.assertEqual(self.r.clip(r2), evas.Rect(0, 2, 5, 5))

    def testClipRight(self):
        r2 = evas.Rect(5, 2, 10, 5)
        self.assertEqual(self.r.clip(r2), evas.Rect(5, 2, 5, 5))

    def testClipTop(self):
        r2 = evas.Rect(2, -5, 5, 10)
        self.assertEqual(self.r.clip(r2), evas.Rect(2, 0, 5, 5))

    def testClipBottom(self):
        r2 = evas.Rect(2, 5, 5, 10)
        self.assertEqual(self.r.clip(r2), evas.Rect(2, 5, 5, 5))


class TestRectUnion(unittest.TestCase):
    def setUp(self):
        self.r = evas.Rect(0, 0, 10, 10)

    def testUnionContained(self):
        r2 = evas.Rect(-10, -10, 30, 30)
        self.assertEqual(self.r.union(r2), r2)

    def testUnionContains(self):
        r2 = evas.Rect(5, 5, 2, 2)
        self.assertEqual(self.r.union(r2), self.r)

    def testUnion(self):
        r2 = evas.Rect(-10, -10, 5, 5)
        self.assertEqual(self.r.union(r2), evas.Rect(-10, -10, 20, 20))


class TestRectClamp(unittest.TestCase):
    def setUp(self):
        self.r = evas.Rect(0, 0, 10, 10)

    def testClampContained(self):
        r2 = evas.Rect(-10, -10, 30, 30)
        self.assertEqual(self.r.clamp(r2), self.r)

    def testClampContains(self):
        r2 = evas.Rect(0, 0, 4, 4)
        # -3 = 4/2 - 5/2 (centered)
        self.assertEqual(self.r.clamp(r2), evas.Rect(-3, -3, 10, 10))

    def testClampTopLeft(self):
        r2 = evas.Rect(5, 5, 20, 20)
        self.assertEqual(self.r.clamp(r2), evas.Rect(5, 5, 10, 10))

    def testClampTopRight(self):
        r2 = evas.Rect(-15, 5, 20, 20)
        self.assertEqual(self.r.clamp(r2), evas.Rect(-5, 5, 10, 10))

    def testClampBottomLeft(self):
        r2 = evas.Rect(5, -15, 20, 20)
        self.assertEqual(self.r.clamp(r2), evas.Rect(5, -5, 10, 10))

    def testClampBottomRight(self):
        r2 = evas.Rect(-15, -15, 20, 20)
        self.assertEqual(self.r.clamp(r2), evas.Rect(-5, -5, 10, 10))


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
