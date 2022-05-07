#' Plot the unemployment rate in county level for a specific state and a year
#' @param file the file path.
#' @param yr the select year.
#' @param State.name the chosen state.
#' @return a ggplot figure
#' @export
#' @examples
#' file=dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv")
#'
#' plotunemployed(file, 2018, "NJ")
#' @author Xiaolan Wan
#' @import dplyr tidyr ggplot2 sf usmap datasets
#' @import sf usmap dplyr ggplot2
#'
#'
plotunemployed <- function(file, yr, State.name)
{
  # summarize unemployment
  if(State.name %in% state.abb & yr <= 2020 & yr >= 2000){
    database <- file %>% dplyr::filter(Attribute == "Unemployment_rate_") %>%
      dplyr::filter(State == State.name) %>% dplyr::filter(year==yr) %>% "["(-1,) %>%
      arrange(Area_name)
  } else if(!State.name %in% state.abb)
  {
    print("Error! Not a state!")
    return()
  } else if(yr < 2000 | yr > 2020)
  {
    print("Error! Year beyond the ranage, the input should in [2000, 2020]")
    return()
  }

  database <- database %>%
    mutate(level = cut(Value, breaks = c(0, 2, 4, 6, 8, 100), labels = c("VeryLow", "Low", "Medium", "High", "VeryHigh")))

  colorvalues <- c("VeryHigh" = "#ed4747", "High" = "#ffada2", "Medium" = "#cccccc", "Low" = "#67b5e3", "VeryLow" = "#1155b6",
                   "None" = "#150F0F")
  # get map data
  d <- us_map("counties") %>% dplyr::filter(abbr == State.name)
  if(!State.name %in% c("AK"))
    d$county <- substr(d$county, 1, nchar(d$county) - 7)
  d$group <- d$county
  d <- d %>% arrange(group)

  if(State.name == "AK")
  {
    tmp <- database %>% dplyr::filter(Area_name == "Valdez-Cordova Census Area")
    database <- database %>%
      add_row(FIPS_Code = NA, State = rep("AK", 2),
              Area_name = c("Chugach Census Area", "Copper River Census Area"),
              state = "AK", Attribute = rep(database$Attribute[1], 2),
              year = rep(yr, 2), Value = NA, level = "None") %>%
      dplyr::filter(Area_name != "Valdez-Cordova Census Area")
  }
  if(State.name == "AK" & yr < 2010)
  {
    database <- database %>%
      add_row(FIPS_Code = NA, State = rep("AK", 2),  year = yr,
              Area_name = c("Hoonah-Angoon Census Area","Petersburg Census Area"),
              state = rep("AK", 2), Attribute = rep(database$Attribute[1], 2),
              Value = NA, level = rep("None", 2))
  } else if(State.name == "HI")
  {
    database <- database %>%
      add_row(FIPS_Code = 5005, State = "HI", Area_name = "Kalawao County", year = yr,
              state = "HI", Attribute = database$Attribute[1], Value = NA,level = "None")
  } else if(State.name == "LA" & yr %in% 2005:2006)
  {
    database <- database %>%
      add_row(FIPS_Code = NA, State = rep("LA", 7), year = rep(yr, 7), state = rep("LA", 7),
              Area_name = c("Jefferson", "Orleans", "Plaquemines", "St. Bernard",
                            "St. Helena", "St. John the Baptist","St. Tammany"),
              Attribute = rep(database$Attribute[1], 7),
              Value = NA, level = "None")
  }

  database <- database %>% arrange(Area_name)

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
    geom_sf_text(aes(label = Value, geometry = centroids), colour = "black", size = 4.5, data = tmp) +
    scale_fill_manual(values = colorvalues, guide = guide_none()) +
    ggtitle(paste("Unemployment rate in", State.name, "in year", yr)) +
    theme_void() + theme(legend.position='none', plot.title = element_text(hjust = 0.5,size = 18, face = "bold"))
}


