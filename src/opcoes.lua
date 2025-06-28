local gameManager

local opcoes = {
    buttons = {}
}

function create_buttons(image, fn)
    return {
        image = love.graphics.newImage(image),
        fn = fn
    }
end

button_values = {
    {
        "assets/opcoes_menu_checkbutton.png",
        function()
            gameManager.changeState("mainMenu")
        end
    },
    {
        "assets/opcoes_menu_exitbutton.png",
        function()
            gameManager.changeState("mainMenu")
        end
    }
}

function opcoes.load()
    gameManager = require "gameManager"

    background = love.graphics.newImage("assets/opcoes_menu.png")

    for _, row in ipairs(button_values) do
        table.insert(opcoes.buttons, create_buttons(row[1], row[2]))
    end

end

function opcoes.draw()
    local windowWidth, windowHeight = love.graphics.getDimensions()

    local imageWidth, imageHeight = background:getWidth(), background:getHeight()


    love.graphics.setBackgroundColor(0.6, 0.2, 0.1)

    love.graphics.draw(background, windowWidth / imageWidth + 250, windowHeight / imageHeight, 0, 0.5, 0.4)

    love.graphics.draw(opcoes.buttons[1].image, 400, 500, 0, 0.4, 0.4)

    love.graphics.draw(opcoes.buttons[2].image, 750, 500, 0, 0.4, 0.4)


end

return opcoes