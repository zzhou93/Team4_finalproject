#' Plot the unemployment rate along with years
#' @param file the file path.
#' @param local.name the chosen local.
#' @return a ggplot figure
#' @export
#' @examples
#' file=dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv")
#'
#' plotunemployed_time(file, "Texas")
#' @author Lin Quan Zirou Zhou
#' @import tidyverse plotly
#'
#'
plotunemployed_time <- function(file, local.name){

  file<-file%>%filter(is.na(state))
  if (!local.name %in% as.character(levels(as.factor(file$Area_name)))) {
    print("Error! Not a state!")
    return()
  }else if(local.name %in% as.character(levels(as.factor(file$Area_name)))){
    database <- file%>%
      filter(Area_name %in% c(local.name,"United States"))%>%
      spread(Attribute,Value)

    temp_plot <- database %>% ggplot(aes(year,Unemployment_rate_,group=1,text = paste('Area: ', State,
                                                                                      '<br>Year: ', year,
                                                                                      '<br>Employment: ', Employed_,
                                                                                      '<br>Unemployment: ', Unemployed_,
                                                                                      '<br>Unemployment rate: ', Unemployment_rate_,"%"),color=Area_name))+
      geom_point()+geom_line() +
      theme(
        plot.title = element_text(size = 18, face = "bold"),
        axis.text = element_text(size = 9))+ scale_color_discrete(paste0(local.name," vs US"))+
      ggtitle(paste("Unemployment rate of",local.name,"vs the Whole nation"))
    ### plotly
    ggplotly(temp_plot,tooltip = "text") %>%
      layout(
             xaxis = list(title="Year"), yaxis = list(title="Unemployment rate (%)"),
             margin=list(t=-10))
  }

}



