require 'astrodynamics/astronomical_object'

module Astrodynamics
  class Planet < AstronomicalObject

    def initialize name, x, y, z, m, r, dx = 0, dy = 0, dz = 0
      super name, x, y, z, m, r, dx, dy, dz
    end

  end
end