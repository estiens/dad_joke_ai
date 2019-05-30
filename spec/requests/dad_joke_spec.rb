require_relative '../spec_helper'

RSpec.describe 'hello world' do
  include Rack::Test::Methods

  it 'returns a joke from the joke endpoint' do
    get '/joke'
    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)

    expect(body['jokes']).to_not be_nil
  end

  it 'returns mulitple jokes from the joke endpoint' do
    get '/joke?num=3'
    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)

    expect(body['jokes'].length).to eq 3
  end

  it 'returns a joke from the joke endpoint for a topic' do
    get '/joke?topic=boy'
    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)

    expect(body['jokes']).to_not be_nil
  end

  it 'returns false if it cannot find the topic' do
    get '/joke?topic=foobarfoo'
    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)

    expect(body['jokes'].first).to eq false
  end
end
