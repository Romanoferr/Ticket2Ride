function create_button(text, fn)
    return {
        text = text,
        fn = fn
    }
end

local buttons = {}

local button_values = {
    { "Iniciar Jogo", function()
        print("Iniciando jogo")
    end },
    { "Opções", function()
        print("iniciando opções")
    end },
    { "Sair", function()
        love.event.quit()
    end }
}

function love.load()

    for _, v in pairs(button_values) do

        table.insert(buttons, createButton(
                v[]
        )
        )
    end
end

function love.update(dt)

end

function love.draw()

end
