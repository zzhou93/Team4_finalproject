#' read csv file from USDA site and clean up.
#' @param url the csv file path.
#' @return cleaned data.
#' @export
#' @examples
#' dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv")
#' @author Zirou Zhou
#' @import tidyverse tidyr
dataclean<- function(url){
file=read.csv(url)
file<-separate(file,Attribute,c("Attribute","year"),sep = -4)
file<-separate(file,Area_name,c("Area_name","state"),sep = ",")
file$Area_name <- gsub(" County","", file$Area_name)
file$year=as.numeric(file$year)
return(file)
}


