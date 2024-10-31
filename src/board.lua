require("globals")
require("tile")

-- Board class
Board = {}
Board.__index = Board

local TOP = 1
local BOTTOM = -1

function Board:new()
  local instance = setmetatable({}, Board)
  -- Initialize board attributes
  instance.grid = {}
  instance.pieces = {}
  instance.offsetX = 0
  instance.offsetY = 0
  instance.tileSize = 0
  instance.rows = -1
  instance.cols = -1
  return instance
end

function Board:initializeBoard(rows, cols, player1, player2)
  -- Set up initial board state
  self.rows = rows
  self.cols = cols
  self.grid = {}
  local colors = {C[string.upper(player1.color)], C[string.upper(player2.color)]}

  for i = 1, rows do
    self.grid[i] = {}
    for j = 1, cols do
      -- Alternate colors based on the sum of the indices
      local colorIndex = (i + j) % 2 + 1
      self.grid[i][j] = Tile.new(colors[colorIndex])
    end
  end

  self.players = {player1, player2}

  self:draw()
  self:initializePieces()
end

function Board:draw()
  self:drawBoard()
  self:drawPieces()
end

function Board:initializePieces()
  -- Position all non-interactive players' pieces below the board
  for i, player in ipairs(self.players) do
    DebugPrint("BOARD", "Setting piece initial positions for player", i, player:getColor())

    -- Player 1 pieces are below the board, Player 2 pieces are above the board
    local topbottom_multiplier = TOP
    if i == 2 then
      topbottom_multiplier = BOTTOM
    end
    for index, piece in ipairs(player:getPieces()) do
      if not player.isInteractive then
        self:initializeInteractivePiece(piece, index, topbottom_multiplier)
      elseif not player.isInteractive and piece.position:isDefault() then
        self:initializeNonInteractivePiece(piece)
      end
    end
  end
end

function Board:initializeInteractivePiece(piece, index, topbottom)
  local position = {
    x = (index - 1) * self.tileSize + self.offsetX,
    y = self.offsetY + self.rows * self.tileSize + self.tileSize * PIECE_OFFSET * topbottom
  }
  DebugPrint("BOARD", "Setting piece initial position", position.x, position.y)
  piece:getPosition():set(position.x, position.y)
  piece:getOriginalPosition():set(position.x, position.y)
end

function Board:initializeNonInteractivePiece(piece, topbottom)
  local numRows = #self.grid
  local numCols = #self.grid[1]
  -- Piece starts indicates how far from the center column and top/bottom of the board the piece is
  local pieceStart = piece:getStart()
  local pieceColIndex = (math.floor(numCols/2)) + pieceStart.offsetX
  local pieceRowIndex = (topbottom == TOP) and pieceStart.offsetY or (numRows - pieceStart.offsetY)
  local tile = self.grid[pieceRowIndex][pieceColIndex]
  piece:getPosition():copy(tile:calculatePiecePosition())
  piece:getOriginalPosition():copy(piece:getPosition())
  tile:setPiece(piece)
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
    for j, tile in ipairs(row) do
      -- Draw the rectangle for the current tile
      love.graphics.setColor(tile:getColor())
      local tileTopLeftCorner = {x = self.offsetX + (j - 1) * self.tileSize, y = self.offsetY + (i - 1) * self.tileSize}
      tile:setTopLeftCorner(tileTopLeftCorner)
      tile:setTileSize(self.tileSize)
      love.graphics.rectangle("fill", tileTopLeftCorner.x, tileTopLeftCorner.y, self.tileSize, self.tileSize)
    end
  end
end

function Board:drawPieces()
  love.graphics.setColor(1, 1, 1) -- Reset color to white for pieces
  -- Draw the pieces
  for _, player in ipairs(self.players) do
    for _, piece in ipairs(player:getPieces()) do
      local position = piece:getPosition()
      love.graphics.draw(piece:getTexture(), position.x, position.y)
    end
  end
end 

function Board:update(dt)
  -- Update logic for dragging and dropping pieces
  for _, player in ipairs(self.players) do
    if player.isInteractive then
      for _, piece in ipairs(player:getPieces()) do
        if piece.isDragging then
          local mousePosition = love.mouse.getPosition()
          piece:getPosition():set(mousePosition.x, mousePosition.y)
        end
      end
    end
  end
end

function Board:mousepressed(x, y, button)
  if button == 1 then -- Left mouse button
    for _, player in ipairs(self.players) do
      if player.isInteractive then
        for _, piece in ipairs(player:getPieces()) do
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
        for _, piece in ipairs(player:getPieces()) do
          if piece.isDragging then
            piece.isDragging = false
            -- Check if the piece is dropped on a valid board position
            local boardX, boardY = self:getBoardPosition(x, y)
            if boardX > 0 and boardX <= #self.grid and boardY > 0 and boardY <= #self.grid[1] then
              local tile = self.grid[boardY][boardX]
              if self:isValidMove(piece, tile) then
                self:movePiece(piece, tile)
              else
                -- Reset to original position if not valid
                piece:resetPosition()
              end
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
  local piecePosition = piece:getPosition()
  local pieceX, pieceY = piecePosition.x, piecePosition.y
  return x >= pieceX and x <= pieceX + piece:getWidth() and y >= pieceY and y <= pieceY + piece:getHeight()
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

function Board:movePiece(piece, destTile)
  piece:getPosition():set(destTile:calculatePiecePosition())
  -- Remove piece from current tile
  if piece:getTile() then
    piece:getTile():setPiece(nil)
  end
  -- Set piece to new tile
  destTile:setPiece(piece)
end
