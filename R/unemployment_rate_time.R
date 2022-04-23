#' Plot the unemployment rate along with years
#' @param file the file path.
#' @param local.name the chosen local.
#' @return a ggplot figure
#' @export
#' @examples
#' file=dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv")
#'
#' plotunemployed_time(file, "Texas")
#' @author Lin Quan
#' @import tidyverse plotly
#'
#'
plotunemployed_time <- function(file, local.name){
  # summarize unemployment
  if (local.name %in% as.character(levels(as.factor(file$Area_name)))) {
    database <- file %>%
      filter(Area_name %in%  c(local.name,"United States"))%>%filter(is.na(state)) %>%
      spread(Attribute,Value)


  } else if(!local.name %in% as.character(levels(as.factor(file$State))))
  {
    print("Error! Not a state!")
    return()
  }
  ## umployment along with year
  temp_plot <- database %>% ggplot(aes(year,Unemployment_rate_,group=1,text = paste('Area: ', State,
                                                               '<br>Year: ', year,
                                                               '<br>Employment: ', Employed_,
                                                                '<br>Unemployment: ', Unemployed_,
                                                                '<br>Unemployment rate: ', Unemployment_rate_,"%"),color=Area_name))+
               geom_point()+geom_line() +
    theme(
          plot.title = element_text(size = 18, face = "bold"),
          axis.text = element_text(size = 9))+ scale_color_discrete(paste0(database$Area_name[30]," vs US"))
  ### plotly
  ggplotly(temp_plot,tooltip = "text") %>%
    layout(title = list(text = paste0("Unemployment rate in ",database$Area_name[30])),
           xaxis = list(title="Year"), yaxis = list(title="Unemployment rate"),
           margin=list(t=-10))
}



