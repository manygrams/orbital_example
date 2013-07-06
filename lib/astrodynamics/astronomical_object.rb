require 'matrix'

module Astrodynamics
  class AstronomicalObject
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

    def get_mass
      @mass
    end

    def get_radius
      @radius
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
      unit_vector = (1/distance) * vector
      (distance > o1.get_radius) && (distance > o2.get_radius) ? ((-G * o1.get_mass * o2.get_mass) /  (distance ** 2)) * unit_vector : Vector[0, 0, 0]
    end

  end
end