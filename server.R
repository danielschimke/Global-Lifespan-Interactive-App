library(shiny)
library(shinydashboard)
library(datasets)
library(tidyverse)
library(ggplot2)


server <- function(input, output) {
  
  #Display simple life expectancy data
  lifeData <- data.frame(read.csv("life-expectancy.csv"))
  
  output$lifeChart <- renderPlot({
    ggplot(lifeData) +
      geom_line(aes(x=Year, y=Life.expectancy..years., fill=Entity))
  })
}