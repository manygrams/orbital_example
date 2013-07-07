class Hash
  def except(*keys)
    dup.except!(*keys)
  end

  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end
end

$: << 'lib'
require 'astrodynamics/planet'
require 'csv'
require 'rinruby'

N = ARGV[0] ? ARGV[0].to_i : 10000

objects =
{
  'sun'    => Astrodynamics::Planet.new('sun',     0,  0,    5,  550, 2),
  'moon1'  => Astrodynamics::Planet.new('moon1',  10, 10,  -20,  890, 0.25),
  'moon2'  => Astrodynamics::Planet.new('moon2',   6, 18,    2,  500, 0.25),
  'moon3'  => Astrodynamics::Planet.new('moon3', -10, 10,    8,  400, 0.05),
  'moon4'  => Astrodynamics::Planet.new('moon4',   6, -4,   -2,  400, 0.05)
}

# objects['moon1'].make_circular objects['sun']
# objects['moon2'].make_circular objects['moon1']

CSV.open("planets.csv", "wb") do |csv|
  N.times do | i |
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

  every = 100

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