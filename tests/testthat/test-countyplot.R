test_that("output is a ggplot2 plot", {
  file=dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv")
  p <- stateunemployed(file, 2012,"IA")

  expect_s3_class(p, "ggplot")
})
