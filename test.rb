require 'test/unit'
require_relative 'lib/deck.rb'
require_relative 'lib/player.rb'

# Testing basic interactions with the game
class TestDeck < Test::Unit::TestCase
  def test_deck
    deck = Deck.new
    assert_equal(deck.cards.length, 52)
  end

  def test_ace_little
    player = Player.new(1)
    player.add_card Card.new('♣', 'J')
    player.add_card Card.new('♣', 'A')
    assert_equal(player.cards.length, 2)
    assert_equal(player.total_hand, 21)
  end

  def test_more_than_one_ace
    player = Player.new(1)
    player.add_card Card.new('♣', '1')
    player.add_card Card.new('♣', 'A')
    player.add_card Card.new('♥', 'A')
    player.add_card Card.new('♦', 'A')
    assert_equal(player.total_hand, 14)
  end

  def test_ace_high
    player = Player.new(1)
    player.add_card Card.new('♣', '9')
    player.add_card Card.new('♣', 'A')
    player.add_card Card.new('♣', '7')
    assert_equal(player.total_hand, 17)
  end
end
