local gameManager = require "gameManager"

describe('gameManager state', function()
    it('deve iniciar no estado mainMenu', function()
        assert.are.equal(gameManager.state, 'mainMenu')
    end)

    it('o score inicial deve ser zero', function()
        assert.are.equal(gameManager.score, 0)
    end)

    it('deve ser capaz de alterar entre estados que existam no jogo', function()
        gameManager.changeState('opcoes')
        assert.are.equal(gameManager.state, 'opcoes')
    end)

end)

