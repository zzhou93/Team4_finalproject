#' read csv file from USDA site and clean up.
#' @param file the file path.
#' @param yr the select year.
#' @param State.name the chosen state.
#' @return top 10 unemployed county histogram
#' @export
#' @examples
#' stateunemployed(file, 2011, "IA")
#' @author Zirou Zhou
#' @import tidyverse
stateunemployed<-function(file, yr, State.name){
  if (yr %in% as.numeric(levels(as.factor(file$year)))){

  if (State.name %in% as.character(levels(as.factor(file$State)))){
    database <- file%>% filter(Attribute=="Unemployed_")%>%
      filter(State==State.name)%>%filter(year==yr)%>% filter(!is.na(state))%>%
      mutate(percent=round(100*Value/sum(Value),2))%>%
      mutate(county_percent=paste(Area_name,percent,"%"))%>%
      arrange(desc(Value))%>%slice(1:10)
    database%>%
      ggplot(aes(x=Area_name,y=Value,fill=county_percent))+geom_col()+
      scale_fill_discrete("Percent of Population")+
      xlab(paste("Top 10 County of Chosen State"))+ylab("Population")
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
