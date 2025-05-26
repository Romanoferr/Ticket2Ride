local lovebird = require "libs.lovebird"

local buttons = {}

local font = nil

function create_button(text, fn)
    return {
        text = text,
        fn = fn
    }
end

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

function love.load()

    font = love.graphics.newFont(32)

    for _, row in ipairs(button_values) do
        table.insert(buttons, create_button(row[1], row[2]))
    end

end

function love.update(dt)
    lovebird.update()
end

function love.draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    local button_width = ww * (1 / 3)
    local button_height = 64

    local margin = 16

    local total_height = (button_height + margin) * #buttons

    local cursor_y = 0

    for _, b in ipairs(buttons) do

        local bx = (ww * 0.5) - (button_width * 0.5)
        local by = (wh * 0.5) - (total_height * 0.5) + cursor_y

        love.graphics.setColor(0.4, 0.4, 0.4, 1.0)
        love.graphics.rectangle(
                "fill",
                bx,
                by,
                button_width,
                button_height
        )

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(
                b.text,
                font,
                bx,
                by
        )

        cursor_y = cursor_y + (button_height + margin)
    end

end
