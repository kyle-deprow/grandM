require("globals")

-- Board class
Board = {}
Board.__index = Board

function Board:new()
  local instance = setmetatable({}, Board)
  -- Initialize board attributes
  instance.grid = {}
  instance.pieces = {}
  instance.offsetX = 0
  instance.offsetY = 0
  instance.tileSize = 0
  return instance
end

function Board:initializeBoard(rows, cols, player1, player2)
  -- Set up initial board state
  self.grid = {}
  local colors = {player1.color, player2.color}

  for i = 1, rows do
    self.grid[i] = {}
    for j = 1, cols do
      -- Alternate colors based on the sum of the indices
      local colorIndex = (i + j) % 2 + 1
      self.grid[i][j] = colors[colorIndex]
    end
  end

  self.players = {player1, player2}

  self:initializePieces()
  self:draw()
end

function Board:draw()
  self:drawBoard()
  self:drawPieces()
end

function Board:initializePieces()
  -- Position all non-interactive players' pieces below the board
  for i, player in ipairs(self.players) do
    -- Player 1 pieces are below the board, Player 2 pieces are above the board
    local topbottom_multiplier = 1
    if i == 2 then
      topbottom_multiplier = -1
    end

    for index, piece in ipairs(player.getPieces()) do
      if not player.isInteractive then
        piece.position = {
          x = (index - 1) * self.tileSize + self.offsetX,
          y = self.offsetY + rows * self.tileSize + self.tileSize * PIECE_OFFSET * topbottom_multiplier
        }
        piece.setOriginalPosition(piece.position)
      end
    end
  end
end

function Board:drawBoard()
  local windowWidth, windowHeight = love.graphics.getDimensions()
  local numRows = #self.grid
  local numCols = #self.grid[1]
  local scalingFactor = 0.80
  self.tileSize = math.min(windowWidth / numCols, windowHeight / numRows)*scalingFactor

  -- Calculate offsets to center the board
  local totalBoardWidth = numCols * self.tileSize
  local totalBoardHeight = numRows * self.tileSize
  self.offsetX = (windowWidth - totalBoardWidth) / 2
  self.offsetY = (windowHeight - totalBoardHeight) / 2

  for i, row in ipairs(self.grid) do
    for j, color in ipairs(row) do
      -- Draw the rectangle for the current tile
      love.graphics.setColor(color)
      love.graphics.rectangle("fill", self.offsetX + (j - 1) * self.tileSize, self.offsetY + (i - 1) * self.tileSize, self.tileSize, self.tileSize)
    end
  end
end

function Board:drawPieces()
  love.graphics.setColor(1, 1, 1) -- Reset color to white for pieces
  -- Draw the pieces
  for _, player in ipairs(self.players) do
    for _, piece in ipairs(player.getPieces()) do
      love.graphics.draw(piece.texture, piece.position.x, piece.position.y)
    end
  end
end 

function Board:update(dt)
  -- Update logic for dragging and dropping pieces
  for _, player in ipairs(self.players) do
    if player.isInteractive then
      for _, piece in ipairs(player.getPieces()) do
        if piece.isDragging then
          piece.position.x, piece.position.y = love.mouse.getPosition()
        end
      end
    end
  end
end

function Board:mousepressed(x, y, button)
  if button == 1 then -- Left mouse button
    for _, player in ipairs(self.players) do
      if player.isInteractive then
        for _, piece in ipairs(player.getPieces()) do
          if self.isMouseOverPiece(piece, x, y) then
            piece.isDragging = true
            break
          end
        end
      end
    end
  end
end

function Board:mousereleased(x, y, button)
  if button == 1 then -- Left mouse button
    for _, player in ipairs(self.players) do
      if player.isInteractive then
        for _, piece in ipairs(player.getPieces()) do
          if piece.isDragging then
            piece.isDragging = false
            -- Check if the piece is dropped on a valid board position
            local boardX, boardY = self:getBoardPosition(x, y)
            if self:isValidMove(piece, boardX, boardY) then
              piece.setPosition({x = boardX, y = boardY})
            else
              -- Reset to original position if not valid
              piece.resetPosition()
            end
            break
          end
        end
      end
    end
  end
end

function Board:isMouseOverPiece(piece, x, y)
  -- Check if the mouse is over the piece
  local pieceX, pieceY = piece.position.x, piece.position.y
  return x >= pieceX and x <= pieceX + piece.width and y >= pieceY and y <= pieceY + piece.height
end

function Board:getBoardPosition(x, y)
  -- Convert screen coordinates to board coordinates
  local boardX = math.floor((x - self.offsetX) / self.tileSize) + 1
  local boardY = math.floor((y - self.offsetY) / self.tileSize) + 1
  return boardX, boardY
end

function Board:isValidMove(piece, x, y)
  -- Implement logic to check if the move is valid
  return true -- Placeholder, implement actual logic
end