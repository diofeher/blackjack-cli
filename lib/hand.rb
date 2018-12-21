# Hand - needed to split in this class to make split work
class Hand
  UPPER_LIMIT = 21
  attr_accessor :cards, :current_bet
  def initialize(player, current_bet = 0)
    @player = player
    @cards = []
    @current_bet = current_bet
  end

  def remove_card
    @cards.pop
  end

  def add_card(card)
    @cards.push card
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

  def can_split
    (@cards.length == 2) && (@cards[0].value == @cards[1].value) && @player.hands.length < 2
  end

  def can_double_down
    (@cards.length == 2) && !@player.splitted
  end

  def show_hand
    @cards.map(&:to_s)
  end

  def status
    "Cards: #{show_hand}\nTotal: #{total_hand}\nCurrent Bet: #{current_bet}"
  end

  def bet(value)
    if value % 10 != 0
      puts 'You need to bet multiples of 10'
    elsif value > @player.money
      puts 'You do not have that money to bet'
    else
      @current_bet = value
    end
  end
end
