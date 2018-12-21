require 'test/unit'
require_relative '../lib/game.rb'

class TestGame < Test::Unit::TestCase
  def test_player_creation
    game = Game.new(2)
    assert_equal(game.players.length, 2)
    assert_true(game.dealer.instance_of?(Player))
  end

  def test_new_round
    game = Game.new(2)
    game.new_round
    game.players.each do |player|
      assert_equal(player.hand.cards.length, 2)
    end
    assert_equal(game.dealer.hand.cards.length, 2)
  end

  def test_continue
    game = Game.new(2)
    assert_true(game.continue?)
    game.players.each do |player|
      player.money = 0
    end
    assert_false(game.continue?)
  end

  def test_hit
    game = Game.new(2)
    player = game.players[0]
    game.hit player.hand
  end

  def test_double_down
    game = Game.new(2)
    game.new_round
    hand = game.players[0].hand
    hand.current_bet = 300
    game.double_down(hand)
    assert_equal(hand.cards.length, 2)
    hand.current_bet = 100
    game.double_down(hand)
    assert_equal(hand.cards.length, 3)
    assert_equal(hand.current_bet, 200)
  end
end
