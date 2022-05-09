#' Shiny example
#' @return a dashboard
#' @export
#' @import shiny
#' @author Lin Quan
runExample <- function() {
  appDir <- system.file("shiny-examples", "myapp",
                        package = "unemployedR")
  if (appDir == "") {
    stop(paste0("Could not find example directory. ",
                "Try re-installing `unemployedR`."), call. = FALSE)
  }
  # the first app will be called
  runApp(appDir[1], display.mode = "normal")
}
