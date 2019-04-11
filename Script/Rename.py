import os

directory = os.path.abspath(os.path.dirname(os.getcwd() + "/../Data/"))
print(directory)
if directory:
    folders = os.listdir(directory)
    print(folders)
    i = 0
    for folder in folders:
        folder_directory = directory + '/' + folder
        print(folder_directory)
        if os.path.isdir(folder_directory):
            files = os.listdir(directory + '/' + folder)
            for file in files:
                os.rename(folder_directory + '/' + file,
                          folder_directory + '/' + str(i) + ".jpg")
                i += 1
