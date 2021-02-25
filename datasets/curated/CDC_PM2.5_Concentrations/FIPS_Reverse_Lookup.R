#install.packages('usmap')
library(usmap)
usmap::fips_info(c("01001", "01003", "01005", "01007"))
#>      full abbr         county  fips
#> 1 Alabama   AL Baldwin County 01003
#> 2 Alabama   AL Barbour County 01005
#> 3 Alabama   AL Autauga County 01001
#> 4 Alabama   AL    Bibb County 01007