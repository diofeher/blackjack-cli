require 'test/unit'
require_relative 'lib/deck.rb'
require_relative 'lib/player.rb'

class TestDeck < Test::Unit::TestCase
  def test_deck
    deck = Deck.new
    assert_equal(deck.cards.length, 52)
  end

  def test_ace_with_face
    player = Player.new(1)
    player.add_card Card.new('♣', 'J')
    player.add_card Card.new('♣', 'A')
    assert_equal(player.cards.length, 2)
    assert_equal(player.total_hand, 21)
  end

  def test_ace_without_face
    player = Player.new(1)
    player.add_card Card.new('♣', '1')
    player.add_card Card.new('♣', 'A')
    assert_equal(player.total_hand, 2)
  end
end
