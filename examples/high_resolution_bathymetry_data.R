library(sf)
install.packages("pak")
pak::pak('vapour')
library(vapour)
pak::pak('countrycode')
pak::pak('hypertidy/spatial.datasources')
pak::pak('hypertidy/ximage')
library(ximage)

#link to a high-resolution topogrpahy+bathymtry dataset
dsn <- spatial.datasources::gebco()
dsn

#download a all tiles at 1 deg resolution globally
terra::rast(dsn)

# whole world view
im <- gdal_raster_data(dsn, target_res = 1)
ximage(im, asp = 1, xlab="Longitude", ylab="Latitude")

# just look at a view of the world over the South Pole
im_epsg_3031 <- gdal_raster_data(dsn, target_res = 25000, target_crs = "EPSG:3031", target_ext = c(-1, 1, -1, 1) * 1e7)
ximage(im_epsg_3031, asp = 1)

# just look at a view of the world over the North Pole
im_epsg_3995 <- gdal_raster_data(dsn, target_res = 25000, target_crs = "EPSG:3995", target_ext = c(-1, 1, -1, 1) * 1e7)
ximage(im_epsg_3995, asp = 1)