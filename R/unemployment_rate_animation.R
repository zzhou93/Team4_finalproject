#' Provide animation plot of the unemployment rate in county level for a specific state
#' @param file the file path.
#' @param State.name the chosen state.
#' @return a gif figure
#' @export
#' @examples
#' file=dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv")
#'
#' plotunemployed_animation(file, "NJ")
#' @author Xiaolan Wan
#' @import sf usmap gifski tibble
#' @importFrom stats median setNames
#' @importFrom gganimate transition_states animate gifski_renderer
#' @importFrom transformr tween_sf
#'
#'
plotunemployed_animation <- function(file, State.name)
{
  # summarize unemployment
  database <- file %>% filter(Attribute == "Unemployment_rate_") %>%
    filter(State == State.name) %>% filter(FIPS_Code %% 1000 != 0) %>%
    arrange(Area_name)


  database <- database %>%
    mutate(level = cut(Value, breaks = c(0, 3, 5, 7, 9, 100), labels = c("VeryLow", "Low", "Medium", "High", "VeryHigh")))

  colorvalues <- c("VeryHigh" = "#ed4747", "High" = "#ffada2", "Medium" = "#cccccc", "Low" = "#67b5e3", "VeryLow" = "#1155b6")
  # get map data
  rawd <- us_map("counties") %>% filter(abbr == State.name)
  if(!State.name %in% c("AK"))
    rawd$county <- substr(rawd$county, 1, nchar(rawd$county) - 7)
  rawd$group <- rawd$county
  d <- rawd %>% arrange(group)

  if(State.name == "AK")
  {
    tmp <- database %>% filter(Area_name == "Valdez-Cordova Census Area")
    for(year in 2000:2020)
    {
      database <- database %>% add_row(FIPS_Code = 2063, State = "AK", Area_name = "Chugach Census Area",
                                       state = "AK", Attribute = database$Attribute[1],
                                       year = year, Value = tmp$Value[year - 1999]) %>%
        add_row(FIPS_Code = 2066, State = "AK", Area_name = "Copper River Census Area",
                state = "AK", Attribute = database$Attribute[1], year = year, Value = tmp$Value[year - 1999])
      if(year < 2010)
      {
        database <- database %>% add_row(FIPS_Code = 2015, State = "AK", Area_name = "Hoonah-Angoon Census Area",
                                         state = "AK", Attribute = database$Attribute[1], year = year, Value = NA) %>%
          add_row(FIPS_Code = 2195, State = "AK", Area_name = "Petersburg Census Area",
                  state = "AK", Attribute = database$Attribute[1], year = year, Value = NA)
      }
    }
    database <- database %>% filter(Area_name != "Valdez-Cordova Census Area")

  }

  if(State.name == "HI")
  {
    for(year in 2000:2020)
      database <- database %>% add_row(FIPS_Code = 5005, State = "HI", Area_name = "Kalawao County",
                                       state = "HI", year = year, Attribute = database$Attribute[1], Value = NA)
  }

  database <- database %>% arrange(year, Area_name)

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

  spdata  <- st_sfc(USS, crs = usmap_crs()@projargs)
  tmp <- data.frame()
  for(yr in 2000:2020)
  {
    tmp <- rbind(tmp, st_sf(data.frame(database %>% filter(year == yr), geometry = spdata)))
  }
  tmp$centroids <- st_centroid(tmp$geometry)

  tmp <- cbind(tmp, do.call(rbind, st_geometry(tmp$centroids)) %>%
                 as_tibble() %>% setNames(c("lon","lat")))

  originplot = ggplot() +
    geom_sf(aes(fill = level, alpha = 0.4), color = "white",  data = tmp) +
    scale_fill_manual(values = colorvalues, guide = guide_none()) +
    theme_void() + theme(legend.position='none', plot.title = element_text(hjust = 0.5))

  animateplot = originplot +
    geom_text(aes(y = lat, x = lon, label = Value),
              colour = "black", size = 4.5, data = tmp) +
    geom_text(data = tmp,
              aes(x = median(lon), y = min(lat) - abs(max(lat) - min(lat))/4,
                  label = paste("UR In", State.name, "In", year)),
              colour = "black", size = 5) +
    transition_states(states = year)

  animate(animateplot, renderer = gifski_renderer(), fps = 5, duration = 10)
}
