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

N = 500000

objects =
{
  'sun'    => Astrodynamics::Planet.new('sun',     0,  0,    5, 1550, 0.5),
  'moon1'  => Astrodynamics::Planet.new('moon1',  10, 10,  -20,  890, 0.25, -4e-7, 3e-05, -1e-05),
  'moon2'  => Astrodynamics::Planet.new('moon2',   6, 18,    2,  500, 0.25, -1e-3, 2e-14,  2e-07),
  'moon3'  => Astrodynamics::Planet.new('moon3', -10, 10,    8,   20, 0.05, -1e-3, 2e-14,  2e-07),
  'moon4'  => Astrodynamics::Planet.new('moon4',   6, -4,   -2,   20, 0.05, -1e-3, 2e-14,  2e-07)
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

