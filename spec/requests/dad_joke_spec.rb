require '../spec_helper'

RSpec.describe 'hello world' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'returns something' do
    get '/'
    expect(last_response).to be_ok
  end
end
