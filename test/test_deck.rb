require 'test/unit'
require_relative '../lib/deck.rb'

# Testing basic interactions with the game
class TestDeck < Test::Unit::TestCase
  def test_deck
    deck = Deck.new
    assert_equal(deck.cards.length, 52)
  end
end
