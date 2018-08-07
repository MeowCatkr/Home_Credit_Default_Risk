#source('Func/AllFunctions.R')
######
application_train=read.csv('Data/application_train.csv')
bureau=read.csv('Data/bureau.csv')
bureau_balance=read.csv('Data/bureau_balance.csv')
credit_card_balance=read.csv('Data/credit_card_balance.csv')
installments_payments=read.csv('Data/installments_payments.csv')




View(head(credit_card_balance,1000))
dim(bureau_balance)
summary(applicationTrain)
unique(bureau$CREDIT_CURRENCY)


applicationTrain$TARGET = as.factor(applicationTrain$TARGET)
applicationTrain$CNT_CHILDREN = as.factor(applicationTrain$CNT_CHILDREN)








biasColumns=getBiasVariables(applicationTrain) 
# outof 122 columns 38 are biased. 
#Including target variable

#visualize(applicationTrain)




###################################################
########### INITIAL MODEL #########################
###################################################



########### Decision Tree #########################
library(caTools)
set.seed(100)
split = sample.split(applicationTrain$TARGET, SplitRatio = 0.5)
train = subset(applicationTrain, split == TRUE)
test = subset(applicationTrain, split == FALSE)


library(rpart)
library(rpart.plot)
regressor = rpart(formula = train$TARGET~.,
                data = train,
                control = rpart.control(minsplit = 1))
summary(regressor)
regressor
rpart.plot(regressor)
result=predict(regressor,test)
View(cbind(result,test$TARGET))







































