require("globals")
require("board")
require("player")
require("tools/util")

GameManager = {}
GameManager.__index = GameManager


function GameManager:new()
  local instance = setmetatable({}, GameManager)
  -- Initialize attributes
  instance.currentPlayer = nil
  instance.inactivePlayer = nil

  instance.gameState = "init"
  instance.board = Board:new()
  instance.players = {
    BOTTOM = Player:new(ReturnPlayerConfigFile("player_white"), BOTTOM),
    TOP = Player:new(ReturnPlayerConfigFile("pc_lvl1"), TOP)
  }

  return instance
end

function GameManager:startGame()
  self.currentPlayer = self.players.BOTTOM
  self.inactivePlayer = self.players.TOP
  self.board:initialize(8, 8, self.currentPlayer, self.inactivePlayer)
  self.gameState = "playing"
end

function GameManager:update(dt)
  if self.gameState == "playing" then
    self.board:update(dt)
  end
end

function GameManager:draw()
  self.board:draw()
end

function GameManager:keypressed(key)
  if key == "space" then
    self:switchTurn()
  end
end

function GameManager:switchTurn()
  self.currentPlayer = self.players[self.inactivePlayer]
  self.inactivePlayer = self.players[self.currentPlayer]
end

function GameManager:mousepressed(x, y, button)
  -- If the game is in playing state, pass the mouse press to the board
  if self.gameState == "playing" then
    self.board:mousepressed(x, y, button)
  end
end

function GameManager:mousemoved(x, y)
  -- If the game is in playing state, pass the mouse move to the board
  if self.gameState == "playing" then
    self.board:mousemoved(x, y)
  end
end

function GameManager:mousereleased(x, y, button)
  -- If the game is in playing state, pass the mouse release to the board
  if self.gameState == "playing" then
    self.board:mousereleased(x, y, button)
  end
end

