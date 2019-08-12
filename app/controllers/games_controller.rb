require 'json'
require 'open-uri'

class GamesController < ApplicationController

  def new
    @grid = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    grid = params[:grid]
    word_letters = params[:word].upcase.split('')
    word = params[:word]
    @count = increment_count

    if inletters?(grid, word_letters) && api(word)['found']
      @message = "valid according to the grid and is an English word"
    elsif inletters?(grid, word_letters)
      @message = "sorry, but #{word.upcase} does not seem to be an english word "
    else
      @message = "sorry, but #{word.upcase} can't be built out grid"
    end
  end

  private

  def api(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = open(url).read
    JSON.parse(word_serialized)
  end

  def inletters?(letters, word_letters)
    word_letters.all? { |e| word_letters.count(e) <= letters.count(e) }
  end

  def increment_count
  if session[:counter].nil?
  session[:counter] = 0
  end
  session[:counter] += 1
  end

end

