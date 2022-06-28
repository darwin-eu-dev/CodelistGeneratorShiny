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
   

 
    if(!is.null(input$source.codes)){
     working.source.codes<- input$source.codes
   } else {
     working.source.codes<-NULL
   }
   
  
get_candidate_codes(
  keywords=c(working.Keywords),
  domains = "Condition", #input$domains,
  search_synonyms = input$search.synonyms,
  fuzzy_match = input$fuzzy.match,
  max_distance_cost = input$fuzzy.match.max.distance,
  exclude = working.exclude, 
  include_descendants = input$include.descendants,
  include_ancestor = input$include.ancestor,
  db=db,
  vocabulary_database_schema = "main"
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
#     input$source.codes
#   })
  

 get.tbl.source<-eventReactive(input$button, {
     table<-get.tbl()


    validate(need(nrow(table)>0,
                "No candidate codes"))
    validate(need(input$source.codes!="",
                "No vocabulary selected"))


   show_mappings(table ,
                 source_vocabularies=input$source.codes,
  db=db,
  vocabulary_database_schema = "main")


})
 
  output$tbl.source<-    renderDataTable({
   
  table<-get.tbl.source()

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
    write.csv( get.tbl.source()   , file, row.names =FALSE)
  }
)

    
}





