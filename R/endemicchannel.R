
endemicchannel <- function(data, yearnow, period ="month", .var="cases", nyears = 5, alpha=0.05 ){

  y = .var

  if ( is.null(yearnow) ) {
    yearnow = max(data$year, na.rm = TRUE)
  }

  # filter( year >= (yearnow- nyears ), year < yearnow )
  data2 <- data[data$year >= (yearnow- nyears ) & data$year < yearnow, ]


  frm = formula( paste0(y, " ~ ", period ) )

  inframax = aggregate(
    frm, FUN = \(x) x[ kit::topn(x,n=2L,decreasing=TRUE)[2L]]
    , data = data2
  )

  supramin = aggregate(
    frm, FUN = \(x) x[ kit::topn(x,n=2L,decreasing=FALSE)[2L]]
    , data = data2
  )

  median_ = aggregate(
    frm, FUN = \(x) stats::median(x, na.rm = TRUE)
    , data = data2
  )


  data.frame( year = yearnow
              , period = inframax[[period]]
              , median = median_[[y]]
              , supramin = supramin[[y]]
              , inframax = inframax[[y]]
  )
}
