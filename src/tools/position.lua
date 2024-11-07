-- Position utility class
Position = {}
Position.__index = Position

-- Constructor
function Position.new(x, y)
  local self = setmetatable({}, Position)
  self.x = x or 0
  self.y = y or 0
  return self
end

-- Copy constructor
function Position:copy(pos)
  self.x = pos.x
  self.y = pos.y
end

-- Equality comparison metamethod
Position.__eq = function(a, b)
  return a.x == b.x and a.y == b.y
end

-- String representation metamethod (useful for debugging)
Position.__tostring = function(self)
  return string.format("Position(x=%d, y=%d)", self.x, self.y)
end

-- Getters
function Position:getX()
  return self.x
end

function Position:getY()
  return self.y
end

-- Setters
function Position:setX(x)
  self.x = x
end

function Position:setY(y)
  self.y = y
end

-- Set both x and y at once
function Position:setXY(x, y)
  self.x = x
  self.y = y
end

-- Check if position is at default/uninitialized state (0,0)
function Position:isUninitialized()
  return self.x == 0 and self.y == 0
end

-- Alternative name if you prefer this syntax
function Position:isDefault()
  return self:isUninitialized()
end

function Position:add(pos)
  self.x = self.x + pos.x
  self.y = self.y + pos.y
end 

function Position:subtract(pos)
  self.x = self.x - pos.x
  self.y = self.y - pos.y
end

return Position