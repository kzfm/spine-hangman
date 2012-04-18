Spine = require('spine')

class Game extends Spine.Model
  @configure 'Game'

  win: false
  lost: false
  threshold: 6

  new: =>
    $.ajax(
      url: "/new",
      type: "POST",
      dataType: "json",
      success: (response) ->
        @lost = false
        @win = false
        Game.trigger "gameStartedEvent", response
    )

  check: =>
    return if @win or @lost
    $.ajax(
      url: "/check",
      type: "POST",
      data: {char_clicked: @char_clicked},
      dataType: "json",
      success: (response) ->
        if response.incorrect_guesses >= @threshold
          @lost = true
        if response.win
          @win = true
        Game.trigger "guessCheckedEvent", response
    )

  get_answer: =>
    #console.log @lost
    #return if not @lost

    $.ajax(
      url: "/answer",
      type: "POST",
      dataType: "json",
      success: (response) ->
        Game.trigger "answerFetchedEvent", response
    )

module.exports = Game