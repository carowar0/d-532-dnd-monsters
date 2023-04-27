### Server file for D&D 5e Monsters Database
### By Caro Lee 

library(DBI)
library(RSQLite)
library(shiny)
library(stringr)

conn <- dbConnect(RSQLite::SQLite(), dbname = "monsters.db")
data <- dbGetQuery(conn, "SELECT * FROM monsters") 
# dbListTables(conn)

function(input, output, session){
  ##### 1. Home
  
  ##### 2. Database
  output$table <- DT::renderDataTable({
    if (input$dataSubset == 2) {
      data <- dbGetQuery(conn, "SELECT * FROM url_available_view") 
    }
    else if (input$dataSubset == 3) {
      data <- dbGetQuery(conn, "SELECT * FROM complete_stats_view") 
    }
    else {
      data 
    }
    DT::datatable(data[, input$selectedCols, drop = FALSE])
  })
  
  ##### 3. Card Creator
  ### Capturing all the inputs 
  monster <- reactive({input$monsterName}) # monster name
  choices <- reactive({input$sheetChoices}) # sheet choices 
  # customOptions <- reactive({input$customization}) # customization options
  
  ### Data frame with all relevant info
  monsterStats <- reactive({data[data$name==print(monster()),]})
  
  ### Attributes = 1
  output$monsterAttrs <- renderUI({
    if (1 %in% choices()){
      HTML(paste0("<b>Type:</b> ",monsterStats()[,4]," (",monsterStats()[,5],") ",br(),
                  "<b>Movement:</b> ", ifelse(monsterStats()[,9]==1, "can","cannot"), " swim; ",
                                       ifelse(monsterStats()[,10]==1, "can","cannot"), " fly"))
    } 
  })
  
  ### Encounter Type = 2
  output$encounterType <- renderUI({
    if (2 %in% choices()){
      HTML(paste0("<b>Challenge rating:</b> ",monsterStats()[,3],br(),
                  "<b>Size:</b> ",monsterStats()[,6],br(),
                  "<b>Alignment:</b> ",monsterStats()[,11],br(),
                  "<b>Legendary:</b> ", ifelse(monsterStats()[,12]==1, "yes","no")))
    } 
  })
  
  ### Combat stats = 3
  output$monsterCombat <- renderTable({
    if (3 %in% choices()){
      monsterStats()[,c(7,8,14:19)]
    }
  }, bordered=T)
  
  ### References = 4 
  output$monsterRefs <- renderUI({
    if (4 %in% choices()){
      HTML(paste0("<b>URL:</b> ",monsterStats()[,2],br(),"<b>Source:</b> ",monsterStats()[,13]))
    } 
  })
  
  output$monsterName <- renderText({str_to_upper(print(monster()))})
  output$monsterStatsTable <- renderTable(monsterStats())
  
  ##### 4. Resources
  url1 <- a("dndbeyond.com:", href="https://www.dndbeyond.com/")
  url2 <- a("roll20.net:", href="https://roll20.net/")
  url3 <- a("AidedDD.org:", href="PLACEHOLDER")
  url4 <- a("DnD 5e Dataset:", href="PLACEHOLDER")
  
  output$links <- renderUI({
    tagList(
      h4("These are some useful resources for those who want to learn more about D&D and its mechanics:"), 
      url1, "An official D&D resource website published by Wizards of the Coast. It has tools like online rule books, digital character sheets, and so on." , br(),
      url2, "A website where people can play their D&D campaigns online through a virtual tabletop platform. Also includes information on monsters, spells, and etc.", br(),
      url3, "The reference website where the data originates from.", br(),
      url4, "Where I originally found my data.", br(),
      )
  })
  
  ##### X. Disconnect
  session$onSessionEnded(function(){
    dbDisconnect(conn)
  })
}

