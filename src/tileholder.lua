require("tools/util")
require("tile")

-- TileHolder class to represent a row of tiles for holding pieces
TileHolder = {}
TileHolder.__index = TileHolder

-- Constructor for new TileHolder
-- @param maxPieces: maximum number of pieces this holder can contain
-- @param position: TOP or BOTTOM position relative to board
-- @param boardWidth: width of the game board (for centering)
-- @param tileSize: size of each tile
function TileHolder.new(maxPieces, position, boardWidth, tileSize)
  local instance = setmetatable({}, TileHolder)
  instance.maxPieces = maxPieces
  instance.position = position
  instance.tiles = {}
  instance.tileSize = tileSize
  instance.boardWidth = boardWidth
  instance:initializeTiles()
  return instance
end

function TileHolder:initializeTiles()
  -- Calculate starting X position to center the holder
  local holderWidth = self.maxPieces * self.tileSize
  local startX = (self.boardWidth - holderWidth) / 2

  -- Calculate Y position based on position (TOP/BOTTOM)
  local startY = (self.position == TOP) and -self.tileSize * 1.5 or (self.boardWidth + self.tileSize * 0.5)

  -- Create tiles
  for i = 1, self.maxPieces do
    local tile = Tile.new(C.PURPLE)
    tile:setTileSize(self.tileSize)
    tile:setTopLeftCorner(Position.new(
      startX + (i-1) * self.tileSize,
      startY
    ))
    table.insert(self.tiles, tile)
  end
end

function TileHolder:reset(position, tileSize, boardWidth)
  self.position = position
  self.tiles = {}
  self.tileSize = tileSize
  self.boardWidth = boardWidth
  self:resetTiles()
end

function TileHolder:resetTiles()
  -- Calculate starting X position to center the holder
  local holderWidth = self.maxPieces * self.tileSize
  local startX = (self.boardWidth - holderWidth) / 2

  -- Calculate Y position based on position (TOP/BOTTOM)
  local startY = (self.position == TOP) and -self.tileSize * 1.5 or (self.boardWidth + self.tileSize * 0.5)

  -- Reset tiles positions
  for i, tile in ipairs(self.tiles) do
    tile:reset(self.tileSize, startX + (i-1) * self.tileSize, startY)
  end
end

-- Add a piece to the first available tile
-- @param piece: the piece to add
-- @return boolean: true if piece was added, false if holder is full
function TileHolder:addPiece(piece)
  for _, tile in ipairs(self.tiles) do
    if not tile:hasPiece() then
      tile:setPiece(piece)
      -- Update piece position based on tile
      local piecePos = tile:calculatePiecePosition()
      piece:getPosition():copy(piecePos)
      piece:getOriginalPosition():copy(piecePos)
      return true
    end
  end
  return false
end

-- Remove a piece from a specific tile
-- @param piece: the piece to remove
-- @return boolean: true if piece was removed, false if piece not found
function TileHolder:removePiece(piece)
  for _, tile in ipairs(self.tiles) do
    if tile:getPiece() == piece then
      tile:setPiece(nil)
      return true
    end
  end
  return false
end

-- Get piece at specific position
-- @param x,y: screen coordinates
-- @return piece: the piece at the position, or nil if no piece
function TileHolder:getPieceAtPosition(x, y)
  for _, tile in ipairs(self.tiles) do
    local corner = tile:getTopLeftCorner()
    local size = tile:getTileSize()

    -- Check if coordinates are within tile bounds
    if x >= corner:getX() and x <= corner:getX() + size and
      y >= corner:getY() and y <= corner:getY() + size then
      return tile:getPiece()
    end
  end
  return nil
end

-- Draw the tile holder and its pieces
function TileHolder:draw()
  for _, tile in ipairs(self.tiles) do
    tile:draw()

    -- Draw piece if present
    if tile:hasPiece() then
      local piece = tile:getPiece()
      piece:draw()
    end
  end
end

-- Get all pieces currently in the holder
function TileHolder:getPieces()
  local pieces = {}
  for _, tile in ipairs(self.tiles) do
    if tile:hasPiece() then
      table.insert(pieces, tile:getPiece())
    end
  end
  return pieces
end

return TileHolder