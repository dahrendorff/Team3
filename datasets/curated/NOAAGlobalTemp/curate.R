# Code is taken from, or inspired by:
# November Temperature Anomaly" Shammun (URL: https://rpubs.com/KoushikChowdhury/329356)

library(RNetCDF)

da1 = scan("NOAAGlobalTemp.gridded.v4.0.1.201711.asc")
# read data upto January 2017
da1 = da1[1:4267130]

length(da1)