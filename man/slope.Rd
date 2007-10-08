\name{slope}
\alias{slope}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Slope estimates from segmented relationships }
\description{
  Computes slopes of each `segmented' relationship in the fitted model.
}
\usage{
slope(ogg, level = 0.95)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ogg}{ an object of class \code{"segmented"}, returned by any \code{segmented} method. }
  \item{level}{ the confidence level required. }
}
\details{
  To fit broken-line relationships, \code{segmented} uses a parameterization whose coefficients are not 
  the slopes. Therefore given an object \code{"segmented"}, \code{slope} computes point estimates,
  standard errors, t-values and confidence intervals of the slopes of each segmented relationship in the fitted model.
}
\value{
  \code{slope} returns a list of matrices. Each matrix represents a segmented relationship and its number of rows equal 
  to the number of segments, while five columns summarize the results.
}
\references{Muggeo, V.M.R. (2003) Estimating regression models with unknown break-points. 
    \emph{Statistics in Medicine} \bold{22}, 3055--3071.}

\author{Vito M. R. Muggeo, \email{vmuggeo@dssm.unipa.it} }

\note{ The returned summary is based on limiting Gaussian distribution for the model parameters involved 
    in the computations. Sometimes, even with large sample sizes such approximations are questionable 
    (e.g., with small difference-in-slope parameters) and the results returned by \code{slope} 
    might be unreliable. Therefore is responsability of the user to gauge the applicability of such asymptotic 
    approximations. Anyway, the t values may be not assumed for testing purposes 
    and they should be used just as guidelines to assess the estimate uncertainty.
}
\seealso{ See also \code{\link{davies.test}} to test for a nonzero differece-in-slope parameter.}

\examples{

set.seed(16)
x<-1:100
y<-2+1.5*pmax(x-35,0)-1.5*pmax(x-70,0)+rnorm(100,0,3)
out<-glm(y~1)
out.seg<-segmented(out,seg.Z=~x,psi=list(x=c(20,80)))
## the slopes of the three segments....
slope(out.seg)
rm(x,y,out,out.seg)
}
\keyword{ regression }
\keyword{ htest }