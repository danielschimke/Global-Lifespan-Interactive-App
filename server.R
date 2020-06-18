library(shiny)
library(shinydashboard)
library(datasets)
library(tidyverse)
library(ggplot2)


server <- function(input, output) {
  
#  lifeData <- data.frame(read.csv("life-expectancy.csv"))
  dataAccess <- "data.db"
  con <- dbConnect(drv = RSQLite::SQLite(), dbname = dataAccess)
  lifeData <- dbReadTable(con, "Merged Table")
  dbDisconnect(con)
  
  #Display simple life expectancy data
  newLifeData <- reactive({
    req(input$updateLifeChart)
    lifeData %>% filter(Entity %in% input$updateLifeChart)
  })
  output$lifeChart <- renderPlot({
    ggplot(newLifeData()) +
      geom_line(aes(x=Year, y=lifeExpectancy, color=Entity))
  })
  
  #Update the database with a new entry
  observeEvent(input$submitNewEntry, {
    if(as.numeric(input$newExpectancy) >= 0 && as.numeric(input$newExpectancy) <= 124){
      output$submitMessage <- renderText({"Submission added"})
      lifeData <- add_row(lifeData, Entity = input$newEntity, Year = as.numeric(input$newYear), Code = input$newCode,
              lifeExpectancy = as.numeric(input$newExpectancy), childMortality = as.numeric(input$newChildMortality))
      
      dataUpdate <- "data.db"
      con <- dbConnect(drv = RSQLite::SQLite(), dbname = dataUpdate)
      dbWriteTable(con, "Merged Table", lifeData, overwrite = TRUE)
      dbDisconnect(con)
    }else{
      output$submitMessage <- renderText({"Error: Enter a valid life expectancy"})
    }
    
  })
}