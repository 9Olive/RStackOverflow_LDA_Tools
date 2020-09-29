library(tidyverse)
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