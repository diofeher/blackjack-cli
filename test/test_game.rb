require 'test/unit'
require_relative '../lib/game.rb'

class FakeInput
  def gets
    @stubbed_input ||= %w[1]
    @stubbed_input.shift
  end
end

$stdin = FakeInput.new

class TestGame < Test::Unit::TestCase
    def test_game
        game = Game.new
        assert_equal(game.number_of_players, 1)
    end
end