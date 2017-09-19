data {
  int N_h; 
  int N_s;
  real Y_h[N_h];
  real Y_s[N_s];
}

parameters {
  real<lower=0> m_h; //形状パラメータ
  real<lower=0> m_s;
  real<lower=0> eta_h; //尺度パラメータ
  real<lower=0> eta_s;
}

model {
  for(i in 1:N_h){
    Y_h[i] ~ weibull(m_h, eta_h);
  }
  for(j in 1:N_s){
    Y_s[j] ~ weibull(m_s, eta_s);
  }
}