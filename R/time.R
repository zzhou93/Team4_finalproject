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
  if (local.name %in% as.character(levels(as.factor(file$Area_name)))) {
    data <- file%>% filter(	Attribute=="Unemployment_rate_")%>%
      filter(Area_name %in% c(local.name,"United States"))%>%filter(is.na(state))

  }else print("Not a suitable Area name")
}

