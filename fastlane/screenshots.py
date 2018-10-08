from PIL import Image
import math
import os

devices = ["iPhone X", "iPhone XS Max", "iPhone 8", "iPhone 8 Plus", "iPhone SE", "iPad Pro (9.7-inch)", "iPad Pro (12.9-inch)"]
deviceData = {'iPhone X': {
            'device': 'iPhone X',
            'multiple': 3,
            'storeSize': (1125, 2436),
            'screenshots':
                {'01':
                    {'origin': {'en-US': (-38, 48),
                                'ru': (-38, 48),
                                'de-DE': (-38, 48)},
                    'size': (390, 780),
                    'angel': -33},
                '02':
                    {'origin': {'en-US': (725, 197),
                                'ru': (725, 197),
                                'de-DE': (725, 197)},
                    'size': (390, 780),
                    'angel': 0},
                '03':
                    {'origin': {'en-US': (1148, 195),
                                'ru': (1148, 220),
                                'de-DE': (1148, 226)},
                    'size': (335, 670),
                    'angel': 0},
                '04':
                    {'origin': {'en-US': (1524, 226),
                                'ru': (1524, 226),
                                'de-DE': (1524, 219)},
                    'size': (335, 670),
                    'angel': 0},
                '05':
                    {'origin': {'en-US': (1900, 226),
                                'ru': (1900, 226),
                                'de-DE': (1900, 226)},
                    'size': (335, 670),
                    'angel': 0},
                '06':
                    {'origin': {'en-US': (2276, 236),
                                'ru': (2276, 236),
                                'de-DE': (2276, 210)},
                    'size': (335, 670),
                    'angel': 0},
                '07':
                    {'origin': {'en-US': (2652, -150),
                                'ru': (2652, -48),
                                'de-DE': (2652, -38)},
                    'size': (335, 670),
                    'angel': 0},
                '08':
                    {'origin': {'en-US': (3028, -119),
                                'ru': (3028, -119),
                                'de-DE': (3028, -73)},
                    'size': (335, 670),
                    'angel': 0},
                '09':
                    {'origin': {'en-US': (3404, 226),
                                'ru': (3404, 226),
                                'de-DE': (3404, 226)},
                    'size': (335, 670),
                    'angel': 0},
                }
            },
        'iPhone XS Max': {
            'device': 'iPhone X',
            'multiple': 3,
            'storeSize': (1242, 2688),
            'screenshots':
                {'01':
                    {'origin': {'en-US': (-22, 33),
                                'ru': (-22, 33),
                                'de-DE': (-22, 33)},
                    'size': (410, 820),
                    'angel': -33},
                '02':
                    {'origin': {'en-US': (800, 155),
                                'ru': (800, 155),
                                'de-DE': (800, 155)},
                    'size': (430, 860),
                    'angel': 0},
                '03':
                    {'origin': {'en-US': (1265, 185),
                                'ru': (1265, 221),
                                'de-DE': (1265, 221)},
                    'size': (347, 748),
                    'angel': 0},
                '04':
                    {'origin': {'en-US': (1680, 226),
                                'ru': (1680, 226),
                                'de-DE': (1680, 226)},
                    'size': (347, 748),
                    'angel': 0},
                '05':
                    {'origin': {'en-US': (2095, 226),
                                'ru': (2095, 226),
                                'de-DE': (2095, 226)},
                    'size': (347, 748),
                    'angel': 0},
                '06':
                    {'origin': {'en-US': (2510, 226),
                                'ru': (2510, 226),
                                'de-DE': (2510, 226)},
                    'size': (347, 748),
                    'angel': 0},
                '07':
                    {'origin': {'en-US': (2925, -258),
                                'ru': (2925, -42),
                                'de-DE': (2925, -42)},
                    'size': (347, 748),
                    'angel': 0},
                '08':
                    {'origin': {'en-US': (3340, -258),
                                'ru': (3340, -83),
                                'de-DE': (3340, -83)},
                    'size': (347, 748),
                    'angel': 0},
                '09':
                    {'origin': {'en-US': (3755, 226),
                                'ru': (3755, 226),
                                'de-DE': (3755, 226)},
                    'size': (347, 748),
                    'angel': 0},
                }
            },
        'iPhone 8': {
            'device': 'iPhone 8',
            'multiple': 2,
            'storeSize': (750, 1334),
            'screenshots':
                {'01':
                    {'origin': {'en-US': (12, 29),
                                'ru': (12, 29),
                                'de-DE': (12, 29)},
                    'size': (360, 735),
                    'angel': -33},
                '02':
                    {'origin': {'en-US': (723, 125),
                                'ru': (723, 125),
                                'de-DE': (723, 125)},
                    'size': (390, 795),
                    'angel': 0},
                '03':
                    {'origin': {'en-US': (1148, 171),
                                'ru': (1148, 207),
                                'de-DE': (1148, 177)},
                    'size': (335, 683),
                    'angel': 0},
                '04':
                    {'origin': {'en-US': (1524, 171),
                                'ru': (1524, 171),
                                'de-DE': (1524, 212)},
                    'size': (335, 683),
                    'angel': 0},
                '05':
                    {'origin': {'en-US': (1900, 170),
                                'ru': (1900, 170),
                                'de-DE': (1900, 202)},
                    'size': (335, 683),
                    'angel': 0},
                '06':
                    {'origin': {'en-US': (2276, 205),
                                'ru': (2276, 205),
                                'de-DE': (2276, 205)},
                    'size': (335, 683),
                    'angel': 0},
                '07':
                    {'origin': {'en-US': (2652, -232),
                                'ru': (2652, -193),
                                'de-DE': (2652, -193)},
                    'size': (335, 683),
                    'angel': 0},
                '08':
                    {'origin': {'en-US': (3028, -227),
                                'ru': (3028, -227),
                                'de-DE': (3028, -227)},
                    'size': (335, 683),
                    'angel': 0},
                '09':
                    {'origin': {'en-US': (3399, 205),
                                'ru': (3399, 171),
                                'de-DE': (3399, 171)},
                    'size': (335, 683),
                    'angel': 0},
                }
            },
        'iPhone 8 Plus': {
            'device': 'iPhone 8 Plus',
            'multiple': 3,
            'storeSize': (1242, 2208),
            'screenshots':
                {'01':
                    {'origin': {'en-US': (11, 0),
                                'ru': (11, 0),
                                'de-DE': (11, 0)},
                    'size': (400, 816),
                    'angel': -33},
                '02':
                    {'origin': {'en-US': (800, 144),
                                'ru': (800, 144),
                                'de-DE': (800, 144)},
                    'size': (425, 867),
                    'angel': 0},
                '03':
                    {'origin': {'en-US': (1265, 185),
                                'ru': (1265, 221),
                                'de-DE': (1265, 185)},
                    'size': (374, 763),
                    'angel': 0},
                '04':
                    {'origin': {'en-US': (1680, 226),
                                'ru': (1680, 226),
                                'de-DE': (1680, 226)},
                    'size': (374, 763),
                    'angel': 0},
                '05':
                    {'origin': {'en-US': (2095, 226),
                                'ru': (2095, 226),
                                'de-DE': (2095, 226)},
                    'size': (374, 763),
                    'angel': 0},
                '06':
                    {'origin': {'en-US': (2510, 226),
                                'ru': (2510, 226),
                                'de-DE': (2510, 226)},
                    'size': (374, 763),
                    'angel': 0},
                '07':
                    {'origin': {'en-US': (2925, -258),
                                'ru': (2925, -217),
                                'de-DE': (2925, -217)},
                    'size': (374, 763),
                    'angel': 0},
                '08':
                    {'origin': {'en-US': (3340, -258),
                                'ru': (3340, -258),
                                'de-DE': (3340, -258)},
                    'size': (374, 763),
                    'angel': 0},
                '09':
                    {'origin': {'en-US': (3755, 226),
                                'ru': (3755, 226),
                                'de-DE': (3755, 226)},
                    'size': (374, 763),
                    'angel': 0},
                }
            },
        'iPhone SE': {
            'device': 'iPhone SE',
            'multiple': 2,
            'storeSize': (640, 1136),
            'screenshots':
                {'01':
                    {'origin': {'en-US': (15, 0),
                                'ru': (15, 0),
                                'de-DE': (15, 0)},
                    'size': (300, 630),
                    'angel': -33},
                '02':
                    {'origin': {'en-US': (615, 121),
                                'ru': (615, 121),
                                'de-DE': (615, 121)},
                    'size': (310, 650),
                    'angel': 0},
                '03':
                    {'origin': {'en-US': (983, 144),
                                'ru': (983, 180),
                                'de-DE': (983, 144)},
                    'size': (280, 587),
                    'angel': 0},
                '04':
                    {'origin': {'en-US': (1304, 144),
                                'ru': (1304, 144),
                                'de-DE': (1304, 171)},
                    'size': (280, 587),
                    'angel': 0},
                '05':
                    {'origin': {'en-US': (1625, 144),
                                'ru': (1625, 144),
                                'de-DE': (1625, 171)},
                    'size': (280, 587),
                    'angel': 0},
                '06':
                    {'origin': {'en-US': (1946, 144),
                                'ru': (1946, 144),
                                'de-DE': (1946, 171)},
                    'size': (280, 587),
                    'angel': 0},
                '07':
                    {'origin': {'en-US': (2267, -196),
                                'ru': (2267, -196),
                                'de-DE': (2267, -169)},
                    'size': (280, 587),
                    'angel': 0},
                '08':
                    {'origin': {'en-US': (2588, -196),
                                'ru': (2588, -196),
                                'de-DE': (2588, -196)},
                    'size': (280, 587),
                    'angel': 0},
                '09':
                    {'origin': {'en-US': (2905, 171),
                                'ru': (2905, 144),
                                'de-DE': (2905, 171)},
                    'size': (280, 587),
                    'angel': 0},
                }
            },
        'iPad Pro (9.7-inch)': {
            'device': 'iPad Pro (9.7-inch)',
            'multiple': 2,
            'storeSize': (2224, 1668),
            'screenshots':
                {'01':
                    {'origin': {'en-US': (256, -477),
                                'ru': (256, -477),
                                'de-DE': (256, -477)},
                    'size': (1360, 960),
                    'angel': 33},
                '02':
                    {'origin': {'en-US': (2120, 199),
                                'ru': (2120, 199),
                                'de-DE': (2120, 199)},
                    'size': (1165, 823),
                    'angel': 0},
                '03':
                    {'origin': {'en-US': (3379, 217),
                                'ru': (3379, 217),
                                'de-DE': (3379, 217)},
                    'size': (1035, 729),
                    'angel': 0},
                '04':
                    {'origin': {'en-US': (4492, 272),
                                'ru': (4492, 272),
                                'de-DE': (4492, 272)},
                    'size': (1035, 729),
                    'angel': 0},
                '05':
                    {'origin': {'en-US': (5605, 217),
                                'ru': (5605, 217),
                                'de-DE': (5605, 272)},
                    'size': (1035, 729),
                    'angel': 0},
                '06':
                    {'origin': {'en-US': (6718, 271),
                                'ru': (6718, 271),
                                'de-DE': (6718, 271)},
                    'size': (1035, 729),
                    'angel': 0},
                '07':
                    {'origin': {'en-US': (7831, -167),
                                'ru': (7831, -167),
                                'de-DE': (7831, -167)},
                    'size': (1035, 729),
                    'angel': 0},
                '08':
                    {'origin': {'en-US': (8944, -167),
                                'ru': (8944, -167),
                                'de-DE': (8944, -167)},
                    'size': (1035, 729),
                    'angel': 0},
                '09':
                    {'origin': {'en-US': (10057, 210),
                                'ru': (10057, 210),
                                'de-DE': (10057, 210)},
                    'size': (1035, 729),
                    'angel': 0},
                }
            },
        'iPad Pro (12.9-inch)': {
            'device': 'iPad Pro (12.9-inch)',
            'multiple': 2,
            'storeSize': (2732, 2048),
            'screenshots':
                {'01':
                    {'origin': {'en-US': (312, -395),
                                'ru': (312, -395),
                                'de-DE': (312, -395)},
                    'size': (1460, 1054),
                    'angel': 33},
                '02':
                    {'origin': {'en-US': (2634, 189),
                                'ru': (2634, 189),
                                'de-DE': (2634, 189)},
                    'size': (1420, 1024),
                    'angel': 0},
                '03':
                    {'origin': {'en-US': (4141, 217),
                                'ru': (4141, 217),
                                'de-DE': (4141, 217)},
                    'size': (1286, 928),
                    'angel': 0},
                '04':
                    {'origin': {'en-US': (5508, 217),
                                'ru': (5508, 217),
                                'de-DE': (5508, 272)},
                    'size': (1286, 928),
                    'angel': 0},
                '05':
                    {'origin': {'en-US': (6875, 217),
                                'ru': (6875, 217),
                                'de-DE': (6875, 217)},
                    'size': (1286, 928),
                    'angel': 0},
                '06':
                    {'origin': {'en-US': (8242, 217),
                                'ru': (8242, 217),
                                'de-DE': (8242, 272)},
                    'size': (1286, 928),
                    'angel': 0},
                '07':
                    {'origin': {'en-US': (9609, -175),
                                'ru': (9609, -120),
                                'de-DE': (9609, -120)},
                    'size': (1286, 928),
                    'angel': 0},
                '08':
                    {'origin': {'en-US': (10976, -175),
                                'ru': (10976, -175),
                                'de-DE': (10976, -175)},
                    'size': (1286, 928),
                    'angel': 0},
                '09':
                    {'origin': {'en-US': (12343, 230),
                                'ru': (12343, 230),
                                'de-DE': (12343, 230)},
                    'size': (1286, 928),
                    'angel': 0},
                }
            },
        }

