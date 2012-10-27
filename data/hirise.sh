#!/bin/bash

FILE="$1"
RESOLUTION="$2"
WORKDIR=$(pwd);
ADDO="2 4 8 16 32 64 128 256 512 1024 2048 4096 8192"
COLOR_INFO=$(echo $FILE | sed -E 's~.*_([A-Z]+)\.JP2~\1~g');
SCRIPTDIR="$HOME/Applications/isis3"
EQUIRECTANGULAR="+proj=eqc +lat_ts=0 +lat_0=0 +lon_0=180 +x_0=0 +y_0=0 +a=3396190 +b=3396190 +units=m +no_defs"
## override native dataset projection information, which is misread in gdal
mkdir -p stats
mkdir -p geom
./fix_jp2 $FILE;
## convert from jp2 to nasa PDS format.
PROCESS=$(cd $SCRIPTDIR && \
  ./JP2_to_PDS \
    -Input ${WORKDIR}/${FILE}  \
    -Output ${WORKDIR}/${FILE%.JP2}.IMG  \
    -Resolution $RESOLUTION \
    -LAbel ${WORKDIR}/LBL/${FILE%.JP2}.LBL) && \
## What follows is a dirty hack to get around GDAL's problems handling the native dataset projection. Using a different version of GDAl with better JPEG2000 support, I obtain the image extents for the source image, which are distorted in the JP2_to_PDS translation. I then reapply the native projection and source extents in the gdal_translate step. 
/Library/Frameworks/GDAL.framework/Versions/1.9/Programs/gdalinfo $FILE > stats/${FILE%$FILE_EXTENSION}.txt;
METADATA="stats/${FILE%$FILE_EXTENSION}.txt"
echo "$FILE" > geom/${FILE%$FILE_EXTENSION}.txt
cat $METADATA | sed -nE 's~(Upper.*|Lower.*)~\1~p' | while read COORDINATES; do
	  SRC_LON=$(echo $COORDINATES | sed -nE 's~^[a-zA-Z ]+[ ]{1,}\(([^\)]+)\)[ ]{1,}\(([^)]+)\)~\1~p' | tr -d ' ' | sed -nE 's~^([^,]+),([^,]+)~\1~p');
	  SRC_LAT=$(echo $COORDINATES | sed -nE 's~^[a-zA-Z ]+[ ]{1,}\(([^\)]+)\)[ ]{1,}\(([^)]+)\)~\1~p' | tr -d ' ' | sed -nE 's~^([^,]+),([^,]+)~\2~p');
      echo "$SRC_LON,$SRC_LAT" >> geom/${FILE%$FILE_EXTENSION}.txt
  done
SUL=$(cat geom/${FILE%$FILE_EXTENSION}.txt | sed -nE '2 s/(.*)/\1/p');
SLL=$(cat geom/${FILE%$FILE_EXTENSION}.txt | sed -nE '3 s/(.*)/\1/p');
SUR=$(cat geom/${FILE%$FILE_EXTENSION}.txt | sed -nE '4 s/(.*)/\1/p');
SLR=$(cat geom/${FILE%$FILE_EXTENSION}.txt | sed -nE '5 s/(.*)/\1/p');
SRC_DATA_ROW=$(echo "$FILE%$SUL%$SUR%$SLR%$SLL%$SUL%" | tr ',' ' '| sed -E 's~^([^%]+)%(.*)%$~\1;POLYGON((\2))~g'| tr '%' ',' | sed -E "s~^~\'~g;s~$~'~g;s~;~\',\'~g");
SRC_EXTENTS=$(echo "$SUL $SLR" |  sed -E 's~([0-9\.\-]+),([0-9\.\-]+)~\2 \1~g' | tr '\n' ' ');
echo "$SRC_DATA_ROW" >> combined_geometry.csv;
if [ "$COLOR_INFO" = 'COLOR' ]
	then
		gdal_translate \
		  -ot Byte \
		  -scale 0 800 0 255 \
		  -a_nodata "0 0 0" \
		  -a_ullr  $SRC_EXTENTS \
		  -a_srs "$EQUIRECTANGULAR" \
		  -b 3 -b 2 -b 1 \
		  ${FILE%.JP2}.IMG \
          ${FILE%.JP2}.tif
    else
		gdal_translate \
		    -ot Byte \
		    -scale 0 800 0 255 \
		    -a_nodata 0 \
		    -a_ullr  $SRC_EXTENTS \
		    -a_srs "$EQUIRECTANGULAR" \
		    ${FILE%.JP2}.IMG \
		    ${FILE%.JP2}.tif
fi
gdalwarp \
   -r lanczos \
   -srcnodata "0 0 0" \
   -dstnodata "0 0 0" \
   -dstalpha \
   -wm 1000 \
   -co COMPRESS=LZW \
   -multi \
   -s_srs "$EQUIRECTANGULAR" \
   -t_srs EPSG:3785 \
   ${FILE%.JP2}.tif  \
   ${FILE%.JP2}-3785.tif && \
mv -f ${FILE%.JP2}-3785.tif ${FILE%.JP2}.tif && \
gdaladdo \
   -r cubic \
   --config COMPRESS_OVERVIEW LZW \
   ${FILE%.JP2}.tif \
   $ADDO && \
rm ${FILE%.JP2}.IMG;