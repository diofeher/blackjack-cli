require_relative 'card.rb'

# Deck with cards used by the game
class Deck
  attr_accessor :suits, :cards
  def initialize
    @suits = { ace: '♠', clubs: '♣', hearts: '♥', diamonds: '♦' }
    values = (2..10).to_a + %w[A J Q K]
    @initial_cards =
      @suits.values.product(values).collect { |i, v| Card.new(i, v) }.compact
    @cards = @initial_cards.shuffle
  end

  def restart
    @cards = @initial_cards
  end

  def hit
    @cards.pop
  end
end
