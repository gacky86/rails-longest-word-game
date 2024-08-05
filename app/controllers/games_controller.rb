require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    alphabets = ("A".."Z").to_a
    10.times { @letters << alphabets.sample }
  end

  def score
    # @answer = params[:answer]
    # raise
    grid = params[:letters].chars
    url = "https://dictionary.lewagon.com/#{params[:answer]}"
    result_serialized = URI.open(url).read
    result = JSON.parse(result_serialized)
    check_dict = result["found"]
    length = result["length"]

    check_grid = true
    params[:answer].each_char do |letter|
      grid.include?(letter.upcase) ? grid.delete_at(grid.index(letter.upcase)) : check_grid = false
    end

    @result_text = ""
    if !check_grid
      @result_text = "Sorry, but #{params[:answer]} can't be built out of #{params[:letters]}"
    elsif !check_dict
      @result_text = "Sorry, but #{params[:answer]} doesn't seem to be a valid English word"
    else
      @result_text = "Congraturations! #{params[:answer]} is a valid English word"
    end
  end
end
