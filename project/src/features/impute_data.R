library(data.table)
library(mice)
library(glmnet)
library(MASS)
library(xgboost)
library(caret)

# remove ID colmn from data
test_data<-fread("./project/volume/data/raw/Stat_380_test.csv")
test_data<-subset(test_data, select = -c(Id))
train_data<-fread("./project/volume/data/raw/Stat_380_train.csv")
train_data <- subset(train_data, select = -c(Id))

#impute missing values, using all parameters as default values
# Note this process will take some time
timputed_data <- mice(train_data, m=5, maxit = 50, method = 'pmm', seed = 500)
new_train_data<-data.table(complete(timputed_data))
imputed_data <- mice(test_data, m=5, maxit = 50, method = 'pmm', seed = 500)
new_test_data<-data.table(complete(imputed_data))

fwrite(new_train_data,"./project/volume/data/interim/new_train_data.csv")
fwrite(new_test_data,"./project/volume/data/interim/new_test_data.csv")