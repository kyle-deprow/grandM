require("globals")
require("tileholder")
require("tile")

-- Board class
Board = {}
Board.__index = Board

function Board:new()
  local instance = setmetatable({}, Board)
  -- Initialize board attributes
  instance.gridTiles = {}
  instance.tileHolders = {BOTTOM = {}, TOP = {}}
  instance.players = {BOTTOM = nil, TOP = nil}
  instance.pieces = {}
  instance.offsetX = 0
  instance.offsetY = 0
  instance.tileSize = 0
  instance.rows = -1
  instance.cols = -1
  instance.windowWidth = 0
  instance.windowHeight = 0
  instance.totalBoardWidth = 0
  instance.totalBoardHeight = 0
  return instance
end

function Board:initialize(rows, cols, player1, player2)
  -- Set up initial board state
  self.rows = rows
  self.cols = cols
  self.gridTiles = {}
  self.players = {BOTTOM = player1, TOP = player2}
  DebugPrint("BOARD", "Initializing board", self.players.BOTTOM:getColor(), self.players.TOP:getColor())
  self.tileHolders = {BOTTOM = {}, TOP = {}}

  self:initializeBoard()
  self:initializeTileHolders()
  self:initializePieces()
end

function Board:calculateBoardParameters()
  self.windowWidth, self.windowHeight = love.graphics.getDimensions()
  self.tileSize = math.min(self.windowWidth / self.cols, self.windowHeight / self.rows)*BOARD_SCALING_FACTOR

  -- Calculate offsets to center the board
  self.totalBoardWidth = self.cols * self.tileSize
  self.totalBoardHeight = self.rows * self.tileSize
  self.offsetX = (self.windowWidth - self.totalBoardWidth) / 2
  self.offsetY = (self.windowHeight - self.totalBoardHeight) / 2
end

-- Initialize the board with tiles, calculate tile sizes, and offsets
-- This is done before pieces are initialized so that the board can be centered
-- and the tile holders can be initialized in the correct position
function Board:initializeBoard()
  local colors = {C[self.players.BOTTOM:getColor()], C[self.players.TOP:getColor()]}

  self:calculateBoardParameters()
  for i = 1, self.rows do
    self.gridTiles[i] = {}
    for j = 1, self.cols do
      -- Alternate colors based on the sum of the indices
      local colorIndex = (i + j) % 2 + 1
      self.gridTiles[i][j] = Tile.new(colors[colorIndex])
      -- Set the top left corner position of the tile using offsets and indices
      self.gridTiles[i][j]:reset(self.tileSize, self.offsetX + (j - 1) * self.tileSize, self.offsetY + (i - 1) * self.tileSize)
    end
  end
end

-- Initialize the tile holders for each player
-- Tile holders are the constructs that hold the pieces that are held off the board by the players
-- They are initialized in the correct position with empty transparent Tiles and will be loaded during Piece initialization
function Board:initializeTileHolders()
  for position, player in pairs(self.players) do
    self.tileHolders[position] = TileHolder.new(player:getMaxPieces(),
      position, self.offsetX, self.offsetY, self.totalBoardHeight, self.tileSize)
  end
end

-- Initialize the pieces on the board
-- There are two types of initialization routines for pieces: tile holders and board
-- Tile holder pieces are pieces held off the board to be moved onto the board by the player
-- Board pieces are pieces that already start on a board tile and cannot be moved until the game starts
function Board:initializePieces()
  -- Position all non-interactive players' pieces below the board
  for position, player in pairs(self.players) do
    DebugPrint("BOARD", "Initializing pieces for player", position, player:getColor(), "length", #player:getPieces())
    for _, piece in ipairs(player:getPieces()) do
      piece:calculateScale(self.tileSize)
      DebugPrint("BOARD", "Initializing piece", piece:getId(), "position", piece.position, "scale", piece.scale, "tileSize", self.tileSize)
      if player:getIsInteractive() then
        self:initializeTileHolderPiece(piece, position)
      elseif not player:getIsInteractive() and piece.position:isDefault() then
        self:initializeBoardPiece(piece, position)
      end
    end
  end
end

function Board:initializeTileHolderPiece(piece, position)
  self.tileHolders[position]:addPiece(piece)
end

function Board:initializeBoardPiece(piece, position)
  -- Piece starts indicates how far from the center column and top/bottom of the board the piece is
  DebugPrint("BOARD", "Initializing board piece", piece:getId(), "for player", position)
  local pieceStart = piece:getStart()
  local pieceColIndex = (math.floor(self.cols/2)) + pieceStart.offsetX
  local pieceRowIndex = (position == "TOP") and pieceStart.offsetY or (self.rows - pieceStart.offsetY)
  local tile = self.gridTiles[pieceRowIndex + 1][pieceColIndex + 1]
  piece:getPosition():copy(tile:calculatePiecePosition())
  piece:getOriginalPosition():copy(piece:getPosition())
  tile:setPiece(piece)
end

function Board:draw()
  if self:checkIfWindowSizeChanged() then
    self:calculateBoardParameters()
    self:resetBoard()
    self:resetTileHolders()
  end
  self:drawBoard()
  self:drawTileHolders()
end

function Board:checkIfWindowSizeChanged()
  local windowWidth, windowHeight = love.graphics.getDimensions()
  if windowWidth ~= self.windowWidth or windowHeight ~= self.windowHeight then
    return true
  end
  return false
end

function Board:resetBoard()
  self:calculateBoardParameters()
  for i, row in ipairs(self.gridTiles) do
    for j, tile in ipairs(row) do
      tile:reset(self.tileSize, self.offsetX + (j - 1) * self.tileSize, self.offsetY + (i - 1) * self.tileSize)
    end
  end
end

function Board:resetTileHolders()
  for _, tileHolder in pairs(self.tileHolders) do
    tileHolder:reset(self.offsetX, self.offsetY, self.totalBoardWidth, self.tileSize)
  end
end

function Board:drawBoard()
  for _, row in ipairs(self.gridTiles) do
    for _, tile in ipairs(row) do
      -- Draw the rectangle for the current tile
      tile:draw()
    end
  end
end

function Board:drawTileHolders()
  for position, tileHolder in pairs(self.tileHolders) do
    tileHolder:draw()
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
