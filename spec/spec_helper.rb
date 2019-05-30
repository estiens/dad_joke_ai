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

RSpec.configure { |c| c.include RSpecMixin }
