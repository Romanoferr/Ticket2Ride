local menuFunctions = require "src.libs.mainMenuFunctions"

local gameManager

local mainMenu = {
    buttons = {},
    font = nil,
    frames = {},
    frameCount = 50,
    currentFrame = 1,
    frameTimer = 0,
    frameDelay = 0.1,
    button_height = 64,
    margin = 16
}

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

    gameManager = require "src.gameManager"

    -- valores da fonte

    mainMenu.font = love.graphics.newFont(32)

    -- load dos botoes e seus valores

    menuFunctions.loadButtons(mainMenu.buttons, button_values)

    -- load dos frames da animacao de background

    menuFunctions.loadBackgroundFrames(mainMenu.frameCount, mainMenu.frames)

    -- load do titulo e suas dimensoes

    title, titleW, titleH = menuFunctions.loadTitle("src/assets/ticket_2_ride_logo.png")

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

    -- somatorio da altura dos botoes
    local total_height = mainMenu.button_height * #mainMenu.buttons

    -- posicionamento vertical do botoes
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

        -- o mouse esta posicionado na area do botao?
        local hot = menuFunctions.isHot(mx, my, bx, by, button_width, mainMenu.button_height)

        -- efeito do botao
        menuFunctions.buttonActivation(hot, b)

        -- efeito hover
        menuFunctions.buttonHighlight(hot, color)

        -- desenho do formato dos botoes
        menuFunctions.drawRectangles(color, bx, by, button_width, mainMenu)

        -- desenho do texto
        menuFunctions.drawText(mainMenu, b, bx, by)

        -- atualizacao do posicionamento vertical do botoes
        cursor_y = cursor_y + (mainMenu.button_height + mainMenu.margin)

    end

end

return mainMenu