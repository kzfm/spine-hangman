Spine = require('spine')
Game = require('models/game')

class Option extends Spine.Controller
  el: $("#options")

  constructor: ->
    super
    Game.bind "gameStartedEvent", @removeGetAnswerButton
    Game.bind "guessCheckedEvent", @showGetAnswerButton

  events:
    'click #new_game': 'startNewGame'
    'click #show_answer': 'showAnswer'

  startNewGame: -> @model.new()

  removeGetAnswerButton: -> $("#show_answer").remove()

  showGetAnswerButton: (response) =>
    if response.incorrect_guesses is @model.threshold
      @el.append('<input type="button" id="show_answer" class="action_button" value="Show answer" />')

  showAnswer: -> @model.get_answer()

module.exports = Option