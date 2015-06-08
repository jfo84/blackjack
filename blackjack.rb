#!/usr/bin/env ruby

# YOUR CODE HERE

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

class Hand < Array

  attr_reader :deck, :hand_contents

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

  def initialize(deck, player_hand, dealer_hand)
    @deck = deck
    @player_hand = player_hand
    @dealer_hand = dealer_hand
    @win = false
    @lose = false
  end

  def win?
    puts "You win. Your hand had a score of #{@player_hand.score} while the dealer had a score of #{@dealer_hand.score}"
    @win = true
  end

  def lose?
    puts "You lose. Your hand had a score of #{@player_hand.score} while the dealer had a score of #{@dealer_hand.score}"
    @lose = true
  end

  def player_talk
    puts "Dealer says hit or stand. Respond."
    choice = gets.chomp
    player_hit(choice)
  end

  def player_hit(choice)
    if choice == "hit"
      @player_hand.hand_contents << @deck.draw!
      @player_hand.score
      greater_than_twenty_one_check
      puts "You drew a #{player_hand.hand_contents.last.rank}#{player_hand.hand_contents.last.suit}."
      puts "Your hand has a score of #{@player_hand.score}."
    elsif choice == "stand"
      dealer_hit
    else
      player_hit
    end
  end

  def greater_than_twenty_one_check
    if @player_hand.score > 21
      puts "You busted!"
      lose?
    end
    if @dealer_hand.score > 21
      puts "Dealer busted. You win!"
      win?
    end
  end

  def dealer_hit
    until @dealer_hand.score > 18
      @dealer_hand.hand_contents << @deck.draw!
      @dealer_hand.score
      puts "The dealer's hand has a score of #{@dealer_hand.score}."
    end
    greater_than_twenty_one_check
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

until @win == true || @lose == true
  deck = Deck.new; player_hand = Hand.new(deck); dealer_hand = Hand.new(deck)
  game = Game.new(deck, player_hand, dealer_hand)
  puts "Let's play blackjack!!!"
  puts "Your opening hand is a #{player_hand.hand_contents.first.rank}#{player_hand.hand_contents.first.suit} and a #{player_hand.hand_contents.last.rank}#{player_hand.hand_contents.last.suit}."
  game.player_talk
  game.game_winner
end
