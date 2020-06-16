library(shiny)
library(shinydashboard)
library(datasets)
library(tidyverse)
library(ggplot2)

ui <- dashboardPage(
    dashboardHeader(title = "Fun with databases"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Life Expectancy", tabName = "life", icon = icon("heartbeat"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "life",

          checkboxGroupInput("updateLifeChart", label = "Filter by Country:",
                             choices = unique(lifeData$Entity),
                             selected = NULL, inline = TRUE),
          plotOutput("lifeChart")        
        )
      )
    )

)

shinyUI(ui)