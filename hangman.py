from flask import Flask, session, render_template, jsonify, request
from random import random
import math

SECRET_KEY = 'hangmanyoungman'
DEBUG = True

app = Flask(__name__)
app.config.from_object(__name__)
app.jinja_env.add_extension('pyjade.ext.jinja.PyJadeExtension')


def get_random():
    words = open("countries.txt").readlines()
    idx = int(math.floor((random() * len(words))))
    return words[idx][:-1].upper()


def masquerade(word):
    return [' ' if c == ' ' else '&nbsp;' for c in word]


def reveal(last_revealed_word, char_clicked, final_word):
    chars = list(final_word)
    return [b if a == '&nbsp;' and b == char_clicked else a for a, b in zip(last_revealed_word, chars)]


def chars_left(revealed_word):
    return revealed_word.count('&nbsp')


def is_win(chars_left, incorrect_guesses):
    return chars_left == 0 and incorrect_guesses < 6


def is_correct_guess(char_clicked, final_word):
    return char_clicked in final_word


@app.route('/')
def index():
    return render_template('index.jade')


@app.route('/new', methods=['POST'])
def new_word():
    word = get_random()
    masquerade_word = masquerade(word)

    session['word'] = word
    session['incorrect_guesses'] = 0
    session['chars_left'] = len(word)
    session['revealed_word'] = masquerade_word
    return jsonify(word=masquerade_word)


@app.route('/check', methods=['POST'])
def check_word():
    final_word = session['word']
    app.logger.debug(final_word)
    app.logger.debug("data: " + request.data)
    app.logger.debug("form: " + str(request.form))
    char_clicked = request.form['char_clicked']
    correct_guess = is_correct_guess(char_clicked, final_word)
    win = False
    
    if correct_guess:
        session['revealed_word'] = reveal(session['revealed_word'], char_clicked, final_word)
        session['chars_left'] = chars_left(session['revealed_word'])
    else:
        session['incorrect_guesses'] += 1
    win = is_win(session['chars_left'], session['incorrect_guesses'])
    return jsonify(word=session['revealed_word'], correct_guess=correct_guess, incorrect_guesses=session['incorrect_guesses'], win=win)


@app.route('/answer', methods=['POST'])
def answer_word():
    if session['incorrect_guesses'] < 6 and session['chars_left'] > 0:
        return jsonify(success=-1, message="You haven't finished the game yet")
    else:
        return jsonify(success=1, answer=session['word'])


if __name__ == '__main__':
    app.run()
