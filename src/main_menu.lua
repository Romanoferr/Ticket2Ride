local gameManager = require "gameManager"

function create_button(text, fn)
    return {
        text = text,
        fn = fn
    }
end

local settings = {
    fullscreen = false,
    screenScaler = 1,
    logicalWidth = 1280,
    logicalHeight = 720
}

local button_values = {
    { "Iniciar Jogo",
      function()
          print("Iniciando jogo")
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

local buttons = {}

function love.load()

    for _, v in pairs(button_values) do
        table.insert(buttons, create_button(v[1], v[2]))
    end

    gameManager.draw()

end

function love.update(dt)


end

function love.draw()
    gameManager.draw()
end
