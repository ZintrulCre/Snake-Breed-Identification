import os
import sys
import time
import requests

if len(sys.argv) < 2 or len(sys.argv) > 2:
    print("Wrong parameters!")
    sys.exit()
start = time.time()
target = sys.argv[1]
i, j = 1000, 0
path = os.getcwd() + "/"
folder = path + target
if not os.path.exists(folder):
    os.mkdir(folder)
with open(path + target + ".txt") as txt:
    for url in txt:
        print("line " + str(j))
        j += 1
        try:
            response = requests.get(url)
        except requests.exceptions.ConnectionError:
            continue
        if response.status_code == 200:
            if not response.headers.get('content-length') or int(response.headers.get('content-length')) // 1000 < 20:
                continue
            with open(folder + '/' + str(i) + '.jpg', 'wb') as image:
                image.write(response.content)
            print("image " + str(i))
            i += 1
print("Download finished!")
end = time.time()
print("total time:", end - start)
