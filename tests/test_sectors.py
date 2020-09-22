"""
Sectors look like this
    A B C D
    E F G H
    I J K L
    M N O P
So each sub sector has a letter associated with it and an optional subsector title.
Possible test cases could be
    I can create a blank sector
    I can create an entire sector
    I can create a sector with 1 subsector filled in
        I can specify which subsector will be filled in
    I can create a sector with some specified subsectors filled in

"""

import unittest
import sectorGenerator as sg
import lxml.etree as et

count_sectors = et.XPath("count(sector)")
count_subsectors = et.XPath("count(/sector/subsector)")
count_hexes = et.XPath("count(/sector/subsector/hex)")
count_contents = et.XPath("count(/sector/subsector/hex/contents)")


class TestSectorCreation(unittest.TestCase):

    def setUp(self):
        pass

    def test_create_a_blank_sector(self):
        sector_data = sg.sector_data()
        result = sg.generate_sector(sector_data)
        self.assertEqual(count_sectors(result), 1)
        self.assertEqual(count_subsectors(result), 16)
        self.assertEqual(count_hexes(result), 80)
        self.assertEqual(count_contents(result), 0)

    def test_create_entire_sector(self):
        # not super comfortable with this implementation of sector_data
        sector_data = sg.sector_data(
            True,
            True,
            True,
            True,
            True,
            True,
            True,
            True,
            True,
            True,
            True,
            True,
            True,
            True,
            True,
            True
        )
        result = sg.generate_sector(sector_data)
        self.assertEqual(count_sectors(result), 1)
        self.assertEqual(count_subsectors(result), 16)
        self.assertEqual(count_hexes(result), 80)
        self.assertEqual(count_contents(result), 0)