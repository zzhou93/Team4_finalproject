#' Plot top 10 unemployed county histogram in selected state and a year
#' @param file the file path.
#' @param yr the select year.
#' @param State.name the chosen state.
#' @return top 10 unemployed county histogram
#' @export
#' @examples
#' file=dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv")
#'
#' stateunemployed(file, 2011, "IA")
#' @author Zirou Zhou Lin Quan
#' @import dplyr forcats ggplot2


stateunemployed<-function(file, yr, State.name){
  if (yr %in% as.numeric(levels(as.factor(file$year)))){

  if (State.name %in% as.character(levels(as.factor(file$State)))){


    database <- file%>% filter(Attribute=="Unemployed_")%>%
      filter(State==State.name)%>%filter(year==yr)%>% filter(!is.na(state))%>%
      mutate(percent=round(100*Value/sum(Value),2))%>%
      mutate(county_percent=paste(Area_name,percent,"%"))%>%
      arrange(desc(Value))%>%slice(1:10)

  database%>%
      ggplot(aes(x=fct_reorder(Area_name, percent, .desc = TRUE),y=Value,fill=county_percent,text = paste('County: ', Area_name,
                                                                                                    '<br>Unemployment: ', Value,
                                                                                                    '<br>percentage: ', percent,"%")))+

      geom_bar(stat = "identity") +
      theme_minimal(base_size = 9.5) +
      xlab(paste("Top 10 county of chosen ctate"))+ylab("Unemployment population")+scale_fill_manual(values = c(rep("#9ecae1", 10))) +
      theme(legend.position = "none",
            plot.title = element_text(size = 10, face = "bold"),
            axis.text = element_text(size = 6),
            panel.grid.major = element_blank())+ggtitle(paste("Top 10 unemployed county in",State.name))

  # plotly::ggplotly(temp_plot,tooltip = "text")
  }else if(!State.name %in% as.character(levels(as.factor(file$State))))
  {
    print("Error! Not a state!")
    return()
  }
  }else if(!yr %in% as.numeric(levels(as.factor(file$year))))
  {
    print("Error! Not a valid year!")
    return()
  }


  }



