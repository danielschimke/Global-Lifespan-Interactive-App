library(shiny)
library(shinydashboard)
library(datasets)
library(tidyverse)
library(ggplot2)


server <- function(input, output) {
  
  lifeData <- data.frame(read.csv("life-expectancy.csv"))
  #Display simple life expectancy data
  newLifeData <- reactive({
    req(input$updateLifeChart)
    lifeData %>% filter(Entity %in% input$updateLifeChart)
  })
  output$lifeChart <- renderPlot({
    ggplot(newLifeData()) +
      geom_line(aes(x=Year, y=Life.expectancy..years., color=Entity))
  })
}