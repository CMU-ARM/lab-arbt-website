#!/bin/bash

# Author: M. Freddie Dias <mfdias@ri.cmu.edu>
# Date: Aug 1, 2011

# This script will create an album by taking all the jpg files in the specified folder (src)
# and creating a new folder inside the current directory (album_name) and create two subfolders
# inside it ("photos" and "thumbs"). The script will then copy the original jpegs to the "photos"
# folder (while renaming them as image_XXX.jpg) and create matching thumbnails in the "thumbs"
# subfolder (thumbs will be approximately 120 pixels in the largest dimension)

# Input parameters:
#   1: src: source folder to pull photos from
#   2: album_name: the name to use when creating the new album

print_help() {
  echo ""
  echo "Usage : $0 src_folder album_name"
  echo ""
  echo "  There are two input parameters to this script:"
  echo "    \"src_folder\"   Folder with original jpeg images"
  echo ""
  echo "    \"album_name\"   Name of new album to be created"
  echo ""
}

########### Internal variables ###############

# max dimension of thumbnail (if landscape, width = thumb_size, else, height = thumb_size)
thumb_size=120;

# max dimension of full size photo
max_photo_size=600;

# file count width (determines number of zeros to pad to each filenumber)
count_width=3;

# conversion quality (value passed as "-quality" param to convert)
quality=85;

# supported image file types (separate with "\|")
file_types="jpg\|JPG\|png";

######### You should not need to make changes below this line #############

# Make sure src_folder parameter is specified
if [ -z "$1" ]; then
    echo ""
    echo "ERROR! No src_folder specified!"
    print_help
    echo "Exiting..."
    echo ""
    exit 0
fi

# Check that the directory exists (symlinks are ok)
if [ ! -d "$1" ]; then
    echo ""
    echo "ERROR! Folder not found: \"$1\""
    echo "Aborting..."
    echo ""
    exit 0
fi

# Make sure album name parameter is specified
if [ -z "$2" ]; then
  echo ""
  echo "ERROR! album_name not specified!"
  print_help
  echo "Exiting..."
  echo ""
  exit 0
fi

# Make sure album name is not already in use
if [ -d "$2" ]; then
    echo ""
    echo "ERROR! An album by the name \"$2\" already exists! Please choose another name."
    echo "Aborting..."
    echo ""
    exit 0
fi

# First create the directory structure needed
#echo "mkdir \"$2\"";
#mkdir "$2";
#echo "mkdir \"$2/photos\"";
#mkdir "$2/photos";
#echo "mkdir \"$2/thumbs\"";
#mkdir "$2/thumbs";

# Next we loop through all the files and for each file we copy/rename the original
# into the "photos" folder and resize/rename a thumbnail to match in the "thumbs" folder
count=1;
#echo "Copying original files to \"photos\" folder..."
#for i in `ls "$1" | grep -i ".jpg"` ; do
#shopt -s nullglob
#echo "starting test for loop:"
#echo "  for j in \"$1\"/*.{$file_types} ; do echo \"$j\"; done";
#for j in "$1"/*.{$file_types} ; do echo "$j"; done

#echo "for i in \`find \"$1\" -iname *.{\"$file_types\"}\` ; do";
#shopt -s nullglob
#echo "for i in $1/*.{$file_types} ; do echo \$i; done";
#echo "for i in $1/*.{$file_types} ; do echo \$i; done"
#for i in $1/*.{$file_types} ; do echo $i; done

echo "for i in \`find $1 -type f -regex \".*\\.\\($file_types\\)\"\` ; do echo \$i; done";
for i in `find $1 -type f -regex ".*\.\($file_types\)"` ; do echo $i; done