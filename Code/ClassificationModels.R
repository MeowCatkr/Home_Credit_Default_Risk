setwd('/Users/shitalkat/Workstation/GitHub/Home_Credit_Default_Risk')

source('SharedCode/AllFunctions.R')
ds=read.csv('Data/application_train_vars_new.csv')


########## N Samples ##########

biasColumns=getBiasVariables(ds) 
biasColumns

t=getNSamplesFromPopulation(ds,'TARGET')
min(t)
getNSamplesFromPopulation= function(populationDataset,targetVarName, sampleNos = 1)
{
  frequencyTable=table(populationDataset[targetVarName])
  return(frequencyTable)
}

fold=CreditBureauTarget.target1=CreditBureauTarget[CreditBureauTarget$TARGET==1,] #20368
CreditBureauTarget.target0=CreditBureauTarget[CreditBureauTarget$TARGET==0,] 
fold=rbind.data.frame(fold,head(CreditBureauTarget,20368))


table(ds['TARGET'])


########## Decision Tree ##########




library(rpart)
library(rpart.plot)
regressor = rpart(formula = ds$TARGET~.,
                  data = ds,
                  method='class',
                  control = rpart.control(minsplit = 2))
summary(regressor)
regressor
rpart.plot(regressor)
result=predict(regressor,fold,type = 'class')
mergeResult=(cbind.data.frame(result,fold$TARGET))

table(mergeResult)


########## Model Evaluation Measures ##########
