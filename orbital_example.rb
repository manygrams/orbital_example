class Hash
  def except(*keys)
    dup.except!(*keys)
  end

  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end
end

def time
  start = Time.now
  yield
  Time.now - start
end

$: << 'lib'
require 'astrodynamics/planet'
require 'csv'
require 'rinruby'

SIM_NUM = ARGV[0] ? ARGV[0].to_i : 10000
N = ARGV[1] ? ARGV[1].to_i : 15

objects = {}

N.times do |i|
  objects[i] = Astrodynamics::AstronomicalObject.new i
end

CSV.open("planets.csv", "wb") do |csv|
  SIM_NUM.times do | i |
    objects.each { | key, object | object.calc_tick(objects.except key) }
    objects.each { | key, object | object.apply_tick }
    objects.each { | key, object | csv << [ i, object.to_s, object.get_position[0], object.get_position[1], object.get_position[2] ] }
  end
end

R.eval <<EOF
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

  every = 10

  t_list = unique(x$t)
  t_list = t_list[t_list %% every == 0]

  ani.start()
  for(i in t_list)
  {
   this <- x[x$t == i, ]
   scatterplot3d(this$x, this$y, this$z, xlab="x", ylab="y", zlab="z", xlim=xl, ylim=yl, zlim=zl)
  }
  ani.stop()
  ani.options(interval = 0.1)
EOF

sleep(3)