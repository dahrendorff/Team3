//gp_continuous
//https://mc-stan.org/docs/2_26/stan-users-guide/fit-gp-section.html
functions {
  vector gp_pred_rng(matrix d,
                     vector y,
                     real alpha,
                     real rho,
                     matrix L) {
    int N2 = rows(d);
    int N = cols(d) - N2;
    vector[N2] f2;
    {
      matrix[N2,N] k_d_d2;
      vector[N2] f2_mu;
      matrix[N, N2] v_pred;
      matrix[N2, N2] cov_f2;

      k_d_d2
        = square(alpha)
          * exp(-square(d[,1:N]) / (2 * square(rho)));

      f2_mu = k_d_d2 * mdivide_right_tri_low(mdivide_left_tri_low(L, y)', L)';

      v_pred = mdivide_left_tri_low(L, k_d_d2);

      cov_f2
        = square(alpha)
          * exp(-square(d[,(N+1):]) / (2 * square(rho)))
          - crossprod(v_pred);

      f2 = multi_normal_rng(f2_mu, add_diag(cov_f2, 1e-9));
    }
    return f2;
  }
}
data {
  int N; // number of samples
  matrix[N,N] d; // pre-computed distance between samples
  real<lower=0> prior_scale; // expected length-scale of GP; eg mean of distances
  int N2; // number of points to impute
  matrix[N2,N+N2] d2; // pre-computed distances between points to impute
  vector[N] y; // continuous, normally distributed data
}
parameters {
  real<lower=0> rho; // length-scale of GP correlation
  real<lower=0> alpha; // variance explained by GP
  real<lower=0> sigma; // residual variance
}
transformed parameters {
  matrix[N,N] L
    = cholesky_decompose(add_diag(square(alpha)
                                  * exp(-square(d) / (2 * square(rho))),
                                  square(sigma)));
}
model {
  rho ~ inv_gamma(5, 5 * prior_scale);
  alpha ~ std_normal();
  sigma ~ std_normal();

  y ~ multi_normal_cholesky(zeros_vector(N), L);
}
generated quantities {
  vector[N2] f2 = gp_pred_rng(d2, y, alpha, rho, L);
  vector[N2] y2;
  for(n2 in 1:N2) y2[n2] = normal_rng(f2[n2], sigma);
}
