require_relative 'game.rb'

# Game where all the interactions happen and I/O
class GameInteraction
  attr_reader :game
  def initialize
    number = 0
    puts 'Select the number of players: '
    number = gets.to_i while number.zero?
    @game = Game.new(number)
  end

  def play
    loop do
      show_table
      @game.new_round
      players_play
      dealer_play
      @game.finish_round
      next if @game.continue?

      show_table
      puts 'END OF GAME - Dealer won'
      exit
    end
  end

  def show_header(text)
    puts '----------------'
    puts text
    puts '----------------'
  end

  def dealer_play
    show_header('DEALER\'S TIME!')
    @game.dealer_round
    puts @game.dealer.hands[0].status
  end

  def players_play
    @game.players.each do |player|
      next if player.money.zero?

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

  def select_option(player, hand)
    loop do
      show_menu(hand)
      option = gets.strip
      case option
      when '1'
        puts 'HIT!'
        total = @game.hit hand
        puts hand.status
        break if total >= Hand::UPPER_LIMIT
      when '2'
        puts 'STAND!'
        break
      when '3'
        if @game.double_down hand
          puts hand.status
          break
        else
          puts 'Cannot double down.'
        end
      when '4'
        next unless hand.can_split

        @game.split player
        puts hand.status
      else
        puts 'Invalid option.'
      end
    end
  end

  def show_menu(hand)
    puts 'Please select:'
    puts '1) Hit'
    puts '2) Stand'
    puts '3) Double Down' if hand.can_double_down
    puts '4) Split' if hand.can_split
  end

  def show_table
    show_header('TABLE')
    @game.players.each do |player|
      puts " #{player.name}: $#{player.money}"
    end
    puts "----------------\n\n"
  end
end
