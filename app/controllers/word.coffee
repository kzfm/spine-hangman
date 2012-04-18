Spine = require('spine')
Game = require('models/game')

class Word extends Spine.Controller
  el: $("#word")

  constructor: ->
    super
    Game.bind "gameStartedEvent", @render
    Game.bind "guessCheckedEvent", @displayGuessResult

  render: (response) =>
    $("#hint").show()
    @el.hide()
    @el.html require("views/word")(characters: response.word)
    @el.show()
    @

  displayGuessResult: (response) =>
    @el.html require("views/word")(characters: response.word)



module.exports = Word