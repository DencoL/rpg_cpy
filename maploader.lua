local love = require("love")
local lume = require("utils.lume")

local MapLoader = {}

--- @param map_name string map name
--- @return table map table
function MapLoader:loadMap(map_name)
    return lume.deserialize(love.filesystem.read("assets/maps/" .. map_name .. ".txt"))
end

return MapLoader
