-- train.lua

local train = {
}

function train.load()

end

function train.update ()
    
end

function train.draw ()
    love.graphics.setColor(1, 1, 0) -- Amarelo para o trem
    love.graphics.setLineWidth(1)
    local vertices = {100,100, 200,100, 150,200}

    love.graphics.polygon("fill", vertices)
end
