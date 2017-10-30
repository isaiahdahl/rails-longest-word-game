require 'date'
require 'json'
require 'open-uri'
require 'byebug'

class GameController < ApplicationController
  def game
    @grid_size = params[:grid].to_i
    @grid = []
    alphabet = ("A".."Z").to_a
    vowels = alphabet.select { |v| v =~ /[AEIOU]/ }
    consenants = alphabet.reject { |v| v =~ /[AEIOU]/ }
    @grid_size > 9 ? grid_vowels = 5 : grid_vowels = @grid_size/2
    @grid << vowels.sample(grid_vowels)
    @grid << consenants.sample(@grid_size - grid_vowels)
    @grid.flatten!.shuffle!
  end

  def score
    @grid = params[:grid].chars
    @time = params[:time].to_i
    @attempt = params[:word]
    @url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    @user_serialized = open(@url).read
    @word_parse = JSON.parse(@user_serialized)
    @attempt.upcase!
    @att = @attempt.chars.sort!
    @range = @grid.flatten.sort!
    @compare = @att.all? {|x| @range.include? x}
    @score = 10
    if @word_parse['found'] != false
      @attempt.length.times do
        @score += 3.12344543
      end
      time_score = (1..@time).to_a
      for second in time_score
        @score -= 1.1324142134
      end
    else
      @score = 0
    end
    @compare == false ? @score = 0 : @message = "Correct word not on the grid"
    if @score == 0
      @message = @message = "Word does not exist"
    else
      @score > 10 ? @message = "Well done!" : @message = "I've seen better."
    end
    @he_shoots_he = score
  end
end
