library(shiny)
library(shinydashboard)
library(readr)
library(dplyr)
library(dbplyr)

shinyUI(
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