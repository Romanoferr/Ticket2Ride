local sound = {
}

sound.volume = 0.4

function sound.load()
    sound.musicaJogo = love.audio.newSource("assets/efeitos_sonoros/best-game-console-301284.mp3", "stream")
    sound.musicaJogo:setLooping(true)
    sound.musicaJogo:setVolume(sound.volume)

end

function sound.play()
    if sound.musicaJogo and not sound.musicaJogo:isPlaying() then
        sound.musicaJogo:play()
    end
end

function sound.getter()
    return sound.volume * 100
end

function sound.setter(v)
    sound.musicaJogo:setVolume(v)
end

return sound