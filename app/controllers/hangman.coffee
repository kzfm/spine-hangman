Spine = require('spine')
Game = require('models/game')

class Hangman extends Spine.Controller
  el: $("#ground")

  constructor: ->
    super
    @body_parts = [$("#head"), $("#body"), $("#right_arm"),
                   $("#left_arm"), $("#right_leg"), $("#left_leg")]
    Game.bind "gameStartedEvent", @clearHangman
    Game.bind "guessCheckedEvent", @drawHangman

  drawHangman: (response) =>
    if not response.correct_guess
      p = @body_parts[parseInt(response.incorrect_guesses)-1]
      p.css("visibility", "visible")

  clearHangman: ->
    $("#string").css("visibility", "visible")
    for p in @body_parts
      p.css("visibility", "hidden")

module.exports = Hangman