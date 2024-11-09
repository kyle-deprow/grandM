require("globals")
require("board")
require("player")

require("tools/util")
require("tools/eventbus")
require("events/gamestatechange")
--require("events/piecechange")

GameManager = {}
GameManager.__index = GameManager


function GameManager:new()
  local instance = setmetatable({}, GameManager)
  -- Initialize attributes
  instance.currentPlayer = nil
  instance.inactivePlayer = nil

  instance.gameState = VALID_GAME_STATES.START_SCREEN

  instance.eventBus = EventBus:new()
  instance:registerEventHandlers()

  -- TODO: Immediately initialize the game
  instance:handleGameStateChange(GameStateChange.new({newState = VALID_GAME_STATES.INITIALIZE,
                                                      player = {TOP = "pc_lvl1", BOTTOM = "player_white"}}))

  return instance
end

function GameManager:registerEventHandlers()
  -- Register event handlers with callback functions
  self.eventBus:subscribe("PIECE_ATTRIBUTE_CHANGE", function(pieceChange)
    self:handlePieceAttributeChange(pieceChange)
  end)

  -- self.eventBus:subscribe("GAME_STATE_CHANGE", function(gameStateChange)
  --   self:handleGameStateChange(gameStateChange)
  -- end)
end

-- function GameManager:handlePieceAttributeChange(pieceChange)
--   -- Handle piece attribute changes
--   if pieceChange.attributeName == "captured" and pieceChange.newValue == true then
--     -- Handle piece capture logic
--     self:checkGameEndCondition()
--   end
-- end

function GameManager:handleGameStateChange(gameStateChange)
  local handlerName = "handle" .. gameStateChange:getNewState():gsub("^%l", string.upper)
  if self[handlerName] then
    self[handlerName](self, gameStateChange)
  else
    DebugPrint("MANAGER", "No handler found for game state change: " .. gameStateChange.newState)
  end
end

function GameManager:handleInitialize(gameStateChange)
  if self:isStartScreen() then
    self.gameState = VALID_GAME_STATES.INITIALIZE
    self.board = Board:new(self)
    self.players = {
      BOTTOM = Player:new(ReturnPlayerConfigFile(gameStateChange.player.BOTTOM), BOTTOM),
      TOP = Player:new(ReturnPlayerConfigFile(gameStateChange.player.TOP), TOP)
    }
    self.currentPlayer = self.players.BOTTOM
    self.inactivePlayer = self.players.TOP
    self.board:initialize(8, 8, self.currentPlayer, self.inactivePlayer)
  end
end

function GameManager:update(dt)
  if self:isBoardActive() then
    self.board:update(dt)
  end
end

function GameManager:draw()
  if self:isBoardActive() then
    self.board:draw()
  end
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
  if self:isBoardActive() then
    self.board:mousepressed(x, y, button)
  end
end

function GameManager:mousemoved(x, y)
  -- If the game is in playing state, pass the mouse move to the board
  if self:isBoardActive() then
    self.board:mousemoved(x, y)
  end
end

function GameManager:mousereleased(x, y, button)
  -- If the game is in playing state, pass the mouse release to the board
  if self:isBoardActive() then
    self.board:mousereleased(x, y, button)
  end
end

function GameManager:isBoardActive()
  return self.gameState == VALID_GAME_STATES.INITIALIZE or
         self.gameState == VALID_GAME_STATES.IN_PROGRESS
end

function GameManager:isStartScreen()
  return self.gameState == VALID_GAME_STATES.START_SCREEN
end

function GameManager:getEventBus()
  return self.eventBus
end