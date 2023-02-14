require 'colorize'

class Player
  def initialize(name, color, symbol)
    @name = name
    @color = color
    @symbol = symbol
  end

  attr_reader :name, :color, :symbol
end

class GameProcess
  def initialize
  end

  def start_game
    @player1 = self.first_player
    @player2 = self.second_player
    @over = false
    @current_board = Board.new
    @current_board.show_board
    @current_player =
      if rand(1..2) == 1
        @player1
      else
        @player2
      end
    puts "#{@current_player.name.colorize(@current_player.color)} goes first. Pick a square."
  end

  def first_player
    puts "Enter the first player's name. "
    puts 'They will be playing Xs.'.colorize(:red)
    player1name = gets.chomp
    Player.new(player1name, :red, 'X')
  end

  def second_player
    puts "Enter the second player's name. "
    puts 'They will be playing Os.'.colorize(:green)
    player1name = gets.chomp
    Player.new(player1name, :green, 'O')
  end

  def turn
    @square = gets.chomp.downcase
    if @current_board.board_checker.include? @square.reverse
      @square = @square.reverse
    end
    if @current_board.board_checker.include?(@square)
      check_square
      @current_board.board[@square.intern] = @current_player.symbol.colorize(@current_player.color)
      @current_board.show_board
      check_board_state
    else
      puts 'Incorrect input. Please try again.'
      turn
    end
    @over ? return : switch_players

    puts "It's #{@current_player.name.colorize(@current_player.color)}'s turn now. Pick a square."
    turn
  end

  def switch_players
    @current_player =
      if @current_player == @player1
        @player2
      elsif @current_player == @player2
        @player1
      end
  end

  def check_board_state
    if @current_board.board.slice(:a1, :a2, :a3).all? { |_key, value| value == @current_player.symbol.colorize(@current_player.color) } ||
       @current_board.board.slice(:b1, :b2, :b3).all? { |_key, value| value == @current_player.symbol.colorize(@current_player.color) } ||
       @current_board.board.slice(:c1, :c2, :c3).all? { |_key, value| value == @current_player.symbol.colorize(@current_player.color) } ||
       @current_board.board.slice(:a1, :b1, :c1).all? { |_key, value| value == @current_player.symbol.colorize(@current_player.color) } ||
       @current_board.board.slice(:a2, :b2, :c2).all? { |_key, value| value == @current_player.symbol.colorize(@current_player.color) } ||
       @current_board.board.slice(:a3, :b3, :c3).all? { |_key, value| value == @current_player.symbol.colorize(@current_player.color) } ||
       @current_board.board.slice(:a1, :b2, :c3).all? { |_key, value| value == @current_player.symbol.colorize(@current_player.color) } ||
       @current_board.board.slice(:a3, :b2, :c1).all? { |_key, value| value == @current_player.symbol.colorize(@current_player.color) }
      end_game
    end
  end

  def check_square
    if @current_board.board[@square.intern] == '_'
      true
    else
      puts 'Square is occupied. Try another one.'
      turn
    end
  end

  def end_game
    puts "#{@current_player.name.colorize(@current_player.color)} is victorious!"
    @over = true
  end
end

class Board
  attr_reader :board, :board_checker

  def initialize
    @board = {
      a1: '_', a2: '_', a3: '_',
      b1: '_', b2: '_', b3: '_',
      c1: '_', c2: '_', c3: '_'
    }
    @board_checker = %w[a1 a2 a3 b1 b2 b3 c1 c2 c3]
  end

  def show_board
    puts "
        1   2   3
    A | #{@board[:a1]} | #{@board[:a2]} | #{@board[:a3]} |
    B | #{@board[:b1]} | #{@board[:b2]} | #{@board[:b3]} |
    C | #{@board[:c1]} | #{@board[:c2]} | #{@board[:c3]} |
    "
  end
end

game = GameProcess.new
game.start_game
game.turn
