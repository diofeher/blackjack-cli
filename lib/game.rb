require_relative 'player.rb'
require_relative 'deck.rb'

# Game where all the interactions happen
class Game
  attr_accessor :number_of_players
  def initialize
    puts 'Select the number of players: '
    @number_of_players = gets.to_i
    @dealer = Player.new(0)
    @players = Array.new(@number_of_players) do |i|
      Player.new('Player ' + (i + 1).to_s)
    end
    @deck = Deck.new
  end

  def select_option(player)
    loop do
      puts 'Please select:'
      puts '1) Hit'
      puts '2) Stand'
      puts '3) Double Down'
      puts '4) Split'
      option = gets.strip
      case option
      when '1'
        puts 'HIT!'
        player.add_card @deck.hit
        player.show_status
        total = player.total_hand
        break if total >= Player::UPPER_LIMIT
      when '2'
        puts 'Stop!'
        break
      when '3'
        curr_bet = player.current_bet * 2
        if player.bet(curr_bet)
          player.add_card @deck.hit
          puts player.show_status
          break
        else
          puts 'Cannot double down.'
        end
      when '4'
        # TODO: Implement that
      else
        puts 'Invalid option.'
      end
    end
  end

  def players_round
    @dealer.add_card @deck.hit
    @dealer.add_card @deck.hit
    @players.each do |player|
      player.add_card @deck.hit
      player.add_card @deck.hit
      next if player.money.zero?

      puts "\n#{player.name}: $#{player.money} left"
      player.show_status
      while player.current_bet.zero?
        puts 'Put your current bet:'
        curr_bet = gets.to_i
        player.bet(curr_bet)
      end
      break if player.total_hand == Player::UPPER_LIMIT

      select_option(player)
    end
  end

  def dealer_round
    show_header('DEALER TIME')
    loop do
      puts "Dealer Cards: #{@dealer.show_hand}"
      total = @dealer.total_hand
      puts "Total: #{total}"
      total <= 17 ? @dealer.add_card(@deck.hit) : break
    end
  end

  def finish_round
    @players.each do |player|
      if player.total_final > @dealer.total_final
        player.money += player.current_bet * 2
      elsif player.total_final < @dealer.total_final
        player.money -= player.current_bet
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
