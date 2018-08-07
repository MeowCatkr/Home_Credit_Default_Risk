# A function that returns the variable which has skew/bias value. 
# i.e. perticular value is repeated in 80% of train data
# trainData : pass the train dataset
# returns : the name of columns that needs to drop.
getBiasVariables = function(trainData,cutoff=0.8)
{
  totalRecords=nrow(trainData)
  biasResult = data.frame(ColumnName=NULL,Value=NULL,Bias=NULL)
  for (varName in names(trainData)) {
    
    freqTable = table(trainData[varName])
    maxValue=max(freqTable)
    maxName=names(freqTable[which.max(freqTable)])
    if(maxValue/totalRecords>=cutoff)
    {
      biasResult=rbind(biasResult,data.frame(ColumnName=varName,Value=maxName,Bias=maxValue/totalRecords))
    }
  }
  biasResult
}



visualize <- function(filedata){
  
  all_factor <- sapply(filedata,is.factor)
  all_factor_columns <-names(all_factor[all_factor==TRUE])
  
  for (i in 1:length(all_factor_columns)){
    column_data <-filedata[,c(all_factor_columns[i])]
    lbls <-round(table(column_data)/ sum(table(column_data))*100,2)
    pie(table(column_data),labels = paste(names(lbls) ,'-',lbls),main=all_factor_columns[i])
    readline(prompt="Press [enter] to continue")
  }
  
  all_continous <- sapply(filedata,is.numeric)
  all_continous_columns <- names(all_continous[all_continous==TRUE])
  
  for (j in 1:length(all_continous_columns)){
    
    boxplot(filedata[,c(all_continous_columns[j])],main=all_continous_columns[j])
    summary(filedata$age)
    readline(prompt = "Press [enter] to continue")
    
    hist(filedata[,c(all_continous_columns[j])],main=all_continous_columns[j])
    readline(prompt = "Press [enter] to continue")
  }
  
}

# ------------------ Required Functions -------------




# A function that drops variables/columns from dataset
# dataset : pass the object of dataframe
# colNamesToRemove : pass the vector of characters
# returns : the dataset with droped vaiables
dropVariables=function(dataset,colNamesToRemove)
{
  for (variable in colNamesToRemove) {
    dataset[variable] = NULL
  }
  dataset
}

# A function that replace NA value with provided value
# dataset : pass the object of dataframe
# colNames : pass the column names
# value : replacement for NA
# returns : dataset with replaced NA values
replaceNAValues = function(dataset,colNames,value)
{
  for (varName in names(dataset)) {
    if(varName %in% colNames)
    {
      if(is.factor(dataset[,varName])) # need to do this. OW it will throw the error
      {
        levels(dataset[,varName]) = c(levels(dataset[,varName]),value)
        levels(dataset[,varName]) = c(levels(dataset[,varName]),value)
      }
      dataset[,varName][(is.na(dataset[,varName]))] <- value
    }
  }
  dataset
}


factorEligebleColumns=function(dataset)
{
  result = data.frame(ColumnName=NULL,Count=NULL,Values=NULL)
  for(column in colnames(dataset))
  {
    if(class(dataset[,column])!='factor'){
      cnt=length(unique(dataset[,column]))
      if(cnt<=2)
      {
        values=(unique(dataset[,column]))
        valStr=''
        for(v in values)
        {
          valStr=paste(valStr,v )
        }
        result=rbind(result,data.frame(ColumnName=column,Count=cnt,Values=valStr))
      }
      
    }
  }
  result
}

covertToFactors=function(dataset,columnList)
{
  for (col in columnList) {
    dataset[,col] = as.factor(dataset[,col])
  }
  dataset
}

