library(shiny)
library(shinythemes)
library(shinydashboard)
library(unemployedR)
library(plotly)

file = dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv")%>%
  filter(!State %in% c("PR"))

StateList <- unique(file$State) %>% sort()
StateList<-StateList[-which(StateList=="DC")]
YearList <- unique(file$year) %>% sort()
#AreaList <- unique(file$Area_name) %>% sort()

shinyUI(navbarPage(theme=shinytheme("flatly"), collapsible=TRUE,
                   "", id="nav",
                   # First tab
                   tabPanel("Spatial",
                            div(class="outer",
                                tags$head(includeCSS("styles.css")),
                                plotOutput("first",
                                           width="80%", height="70%"),
                                absolutePanel(id="controls", class="panel panel-default",
                                              top=80, left=5, width=200, fixed=TRUE,
                                              draggable=TRUE, height="auto",
                                              selectInput("state",
                                                          label=h5("Select one state:"),
                                                          choices = c(StateList), selected = "IA"
                                              ), # end of selectInput1 for state
                                              selectInput("year",
                                                          label=h5("Select one year"),
                                                          choices = c(YearList)
                                              ), # end of selectInput

                                              tags$i(h5("The panel is draggable"), style = "color:#FF9933")
                                              ),
                                absolutePanel(id = "insert", class = "panel panel-default",
                                              top = 740, left = 5, width = 700, fixed=TRUE,
                                              draggable = TRUE, height = 500, style = "opacity: 0.9",

                                              plotOutput("insert", width="100%", height="100%")
                                )


                            ) # end of div
                          ),
                   tabPanel("Temporal",
                            div(class="outer",
                                tags$head(includeCSS("styles.css")),
                                plotlyOutput("Second",
                                           width="80%", height="80%"),
                                absolutePanel(id="controls", class="panel panel-default",
                                              top=80, left=5, width=200, fixed=TRUE,
                                              draggable=TRUE, height="auto",
                                              selectInput("Area",
                                                          label=h5("Select one state:"),
                                                          choices = c(StateList), selected = "IA"
                                              ), # end of selectInput1 for place

                                              tags$i(h5("The panel is draggable"), style = "color:#FF9933")
                                ),
                                absolutePanel(id = "insert2", class = "panel panel-default",
                                              top = 540, left = 5, width = 500, fixed=TRUE,
                                              draggable = TRUE, height = 300, style = "opacity: 0.9",
                                              selectInput("year2",
                                                          label=h5("Select one year"),
                                                          choices = c(YearList)
                                              ),

                                              plotlyOutput("insert2", height="170px", width="100%")
                                )


                            ) # end of div
                   )
))
