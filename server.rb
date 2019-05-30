require 'sinatra'
require 'pry'

require_relative 'lib/magic_markov'
require_relative 'lib/markov_dictionary'

class MarkovModel
  def self.init
    dictionary = MarkovDictionary.load_dictionary('./shared/frequency_hash.json')
    @@model = MagicMarkov.new(dictionary)
  end

  def self.model
    @@model
  end
end

configure do
  MarkovModel::init()
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
