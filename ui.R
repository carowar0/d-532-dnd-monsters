### UI file for D&D 5e Monsters Database 
### By Caro Lee

library(DBI)
library(RSQLite)
library(shiny)
library(bslib)
library(stringr)

conn <- dbConnect(RSQLite::SQLite(), dbname = "monsters.db")
data <- dbGetQuery(conn, "SELECT * FROM monsters") 

##### Customizing UI
navbarPage("",
  ##### 0. All pages
  theme = bs_theme(bootswatch = "morph"),
  
  ##### 1. Home 
  tabPanel("Home",
  fluidPage(
    titlePanel(HTML("<center><b>D&D 5e Monster Database</b></center>")),
    HTML('<center><img src="monsters.png", height="88%", width="88%"></center>'),
    fluidRow(
      includeHTML("intro.html")
    )
  )), 
  
  ##### 2. Database
  tabPanel("Database",
  fluidPage(
    titlePanel(HTML("<b>Database</b>")),
    sidebarLayout(
      sidebarPanel(width=2,
        radioButtons("dataSubset", label = "Data Subset:",
          choices = list("All Data" = 1, "URL Available" = 2, "Stats Available" = 3), selected = 1), 
        checkboxGroupInput("selectedCols", "Columns to show:",
          choices=names(data), selected = names(data)),
        submitButton("Load"), 
      ),
      mainPanel(
        DT::dataTableOutput("table")
      )
    )
  ),
  ),
  
  ##### 3. Card Creator
  tabPanel("Monster Info Sheet",
  fluidPage(
    titlePanel(HTML("<b>Monster Info Sheet</b>")),
    sidebarLayout(sidebarPanel(
      selectInput("monsterName", label = "Choose your monster:", 
        choices = data$name, 
        selected = data$name[1]),
      checkboxGroupInput("sheetChoices", "Include:",
        choices=list("Attributes" = 1, "Encounter Type" = 2, "Combat Stats" = 3, "References" = 4), selected = c(1,2,3,4)),
      # radioButtons("customization", label = "Additional options:",
      #   choices = list("Option 1" = 1, "Option 2" = 2, "Option 3" = 3), selected = 1),
      submitButton("Generate"), 
    ),
    mainPanel(
      tags$h3(textOutput("monsterName")),
      uiOutput("monsterAttrs"), tags$br(),
      uiOutput("encounterType"), tags$br(),
      tableOutput("monsterCombat"), tags$br(),
      uiOutput("monsterRefs")
    ))  
  )
  ),
  
  ##### 4. Resources
  tabPanel("Resources",
  fluidPage(
    titlePanel(HTML("<b>Resources</b>")),
    uiOutput("links")  
  )
  )
)