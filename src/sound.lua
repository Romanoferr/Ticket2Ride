local sound = {
}

sound.volume = 0.4

sound.musicaJogo = nil

function sound.load()
    if not sound.musicaJogo then
        sound.musicaJogo = love.audio.newSource("assets/efeitos_sonoros/best-game-console-301284.mp3", "stream")
        sound.musicaJogo:setLooping(true)
        sound.musicaJogo:setVolume(sound.volume)
    end
end

function sound.play()
    if sound.musicaJogo then
        if not sound.musicaJogo:isPlaying() then
            sound.musicaJogo:play()
        end
    end
end

function sound.getter()
    return sound.volume * 100
end

function sound.setter(v)
    sound.volume = v/100
    sound.musicaJogo:setVolume(v)
end

return sound