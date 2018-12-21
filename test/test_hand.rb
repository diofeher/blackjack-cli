require 'test/unit'
require_relative '../lib/deck.rb'
require_relative '../lib/player.rb'

# Testing basic interactions with the game
class TestHand < Test::Unit::TestCase
  def test_ace_blackjack
    hand = Hand.new(1)
    hand.add_card Card.new('♣', 'J')
    hand.add_card Card.new('♣', 'A')
    assert_equal(hand.cards.length, 2)
    assert_equal(hand.total_hand, 21)
  end

  def test_more_than_one_ace
    hand = Hand.new(1)
    hand.add_card Card.new('♣', '1')
    hand.add_card Card.new('♣', 'A')
    hand.add_card Card.new('♥', 'A')
    hand.add_card Card.new('♦', 'A')
    assert_equal(hand.total_hand, 14)
  end

  def test_ace_high
    hand = Hand.new(1)
    hand.add_card Card.new('♣', '9')
    hand.add_card Card.new('♥', 'A')
    hand.add_card Card.new('♣', '7')
    assert_equal(hand.total_hand, 17)
  end

  def test_split
    player = Player.new('Test')
    hand = player.hands[0]
    card1 = Card.new('♣', '9')
    card2 = Card.new('♥', '9')
    hand.current_bet = 100
    hand.add_card card1
    hand.add_card card2
    assert_true(hand.can_split)
    second_hand = player.split!
    assert_equal(hand.cards.length, 1)
    assert_equal(hand.current_bet, 50)
    assert_equal(second_hand.cards.length, 1)
    assert_equal(second_hand.current_bet, 50)
  end
end
