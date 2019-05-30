require_relative '../spec_helper'

# high level end to end spec that makes sure our dictionary service can create a dictionary,
# load a dictionary, and the dictionary has the correct hashes

describe 'markov frequency dictionary' do
  let(:dictionary_file) { 'test.json' }
  let(:source_text) { 'The cat is a bird. Is the boy not a dog? A boy went home. A dog went home.' }

  before(:each) do
    MarkovDictionary.new(source_text: source_text, file: dictionary_file).create_dictionary
    @dictionary = MarkovDictionary.load_dictionary(dictionary_file)
  end

  after(:each) do
    File.delete(dictionary_file) if File.exist?(dictionary_file)
  end

  it 'does all the dictionary stuff woooooo' do
    service = MarkovDictionary.new(source_text: source_text, file: dictionary_file)
    service.create_dictionary

    dictionary = MarkovDictionary.load_dictionary(dictionary_file)

    starting_words = dictionary['starters']
    expect(starting_words.count).to eq 3
    expect(starting_words).to include('the')
    expect(starting_words).to include('a')
    expect(starting_words).to include('is')

    frequencies = dictionary['frequencies']
    expect(frequencies.keys.count).to eq 12

    expect(frequencies['the']).to include 'cat'
    expect(frequencies['the']).to include 'boy'
  end
end
