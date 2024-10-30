local json = require("lib.json")

function HEX(hex)
  if #hex <= 6 then hex = hex.."FF" end
  local _,_,r,g,b,a = hex:find('(%x%x)(%x%x)(%x%x)(%x%x)')
  local color = {tonumber(r,16)/255,tonumber(g,16)/255,tonumber(b,16)/255,tonumber(a,16)/255 or 255}
  return color
end

function ReturnPlayerConfigFile(configName)
  return PLAYER_CONFIG_PATH .. configName .. ".json"
end

function ReturnJsonConfig(jsonConfigPath)
  -- Read the JSON configuration file
  local file = io.open(jsonConfigPath, "r")
  if not file then
    error("Could not open file: " .. jsonConfigPath)
  end

  local content = file:read("*a")
  file:close()

  return json.decode(content)
end
