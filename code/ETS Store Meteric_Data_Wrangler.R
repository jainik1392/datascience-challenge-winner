library(tidyverse)
#install.packages('forecast')
library(forecast)
storemet<-read.csv('Store_Metrics_final.csv')
names(storemet)
head(storemet)
storemet$level_1<-as.Date(storemet$level_1, format="%m/%d/%Y")

unique(storemet['level_1'])
storemet<-storemet[c(-10,-11,-12,-13,-14)]
data<-data.frame(matrix(ncol = 4, nrow = 0))
x <- c("plant", "date", "KPI","value")
colnames(data)<-x
for (kpi in names(storemet)[3:9]){
  for ( plant in unique(storemet$ï..ï..Plant)){
    tsdata<-ts(storemet[storemet$ï..ï..Plant==plant,kpi],start=c(2013,1),end=c(2014,12),frequency=12)
    HWmodel<-ets(tsdata,model = "ZZA")
    seas_fcast <- forecast(HWmodel, h=12)
    data<-rbind(data,data.frame(rep(plant,12),as.yearmon(time(seas_fcast$mean)), rep(kpi,12),as.numeric(seas_fcast$mean)))
    print(plant)
    }
}

tsdata<-ts(storemet[storemet$ï..ï..Plant=='A2AB','StoreAccountMTDtoQuota'],start=c(2013,1),end=c(2014,12),frequency=12)
HWmodel<-ets(tsdata,model = "ZZA")
seas_fcast <- forecast(HWmodel, h=12)
plot(seas_fcast)
data<-rbind(data,data.frame(rep(plant,12),as.yearmon(time(seas_fcast$mean)), rep(kpi,12),as.numeric(seas_fcast$mean)))

storemet<-storemet%>%
  arrange(ï..ï..Plant,level_1)

library(zoo)
fortify(seas_fcast$mean)

library(reshape)
data2<-cast(data, plant+date~KPI)
write.csv(data2,"2015metricEstimate.csv")
