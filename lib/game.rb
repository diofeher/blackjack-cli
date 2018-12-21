require_relative 'player.rb'
require_relative 'deck.rb'

# Game where all the interactions happen
class Game
  attr_accessor :number_of_players
  def initialize
    @number_of_players = 0
    puts 'Select the number of players: '
    @number_of_players = gets.to_i while @number_of_players.zero?
    @dealer = Player.new('Dealer')
    @players = Array.new(@number_of_players) do |i|
      Player.new('Player ' + (i + 1).to_s)
    end
    @deck = Deck.new
  end

  def show_menu(hand)
    puts 'Please select:'
    puts '1) Hit'
    puts '2) Stand'
    puts '3) Double Down' if hand.can_double_down
    puts '4) Split' if hand.can_split
  end

  def select_option(player, hand)
    loop do
      show_menu(hand)
      option = gets.strip
      case option
      when '1'
        puts 'HIT!'
        hand.add_card @deck.hit
        puts hand.status
        total = hand.total_hand
        break if total >= Hand::UPPER_LIMIT
      when '2'
        puts 'Stop!'
        break
      when '3'
        curr_bet = hand.current_bet * 2
        if hand.bet(curr_bet)
          hand.add_card @deck.hit
          puts hand.status
          break
        else
          puts 'Cannot double down.'
        end
      when '4'
        next unless hand.can_split

        second_hand = player.split!
        hand.add_card(@deck.hit)
        second_hand.add_card(@deck.hit)
        puts hand.status
      else
        puts 'Invalid option.'
      end
    end
  end

  def players_round
    2.times { @dealer.hands[0].add_card @deck.hit }
    @players.each do |player|
      next if player.money.zero?

      2.times { player.hands[0].add_card @deck.hit }
      player.hands.each do |hand|
        puts "\n#{player.name}: $#{player.money} left"
        puts hand.status
        while hand.current_bet.zero?
          puts 'Put your current bet:'
          curr_bet = gets.to_i
          hand.bet(curr_bet)
        end
        break if hand.total_hand == Hand::UPPER_LIMIT

        select_option(player, hand)
      end
    end
  end

  def dealer_round
    show_header('DEALER\'S TIME!')
    hand = @dealer.hands[0]
    puts hand.status
    total = hand.total_hand
    hand.add_card(@deck.hit) if total < 17
    puts hand.status
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

  def show_table
    show_header('TABLE')
    @players.each do |player|
      puts " #{player.name}: $#{player.money}"
    end
    puts "----------------\n\n"
  end

  def continue_game?
    @players.any? { |player| player.money > 0 }
  end

  def show_header(text)
    puts '----------------'
    puts text
    puts '----------------'
  end

  def play
    loop do
      show_table
      players_round
      dealer_round
      finish_round
      next if continue_game?

      show_table
      puts 'END OF GAME - Dealer won'
      exit
    end
  end
end
