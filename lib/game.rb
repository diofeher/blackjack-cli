require_relative 'player.rb'
require_relative 'deck.rb'

class Game
  attr_accessor :number_of_players
  def initialize
    puts 'Select the number of players: '
    @number_of_players = gets.to_i
    @dealer = Player.new(0)
    @players = Array.new(@number_of_players) { |i| Player.new(i + 1) }
    @deck = Deck.new
  end

  def players_round
    @dealer.add_card @deck.hit
    @dealer.add_card @deck.hit
    @players.each do |player|
      player.add_card @deck.hit
      player.add_card @deck.hit
      next if player.money == 0

      puts "Player #{player.number}: $#{player.money} left"
      puts "Cards: #{player.show_hand}" 
      puts "Total: #{player.total_hand}"
      while player.current_bet == 0
        puts 'Put your current bet:'
        curr_bet = gets.to_i
        player.bet(curr_bet)
      end
      loop do
        puts 'Please select:'
        puts '1) Hit'
        puts '2) Stand'
        puts '3) Double Down'
        option = gets.strip
        case option
        when '1'
          player.add_card @deck.hit
          puts "Cards: #{player.show_hand}"
          total = player.total_hand
          puts "Total: #{total}"
          puts 'HIT!'
          break if total >= 21
        when '2'
          puts 'Stop!'
          break
        when '3'
          curr_bet = player.current_bet * 2
          player.bet(curr_bet)
        else
          puts 'Invalid option'
        end
      end
    end
  end

  def dealer_round
    puts '--------------'
    puts 'DEALER TIME'
    puts '--------------'
    loop do
      puts "Dealer Cards: #{@dealer.show_hand}"
      total = @dealer.total_hand
      puts "Total: #{total}"
      if total <= 17
        @dealer.add_card @deck.hit
      else
        break
      end
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
    puts ' ---------------'
    puts '|    TABLE      |'
    puts ' ---------------'
    @players.each do |player|
      puts " Player #{player.number}: $#{player.money}"
    end
    puts "----------------\n\n"
  end

  def check_end_game
    !@players.all? { |player| player.money > 0 }
  end

  def play
    loop do
      show_table
      players_round
      dealer_round
      finish_round
      show_table
      if check_end_game
        puts 'END OF GAME - Dealer won'
        exit
      end
    end
  end
end
