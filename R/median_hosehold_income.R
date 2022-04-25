#' Plot the median house hold income in county level for a specific state in 2019
#' @param file the file path.
#' @param yr 2019.
#' @param State.name the chosen state.
#' @return a ggplot figure
#' @export
#' @examples
#' file=dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv")
#'
#' plot_medianhouseholdincome(file, 2019, "NJ")
#' @author Lin Quan
#' @import tidyverse
#' @import sf
#' @import usmap
#'
plot_medianhouseholdincome <- function(file, yr=2019, State.name)
{
  # summarize unemployment
  if(State.name %in% as.character(levels(as.factor(file$State))) & yr == 2019){
    database <- file %>% filter(Attribute == "Median_Household_Income_") %>%
      filter(State == State.name) %>% filter(year==yr) %>% "["(-1,) %>%
      arrange(Area_name)
  } else if(!State.name %in% as.character(levels(as.factor(file$State))))
  {
    print("Error! Not a state!")
    return()
  }
  database <- database %>%
    mutate(level = cut(Value, breaks = c(0,24000, 40000, 53000, 70000, 150000), labels = c("VeryLow", "Low", "Medium", "High", "VeryHigh")))

  colorvalues <- c("VeryHigh" = "#ed4747", "High" = "#ffada2", "Medium" = "#cccccc", "Low" = "#67b5e3", "VeryLow" = "#1155b6")
  # get map data
  d <- us_map("counties") %>% filter(abbr == State.name)
  if(!State.name %in% c("AK"))
    d$county <- substr(d$county, 1, nchar(d$county) - 7)
  d$group <- d$county
  d <- d %>% arrange(group)

  if(State.name == "AK")
  {
    tmp <- database %>% filter(Area_name == "Valdez-Cordova Census Area")
    database <- database %>% add_row(FIPS_Code = 2063, State = "AK", Area_name = "Chugach Census Area",
                                     state = "AK", Attribute = database$Attribute[1], Value = tmp$Value) %>%
      add_row(FIPS_Code = 2066, State = "AK", Area_name = "Copper River Census Area",
              state = "AK", Attribute = database$Attribute[1], Value = tmp$Value) %>%
      filter(Area_name != "Valdez-Cordova Census Area")
  }
   else if(State.name == "HI")
  {
    database <- database %>% add_row(FIPS_Code = 5005, State = "HI", Area_name = "Kalawao County",
                                     state = "HI", Attribute = database$Attribute[1], Value = NA)

  }

  database <- database %>% arrange()

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
    geom_sf_text(aes(label = Value, geometry = centroids), colour = "black", size = 3.5, data = tmp) +
    scale_fill_manual(values = colorvalues, guide = guide_none()) +
    ggtitle(paste("Median household income in", State.name, "In 2019")) +
    theme_void() + theme(legend.position='none', plot.title = element_text(hjust = 0.5))
}






