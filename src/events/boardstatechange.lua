require("globals")
require("events/event")

BoardStateChange = Event:extend()
BoardStateChange.__class = "BoardStateChange"

function BoardStateChange:new(params)
  local instance = Event.new(self, EVENTS.BOARD_STATE_CHANGE, params.triggeredBy)
  instance.boardNumber = params.boardNumber
  instance.newState = params.newState
  return instance
end

-- Getters
function BoardStateChange:getBoardNumber() return self.boardNumber end
function BoardStateChange:getNewState() return self.newState end

-- Override serialize method
function BoardStateChange:serialize()
  local baseData = Event.serialize(self)
  baseData.boardNumber = self.boardNumber
  baseData.newState = self.newState
  return baseData
end

-- Override isValid method
function BoardStateChange:isValid()
  local baseValid = Event.isValid(self)
  return baseValid and
         self.boardNumber and
         self.newState and
         BoardStateChange.VALID_STATES[self.newState:upper()]
end

return GameStateChange