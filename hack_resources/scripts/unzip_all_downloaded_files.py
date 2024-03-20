import os
import zipfile

# Set the directory to the current working directory
directory = os.getcwd()

# List all files in the directory
files = os.listdir(directory)

# Filter out only the zip files
zip_files = [file for file in files if file.endswith('.zip')]

# Unzip each zip file into a folder with the same name
for zip_file in zip_files:
    # Create a folder with the same name as the zip file (without the extension)
    folder_name = os.path.splitext(zip_file)[0]
    os.makedirs(os.path.join(directory, folder_name), exist_ok=True)

    # Unzip the contents of the zip file into the created folder
    with zipfile.ZipFile(os.path.join(directory, zip_file), 'r') as zip_ref:
        zip_ref.extractall(os.path.join(directory, folder_name))
    
    print("Extracted", zip_file, "into", folder_name, "folder")

    # Delete the zip file after extraction
    os.remove(os.path.join(directory, zip_file))
    print("Deleted", zip_file)
