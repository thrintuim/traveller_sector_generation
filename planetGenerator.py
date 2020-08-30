import random
import string
d6 = range(1, 7)


def rolld6():
    return random.choice(d6)


def roll2d6():
    return (random.choice(d6) + random.choice(d6))


def determineWorldOccurence(modifier=0):
    """
    Determine if there is a world in this hex
    a roll of
    """
    result = rolld6() + modifier
    if(result >= 4):
        return True
    else:
        return False


def determineStarPort():
    result = roll2d6()
    if result < 5:
        return "A"
    elif result < 7:
        return "B"
    elif result < 9:
        return "C"
    elif result < 10:
        return "D"
    elif result < 12:
        return "E"
    else:
        return "X"


def determineNavalBase(starPortValue):
    if starPortValue not in "AB":
        return False
    else:
        result = roll2d6()
        if result >= 8:
            return True
        else:
            return False


def determineScoutBase(starPortValue):
    if starPortValue is "A":
        modifier = -3
    elif starPortValue is "B":
        modifier = -2
    elif starPortValue is "C":
        modifier = -1
    elif starPortValue is "D":
        modifier = 0
    else:
        return False
    result = roll2d6() + modifier
    if result >= 7:
        return True
    else:
        return False


def determineGasGiant():
    result = roll2d6()
    if result <= 9:
        return True
    else:
        return False


def determinePlanetSize():
    """
    Roll 2d6 - 2 for planet size.
    1000s km diameter for planet
    """
    return roll2d6() - 2


def determineAtmo(planetSize):
    """
    Roll 2d6 - 7 + planetSize to
    determine the atmosphere type
    """
    if planetSize is 0:
        return 0
    else:
        result = roll2d6() - 7 + planetSize
        if result < 0:
            result = 0
        return result


def determineHydro(planetSize, planetAtmo):
    """
    Roll 2d6 - 7 + planetSize for hydrographics
    If planetSize is  0 then hydro is 0
    If planetAtmo is <= 1 or > 9 then -4 DM
    """
    if planetSize <= 0:
        return 0
    else:
        modifier = 0
        if planetAtmo >= 10 or planetAtmo <= 1:
            modifier = -4

        result = roll2d6() - 7 + planetSize + modifier
        if result < 0:
            result = 0
        return result


def determinePopulation():
    """
    Roll 2d6 - 2 for population.
    Represented as powers of 10
    """
    return roll2d6() - 2


def determineGovernment(population):
    """
    Roll 2d6 - 7 + population for government type.
    If population is 0 then govt is 0.
    """
    if population <= 0:
        return 0
    else:
        result = roll2d6() - 7 + population
        if result < 0:
            result = 0
        return result


def determineLawLevel(government, population):
    """
    Roll 2d6 - 7 + government for law level.
    If population is 0 then law level is 0.
    """
    if population <= 0:
        return 0
    else:
        result = roll2d6() - 7 + government
        if result < 0:
            result = 0
        return result


def determineTechLevel(upp):
    """
    Roll 1d6 plus modifiers for tech level.
    If population is 0 then tech level is 0.
    """
    planetPop = convertFromHex(upp[4])
    if planetPop < 1:
        return 0
    else:
        starPortValue = upp[0]
        planetSize = convertFromHex(upp[1])
        planetAtmo = convertFromHex(upp[2])
        planetHydro = convertFromHex(upp[3])
        planetGovt = convertFromHex(upp[5])
        modifier = 0
        # Modifiers for star port
        if starPortValue is "A":
            modifier += 6
        elif starPortValue is "B":
            modifier += 4
        elif starPortValue is "C":
            modifier += 2
        elif starPortValue is "X":
            modifier += -4
        else:
            pass

        # Modifiers for planetSize
        if planetSize > 3:
            pass
        elif planetSize <= 1:
            modifier += 2
        elif planetSize <= 3:
            modifier += 1

        # Modifiers for Atmo
        if planetAtmo > 3 and planetAtmo < 10:
            pass
        else:
            modifier += 1

        # Modifiers for Hydro
        if planetHydro < 9:
            pass
        elif planetHydro == 9:
            modifier += 1
        elif planetHydro > 9:
            modifier += 2

        # Modifiers for Population
        if planetPop > 5 and planetPop < 9:
            pass
        elif planetPop <= 5:
            modifier += 1
        elif planetPop == 9:
            modifier += 2
        elif planetPop > 9:
            modifier += 4

        # Modifiers for Government
        if planetGovt not in [0, 5, 13]:
            pass
        elif planetGovt is 0 or planetGovt is 5:
            modifier += 1
        elif planetGovt is 13:
            modifier += -2

        # Finally make tech roll
        result = rolld6() + modifier
        if result < 0:
            result = 0
        return result


