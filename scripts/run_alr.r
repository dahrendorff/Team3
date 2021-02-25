library(ape)
library(cmdstanr)
library(rstan)

wd <- getwd()
output_prefix <- file.path(wd,'outputs/alr')
model_dir <- file.path(wd, 'models')
model_name <- 'alr'

sampling_command <- paste(paste0('./', model_name),
                paste0('data file=', file.path(output_prefix, 'data.json')),
                #paste0('init=', file.path(output_prefix, 'inits.json')),
                'output',
                paste0('file=', file.path(output_prefix, 'samples.txt')),
                paste0('refresh=', 100),
                'method=sample algorithm=hmc',
                #'stepsize=0.01',
                'engine=nuts',
                'max_depth=7',
                'num_warmup=500',
                'num_samples=200',
                sep=' ')
      
phy <- read.tree()
latlon <- read.table()

phy <- drop.tips(phy$tip.label %in% latlon[,1])
latlon <- latlon[phy$tip.label,]
latlonrad <- DescTools:::DegToRad(latlon[,2:3])
      
N <- nrow(latlon)

tipdist <- geosphere:::distm(latlon, fun = function(x,y) geosphere:::distGeo(x,y,a=1))
sigma_prior <- mean(cophenetic(phy)/tipdist)             
                              
data <- list(N = N,
             phi_tips = latlonrad[,1],
             theta_tips = latlonrad[,2],
             time = phy$edge.length,
             self = phy$edge[,1],
             ancestor = phy$edge[,2],
             sigma_prior = sigma_prior)

#init <- list()

#write_stan_json(init, file.path(output_prefix, 'inits.json'))
write_stan_json(data, file.path(output_prefix, 'data.json'))

setwd(cmdstan_path())
system(paste0('make ', file.path(model_dir, model_name)))

setwd(model_dir)
print(sampling_command)
print(date())
system(sampling_command)

#setwd(wd)
#stanfit <- read_stan_csv(file.path(output_prefix, 'samples.txt'))
