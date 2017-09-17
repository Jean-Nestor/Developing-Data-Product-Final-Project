library(shiny)
library(caret)
library(rpart.plot)
library(ggplot2)
library(dplyr)
library(C50)
library(e1071)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Telecommunication Churn Prediction Using Logical Regression Model"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      helpText(strong("Predicting Churn: using Logical Regression Model to classify
               customers, pin-point customers who are in risk to churn. 
               This is based on the CS50 data for churn as part. This package
               can be installed on the R Library and it is part 
               of the c50 package.")),
      
      h3(strong("Instructions: to be read")),
      
      p("1. One model is built: Logical Regression Model is used, the user to choose between
        Doing Cross Validation or not. Only 1 option should be ticked"), 
      p("2. The model shows the decision tree as part of the algorithm on the main panel of the 
        application for both rpart and cross-validated rpart"),
      p("3. The summary of the predicted value is shown on the slidepanel, 
        with var1=Categorization & Freq=Number of Classified customers"),
      
      h3(strong("App. Menu: Choose one")),
    
       checkboxInput("LPART", "Apply Logical Regression model with trees to predict churn", value = TRUE),
       checkboxInput("LDA", "Apply Logical Regression with Trees, with Cross-Validation", value = FALSE),
      
      sliderInput("kfolds",
                  "Use Cross Validation To build the Model, Choose K-Fold:",
                  min = 5,
                  max = 30,
                  value = 10),
      
      h4("The K-Folds used value is:", align="center"),
      textOutput("distPlot"),
      
      h3("Predicted Classification"), 
      tableOutput("pred1"),
      
      h3(strong("Further Reading")),
      
      tags$div(class="header", checked=NA,
               tags$p("To view the Presentation slide in R, "),
               tags$a(href="shttp://rpubs.com/jeannestd/Developing-Data-Product-Course-Project", "Click Here!"))
      
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      
      h3("Buidling & Applying Prediction Models", style="color:blue"),
      h4("Regression Model: Trees Result"),
      p(strong("Note that the application can take up to 5 seconds to load the results. 
               due to the size of the data. Please be patient")),
      plotOutput("rtree"),
      textOutput("rpartp"),
       
      h3("Exploring Relationships between Calls made for All customers"),
      h4("Taking into consideration churned and non-churned customers"),
      p(""),
      p("The EDA is splitted in Multiple tabs, to show different relationships
        between predictors in the dataset, and can helpp in defining
        pattern of information. the first 3 tabls are self explanatory, 
        EDA=Relation between different calls", style="color:blue"),
      p(""),
      
      tabsetPanel(type="tabs",
                  tabPanel("State_Distribution", br(), plotOutput("statedis")),
                  tabPanel("Int_Plan", br(), plotOutput("intplan")),
                  tabPanel("voice_mail_plan", br(), plotOutput("vmplan")),
                  tabPanel("EDA_A", br(), plotOutput("callplot1")),
                  tabPanel("EDA_B", br(), plotOutput("callplot2")),
                  tabPanel("EDA_C", br(), plotOutput("callplot3"))
                  )
       
      
    )
  )
))
