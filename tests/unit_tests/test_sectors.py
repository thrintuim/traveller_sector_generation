"""
Sectors look like this
    A B C D
    E F G H
    I J K L
    M N O P
So each sub sector has a letter associated with it
    and an optional subsector title.
Possible test cases could be
    I can create a blank sector - What does a blank sector look like?
        Do we have all of the hexes and whatnot and none of the contents?
    I can create an entire sector - To test this we need to make sure there are
        some contents in the subsector that has been created.
    I can create a sector with 1 subsector filled in
        I can specify which subsector will be filled in
    I can create a sector with existing subsector XML
    I can create a sector with some specified subsectors filled in

"""

import unittest
from unittest.mock import Mock, call, patch
import sectorGenerator as sg
import lxml.etree as et

count_sectors = et.XPath("count(/sector)")
count_subsectors = et.XPath("count(/sector/subsector)")


class TestSectorCreation(unittest.TestCase):

    def setUp(self):
        pass

    @patch("sectorGenerator.Subsector")
    def test_create_sector(self, ssg):
        Subsector = Mock()
        Subsector.generate_subsector = Mock()
        subsector_mocks = [et.Element("subsector") for num in range(0, 16)]
        Subsector.generate_subsector.side_effect = subsector_mocks
        ssg.return_value = Subsector
        sector_data = sg.sector_data()
        calls = [call(x) for x in sector_data]
        result = sg.generate_sector(sector_data)
        self.assertEqual(count_sectors(result), 1)
        self.assertEqual(count_subsectors(result), 16)
        Subsector.generate_subsector.assert_has_calls(calls)


if __name__ == "__main__":
    unittest.main()
