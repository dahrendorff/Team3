//gp_continuous
data {
  int N; // number of samples
  matrix[N,N] d; // pre-computed distance between samples
  real<lower=0> prior_scale;
}
parameters {
  real<lower=0> rho; // length-scale of correlation
  real<lower=0> alpha; // variance explained by gp
  real<lower=0> sigma; // residual variance
}
transformed parameters {
}
model {
  matrix[N,N] L 
    = cholesky_decompose(add_diag(square(alpha) 
                                  * exp(-square(rho) / (2 * square(d))), 
                                  square(sigma)));
  rho ~ inv_gamma(5, 5 * prior_scale)
}
generated quantities {
}
