import lxml.etree as et
"""
Subsectors are laid out in hexes.
Hexes have 10 "rows" and 8 columns for
    80 hexs to a subsector.
Each hex has a 50% chance of containing a world.
"""


class Subsector:

    def generate_subsector(self, data):
        subsector = et.Element("subsector")
        hexes = [et.Element("hex") for num in range(1, 81)]
        subsector.extend(hexes)
        return subsector

    def _blank_subsector(self):
        pass
