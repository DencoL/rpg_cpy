local Class = require("utils.class")
local Entity = require("base.entity")

--- @class Player : Entity
--- @field speed number speed of the player
--- @field moving boolean indicates whether the player should move or not
local Player = Class {
    __includes = Entity
}

function Player:init(x, y, iso_x, iso_y)
    Entity.init(self, x, y, iso_x, iso_y, "assets/player.png")

    self.speed = 1
    self.moving = false
end

return Player
