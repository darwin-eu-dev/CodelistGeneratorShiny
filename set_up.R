library(dplyr)
library(stringr)
library(readr)
library(DBI)

# remotes::install_github("darwin-eu/CodelistGenerator")
library(CodelistGenerator)

vocab.folder<-"E:/CdmVocab2" # directory of unzipped files
concept<-read_delim(paste0(vocab.folder,"/CONCEPT.csv"),
     "\t", escape_double = FALSE, trim_ws = TRUE)
concept_relationship<-read_delim(paste0(vocab.folder,"/CONCEPT_RELATIONSHIP.csv"),
     "\t", escape_double = FALSE, trim_ws = TRUE) %>%
  filter(relationship_id=="Mapped from")
concept_ancestor<-read_delim(paste0(vocab.folder,"/CONCEPT_ANCESTOR.csv"),
     "\t", escape_double = FALSE, trim_ws = TRUE)
concept_synonym<-read_delim(paste0(vocab.folder,"/CONCEPT_SYNONYM.csv"),
     "\t", escape_double = FALSE, trim_ws = TRUE)
vocabulary<-read_delim(paste0(vocab.folder,"/VOCABULARY.csv"),
     "\t", escape_double = FALSE, trim_ws = TRUE)

concept<-concept %>%
  filter(domain_id %in% "Condition")
concept_relationship<-concept_relationship  %>%
  inner_join(concept %>% select(concept_id) %>% 
               rename("concept_id_1"="concept_id"))
concept_ancestor1<-concept %>%
                select("concept_id") %>%
                rename("ancestor_concept_id"="concept_id") %>%
                inner_join(concept_ancestor,
                          by="ancestor_concept_id") 
concept_ancestor2<-concept %>%
                select("concept_id") %>%
                rename("descendant_concept_id"="concept_id") %>%
                inner_join(concept_ancestor,
                          by="descendant_concept_id") 
concept_ancestor<-bind_rows(concept_ancestor1,concept_ancestor2)
rm(concept_ancestor1,concept_ancestor2)
concept_synonym<-concept %>%
                select("concept_id") %>%
  inner_join(concept_synonym, by="concept_id") 

db <- dbConnect(RSQLite::SQLite(), here::here("data", "db.sqlite"))
dbWriteTable(db, "concept", concept)
dbWriteTable(db, "concept_relationship", concept_relationship)
dbWriteTable(db, "concept_ancestor", concept_ancestor)
dbWriteTable(db, "concept_synonym", concept_synonym)
dbWriteTable(db, "vocabulary", vocabulary)
rm(concept,concept_relationship, concept_ancestor, concept_synonym, vocabulary)
rm(list=ls())
