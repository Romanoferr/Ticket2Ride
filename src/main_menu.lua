local lovebird = require "libs.lovebird"

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


end

function love.update(dt)
    lovebird.update()
end

function love.draw()
    local ww = love.grahics.getWidth()
    local wh = love.grahics.getHeight()

    local button_width = ww * (1 / 3)
    local button_height = 64

    local margin = 16

    for i, button in pairs(buttons) do
        love.graphics.rectangle(
                "fill",
                (ww * 0.5) - (button_width * 0.5),
                (wh * 0.5) - (button_height * 0.5),
                button_width,
                button_height
        )
    end

end
