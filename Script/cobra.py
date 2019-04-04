import os
import requests

folder = 'cobra'
i = 0
if not os.path.exists(folder):
    os.mkdir(folder)
with open(folder + ".txt") as txt:
    for url in txt:
        print(url)
        try:
            response = requests.get(url)
        except requests.exceptions.ConnectionError:
            continue
        if response.status_code == 200:
            with open(folder + '/' + str(i) + '.jpg', 'wb') as image:
                image.write(response.content)
            print(i)
            i += 1
