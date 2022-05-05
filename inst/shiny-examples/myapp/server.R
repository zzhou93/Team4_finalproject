

library(tidyverse)


library(unemployedR)

library(plotly)

file = dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv") %>%
  filter(!State %in% c("PR"))






##################################

shinyServer(function(input, output) {

  ##### first for spatial
  output$first <- renderPlot({
    plotunemployed(file, input$year, input$state)
  })

  ##### first for insert
  output$insert <- renderPlot({
    if(input$year == 2019){
      plotmedianhouseholdincome(file, input$state)
    }
    else {
      empty_plot <- function(title = NULL){
        p <- plotly_empty(type = "scatter", mode = "markers") %>%
          config(
            displayModeBar = FALSE
          ) %>%
          layout(
            title = list(
              text = title,
              yref = "paper",
              y = 0.5
            )
          )
        return(p)
      }
      empty_plot("")}
  })

  ##### second for temporal
  output$Second <- renderPlotly({
    temp_plot<-plotunemployed_time(file,input$Area)
    ggplotly(temp_plot,tooltip = "text")
  })
  ##### second for insert
  output$insert2 <- renderPlotly({

    temp_plot2<-stateunemployed(file, input$year2, input$Area)
    ggplotly(temp_plot2,tooltip = "text")

  })

})

