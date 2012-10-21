#!/bin/bash
mkdir -p json;
mkdir -p uploaded;
cat csvs.txt | while read CSV_DOC; do
        head -n 1 ~/git/hirise/data/meta-extraction/header.csv > TMP/${CSV_DOC%.csv}-TMP.csv;
        cat TMP/${CSV_DOC} | tr -d '\"' >> TMP/${CSV_DOC%.csv}-TMP.csv;
        csvjson -d \; -i 3 -k source_product_id TMP/${CSV_DOC%.csv}-TMP.csv > json/${CSV_DOC%.csv}.json;
        MIN_LAT=$(cat json/${CSV_DOC%.csv}.json | \
          sed -nE 's~^      "minimum_latitude": "([^"]+)",~\1~p' | tr -d ' ');
        MAX_LAT=$(cat json/${CSV_DOC%.csv}.json | \
          sed -nE 's~^      "maximum_latitude": "([^"]+)",~\1~p' | tr -d ' ');
        W_LON_VAL=$(cat json/${CSV_DOC%.csv}.json | \
          sed -nE 's~^      "westernmost_longitude": "([^"]+)",~\1~p' | tr -d ' ');
        ## troubleshoot floating point numeric comparisons in bash
if [ 1 -eq `echo "${W_LON_VAL} < 180" | bc` ];
then  
    W_LON=$W_LON_VAL;
else
    W_LON=$(echo "180 - $W_LON_VAL" | bc -l);
fi    
         E_LON_VAL=$(cat json/${CSV_DOC%.csv}.json | \
sed -nE 's~^      "easternmost_longitude": "([^"]+)",~\1~p' | tr -d ' ');
## troubleshoot floating point numeric comparisons in bash
if [ 1 -eq `echo "${E_LON_VAL} < 180" | bc` ];
then
    E_LON=$E_LON_VAL;
else
    E_LON=$(echo "180-$E_LON_VAL" | bc -l);
fi
      GEO_POLYGON=$(echo "[ [$W_LON,$MAX_LAT], [$E_LON, $MAX_LAT], [$E_LON, $MIN_LAT], [$W_LON, $MIN_LAT], [$W_LON, $MAX_LAT] ]");
     # add simplified point in lieu of polygon due to geocouch lack of support for polygons.
      POLYGON=$(echo "$W_LON,$MAX_LAT");   
     BBOX=$(echo "[
              $W_LON,\`
              $MIN_LAT,\`
              $E_LON,\`
              $MAX_LAT\`
           ]");
        BBOX_INSERT=$( echo $BBOX);
        PROD_ID=$(cat json/${CSV_DOC%.csv}.json | \
          sed -nE 's~^      "source_product_id": "\(([^\)]+)\)",~\1~p' | tr -s ', ' '-' | sed -E 's~^(.*)\-$~\1~g');
        cat json/${CSV_DOC%.csv}.json | \
          perl -i -pe 's~^\{\n~{ \n   "type": "FeatureCollection", \n   "bbox": BBOX_INSERT, \n   "features": [\n      {\n         "geometry": {\n            "type": "Point",\n              "coordinates": [\n    INSERT_POLYGON\n    \n ]},\n   "type": "Feature",\n  "id":~sm' | \
          sed -E "s~^(.*)INSERT_POLYGON~\1${POLYGON}~g;s~(.*)BBOX_INSERT(.*)~\1${BBOX_INSERT}\2~g" | \
          tr '\`' '\n' | \
          sed -E 's~([[:space:]]{1,}"id":[[:space:]]{1,})"\(([^\)]+)\)"~\1"PROD_INSERT"~g' | \
          sed -E "s~(.*)PROD_INSERT(.*)~\1${CSV_DOC%.csv}.LBL\",\
        \"properties\2~g;s~^\}$~}]}~g" |\
          sed -E "s~([^\"]+\"geometry\": )\"POLYGON[^\)]+))\",~\1 {\"type\":\"Polygon\", \"coordinates\":\"[$GEO_POLYGON]\"},~g" | \
        jsonlint > json/${CSV_DOC%.csv}.geojson;
        curl -X POST http://localhost:5984/hirise --header 'Content-Type: application/json' --data @json/${CSV_DOC%.csv}.geojson 
    rm -f TMP/${CSV_DOC%.csv}-TMP.csv json/${CSV_DOC%.csv}.json;
    mv TMP/${CSV_DOC} uploaded/${CSV_DOC};
    done