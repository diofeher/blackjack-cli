require 'byebug'
require_relative 'hand.rb'

# Player with cards and some interactions
class Player
  attr_accessor :money, :name, :hands, :splitted
  def initialize(name, initial_money = 200)
    @name = name
    @money = initial_money
    @splitted = false
    @hands = [Hand.new(self)]
  end

  def hand
    hands[0]
  end

  def split!
    @splitted = true
    first_hand = hand
    curr_bet = first_hand.current_bet / 2
    first_hand.current_bet = curr_bet

    second_hand = Hand.new(self, curr_bet)
    second_hand.add_card first_hand.remove_card
    hands.push second_hand
    second_hand
  end

  def restart
    @splitted = false
    @hands = [Hand.new(self)]
  end
end
