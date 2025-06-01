local lovebird = require "src.libs.lovebird"

local scoringBoard = {
    board = nil,
    width = 26, -- largura do tabuleiro
    height = 16, -- altura do tabuleiro

    -- totalSquares = 2 * 25 + 2 * 15,

    -- inicializa o tabuleiro de pontuação
    squares = {},
    counter = 0,
}

-- Isso foi uma das piores coisas que eu já fiz na minha vida 
-- mas não sei como fazer diferente
function scoringBoard.load()
    for i = 0, scoringBoard.width-1 do
        table.insert(scoringBoard.squares, { x = i, y = 0, counter = scoringBoard.counter })
            scoringBoard.counter = scoringBoard.counter + 1
    end

    for j=0, scoringBoard.height-2 do
        table.insert(scoringBoard.squares, { x = scoringBoard.width-1, y = j+1, counter = scoringBoard.counter })
            scoringBoard.counter = scoringBoard.counter + 1
    end

    for i = scoringBoard.width-2, 0, -1 do
        table.insert(scoringBoard.squares, { x = i, y = scoringBoard.height-1, counter = scoringBoard.counter })
        scoringBoard.counter = scoringBoard.counter + 1
    end

    for j = scoringBoard.height-2, 1, -1 do
        table.insert(scoringBoard.squares, { x = 0, y = j, counter = scoringBoard.counter })
        scoringBoard.counter = scoringBoard.counter + 1
    end
end


function scoringBoard.update()

end

function scoringBoard.draw()
    love.graphics.setColor(1, 1, 1)
    for _, square in ipairs(scoringBoard.squares) do
        local drawX = square.x * (love.graphics.getWidth() / scoringBoard.width)
        local drawY = square.y * (love.graphics.getHeight() / scoringBoard.height)
        love.graphics.rectangle("line", drawX, drawY, 46, 46)
        love.graphics.print(square.counter, drawX + 5, drawY + 5) 
    end
end

return scoringBoard
