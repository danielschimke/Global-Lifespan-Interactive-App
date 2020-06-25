library(shiny)
library(shinydashboard)
library(datasets)
library(tidyverse)
library(ggplot2)
library(DBI)

dataAccess <- "data.db"
con <- dbConnect(drv = RSQLite::SQLite(), dbname = dataAccess)
lifeData <- dbReadTable(con, "mergedTable")

fixCamelCase <- function(givenString){
  return(str_to_title(gsub("(\\D)(\\d)", "\\1 \\2", gsub("([[:lower:]])([[:upper:]])", "\\1 \\2", givenString))))
}

axisSelect <- colnames(lifeData[,!colnames(lifeData) %in% c("Entity","Code")])
names(axisSelect) <- fixCamelCase(colnames(lifeData[,!colnames(lifeData) %in% c("Entity","Code")]))
