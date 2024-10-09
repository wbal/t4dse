set.seed(1)
x=seq(0,12*6-1)
y=100 + 20*cos(2*pi*x/12) + rnorm(n = length(x),mean = 50,sd = 40)
y[y<0] <- 0
data14a19 <- data.frame( idx=seq(1,12*6), year=rep(2014:2019, each=12 ), month=rep(1:12, 6), cases=y )

test_that("endemicchannel() generates the endemic channel with 12 months", {
  expect_equal(
    nrow( endemicchannel(data =data14a19
                   ,yearnow = 2019,period = "month"
                   ,.var = "cases"
                   ,nyears = 5) ),
    12
  )
})

test_that("endemicchannel() errors if input not a data frame", {
  expect_error(
    endemicchannel(data ="data14a19"
                         ,yearnow = 2019,period = "month"
                         ,.var = "cases"
                         ,nyears = 5)
  )
})
