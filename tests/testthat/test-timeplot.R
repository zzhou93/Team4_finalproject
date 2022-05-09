test_that("output is a ggplot2 plot", {
  file=dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv")
  p <- plotunemployed_time(file, "IA")

  expect_s3_class(p, "ggplot")
})
