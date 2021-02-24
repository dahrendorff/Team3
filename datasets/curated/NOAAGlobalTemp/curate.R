# Code is taken from, or inspired by:
# November Temperature Anomaly" Shammun (URL: https://rpubs.com/KoushikChowdhury/329356), which in turn states that:
# "This article to most extent is inspired by the article by Samuel S.P. Shen which you can download from this address: [Climate Data Analysis Using R] (httP;//shen.sdsu.edu/pdf/R-TextBySamShen2017.pdf)"
#
#
library(RNetCDF)

da1 = scan("NOAAGlobalTemp.gridded.v4.0.1.201711.asc")
# read data upto January 2017
da1 = da1[1:4267130]

length(da1)
