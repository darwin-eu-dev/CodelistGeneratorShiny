#### SERVER ------
server <-	function(input, output, session) {
  
  get.tbl<-reactive({
        
    validate(need(input$Keywords!="", 
                "No keywords entered"))
    
   working.Keywords<- unlist(strsplit(input$Keywords,";"))
   
   if(!is.null(input$exclude)){
     working.exclude<- unlist(strsplit(input$exclude,";"))
   } else {
     working.exclude<-NULL
   }
   

 
    if(!is.null(input$non_standard.codes)){
     working.non_standard.codes<- input$non_standard.codes
   } else {
     working.non_standard.codes<-NULL
   }
   
  
getCandidateCodes(
  keywords=c(working.Keywords),
  conceptClassId = NULL, 
  standardConcept = "Standard",
  domains = "Condition", #input$domains,
  searchSynonyms = input$search.synonyms,
  searchNonStandard = FALSE,
  fuzzyMatch = input$fuzzy.match,
  maxDistanceCost = input$fuzzy.match.max.distance,
  exclude = working.exclude, 
  includeDescendants = input$include.descendants,
  includeAncestor = input$include.ancestor,
  verbose = TRUE, 
  db=db,
  vocabularyDatabaseSchema = vocabSchema
)

  }) 
  
  
  output$tbl<-  renderDataTable({

  table<-get.tbl() 
  
  validate(need(ncol(table)>1, 
                "No results for selected inputs"))
  
   datatable(table,rownames= FALSE, extensions = 'Buttons',
    options = list( buttons = list(list(extend = "excel", 
                                        text = "Download table as excel",
                                        filename = "CandidateCodelist.csv"))
                            ))
   
   
    } )
  
  output$downloadCodelist <- downloadHandler(
  filename = function() {
    paste0("CandidateCodes", ".csv")
  },
  content = function(file) {
    write.csv( get.tbl()   , file, row.names =FALSE) 
  }
)
  
# ntext <- eventReactive(input$goButton, {
#     input$non_standard.codes
#   })
  

 get.tbl.non_standard<-eventReactive(input$button, {
     table<-get.tbl()


    validate(need(nrow(table)>0,
                "No candidate codes"))
    validate(need(input$non_standard.codes!="",
                "No vocabulary selected"))


   showMappings(table ,
                 nonStandardVocabularies=input$non_standard.codes,
  db=db,
  vocabularyDatabaseSchema = vocabSchema)


})
 
  output$tbl.non_standard<-    renderDataTable({
   
  table<-get.tbl.non_standard()

  validate(need(ncol(table)>1,
                "No results for selected inputs"))

   datatable(table,rownames= FALSE, extensions = 'Buttons',
    options = list( buttons = list(list(extend = "excel",
                                        text = "Download table as excel",
                                        filename = "CandidateCodelistMappings.csv"))
                            ))


    } )


   output$downloadCodelistMappings <- downloadHandler(
  filename = function() {
    paste0("CandidateCodelistMappings", ".csv")
  },
  content = function(file) {
    write.csv( get.tbl.non_standard()   , file, row.names =FALSE)
  }
)

    
}





