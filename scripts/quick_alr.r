library(ape)

phy <- read.tree('/Users/Ryan/codeathon2021/Team3/datasets/raw/NextStrain/nextstrain_ncov_north-america_timetree.nwk')

dat <- read.table('/Users/Ryan/codeathon2021/Team3/datasets/raw/NextStrain/nextstrain_ncov_north-america_metadata.tsv',header=T, sep='\t', quote='')

dat <- dat[dat$Location != '',]

library('tmaptools')
latlon <- geocode_OSM(dat$Location)
