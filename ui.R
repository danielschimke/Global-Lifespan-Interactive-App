

  
ui <- dashboardPage(
    dashboardHeader(title = "Country Data Analysis"),
    dashboardSidebar(
      sidebarMenu(id = "sidebar",
        menuItem("Main", tabName = "life", icon = icon("heartbeat")),
        menuItem("Add Entry", tabName = "newEntry", icon = icon("file")),
        conditionalPanel(
          condition = "input.sidebar == 'life'",
          style = "position:fixed;width:inherit;",
          selectInput("changeX", label = "X Axis:",
                      choices = axisSelect, 
                      width = 210),
          selectInput("changeY", label = "Y Axis:", 
                      choices = axisSelect, 
                      width = 210),
          actionButton("clearEntity", label = "Clear All")
        )
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "life",

          h2("Historical Statistical Analysis"),
          h4("Filter by Country/Entity:"),
          fluidRow(
            box(
              width = 2,
              selectInput("updateLifeChartA", label = "A", multiple = TRUE,
                               choices = unique(lifeData[grep("^A", lifeData$Entity),]$Entity),
                               selected = NULL)
            ),
            box(
              width = 2,
              selectInput("updateLifeChartB", label = "B", multiple = TRUE,
                                 choices = unique(lifeData[grep("^B", lifeData$Entity),]$Entity),
                                 selected = NULL)
            ),
            box(
              width = 2,
              selectInput("updateLifeChartC", label = "C", multiple = TRUE,
                                 choices = unique(lifeData[grep("^C", lifeData$Entity),]$Entity),
                                 selected = NULL)
            ),
            box(
              width = 2,
              selectInput("updateLifeChartDE", label = "D-E", multiple = TRUE,
                                 choices = unique(lifeData[grep("^D|^E", lifeData$Entity),]$Entity),
                                 selected = NULL)
            ),
            box(
              width = 2,
              selectInput("updateLifeChartFG", label = "F-G", multiple = TRUE,
                          choices = unique(lifeData[grep("^F|^G", lifeData$Entity),]$Entity),
                          selected = NULL)
            ),
            box(
              width = 2,
              selectInput("updateLifeChartHJ", label = "H-J", multiple = TRUE,
                          choices = unique(lifeData[grep("^H|^I|^J", lifeData$Entity),]$Entity),
                          selected = NULL)
            ),
          ),
          fluidRow(
            box(
              width = 2,
              selectInput("updateLifeChartKL", label = "K-L", multiple = TRUE,
                          choices = unique(lifeData[grep("^K|^L", lifeData$Entity),]$Entity),
                          selected = NULL)
            ),
            box(
              width = 2,
              selectInput("updateLifeChartM", label = "M", multiple = TRUE,
                          choices = unique(lifeData[grep("^M", lifeData$Entity),]$Entity),
                          selected = NULL)
            ),
            box(
              width = 2,
              selectInput("updateLifeChartNO", label = "N-O", multiple = TRUE,
                          choices = unique(lifeData[grep("^N|^O", lifeData$Entity),]$Entity),
                          selected = NULL)
            ),
            box(
              width = 2,
              selectInput("updateLifeChartPR", label = "P-R", multiple = TRUE,
                          choices = unique(lifeData[grep("^P|^Q|^R", lifeData$Entity),]$Entity),
                          selected = NULL)
            ),
            box(
              width = 2,
              selectInput("updateLifeChartS", label = "S", multiple = TRUE,
                          choices = unique(lifeData[grep("^S", lifeData$Entity),]$Entity),
                          selected = NULL)
            ),
            box(
              width = 2,
              selectInput("updateLifeChartTZ", label = "T-Z", multiple = TRUE,
                          choices = unique(lifeData[grep("^T|^U|^V|^W|^X|^Y|^Z", lifeData$Entity),]$Entity),
                          selected = NULL)
            ),
          ),

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