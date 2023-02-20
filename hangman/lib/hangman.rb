require 'json'
require 'colorize'

class Game
  attr_accessor :guess_count, :open_letters, :absent_letters, :word, :split_word

  def initialize(dictionary)
    @word = word_choice(dictionary)
    @split_word = @word.split('')
    @guess_count = 8
    @open_letters = Array.new(@word.length, '_')
    @absent_letters = []
  end

  def word_choice(dictionary)
    dict = File.open(dictionary)
    dict_l = dict.readlines.length
    dict.rewind
    word = dict.readlines[rand(0...dict_l)].chomp
    return word unless word.length < 5 || word.length > 12

    word_choice(dictionary)
  end

  def info
    puts ''
    print "Guessed letters: #{@open_letters.join(' ').colorize(:green)}"
    puts ''
    puts "Absent letters: #{@absent_letters.join(' ').colorize(:red)}"
    puts "Guesses remaining: #{@guess_count}"
    puts ''
    puts 'Guess a letter!'
    return game_end('lose') if guess_count.zero?
    return game_end('win') if @open_letters == @split_word

    turn
  end

  def turn
    input = gets.chomp.downcase
    if valid_input?(input)
      check_input(input)
    else
      puts 'Incorrect input. Try again.'.colorize(:red)
      turn
    end
  end

  def valid_input?(input)
    case 
    when input == @word
      game_end('win')
    when input == '-save'
      true
    when input.length != 1 || !input.match(/^[a-zA-Z]+/)
      return false
    when @open_letters.include?(input) || @absent_letters.include?(input)
      return false
    else
      true
    end
  end

  def check_input(input)
    if input == '-save'
      puts 'Game saved. Thanks for playing!'.colorize(:blue)
      save_game
    elsif @split_word.include?(input)
      puts 'Correct!'.colorize(:green)
      reveal_letters(input)
      info
    else
      puts 'Incorrect!'.colorize(:red)
      @guess_count -= 1
      @absent_letters << input
      info
    end
  end

  def reveal_letters(input)
    @split_word.each_with_index do |letter, index|
      @open_letters[index] = input if letter == input
    end
  end

  def save_game
    save = JSON.dump(
      'guess_count' => @guess_count,
      'open_letters' => @open_letters,
      'absent_letters' => @absent_letters,
      'word' => @word,
      'split_word' => @split_word
    )
    File.write('save.json', save)
  end

  def load_game
    file = JSON.parse(File.read('save.json'))
    @guess_count = file['guess_count']
    @open_letters = file['open_letters']
    @absent_letters = file['absent_letters']
    @word = file['word']
    @split_word = file['split_word']
  end

  def game_end(result)
    puts ''
    case result
    when 'win'
      puts 'Congratulations! You won!'.colorize(:green)
    when 'lose'
      puts 'Too bad. You lost!'.colorize(:red)
    end
    puts "The word was: #{@word.colorize(:color => :blue, :mode => :bold)}"
  end
end

def launch_game(game)
  choice = gets.chomp
  if choice == '-new'
    true
  elsif choice == '-load'
    if File.exist?('save.json')
      game.load_game
    else
      puts 'No saved game found, please try again.'.colorize(:red)
      launch_game(game)
    end
  else
    puts 'Incorrect input, please try again.'.colorize(:red)
    launch_game(game)
  end
  puts 'To save the game in progress, type - save.'.colorize(:blue)
end

puts 'Hangman initialized!'
puts 'To start a new game, type -new'
puts 'To load your game state, type -load'
dictionary = 'google-10000-english-no-swears.txt'
game = Game.new(dictionary)
launch_game(game)
game.info
