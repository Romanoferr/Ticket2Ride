local menuFunctions = require "libs.mainMenuFunctions"

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

local button_height = 64

local margin = 16

local button_values = {
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

function mainMenu.load()

    gameManager = require "gameManager"

    -- valores da fonte

    mainMenu.font = love.graphics.newFont(32)

    -- load dos botoes e seus valores

    menuFunctions.loadButtons(mainMenu.buttons, button_values)

    -- load dos frames da animacao de background

    menuFunctions.loadBackgroundFrames(mainMenu.frameCount, mainMenu.frames)

    -- load do titulo e suas dimensoes

    title, titleW, titleH = menuFunctions.loadTitle("assets/ticket_2_ride_logo.png")

end

function mainMenu.update(dt)
    -- responsavel pela animacao da tela de fundo
    menuFunctions.updateFrames(mainMenu, dt)

end

function mainMenu.draw()

    -- dimensoes da tela
    local ww, wh = love.graphics.getWidth(), love.graphics.getHeight()

    -- largura do botao
    local button_width = ww * (1 / 3)

    -- distancia entre os botoes
    local total_height = (button_height + margin) * #mainMenu.buttons

    local cursor_y = 0

    -- desenho do background

    menuFunctions.drawBackground(mainMenu, ww, wh)

    --  desenho do titulo

    menuFunctions.drawTitle(title, ww, titleW)

    -- desenho dos botoes
    for _, b in ipairs(mainMenu.buttons) do

        -- ultima botao selecionado
        b.last = b.now

        -- cor inicial do botao
        local color = { 0.4, 0.4, 0.4, 1.0 }

        -- posicao  dos botoes em relacao da tela
        local bx, by = (ww * 0.25) - (button_width * 0.5), (wh * 0.7) - (total_height * 0.5) + cursor_y

        -- posicao do mouse na tela
        local mx, my = love.mouse.getPosition()

        -- botao selecionado
        b.now = love.mouse.isDown(1)

        local hot = menuFunctions.isHot(mx, my, bx, by, button_width, button_height)

        menuFunctions.buttonActivation(hot, b)

        menuFunctions.buttonHighlight(hot, color)

        love.graphics.setColor(unpack(color))

        love.graphics.rectangle(
                "fill",
                bx,
                by,
                button_width,
                button_height
        )

        local textW, textH = mainMenu.font:getWidth(b.text), mainMenu.font:getHeight(b.text)

        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.print(
                b.text,
                mainMenu.font,
                (bx * 3) - textW * 0.5,
                by + textH * 0.5
        )

        cursor_y = cursor_y + (button_height + margin)

    end

end

return mainMenu