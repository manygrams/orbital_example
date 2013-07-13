require 'astrodynamics/planet'
require 'rjb'

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