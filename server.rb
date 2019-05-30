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

  def self.model
    @model
  end
end

configure do
  unless settings.environment == :test
    Setup::JokeFetcher.fetch_jokes
    Setup::JokeAnalyzer.analyze_jokes
  end
  MarkovModel.init
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
