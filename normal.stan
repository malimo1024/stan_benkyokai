data { //データの型宣言
  int N_h; //ケース数
  int N_s;
  real Y_h[N_h]; //対数視聴回数(ベクトル)
  real Y_s[N_s];
}

parameters { //パラメータの型宣言
  real mu_h; //平均
  real mu_s;
  real<lower=0> sigma_h; //標準偏差
  real<lower=0> sigma_s;
}

model { //尤度と事前分布の記述．今回は事前分布を省略=無情報事前分布を使用
  for (n in 1:N_h) {
    Y_h[n] ~ normal(mu_h,sigma_h); //パラメータは対数家されて__lpに加算されていく
  }
  for (n in 1:N_s) {
    Y_s[n] ~ normal(mu_s,sigma_s);
  }
}