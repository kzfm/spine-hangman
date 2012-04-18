require('lib/setup')

Spine = require('spine')
Game = require('models/game')
Option = require('controllers/option')
Characters = require('controllers/characters')
Word = require('controllers/word')
Answer = require('controllers/answer')
Hangman = require('controllers/hangman')

class App extends Spine.Controller
  constructor: ->
    super
    game = new Game
    option = new Option model: game
    characters = new Characters model: game
    word = new Word model: game
    answer = new Answer model: game
    hangman = new Hangman model: game

module.exports = App
