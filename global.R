#### PACKAGES -----
library(shiny)
library(shinythemes)
library(here)
library(readr)
library(RSQLite)
library(DBI)
library(dbplyr)
library(dplyr)
library(stringr)
library(checkmate)
library(DT)
library(shinycssloaders)
library(shinyWidgets)
library(dtplyr)
library(CodelistGenerator)


# data ----
db <- dbConnect(RSQLite::SQLite(), here::here("data", "db.sqlite"))
