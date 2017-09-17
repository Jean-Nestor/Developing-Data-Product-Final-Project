
library(shiny)
library(caret)
library(rpart.plot)
library(ggplot2)
library(dplyr)
library(C50)
library(e1071)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  data(churn)
  str(churnTrain)
  str(churnTest)
  summary(churnTrain)
  
  
  output$distPlot <- renderText({
    
    output$distPlot=renderText(input$kfolds)
    
  })
  
  
  intplanchurn=table(churnTrain$churn, churnTrain$international_plan)
  
  output$intplan=renderPlot({
    barplot(intplanchurn, legend=rownames(intplanchurn), col = c("blue", "red"), 
            ylab = "Count", xlab = "International Plan",
            main = "Churn Ratio by International Plan")
  })
  
  vmchurn=table(churnTrain$churn, churnTrain$voice_mail_plan)
  
  output$vmplan=renderPlot({
    barplot(vmchurn, legend=rownames(vmchurn), col = c("blue", "red"), 
            ylab = "Count", xlab = "Voice mail plan",
            main = "Churn Ratio by Voice mail plan")
  })
  
  statedis_churn=table(churnTrain$churn, churnTrain$state)
  
  output$statedis=renderPlot({
    barplot(statedis_churn, legend=rownames(statedis_churn), col = c("blue", "red"),
            ylab = "Count", xlab = "State",
            main = "Churn Ratio by State")
  })

  
  output$callplot1=renderPlot({
    qplot(total_day_calls, total_eve_calls, colour=churn, data=churnTrain)
  })
  output$callplot2=renderPlot({
    qplot(total_eve_calls, total_night_calls, colour=churn, data=churnTrain)
  })
  output$callplot3=renderPlot({
    qplot(total_night_calls, total_day_calls, colour=churn, data=churnTrain)
  })
  
  pred=reactive({
    modFit=train(churn~., method="rpart", data=churnTrain)
    lpartpred=predict(modFit, newdata = churnTest)
  })
  
  predc=reactive({
    foldinput=input$kfolds
    folds=createFolds(y=churnTrain$churn, k=foldinput, list = TRUE, returnTrain = FALSE)
    trainfolds=churnTrain[folds$Fold01,]
    modFit_rpart_c=train(churn~., method="rpart", data=trainfolds)
    lpart_cross_pred=predict(modFit_rpart_c, newdata = churnTest)
  })
  
  conf=reactive({
    modFit=train(churn~., method="rpart", data=churnTrain)
    lpartpred=predict(modFit, newdata = churnTest)
    conf=confusionMatrix(lpartpred, churnTest$churn)
  })
  
  confcv=reactive({
    modFit_rpart_c=train(churn~., method="rpart", data=trainfolds)
    lpart_cross_pred=predict(modFit_rpart_c, newdata = churnTest)
    confusionMatrix(lpart_cross_pred, churnTest$churn)
  })
  
  
    output$rtree=renderPlot({
      if(input$LPART){
        modFit=train(churn~., method="rpart", data=churnTrain)
        plot(modFit$finalModel, uniform = TRUE, main="Classification Tree without Cross Validation")
        text(modFit$finalModel, use.n = TRUE, all = TRUE, cex.=8)
      }
      
      if(input$LDA){
        foldinput=input$kfolds
        folds=createFolds(y=churnTrain$churn, k=foldinput, list = TRUE, returnTrain = FALSE)
        trainfolds=churnTrain[folds$Fold01,]
        modFit_rpart_c=train(churn~., method="rpart", data=trainfolds)
        plot(modFit_rpart_c$finalModel, uniform = TRUE, main="Classification Tree with Cross Validation")
        text(modFit_rpart_c$finalModel, use.n = TRUE, all = TRUE, cex.=8)
      }
    })
    
    output$rpartp=renderPrint({
      
      if(input$LPART){
        print(conf())
        
      }
      else if (input$LDA){
        print(conf())
        
      }
      
    })
    
    output$pred1=renderTable({
      
      if(input$LDA){
        table(predc())
        
      }
      else if(input$LPART){
        table(pred())
        
      }
      
      
    })

  
})
