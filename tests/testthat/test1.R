test_that("is file there?", {
  file=dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv")
  expect_type(file, "list")
  expect_equal(dim(file), c(290441,7))
  expect_named(file, c("FIPS_Code", "State",     "Area_name", "state",     "Attribute", "year" ,     "Value"  ) )
  expect_equal(min(file$year), 2000)
  expect_equal(max(file$year), 2020)
  expect_equal(unique(file$State),c( "US", "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC",
                             "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA",
                             "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV",
                             "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA",
                             "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV",
                             "WI", "WY", "PR") )
})

test_that("is map there?",{
  library(usmap)
  map<-us_map("counties")
  file=dataclean("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.csv")
  expect_equal(dim(map),c(55211,   10))
  expect_named(map,c( "x",  "y" ,     "order" , "hole" ,  "piece",  "group" , "fips" ,  "abbr" ,  "full" ,  "county"))
  expect_equal(length(c("US",unique(map$abbr),"PR")),length(unique(file$State)))
  expect_equal(c("US",unique(map$abbr),"PR"),unique(file$State))
})
