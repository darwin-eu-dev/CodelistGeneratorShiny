

#### UI -----
ui <-  fluidPage(theme = shinytheme("spacelab"),
                 
# title ------ 
# shown across tabs
titlePanel("OMOP CDM candidate codelist generator"),
                 
# set up: pages along the side -----  
                 navlistPanel(
   
                   
                   
                   
## Results pages ------ 
tabPanel("Search strategy",
         tags$h4("Keywords"),
         textAreaInput("Keywords", 
                       tags$h5("Words to search for (separate with ´;´).",
                               "For example, a search for ", 
                               tags$em("Knee osteoarthritis; hip osteoarthritis; arthroplasty"),
                 " would search for these three alterative sets of keywords."), rows = 3),
         tags$h4("Exclude"),
         textAreaInput("exclude", 
                       tags$h5("Words to exclude (separate with ´;´)",
                               "For example, ", 
                               tags$em("due to trauma"),
                 " would search for and exclude codes with this single set of words to exclude."), rows = 3),
         
                  tags$h4("Include descendants"),
         checkboxInput("include.descendants", 
                       label = "Include any descendants of identified concepts",
                       value = TRUE),
         
                  tags$h4("Include ancestor"),
         checkboxInput("include.ancestor", 
                       label = "Include the direct ancestor of identified concepts",
                       value = FALSE),
         
         tags$h4("Search synonyms"),
         checkboxInput("search.synonyms", 
                       label = "Also search via concept synonym table (note, this can increase run-time considerably)",
                       value = FALSE),
         tags$h4("Use fuzzy matching"),
         checkboxInput("fuzzy.match", 
                       label = "Also search for approximate matches (based on generalized Levenshtein edit distance)",
                       value = FALSE),
        # tags$h4("Maximum distance for fuzzy matching"),
         numericInput("fuzzy.match.max.distance", 
                      label = tags$h5("If using maximum distance, 
                      maximum distance allowed for a match",
                       tags$a("(see here for more details)",
        href="https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/agrep",
        target="_blank")),
                        value = 0.1, step = 0.1 ),
       
# tags$h4("Domains"),
# pickerInput(inputId = "domains",
#   label = "Domains of OMOP CDM to include",
#   choices =c("Condition", "Drug", "Device", "Observation", "Procedure"),
#   selected = c("Condition"),
#   options = list(`actions-box` = TRUE,
#     size = 10,`selected-text-format` = "count > 3"), multiple = TRUE),
         tags$hr()
),
    tabPanel("Output",
      tabsetPanel(
        id = "tabset",
        
        tabPanel("Candidate codelist",
           tags$hr(),
           withSpinner(DTOutput('tbl')),
           tags$hr(),
        downloadBttn("downloadCodelist",
              size="xs",
               label = "Download")),
        
        tabPanel("Explore mappings to standard codes in codelist", 
                 # tags$h4("Vocabulary"),
                 tags$hr(),
pickerInput(inputId = "source.codes",
  label = tags$h5("Only include codes with mappings from "),
  choices =c("ICD10CM",
             "ICD9CM",  
             "Read",
             "SNOMED"),
  selected = "ICD10CM",
  options = list(`actions-box` = TRUE,
    size = 10,`selected-text-format` = "count > 3"), multiple = TRUE) ,
   actionBttn("button", "Get mappings for selected vocabularies",
                 style = "unite",
              size="xs",
                color ="royal"),
tags$hr(),
            withSpinner(DTOutput('tbl.source')),
         downloadBttn("downloadCodelistMappings",
              size="xs",
                label = "Download")
)
      )
    )
))

