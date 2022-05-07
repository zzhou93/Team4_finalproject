#' Plot the unemployment rate along with years
#' @param file the file path.
#' @param local.name the chosen area
#' @return a ggplot figure
#' @export
#' @examples
#' file=dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv")
#'
#' plotunemployed_time(file, "IA")
#' @author Lin Quan Zirou Zhou
#' @import tidyr ggplot2
#'
plotunemployed_time <- function(file, local.name){

  file<-file%>%filter(is.na(state))
  if (!local.name %in% as.character(levels(as.factor(file$State)))) {
    print("Error! Not a state!")
    return()
  }else if(local.name %in% as.character(levels(as.factor(file$State)))){
    database <- file%>%
      filter(State %in% c(local.name,"US"))%>%
      spread(Attribute,Value)
   # database$State<-as.factor(database$State)
    # temp_plot <-
     database %>% ggplot(aes(year,Unemployment_rate_,group=State,text = paste('State: ', State,
                                                                                         '<br>Year: ', year,
                                                                                         '<br>Employment: ', Employed_,
                                                                                         '<br>Unemployment: ', Unemployed_,
                                                                                         '<br>Unemployment rate: ', round(Unemployment_rate_,2),"%"),color=State))+
      geom_point()+geom_line() +
      theme(
        plot.title = element_text(size = 18, face = "bold"),
        axis.text = element_text(size = 9))+ scale_color_discrete(paste0(local.name," vs US"))+
      ggtitle(paste("Unemployment rate of",local.name,"vs the Whole nation"))+
      xlab(paste("Year"))+ylab("Unemployment rate")
    ### plotly
    #plotly::ggplotly(temp_plot,tooltip = "text")
  }

}



