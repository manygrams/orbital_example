$: << 'lib'
require 'orbital_example'

classpath = Dir['./lib/java/*'].join(':')
Rjb::load classpath, jvmargs=['-Xmx512M']
Chart = Rjb::import 'org.jzy3d.chart.Chart'
Scatter = Rjb::import 'org.jzy3d.plot3d.primitives.Scatter'
Coord3d = Rjb::import 'org.jzy3d.maths.Coord3d'
chart = Chart.new

SIM_NUM = ARGV[0] ? ARGV[0].to_i : 10000
N = ARGV[1] ? ARGV[1].to_i : 15

objects = {}
N.times do |i|
  objects[i] = Astrodynamics::AstronomicalObject.new i
end

SIM_NUM.times do | i |
  coord = []
  objects.each { | key, object | object.calc_tick(objects.except key) }
  objects.each { | key, object | object.apply_tick }
  objects.each do | key, object |
    coord << Coord3d.new(object.get_position[0], object.get_position[1], object.get_position[2])
  end

  scatter = Scatter.new coord
  chart.getScene.add scatter
end