library(shiny)
library(shinydashboard)
library(datasets)
library(tidyverse)
library(ggplot2)


server <- function(input, output) {
  
#  lifeData <- data.frame(read.csv("life-expectancy.csv"))
  dataAccess <- "data.db"
  con <- dbConnect(drv = RSQLite::SQLite(), dbname = dataAccess)
  lifeData <- dbReadTable(con, "mergedTable")
  
  #Display simple life expectancy data
  newLifeData <- reactive({
    req(input$updateLifeChart)
    lifeData <- dbReadTable(con, "mergedTable")
    lifeData %>% filter(Entity %in% input$updateLifeChart)
  })
  output$lifeChart <- renderPlot({
    ggplot(newLifeData()) +
      geom_line(aes(x=Year, y=lifeExpectancy, color=Entity))
  })
  output$suicideVchildMortality <- renderPlot({
    ggplot(newLifeData()) +
      geom_line(aes(x=suicideRatePer100000, y=childMortality, color=Entity))
  })
  output$GDPvLifeExpectancy <- renderPlot({
    ggplot(newLifeData()) +
      geom_line(aes(x=GDPperCapita, y=lifeExpectancy, color=Entity))
  })
  output$inputGraph <- renderPlot({
    ggplot(newLifeData()) +
      geom_line(aes(x=newLifeData()[[input$changeX]], y=newLifeData()[[input$changeY]], color=Entity)) +
      xlab(input$changeX) + ylab(input$changeY)
  })

  #Update the database with a new entry
  observeEvent(input$submitNewEntry, {
    if(!is.na(as.numeric(input$newExpectancy)) && !is.na(as.numeric(input$newChildMortality))){
      if(as.numeric(input$newExpectancy) >= 0 && as.numeric(input$newExpectancy) <= 124){
        if(as.numeric(input$newChildMortality) >= 0 && as.numeric(input$newChildMortality) <= 100){
          if(!is.na(as.numeric(input$newYear))){
            output$submitMessage <- renderText({"Submission added"})
            lifeData <- add_row(lifeData, Entity = input$newEntity, Year = as.numeric(input$newYear), Code = input$newCode,
                              lifeExpectancy = as.numeric(input$newExpectancy), childMortality = as.numeric(input$newChildMortality))
          
            dataUpdate <- "data.db"
            con <- dbConnect(drv = RSQLite::SQLite(), dbname = dataUpdate)
            dbWriteTable(con, "mergedTable", lifeData, overwrite = TRUE)
          }else{
            output$submitMessage <- renderText({"Error: Year must be a number"})
          }
        }else{
          output$submitMessage <- renderText({"Error: Enter a valid child mortality (0-100)"})
        }
      }else{
        output$submitMessage <- renderText({"Error: Enter a valid life expectancy (0-124)"})
      }
    }else{
      output$submitMessage <- renderText({"Error: Life expectancy and child mortality must be a number"})
    }
    
  })
  
  #Creates a heatmap with the data
  output$heatmap <- renderPlot({
    ggplot(newLifeData(), aes(Entity, Year)) + 
           geom_tile(aes(fill = lifeExpectancy), color = "white") + 
           scale_fill_gradient(low = "white", high = "steelblue")
  })
}