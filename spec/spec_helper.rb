require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../server.rb', __dir__
require File.expand_path '../lib/magic_markov.rb', __dir__
require File.expand_path '../lib/markov_dictionary.rb', __dir__

module RSpecMixin
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
end

RSpec.configure do |c|
  c.include RSpecMixin

  c.after(:all) do
    dict_file = File.expand_path '../tmp/request_test.json', __dir__
    File.delete(dict_file) if File.exist?(dict_file)
  end
end
