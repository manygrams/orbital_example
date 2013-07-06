rm(list=ls())
library(scatterplot3d)
library(animation)
library(reshape2)

x <- read.csv("~/Code/orbital_example/planets.csv", header=FALSE)
colnames(x) <- c("t","name","x","y","z")

UNIQUE <- length(unique(x$name))
N <- nrow(x)/UNIQUE

x <- x[1:(N*UNIQUE), ]

xl = c(min(x$x)-1, max(x$x)+1)
yl = c(min(x$y)-1, max(x$y)+1)
zl = c(min(x$z)-1, max(x$z)+1)

# x.wide <- reshape(x, direction="wide", timevar="name", idvar="t")
# scatterplot3d(x$x, x$y, x$z, xlim=xl, ylim=yl, zlim=zl, xlab="x", ylab="y", zlab="z")

every = 500

t_list = unique(x$t)
t_list = t_list[t_list %% every == 0]

ani.start()
for(i in t_list)
{
 this <- x[x$t == i, ]
 scatterplot3d(this$x, this$y, this$z, xlim=xl, ylim=yl, zlim=zl, xlab="x", ylab="y", zlab="z")
}
ani.stop()
ani.options(interval = 0.1)

