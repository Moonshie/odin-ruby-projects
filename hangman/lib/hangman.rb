class Game
  attr_reader :word, :split_word
  attr_accessor :guess_count, :open_letters, :absent_letters

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
    return game_end('lose') if guess_count.zero?
    return game_end('win') if @open_letters == @split_word

    puts ''
    print "Guessed letters: #{@open_letters.join(' ')}"
    puts ''
    puts "Absent letters: #{@absent_letters.join(' ')}"
    puts "Guesses remaining: #{@guess_count}"
    puts ''
    puts 'Guess a letter!'
    turn
  end

  def turn
    input = gets.chomp.downcase
    if valid_input?(input)
      check_input(input)
    else
      puts 'Incorrect input. Try again.'
      turn
    end
  end

  def valid_input?(input)
    if input == @word
      game_end('win')
    elsif input.length != 1 || !input.match(/^[a-zA-Z]+/)
      false
    elsif @open_letters.include?(input) || @absent_letters.include?(input)
      false
    else
      true
    end
  end

  def check_input(input)
    if @split_word.include?(input)
      puts 'Correct!'
      reveal_letters(input)
    else
      puts 'Incorrect!'
      @guess_count -= 1
      @absent_letters << input
    end
    info
  end

  def reveal_letters(input)
    @split_word.each_with_index do |letter, index|
      if letter == input
        @open_letters[index] = input
      end
    end
  end

  def game_end(result)
    puts ''
    case result
    when 'win'
      puts 'Congratulations! You won!'
    when 'lose'
      puts 'Too bad. You lost!'
    end
    puts "The word was: #{@word}"
  end
end

puts 'Hangman initialized!'
dictionary = 'google-10000-english-no-swears.txt'
game = Game.new(dictionary)
game.info
