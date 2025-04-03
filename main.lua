--- @class love
local love = require("love")

function love.load()
    tile = love.graphics.newImage("tile.png")

    tile_width = tile:getWidth()
    tile_height = tile:getHeight()
    screen_width = love.graphics.getWidth()
    screen_height = love.graphics.getHeight()
    screen_x_center = screen_width / 2
    screen_y_center = screen_height / 2

    local player_iso_x, player_iso_y = toIsometric(0, 0, tile_width, tile_height)

    player = {
        texture = love.graphics.newImage("player.png"),
        x = 0,
        y = 0,
        target_x = 0,
        target_y = 0,
        iso_x = player_iso_x,
        iso_y = player_iso_y,
        moving = false,
        speed = 50
    }

end

function love.update(dt)
    if player.moving then
        local target_iso_x, target_iso_y = toIsometric(player.target_x, player.target_y, tile_width, tile_height)

        local dx = target_iso_x - player.iso_x
        local dy = target_iso_y - player.iso_y
        local dist = math.sqrt(dx * dx + dy * dy)

        if dist > 1 then
            local move_x = (dx / dist) * player.speed * dt
            local move_y = (dy / dist) * player.speed * dt

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

            local transformed_x, transformed_y = toIsometric(x, y, tile_width, tile_height)
            love.graphics.draw(tile, transformed_x, transformed_y)
        end
    end

    love.graphics.draw(player.texture, player.iso_x + (tile_width / 2) - (player.texture:getWidth() / 2), player.iso_y - tile:getHeight() / 3)
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

function toIsometric(x, y, tileWidth, tileHeight)
    local isoX = (x - y) * (tileWidth / 2)
    local isoY = (x + y) * (tileHeight / 2)

    return isoX + screen_x_center - tileWidth, isoY + 100
end
