local trainCards = require "trainCards"
local lovebird = require "libs.lovebird"

local players = {}

local playerList = {}

function players.add(player)
    table.insert(playerList, player)
end

function players.getAll()
    return playerList
end

function players.assignTrainCards(playerId, cards)
    for _, player in ipairs(playerList) do
        if player.id == playerId then
            player.trainCards = player.trainCards or {}
            for _, card in ipairs(cards) do
                table.insert(player.trainCards, card)
            end
            return
        end
    end
end

function players.assignDestinationCards(playerId, cards)
    for _, player in ipairs(playerList) do
        if player.id == playerId then
            player.destinationCards = player.destinationCards or {}
            for _, ticket in ipairs(cards) do
                table.insert(player.destinationCards, ticket) -- Fixed to insert individual tickets
            end
            return
        end
    end
end

-- get cards per player
function players.getTrainCards(playerId)
    for _, player in ipairs(playerList) do
        if player.id == playerId then
            return player.trainCards or {}
        end
    end
    return {}
end

function players.getDestinationCards(playerId)
    for _, player in ipairs(playerList) do
        if player.id == playerId then
            return player.destinationCards or {}
        end
    end
    return {}
end

function players.draw()
    for _, player in ipairs(players.getAll()) do
        love.graphics.setColor(player.color)
        love.graphics.circle("fill", player.x, player.y, player.radius)
        love.graphics.print("ID: " .. player.id, 4 * (player.x + 20), player.y + 20)

        for _, card in ipairs(player.trainCards) do
            love.graphics.print(trainCards.colorMap[card], 4 * (player.x + 20), player.y + 30 * _)
            -- lovebird.print(string.format("Player %d Train Card: %s", player.id, trainCards.colorMap[card]))
        end

        for _, ticket in ipairs(player.destinationCards) do
            love.graphics.print(ticket.startCity .. " - " .. ticket.endCity, 200 + (15*player.x), player.y + 30 * _)
            -- lovebird.print(string.format("Player %d Destination Ticket: %s - %s", player.id, ticket.startCity, ticket.endCity))
        end


    end
end

return players
