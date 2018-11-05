require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    grid = []
    10.times do
      letter = ('A'...'Z').to_a.sample
      grid << letter
    end
    @grid = grid
  end

  def score
    @grid = params["grid"]
    run_game(params["attempt"])
  end
end

def run_game(attempt)
  @result = { score: attempt.length, message: "well done!" }
  dictionary = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
  @result = { score: 0, message: "not an english word" } unless dictionary["found"]
  @result = check_grid(@grid, attempt, @result)
end

def check_grid(grid, attempt, result)
  attempt.upcase.split("").each do |letter|
    if @grid.include?(letter)
      @result = @result
    else
      @result[:score] = 0
      @result[:message] = "not in the grid"
    end
  end
  return @result
end
