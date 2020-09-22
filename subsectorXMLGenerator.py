import lxml.etree as et
from planetGenerator import determineTradeClassifications as dtc


class subsector(object):
    def __init__(self, density, title=None):
        self.title = title
        self.density = density

    def getSubSector(self):
        return self

    def subSectorXML(self):
        pass


class subsectorHex(object):
    def __init__(self, density, number):
        pass


def assginClassifications(xmlfile):
    xml = et.parse(xmlfile)
    worlds = xml.xpath(".//system/world")
    for world in worlds:
        upp = world.get("upp")
        notes, classes = dtc(upp)
        try:
            tc = world.xpath("./tradeClassifications")[0]
            tc.clear()
        except IndexError:
            tc = et.Element("tradeClassifications")
        tn = et.Element("tradeNotes")
        tn.text = notes
        for tclass in classes:
            tclassEl = et.Element("class")
            tclassEl.text = tclass
            tc.append(tclassEl)
        tc.append(tn)
        world.append(tc)
    return xml
