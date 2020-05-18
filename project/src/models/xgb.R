library(data.table)
library(mice)
library(glmnet)
library(MASS)
library(xgboost)
library(caret)

test_raw<-fread("./project/volume/data/raw/Stat_380_test.csv")
test<-fread("./project/volume/data/interim/new_test_data.csv")
train<-fread("./project/volume/data/interim/new_train_data.csv")


#xgboost
y.train<-train$SalePrice
test$SalePrice<-0
y.test<-test$SalePrice

# work with dummies

dummies <- dummyVars(SalePrice~ ., data = train)
x.train<-predict(dummies, newdata = train)
x.test<-predict(dummies, newdata = test)




dtrain <- xgb.DMatrix(x.train,label=y.train,missing=NA)
dtest <- xgb.DMatrix(x.test,label=y.test,missing=NA)

# Use cross validation 

param <- list(objective= "reg:linear",gamma=0.015,booster= "gbtree",
                eval_metric= "rmse",eta=0.05,
                max_depth= 10,subsample=0.9,
                colsample_bytree= 0.9,tree_method = 'hist')


XGBm<-xgb.cv( params=param,nfold=5,nrounds=100,missing=NA,data=dtrain,print_every_n=1)

# fit the model
watchlist <- list(eval = dtest, train = dtrain)
#fit the full model
XGBm<-xgb.train( params=param,nrounds=100,missing=NA,data=dtrain,watchlist,early_stop_round=20,print_every_n=1)
SalePrice<-predict(XGBm, newdata=dtest)
submission<-data.table(SalePrice)
submission$Id<-test_raw$Id
submission<-submission[,.(Id,SalePrice)]
fwrite(submission,"./project/volume/data/processed/xgb.csv")
