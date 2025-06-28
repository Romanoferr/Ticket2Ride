local menuFunctions = require "libs.mainMenuFunctions"

local gameManager

local opcoes = {
    buttons = {}
}

function create_buttons(image, fn, bx, by)
    return {
        image = love.graphics.newImage(image),
        fn = fn,
        bx = bx,
        by = by,
        now = false,
        last = false
    }
end

function isHot(mx, my, bx, by, button_width, button_height)

    return mx > bx and mx < bx + button_width and my > by and my < by + button_height

end

function buttonActivation(hot, b)
    if hot and not b.last and b.now then
        b.fn()
    end
end

function buttonHighlight(hot, color)
    if hot then
        for i, c in ipairs({ 1.0, 1.0, 1.0, 1.0 }) do
            color[i] = c
        end
    end
end

button_values = {
    {
        "assets/opcoes_menu_checkbutton.png",
        function()
            gameManager.changeState("mainMenu")
        end,
        400,
        500
    },
    {
        "assets/opcoes_menu_exitbutton.png",
        function()
            gameManager.changeState("mainMenu")
        end,
        750,
        500
    }
}

function opcoes.load()
    gameManager = require "gameManager"

    background = love.graphics.newImage("assets/opcoes_menu.png")

    for _, row in ipairs(button_values) do
        table.insert(opcoes.buttons, create_buttons(row[1], row[2], row[3], row[4]))
    end

end

function opcoes.draw()

    local windowWidth, windowHeight = love.graphics.getDimensions()

    local imageWidth, imageHeight = background:getWidth(), background:getHeight()

    local buttonWidth = opcoes.buttons[1].image:getWidth() * 0.4

    local buttonHeight = opcoes.buttons[1].image:getHeight() * 0.4

    love.graphics.setBackgroundColor(0.6, 0.2, 0.1)

    love.graphics.draw(background, windowWidth / imageWidth + 250, windowHeight / imageHeight, 0, 0.5, 0.4)

    for _, button in ipairs(opcoes.buttons) do

        local color = { 0.7, 0.7, 0.7, 1 }

        button.last = button.now

        local mousex, mousey = love.mouse.getPosition()

        button.now = love.mouse.isDown(1)

        local hot = isHot(mousex, mousey, button.bx, button.by, buttonWidth, buttonHeight)

        buttonHighlight(hot, color)

        --buttonActivation(hot, button)

        love.graphics.setColor(unpack(color))

        love.graphics.draw(button.image, button.bx, button.by, 0, 0.4, 0.4)

    end


end

return opcoes