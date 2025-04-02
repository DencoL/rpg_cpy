--- @class love
local love = require("love")

function love.load()
    tile = love.graphics.newImage("tile.png")

    player = {
        texture = love.graphics.newImage("player.png"),
        x = 0,
        y = 0,
        previous_x = 0,
        previous_y = 0,
        moving = false,
        moving_direction = ""
    }

    tile_width = tile:getWidth()
    tile_height = tile:getHeight()
    screen_width = love.graphics.getWidth()
    screen_height = love.graphics.getHeight()
    screen_x_center = screen_width / 2
    screen_y_center = screen_height / 2
end

function love.update(dt)
    if player.moving then
        if player.moving_direction == "left" and player.x <= player.previous_x - 1 then
            player.moving = false
        elseif player.moving_direction == "right" and player.x >= player.previous_x + 1 then
            player.moving = false
        elseif player.moving_direction == "down" and player.y >= player.previous_y + 1 then
            player.moving = false
        elseif player.moving_direction == "up" and player.y <= player.previous_y - 1 then
            player.moving = false
        end

        local speed = 1.5
        if player.moving_direction == "left" then
            player.x = player.x - speed * dt
        elseif player.moving_direction == "right" then
            player.x = player.x + speed * dt
        elseif player.moving_direction == "down" then
            player.y = player.y + speed * dt
        elseif player.moving_direction == "up" then
            player.y = player.y - speed * dt
        end
    else
        if love.keyboard.isDown("left") then
            player.moving_direction = "left"
            player.moving = true
        elseif love.keyboard.isDown("right") then
            player.moving_direction = "right"
            player.moving = true
        elseif love.keyboard.isDown("down") then
            player.moving_direction = "down"
            player.moving = true
        elseif love.keyboard.isDown("up") then
            player.moving_direction = "up"
            player.moving = true
        end

        player.previous_x = player.x
        player.previous_y = player.y
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

    local transformed_player_x, transformed_player_y = toIsometric(player.x, player.y, tile_width, tile_height)
    love.graphics.draw(player.texture, transformed_player_x + (tile_width / 2) - (player.texture:getWidth() / 2), transformed_player_y - tile:getHeight() / 3)
end


function love.keypressed(key)
    if key == "q" then
        love.event.quit()
    end
end

function toIsometric(x, y, tileWidth, tileHeight)
    local isoX = (x - y) * (tileWidth / 2)
    local isoY = (x + y) * (tileHeight / 2)

    return isoX + screen_x_center - tileWidth, isoY + 100
end
