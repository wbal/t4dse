
#' Create endemic channel
#'
#' @param data A data frame with columns: year, month/week, cases.
#' @param yearnow The year for which the endemic channel will be computed
#' @param period Specify the name of the column to aggregate the time: i.e. "month" or "epiweek". Default period="month"
#' @param .var Column name to compute the endemic channel. Default .var="cases"
#' @param nyears Number of years to compute the endemic channel. Default nyears= 5
#'
#' @return Returns a dataframe with colums: year, month, median, supramin, inframax
#' @importFrom stats aggregate formula
#' @importFrom kit topn
#' @export
#'
#' @author W. Baldoquin Rodríguez
#'
#' @references Baldoquin-Rodríguez W, et al. Effectiveness of a multicomponent dengue prevention strategy targeting transmission hotspots in Santiago de Cuba, Cuba, 2015-2020. 2024. [in-review]
#' @examples
#' set.seed(1)
#' x=seq(0,12*6-1)
#' y=100 + 20*cos(2*pi*x/12) + rnorm(n = length(x),mean = 50,sd = 40)
#' y[y<0] <- 0
#' data14a19 <- data.frame( idx=seq(1,12*6), year=rep(2014:2019, each=12 ),
#'  month=rep(1:12, 6), cases=y )
#' endemicchannel(data =data14a19,yearnow = 2019 )
endemicchannel <- function(data, yearnow, period ="month", .var="cases", nyears = 5 ){

  stopifnot( is.data.frame(data),
             is.numeric(yearnow),
             is.character(period),
             is.character(.var),
             is.numeric(nyears)
             )

  y = .var

  if ( is.null(yearnow) ) {
    yearnow = max(data$year, na.rm = TRUE)
  }

  # filter( year >= (yearnow- nyears ), year < yearnow )
  data2 <- data[data$year >= (yearnow- nyears ) & data$year < yearnow, ]


  frm = stats::formula( paste0(y, " ~ ", period ) )

  inframax = stats::aggregate(
    frm, FUN = \(x) x[ kit::topn(x,n=2L,decreasing=TRUE)[2L]]
    , data = data2
  )

  supramin = stats::aggregate(
    frm, FUN = \(x) x[ kit::topn(x,n=2L,decreasing=FALSE)[2L]]
    , data = data2
  )

  median_ = stats::aggregate(
    frm, FUN = \(x) stats::median(x, na.rm = TRUE)
    , data = data2
  )


  df<-  data.frame( year = yearnow
              , period = inframax[[period]]
              , median = median_[[y]]
              , supramin = supramin[[y]]
              , inframax = inframax[[y]]
  )
  names(df)[2]<-period
  df
}
