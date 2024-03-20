# unzip all zip files in directory

# Set the directory where your zip files are located
directory <- "~"

# List all files in the directory
files <- list.files(directory)

# Filter out only the zip files
zip_files <- files[grep("\\.zip$", files)]

# Unzip each zip file into a folder with the same name
for (zip_file in zip_files) {
  # Create a folder with the same name as the zip file (without the extension)
  folder_name <- sub("\\.zip$", "", zip_file)
  dir.create(file.path(directory, folder_name), showWarnings = FALSE)
  
  # Unzip the contents of the zip file into the created folder
  unzip(file.path(directory, zip_file), exdir = file.path(directory, folder_name))
  
  cat("Extracted", zip_file, "into", folder_name, "folder\n")
  # Delete the zip file after extraction
  file.remove(file.path(directory, zip_file))
  cat("Deleted", zip_file, "\n")
}
