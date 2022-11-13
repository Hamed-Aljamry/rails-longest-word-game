require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || "").upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end

# require 'open-uri'
# require 'json'
# class GamesController < ApplicationController
#   def new
#     @letters = (0...9).to_a.map! { ('A'..'Z').to_a.sample }
#   end
#   def score
#     @message = ''
#     url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
#     search = URI.open(url).read
#     hash = JSON.parse(search)
#     characters_are_in_grid = true
#     params[:word].upcase.each_char do |character|
#       characters_are_in_grid = params[:letters].include?(character)
#       break if characters_are_in_grid == false
#     end
#     if hash['found'] && characters_are_in_grid
#       @message = "#{params[:word]} is valid according to the grid and is an English word"
#     elsif !hash['found'] && characters_are_in_grid
#       @message = "#{params[:word]} is valid according to the grid, but is not a valid English word"
#     else
#       @message = "#{params[:word]} can’t be built out of the original grid"
#     end
#   end
# end
