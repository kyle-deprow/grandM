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
function TileHolder.new(maxPieces, topbottom, boardOffsetX, boardOffsetY, boardWidth, boardTileSize)
  local instance = setmetatable({}, TileHolder)
  instance.maxPieces = maxPieces
  instance.topbottom = topbottom
  instance.tiles = {}
  instance:setBoardParameters(boardOffsetX, boardOffsetY, boardWidth, boardTileSize)
  instance:initializeTiles()
  return instance
end

function TileHolder:setBoardParameters(boardOffsetX, boardOffsetY, boardWidth, boardTileSize)
  self.holderWidth = self.maxPieces * boardTileSize
  -- Center the holder on the board and then push left corner over half the holder width
  self.holderOffsetX = (boardOffsetX + boardWidth / 2) - self.holderWidth / 2

  -- Center holder above or below the board depending on the position and account for the tile size
  -- If above account for the tile size when drawing the top corner
  self.holderOffsetY = (self.topbottom == TOP) and boardOffsetY - (TILE_HOLDER_OFFSET_Y_FACTOR * boardTileSize) - boardTileSize or
    (boardOffsetY + boardWidth) + TILE_HOLDER_OFFSET_Y_FACTOR * boardTileSize

  self.boardWidth = boardWidth
  self.tileSize = boardTileSize
end

function TileHolder:reset(boardOffsetX, boardOffsetY, boardWidth, boardTileSize)
  self:setBoardParameters(boardOffsetX, boardOffsetY, boardWidth, boardTileSize)
  self:resetTiles()
end

function TileHolder:initializeTiles()
  -- Create tiles
  for i = 1, self.maxPieces do
    local tile = Tile.new(C.PURPLE)
    tile:setTileSize(self.tileSize)
    tile:setTopLeftCorner(Position.new(
      self.holderOffsetX + (i-1) * self.tileSize,
      self.holderOffsetY
    ))
    table.insert(self.tiles, tile)
  end
end

function TileHolder:resetTiles()
  -- Reset tiles positions
  for i, tile in ipairs(self.tiles) do
    tile:reset(self.tileSize, self.holderOffsetX + (i-1) * self.tileSize, self.holderOffsetY)
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