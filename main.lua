--- @class love
local love = require("love")

local Player = require("player")

local tile
local tile_width
local tile_height
local screen_width
local screen_x_center
local speed_multiplier

local player

local function toIsometric(x, y, tileWidth, tileHeight)
    local isoX = (x - y) * (tileWidth / 2)
    local isoY = (x + y) * (tileHeight / 2)

    return isoX + screen_x_center - tileWidth, isoY + 100
end

function love.load()
    tile = love.graphics.newImage("assets/tile.png")

    tile_width = tile:getWidth()
    tile_height = tile:getHeight()
    screen_width = love.graphics.getWidth()
    screen_x_center = screen_width / 2
    speed_multiplier = 50

    local player_iso_x, player_iso_y = toIsometric(0, 0, tile_width, tile_height)

    player = Player(0, 0, player_iso_x, player_iso_y)
end

function love.update(dt)
    if player.moving then
        local target_iso_x, target_iso_y = toIsometric(player.target_x, player.target_y, tile_width, tile_height)

        local dx = target_iso_x - player.iso_x
        local dy = target_iso_y - player.iso_y
        local dist = math.sqrt(dx * dx + dy * dy)

        if dist > 1 then
            local move_x = (dx / dist) * player.speed * speed_multiplier * dt
            local move_y = (dy / dist) * player.speed * speed_multiplier * dt

            player.iso_x = player.iso_x + move_x
            player.iso_y = player.iso_y + move_y
        else
            player.iso_x = target_iso_x
            player.iso_y = target_iso_y
            player.x = player.target_x
            player.y = player.target_y
            player.moving = false
        end
    end
end

function love.draw()
    local tiles_count = 5

    for i = 0, tiles_count - 1 do
        for j = 0, tiles_count - 1 do
            local x = i
            local y = j

            local iso_x, iso_y = toIsometric(x, y, tile_width, tile_height)
            love.graphics.draw(tile, iso_x, iso_y)
        end
    end

    local x_offset = (tile_width / 2) - (player.image:getWidth() / 2)
    local y_offset = tile:getHeight() / 3
    love.graphics.draw(player.image, player.iso_x + x_offset, player.iso_y - y_offset)
end


function love.keypressed(key)
    if key == "q" then
        love.event.quit()
    end

    if not player.moving then
        if love.keyboard.isDown("left") then
            player.target_x = player.x - 1
        elseif love.keyboard.isDown("right") then
            player.target_x = player.x + 1
        elseif love.keyboard.isDown("down") then
            player.target_y = player.y + 1
        elseif love.keyboard.isDown("up") then
            player.target_y = player.y - 1
        end

        player.moving = true
    end
end
