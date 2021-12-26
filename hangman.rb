require 'yaml'
require_relative 'lib/color'
require_relative 'lib/serialize'

class Game
  include BasicSerializable

  attr_reader :random_word
  attr_accessor :display, :incorrect_guesses, :guesses

  def initialize
    @guesses = 10
    @random_word = generate_word
    @display = Array.new(@random_word.size, '_')
    @incorrect_guesses = []
  end

  def get_input(game)
    puts '*************************************************************************'
    puts "Enter #{'"save"'.green} to save the game"
    puts ''
    puts game.display.join(' ')
    puts ''
    puts "Incorrect letters: #{game.incorrect_guesses.join(' ')}"
    puts ''
    puts "Remaining guesses: #{game.guesses}"
    puts ''
    print 'Enter a letter to make a guess> '
    gets.chomp.downcase
  end

  def over?(game)
    game.display.include?('_') && game.guesses > 0
  end

  def decide_winner(game)
    puts ''
    puts game.display.join(' ')
    puts ''
    if game.guesses > 0
      puts "Congrats! You guessed '#{game.random_word.yellow}'"
    else
      puts "You lost. Correct answer was '#{game.random_word.yellow}'"
    end
  end

  def execute(game, input)
    if input == 'save'
      puts 'Saving...'
      save_game(game.serialize)
    else
      populate(game, input)
    end
  end

  private

  def save_game(save_file)
    Dir.mkdir('saves') unless Dir.exist?('saves')
    filename = 'saves/save.txt'
    File.open(filename, 'w') do |file|
      file.puts save_file
    end
  end

  def generate_word
    words_list = File.read('5desk.txt').split(' ')
    words_correct_size = words_list.filter_map { |word| word if word.size.between?(5, 12) }
    words_correct_size.sample.downcase
  end

  def populate(game, input)
    game.random_word.split('').each_with_index do |letter, index|
      game.display.each_with_index do |_placeholder, _display_index|
        if letter.downcase == input
          game.display[index] = input
        elsif !game.random_word.include?(input)
          break if game.incorrect_guesses.include?(input)

          game.guesses -= 1
          game.incorrect_guesses.push(input)
        end
      end
    end
  end
end

game = Game.new
puts "Enter '1' to start a new game"
puts "Enter '2' to load a save file"
choice = gets.chomp
if choice == '1'
  while game.over?(game)
    input = game.get_input(game)

    game.execute(game, input)
  end
  game.decide_winner(game)
elsif choice == '2'
  puts 'Loading..'
  game.unserialize(File.read('saves/save.txt'))

  while game.over?(game)
    input = game.get_input(game)

    game.execute(game, input)
  end
  game.decide_winner(game)
end
