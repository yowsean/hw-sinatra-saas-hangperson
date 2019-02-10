class HangpersonGame
  attr_accessor :word, :guesses, :wrong_guesses

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    if letter.nil?
      raise ArgumentError, 'Guess is nil'
    end
    if letter.empty?
      raise ArgumentError, 'Guess is empty'
    end
    if !/[a-zA-Z]/.match(letter)
      raise ArgumentError, 'Guess is not a letter'
    end
    letter.downcase!
    if !@guesses.include?(letter) and !@wrong_guesses.include?(letter)
      if @word.downcase.include?(letter)
        @guesses << letter
      else
        @wrong_guesses << letter
      end
      return true
    else
      return false
    end
  end

  def word_with_guesses
    output = @word
    @word.chars do |letter|
      if !@guesses.include?(letter)
        output = output.tr(letter, '-')
      end
    end
    return output
  end

  def check_win_or_lose
    if @guesses.length + @wrong_guesses.length > 6
      return :lose
    end
    @word.chars do |letter|
      if !@guesses.include?(letter)
        return :play
      end
    end
    return :win
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
