test_that("is map there?",{
  library(usmap)
  map<-us_map("counties")
  file=dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv")
  expect_equal(dim(map),c(55211,   10))
  expect_named(map,c( "x",  "y" ,     "order" , "hole" ,  "piece",  "group" , "fips" ,  "abbr" ,  "full" ,  "county"))
  expect_equal(length(c("US",unique(map$abbr),"PR")),length(unique(file$State)))
  expect_equal(c("US",unique(map$abbr),"PR"),unique(file$State))
})
