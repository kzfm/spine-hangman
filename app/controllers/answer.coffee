Spine = require('spine')
Game = require('models/game')

class Answer extends Spine.Controller
  el: $("#answer")

  constructor: ->
    super
    Game.bind "gameStartedEvent", @hide
    Game.bind "answerFetchedEvent", @render

  render: (response) =>
    console.log response.answer
    if response.success is 1
       @el.html "Answer: " + response.answer
       @el.show()
    else
      alert response.message

  hide: => @el.hide()

module.exports = Answer