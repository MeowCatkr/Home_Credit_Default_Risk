


setwd('/Users/shitalkat/Workstation/GitHub/Home_Credit_Default_Risk')
source('SharedCode/AllFunctions.R')

CreditBureauTarget=read.csv('Data/CreditBureauTarget.csv')





View(head(CreditBureauTarget,1000))
dim(CreditBureauTarget)





biasColumns=getBiasVariables(CreditBureauTarget) 
biasColumns
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







































