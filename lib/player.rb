require 'byebug'

# Player with cards and some interactions
class Player
  UPPER_LIMIT = 21
  INITIAL_MONEY = 200
  attr_accessor :money, :cards, :current_bet, :name
  def initialize(name)
    @name = name
    @money = INITIAL_MONEY
    @cards = []
    @current_bet = 0
  end

  def total_hand
    ace_count = @cards.count { |c| c.value == 'A' }
    total = @cards.map(&:score).inject(0, &:+)
    until ace_count.zero?
      ace_count -= 1
      total += if total + 10 + (ace_count - 1) > UPPER_LIMIT
                 1
               else
                 11
               end
    end
    total
  end

  def total_final
    total_hand <= UPPER_LIMIT ? total_hand : 0
  end

  def add_card(card)
    @cards.push card
  end

  def show_hand
    @cards.map(&:to_s)
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

  def show_status
    puts "Cards: #{show_hand}"
    puts "Total: #{total_hand}"
  end
end
