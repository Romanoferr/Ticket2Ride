local gameManager = require "gameManager"

local settings = {
    fullscreen = false,
    screenScaler = 1,
    logicalWidth = 960,
    logicalHeight = 540
}


function love.load()
    love.window.setTitle( 'Ticket 2 Ride' )
    love.window.setMode(settings.logicalWidth, settings.logicalHeight, {resizable=true, vsync=0, minwidth=settings.logicalWidth*settings.screenScaler, minheight=settings.logicalHeight*settings.screenScaler})
    love.graphics.setDefaultFilter("nearest", "nearest")
    gameManager.load()
end

function love.update(dt)
    gameManager.update(dt)
end

function love.draw()
    gameManager.draw()
end