require 'matrix'

module Astrodynamics
  class AstronomicalObject
    attr_accessor :name, :current_x, :current_y, :current_z, :mass, :radius, :dx, :dy, :dz

    G = 6.67384e-11

    def initialize name, x, y, z, m, r, dx = 0, dy = 0, dz = 0
      @name = name
      @current_x = x
      @current_y = y
      @current_z = z

      @mass = m
      @radius = r

      @dx = dx
      @dy = dy
      @dz = dz
    end

    def initialize name
      scale = 110
      @name = name
      @current_x = Random.rand(-scale..scale).to_f
      @current_y = Random.rand(-scale..scale).to_f
      @current_z = Random.rand(-scale..scale).to_f

      @mass = Random.rand(10..20000).to_f
      @radius = Random.rand(0..10).to_f/5

      @dx = 0
      @dy = 0
      @dz = 0
    end

    def to_s
      @name
    end

    def calc_tick objects
      accelerations = []
      acceleration = Vector[ 0, 0, 0 ]
      objects.each { | key, object | accelerations << calculate_acceleration(object, self) }
      accelerations.each { |a| acceleration += a }

      @dx += acceleration[0]
      @dy += acceleration[1]
      @dz += acceleration[2]
    end

    def apply_tick
      @current_x += @dx
      @current_y += @dy
      @current_z += @dz
    end

    def get_position
      Vector[ @current_x, @current_y, @current_z ]
    end

    def get_change
      Vector[ @dx, @dy, @dz ]
    end

    def make_circular o
      vector = o.get_position - self.get_position
      distance = vector.magnitude
      @dx = Math.sqrt(G * o.get_mass / distance) * 0.95
      @dy = 0
      @dz = 0
    end

    private

    def calculate_acceleration o1, o2
      vector = o2.get_position - o1.get_position
      distance = vector.magnitude
      (distance > o1.radius + o2.radius) ? ((-G * o1.mass * o2.mass) /  (distance ** 2)) * vector.normalize : Vector[ 0, 0, 0 ]
    end

  end
end