


setwd('..','/Users/shitalkat/Workstation/GitHub/Home_Credit_Default_Risk')
source('SharedCode/AllFunctions.R')

CreditBureauTarget=read.csv('Data/CreditBureauTarget.csv')





View(head(CreditBureauTarget,1000))
dim(CreditBureauTarget)
str(CreditBureauTarget)




biasColumns=getBiasVariables(CreditBureauTarget) 
biasColumns


###################################################
########### INITIAL MODEL #########################
###################################################


fold=CreditBureauTarget.target1=CreditBureauTarget[CreditBureauTarget$TARGET==1,] #20368
CreditBureauTarget.target0=CreditBureauTarget[CreditBureauTarget$TARGET==0,] 
fold=rbind.data.frame(fold,head(CreditBureauTarget,20368))



fold$sk_id_curr=NULL
fold$SK_ID_CURR=NULL


table(mergeResult)

########### Decision Tree #########################
library(caTools)
set.seed(100)
split = sample.split(applicationTrain$TARGET, SplitRatio = 0.5)
train = subset(applicationTrain, split == TRUE)
test = subset(applicationTrain, split == FALSE)


library(rpart)
library(rpart.plot)
regressor = rpart(formula = fold$TARGET~.,
                  data = fold,
                  method='class',
                  control = rpart.control(minsplit = 2))
summary(regressor)
regressor
rpart.plot(regressor)
result=predict(regressor,fold,type = 'class')
mergeResult=(cbind.data.frame(result,fold$TARGET))

table(mergeResult)

########## Random Forest ##########



install.packages('randomForest')
library(randomForest)
set.seed(123)
model = randomForest(fold$TARGET ~ ., 
                     data = fold ,
                     method='class',
                     importance = TRUE,
                     mtry = 6,
                     ntree = 20)

summary(model)
result=predict(model,fold,type = 'class')
mergeResult=(cbind.data.frame(result,fold$TARGET))

mergeResult['predict']=mergeResult$result>0.5
table(mergeResult[-1])




































