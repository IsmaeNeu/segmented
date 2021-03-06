\name{segmented}
\alias{segmented}
\alias{segmented.lm}
\alias{segmented.glm}
\alias{segmented.default}
\alias{segmented.Arima}
%\alias{print.segmented}
%\alias{summary.segmented}
%\alias{print.summary.segmented}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Segmented relationships in regression models
}
\description{
  Fits regression models with segmented relationships between the response
   and one or more explanatory variables. Break-point estimates are provided.
}
\usage{
segmented(obj, seg.Z, psi, control = seg.control(), 
    model = TRUE, ...)

\method{segmented}{default}(obj, seg.Z, psi, control = seg.control(),
    model = TRUE, ...)

\method{segmented}{lm}(obj, seg.Z, psi, control = seg.control(),
    model = TRUE, ...)

\method{segmented}{glm}(obj, seg.Z, psi, control = seg.control(),
    model = TRUE, ...)

\method{segmented}{Arima}(obj, seg.Z, psi, control = seg.control(),
    model = TRUE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{obj}{ standard `linear' model of class "lm" or "glm". Since version 0.5.0-0 any regression 
  fit may be supplied (see 'Details').}
  \item{seg.Z}{ the segmented variables(s), i.e. the continuous covariate(s) understood to have a piecewise-linear relationship with response. It is a formula with no response variable, such as \code{seg.Z=~x} or \code{seg.Z=~x1+x2}. It can be missing when \code{obj} (a "lm" or "glm" fit) includes only one covariate which is taken as segmented variable. Currently, formulas involving functions, such as \code{seg.Z=~log(x1)} or even \code{seg.Z=~sqrt(x1)}, 
      or selection operators, such as \code{seg.Z=~d[,"x1"]} or \code{seg.Z=~d$x1}, are \emph{not} allowed. 
      
               }
  \item{psi}{ starting values for the breakpoints to be estimated. If there is a single segmented variable specified in \code{seg.Z}, \code{psi} is a numeric vector, and it can be missing  when 1 breakpoint has to be estimated (and the median of the segmented variable is used as a starting value). If \code{seg.Z} includes several covariates, \code{psi} has be specified as a \emph{named} list of vectors whose names have to match the variables in the \code{seg.Z} argument. Each vector of such list includes starting values for the break-point(s) for the corresponding variable in \code{seg.Z}. 
      A \code{NA} value means that `\code{K}' quantiles (or equally spaced values) are used as starting values; 
      \code{K} is fixed via the \code{\link{seg.control}} auxiliary function. }
      
  \item{control}{ a list of parameters for controlling the fitting process.
      See the documentation for \code{\link{seg.control}} for details. }
  \item{model}{ logical value indicating if the model.frame should be returned.}
  \item{\dots}{ optional arguments. }
}
\details{
  Given a linear regression model (usually of class "lm" or "glm"), segmented tries to estimate
  a new model having broken-line relationships with the variables specified in \code{seg.Z}.
  A segmented (or broken-line) relationship is defined by the slope
  parameters and the break-points where the linear relation changes. The number of breakpoints
  of each segmented relationship is fixed via the \code{psi} argument, where initial
  values for the break-points must be specified. The model
  is estimated simultaneously yielding point estimates and relevant approximate
   standard errors of all the model parameters, including the break-points.

  Since version 0.2-9.0 \code{segmented} implements the bootstrap restarting algorithm described in Wood (2001).
  The bootstrap restarting is expected to escape the local optima of the objective function when the
  segmented relationship is flat and the log likelihood can have multiple local optima.

  Since version 0.5-0.0 the default method \code{segmented.default} has been added to estimate segmented relationships in 
  general (besides "lm" and "glm" fits) regression models, such as Cox regression or quantile regression (for a single percentile). 
  The objective function to be minimized is the (minus) value extracted by the \code{logLik} function or it may be passed on via 
  the \code{fn.obj} argument in \code{seg.control}. See example below. While the default method is expected to work with any regression 
  fit (where the usual \code{coef()}, \code{update()}, and \code{logLik()} returns appropriate results), it is not recommended for 
  "lm" or "glm" fits (as \code{segmented.default} is slower than the specific methods \code{segmented.lm} and \code{segmented.glm}), although 
  final results are the same. However the object returned by \code{segmented.default} is \emph{not} of class "segmented", as currently
  the segmented methods are not guaranteed to work for `generic' (i.e., besides "lm" and "glm") regression fits. The user 
  could try each "segmented" method on the returned object by calling it explicitly (e.g. via \code{plot.segmented()} or \code{confint.segmented()}). 
}
\value{
  The returned object depends on the \code{last} component returned by \code{seg.control}.
  If last=TRUE, the default, segmented returns an object of class "segmented" which inherits
  from the class "lm" or "glm" depending on the class of \code{obj}. Otherwise a list is
  returned, where the last component is the fitted model at the final iteration,
  see \code{\link{seg.control}}. \cr

An object of class "segmented" is a list containing the components of the
original object \code{obj} with additionally the followings:
  \item{psi}{estimated break-points and relevant (approximate) standard errors}
  \item{it}{number of iterations employed}
  \item{epsilon}{difference in the objective function when the algorithm stops}
  \item{model}{the model frame}
  \item{psi.history}{a list or a vector including the breakpoint estimates at each step}
  \item{seed}{the integer vector containing the seed just before the bootstrap resampling. 
     Returned only if bootstrap restart is employed}
  \item{..}{Other components are not of direct interest of the user}
  }
  
\references{ 
Muggeo, V.M.R. (2003) Estimating regression models with unknown 
  break-points. \emph{Statistics in Medicine} \bold{22}, 3055--3071.

Muggeo, V.M.R. (2008) Segmented: an R package to fit regression 
  models with broken-line relationships. \emph{R News} \bold{8/1}, 20--25.
  }

    
\author{ Vito M. R. Muggeo, \email{vito.muggeo@unipa.it} }

\note{
\enumerate{
\item The algorithm will start if the \code{it.max} argument returned by \code{seg.control}
  is greater than zero. If \code{it.max=0} \code{segmented} will estimate a new linear model with
 break-point(s) fixed at the values reported in \code{psi}.
 
\item In the returned fit object, `U.' is put before the name of the segmented 
variable to mean the difference-in-slopes coefficient.

\item Methods specific to the class \code{"segmented"} are
    \itemize{
  \item \code{print.segmented}
  \item \code{summary.segmented}
  \item \code{print.summary.segmented}
  \item \code{plot.segmented}
  \item \code{lines.segmented}
  \item \code{confint.segmented}
  \item \code{vcov.segmented}
  \item \code{predict.segmented}
  \item \code{points.segmented}
            }

Others are inherited from the class \code{"lm"} or \code{"glm"} depending on the
 class of \code{obj}.

     }
}
\section{ Warning }{It is well-known that the log-likelihood function for the 
break-point may be not concave, especially 
for poor clear-cut kink-relationships. In these circumstances the initial guess
 for the break-point, i.e. the \code{psi} argument, must be provided with care. For instance visual 
inspection of a, possibly smoothed, scatter-plot is usually a good way to obtain some idea on breakpoint location. 
However bootstrap restarting, implemented since version 0.2-9.0, is relatively more robust to starting values specified 
in  \code{psi}. Alternatively an automatic procedure may be implemented by specifying \code{psi=NA} and 
\code{stop.if.error=FALSE} in \code{\link{seg.control}}: experience suggests to increase the number of iterations 
via \code{it.max} in \code{seg.control()}. This automatic procedure, however, is expected to overestimate 
the number of breakpoints. 
}

