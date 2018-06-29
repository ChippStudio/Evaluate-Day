from PIL import Image
import os

print('Start screenshot maker')

sizes = {'iPhone X': (1125, 2436),
        'iPhone 8': (750, 1334),
        'iPhone 8 Plus': (1242, 2208),
        'iPhone SE': (640, 1136),
        'iPad Pro (12.9-inch)': (2732, 2048),
        'iPad Pro (9.7-inch)': (2224, 1668)}

devSizes = {'iPhone X': (1045, 2090),
            'iPhone 8': (670, 1367),
            'iPhone 8 Plus': (1162, 2370),
            'iPhone SE': (560, 1175),
            'iPad Pro (12.9-inch)': (2652, 1914),
            'iPad Pro (9.7-inch)': (2144, 1515)}

devCoordinates = {'iPhone X': (40, 316),
                'iPhone 8': (40, 244),
                'iPhone 8 Plus': (40, 316),
                'iPhone SE': (40, 244),
                'iPad Pro (12.9-inch)': (40, 244),
                'iPad Pro (9.7-inch)': (40, 244)}

devMultiple = {'iPhone X': '@3x',
                'iPhone 8': '@2x',
                'iPhone 8 Plus': '@3x',
                'iPhone SE': '@2x',
                'iPad Pro (12.9-inch)': '@3x',
                'iPad Pro (9.7-inch)': '@3x'}

descriptionCoordinates = {'iPhone X': (80, 40),
                            'iPhone 8': (80, 40),
                            'iPhone 8 Plus': (80, 40),
                            'iPhone SE': (20, 40),
                            'iPad Pro (12.9-inch)': (80, 40),
                            'iPad Pro (9.7-inch)': (80, 40)}

langs = []
# root, dirs, files
for data in os.walk("screenshots"):
    for lang in data[1]:
        langs.append(lang)

print(langs)

for lang in langs:
    devices = []
    for data in os.walk('screenshots/' + lang):
        for d in data[2]:
            devices.append(d)

    for d in devices:
        #Вся магия тут
        if d[-10:-4] != 'framed':
            continue
        mPos = 0
        for i, c in enumerate(d):
            if c == '-':
                mPos = i
        nPos = d.find('_')

        devName = d[:mPos]
        screenName = d[mPos+1:nPos]
        devFamily = d[:d.find(' ')]
        screenNumber = screenName[:2]

        print('screenshots/'+ lang + '/' + devFamily + '-' + screenName + '.png')

        # Start make screenshot
        #Open all
        # newScreenshot = Image.new('RGB', sizes[devName], (255, 255, 255))
        # print('data/backgrounds/' + screenName + '-' +  +'.png')
        # print(screenNumber)
        newScreenshot = Image.open('data/backgrounds/' + screenNumber + '-' + devName +'.png' )
        description = Image.open('data/' + lang + '/' + devFamily + '/' + screenName + devMultiple[devName] + '.png')
        image = Image.open('screenshots/'+ lang + '/' + d)
        # resize
        image = image.resize(devSizes[devName], Image.ANTIALIAS)

        #combine
        newScreenshot.paste(description, descriptionCoordinates[devName], description)
        newScreenshot.paste(image, devCoordinates[devName], image)

        newScreenshot.save('store_screenshots/' + lang + '/' + d)
    #device.save('screenshots/' + lang + '/huuuu.png')
