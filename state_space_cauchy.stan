data {
    int t;
    int t_miss;
    real Y_t[t];
}

parameters {
    real<lower=0> Y_miss[t_miss];
    real<lower=0> sigma_state;
    real<lower=0> sigma_observation;
    real<lower=0> mu_init;
    real<lower=-pi()/2,upper=pi()/2> mu_unif[t-1];
}

transformed parameters {
   real mu[t];
   mu[1] = mu_init;
   for (n in 2:t)
      mu[n] = mu[n-1] + sigma_state*tan(mu_unif[n-1]);
}

model {
    int n_miss;
    n_miss = 0;
    for(i in 1:t){
        if(Y_t[i]!=9999){
          Y_t[i] ~ cauchy(mu[i],sigma_observation); 
        }else{
          n_miss = n_miss + 1;
          Y_miss[n_miss] ~ cauchy(mu[i],sigma_observation); //観測モデル(欠損値)
        }
    }
}