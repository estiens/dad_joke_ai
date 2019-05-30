require 'gingerice'

class MagicMarkov
  def initialize(dictionary)
    @dictionary = dictionary
    @frequencies = dictionary['frequencies']
    @starting_words = dictionary['starters']
  end

  def generate_joke(word = nil)
    if check_for_word(word)
      joke = generate_sentence(word)
      rand(0..2).times { joke += " #{generate_sentence}" }
      joke
    else
      false
    end
  end

  private

  def generate_sentence(word = nil)
    sentence = ''
    word ||= @starting_words.sample
    until ['?', '.', '!'].include? word
      sentence += "#{word} "
      word = get_next_word(word)
    end
    sentence = clean_sentence(sentence)
    "#{sentence}#{word}"
  end

  def clean_sentence(sentence)
    sentence = sentence.strip
    sentence[0] = sentence[0].capitalize
    begin
      parsed = Gingerice::Parser.new.parse(sentence)
      parsed['result']
    rescue Gingerice::ConnectionError
      sentence
    end
  end

  def check_for_word(word)
    return true unless word

    @frequencies.keys.include?(word)
  end

  def get_next_word(word)
    @frequencies[word]&.sample || @frequencies.keys.sample
  end
end
