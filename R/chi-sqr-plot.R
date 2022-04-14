#' Caculating and visualizing the correlation between two variables
#' @param dataset targeted data
#' @return  interactive correlation grah
#' @export
#' @examples
#' chi_pic(dataset)
#' @author Lin Quan
#' @import psych
#' @import reshape2
#' @import ggplot2
#' @import plotly
chi_pic <- function(dataset){

  col=dim(dataset)[2]

  get_chimat <- function(dataset){
    col=dim(dataset)[2]
    chimat=matrix(1:col^2, nrow = col, ncol = col)
    for (i in 1:col){
      for (j in 1:col){
        if(dim(table(dataset[,i])) == 2 & dim(table(dataset[,j])) == 2){
          temp <-table(dataset[,i], dataset[,j])
          chimat[i,j]=phi(temp, digits = 3)
        }else {
          chimat[i,j]=round(cor(dataset[,i], dataset[,j], method = "pearson"),3)
        }
      }
    }
    return(chimat)
  }

  chimat=get_chimat(dataset)

  get_upper_tri <- function(chimat){
    chimat[lower.tri(chimat)]<- NA
    return(chimat)
  }

  upper_tri=get_upper_tri(chimat)
  diag(upper_tri)=NA
  colnames(upper_tri)=colnames(dataset)
  rownames(upper_tri)=colnames(dataset)


  melted_ut=melt(upper_tri, na.rm = T)


  temp_plot <-ggplot(data = melted_ut, aes(x=Var1, y=Var2, fill=value,text = paste(
                                                                                   'variable1: ', Var1,
                                                                                   '<br>variable2: ', Var2,
                                                                                   '<br>correlation: ', value))) + geom_tile() +
    geom_text(aes(Var1, Var2, label = value), color = "white", size = 2.5) +
    labs(title="") +
    theme(
      axis.text.x = element_text(angle = 90),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      axis.text = element_text(size=10),
      axis.title = element_text(size=10),
      panel.grid.major = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      axis.ticks = element_blank(),
      legend.position = "right",
      legend.direction = "vertical")+
    guides(fill = guide_colorbar(barwidth = 1, barheight = 7,
                                 title.position = "top", title.hjust = 0.3))
  ggplotly(temp_plot, tooltip = "text")

}
