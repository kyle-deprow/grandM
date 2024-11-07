require("tools.util")

local TILE_CORRECTION = 0.025

-- Tile class to represent a single tile on the board
Tile = {}
Tile.__index = Tile

-- Constructor for new Tile
-- @param color: initial color of the tile (string)
-- @param piece: initial piece on the tile (can be nil)
function Tile.new(color, row, col)
  local instance = setmetatable({}, Tile)
  instance.color = color
  instance.piece = nil
  instance.leftTopCorner = Position.new(0, 0)
  instance.tileSize = 0
  instance.row = row
  instance.col = col
  instance.isInvalid = false
  -- Copy the color for invalid shade and change the alpha
  instance.invalidShade = {instance.color[1], instance.color[2], instance.color[3], INVALID_TILE_ALPHA}
  return instance
end

function Tile:draw()
  DebugPrint("Tile", "Drawing tile at ", self.leftTopCorner, "valid", self.isInvalid)
  if not self.isInvalid then
    love.graphics.setColor(self.color)
  else
    love.graphics.setColor(self.invalidShade)
  end
  love.graphics.rectangle("fill", self.leftTopCorner.x, self.leftTopCorner.y, self.tileSize, self.tileSize)
end

function Tile:reset(tileSize, topLeftCornerX, topLeftCornerY)
  self.tileSize = tileSize
  self.leftTopCorner:setXY(topLeftCornerX, topLeftCornerY)
  if self:hasPiece() then
    self.piece:reset(self:calculatePiecePosition())
    self.piece:calculateScale(self.tileSize)
  end
end

function Tile:calculatePiecePosition()
  local x = self.leftTopCorner.x + self.tileSize * TILE_CORRECTION
  local y = self.leftTopCorner.y + self.tileSize * TILE_CORRECTION
  return Position.new(x, y)
end

function Tile:hasPiece()
    return self.piece ~= nil
end

function Tile:getColor()
  return self.color
end

function Tile:getPiece()
  return self.piece
end

function Tile:getTopLeftCorner()
  return self.leftTopCorner
end

function Tile:getTileSize()
  return self.tileSize
end

function Tile:getRow()
  return self.row
end

function Tile:getCol()
  return self.col
end

function Tile:setPiece(piece)
    self.piece = piece
end

function Tile:setColor(color)
  self.color = color
end

function Tile:setTopLeftCorner(topLeftCorner)
  self.leftTopCorner = topLeftCorner
end

function Tile:setTileSize(tileSize)
  self.tileSize = tileSize
end

function Tile:setIsInvalid(isInvalid)
  self.isInvalid = isInvalid
end

return Tile