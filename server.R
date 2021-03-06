library(shiny)
library(shinydashboard)
library(readr)
library(dplyr)
library(dbplyr)

run_query <- function(query) {
  require(dbplyr)
  require(RPostgres)
  require(DBI)
  conn_host 	<- '35.194.80.242'
  conn_dbname <- 'text-data'
  conn_user 	<- 'postgres'
  conn_port 	<- '5432'
  conn_pw     <- 'vdztVxOwJ^6B'
  con   <- dbConnect(Postgres(), dbname = conn_dbname, host = conn_host, port = conn_port, user = conn_user, password = conn_pw)
  query_result <- dbGetQuery(con, query)
  dbDisconnect(con)
  return(query_result)
}

ctm <- read_csv(url("https://drive.google.com/uc?id=1rUWKfmq9FT6OkZhtVwTOQV9YgIIx8Pag"), col_types = 'iDiciiiiiddddd')

shinyServer(function(input, output) {
  
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