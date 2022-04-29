#' Shiny example
#' @return a dashboard
#' @export
#' @import shiny
runExample <- function() {
  appDir <- system.file("shiny-examples", "myapp",
                        package = "finalproject")
  if (appDir == "") {
    stop(paste0("Could not find example directory. ",
                "Try re-installing `finalproject`."), call. = FALSE)
  }
  # the first app will be called
  runApp(appDir[1], display.mode = "normal")
}
