local trainCards = require "trainCards"
local lovebird = require "libs.lovebird"

local players = {
    playerList = {},
    currentPlayer = nil,
}

function players.add(player)
    table.insert(players.playerList, player)
    if not players.currentPlayer then
        players.currentPlayer = player
    end
end

function players.getAll()
    return players.playerList
end

function players.total()
    return #players.playerList
end

function players.assignTrainCards(playerId, cards)
    for _, player in ipairs(players.playerList) do
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
    for _, player in ipairs(players.playerList) do
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
    for _, player in ipairs(players.playerList) do
        if player.id == playerId then
            return player.trainCards or {}
        end
    end
    return {}
end

function players.getDestinationCards(playerId)
    for _, player in ipairs(players.playerList) do
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

function players.getCurrent()
    if not players.currentPlayer and #players.playerList > 0 then
        players.currentPlayer = players.playerList[1]
    end
    return players.currentPlayer
end


function players.next()
    local current = players.currentPlayer
    if not current then
        players.currentPlayer = players.playerList[1]
        return players.currentPlayer
    end

    for i, p in ipairs(players.playerList) do
        if p.id == current.id then
            local nextIndex = (i % #players.playerList) + 1
            players.currentPlayer = players.playerList[nextIndex]
            return players.currentPlayer
        end
    end

    -- fallback: se não encontrar o atual na lista (caso raro)
    players.currentPlayer = players.playerList[1]
    return players.currentPlayer
end

return players
