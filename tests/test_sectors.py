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
from .. import sectorGenerator as sg
import lxml.etree as et

count_sectors = et.XPath("count(/sector)")
count_subsectors = et.XPath("count(/sector/subsector)")
count_hexes = et.XPath("count(/sector/subsector/hex)")
count_contents = et.XPath("count(.//hex/contents)")
get_subsectors = et.XPath("/sector/subsector")
get_specific_subsector = et.XPath("/sector/subsector[@position=$id]")


class TestSectorCreation(unittest.TestCase):

    def setUp(self):
        pass

    def basic_tests(self, result):
        self.assertEqual(count_sectors(result), 1)
        self.assertEqual(count_subsectors(result), 16)
        self.assertEqual(count_hexes(result), 1280)

    def specific_subsectors_have_contents(self, subsector_ids, result):
        for sec_id in subsector_ids:
            sec = get_specific_subsector(result, id=sec_id)[0]
            self.assertGreater(count_contents(sec), 0)

    def test_create_a_blank_sector(self):
        sector_data = sg.sector_data()
        result = sg.generate_sector(sector_data)
        self.basic_tests(result)
        self.assertEqual(count_contents(result), 0)

    def test_create_entire_sector(self):
        # not super comfortable with this implementation of sector_data
        data = [True for num in range(0, 16)]
        sector_data = sg.sector_data(*data)
        result = sg.generate_sector(sector_data)
        self.basic_tests(result)
        for subsector in get_subsectors(result):
            self.assertGreater(count_contents(subsector), 0)

    def test_create_single_sector(self):
        sector_data = sg.sector_data(J=True)
        result = sg.generate_sector(sector_data)
        self.basic_tests(result)
        self.specific_subsectors_have_contents("J", result)

    def test_create_sector_with_existing_subsector_xml(self):
        sector_data = sg.sector_data(G="sample3.xml")
        result = sg.generate_sector(sector_data)
        self.basic_tests(result)
        self.specific_subsectors_have_contents("G", result)
        self.assertEqual(
            result.xpath("count(/sector/subsector[position='G']//world[@name='Keats'])"),
            1
        )

    def test_create_sector_with_specific_sectors_generated(self):
        sector_data = sg.sector_data(C=True, G=True, F=True)
        result = sg.generate_sector(sector_data)
        self.basic_tests(result)
        self.specific_subsectors_have_contents("CGF", result)


if __name__ == "__main__":
    unittest.main()
