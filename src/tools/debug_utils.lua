DebugUtils = {}

function DebugUtils.tableToString(tbl, indent)
  if not tbl then return "nil" end
  if type(tbl) ~= "table" then return tostring(tbl) end

  indent = indent or 0
  local spaces = string.rep("  ", indent)

  -- Get class name if available (through metatable)
  local className = ""
  local mt = getmetatable(tbl)
  if mt and mt.__class then
    className = mt.__class .. " "
  end

  local str = className .. "{\n"

  for k, v in pairs(tbl) do
    local key = type(k) == "number" and k or '"'..k..'"'
    str = str .. spaces .. "  [" .. key .. "] = "

    -- Special handling for triggeredBy if it's a table/class
    if k == "triggeredBy" and type(v) == "table" then
      local triggerMt = getmetatable(v)
      if triggerMt and triggerMt.__class then
        str = str .. '"' .. triggerMt.__class .. '"'
      else
        str = str .. tostring(v)
      end
    else
      if type(v) == "table" then
        str = str .. DebugUtils.tableToString(v, indent + 1)
      else
        str = str .. tostring(v)
      end
    end
    str = str .. ",\n"
  end

  return str .. spaces .. "}"
end

return DebugUtils