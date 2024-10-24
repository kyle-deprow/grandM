require("globals")

-- Board class
Board = {}
Board.__index = Board

function Board:new()
  local instance = setmetatable({}, Board)
  -- Initialize board attributes
  instance.grid = {}
  instance.pieces = {}
  return instance
end

function Board:initializeBoard(rows, cols, colors)
  -- Set up initial board state
  self.grid = {}

  for i = 1, rows do
    self.grid[i] = {}
    for j = 1, cols do
      -- Alternate colors based on the sum of the indices
      local colorIndex = (i + j) % 2 + 1
      self.grid[i][j] = colors[colorIndex]
    end
  end
end

function Board:draw()
  local windowWidth, windowHeight = love.graphics.getDimensions()
  local numRows = #self.grid
  local numCols = #self.grid[1]
  local scalingFactor = 0.80
  local tileSize = math.min(windowWidth / numCols, windowHeight / numRows)*scalingFactor

  -- Calculate offsets to center the board
  local totalBoardWidth = numCols * tileSize
  local totalBoardHeight = numRows * tileSize
  local offsetX = (windowWidth - totalBoardWidth) / 2
  local offsetY = (windowHeight - totalBoardHeight) / 2

  -- Draw the board and pieces
  for i, row in ipairs(self.grid) do
    for j, color in ipairs(row) do
      -- Draw the rectangle for the current tile
      love.graphics.setColor(color)
      love.graphics.rectangle("fill", offsetX + (j - 1) * tileSize, offsetY + (i - 1) * tileSize, tileSize, tileSize)
    end
  end
  -- Reset color to default
  love.graphics.setColor(1, 1, 1)
end