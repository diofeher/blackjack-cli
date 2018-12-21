require 'test/unit'
require_relative '../lib/game.rb'

class TestGame < Test::Unit::TestCase
  def setup
    @game = Game.new(2)
    assert_equal(@game.players.length, 2)
  end

  def test_new_round
    @game.new_round
    @game.players.each do |player|
      assert_equal(player.hands[0].cards.length, 2)
    end
    assert_equal(@game.dealer.hands[0].cards.length, 2)
  end
end
