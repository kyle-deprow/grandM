require("tools.util")

-- Tile class to represent a single tile on the board
Tile = {}
Tile.__index = Tile

-- Constructor for new Tile
-- @param color: initial color of the tile (string)
-- @param piece: initial piece on the tile (can be nil)
function Tile.new(color)
  local instance = setmetatable({}, Tile)
  instance.color = color
  instance.piece = nil
  instance.leftTopCorner = Position.new(0, 0)
  instance.tileSize = 0
  return instance
end


function Tile:calculatePiecePosition()
  local x = self.leftTopCorner.x + self.tileSize * 0.5
  local y = self.leftTopCorner.y + self.tileSize * 0.2
  return Position.new(x, y)
end

-- Getter for tile color
function Tile:getColor()
  return self.color
end

-- Getter for piece
function Tile:getPiece()
  return self.piece
end


-- Getter for tile top left corner
function Tile:getTopLeftCorner()
  return self.leftTopCorner
end

-- Getter for tile size
function Tile:getTileSize()
  return self.tileSize
end

-- Setter for piece
function Tile:setPiece(piece)
    self.piece = piece
end

-- Setter for tile color
function Tile:setColor(color)
  self.color = color
end

-- Setter for tile top left corner
function Tile:setTopLeftCorner(topLeftCorner)
  self.leftTopCorner = topLeftCorner
end

-- Setter for tile size
function Tile:setTileSize(tileSize)
  self.tileSize = tileSize
end

-- Check if tile has a piece
function Tile:hasPiece()
    return self.piece ~= nil
end

return Tile