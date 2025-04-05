--- @class love
local love = require("love")
local lume = require("utils.lume")

local Player = require("player")

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
    tile_width = 92
    tile_height = 46
    screen_width = love.graphics.getWidth()
    screen_x_center = screen_width / 2
    speed_multiplier = 50

    local player_start_x = 1
    local player_start_y = 1
    local player_iso_x, player_iso_y = toIsometric(player_start_x, player_start_y, tile_width, tile_height)

    player = Player(player_start_x, player_start_y, player_iso_x, player_iso_y)

    map = lume.deserialize(love.filesystem.read("assets/maps/dummy.txt"))
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
    local y_offset = tile_height / 3 + (extra_y_offset or 0)

    local draw_x = iso_x + x_offset
    local draw_y = iso_y - y_offset

    love.graphics.draw(image, draw_x, draw_y)
end

--- @param values table values to draw
--- @param draw_func fun(object, iso_x, iso_y)
local function draw(values, draw_func)
    for x, row in ipairs(values) do
        for y, column in pairs(row) do

            local iso_x, iso_y = toIsometric(y, x, tile_width, tile_height)
            draw_func(column, iso_x, iso_y)
        end
    end
end

local function getAsset(name)
    return "assets/" .. name .. ".png"
end

function love.draw()
    draw(map.base_tiles, function (column, iso_x, iso_y)
        love.graphics.draw(love.graphics.newImage(getAsset(column)), iso_x, iso_y)
    end)

    draw(map.objects, function (column, iso_x, iso_y)
        if not (column == nil) then
            drawCenteredOnTile(love.graphics.newImage(getAsset(column.name)), iso_x, iso_y, column.y_offset)
        end
    end)

    drawCenteredOnTile(player.image, player.iso_x, player.iso_y)
end

local function isMoveKey(key)
    return key == "right" or key == "left" or key == "up" or key == "down"
end

local function tryMove(key)
    if player.moving then
        return
    end

    local target_x = player.x
    local target_y = player.y

    if key == "left" then
        target_x = player.x - 1
    elseif key == "right" then
        target_x = player.x + 1
    elseif key == "down" then
        target_y = player.y + 1
    elseif key == "up" then
        target_y = player.y - 1
    end

    if not (map.objects[target_y][target_x] == nil) then
        return
    end

    player.target_x = target_x
    player.target_y = target_y
    player.moving = true
end

function love.keypressed(key)
    if key == "q" then
        love.event.quit()
    end

    if isMoveKey(key) then
        tryMove(key)
    end
end
