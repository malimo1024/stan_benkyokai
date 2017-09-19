data {
    int t;
    int t_miss;
    real Y_t[t];
}

parameters {
    real<lower=0> mu[t];
    real<lower=0> Y_miss[t_miss];
    real<lower=0> sigma_state;
    real<lower=0> sigma_observation;
    real<lower=0> mu_init;
}

model {
    int n_miss;
    n_miss = 0;
    for(i in 1:t){
      if(i == 1){
        mu[i] ~ normal(mu_init,sigma_state); //システムモデル(i=1)
        Y_t[i] ~ normal(mu[i],sigma_observation); //観測モデル(i=1)
      }else{
        if(Y_t[i]!=9999){
          Y_t[i] ~ normal(mu[i],sigma_observation); 
        }else{
          n_miss = n_miss + 1;
          Y_miss[n_miss] ~ normal(mu[i],sigma_observation); //観測モデル(欠損値)
        }
        mu[i] ~ normal(mu[i-1],sigma_state); //システムモデル(i=>2)
      }
    }
}