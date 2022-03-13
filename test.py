import os

BASE_PATH = os.getcwd()

unwanted = []

def getUnwantedFiles(base_path,unwanted):

    for i in os.listdir(base_path):
        if os.path.isdir(f"{base_path}/{i}"):
            # is directory
            unwanted = getUnwantedFiles(f"{base_path}/{i}",unwanted)
        else:
            # is file
            if i.startswith("._"):
                unwanted.append(f"{base_path}/{i}")

    return unwanted

bad_files = getUnwantedFiles(BASE_PATH,unwanted)

for i in bad_files:
    os.remove(i)