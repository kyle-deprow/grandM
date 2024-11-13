Event = {}
Event.__index = Event
Event.__class = "Event"

function Event:new(eventType, triggeredBy)
  local instance = setmetatable({}, self)
  instance.eventType = eventType or UNDEFINED
  instance.triggeredBy = triggeredBy or UNDEFINED
  instance.timestamp = os.time()
  return instance
end

-- Add extend method for inheritance
function Event:extend()
  local cls = {}
  cls.__index = cls
  setmetatable(cls, {
    __index = self,
    __call = function(c, ...)
      local instance = setmetatable({}, c)
      instance:new(...)
      return instance
    end
  })
  return cls
end

function Event:getEventType() return self.eventType end
function Event:getTimestamp() return self.timestamp end

-- Serialize event data for logging or network transmission
function Event:serialize()
  return {
    eventType = self.eventType,
    timestamp = self.timestamp
  }
end

-- Default method for validation
function Event:isValid()
  return self.eventType ~= nil and self.eventType ~= UNDEFINED
end

return Event