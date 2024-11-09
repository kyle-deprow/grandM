-- TileTranslation utility class for managing tile movement parameters
TileTranslation = {}
TileTranslation.__index = TileTranslation

-- Constructor
function TileTranslation.new(sourcePos, destinationPos, boardRows, boardCols, sourceTile, destinationTile)
  local self = setmetatable({}, TileTranslation)
  self.source = sourcePos or Position.new(0, 0)
  self.destination = destinationPos or Position.new(0, 0)
  self.boardRows = boardRows or 0
  self.boardCols = boardCols or 0
  self.sourceTile = sourceTile or nil
  self.destinationTile = destinationTile or nil

  -- Calculate differences
  self.difference = self.destination - self.source

  return self
end

-- Copy constructor
function TileTranslation:copy(trans)
    self.source:copy(trans.source)
    self.destination:copy(trans.destination)
    self.difference:copy(trans.difference)
    self.boardRows = trans.boardRows
    self.boardCols = trans.boardCols
    self.sourceTile = trans.sourceTile
    self.destinationTile = trans.destinationTile
end

function TileTranslation:rotate()
  -- Rotate 180 degrees by flipping coordinates relative to board dimensions
  -- For rows: newRow = boardRows - 1 - oldRow
  -- For cols: newCol = boardCols - 1 - oldCol
  self.destination:setXY(self.boardRows - 1 - self.destination:getX(),
                         self.boardCols - 1 - self.destination:getY())
  self.source:setXY(self.boardRows - 1 - self.source:getX(),
                    self.boardCols - 1 - self.source:getY())
  self:updateDiffs()
end

-- String representation metamethod (useful for debugging)
TileTranslation.__tostring = function(self)
  return string.format("TileTranslation(source=(%d,%d), destination=(%d,%d), difference=(%d,%d), board=(%d,%d))",
    self.source:getX(), self.source:getY(),
    self.destination:getX(), self.destination:getY(),
    self.difference:getX(), self.difference:getY(),
    self.boardRows, self.boardCols)
end

-- Getters
function TileTranslation:getSource() return self.source end
function TileTranslation:getDestination() return self.destination end
function TileTranslation:getBoardRows() return self.boardRows end
function TileTranslation:getBoardCols() return self.boardCols end
function TileTranslation:getDifference() return self.difference end
function TileTranslation:getSourceTile() return self.sourceTile end
function TileTranslation:getDestinationTile() return self.destinationTile end
function TileTranslation:getDifferenceRow() return self.difference:getX() end
function TileTranslation:getDifferenceCol() return self.difference:getY() end

-- Setters
function TileTranslation:setSourcePosition(row, col)
  self.source:set(row, col)
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
  self.difference = self.destination - self.source
end

return TileTranslation