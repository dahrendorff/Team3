## Load Necessary Packages ##
library(dplyr)

## Transfer the metadata from nextstrain into a data frame ##

north_america_data<-read.csv("nextstrain_ncov_north-america_metadata.tsv", header = TRUE, sep = "\t", quote = "")

    ## Viewing to ensure it loaded in properly ## 
      view(north_america_data)

## Select sequence entries that have a response in the location column ##
    ## Checking what I'm actually working with ##
      str(north_america_data)

NA_location_data <- filter(north_america_data, Location !="")

view(NA_location_data)







