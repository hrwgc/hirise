---
layout: post
title: "Mars Map Projections"
description: ""
category: 
tags: 
  - SRS
  - projections
  - EPSG
  - geo
---
{% include JB/setup %}

## Spatial Reference

### Resources


- [proj4 Equirectangular Projection Parameters](http://www.remotesensing.org/geotiff/proj_list/equirectangular.html)
- [HiRISE Dataset Map Projection Description](http://hirise-pds.lpl.arizona.edu/PDS/CATALOG/DSMAP.CAT)


## Equirectangular 

### HiRISE Specification

equation var | label tag | meaning | 
--- | --- | ---- |
LonP  | CENTER_LONGITUDE | center longitude of map projection |
LatP  | CENTER_LATITUDE | center latitude of the projection at which scale is given
L0    | LINE_PROJECTION_OFFSET | 
S0    | SAMPLE_PROJECTION_OFFSET |
Scale | MAP_SCALE |
Re    | A_AXIS_RADIUS |  equatorial radius 
Rp    | C_AXIS_RADIUS  | polar radius

### [PROJ.4 Specification](http://www.remotesensing.org/geotiff/proj_list/equirectangular.html)

Name | EPSG # | GeoTIFF ID | OGC(OGR) WKT | ESRI PE WKT | PROJ.4 | Units
--- | --- | --- | --- | --- | --- | --- |
Latitude of true scale | 3 | ProjStdParallel1 | standard_parallel_1 | Standard_Parallel_1 | +lat_ts | Angular
Latitude of origin | 1 (8801) | ProjCenterLat | latitude_of_origin | (unavailable) | +lat_0 | Angular
Longitude of projection center | 2 (8802/8822) | ProjCenterLong | central_meridian | Central_Meridian | +lon_0 | Angular
False Easting | 6 | FalseEasting | false_easting | False_Easting | +x_0 | Linear
False Northing | 7 | FalseNorthing | false_northing | False_Northing | +y_0 | Linear


### Equirectangular / Equidistant Cylindrical (IAU2000:49913) with Center at 180

- PROJ4

{% highlight %}
+proj=eqc +lat_ts=0 +lat_0=0 +lon_0=180 +x_0=0 +y_0=0 +a=3396190 +b=3396190 +units=m +no_defs
{% endhighlight %}

- .prj

{% highlight %}
PROJCS["Mars_Equidistant_Cylindrical",GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Equidistant_Cylindrical"],PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",180],PARAMETER["Standard_Parallel_1",0],UNIT["Meter",1]]
{% endhighlight %}

### Equirectangular / Equidistant Cylindrical (IAU2000:49911) with Center at 0

- PROJ4

{% highlight %}
+proj=eqc +lat_ts=0 +lat_0=0 +lon_0=0 +x_0=0 +y_0=0 +a=3396190 +b=3396190 +units=m +no_defs
{% endhighlight %}

- .prj

{% highlight %}
PROJCS["Mars_Equidistant_Cylindrical",GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Equidistant_Cylindrical"],PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",0],PARAMETER["Standard_Parallel_1",0],UNIT["Meter",1]]
{% endhighlight %}


## Polar Stereographic

### HiRISE Specification


equation var | label tag | meaning | 
--- | --- | ---- |
LonP  | CENTER_LONGITUDE | central longitude 
LatP  | CENTER_LATITUDE | latitude of true scale: always 90 or -90
L0    | LINE_PROJECTION_OFFSET |
S0    | SAMPLE_PROJECTION_OFFSET |
Scale | MAP_SCALE | 
Re    | A_AXIS_RADIUS | equatorial radius 
Rp    | C_AXIS_RADIUS | polar radius of Mars, 3376.2 km

### [PROJ.4 Specification](http://www.remotesensing.org/geotiff/proj_list/equirectangular.html)

Name | EPSG # | GeoTIFF ID | OGC WKT | Units |  Proj.4 North Pole | Proj.4 South Pole
--- | --- | --- | --- | --- | --- | --- |
Latitude of natural origin | 1 | NatOriginLat | latitude_of_origin | Angular |  +lat_0=90 | +lat_0=-90
Latitude of True Scale | | | | | +lat_ts | +lat_ts
Longitude of natural origin | 2 | StraightVertPoleLong | central_meridian | Angular | +lon_0 | +lon_0 |
Scale factor at natural origin | 5 | ScaleAtNatOrigin | scale_factor | Unitless | +k_0 | +k_0
False Easting | 6 | FalseEasting | false_easting | Linear | +x_0 | +x_0
False Northing | 7 | FalseNorthing | false_northing | Linear | +y_0 | +y_0



### North Polar Stereographic (IAU2000:49918)

- PROJ 4

{% highlight %}
+proj=stere +lat_0=90 +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=3396190 +b=3376200 +units=m +no_defs 
{% endhighlight %}

- .prj

{% highlight %}
PROJCS["Mars_North_Pole_Stereographic",GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Stereographic"],PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",0],PARAMETER["Scale_Factor",1],PARAMETER["Latitude_Of_Origin",90],UNIT["Meter",1]]
{% endhighlight %}

### South Polar Stereographic (IAU2000:49920)

- PROJ4

{% highlight %}
+proj=stere +lat_0=-90 +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=3396190 +b=3376200 +units=m +no_defs 
{% endhighlight %}

- .prj

{% highlight %}
PROJCS["Mars_South_Pole_Stereographic",GEOGCS["Mars 2000",DATUM["D_Mars_2000",SPHEROID["Mars_2000_IAU_IAG",3396190.0,169.89444722361179]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Stereographic"],PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",0],PARAMETER["Scale_Factor",1],PARAMETER["Latitude_Of_Origin",-90],UNIT["Meter",1]]
{% endhighlight %}






