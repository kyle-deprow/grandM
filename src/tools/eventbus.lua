require("tools/debug_utils")

EventBus = {}
EventBus.__index = EventBus

local instance = nil

function EventBus.new()
  error("EventBus is a singleton. Use EventBus:getInstance() instead.")
end

function EventBus:getInstance()
  if not instance then
    instance = setmetatable({}, EventBus)
    instance.subscribers = {}
  end
  return instance
end

function EventBus:subscribe(eventName, callback)
  if not self.subscribers[eventName] then
    self.subscribers[eventName] = {}
  end
  table.insert(self.subscribers[eventName], callback)
end

function EventBus:publish(event)
  DebugPrint("EVENTBUS", "Publishing event: " .. DebugUtils.tableToString(event))
  if not event:isValid() then
    DebugPrint("EVENTBUS", "Warning: Attempted to publish invalid event")
    return false
  end

  local eventType = event:getEventType()
  if self.subscribers[eventType] then
    for _, callback in ipairs(self.subscribers[eventType]) do
      callback(event)
    end
  end
  return true
end

function EventBus:unsubscribe(eventName, callback)
  if self.subscribers[eventName] then
    for i, subscribedCallback in ipairs(self.subscribers[eventName]) do
      if subscribedCallback == callback then
        table.remove(self.subscribers[eventName], i)
        break
      end
    end
  end
end

return EventBus