langs = []
# root, dirs, files
for data in os.walk("screenshots"):
    for lang in data[1]:
        langs.append(lang)

for lang in langs:
    for device in devices:
        background = Image.open('data/' + device + '_' + lang + '.png')
        dev = deviceData[device]['device']
        for i in range(1, 10):
            # Open screenshot
            screenshot = Image.open('screenshots/'+ lang + '/' + dev + '-0' + str(i) + '_framed.png')

            multiple = deviceData[device]['multiple']
            size = (deviceData[device]['screenshots']['0'+str(i)]['size'][0] * multiple, deviceData[device]['screenshots']['0'+str(i)]['size'][1] * multiple)
            angle = deviceData[device]['screenshots']['0'+str(i)]['angel']

            resizedImage = screenshot.resize(size, Image.ANTIALIAS)
            newImage = resizedImage.rotate(angle, Image.BICUBIC, expand=1)

            # combane
            deviceOffset = (deviceData[device]['screenshots']['0'+str(i)]['origin'][lang][0] * multiple, deviceData[device]['screenshots']['0'+str(i)]['origin'][lang][1] * multiple)
            background.paste(newImage, deviceOffset, newImage)

            if i == 9:
                background.save('full_screenshots/' + lang + '/' + device + '.png')
                print('New full image saved - ' + device)

                # Slice screenshots
                width, height = background.size
                upper = 0
                left = 0
                sliceSize = deviceData[device]['storeSize'][0]
                slices = int(math.ceil(width/sliceSize))

                count = 1
                for slice in range(slices):
                    if count == slices:
                        lower = width
                    else:
                        lower = int(count * sliceSize)

                    bbox = (left, upper, lower, height)
                    workingSlice = background.crop(bbox)
                    left += sliceSize
                    workingSlice.save('store_screenshots/' + lang + '/' + device + '-0' + str(count) + '.png')
                    print("slice - ")
                    count += 1
