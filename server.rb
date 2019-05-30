require 'sinatra'
require 'pry'

require_relative 'lib/magic_markov'
require_relative 'lib/markov_dictionary'
require_relative 'services/setup_service'

class SuperBasicCache
  EXPIRES = 30

  def self.init
    @cache = {}
  end

  def self.fetch(key)
    return nil unless @cache.key?(key)
    return nil unless @cache[key][:expiration_time].to_i > Time.now.to_i

    message = "fetched value from cache for #{key} "
    message += "will expire in #{@cache[key][:expiration_time] - Time.now.to_i}"
    puts message
    @cache[key][:value]
  end

  def self.write(key, value)
    puts "writing #{value} to #{key} in cache"
    @cache[key] = { value: value, expiration_time: Time.now.to_i + EXPIRES }
  end
end

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

  class << self
    attr_reader :model
  end
end

configure do
  if settings.environment == :test
    MarkovModel.test_init
  else
    SetupService::JokeFetcher.fetch_jokes
    SetupService::JokeAnalyzer.analyze_jokes
    MarkovModel.init
    SuperBasicCache.init
  end
end

get '/' do
  'Hello World'
end

def fetch_from_cache(cache_key)
  return nil if settings.environment == :test
  return nil if params[:cache] == 'false'

  SuperBasicCache.fetch(cache_key)
end

def write_to_cache(cache_key, jokes)
  return if settings.environment == :test

  SuperBasicCache.write(cache_key, jokes)
end

def cache_key(num = nil, topic = nil)
  "joke#{num}#{topic}"
end

def get_new_jokes(num, topic)
  jokes = []
  num.to_i.times do
    jokes << MarkovModel.model.generate_joke(topic)
  end
  cache_key = cache_key(num, topic)
  write_to_cache(cache_key, jokes)
  jokes
end

get '/joke' do
  num = [1, params[:num].to_i, 10].sort[1]
  topic = params[:topic]
  cache_key = cache_key(num, topic)
  jokes = fetch_from_cache(cache_key) || get_new_jokes(num, topic)
  return { jokes: jokes }.to_json
end
