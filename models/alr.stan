## estimate ancestral node locations on a sphere assuming presence of large outlier movements
functions {
  real wrapped_cauchy_lpdf(real y, real mu, real gamma) {
    return(log(sinh(gamma))
           - log(cosh(gamma) - cos(y-mu))
           - log(2 * pi()));
  }
}
data {
  int<lower=2> N; // number of tips
  vector<lower=-pi(), upper=pi()>[N] phi_tips; //latitude in radians
  vector<lower=-pi()/2, upper=pi()/2>[N] theta_tips; //longitude in radians
  vector<lower=0>[2*N-2] time; //temporal distances between adjacent tips/nodes
  int self[2*N-2]; // index for each tip/node in a single vector
  int ancestor[2*N-2]; // index for each tip/node's ancestor in a single vector
  real<lower=0> sigma_prior;
}
parameters {
  real<lower=0> sigma_raw; //dispersal rate
  unit_vector[3] loc_anc[N-1]; //ancestral node location
}
transformed parameters {
  vector[2*N-1] phi; //latitude in radians
  vector[2*N-1] theta; //longitude in radians
  vector[2*N-2] d; //geographic distances between adjacent tips/nodes
  phi[1:N] = phi_tips;
  theta[1:N] = theta_tips;
  for(n in 1:(N-1)) {
    phi[N+n] = atan2(loc_anc[2],loc_anc[1]);
    theta[N+n] = atan2(sqrt(dot_self(loc_anc[1:2])), loc_anc[3]);
  }
  for(n in 1:(2*N-2)) {
    d[n] = sqrt(2-2*(sin(theta[self[n]])*sin(theta[ancestor[n]])*cos(phi[self[n]]-phi[ancestor[n]])+cos(theta[self[n]])*cos(theta[ancestor[n]])));
  }
}
model {
  sigma_raw ~ std_normal();
  time ~ wrapped_cauchy(d, sigma_raw * sigma_prior);
}
