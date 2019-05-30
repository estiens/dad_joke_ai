require_relative '../spec_helper'

RSpec.describe 'hello world' do
  include Rack::Test::Methods

  it 'returns something' do
    get '/'
    expect(last_response).to be_ok
  end
end
