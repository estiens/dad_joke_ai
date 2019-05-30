require 'sinatra'
require 'pry'

require_relative 'lib/magic_markov'
require_relative 'lib/markov_dictionary'
require_relative 'lib/setup'

class MarkovModel
  def self.init
    filename = './shared/frequency_hash.json'
    return unless File.exist?(filename)

    dictionary = MarkovDictionary.load_dictionary(filename)
    @model = MagicMarkov.new(dictionary)
  end

  def self.test_init
    dictionary_file = 'shared/test.json'
    source_text = 'The cat is a bird. Is the boy not a dog? A boy went home. A dog went home.'
    MarkovDictionary.new(source_text: source_text, file: dictionary_file).create_dictionary
    dictionary = MarkovDictionary.load_dictionary(dictionary_file)
    @model = MagicMarkov.new(dictionary)
  end

  def self.model
    @model
  end
end

configure do
  if settings.environment == :test
    MarkovModel.test_init
  else
    Setup::JokeFetcher.fetch_jokes
    Setup::JokeAnalyzer.analyze_jokes
    MarkovModel.init
  end
end

get '/' do
  'Hello World'
end

get '/joke' do
  jokes = []
  num = params['num'] || 1
  topic = params['topic']
  num.to_i.times do
    jokes << MarkovModel.model.generate_joke(topic)
  end
  return { jokes: jokes }.to_json
end
