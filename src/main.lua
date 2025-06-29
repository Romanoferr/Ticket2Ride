
local gameManager = require "gameManager"
local lovebird = require "libs.lovebird"
local settings = {
    fullscreen = false,
    screenScaler = 1,
    logicalWidth = 1280,
    logicalHeight = 720
}
function love.load()
    love.window.setTitle('Ticket 2 Ride - Sistema de Compra de Cartas')
    love.window.setMode(settings.logicalWidth, settings.logicalHeight, {
        resizable=true, 
        vsync=0, 
        minwidth=settings.logicalWidth*settings.screenScaler, 
        minheight=settings.logicalHeight*settings.screenScaler
    })
    love.graphics.setDefaultFilter("nearest", "nearest")
    gameManager.load()
end
function love.update(dt)
    lovebird.update()
    gameManager.update(dt)
end
function love.draw()
    gameManager.draw()
    
    -- Instruções gerais (canto inferior direito)
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.print("TAB: Alternar fase do jogo", love.graphics.getWidth() - 200, love.graphics.getHeight() - 60)
    love.graphics.print("Clique no botão: Alternar view", love.graphics.getWidth() - 200, love.graphics.getHeight() - 40)
end
--  Tratamento de cliques do mouse
function love.mousepressed(x, y, button, istouch, presses)
    gameManager.mousepressed(x, y, button)
end
-- Tratamento de movimento do mouse (usado para feedback)
function love.mousemoved(x, y, dx, dy, istouch)
    gameManager.mousemoved(x, y, dx, dy)
end
--  Tratamento de teclas
function love.keypressed(key)
    gameManager.keypressed(key)
end