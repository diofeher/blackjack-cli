require 'byebug'

class Player
  INITIAL_MONEY = 200
  attr_accessor :money, :cards, :current_bet, :number
  def initialize(number)
    @number = number
    @money = INITIAL_MONEY
    @cards = []
    @include_face_card = false
    @current_bet = 0
  end

  def score(card)
    if card.value == 'A'
      @include_face_card ? 10 : (return 1)
    elsif %w[J Q K].include? card.value
      10
    else
      card.value
    end
  end

  def total_hand
    @cards.map { |card| score(card) }.inject(0, &:+)
  end

  def total_final
    total_hand <= 21 ? total_hand : 0
  end

  def add_card(card)
    @include_face_card = true if %w[J Q K].include? card
    @cards.push card
    @cards
  end

  def show_hand
    @cards.map &:to_s
  end

  def bet(value)
    if value % 10 != 0
      puts 'You need to bet multiples of 10'
    elsif value > @money
      puts 'You do not have that money to bet'
    else
      @current_bet = value
    end
  end

  def restart
    @cards = []
    @current_bet = 0
  end
end
