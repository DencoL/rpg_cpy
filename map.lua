local Class = require("utils.class")

--- @class Map
local Map = Class{}

function Map:init(size, basement, entities)
    assert(type(basement) == "table", "map basement must be a table")
    assert(type(entities) == "table", "map entities must be a table")
    assert(#basement == size, "map basement must be the same size as map size")
    assert(#entities == size, "map entities must be the same size as map size")

    self.basement = basement
    self.entities = entities
    self.size = size
end

return Map
