require("globals")
require("board")
require("player")

require("tools/util")
require("tools/eventbus")
require("events/gamestatechange")
require("events/initializeboard")
--require("events/piecechange")

GameManager = {}
GameManager.__index = GameManager


function GameManager:new()
  local instance = setmetatable({}, GameManager)
  -- Initialize attributes
  instance.currentPlayer = nil
  instance.inactivePlayer = nil

  instance.gameState = VALID_GAME_STATES.START_SCREEN
  instance.boardState = VALID_BOARD_STATES.UNDEFINED

  instance.eventBus = EventBus:getInstance()
  instance:registerEventHandlers()

  -- TODO: Immediately initialize the game
  local initializeBoardEvent = InitializeBoard:new({players = {TOP = "pc_lvl1", BOTTOM = "player_white"},
                                                    boardConfig = {width = 8, height = 8},
                                                    triggeredBy = self})
  instance.eventBus:publish(initializeBoardEvent)

  return instance
end

function GameManager:registerEventHandlers()
  -- Register event handlers with callback functions
  self.eventBus:subscribe(EVENTS.INITIALIZE_BOARD, function(event)
    self:handleInitializeBoard(event)
  end)
  self.eventBus:subscribe(EVENTS.GAME_STATE_CHANGE, function(event)
    self:handleGameStateChange(event)
  end)
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

-- Getters
function GameManager:getGameState() return self.gameState end

-- Handler definitions below
function GameManager:handleInitializeBoard(event)
  if self:isStartScreen() then
    self.gameState = VALID_GAME_STATES.INITIALIZE
    self.board = Board:new(self)
    self.players = {
      BOTTOM = Player:new(ReturnPlayerConfigFile(event.players.BOTTOM), BOTTOM),
      TOP = Player:new(ReturnPlayerConfigFile(event.players.TOP), TOP)
    }
    self.currentPlayer = self.players.BOTTOM
    self.inactivePlayer = self.players.TOP
    self.board:initialize(event.boardConfig.width, event.boardConfig.height, self.players)
  end
end

function GameManager:handleGameStateChange(event)
  self.gameState = event.newState
  if self.gameState == VALID_GAME_STATES.IN_PROGRESS then
    self.eventBus:publish("GAME_STATE_CHANGE", GameStateChange:new({newState=VALID_GAME_STATES.IN_PROGRESS, triggeredBy=self}))
    self.eventBus:publish("BOARD_STATE_CHANGE", BoardStateChange:new({newState=VALID_BOARD_STATES.INITIALIZED, triggeredBy=self}))
  end
end
