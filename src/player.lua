-- Player class
Player = {}
Player.__index = Player

function Player:new(color)
  local instance = setmetatable({}, Player)
  instance.color = color
  return instance
end