#' Plot the median house hold income in county level for a specific state in 2019
#' @param file the file path.
#' @param yr 2019.
#' @param State.name the chosen state.
#' @return a ggplot figure
#' @export
#' @examples
#' file=dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv")
#'
#' plotunemployed(file, 2019, "NJ")
#' @author Lin Quan
#' @import tidyverse sf usmap
#'
#'
plot_medianhouseholdincome <- function(file, yr=2019, State.name)
{
  # summarize unemployment
  if(State.name %in% as.character(levels(as.factor(file$State))) & yr == 2019){
    database <- file %>% filter(Attribute == "Median_Household_Income_") %>%
      filter(State == State.name) %>% filter(year==yr) %>% filter(!is.na(state)) %>%
      mutate(percent=round(100*Value/sum(Value), 2)) %>%
      arrange(Area_name)
  } else if(!State.name %in% as.character(levels(as.factor(file$State))))
  {
    print("Error! Not a state!")
    return()
  }

  database <- database %>%
    mutate(level = cut(percent, breaks = c(0, 1, 3, 5, 8, 100), labels = c("VeryLow", "Low", "Medium", "High", "VeryHigh")))

  # get map data
  d <- us_map("counties") %>% filter(abbr == State.name)
  d$county <- substr(d$county, 1, nchar(d$county) - 7)
  d$group <- d$county
  d <- d %>% arrange(group)

  USS <- lapply(split(d, d$county), function(x) {
    if(length(table(x$piece)) == 1)
    {
      st_polygon(list(cbind(x$x, x$y)))
    }
    else
    {
      st_multipolygon(list(lapply(split(x, x$piece), function(y) cbind(y$x, y$y))))
    }
  })

  tmp  <- st_sfc(USS, crs = usmap_crs()@projargs)
  tmp  <- st_sf(data.frame(database, geometry = tmp))
  tmp$centroids <- st_centroid(tmp$geometry)

  ggplot() + geom_sf(data = tmp) +
    geom_sf(aes(fill = level, alpha = 0.4), color = "white",  data = tmp) +
    geom_sf_text(aes(label = percent, geometry = centroids), colour = "black", size = 4.5, data = tmp) +
    scale_fill_manual(values = c("#1155b6", "#67b5e3", "#cccccc", "#ffada2", "#ed4747"), guide = guide_none()) +
    theme_void() + theme(legend.position='none')
}



