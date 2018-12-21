# Card with suit and value
class Card
  attr_accessor :suit, :value
  def initialize(suit, value)
    @suit = suit
    @value = value
    @color = %w(♥ ♦).include?(suit) ? '31' : '30'
  end

  def to_s
    "\e[#{@color};107m#{@suit}#{@value.to_s}\e[0m"
  end

  def score
    if value == 'A'
      0
    elsif %w[J Q K].include? value
      10
    else
      value.to_i
    end
  end
end
