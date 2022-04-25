#' read csv file from USDA site and clean up.
#' @param file the file path.
#' @param local.name the chosen state.
#' @return unemployment rate by year
#' @export
#' @examples
#' localunemployrate(file, "Texas")
#' @author Zirou Zhou
#' @import tidyverse
localunemployrate<-function(file,local.name){
  file<-file%>%filter(is.na(state))
  if (!local.name %in% as.character(levels(as.factor(file$Area_name)))) {
      print("Error! Not a state!")
    return()
  }else if(local.name %in% as.character(levels(as.factor(file$Area_name)))){
      data <- file%>% filter(	Attribute=="Unemployment_rate_")%>%
        filter(Area_name %in% c(local.name,"United States"))
      data%>%
        ggplot(aes(year,Value,color=Area_name))+geom_point()  +geom_line()+
        scale_color_discrete("Select state vs US")+
        xlab(paste("year"))+ylab("Unemployment rate")+
        ggtitle(paste("Unemployment rate of",local.name,"vs the Whole nation, from 2000-2020"))
    }

  }

