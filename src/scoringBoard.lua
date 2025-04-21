local scoringBoard = {
    board = nil,
    width = 25, -- largura do tabuleiro
    height = 15, -- altura do tabuleiro

    totalSquares = 2 * 25 + 2 * 15,

    -- inicializa o tabuleiro de pontuação
    squares = {},
    counter = 0,

    -- Está pegando os valores errados
    -- logicalWidth = love.graphics.getWidth(),
    --logicalHeight = love.graphics.getHeight(),
}

function scoringBoard.load()
    for i = 0, scoringBoard.width do
        table.insert(scoringBoard.squares, { x = i, y = 0, counter = scoringBoard.counter })
            scoringBoard.counter = scoringBoard.counter + 1
    end
end


function scoringBoard.update()
    
end

function scoringBoard.draw()
    love.graphics.setColor(1, 1, 1)
    for _, square in ipairs(scoringBoard.squares) do
        local drawX = square.x * (1280 / scoringBoard.width)
        local drawY = square.y * (720 / scoringBoard.height)
        love.graphics.rectangle("line", drawX, drawY, 50, 50) -- Draw square
        love.graphics.print(square.counter, drawX + 5, drawY + 5) -- Draw position inside the square
    end
end

return scoringBoard
