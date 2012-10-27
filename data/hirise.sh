#!/bin/bash

FILE="$1"
RESOLUTION="$2"
WORKDIR=$(pwd);
ADDO="2 4 8 16 32 64 128 256 512 1024 2048 4096 8192"
COLOR_INFO=$(echo $FILE | sed -E 's~.*_([A-Z]+)\.JP2~\1~g');
SCRIPTDIR="$HOME/Applications/isis3"
PROCESS=$(cd $SCRIPTDIR && \
  ./JP2_to_PDS \
    -Input ${WORKDIR}/${FILE}  \
    -Output ${WORKDIR}/${FILE%.JP2}.IMG  \
    -Resolution $RESOLUTION \
    -LAbel ${WORKDIR}/LBL/${FILE%.JP2}.LBL) && \
if [ "$COLOR_INFO" = 'COLOR' ]
	then
		gdal_translate \
		  -ot Byte \
		  -scale 0 800 0 255 \
		  -a_nodata 0 \
		  -b 3 -b 2 -b 1 \
		  ${FILE%.JP2}.IMG \
          ${FILE%.JP2}.tif
    else
		gdal_translate \
		    -ot Byte \
		    -scale 0 800 0 255 \
		    -a_nodata 0 \
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
   -t_srs EPSG:3785 \
   ${FILE%.JP2}.tif  \
   ${FILE%.JP2}-3785.tif && \
mv -f ${FILE%.JP2}-3785.tif ${FILE%.JP2}.tif && \
gdaladdo \
   -r cubic \
   --config COMPRESS_OVERVIEW LZW \
   ${FILE%.JP2}.tif \
   $ADDO && \
rm ${FILE%.JP2}.IMG
gzip -9