def convertToHex(value):
    """
    value - int
    given a value convert to A-Z if greater
    than 10.
    """
    if value < 10:
        return str(value)
    else:
        newValue = value - 10
        return string.ascii_uppercase[newValue]


def convertFromHex(value):
    """
    Given a string with a hex value convert it to int
    """
    if value in string.ascii_uppercase:
        return 10 + string.ascii_uppercase.index(value)
    else:
        return int(value)


def generatePlanetUPP(starPortValue):
    """
    Generate a universal planetary profile.
    """
    planetSize = determinePlanetSize()
    planetAtmo = determineAtmo(planetSize)
    planetHydro = determineHydro(planetSize, planetAtmo)
    planetPop = determinePopulation()
    planetGovt = determineGovernment(planetPop)
    planetLaw = determineLawLevel(planetGovt, planetPop)
    upp = starPortValue + convertToHex(planetSize) + \
        convertToHex(planetAtmo) + convertToHex(planetHydro) + \
        convertToHex(planetPop) + convertToHex(planetGovt) + \
        convertToHex(planetLaw)
    return upp


def determineTradeClassifications(upp):
    """
    Determine trade classifications for the world
    based on the upp.
    Returns:
        Notes - str
        classifications - list
    """
    notes = ""
    classifications = []
    planetSize = convertFromHex(upp[1])
    planetPop = convertFromHex(upp[4])
    planetAtmo = convertFromHex(upp[2])
    planetHydro = convertFromHex(upp[3])
    if planetAtmo > 9 and planetHydro > 1:
        notes += "Fluid Oceans"
        classifications.append("Fl")
    elif planetHydro is 10:
        notes += "Water world; "
        classifications.append("Wa")
    if planetHydro is 0 and planetAtmo > 0:
        notes += "Desert world; "
        classifications.append("De")
    if planetAtmo is 0:
        notes += "Vacuum world; "
        classifications.append("Va")
    if planetSize is 0:
        notes += "Asteroid belt; "
        classifications.append("As")
    if planetAtmo in [0, 1] and planetHydro > 0:
        notes += "Ice capped world; "
        classifications.append("Ic")
    if (planetAtmo > 1 and planetAtmo < 6) \
       and planetHydro < 4:
        notes += "Poor world; "
        classifications.append("Po")
    if planetPop < 1:
        notes += "Abandoned/Deserted World; "
        classifications.append("Ba")
    else:
        # planetSize = convertFromHex(upp[1])
        planetGovt = convertFromHex(upp[5])
        if planetPop < 4:
            notes += "Low Population; "
            classifications.append("Lo")
        if planetPop > 8:
            notes += "High Population; "
            classifications.append("Hi")
        if (planetAtmo > 3 and planetAtmo < 10) \
           and (planetHydro > 3 and planetHydro < 9) \
           and (planetPop > 4 and planetPop < 8):
            notes += "Agricultural world; "
            classifications.append("Ag")
        if (planetAtmo < 4) and (planetHydro < 4) \
           and (planetPop > 5):
            notes += "Non-agricultural world; "
            classifications.append("Na")
        if (planetAtmo in [0, 1, 2, 4, 7, 9]) and \
           planetPop > 8:
            notes += "Industrial world; "
            classifications.append("In")
        if planetPop < 7:
            notes += "Non-industrial world; "
            classifications.append("Ni")
        if (planetGovt > 3 and planetGovt < 10) \
           and (planetAtmo in [6, 8]) \
           and (planetPop > 5 and planetPop < 8):
            notes += "Rich world; "
            classifications.append("Ri")
    return notes[:-1], classifications


"""
for num in range(0, 80):
    worldExist = determineWorldOccurence()
    if worldExist:
        starPort = determineStarPort()
        upp = generatePlanetUPP(starPort)
        # print(upp)
        techLevel = determineTechLevel(upp)
        navalBase = determineNavalBase(starPort)
        scoutBase = determineScoutBase(starPort)
        gasGiant = determineGasGiant()
        tradeNotes = determineTradeClassifications(upp)
        print("UPP: ", upp,
              " Tech Level: ", techLevel,
              " Naval Base: ", navalBase,
              " Scout Base: ", scoutBase,
              " Gas Giant: ", gasGiant,
              "\nNotes: ", tradeNotes)
    else:
        print("no world")
"""
