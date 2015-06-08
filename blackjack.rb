#!/usr/bin/env ruby

# YOUR CODE HERE

require 'pry'

class PlayingCard

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

end

SUITS = ['♦', '♣', '♠', '♥']
VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
SCORES = [ 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 1 ]

class Deck

  def initialize
    @card_deck = []
    VALUES.each do |value|
      SUITS.each do |suit|
        @card_deck << PlayingCard.new(value, suit)
      end
    end
    @card_deck.shuffle!
  end

  def draw!
    @card_deck.pop
  end
end

class Hand

  attr_reader :deck

  def initialize(deck)
    @hand_contents = []
    2.times do
      @hand_contents << deck.draw!
    end
  end

  def create_scoring_hash
    @scoring_hash = Hash[VALUES.zip(SCORES.map {|values| values})]
    # we need some way to change A value to 11
  end

  def score
    create_scoring_hash
    sum = 0
    @scoring_hash.each do |value, score|
      @hand_contents.each do |card|
        if value == card.rank
          sum += score
        end
      end
    end
    sum
  end
end

class Game

  attr_accessor :deck, :player_hand, :dealer_hand, :win, :lose

  def initialize
    @deck = Deck.new
    @player_hand = Hand.new(@deck)
    @dealer_hand = Hand.new(@deck)
    @win = false
    @lose = false
  end

  def win?
    @win = true
    puts "You win. Your hand had a score of #{@player_hand.score} while the dealer had a score of #{@dealer_hand.score}"
  end

  def lose?
    @lose = true
    puts "You lose. Your hand had a score of #{@player_hand.score} while the dealer had a score of #{@dealer_hand.score}"
  end

  def player_hit(choice)
    if choice == "hit"
      @player_hand << @deck.draw!
    elsif @player_hand.score > 21
      lose? == true
    end
    puts "Your hand has a score of #{@player_hand.score}."
  end

  def dealer_hit
    until @dealer_hand.score >= 17
      @dealer_hand << @deck.draw!
    end
    if @dealer_hand.score > 21
      win? == true
    end
    puts "The dealer's hand has a score of #{@dealer_hand.score}."
  end

  def game_winner
    if @dealer_hand.score > @player_hand.score
      lose?
    elsif @dealer_hand.score == @player_hand.score
      puts "You tied!"
    else
      win?
    end
  end
end

game = Game.new

binding.pry

puts "Let's play blackjack!!!"
puts "You have a #{@player_hand.hand_contents.first.rank}#{@player_hand.hand_contents.first.suit} and a #{@player_hand.hand_contents.last.rank}#{@player_hand.last.suit}"
puts "Dealer says hit or stand. Respond."
player_choice = gets.chomp
game.player_hit(player_choice)
puts "You drew a #{@player_hand.hand_contents.last.rank}#{@player_hand.hand_contents.last.suit}."
puts "Are you done hitting?"
player_choice = gets.chomp
game.player_hit(player_choice)
puts "You drew a #{@player_hand.hand_contents.last.rank}#{@player_hand.hand_contents.last.suit}."
puts "That's probably enough times. My turn."
game.dealer_hit
game.game_winner
