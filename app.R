library(shiny)
library(shinydashboard)
library(readr)
library(dplyr)

source('Connection.R')

# Loads a local table of results from a correlated dirichlet allocation classifcation
ctm <- read_csv("Ref_Tbls/ctm_cats.csv", col_types = 'iDiciiiiiddddd')

ui <- shinyUI(
  fluidPage(
    fluidRow(
      
      # A container for the results of the correlated dirichlet allocation or ctm r object
      box(
        width = 12,
        title = 'Category Results:',
        DT::dataTableOutput('cat_tbl_id')
      )
    ),
    fluidRow(
      
      # A container for the question associated with the stackoverflow question selected
      box(
        title = "Question: ",
        htmlOutput('que_txt_id')
      ),
      
      # A conatiner for the answer associated with the stackoverflow question selected
      box(
        title = "Answer: ",
        htmlOutput('ans_txt_id')
      )
    )
  )
)

server <- shinyServer(function(input, output) {
  
  # Specifying the data table for the ctm results
  output$cat_tbl_id <- DT::renderDataTable(
    DT::datatable(
      ctm, selection = 'single',
      filter = 'top'
    )
  )
  
  # 
  output$ans_txt_id <- renderUI({
    s = input$cat_tbl_id_rows_selected
    if (length(s)) {
  
      # For local repository
      # ans_txt <- read_csv("Ref_Tbls/Answers_ctm.csv", 
      #                     skip = s, 
      #                     n_max = 1,
      #                     col_names = c("Id", "OwnerUserId", "CreationDate", 
      #                                   "ParentId", "Score", "IsAcceptedAnswer", "Body")) %>% 
      
      ans_txt <- as_tibble(run_query(paste0('SELECT * FROM answers WHERE question_id = ', ctm$ID[s]))) %>%
        # pull(Body) # for local repo
        pull(body) # for sql 
      HTML(ans_txt)
    } else {
      HTML("<p> Select row from Preview Table to view corresponding Answer </p>")
    }
  })
  
  output$que_txt_id <- renderUI({
    s = input$cat_tbl_id_rows_selected
    if (length(s)) {
      
      # que_txt <- read_csv("Ref_Tbls/Questions_ctm.csv", 
      #                     skip = s, 
      #                     n_max = 1,
      #                     col_names = c("Id", "OwnerUserId", "CreationDate", 
      #                                   "Score" ,"Title", "Body" )) %>% 
      
      que_txt <- as_tibble(run_query(paste0('SELECT * FROM questions WHERE id = ', ctm$ID[s]))) %>%
        # pull(Body) # for local repo
        pull(body)
      HTML(que_txt)
    } else {
      HTML("<p> Select row from Preview Table to view corresponding Question. </p>")
    }
  })
  
})

shinyApp(ui = ui, server = server)