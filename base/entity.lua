local love = require("love")
local Class = require("utils.class")

--- @class Entity
--- @field x number x position
--- @field y number y position
--- @field target_x number target x position when moving
--- @field target_y number target y position when moving
--- @field iso_x number isometric x position
--- @field iso_y number isometric y position
--- @field image love.Image texture of the entity
--- @field init fun(self: Entity, x: number, y: number, iso_x: number, iso_y: number, image_path: string)
local Entity = Class {}

--- @param x number x position
--- @param y number y position
--- @param iso_x number isometric x position
--- @param iso_y number isometric y position
--- @param image_path string path of the entity texture
function Entity:init(x, y, iso_x, iso_y, image_path)
    self.x = x
    self.y = y
    self.iso_x = iso_x
    self.iso_y = iso_y
    self.image = love.graphics.newImage(image_path)

    self.target_x = x
    self.target_y = x
end

return Entity
