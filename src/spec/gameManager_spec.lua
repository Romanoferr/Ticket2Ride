describe('gameManager', function()

    local gameManager

    before_each(function ()
        gameManager = require "gameManager"
        gameManager.setStates({ test = { { load = function() end } } })
    end)

    it('deve iniciar no estado mainMenu', function()
        assert.are.equal(gameManager.state, 'mainMenu')
    end)

    it('o score inicial deve ser zero', function()
        assert.are.equal(gameManager.score, 0)
    end)

    it('o valor inicial dos jogadores está como nil', function ()
        assert.are.equal(gameManager.player, nil)
    end)

    it('deve ser capaz de alterar entre estados que existam no jogo', function()
        gameManager.changeState("test")
        assert.are.equal(gameManager.state, "test")
    end)

end)

