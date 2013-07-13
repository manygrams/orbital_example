$: << 'lib'
require 'orbital_example'

SIM_NUM = ARGV[0] ? ARGV[0].to_i : 10000
N = ARGV[1] ? ARGV[1].to_i : 15

objects = {}
N.times do |i|
  objects[i] = Astrodynamics::AstronomicalObject.new i
end

p = ProgressBar.new "Simulation", SIM_NUM

t_vector = []
name_vector = []
x_vector = []
y_vector = []
z_vector = []

SIM_NUM.times do | i |
  p.set(i)
  objects.each { | key, object | object.calc_tick(objects.except key) }
  objects.each { | key, object | object.apply_tick }

  objects.each do | key, object |
    t_vector << i
    name_vector << object.to_s
    x_vector << object.get_position[0]
    y_vector << object.get_position[1]
    z_vector << object.get_position[2]
  end
end

R.echo false, false

R.t = t_vector
R.name = name_vector
R.x = x_vector
R.y = y_vector
R.z = z_vector

R.eval <<-EOF
  library(scatterplot3d)
  library(animation)

  x <- data.frame(t <- t, name <- name, x <- x, y <- x, z <- z)
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
EOF

puts ''
puts 'Press enter to continue.'
STDIN.gets.chomp