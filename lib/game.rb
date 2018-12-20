require_relative 'player.rb'
require_relative 'deck.rb'

class Game
    attr_accessor :number_of_players
    def initialize
        puts 'Select the number of players: '
        @number_of_players = gets.to_i
        @dealer = Player.new(0)
        @players = Array.new(@number_of_players){ |i| Player.new(i+1) }
        @deck = Deck.new
    end

    def players_round
        @dealer.add_card @deck.hit
        @dealer.add_card @deck.hit
        @players.each { |player|
            player.add_card @deck.hit
            player.add_card @deck.hit
            next if player.money == 0
            puts 'Player %i: $%d left' % [player.number, player.money]
            puts 'Cards: %s' % [player.show_hand]
            puts 'Total: %s' % player.total_hand
            while player.current_bet == 0
                puts 'Put your current bet:'
                curr_bet = gets.to_i
                player.bet(curr_bet)
            end
            while true
                puts 'Please select:'
                puts '1) Hit'
                puts '2) Stand'
                puts '3) Double Down'
                puts '4) Split'
                option = gets.strip
                case option
                when '1'
                    player.add_card @deck.hit
                    puts 'Cards: %s' % [player.show_hand]
                    total = player.total_hand
                    puts 'Total: %s' % total
                    puts 'HIT!'
                    if total >= 21
                        break
                    end
                when '2'
                    puts 'Stop!'
                    break
                else 
                    puts 'Invalid option'
                end
            end
        }
    end

    def dealer_round
        puts '--------------'
        puts 'DEALER TIME'
        puts '--------------'
        while true
            puts 'Dealer Cards: %s' % [@dealer.show_hand]
            total = @dealer.total_hand
            puts 'Total: %s' % total
            if total <= 17
                @dealer.add_card @deck.hit
            else
                break
            end
        end
    end

    def finish_round
        @players.each { |player|
            if player.total_final > @dealer.total_final
                player.money += player.current_bet * 2
            elsif player.total_final < @dealer.total_final
                player.money -= player.current_bet
            end
            player.restart
        }
        @dealer.restart
        @deck.restart
    end

    def show_table
        puts ' ---------------'
        puts '|    TABLE      |'
        puts ' ---------------'
        @players.each { |player|
            puts ' Player %s: $%s' % [player.number, player.money]
        }
        puts "----------------\n\n"
    end

    def check_end_game
        not @players.all? {|player| player.money > 0}
    end

    def play
        while true
            self.show_table
            self.players_round
            self.dealer_round
            self.finish_round
            if self.check_end_game
                puts 'END OF GAME - Dealer won'
                exit
            end
        end
    end
end