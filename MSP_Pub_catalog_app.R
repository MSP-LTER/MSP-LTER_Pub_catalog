library(shiny)
library(RefManageR)
library(bibtex) #I don't think I actually used this package but I can't remember and now am afraid to remove it...
library(DT)
library(shinythemes)
library(stringr)

MSP<- ReadZotero(user = "your Zotero user ID", .params=list(key = "access key", collection='Zotero collection key',tag=c('MSP_LTER'))) #MSP_dataset for the data catalog
#I got the collection key by examining the html of my Zotero collection page
MSP_df <- as.data.frame(MSP)

headerImagePanel <- function(title, src) {
  div(
    style = "display: inline; position: relative",
    img(
      src = src, 
      style="width:100%; max-width:100%; position: absolute; z-index:-1;"
    ),
    h1(title, style="display: inline;")
  )
}
# Define UI for application 
ui <- fluidPage(
  theme = shinytheme("united"),
  # Application title
  titlePanel(title="MSP LTER Research Catalog"),
  
  mainPanel(
    DT::dataTableOutput('x1'),
    DT::dataTableOutput('x2'),
    verbatimTextOutput('x3')
  )
  
)

# Define server logic 
server <- function(input, output, session) {
  MSP_df2 <- MSP_df[,c('title','author','url','doi')]
  rownames(MSP_df2)<-NULL
  
  MSP_df2$url <- sapply(MSP_df2$url, function(x) 
    toString(tags$a(href= x,"go to link", target="_blank")))
  MSP_df2$title <- stringr::str_replace_all(MSP_df2$title, "[^[:alnum:]]", " ")
  MSP_df2$author <- stringr::str_replace_all(MSP_df2$author, "[^[:alnum:]]", " ")
  reactive({ 
    # search feature
    s = selectizeInput$x1_search(session, choices = MSP_df2, options = list(create = TRUE), server = TRUE)
    txt = if (is.null(s) || s == '') 'Filtered data' else {
      sprintf('Data matching "%s"', s)
      
    }
    
    
  })
  
  
  output$x2 = DT::renderDataTable(MSP_df2, server = TRUE, escape=FALSE)
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
