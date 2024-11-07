-- Velocity utility class
Velocity = {}
Velocity.__index = Velocity

-- Constructor
function Velocity.new(x, y)
  local self = setmetatable({}, Velocity)
  self.x = x or 0
  self.y = y or 0
  return self
end

-- Copy constructor
function Velocity:copy(vel)
  self.x = vel.x
  self.y = vel.y
end

-- Equality comparison metamethod
Velocity.__eq = function(a, b)
  return a.x == b.x and a.y == b.y
end

-- String representation metamethod (useful for debugging)
Velocity.__tostring = function(self)
  return string.format("Velocity(x=%.2f, y=%.2f)", self.x, self.y)
end

-- Getters
function Velocity:getX()
  return self.x
end

function Velocity:getY()
  return self.y
end

-- Setters
function Velocity:setX(x)
  self.x = x
end

function Velocity:setY(y)
  self.y = y
end

-- Set both x and y at once
function Velocity:setXY(x, y)
  self.x = x
  self.y = y
end

-- Additional utility methods specific to velocity

-- Multiply the velocity by a scalar
function Velocity:multiply(factor)
  self.x = self.x * factor
  self.y = self.y * factor
end

-- Get the magnitude (speed) of the velocity
function Velocity:getMagnitude()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

-- Set to zero velocity
function Velocity:zero()
  self.x = 0
  self.y = 0
end

-- Check if velocity is zero
function Velocity:isZero()
  return self.x == 0 and self.y == 0
end

-- Add another velocity to this one
function Velocity:add(vel)
  self.x = self.x + vel.x
  self.y = self.y + vel.y
end

return Velocity