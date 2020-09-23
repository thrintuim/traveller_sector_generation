import collections

sector_data = collections.namedtuple(
    "sector_data",
    "A B C D E F G H I J K L M N O P",
    defaults=[False for num in range(0, 16)]
)
