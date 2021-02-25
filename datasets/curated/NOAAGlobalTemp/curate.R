# Code is borrowed from, or inspired by:
# November Temperature Anomaly" Shammun (URL: https://rpubs.com/KoushikChowdhury/329356), which in turn states that:
# "This article to most extent is inspired by the article by Samuel S.P. Shen which you can download from this address: [Climate Data Analysis Using R] (httP;//shen.sdsu.edu/pdf/R-TextBySamShen2017.pdf)"
#
# 
#

#install.packages("RNetCDF")
library(RNetCDF)

# input fils is located in datasets/raw/
da1 = scan("NOAAGlobalTemp.gridded.v4.0.1.201711.asc")

# read data upto January 2017
da1 = da1[1:4267130]

length(da1)

#[1]    1.0 1880.0 -999.9 #means mon, year, temp
#data in 72 rows (2.5, ..., 357.5) and 
#data in 36 columns (-87.5, ..., 87.5)
tm1=seq(1,4267129, by=2594)
tm2=seq(2,4267130, by=2594)
#length(tm1)

mm1=da1[tm1] #Extract months
yy1=da1[tm2] #Extract years

rw1<-paste(yy1, sep="-", mm1) #Combine YYYY with MM

tm3=cbind(tm1,tm2)
tm4=as.vector(t(tm3))

#head(tm4)
#[1]    1    2 2595 2596 5189 5190
da2<-da1[-tm4] #Remove the months and years data from the scanned data

da3<-matrix(da2,ncol=1645) #Generate the space-time data
colnames(da3)<-rw1
lat1=seq(-87.5, 87.5, length=36)
lon1=seq(2.5, 357.5,  length=72)
LAT=rep(lat1, each=72)
LON=rep(lon1,36)
gpcpst=cbind(LAT, LON, da3)


#Example where we fetch out data for all Novembers from the last 5 years:
allNovembers = seq(11, 137*12, by =12)
recentYears = seq(2012, 2016, by = 1)

Lat= seq(-87.5, 87.5, length=36)
Lon=seq(2.5, 357.5, length=72)

#Covert the vector into a lon-lat matrix for R map plotting
#mapmat=matrix(gpcpst[,t],nrow=72)

#This command compresses numbers larger than 6 to 6
#mapmat=pmax(pmin(mapmat,6),-6)

#output:
# Lat - latitudes
# Lon - longitudes
# gpcpst contains the entire dataset from 1880 to Jan-2017


## addition RCM to quickly filter a test dataset

testdat <- gpcpst[gpcpst[,ncol(gpcpst)] != -999.9, c(1,2,ncol(gpcpst))]
write.table(testdat,file='testdat.txt',sep='\t',quote=FALSE,row.names=FALSE)
