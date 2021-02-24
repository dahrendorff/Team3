//gp_continuous
data {
  int N; // number of samples
  matrix[N,N] d; // pre-computed distance between samples
  
}
parameters {
  real<lower=0> rho; // length-scale of correlation
  real<lower=0> alpha; // variance explained by gp
  real<lower=0> sigma; // residual variance
}
transformed parameters {
}
model {
  matrix[N,N] cov = add_diag(square(alpha) * exp(-square(rho) / (2 * square(d[]
}
generated quantities {
}
