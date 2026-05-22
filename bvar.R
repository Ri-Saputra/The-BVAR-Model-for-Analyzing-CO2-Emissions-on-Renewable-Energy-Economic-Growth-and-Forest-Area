set.seed(42)
library(BVAR)
library(ggplot2)
library(patchwork)

# plot data
t1 = ggplot(data) + geom_line(aes(x = 1990:(1989+length(gdp)), y = gdp))+
  labs(title = "GDP (current US$)",x = ' ',y=' ')+ theme(panel.background = element_rect(fill = '#D0FFBC'))
t2 = ggplot(data) + geom_line(aes(x = 1990:(1989+length(gdp)), y = renewable))+
  labs(title = "Renewable (% of total final energy consumption)",x = ' ',y=' ')+ theme(panel.background = element_rect(fill = '#D0FFBC'))
t3 = ggplot(data) + geom_line(aes(x = 1990:(1989+length(gdp)), y = forest))+
  labs(title = "Forest (% of land area)",x = ' ',y=' ')+ theme(panel.background = element_rect(fill = '#D0FFBC'))
t4 = ggplot(data) + geom_line(aes(x = 1990:(1989+length(gdp)), y = co2))+
  labs(title = "CO2 (t CO2/year)",x = ' ',y=' ')+ theme(panel.background = element_rect(fill = '#D0FFBC'))
t1+t2+t3+t4

# transform data
y <- fred_transform(data, codes = c(4, 1, 4, 4))

# Prior Set Up
bv_minnesota(lambda = bv_lambda(mode = 0.2, sd = 0.4, min = 0.0001, max = 5), alpha = bv_alpha(mode = 2), var = 1e07)
soc <- bv_soc(mode = 1, sd = 1, min = 1e-04, max = 50)
sur = bv_sur(mode = 1, sd = 1, min = 0.0001, max = 50)
priors <- bv_priors(hyper = "auto", mn = mn, soc = soc, sur = sur)
mh <- bv_metropolis(scale_hess = c(0.05, 0.0001, 0.0001),
                      adjust_acc = TRUE, acc_lower = 0.25, acc_upper = 0.45)
# Estimation of model
run <- bvar(y, lags = 1, n_draw = 1500000, n_burn = 750000,n_thin=1, 
    priors = priors,mh=mh, verbose = TRUE)

# plot trace dan dens lambda
plot(run, type='trace', vars = 'lambda', col='#A2C692')
plot(run, type='dens', vars = 'lambda', col='#45553E')


# irf
opt_irf <- bv_irf(horizon = 33, identification = TRUE)
irf(run) <- irf(run, opt_irf, conf_bands = c(0.05, 0.16))
summary(irf(run))
plot(irf(run), area = TRUE, fill=c("#A2C692", "#D0FFBC"))


# residu
residu = residuals(run, type = "mean")
residu = as.data.frame(residu)
p1 =ggplot(residu,height=2,width=10) + geom_point(aes(x = 1:length(gdp), y = gdp))+
  labs(title = "Plot Residual GDP",x = ' ',y=' ')+ theme(panel.background = element_rect(fill = '#D0FFBC'),
                                                         panel.grid.major = element_blank(),
                                                         panel.grid.minor = element_blank())
p2 =ggplot(residu,height=2,width=10) + geom_point(aes(x = 1:length(renewable), y = renewable))+
  labs(title = "Plot Residual Renewable",x = '',y='')+ theme(panel.background = element_rect(fill = '#D0FFBC'),
                                                             panel.grid.major = element_blank(),
                                                             panel.grid.minor = element_blank())
p3 =ggplot(residu,height=2,width=10) + geom_point(aes(x = 1:length(forest), y = forest))+
  labs(title = "Plot Residual Forest",x = '',y='')+ theme(panel.background = element_rect(fill = '#D0FFBC'),
                                                          panel.grid.major = element_blank(),
                                                          panel.grid.minor = element_blank())
