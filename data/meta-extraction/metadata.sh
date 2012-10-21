#!/bin/bash
### Run this after to download and extract the geometry bounding boxes from the image metadata files. 
let ACTIVE=0
echo "pds_version_id;not_applicable_constant;data_set_id;data_set_name;producer_institution_name;producer_id;producer_full_name;observation_id;product_id;product_version_id;instrument_host_name;instrument_host_id;instrument_name;instrument_id;target_name;mission_phase_name;orbit_number;source_product_id;rationale_desc;software_name;data_set_map_projection;map_projection_type;projection_latitude_type;a_axis_radius;b_axis_radius;c_axis_radius;coordinate_system_name;positive_longitude_direction;keyword_latitude_type;center_latitude;center_longitude;line_first_pixel;line_last_pixel;sample_first_pixel;sample_last_pixel;map_projection_rotation;map_resolution;map_scale;maximum_latitude;minimum_latitude;line_projection_offset;sample_projection_offset;easternmost_longitude;westernmost_longitude;mroobservation_start_time;start_time;spacecraft_clock_start_count;stop_time;spacecraft_clock_stop_count;product_creation_time;mroccd_flag;mrobinning;mrotdi;mrospecial_processing_flag;incidence_angle;emission_angle;phase_angle;local_time;solar_longitude;sub_solar_azimuth;north_azimuth;record_type;encoding_type;encoding_type_version_name;interchange_format;uncompressed_file_name;required_storage_bytes;record_type;record_bytes;file_records;image;lines;line_samples;bands;sample_type;sample_bits;sample_bit_mask;scaling_factor;offset;band_storage_type;core_null;core_low_repr_saturation;core_low_instr_saturation;core_high_repr_saturation;core_high_instr_saturation;center_filter_wavelength;mrominimum_stretch;mromaximum_stretch;filter_name;geometry;url" > DATA.csv;
cat FILES.txt | sed -nE 's~^(.*.LBL)$~\1~p' > LABEL_FILES.txt;
cat LABEL_FILES.txt | while read LINE; do
    (URL=$(echo $LINE | sed -nE 's~^(http://.*)/([^/]+.LBL)$~\1/\2~p');
    FILENAME=$(echo $LINE | sed -nE 's~^(http://.*)/([^/]+.LBL)$~\2~p');
    mkdir -p LBL;
    wget \
       --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3" \
       --referer="http://jpl.nasa.gov" \
       ${LINE} && \
    mv ${FILENAME} LBL/${FILENAME};
    MAX_LAT=$(cat LBL/${FILENAME} | \
       sed -nE 's~.*MAXIMUM_LATITUDE[^0-9]+([-0-9.]+)[ <].*$~\1~p');
    MIN_LAT=$(cat LBL/${FILENAME} | \
       sed -nE 's~.*MINIMUM_LATITUDE[^0-9]+([-0-9.]+)[ <].*$~\1~p');
    EAST=$(cat LBL/${FILENAME} | \
       sed -nE 's~.*EASTERNMOST_LONGITUDE[^0-9]+([-0-9.]+)[ <].*$~\1~p');
    WEST=$(cat LBL/${FILENAME} | \
       sed -nE 's~.*WESTERNMOST_LONGITUDE[^0-9]+([-0-9.]+)[ <].*$~\1~p');
    ID=$(cat LBL/${FILENAME} | \
       sed -nE 's~.*PRODUCT_ID[^=]+= "([^"]+)".*$~\1~p');
    PDS_VERSION_ID=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}PDS_VERSION_ID[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    NOT_APPLICABLE_CONSTANT=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}NOT_APPLICABLE_CONSTANT[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    DATA_SET_ID=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}DATA_SET_ID[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    DATA_SET_NAME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}DATA_SET_NAME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    PRODUCER_INSTITUTION_NAME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}PRODUCER_INSTITUTION_NAME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    PRODUCER_ID=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}PRODUCER_ID[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    PRODUCER_FULL_NAME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}PRODUCER_FULL_NAME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    OBSERVATION_ID=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}OBSERVATION_ID[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    PRODUCT_ID=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}PRODUCT_ID[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    PRODUCT_VERSION_ID=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}PRODUCT_VERSION_ID[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    INSTRUMENT_HOST_NAME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}INSTRUMENT_HOST_NAME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    INSTRUMENT_HOST_ID=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}INSTRUMENT_HOST_ID[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    INSTRUMENT_NAME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}INSTRUMENT_NAME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    INSTRUMENT_ID=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}INSTRUMENT_ID[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    TARGET_NAME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}TARGET_NAME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    MISSION_PHASE_NAME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}MISSION_PHASE_NAME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    ORBIT_NUMBER=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}ORBIT_NUMBER[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    SOURCE_PRODUCT_ID=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}SOURCE_PRODUCT_ID[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    RATIONALE_DESC=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}RATIONALE_DESC[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    SOFTWARE_NAME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}SOFTWARE_NAME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    DATA_SET_MAP_PROJECTION=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}DATA_SET_MAP_PROJECTION[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    MAP_PROJECTION_TYPE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}MAP_PROJECTION_TYPE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    PROJECTION_LATITUDE_TYPE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}PROJECTION_LATITUDE_TYPE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    A_AXIS_RADIUS=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}A_AXIS_RADIUS[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    B_AXIS_RADIUS=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}B_AXIS_RADIUS[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    C_AXIS_RADIUS=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}C_AXIS_RADIUS[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    COORDINATE_SYSTEM_NAME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}COORDINATE_SYSTEM_NAME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    POSITIVE_LONGITUDE_DIRECTION=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}POSITIVE_LONGITUDE_DIRECTION[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    KEYWORD_LATITUDE_TYPE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}KEYWORD_LATITUDE_TYPE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    CENTER_LATITUDE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}CENTER_LATITUDE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    CENTER_LONGITUDE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}CENTER_LONGITUDE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    LINE_FIRST_PIXEL=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}LINE_FIRST_PIXEL[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    LINE_LAST_PIXEL=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}LINE_LAST_PIXEL[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    SAMPLE_FIRST_PIXEL=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}SAMPLE_FIRST_PIXEL[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    SAMPLE_LAST_PIXEL=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}SAMPLE_LAST_PIXEL[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    MAP_PROJECTION_ROTATION=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}MAP_PROJECTION_ROTATION[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    MAP_RESOLUTION=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}MAP_RESOLUTION[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    MAP_SCALE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}MAP_SCALE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    MAXIMUM_LATITUDE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}MAXIMUM_LATITUDE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    MINIMUM_LATITUDE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}MINIMUM_LATITUDE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    LINE_PROJECTION_OFFSET=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}LINE_PROJECTION_OFFSET[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    SAMPLE_PROJECTION_OFFSET=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}SAMPLE_PROJECTION_OFFSET[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    EASTERNMOST_LONGITUDE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}EASTERNMOST_LONGITUDE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    WESTERNMOST_LONGITUDE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}WESTERNMOST_LONGITUDE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    MROOBSERVATION_START_TIME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}MRO:OBSERVATION_START_TIME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    START_TIME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}START_TIME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    SPACECRAFT_CLOCK_START_COUNT=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}SPACECRAFT_CLOCK_START_COUNT[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    STOP_TIME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}STOP_TIME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    SPACECRAFT_CLOCK_STOP_COUNT=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}SPACECRAFT_CLOCK_STOP_COUNT[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    PRODUCT_CREATION_TIME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}PRODUCT_CREATION_TIME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    MROCCD_FLAG=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}MRO:CCD_FLAG[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    MROBINNING=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}MRO:BINNING[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    MROTDI=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}MRO:TDI[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    MROSPECIAL_PROCESSING_FLAG=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}MRO:SPECIAL_PROCESSING_FLAG[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    INCIDENCE_ANGLE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}INCIDENCE_ANGLE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    EMISSION_ANGLE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}EMISSION_ANGLE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    PHASE_ANGLE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}PHASE_ANGLE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    LOCAL_TIME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}LOCAL_TIME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    SOLAR_LONGITUDE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}SOLAR_LONGITUDE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    SUB_SOLAR_AZIMUTH=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}SUB_SOLAR_AZIMUTH[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    NORTH_AZIMUTH=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}NORTH_AZIMUTH[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    RECORD_TYPE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}RECORD_TYPE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    ENCODING_TYPE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}ENCODING_TYPE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    ENCODING_TYPE_VERSION_NAME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}ENCODING_TYPE_VERSION_NAME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    INTERCHANGE_FORMAT=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}INTERCHANGE_FORMAT[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    UNCOMPRESSED_FILE_NAME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}UNCOMPRESSED_FILE_NAME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    REQUIRED_STORAGE_BYTES=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}REQUIRED_STORAGE_BYTES[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    RECORD_TYPE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}RECORD_TYPE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    RECORD_BYTES=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}RECORD_BYTES[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    FILE_RECORDS=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}FILE_RECORDS[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    IMAGE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}IMAGE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    LINES=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}LINES[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    LINE_SAMPLES=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}LINE_SAMPLES[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    BANDS=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}BANDS[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    SAMPLE_TYPE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}SAMPLE_TYPE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    SAMPLE_BITS=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}SAMPLE_BITS[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    SAMPLE_BIT_MASK=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}SAMPLE_BIT_MASK[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    SCALING_FACTOR=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}SCALING_FACTOR[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    OFFSET=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}OFFSET[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    BAND_STORAGE_TYPE=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}BAND_STORAGE_TYPE[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    CORE_NULL=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}CORE_NULL[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    CORE_LOW_REPR_SATURATION=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}CORE_LOW_REPR_SATURATION[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    CORE_LOW_INSTR_SATURATION=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}CORE_LOW_INSTR_SATURATION[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    CORE_HIGH_REPR_SATURATION=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}CORE_HIGH_REPR_SATURATION[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    CORE_HIGH_INSTR_SATURATION=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}CORE_HIGH_INSTR_SATURATION[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    CENTER_FILTER_WAVELENGTH=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}CENTER_FILTER_WAVELENGTH[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    MROMINIMUM_STRETCH=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}MRO:MINIMUM_STRETCH[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    MROMAXIMUM_STRETCH=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}MRO:MAXIMUM_STRETCH[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
    FILTER_NAME=$(cat LBL/$FILENAME | \
       perl -i -pe 's~,[[:space:]]+~, \1~smg' | \
       tr -s ' ' | \
       sed -nE 's~^[[:space:]]{0,}FILTER_NAME[[:space:]]{0,}=[[:space:]]{0,}(.*)$~\1~p' | \
       tr -s '\"' | \
       sed -E 's~^([^<]+)<.*$~\1~g' | \
       tr -s '\n' ' ');
      DATA_ROW=$(echo "${PDS_VERSION_ID};${NOT_APPLICABLE_CONSTANT};${DATA_SET_ID};${DATA_SET_NAME};${PRODUCER_INSTITUTION_NAME};${PRODUCER_ID};${PRODUCER_FULL_NAME};${OBSERVATION_ID};${PRODUCT_ID};${PRODUCT_VERSION_ID};${INSTRUMENT_HOST_NAME};${INSTRUMENT_HOST_ID};${INSTRUMENT_NAME};${INSTRUMENT_ID};${TARGET_NAME};${MISSION_PHASE_NAME};${ORBIT_NUMBER};${SOURCE_PRODUCT_ID};${RATIONALE_DESC};${SOFTWARE_NAME};${DATA_SET_MAP_PROJECTION};${MAP_PROJECTION_TYPE};${PROJECTION_LATITUDE_TYPE};${A_AXIS_RADIUS};${B_AXIS_RADIUS};${C_AXIS_RADIUS};${COORDINATE_SYSTEM_NAME};${POSITIVE_LONGITUDE_DIRECTION};${KEYWORD_LATITUDE_TYPE};${CENTER_LATITUDE};${CENTER_LONGITUDE};${LINE_FIRST_PIXEL};${LINE_LAST_PIXEL};${SAMPLE_FIRST_PIXEL};${SAMPLE_LAST_PIXEL};${MAP_PROJECTION_ROTATION};${MAP_RESOLUTION};${MAP_SCALE};${MAXIMUM_LATITUDE};${MINIMUM_LATITUDE};${LINE_PROJECTION_OFFSET};${SAMPLE_PROJECTION_OFFSET};${EASTERNMOST_LONGITUDE};${WESTERNMOST_LONGITUDE};${MROOBSERVATION_START_TIME};${START_TIME};${SPACECRAFT_CLOCK_START_COUNT};${STOP_TIME};${SPACECRAFT_CLOCK_STOP_COUNT};${PRODUCT_CREATION_TIME};${MROCCD_FLAG};${MROBINNING};${MROTDI};${MROSPECIAL_PROCESSING_FLAG};${INCIDENCE_ANGLE};${EMISSION_ANGLE};${PHASE_ANGLE};${LOCAL_TIME};${SOLAR_LONGITUDE};${SUB_SOLAR_AZIMUTH};${NORTH_AZIMUTH};${RECORD_TYPE};${ENCODING_TYPE};${ENCODING_TYPE_VERSION_NAME};${INTERCHANGE_FORMAT};${UNCOMPRESSED_FILE_NAME};${REQUIRED_STORAGE_BYTES};${RECORD_TYPE};${RECORD_BYTES};${FILE_RECORDS};${IMAGE};${LINES};${LINE_SAMPLES};${BANDS};${SAMPLE_TYPE};${SAMPLE_BITS};${SAMPLE_BIT_MASK};${SCALING_FACTOR};${OFFSET};${BAND_STORAGE_TYPE};${CORE_NULL};${CORE_LOW_REPR_SATURATION};${CORE_LOW_INSTR_SATURATION};${CORE_HIGH_REPR_SATURATION};${CORE_HIGH_INSTR_SATURATION};${CENTER_FILTER_WAVELENGTH};${MROMINIMUM_STRETCH};${MROMAXIMUM_STRETCH};${FILTER_NAME};POLYGON((${WEST} ${MAX_LAT},${EAST} ${MAX_LAT},${EAST} ${MIN_LAT},${WEST} ${MIN_LAT},${WEST} ${MAX_LAT}));${LINE}" | \
       sed -E 's~[[:space:]]{0,};[[:space:]]{0,}~;~g' | \
       tr -d '\n' | \
       perl -i -pe 's~\s{1,}~ ~smg');
   echo "$DATA_ROW" > TMP/${FILENAME%.LBL}.csv) &
    let ACTIVE=$ACTIVE+1
  if [ "$ACTIVE" -eq "10" ]; then
      wait
      sleep 5;
      let ACTIVE=0
  fi
done