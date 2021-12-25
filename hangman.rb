require 'yaml'

module BasicSerializable
  # should point to a class; change to a different
  # class (e.g. MessagePack, JSON, YAML) to get a different
  # serialization
  @@serializer = YAML

  def serialize
    obj = {}
    instance_variables.map do |var|
      obj[var] = instance_variable_get(var)
    end

    @@serializer.dump obj
  end

  def unserialize(string)
    obj = @@serializer.load(string)
    obj.keys.each do |key|
      instance_variable_set(key, obj[key])
    end
  end
end

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end

  def bg_red
    colorize(41)
  end

  def bg_green
    colorize(42)
  end

  def bg_blue
    colorize(44)
  end

  def bg_white
    colorize(47)
  end

  def bg_cyan
    colorize(46)
  end

  def bg_magenta
    colorize(45)
  end

  def bg_yellow
    colorize(43)
  end
end

class Game
  include BasicSerializable

  attr_reader :random_word
  attr_accessor :display, :incorrect_guesses, :guesses

  def initialize
    @guesses = 10
    words_list = File.read('5desk.txt').split(' ')
    words_correct_size = words_list.filter_map { |word| word if word.size.between?(5, 12) }
    @random_word = words_correct_size.sample.downcase
    @display = Array.new(random_word.size, '_')
    @incorrect_guesses = []
  end

  def save_game(save_file)
    Dir.mkdir('saves') unless Dir.exist?('saves')
    filename = 'saves/save.txt'
    File.open(filename, 'w') do |file|
      file.puts save_file
    end
  end
end

game = Game.new
puts "Enter '1' to start a new game"
puts "Enter '2' to load a save file"
choice = gets.chomp
if choice == '1'
  while game.display.include?('_') && game.guesses > 0
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
    input = gets.chomp.downcase

    if input == 'save'
      puts 'Saving...'
      save = game.serialize
      game.save_game(save)
    else
      random_word_split = game.random_word.split('')

      random_word_split.each_with_index do |letter, index|
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
  puts ''
  puts game.display.join(' ')
  puts ''
  if game.guesses > 0
    puts "Congrats! You guessed '#{game.random_word}'"
  else
    puts "You lost. Correct answer was '#{game.random_word}'"
  end
elsif choice == '2'
  puts 'Loading..'
  game.unserialize(File.read('saves/save.txt'))

  while game.display.include?('_') && game.guesses > 0
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
    input = gets.chomp.downcase

    if input == 'save'
      puts 'Saving...'
      save = game.serialize
      game.save_game(save)
    else
      random_word_split = game.random_word.split('')

      random_word_split.each_with_index do |letter, index|
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
  puts ''
  puts game.display.join(' ')
  puts ''
  if game.guesses > 0
    puts "Congrats! You guessed '#{game.random_word}'"
  else
    puts "You lost. Correct answer was '#{game.random_word}'"
  end
end
