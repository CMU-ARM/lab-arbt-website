#!/bin/bash

# Author: M. Freddie Dias <mfdias@ri.cmu.edu>
# Date: Aug 1, 2011
# Last Modified: Feb 20, 2012

# This script will create an album by taking all the image files in the specified folder (src)
# and creating a new folder inside the current directory (album_name) and create two subfolders
# inside it ("photos" and "thumbs"). The script will then copy the original jpegs to the "photos"
# folder (while renaming them as image_XXX.jpg) and create matching thumbnails in the "thumbs"
# subfolder (thumbs will be approximately 120 pixels in the largest dimension)
# NOTE: "image files" are defined as any file with an extension included in the "file_types" variable

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
mkdir "$2";
#echo "mkdir \"$2/photos\"";
mkdir "$2/photos";
#echo "mkdir \"$2/thumbs\"";
mkdir "$2/thumbs";

# Next we loop through all the files and for each file we copy/resize the original
# into the "photos" folder and resize/rename a thumbnail to match in the "thumbs" folder
count=1;
#echo "Copying original files to \"photos\" folder..."

#echo "starting for loop:";
#for i in `ls "$1" | grep -i ".jpg"` ; do
#for i in "$1"/*.{$file_types} ; do

# First set the $IFS to make sure we don't break on spaces in file/folder names
OLDIFS=$IFS
IFS=$(echo -en "\n\b")
for i in `find "$1" -type f -regex ".*\.\($file_types\)"` ; do 
    # echo file name
    #echo "";
    #echo "Considering \"$i\" ...";

    padded_i=$(printf %0"$count_width"d $count); # pad zeros to i to make filenames same length

    # create the two new filenames (one for the original and one for the thumbnail)
    new_orig="$2/photos/image_$padded_i.jpg";
    new_thumb="$2/thumbs/image_$padded_i.jpg";

    # Identify if the orientation of the image and resize thumbnail accordingly
    w=$(identify -format "%w" "$i"); # Get image width (in pixels)
    #echo "  width=$w";
    h=$(identify -format "%h" "$i"); # Get image height (in pixels)
    #echo "  height=$h";

    if [ $w -gt $h ]; then # width > height, i.e. image orientation is landscape

        # first check if width of image is too large
        if [ $w -gt $max_photo_size ]; then
            # image is too large, need to resize
            echo "Resizing... $i ==> $new_orig";
            #echo "convert -resize $max_photo_size -quality $quality \"$i\" $new_orig";
            convert -resize $max_photo_size -quality $quality "$i" $new_orig;
        else
            # image is not larger than max_photo_size so we just copy the original
            echo "Copying... $i ==> $new_orig";
            #echo "cp \"$i\" $new_orig";
            cp "$i" $new_orig;
        fi

        # Now we create the thumbnail
        echo "creating thumbnail \"$new_thumb\"";
        #echo "convert -resize $thumb_size -quality $quality \"$i\" $new_thumb";
        convert -resize $thumb_size -quality $quality "$i" $new_thumb;

    else # height > width, i.e. image orientation is portrait

        # first check if height of image is too large
        if [ $h -gt $max_photo_size ]; then
            # image is too large, need to resize
            echo "Resizing... $i ==> $new_orig";
            #echo "convert -resize x$max_photo_size -quality $quality \"$i\" $new_orig";
            convert -resize x$max_photo_size -quality $quality "$i" $new_orig;
        else
            # image is not larger than max_photo_size so we just copy the original
            echo "Copying... $i ==> $new_orig";
            #echo "cp \"$i\" $new_orig";
            cp "$i" $new_orig;
        fi

        # Now we create the thumbnail
        echo "creating thumbnail \"$new_thumb\"";
        #echo "convert -resize x$thumb_size -quality $quality \"$i\" $new_thumb";
        convert -resize x$thumb_size -quality $quality "$i" $new_thumb;
    fi
    
    ((count++)); # increment file count
done
# restore $IFS
IFS=$OLDIFS

