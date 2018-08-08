setwd('/Users/shitalkat/Workstation/GitHub/Home_Credit_Default_Risk')

source('/Users/shitalkat/Workstation/GitHub/CC/AllFunctions.R')
ds=read.csv('Data/application_train_vars_new.csv')

########## Required PreProcessing ##########
ds$ORGANIZATION_TYPE=NULL
ds$TARGET=as.factor(sample1$TARGET)

########## Train-Test Split ##########

library(caTools)
set.seed(100)
split = sample.split(ds$TARGET, SplitRatio = 0.7)
train = subset(ds, split == TRUE)
test = subset(ds, split == FALSE)

########## Oversampling Samples ##########
library(ROSE)
table(train$TARGET)
dim(ds)
train <- ovun.sample(TARGET~.,data = train,method = "over",N=(197880*2))$data

########## Random Forest ##########

model=RunModel_RandomForest(train,'TARGET',20)
result=Predict_RandomForest(model,test)

result=(cbind.data.frame(result,test$TARGET))
ModelEvalMeasure_classification(table(result))




