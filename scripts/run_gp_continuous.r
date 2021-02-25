#install.packages('geosphere')
#install.packages('DescTools')
library(cmdstanr)
library(rstan)

output_prefix <- './outputs/gp'
model_dir <- './models/'
model_name <- 'gp_continuous'

sampling = paste(paste0('./', model_name),
                paste0('data file=', file.path(output_prefix, 'data.json')),
                paste0('init=', file.path(output_prefix, 'inits.json')),
                'output',
                paste0('file=', file.path(output_prefix, 'samples.txt')),
                paste0('refresh=', 100),
                'method=sample algorithm=hmc',
                'stepsize=0.01',
                'engine=nuts',
                'max_depth=7',
                'num_warmup=500',
                'num_samples=200',
                sep=' ')
                
                
testdat <- read.table('./datasets/curated/NOAAGlobalTemp/testdat.txt',sep='\t',header=T)

d <- geosphere:::distm(testdat[,1:2], fun=distVincentyEllipsoid)

N2 <- 100
randomCartesian <- t(apply(matrix(rnorm(N2*3), nrow=N2), 1, function(x) x / sqrt(sum(x^2))))
randomPolar <- t(apply(randomCartesian, 1, function(x) unlist(DescTools:::CartToSph(x[1],x[2],x[3]))))

d2 <- geosphere:::distm(rbind(testdat[,1:2],randomPolar[,2:3]), fun=distVincentyEllipsoid)
                                          
data <- list(N = nrows(testdat),
             d = d,
             prior_scale = mean(lower.tri(d)),
             N2 = N2,
             d2 = d2[(N+1):(N+N2),],
             y = testdat[,3])

#init <- list()

#write_stan_json(init, file.path(output_prefix, 'inits.json'))
write_stan_json(data, file.path(output_prefix, 'data.json'))

setwd(cmdstan_path())
system(paste0('make ', file.path(model_dir, model_name)))

setwd(model_dir)
print(sampling_command)
print(date())
system(sampling_command)

#stanfit <- read_stan_csv(file.path(output_prefix, 'samples.txt'))
