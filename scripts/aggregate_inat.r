install.packages('rinat')
library(rinat)
#rodents <- get_inat_obs(query = "Rodentia")
rodents <- get_inat_obs(taxon_name = "Rodentia", place_id=__, geo=TRUE, maxresults = 10000)

head(rodents)
rodents_filtered <- rodents[,c('longitude','latitude')]

####### block from https://stackoverflow.com/questions/13316185/r-convert-zipcode-or-lat-long-to-county
library(sp)
library(maps)
library(maptools)

# The single argument to this function, pointsDF, is a data.frame in which:
#   - column 1 contains the longitude in degrees (negative in the US)
#   - column 2 contains the latitude in degrees

latlong2county <- function(pointsDF) {
    # Prepare SpatialPolygons object with one SpatialPolygon
    # per county
    counties <- map('county', fill=TRUE, col="transparent", plot=FALSE)
    IDs <- sapply(strsplit(counties$names, ":"), function(x) x[1])
    counties_sp <- map2SpatialPolygons(counties, IDs=IDs,
                     proj4string=CRS("+proj=longlat +datum=WGS84"))

    # Convert pointsDF to a SpatialPoints object 
    pointsSP <- SpatialPoints(pointsDF, 
                    proj4string=CRS("+proj=longlat +datum=WGS84"))

    # Use 'over' to get _indices_ of the Polygons object containing each point 
    indices <- over(pointsSP, counties_sp)

    # Return the county names of the Polygons object containing each point
    countyNames <- sapply(counties_sp@polygons, function(x) x@ID)
    countyNames[indices]
}
###########

rodentcounty <- latlong2county(rodents_filtered[apply(rodents_filtered,1,function(x) !any(is.na(x))),])

agdat <- sapply(unique(rodentcounty), function(x) sum(rodentcounty == x, na.rm = TRUE))

## need to then aggregate by county and then find county centroid GPS location for input to model

