require_relative 'player.rb'
require_relative 'deck.rb'

# Game with business logic
class Game
  attr_accessor :players, :dealer, :deck
  def initialize(number_of_players = 0)
    @dealer = Player.new('Dealer')
    @players = Array.new(number_of_players) do |i|
      Player.new('Player ' + (i + 1).to_s)
    end
    @deck = Deck.new
  end

  def new_round
    2.times { @dealer.hands[0].add_card @deck.hit }
    @players.each do |player|
      2.times { player.hands[0].add_card @deck.hit }
    end
  end

  def dealer_round
    hand = @dealer.hands[0]
    total = hand.total_hand
    hand.add_card(@deck.hit) if total < 17
  end

  def finish_round
    @players.each do |player|
      player.hands.each do |hand|
        if hand.total_final > @dealer.hands[0].total_final
          player.money += if player.splitted
                            hand.current_bet
                          else
                            hand.current_bet * 3 / 2
                          end
        elsif hand.total_final < @dealer.hands[0].total_final
          player.money -= hand.current_bet
        end
      end
      player.restart
    end
    @dealer.restart
    @deck.restart
  end

  def continue?
    @players.any? { |player| player.money > 0 }
  end

  def hit(hand)
    hand.add_card @deck.hit
    hand.total_hand
  end

  def double_down(hand)
    curr_bet = hand.current_bet * 2
    if hand.bet(curr_bet)
      hand.add_card @deck.hit 
    else
      false
    end
  end

  def split(player)
    hand = player.hands[0]
    second_hand = player.split!
    hand.add_card(@deck.hit)
    second_hand.add_card(@deck.hit)
  end
end
