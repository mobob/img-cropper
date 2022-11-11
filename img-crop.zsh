#/bin/zsh

# little utility that crops and resizes files subdirectories, uses imagemagick

for FILE in */*.jpg; do

#magick identify "$FILE"
width=`magick identify -format "%[fx:w]" "$FILE"`
height=`magick identify -format "%[fx:h]" "$FILE"`
mindimension=$(($width > $height ? $height : $width ))
maxdimension=$(($width > $height ? $width : $height ))
if [ $mindimension -eq $maxdimension ]; then 
  square=1
else 
  square=0
fi
echo $FILE - Dimensions = $width,$height - min = $mindimension, max = $maxdimension, Square: $square

# can skip this if need be, but having the resized file no matter what is handy
#if [  1 -eq $square ]; then
#  echo Square, will not crop
#  continue
#fi

startingw=$(( ($width - $mindimension) / 2 ))
startingh=$(( ($height - $mindimension) / 2 ))

echo "Cropping... starting at $startingw, $startingh"

# get output image names
squarename="${FILE%.*}"-square.jpg
squarename2048="${FILE%.*}"-square2048.jpg

magick convert "$FILE" -crop "$mindimension"x"$mindimension"+$startingw+$startingh +repage "$squarename"

echo "Resizing to 2048..."

magick convert "$squarename" -resize 2048x2048\> "$squarename2048"

done
