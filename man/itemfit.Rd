% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/itemfit.R
\name{itemfit}
\alias{itemfit}
\title{Item fit statistics}
\usage{
itemfit(x, Zh = TRUE, X2 = FALSE, S_X2 = TRUE, group.size = 150,
  mincell = 1, S_X2.tables = FALSE, empirical.plot = NULL,
  empirical.CI = 0, method = "EAP", Theta = NULL, impute = 0,
  digits = 4, ...)
}
\arguments{
\item{x}{a computed model object of class \code{SingleGroupClass},
\code{MultipleGroupClass}, or \code{DiscreteClass}}

\item{Zh}{logical; calculate Zh and associated statistics (infit/outfit)? Disable this is you are
only interested in computing the S-X2 quickly}

\item{X2}{logical; calculate the X2 statistic for unidimensional models?}

\item{S_X2}{logical; calculate the S_X2 statistic?}

\item{group.size}{approximate size of each group to be used in calculating the \eqn{\chi^2}
statistic}

\item{mincell}{the minimum expected cell size to be used in the S-X2 computations. Tables will be
collapsed across items first if polytomous, and then across scores if necessary}

\item{S_X2.tables}{logical; return the tables in a list format used to compute the S-X2 stats?}

\item{empirical.plot}{a single numeric value or character of the item name  indicating which
item to plot (via \code{itemplot}) and overlay with the empirical \eqn{\theta} groupings.
Only applicable when \code{type = 'X2'}. The default is \code{NULL}, therefore no plots
are drawn}

\item{empirical.CI}{a numeric value indicating the width of the empirical confidence interval
ranging between 0 and 1 (default of 0 plots not interval). For example, a 95% confidence
interval would be plotted if \code{empirical.CI = .95}. Only applicable to dichotomous items}

\item{method}{type of factor score estimation method. See \code{\link{fscores}} for more detail}

\item{Theta}{a matrix of factor scores for each person used for statistics that require
empirical estimates. If supplied, arguments typically passed to \code{fscores()} will be
ignored and these values will be used instead. Also required when estimating statistics
with missing data via imputation}

\item{impute}{a number indicating how many imputations to perform (passed to
\code{\link{imputeMissing}}) when there are missing data present.
Will return a data.frame object with the mean estimates
of the stats and their imputed standard deviations}

\item{digits}{number of digits to round result to. Default is 4}

\item{...}{additional arguments to be passed to \code{fscores()}}
}
\description{
\code{itemfit} calculates the Zh values from Drasgow, Levine and Williams (1985),
\eqn{\chi^2} values for unidimensional models, and S-X2 statistics for unidimensional and
multidimensional models (Kang & Chen, 2007; Orlando & Thissen, 2000).
For Rasch, partial credit, and rating scale models infit and outfit statistics are
also produced. Poorly fitting items should be inspected with \code{\link{itemGAM}} to diagnose
whether the functional form of the IRT model was misspecified or could be improved.
}
\examples{
\dontrun{

P <- function(Theta){exp(Theta^2 * 1.2 - 1) / (1 + exp(Theta^2 * 1.2 - 1))}

#make some data
set.seed(1234)
a <- matrix(rlnorm(20, meanlog=0, sdlog = .1),ncol=1)
d <- matrix(rnorm(20),ncol=1)
Theta <- matrix(rnorm(2000))
items <- rep('dich', 20)
ps <- P(Theta)
baditem <- numeric(2000)
for(i in 1:2000)
   baditem[i] <- sample(c(0,1), 1, prob = c(1-ps[i], ps[i]))
data <- cbind(simdata(a,d, 2000, items, Theta=Theta), baditem=baditem)

x <- mirt(data, 1)
raschfit <- mirt(data, 1, itemtype='Rasch')
fit <- itemfit(x)
fit

fit <- itemfit(x, X2=TRUE)
fit$X2

itemfit(x, empirical.plot = 1) #empirical item plot
itemfit(x, empirical.plot = 1, empirical.CI = .99) #empirical item plot with 99\% CI's

#method='ML' agrees better with eRm package
itemfit(raschfit, method = 'ML') #infit and outfit stats

#same as above, but inputting ML estimates instead
Theta <- fscores(raschfit, method = 'ML', full.scores=TRUE)
itemfit(raschfit, Theta=Theta)

#similar example to Kang and Chen 2007
a <- matrix(c(.8,.4,.7, .8, .4, .7, 1, 1, 1, 1))
d <- matrix(rep(c(2.0,0.0,-1,-1.5),10), ncol=4, byrow=TRUE)
dat <- simdata(a,d,2000, itemtype = rep('graded', 10)) - 1
head(dat)

mod <- mirt(dat, 1)
itemfit(mod)

mod2 <- mirt(dat, 1, 'Rasch')
itemfit(mod2)

#massive list of tables
tables <- itemfit(mod, S_X2.tables = TRUE)

#observed and expected total score patterns for item 1 (post collapsing)
tables$O[[1]]
tables$E[[1]]

# fit stats with missing data (run in parallel using all cores)
data[sample(1:prod(dim(data)), 500)] <- NA
raschfit <- mirt(data, 1, itemtype='Rasch')

mirtCluster() # run in parallel
itemfit(raschfit, impute = 10)

#alternative route: use only valid data, and create a model with the previous parameter estimates
data2 <- na.omit(data)
raschfit2 <- mirt(data2, 1, itemtype = 'Rasch', pars=mod2values(raschfit), TOL=NaN)
itemfit(raschfit2)
  }
}
\author{
Phil Chalmers \email{rphilip.chalmers@gmail.com}
}
\references{
Drasgow, F., Levine, M. V., & Williams, E. A. (1985). Appropriateness measurement with
polychotomous item response models and standardized indices.
\emph{Journal of Mathematical and Statistical Psychology, 38}, 67-86.

Kang, T. & Chen, Troy, T. (2007). An investigation of the performance of the generalized
S-X2 item-fit index for polytomous IRT models. ACT

Orlando, M. & Thissen, D. (2000). Likelihood-based item fit indices for dichotomous item
response theory models. \emph{Applied Psychological Measurement, 24}, 50-64.

Reise, S. P. (1990). A comparison of item- and person-fit methods of assessing model-data fit
in IRT. \emph{Applied Psychological Measurement, 14}, 127-137.

Wright B. D. & Masters, G. N. (1982). \emph{Rating scale analysis}. MESA Press.
}
\seealso{
\code{\link{personfit}}, \code{\link{itemGAM}}
}
\keyword{fit}
\keyword{item}

