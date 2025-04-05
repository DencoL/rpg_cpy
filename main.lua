--- @class love
local love = require("love")

local Player = require("player")

local tile
local stone
local tile_width
local tile_height
local screen_width
local screen_x_center
local speed_multiplier

local player
local map

local function toIsometric(x, y, tileWidth, tileHeight)
    local isoX = (x - y) * (tileWidth / 2)
    local isoY = (x + y) * (tileHeight / 2)

    return isoX + screen_x_center - tileWidth, isoY + 100
end

function love.load()
    tile = love.graphics.newImage("assets/tile.png")
    stone = love.graphics.newImage("assets/stone.png")

    tile_width = tile:getWidth()
    tile_height = tile:getHeight()
    screen_width = love.graphics.getWidth()
    screen_x_center = screen_width / 2
    speed_multiplier = 50

    local player_start_x = 1
    local player_start_y = 1
    local player_iso_x, player_iso_y = toIsometric(player_start_x, player_start_y, tile_width, tile_height)

    player = Player(player_start_x, player_start_y, player_iso_x, player_iso_y)
    map = {
        {0, 0, 1, 0, 0},
        {0, 1, 0, 0, 0},
        {0, 0, 0, 0, 0},
        {1, 0, 0, 0, 0},
        {0, 0, 0, 0, 0},
    }
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

local function drawCenteredOnTile(image, iso_x, iso_y, extra_y_offset)
    local x_offset = (tile_width / 2) - (image:getWidth() / 2)
    local y_offset = tile:getHeight() / 3 + (extra_y_offset or 0)

    local draw_x = iso_x + x_offset
    local draw_y = iso_y - y_offset

    love.graphics.draw(image, draw_x, draw_y)
end

function love.draw()
    for x, row in ipairs(map) do
        for y, column in pairs(row) do

            local iso_x, iso_y = toIsometric(y, x, tile_width, tile_height)
            love.graphics.draw(tile, iso_x, iso_y)

            if column == 1 then
                drawCenteredOnTile(stone, iso_x, iso_y, -5)
            end
        end
    end

    drawCenteredOnTile(player.image, player.iso_x, player.iso_y)
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
