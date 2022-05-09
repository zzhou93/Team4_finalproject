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

