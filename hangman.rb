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

words_list = File.read('5desk.txt').split(' ')
words_correct_size = words_list.filter_map {|word| word if word.size.between?(5, 12)}
random_word = words_correct_size.sample.downcase

display = Array.new(random_word.size, '_')
p random_word
puts "Enter #{"\"save\"".green} to save the game, enter #{"\"load\"".yellow} to load your save file"
puts ''
puts display.join(' ')
puts ''
print 'Enter a letter to make a guess> '
input = gets.chomp.downcase

random_word_split = random_word.split('')

random_word_split.each_with_index do |letter, index|
  display.each_with_index do |placeholder, display_index|
    if letter == input
      display[index] = input
    end
  end
end

puts display.join(' ')

