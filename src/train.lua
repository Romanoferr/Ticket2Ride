-- train.lua
local players = require "players"
local lovebird = require "libs.lovebird"

local train = {
    claimedTrains = {}
}

local function snapToConnection(train)
end

function train.load()
end

function train.update(dt)
end

function train.draw()
    for _, claimed in ipairs(train.claimedTrains) do
        local c = claimed.connection
        local color = claimed.color

        local x1, y1, x2, y2 = c.x1, c.y1, c.x2, c.y2
        local dx, dy = x2 - x1, y2 - y1
        local totalLength = math.sqrt(dx^2 + dy^2)
        local angle = math.atan2(dy, dx)

        -- Quantidade de trens com base na distância
        local numTrains = math.max(1, math.floor(c.distance)) -- ou c.distance / 1.5 para ajustar

        -- Margem nas extremidades da conexão
        local margin = 20

        -- Espaço disponível entre as margens
        local usableLength = totalLength - 2 * margin

        -- Espaço entre trens (centro a centro)
        local spacing = usableLength / (numTrains - 1)

        -- Vetor unitário da direção da conexão
        local ux = dx / totalLength
        local uy = dy / totalLength

        local trainLength = 20
        local trainWidth = 10

        for i = 0, numTrains - 1 do
            -- Posição do trem i ao longo da linha
            local offset = margin + i * spacing
            local px = x1 + ux * offset
            local py = y1 + uy * offset

            love.graphics.push()
            love.graphics.translate(px, py)
            love.graphics.rotate(angle)
            love.graphics.setColor(color)
            love.graphics.rectangle("fill", -trainLength/2, -trainWidth/2, trainLength, trainWidth)
            love.graphics.pop()
        end
    end
end

function train.conquer(connection, playerId)
    local player = nil
    for _, p in ipairs(players.getAll()) do
        if p.id == playerId then
            player = p
            break
        end
    end

    if not player then
        lovebird.print("Jogador não encontrado: " .. tostring(playerId))
        return
    end

    table.insert(train.claimedTrains, {
        connection = connection,
        playerId = playerId,
        color = player.color
    })

    lovebird.print("Trem conquistado pelo jogador: " .. tostring(playerId))
end


return train