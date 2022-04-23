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
  if (State.name %in% as.character(levels(as.factor(file$State)))){
    database <- file%>% filter(Attribute=="Unemployed_")%>%
      filter(State==State.name)%>%filter(year==yr)%>% filter(!is.na(state))%>%
      mutate(percent=round(100*Value/sum(Value),2))%>%
      mutate(county_percent=paste(Area_name,percent,"%"))%>%
      arrange(desc(Value))%>%slice(1:10)
  }else  {print("Not a state")}
}

