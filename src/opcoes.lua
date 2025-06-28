local gameManager

local opcoes = {

}

function opcoes.load()
    gameManager = require "gameManager"
    background = love.graphics.newImage("assets/opcoes_menu.png")
end

function opcoes.draw()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local imageWidth, imageHeight = background:getWidth(), background:getHeight()

    love.graphics.setBackgroundColor(0.6, 0.2, 0.1)

    love.graphics.draw(background, windowWidth/imageWidth + 200, windowHeight/imageHeight , 0, 0.5, 0.4)
end

return opcoes