local board = require "board"
local players = require "players"
local trainCards = require "trainCards" 
local tickets = require "destinationTicketCards"

local setupGame = {}

local playerColors = {
    { name = "Green", color = {0, 1, 0} },
    { name = "Yellow", color = {1, 1, 0} },
    { name = "Blue", color = {0, 0, 1} }
}

function setupGame.load()
    local startX, startY = 20, 20 -- posição inicial
    local markerRadius = 5

    for i = 1, 3 do -- 3 jogadores
        players.add({
            id = i,
            color = playerColors[i].color,
            colorName = playerColors[i].name,
            x = startX + (i - 1) * 10, -- Offset 
            y = startY,
            radius = markerRadius
        })

        -- distribui 4 cartas de trem para cada jogador
        local cards = {}
        for _ = 1, 4 do
            table.insert(cards, trainCards.drawCard())
        end
        players.assignTrainCards(i, cards)

        -- distribui 3 cartas de destino para cada jogador
        local destinationCards = {}
        for _ = 1, 3 do
            table.insert(destinationCards, tickets.drawCard())
        end
        players.assignDestinationCards(i, destinationCards)
    end
end

function setupGame.update(dt)
    -- Update game state if needed
end

function setupGame.draw()
end

return setupGame