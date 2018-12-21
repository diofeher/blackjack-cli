require 'test/unit'
require_relative '../lib/game_interaction.rb'

class FakeInput
  def gets
    @stubbed_input ||= %w[2]
    @stubbed_input.shift
  end
end

class FakeOutput
  def write(text)
  end
end

$stdin = FakeInput.new
$stdout = FakeOutput.new

class TestGameInteraction < Test::Unit::TestCase
  def test_game_setup
    blackjack = GameInteraction.new
    assert_equal(blackjack.game.players.length, 2)
  end
end
