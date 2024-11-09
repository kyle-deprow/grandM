require("globals")
require("tileholder")
require("tile")

-- Board class
Board = {}
Board.__index = Board

function Board:new(gameManager)
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
  instance.gameManager = gameManager
  instance.eventBus = gameManager:getEventBus()
  return instance
end

function Board:initialize(rows, cols, player1, player2)
  -- Set up initial board state
  self.rows = rows
  self.cols = cols
  self.gridTiles = {}
  self.players = {BOTTOM = player1, TOP = player2}
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
      self.gridTiles[i][j] = Tile.new(colors[colorIndex], i, j)
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
    for _, piece in ipairs(player:getPieces()) do
      piece:calculateScale(self.tileSize)
      piece:getDragVelocity():zero()
      piece:setBoard(self)
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
  piece:setBoard(self)
end

function Board:initializeBoardPiece(piece, position)
  -- Piece starts indicates how far from the center column and top/bottom of the board the piece is
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
  -- Draw static pieces first so they are behind the dragging pieces
  self:drawStaticPieces()
  self:drawDraggingPieces()
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
      tile:setIsInvalid(false)
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

function Board:drawStaticPieces()
  for position, player in pairs(self.players) do
    for _, piece in ipairs(player:getPieces()) do
      if not piece:getDragging() then
        piece:draw()
      end
    end
  end
end

function Board:drawDraggingPieces()
  for position, player in pairs(self.players) do
    for _, piece in ipairs(player:getPieces()) do
      if piece:getDragging() then
        piece:draw()
      end
    end
  end
end

function Board:update(dt)
  -- Update logic for dragging and dropping pieces
  if self.draggingPiece then
    self.draggingPiece:updateDragging(Position.new(love.mouse.getPosition()), dt)
  end
end

function Board:mousepressed(x, y, button)
  if button == LEFT_CLICK then
    for position, player in pairs(self.players) do
      if player:getIsInteractive() then
        for _, piece in ipairs(player:getPieces()) do
          if self:isMouseOverPiece(piece, x, y) then
            piece:setDragging(true)
            self.draggingPiece = piece
            self:updateTileValidShading()
            break
          end
        end
      end
    end
  end
end

function Board:mousereleased(x, y, button)
  if button == LEFT_CLICK then
    if self.draggingPiece then
      self.draggingPiece:setDragging(false)
      -- Check if the piece is dropped on a valid board position
      local boardX, boardY = self:getBoardPosition(x, y)
      if self:isMouseOverBoard(boardX, boardY) then
        local tile = self.gridTiles[boardY][boardX]
        if self:isValidMove(self.draggingPiece, tile) then
          self:movePiece(self.draggingPiece, tile)
        else
          -- Reset to original position if not valid move tile
          self.draggingPiece:resetToOriginalPosition()
        end
      else
        -- Reset to original position if placed off the board
        self.draggingPiece:resetToOriginalPosition()
      end
      self.draggingPiece = nil
      self:clearTileShading()

      if self:getGameState() == VALID_GAME_STATES.INITIALIZE then
        -- Check if tileholder is empty and switch to in progress if so
        if self.tileHolders.BOTTOM:isEmpty() and self.tileHolders.TOP:isEmpty() then
          self.eventBus:publish("GAME_STATE_CHANGE", GameStateChange.new({newState = VALID_GAME_STATES.IN_PROGRESS, triggeredBy = "BOARD"}))
        end
      end
    end
  end
end

function Board:mousemoved(x, y)
  -- Update the mouse position
  --self.mouseX, self.mouseY = x, y
end

function Board:isMouseOverBoard(boardX, boardY)
  return boardX > 0 and boardX <= self.cols and boardY > 0 and boardY <= self.rows
end

function Board:isMouseOverPiece(piece, x, y)
  -- Check if the mouse is over the piece
  local piecePosition = piece:getPosition()
  local pieceX, pieceY = piecePosition.x, piecePosition.y
  return x >= pieceX and x <= pieceX + piece:getWidth() and y >= pieceY and y <= pieceY + piece:getHeight()
end

function Board:isTileOccupied(row, col)
  return self.gridTiles[row][col]:hasPiece()
end

function Board:getBoardPosition(x, y)
  -- Convert screen coordinates to board coordinates
  local boardX = math.floor((x - self.offsetX) / self.tileSize) + 1
  local boardY = math.floor((y - self.offsetY) / self.tileSize) + 1
  return boardX, boardY
end

function Board:isValidMove(piece, destTile)
  -- If the piece is initialized, it is on the board and can move
  if self:getGameState() == VALID_GAME_STATES.INITIALIZE then
    local translation = TileTranslation.new(
      Position.new(piece:getTileRow(), piece:getTileCol()),
      Position.new(destTile:getRow(), destTile:getCol()),
      self.rows, self.cols, piece:getTile(), destTile
    )
    return piece:validateMove(translation)
  -- If game is in progress, pieces are on the board and can move
  else
    -- If the destination tile is occupied, the placement is not valid
    if destTile:hasPiece() then
      return false
    end

    local translation = TileTranslation.new(
      Position.new(-1, -1),
      Position.new(destTile:getRow(), destTile:getCol()),
      self.rows, self.cols, nil, destTile
    )
    return piece:validatePlacement(translation)
  end
end

function Board:updateTileValidShading()
  -- Shade all tiles based on valid moves
  for i = 1, self.rows do
    for j = 1, self.cols do
      local tile = self.gridTiles[i][j]
      if self:isValidMove(self.draggingPiece, tile) then
        tile:setIsInvalid(false)  -- No shading for valid moves
      else
        tile:setIsInvalid(true)   -- Shade invalid moves
      end
    end
  end
end 

function Board:clearTileShading()
  for i = 1, self.rows do
    for j = 1, self.cols do
      self.gridTiles[i][j]:setIsInvalid(false)
    end
  end
end

function Board:movePiece(piece, destTile)
  -- Set piece position to new tile position and zero out velocity
  piece:getPosition():copy(destTile:calculatePiecePosition())
  piece:getOriginalPosition():copy(piece:getPosition())

  -- Remove piece from current tile
  if piece:getTile() then
    piece:getTile():setPiece(nil)
  end
  -- Set piece to new tile
  destTile:setPiece(piece)
  piece:setTile(destTile)
end

function Board:getGameManager()
  return self.gameManager
end

function Board:getGameState()
  return self.gameManager:getGameState()
end
