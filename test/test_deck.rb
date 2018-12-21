require 'test/unit'
require_relative '../lib/deck.rb'

# Testing basic interactions with the game
class TestDeck < Test::Unit::TestCase
  def test_deck
    deck = Deck.new
    assert_equal(deck.cards.length, 52)
  end

  def test_draw
    deck = Deck.new
    assert_true(deck.draw.instance_of?(Card))
  end
end
