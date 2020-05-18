library(data.table)
library(Hmisc)

Test_raw <- fread("project/volume/data/raw/Stat_380_test.csv")
Train_raw <- fread("project/volume/data/raw/Stat_380_train.csv")



Test_raw$SalePrice = mean(Train_raw$SalePrice)

# submition 1 for mean prices
fwrite(Test_raw[,.(Id,SalePrice)],file = "project/volume/data/processed/mean.csv")




