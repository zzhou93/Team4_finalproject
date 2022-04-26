library(shiny)
library(shinydashboard)
library(DT)
library(tidyverse)
library(sf)
library(stringr)
library(usmap)



files.sources = paste("R/", list.files("R/"), sep = "")
sapply(files.sources, source)

file = dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv") %>%
  filter(!State %in% c("US", "PR"))

StateList <- unique(file$State) %>% sort()
YearList <- unique(file$year) %>% sort()

# plotunemployed(file, 2018, "NJ")
# plotunemployed_time(file, "Texas")

ui <- fluidPage(

  # App title ----
  titlePanel("Unemployment Rate in United States"),

  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(
      fluidRow(
        column(width = 8,
               selectInput("spstate_select", "Select one state:",
                           choices = StateList, selected = "IA")),
        column(width = 12,
               uiOutput("year_select_UI")),
        column(width = 12,
               uiOutput("county_select_UI"))
      )
    ),
    # Main panel for displaying outputs ----
    mainPanel(
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs", id = "tabname",
                  tabPanel("Spatial", value = "sp",
                           plotOutput("plot_spatial", width = "100%")
                  ),    # end Spatial here

                  tabPanel("Temporal", value = "tm",

                  )  # end Temporal here

      )
    )
  )
)

server <- function(input, output) {

  # start from here:
  output$county_select_UI <- renderUI({
    selectInput("county_select", "Select counties (multiple):",
                if(sampledt$tabname == "sp")
                {
                  "Whole State"
                } else
                {
                  file %>% filter(State == input$spstate_select) %>%
                    dplyr::select(Area_name) %>% unlist() %>% unique()
                }, selected = if(sampledt$tabname == "sp"){"Whole State"}else{NULL},
                multiple = T)
  })

  output$year_select_UI <- renderUI({
    selectInput("spyear_select", "Select one year:",
                if(sampledt$tabname == "sp") {
                  YearList
                } else {
                  "ALL Years"
                })
  })
  sampledt = reactiveValues(spdt = data.frame(),
                            tabname = NULL,
                            spstate = NULL,
                            spyear = NULL)
  observe({
    sampledt$spstate = input$spstate_select
    sampledt$spdt = file %>% filter(State == sampledt$spstate)
    sampledt$spyear = input$spyear_select
    sampledt$tabname = input$tabname
  })

  output$plot_spatial <- renderPlot({
    plotunemployed(sampledt$spdt, sampledt$spyear, sampledt$spstate)
  })


}

# Run the application
shinyApp(ui = ui, server = server)


