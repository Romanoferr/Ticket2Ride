local gameManager = require "gameManager"

function love.load()
    love.window.setTitle( 'Ticket 2 Ride' )
    love.graphics.setDefaultFilter("nearest", "nearest")
    gameManager.load()
end

function love.update(dt)
    gameManager.update(dt)
end

function love.draw()
    gameManager.draw()
end