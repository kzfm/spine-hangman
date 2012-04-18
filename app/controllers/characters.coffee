Spine = require('spine')
Game = require('models/game')

class Characters extends Spine.Controller
  el: $("#characters")

  events:
    'click .character': "charClicked"

  constructor: ->
    super
    Game.bind "gameStartedEvent", @render
    Game.bind "guessCheckedEvent", @disableCharacter

  render: =>
    @el.html require("views/character")(
      characters: ['A', 'B', 'C', 'D', 'E', 'F', 'G',
                   'H', 'I', 'J', 'K', 'L', 'M', 'N',
                   'O', 'P', 'Q', 'R', 'S', 'T', 'U',
                   'V', 'X', 'Y', 'Z', 'W', '&'])
    @el.show()
    @

  charClicked: (e) ->
    return if (@model.lost)

    target = $(e.target)
    @model.target = null
    @model.char_clicked = target.attr("char")
    @model.target = target
    @model.check()

  disableCharacter: (response) =>
    if response.correct_guess
      @model.target.removeClass("character").addClass("disabled")

module.exports = Characters