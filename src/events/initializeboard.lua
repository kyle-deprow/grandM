require("globals")
require("events/event")

InitializeBoard = Event:extend()
InitializeBoard.__class = "InitializeBoard"

function InitializeBoard:new(params)
  local instance = Event.new(self, EVENTS.INITIALIZE_BOARD, params.triggeredBy)
  instance.boardConfig = params.boardConfig
  instance.players = params.players
  return instance
end

function InitializeBoard:getBoardConfig()
  return self.boardConfig
end

function InitializeBoard:getPlayers()
  return self.players
end

-- Override serialize method
function InitializeBoard:serialize()
  local baseData = Event.serialize(self)
  baseData.boardConfig = self.boardConfig
  baseData.players = self.players
  return baseData
end

-- Override isValid method
function InitializeBoard:isValid()
  local baseValid = Event.isValid(self)
  return baseValid and
         self.boardConfig and
         self.players and
         self.players.TOP and
         self.players.BOTTOM
end

return InitializeBoard