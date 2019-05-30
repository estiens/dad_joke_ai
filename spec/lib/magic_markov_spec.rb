require_relative '../spec_helper'

describe 'markov chain' do
  before(:all) do
    @dictionary_file = 'test.json'
    @source_text = 'The cat is a bird. Is the boy not a dog? A boy went home. A dog went home.'
    MarkovDictionary.new(source_text: @source_text, file: @dictionary_file).create_dictionary
    @dictionary = MarkovDictionary.load_dictionary(@dictionary_file)
  end

  after(:all) do
    File.delete(@dictionary_file) if File.exist?(@dictionary_file)
  end

  it 'should be able to generate a joke' do
    markov_model = MagicMarkov.new(@dictionary)
    joke = markov_model.generate_joke
    expect(joke).to_not be_nil
  end

  it 'should be able to generate a joke with a given word in it' do
    markov_model = MagicMarkov.new(@dictionary)
    joke = markov_model.generate_joke('dog')
    expect(joke.downcase).to include 'dog'
  end

  it 'should not fail if the word does not exist' do
    markov_model = MagicMarkov.new(@dictionary)
    joke = markov_model.generate_joke('foobar')
    expect(joke).to_not be_nil
  end

  describe 'private methods' do
    # wouldn't normally test private methods, but for such a random output, I want to test some of the
    # intermediate functions

    it 'should be able to grab a word based on an input word' do
      markov_model = MagicMarkov.new(@dictionary)
      expect(markov_model.send(:get_next_word, 'cat')).to eq 'is'

      expect(%w[a not the]).to include markov_model.send(:get_next_word, 'is')
    end

    it 'should always finish with a punctuation mark' do
      markov_model = MagicMarkov.new(@dictionary)
      last_char = markov_model.send(:generate_sentence)[-1]
      expect(['.', '!', '?']).to include last_char
    end
  end
end