p4 =ggplot(residu,height=2,width=10) + geom_point(aes(x = 1:length(co2), y = co2))+
  labs(title = "Plot Residual CO2",x = '',y='')+ theme(panel.background = element_rect(fill = '#D0FFBC'),
                                                       panel.grid.major = element_blank(),
                                                       panel.grid.minor = element_blank())

p1+p2+p3+p4+plot_layout(ncol = 1)

# model
koefisien = coef(run)
model_bvar = model(y,koefisien,residu)
merged_data = cbind(y,model_bvar)

q1 = ggplot(merged_data)+
  geom_line(aes(x=1:length(gdp),y=gdp,color='aktual'))+
  geom_line(aes(x=1:length(gdp),y=V1,color='prediksi'))+labs(title = "GDP",x="",y="")+scale_color_manual(breaks=c('aktual', 'prediksi'),
                                                                                                         values=c('aktual'='blue', 'prediksi'='red'))
q2= ggplot(merged_data)+
  geom_line(aes(x=1:length(renewable),y=renewable,color='aktual'))+
  geom_line(aes(x=1:length(gdp),y=V2,color='prediksi'))+labs(title = "Renewable",x="",y="")+scale_color_manual(breaks=c('aktual', 'prediksi'),
                                                                                                               values=c('aktual'='blue', 'prediksi'='red'))
q3 = ggplot(merged_data)+
  geom_line(aes(x=1:length(gdp),y=forest,color='aktual'))+
  geom_line(aes(x=1:length(gdp),y=V3,color='prediksi'))+labs(title = "Forest",x="",y="")+scale_color_manual(breaks=c('aktual', 'prediksi'),
                                                                                                            values=c('aktual'='blue', 'prediksi'='red'))
q4 = ggplot(merged_data)+
  geom_line(aes(x=1:length(gdp),y=co2,color='aktual'))+
  geom_line(aes(x=1:length(gdp),y=V4,color='prediksi'))+labs(title = "CO2",x="",y="")+scale_color_manual(breaks=c('aktual', 'prediksi'),
                                                                                                         values=c('aktual'='blue', 'prediksi'='red'))
q1+q2+q3+q4


# predict forecast
predict(run) <- predict(run, horizon = 16, conf_bands = c(0.05, 0.16))
plot(predict(run), area = TRUE,t_back = 1,fill=c("#A2C692", "#D0FFBC"))

# granger test
# gdp
grangertest(gdp ~ renewable,order=1, data=y,vcov=vcov_)
grangertest(gdp ~ forest,order=1, data=y,vcov=vcov_)
grangertest(gdp ~ co2,order=1, data=y,vcov=vcov_)
# renewable
grangertest(renewable ~ gdp,order=1, data=y,vcov=vcov_)
grangertest(renewable ~ forest,order=1, data=y,vcov=vcov_)
grangertest(renewable ~ co2,order=1, data=y,vcov=vcov_)
# forest
grangertest(forest ~ gdp,order=1, data=y,vcov=vcov_)
grangertest(forest ~ renewable,order=1, data=y,vcov=vcov_)
grangertest(forest ~ co2,order=1, data=y,vcov=vcov_)
# co2
grangertest(co2 ~ gdp,order=1, data=y,vcov=vcov_)
grangertest(co2 ~ renewable,order=1, data=y,vcov=vcov_)
grangertest(co2 ~ forest,order=1, data=y,vcov=vcov_)




grangertest(gdp ~ renewable,order=1, data=y)
grangertest(gdp ~ forest,order=1, data=y)
grangertest(gdp ~ co2,order=1, data=y)

# renewable
grangertest(renewable ~ gdp,order=1, data=y)
grangertest(renewable ~ forest,order=1, data=y)
grangertest(renewable ~ co2,order=1, data=y)

# forest
grangertest(forest ~ gdp,order=1, data=y)
grangertest(forest ~ renewable,order=1, data=y)
grangertest(forest ~ co2,order=1, data=y)

# co2
grangertest(co2 ~ gdp,order=1, data=y)
grangertest(co2 ~ renewable,order=1, data=y)
grangertest(co2 ~ forest,order=1, data=y)
