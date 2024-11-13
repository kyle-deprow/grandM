local json = require("lib.json")

function DebugPrint(section, ...)
    if DEBUG.ENABLED and DEBUG.SECTIONS[section] then
        local args = {...}
        local message = ""
        for i, v in ipairs(args) do
            message = message .. tostring(v) .. " "
        end
        print("[" .. section .. "] " .. message)
    end
end

function HEX(hex)
  if #hex <= 6 then hex = hex.."FF" end
  local _,_,r,g,b,a = hex:find('(%x%x)(%x%x)(%x%x)(%x%x)')
  local color = {tonumber(r,16)/255,tonumber(g,16)/255,tonumber(b,16)/255,tonumber(a,16)/255 or 255}
  return color
end

function DebugPrintFilesInPath(path)
  if not love.filesystem.getInfo(path) then
    DebugPrint("FILE_PATHS", "Path does not exist:", path)
    return
  end

  DebugPrint("FILE_PATHS", "Files in path:", path)
  local files = love.filesystem.getDirectoryItems(path)

  DebugPrint("FILE_PATHS", "Number of files:", #files)
  for _, file in ipairs(files) do
    DebugPrint("FILE_PATHS", file)
  end
end

function ReturnPieceTextureFile(piece)
  local fullPath = TEXTURE_PATH .. piece.color .. piece.type .. ".png"
  DebugPrint("FILE_PATHS", "Attempting to load piece texture file:", fullPath)
  return fullPath
end

function ReturnPlayerConfigFile(configName)
  local fullPath = love.filesystem.getSource() .. '/' .. PLAYER_CONFIG_PATH .. configName .. ".json"
  DebugPrint("FILE_PATHS", "Attempting to load player config file:", fullPath)
  return fullPath
end

function ReturnJsonConfig(jsonConfigPath)
  -- Debug print to see the exact path we're trying to open
  DebugPrint("FILE_PATHS", "Attempting to open file at path:", jsonConfigPath)

  -- Read the JSON configuration file
  local file = io.open(jsonConfigPath, "r")
  if not file then
    DebugPrint("FILE_PATHS", "File does not exist or cannot be accessed")
    DebugPrint("FILE_PATHS", "Current working directory:", love.filesystem.getWorkingDirectory())
    error("Could not open file: " .. jsonConfigPath)
  end

  local content = file:read("*a")
  file:close()

  return json.decode(content)
end