\seealso{ \code{\link{lm}}, \code{\link{glm}} }

\examples{

set.seed(12)
xx<-1:100
zz<-runif(100)
yy<-2+1.5*pmax(xx-35,0)-1.5*pmax(xx-70,0)+15*pmax(zz-.5,0)+rnorm(100,0,2)
dati<-data.frame(x=xx,y=yy,z=zz)
out.lm<-lm(y~x,data=dati)

#simple example: 1 segmented variable, 1 breakpoint: you do not need to specify 
# the starting value for psi
o<-segmented(out.lm,seg.Z=~z)

#1 segmented variable, 2 breakpoints: you have to specify starting values (vector) for psi:
o<-segmented(out.lm,seg.Z=~x,psi=c(30,60),
    control=seg.control(display=FALSE))
slope(o)

#2 segmented variables: starting values requested via a named list
out.lm<-lm(y~z,data=dati)
o1<-update(o,seg.Z=~x+z,psi=list(x=c(30,60),z=.3))


#the default method leads to the same results (but it is slower)
#o1<-segmented.default(out.lm,seg.Z=~x+z,psi=list(x=c(30,60),z=.3))
#o1<-segmented.default(out.lm,seg.Z=~x+z,psi=list(x=c(30,60),z=.3), 
#    control=seg.control(fn.obj="sum(x$residuals^2)"))


#automatic procedure to estimate breakpoints in the covariate x
# Notice: bootstrap restart is not allowed!
o<-segmented.lm(out.lm,seg.Z=~x+z,psi=list(x=NA,z=.3), 
    control=seg.control(stop.if.error=FALSE,n.boot=0, it.max=20))

#assess the progress of the breakpoint estimates throughout the iterations
\dontrun{
par(mfrow=c(2,1))
draw.history(o, "x")
draw.history(o, "z")
}
#try to increase the number of iterations and re-assess the 
#convergence diagnostics 


#An example using the default method:
# Cox regression with a segmented relationship  
\dontrun{
library(survival)
data(stanford2)

o<-coxph(Surv(time, status)~age, data=stanford2)
os<-segmented(o, ~age, psi=40) #estimate the breakpoint in the age effect
summary(os) #actually it means summary.coxph(os)
plot(os) #it does not work
plot.segmented(os) #call explicitly plot.segmented() to plot the fitted piecewise lines
}
            
}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{regression}
\keyword{nonlinear }
