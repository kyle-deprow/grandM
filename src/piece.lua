-- piece.lua
require("engine/sprite")
require("tools/position")
require("tools/velocity")
require("tools/tile_translation")

-- Base Piece class
Piece = Sprite:extend()
Piece.__class = "Piece"

function Piece:new(pieceConfig)
  local instance = setmetatable({}, self)

  instance.color = pieceConfig.color
  instance.type = pieceConfig.type
  instance.rank = pieceConfig.rank
  instance.health = pieceConfig.health
  instance.defense = pieceConfig.defense
  instance.items = pieceConfig.items or {}
  instance.start = pieceConfig.start or {offsetX = 0, offsetY = 0}
  instance.id = pieceConfig.id
  instance.playerTopBottom = pieceConfig.playerTopBottom
  instance.position = Position.new(0, 0)
  instance.originalPosition = Position.new(0, 0)
  instance.tile = nil

  instance.texture = love.graphics.newImage(ReturnPieceTextureFile(instance))
	instance.pngSize = 150 -- TODO: Hardcoded for now
  instance.preScaler = 1/(instance.pngSize/(0.96)) --scale *0.96
  instance.scale = 0

  instance.dragging = false
  instance.dragVelocity = Velocity.new(0, 0)
  instance.width = 0
  instance.height = 0
  instance.board = nil

  return instance
end

Piece.__tostring = function(self)
  return string.format("%s(type=%s, color=%s, pos=(%d,%d), player=%s, tile=%s)",
    self.__class,
    self.type,
    self.color,
    self.position.x,
    self.position.y,
    self.playerTopBottom,
    self.tile and string.format("[%d,%d]", self.tile:getRow(), self.tile:getCol()) or "nil"
  )
end

function Piece:init(...)
  -- Call the parent class's init method
  Sprite.init(self, ...)
  -- Additional initialization for Piece
end

function Piece:draw()
  -- Set the shader
  -- love.graphics.setShader(self.shader)

  -- Set the hue color uniform
  -- self.shader:send("hueColor", {hueColor[1], hueColor[2], hueColor[3]})

  -- Draw the piece's texture at its position
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.texture, self.position.x, self.position.y, 0, self.scale, self.scale)

  -- Reset the shader
  -- love.graphics.setShader()
end

-- Piece is initialized if it is attached to a tile
function Piece:initialized()
  return self.tile ~= nil
end

function Piece:updateDragging(target, dt)
  -- Calculate offset from center of piece
  target:subtract(Position.new(self.width/2, self.height/2))
  -- Calculate difference between current and target position
  target:subtract(self.position)

  -- Update velocities
  self.dragVelocity:multiply(DRAG_DAMPING)
  self.dragVelocity:add(Velocity.new(target.x*DRAG_ACCELERATION*dt, target.y*DRAG_ACCELERATION*dt))

  -- Apply velocities
  self.position:add(Position.new(self.dragVelocity.x*dt, self.dragVelocity.y*dt))
end

function Piece:calculateScale(tileSize)
  self.scale = self.preScaler * tileSize
  self.width = self.scale * self.pngSize
  self.height = self.scale * self.pngSize
end 

function Piece:validateMove(translation)
  -- Rotate translation if piece is on top so all calculations are the same for both players
  if self:getPlayerTopBottom() == TOP then
    translation:rotate()
  end

  if translation:getDestinationTile():hasPiece() then
    return self:validateOccupiedMove(translation)
  else
    return self:validateUnoccupiedMove(translation)
  end
end

function Piece:checkFriendlyOccupiedMove(translation)
  -- Default implementation: return false if destination tile has a piece of the same player
  -- Subclasses can override this method if they have different rules
  if translation:getDestinationTile():getPiece():getPlayerTopBottom() == self:getPlayerTopBottom() then
    return false
  end
  return true
end

function Piece:validateOccupiedMove(translation)
  if not self:checkFriendlyOccupiedMove(translation) then
    return false
  end
  return self:_validateOccupiedMove(translation)
end

function Piece:_validateOccupiedMove(translation)
  -- Abstract method to be implemented by subclasses
end

function Piece:validateUnoccupiedMove(translation)
  return self:_validateUnoccupiedMove(translation)
end

function Piece:_validateUnoccupiedMove(translation)
  -- Abstract method to be implemented by subclasses
end

function Piece:validatePlacement(translation)
  return self:_validatePlacement(translation)
end

function Piece:_validatePlacement(translation)
  -- Abstract method to be implemented by subclasses
end

function Piece:reset(position)
  self.position:copy(position)
  self.originalPosition:copy(position)
end

function Piece:resetToOriginalPosition()
  self.position:copy(self.originalPosition)
end 

function Piece:setBoard(board) self.board = board end
function Piece:setPosition(position) self.position:copy(position) end
function Piece:setOriginalPosition(position) self.originalPosition:copy(position) end
function Piece:setTile(tile) self.tile = tile end
function Piece:setDragging(dragging)
  self.dragging = dragging
  self.dragVelocity:zero()
end

function Piece:getId() return self.id end
function Piece:getOriginalPosition() return self.originalPosition end
function Piece:getBoard() return self.board end
function Piece:getType() return self.type end
function Piece:getColor() return self.color end
function Piece:getPosition() return self.position end
function Piece:getPngSize() return self.pngSize end
function Piece:getScale() return self.scale end
function Piece:getTexture() return self.texture end
function Piece:getStart() return self.start end
function Piece:getTile() return self.tile end
function Piece:getTileRow() return self.tile and self.tile:getRow() or -1 end
function Piece:getTileCol() return self.tile and self.tile:getCol() or -1 end
function Piece:getWidth() return self.width end
function Piece:getHeight() return self.height end
function Piece:getDragging() return self.dragging end
function Piece:getDragVelocity() return self.dragVelocity end
function Piece:getPlayerTopBottom() return self.playerTopBottom end

return Piece