require 'pry'
require 'pragmatic_segmenter'

class MarkovDictionary
  def initialize(source_text:, file: 'dictionary.json')
    @source_text = source_text
    @file = file
  end

  def self.load_dictionary(file_name)
    JSON.parse(File.open(file_name, 'r', &:read))
  end

  def create_dictionary
    starters = find_starting_words
    frequencies = generate_word_frequencies
    dictionary = { starters: starters, frequencies: frequencies }.to_json
    File.open(@file, 'w') { |file| file.write(dictionary) }
  end

  private

  def sentences_from_source
    return @sentences if @sentences

    text = PragmaticSegmenter::Segmenter.new(text: @source_text)
    @sentences = text.segment.map { |sentence| clean_text(sentence) }
  end

  def clean_text(text)
    text.strip.downcase.gsub(/[^a-z.!?'\s]/i, '')
  end

  def find_starting_words
    sentences_from_source.reject(&:empty?).map { |sent| sent.split.first }.uniq
  end

  def generate_word_frequencies
    frequency_hash = Hash.new { |hash, key| hash[key] = [] }
    word_array = sentences_from_source.join(' ').split(/\b/).map(&:strip)
    word_array = word_array.reject(&:empty_or_tiny?)
    word_array.each_cons(2).each do |first_word, second_word|
      frequency_hash[first_word] << second_word
    end
    frequency_hash
  end
end

class String
  def empty_or_tiny?
    return true if strip.empty?
    return false if ['a', 'i', '.', '!', '?'].include? self
    return true if length < 2

    false
  end
end
