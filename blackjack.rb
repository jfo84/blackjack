#!/usr/bin/env ruby

class PlayingCard

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

end

SUITS = ['♦', '♣', '♠', '♥']
VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
SCORES = [ 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11 ]

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
  attr_accessor :scoring_hash

  def initialize(deck)
    @hand_contents = []
    2.times do
      @hand_contents << deck.draw!
    end
    scoring_hash_initialize
  end

  def scoring_hash_initialize
    @scoring_hash = Hash[VALUES.zip(SCORES.map {|values| values})]
  end

  def score
    sum = 0
    @scoring_hash.each do |value, score|
      hand_contents.each do |card|
        if value == card.rank
          sum += score
        end
        if card.rank == 'A' && sum > 21
          sum -= 10
        end
      end
    end
    sum
  end

end

class Game

  attr_accessor :deck, :player_hand, :dealer_hand, :ace_answer

  def initialize(deck, player_hand, dealer_hand)
    @deck = deck
    @player_hand = player_hand
    @dealer_hand = dealer_hand
  end

  def win
    abort "You win. Your hand had a score of #{player_hand.score} while the dealer had a score of #{dealer_hand.score}."
  end

  def lose
    puts "The dealer drew:"
    dealer_hand.hand_contents.each do |card|
      puts "#{card.rank}#{card.suit}"
    end
    abort "You lose. Your hand had a score of #{player_hand.score} while the dealer had a score of #{dealer_hand.score}."
  end

  def player_question
    puts "Dealer says hit or stand. Respond."
    choice = gets.chomp
    player_hit(choice)
  end

  def draw
    player_hand.hand_contents << @deck.draw!
    puts "You drew a #{player_hand.hand_contents.last.rank}#{player_hand.hand_contents.last.suit}."
  end

  def player_hit(choice)
    if choice == "hit"
      draw
      greater_than_twenty_one_check
      puts "Your hand has a score of #{player_hand.score}."
      player_question
    elsif choice == "stand"
      dealer_hit
    else
      player_question
    end
  end

  def dealer_hit
    until dealer_hand.score > 18
      dealer_hand.hand_contents << @deck.draw!
      dealer_hit
    end
    greater_than_twenty_one_check
  end

  def greater_than_twenty_one_check
    if player_hand.score > 21
      puts "You busted!"
      lose
    end
    if dealer_hand.score > 21
      puts "Dealer busted."
      win
    end
  end

  def game_over
    if dealer_hand.score > player_hand.score
      lose
    elsif dealer_hand.score == player_hand.score
      abort "You tied! Both players had a score of #{dealer_hand.score}."
    else
      win
    end
  end
end

deck = Deck.new; player_hand = Hand.new(deck); dealer_hand = Hand.new(deck)
game = Game.new(deck, player_hand, dealer_hand)
puts "Let's play blackjack!"
puts "Your opening hand is a #{player_hand.hand_contents.first.rank}#{player_hand.hand_contents.first.suit} and a #{player_hand.hand_contents.last.rank}#{player_hand.hand_contents.last.suit}."
game.player_question
game.game_over
