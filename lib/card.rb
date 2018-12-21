# Card with suit and value
class Card
  attr_accessor :suit, :value
  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    "#{@suit}#{@value.to_s}"
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
