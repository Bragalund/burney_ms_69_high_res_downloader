# burney_ms_69_high_res_downloader
This is a powershell script for downloading the book "burney_ms_69" from british library.   
A friend of mine wanted it really high-resolution version of this book for his master thesis in architecture,   
so i created this script. 

The way this script works is by manipulating the URL for all of the smallest picture of all the pages of the book.
It puts all the small images into one page at a time and creates images of each page.
At the end all of the pages of the book is downloaded and named after the page it is in the book.

The book can be viewed here: http://www.bl.uk/manuscripts/Viewer.aspx?ref=burney_ms_69_f001r

### To get this to work...
You need imagemagick.  
It can be downloaded from <https://www.imagemagick.org/download/binaries/ImageMagick-7.0.7-23-Q16-x64-dll.exe>   
The Imagemagick exe has to be set to PATH.

### To run
Just run the script from commandline like any other script in a folder.  
For example:
<code>$ .\downloadImages.ps1 </code>
