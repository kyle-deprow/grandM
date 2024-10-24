require("globals")
require("board")
require("player")

GameManager = {}
GameManager.__index = GameManager


function GameManager:new()
  local instance = setmetatable({}, GameManager)
  -- Initialize attributes
  instance.currentPlayer = nil
  instance.inactivePlayer = nil

  instance.gameState = "init"
  instance.board = Board:new()
  instance.players = {Player:new(C.WHITE), Player:new(C.BLACK)}
  return instance
end

function GameManager:startGame()
  self.currentPlayer = self.players[1]
  self.inactivePlayer = self.players[2]
  self.board:initializeBoard(8, 8, {self.currentPlayer.color, self.inactivePlayer.color})
  self.gameState = "playing"
end

function GameManager:update(dt)
  -- Update game logic
  if self.gameState == "playing" then
    -- Handle game updates
  end
end

function GameManager:draw()
  -- Draw the board and pieces
  self.board:draw()
end

function GameManager:keypressed(key)
  -- Handle key input
  if key == "space" then
    -- Example: switch turns
    self:switchTurn()
  end
end

function GameManager:switchTurn()
  self.currentPlayer = self.players[self.inactivePlayer]
  self.inactivePlayer = self.players[self.currentPlayer]
end