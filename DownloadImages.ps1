$path = (Get-Item -Path ".\" -Verbose).FullName
$downloadFolder = $MyInvocation.Path+"Library_Images"


# Figure out if the folder we will use to store the downloaded images already exists
if((Test-Path $downloadFolder) -eq $false) 
{
  Write-Output "Creating '$downloadFolder'..."

  New-Item -ItemType Directory -Path $downloadFolder | Out-Null
}

# create a WebClient instance that will handle Network communications 
$webClient = New-Object System.Net.WebClient

# original book: http://www.bl.uk/manuscripts/Viewer.aspx?ref=burney_ms_69_f001r

$baseUrl="http://www.bl.uk/manuscripts/Proxy.ashx?view="
$nameOfBook="burney_ms_69"

# install imagemagick for windows
# https://www.imagemagick.org/download/binaries/ImageMagick-7.0.7-23-Q16-x64-dll.exe

# pagenumbers go from f.1r, f.1v, f.2r, f.2v, ..... f.367r, f.367v

$pageIndeks=33

For($k=65; $k -le 734; $k++){

$pageNumber=""
$pageCharacter=""
$partall=
if($k % 2 -eq 0){ # if second-page/partall
$pageCharacter="v"
}else{ # oddetall
$pageCharacter="r"
}

if($pageIndeks -le 9){
$pageNumber="f00"+$pageIndeks
}elseif($pageIndeks -le 99){
$pageNumber="f0"+$pageIndeks
}elseif($pageIndeks -le 999){
$pageNumber="f"+$pageIndeks
}else{
$pageNumber="f"+$pageIndeks
}



$pageName=$pageNumber+$pageCharacter

Write-Output "Pagename is: "+$pageName



# iterate 21 times, but should really get this number from height of image from webpage
For ($i=0; $i -le 21; $i++){

$yAxisInfoText="Downloading small images for y-axis "+$i+" of page..."
Write-Output $yAxisInfoText

# iterate 26 times, but should get this number from width of image from webpage
For($j=0; $j -le 26; $j++){

# example of url:   http://www.bl.uk/manuscripts/Proxy.ashx?view=burney_ms_69_f001r_files/12/3_5.jpg
$url = $baseUrl+$nameOfBook+"_"+$pageName+"_files/13/"+$i+"_"+$j+".jpg"
      

# create name of small image
 if($i -gt 9 -and $j -gt 9){
 $imgFile = "I_"+$i+"_"+$j+"_image_temp.jpg"
 }elseif($i -gt 9 -and $j -le 9){
 $imgFile = "I_"+$i+"_0"+$j+"_image_temp.jpg"
 }elseif($i -le 9 -and $j -gt 9){
 $imgFile = "I_0"+$i+"_"+$j+"_image_temp.jpg"
 }else{
$imgFile = "I_0"+$i+"_0"+$j+"_image_temp.jpg"
}

# Write-Output "Downloading image from url: "+$url+" to image: "+$imgFile

# download small image
$imgSaveDestination = Join-Path $downloadFolder $imgFile
Write-Output "Downloading '$url' to '$imgSaveDestination'..."
$webClient.DownloadFile($url, $imgSaveDestination)
}

# Get y-axis pictures to append. They all have to have the same y-axis
 if($i -gt 9){
 $verticalImagesName="I_"+$i+"_`*_image_temp.jpg"    
}else{
$verticalImagesName="I_0"+$i+"_`*_image_temp.jpg"
}                                                
                                                

$verticalImagesPathAndName=Join-Path $downloadFolder $verticalImagesName






 if($i -gt 9){
$verticalAppendedImageName="out_"+$i+"_temp.jpg"
 }else{
 $verticalAppendedImageName="out_0"+$i+"_temp.jpg"
 }

$verticalAppendedImagesPath=Join-Path $downloadFolder $verticalAppendedImageName

Write-Output "Appending all vertical images to eachother..."

# imagemagick.exe command, Only works if imagemagick is in PATH
# Appends all images with same y-axis values togheter vertical
magick convert -append $verticalImagesPathAndName $verticalAppendedImagesPath

}



$horizontalImage="Page_"+$k+"_"+$pageName+".jpg"
if($k %2 -eq 0){
$pageIndeks++
}


$finalImagePath=Join-Path $downloadFolder $horizontalImage

$allVerticalImagesName="out_`*_temp.jpg"  

$allVerticalImagesNamePath=Join-Path $downloadFolder $allVerticalImagesName

Write-Output "Appending all horizontal images to eachother..."

magick convert +append $allVerticalImagesNamePath $finalImagePath

$allFilesInDownloadFolder=$downloadFolder+"\*"

Write-Output "Removing all temporary pictures..."

Remove-Item -Path $allFilesInDownloadFolder -include *temp.jpg
} # page-loop ends
