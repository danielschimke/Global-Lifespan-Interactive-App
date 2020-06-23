library(shiny)
library(shinydashboard)
library(datasets)
library(tidyverse)
library(ggplot2)
library(DBI)

#lifeData <- data.frame(read.csv("life-expectancy.csv"))

dataAccess <- "data.db"
  con <- dbConnect(drv = RSQLite::SQLite(), dbname = dataAccess)
  lifeData <- dbReadTable(con, "mergedTable")
  dbDisconnect(con)
  
#  df <- lifeData[grep("^A", lifeData$Entity),]
  
ui <- dashboardPage(
    dashboardHeader(title = "Fun with databases"),
    dashboardSidebar(
      sidebarMenu(id = "sidebar",
        menuItem("Life Expectancy", tabName = "life", icon = icon("heartbeat")),
        menuItem("Add Entry", tabName = "newEntry", icon = icon("file")),
        conditionalPanel(
          condition = "input.sidebar == 'life'",
          style = "position:fixed;width:inherit;",
          selectInput("changeX", label = "X Axis:", 
                      choices = colnames(lifeData[,!colnames(lifeData) %in% c("Entity","Code")]), 
                      width = 210),
          selectInput("changeY", label = "Y Axis:", 
                      choices = colnames(lifeData[,!colnames(lifeData) %in% c("Entity","Code")]), 
                      width = 210)
        )
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "life",

          checkboxGroupInput("updateLifeChart", label = "Filter by Country:",
                             choices = unique(lifeData[grep("^A", lifeData$Entity),]$Entity),
                             selected = NULL, inline = TRUE),
          plotOutput("inputGraph"),
          plotOutput("GDPvLifeExpectancy"),
          plotOutput("lifeChart"),
          plotOutput("heatmap"),
          plotOutput("suicideVchildMortality")
        ),
        tabItem(tabName = "newEntry",
          h3("Add a new entry to the database"),
          selectInput("newEntity", label = "Entity:", choices = unique(lifeData$Entity)),
          selectInput("newCode", label = "Code:", choices = NULL),
          textInput("newYear", label = "Year:", placeholder = "####"),
          textInput("newExpectancy", label = "Life Expectancy:", placeholder = "Enter a number in years..."),
          textInput("newChildMortality", label = "Child Mortality Rate:", placeholder = "Ex. 56 for 56%"),
          actionButton("submitNewEntry", label = "Submit"),
          textOutput("submitMessage")
        )
      )
    )

)

shinyUI(ui)