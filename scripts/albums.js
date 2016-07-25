// Author: M. Freddie Dias <mfdias@ri.cmu.edu>
// Date: Aug 1, 2011

// Simple function to pad zeros in front of a number
// NOTE: Only works up to a width of 10
function pad_zeros(num, width) {
    zeros = "0000000000";
    return (zeros + num).slice(-width);
}


// This is a very simple function that will create a lightbox photo album and insert it into the "photos" div of the document
// It is assumed that the photos are organized in the following way on the server:
//  - All photos are of type jpeg and have the ".jpg" extension
//  - All pictures are inside a single folder defined by the "root_folder" variable (see first line of function below)
//  - For each album, there should be a folder called "name"(param) which has two subfolders, "thumbs" and "photos"
//  - In each subfolder (thumbs and photos), there are expected to be "num_photos"(param) and each file will be named 
//    "image_i.jpg" where i is a number between 1 and num_photos
//    NOTE: the numbers in the filenames should be padded with zeros to ensure that each number i has "num_width"(param) digits
//    NOTE2: There is a bash script inside the albums folder called "create_album.sh" that can take a folder of images
//           and automatically resize/rename all of them as necessary to create the correct structure for this script
// 
// PARAMETERS:
//    - name:           name of album (see comments above)
//    - title:          title to display above the album
//    - num_photos:     the number of photos in the album (see comments above)
//    - num_width:      the width of the numbering (eg: num_width = 4 would mean the filenames would look like "image_0001.jpg" etc)
//    - captions_array: array with captions for each image (ignored if length of array is not equal to num_photos)
//
function create_album(name, title, num_photos, num_width, captions_array) {


    var root_folder = "albums";
    var photoDiv = document.getElementById('photos');

    // Check if the captions array is the correct size
    var use_captions = false;
    if (captions_array) { // Check if the array exists
        if (captions_array.length == num_photos) {
            use_captions = true;
        }
    }

    // add space on top
    var br_top = document.createElement("br");
    photoDiv.appendChild(br_top);

    // create anchor (use same name as folder) to allow linking to this album
    var anchor = document.createElement("a");
    anchor.name = name;
    anchor.id = name;
    photoDiv.appendChild(anchor);

    // create and add album title
    var h3 = document.createElement("h3");
    var h3_text = document.createTextNode(title);
    h3.appendChild(h3_text);
    photoDiv.appendChild(h3);

    for (var i=1; i<=num_photos; i++) {
        var span = document.createElement("span");
        var link = document.createElement("a");
        link.href = root_folder + "/" + name + "/photos/image_" + pad_zeros(i, num_width) + ".jpg";
        link.rel = "lightbox[" + name + "]"; // this creates a lightbox album called "name"
        if (use_captions) {
            if (captions_array[i-1] == "") {
                link.title = " ";
            } else {
                link.title = captions_array[i-1];
            }
        } else {
            link.title = " "; // required to clear any previously cached captions!
        }
        var img = document.createElement("img");
        img.src = root_folder + "/" + name + "/thumbs/image_" + pad_zeros(i, num_width) + ".jpg";
        link.appendChild(img);
        span.appendChild(link);
        photoDiv.appendChild(span);
    }
    
    // add space
    var br_bot1 = document.createElement("br");
    photoDiv.appendChild(br_bot1);
    
    // create link back to photo galleries section top
    //var para = document.createElement("p");
    var backlink = document.createElement("a");
    backlink.href = "#Photos";
    var backtext = document.createTextNode("Back to Photo Galleries");
    backlink.appendChild(backtext);
    //para.appendChild(backlink);
    //photoDiv.appendChild(para);
    photoDiv.appendChild(backlink);
    
    // add space
    var br_bot2 = document.createElement("br");
    photoDiv.appendChild(br_bot2);
}