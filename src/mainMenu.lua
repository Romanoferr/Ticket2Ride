local gameManager

local mainMenu = {
    buttons = {},
    font = nil,
    frames = {},
    frameCount = 50,
    currentFrame = 1,
    frameTimer = 0,
    frameDelay = 0.1
}

function create_button(text, fn)
    return {
        text = text,
        fn = fn,
        now = false,
        last = false
    }
end

function mainMenu.load()

    gameManager = require "gameManager"

    -- load dos botoes e seus valores

    button_values = {
        { "Iniciar Jogo",
          function()
              gameManager.changeState("game")
          end },
        { "Opções",
          function()
              print("Iniciando opções")
          end },
        { "Sair",
          function()
              love.event.quit(0)
          end }
    }

    mainMenu.font = love.graphics.newFont(32)

    for _, row in ipairs(button_values) do
        table.insert(mainMenu.buttons, create_button(row[1], row[2]))
    end

    for i = 1, mainMenu.frameCount do
        mainMenu.frames[i] = love.graphics.newImage(string.format("assets/steam_train_frames/frame%03d.png", i))
    end

    -- load do titulo e suas dimensoes

    title = love.graphics.newImage("assets/ticket_2_ride_logo.png")

    titleW = title:getWidth()
    titleH = title:getHeight()


end

function mainMenu.update(dt)
    mainMenu.frameTimer = mainMenu.frameTimer + dt
    if mainMenu.frameTimer >= mainMenu.frameDelay then
        mainMenu.frameTimer = mainMenu.frameTimer - mainMenu.frameDelay
        mainMenu.currentFrame = mainMenu.currentFrame % mainMenu.frameCount + 1
    end
end

function mainMenu.draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    local button_width = ww * (1 / 3)
    local button_height = 64

    local margin = 16

    local total_height = (button_height + margin) * #mainMenu.buttons

    local cursor_y = 0

    -- desenho do background

    love.graphics.draw(mainMenu.frames[mainMenu.currentFrame],
            0,
            0,
            0,
            ww / mainMenu.frames[mainMenu.currentFrame]:getWidth(),
            wh / mainMenu.frames[mainMenu.currentFrame]:getHeight())

    --  desenho do titulo

    titleX = (ww * 0.5) - titleW * 0.5

    love.graphics.draw(
            title,
            titleX + 100,
            0,
            0,
            0.5,
            0.5
    )

    for _, b in ipairs(mainMenu.buttons) do

        b.last = b.now

        local bx = (ww * 0.5) - (button_width * 0.5)
        local by = (wh * 0.5) - (total_height * 0.5) + cursor_y

        local color = { 0.4, 0.4, 0.4, 1.0 }

        local mx, my = love.mouse.getPosition()

        local hot = mx > bx and mx < bx + button_width and
                my > by and my < by + button_height

        b.now = love.mouse.isDown(1)

        if hot and not b.last and b.now then
            b.fn()
        end

        if hot then
            color = { 0.8, 0.8, 0.9, 1.0 }
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(
                "fill",
                bx,
                by,
                button_width,
                button_height
        )

        local textW = mainMenu.font:getWidth(b.text)
        local textH = mainMenu.font:getHeight(b.text)

        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.print(
                b.text,
                mainMenu.font,
                (ww * 0.5) - textW * 0.5,
                by + textH * 0.5
        )

        cursor_y = cursor_y + (button_height + margin)

    end

end

return mainMenu