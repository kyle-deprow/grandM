-- TileTranslation utility class for managing tile movement parameters
TileTranslation = {}
TileTranslation.__index = TileTranslation

-- Constructor
function TileTranslation.new(currentPos, destPos, boardRows, boardCols, currentTile, destTile)
  local self = setmetatable({}, TileTranslation)
  self.current = currentPos or Position.new(0, 0)
  self.destination = destPos or Position.new(0, 0)
  self.boardRows = boardRows or 0
  self.boardCols = boardCols or 0
  self.currentTile = currentTile or nil
  self.destTile = destTile or nil

  -- Calculate differences
  self.difference = self.destination - self.current

  return self
end

-- Copy constructor
function TileTranslation:copy(trans)
    self.current:copy(trans.current)
    self.destination:copy(trans.destination)
    self.difference:copy(trans.difference)
    self.boardRows = trans.boardRows
    self.boardCols = trans.boardCols
    self.currentTile = trans.currentTile
    self.destTile = trans.destTile
end

function TileTranslation:rotate()
  -- Rotate 180 degrees by flipping coordinates relative to board dimensions
  -- For rows: newRow = boardRows - 1 - oldRow
  -- For cols: newCol = boardCols - 1 - oldCol
  self.destination:setXY(self.boardRows - 1 - self.destination:getX(),
                         self.boardCols - 1 - self.destination:getY())
  self.current:setXY(self.boardRows - 1 - self.current:getX(),
                     self.boardCols - 1 - self.current:getY())
  self:updateDiffs()
end

-- String representation metamethod (useful for debugging)
TileTranslation.__tostring = function(self)
  return string.format("TileTranslation(current=(%d,%d), dest=(%d,%d), diff=(%d,%d), board=(%d,%d))",
    self.current:getX(), self.current:getY(),
    self.destination:getX(), self.destination:getY(),
    self.difference:getX(), self.difference:getY(),
    self.boardRows, self.boardCols)
end

-- Getters
function TileTranslation:getCurrent() return self.current end
function TileTranslation:getDestination() return self.destination end
function TileTranslation:getBoardRows() return self.boardRows end
function TileTranslation:getBoardCols() return self.boardCols end
function TileTranslation:getDifference() return self.difference end
function TileTranslation:getCurrentTile() return self.currentTile end
function TileTranslation:getDestinationTile() return self.destTile end
function TileTranslation:getDifferenceRow() return self.difference:getX() end
function TileTranslation:getDifferenceCol() return self.difference:getY() end

-- Setters
function TileTranslation:setCurrentPosition(row, col)
  self.current:set(row, col)
  self:updateDiffs()
end

function TileTranslation:setDestination(row, col)
  self.destination:set(row, col)
  self:updateDiffs()
end

function TileTranslation:setBoardDimensions(rows, cols)
  self.boardRows = rows
  self.boardCols = cols
end

-- Update the difference calculations
function TileTranslation:updateDiffs()
  self.difference = self.destination - self.current
end

return TileTranslation