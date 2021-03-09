import collections
import lxml.etree as et
from subsectorGenerator import Subsector

sector_data = collections.namedtuple(
    "sector_data",
    "A B C D E F G H I J K L M N O P",
    defaults=[False for num in range(0, 16)]
)


def generate_sector(sector_data):
    sector = et.fromstring("<sector sectorName=''></sector>")
    for subsector_data in sector_data:
        subsector = Subsector()
        subsectorXml = subsector.generate_subsector(subsector_data)
        sector.append(subsectorXml)
    return sector
