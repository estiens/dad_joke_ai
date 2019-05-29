require 'httparty'
require 'pry'

module ApiWrappers
  class JokeGetter
    attr_reader :jokes

    BASE_URL = 'https://icanhazdadjoke.com/search'.freeze
    HEADERS = { 'Accept' => 'application/json' }.freeze

    Joke = Struct.new(:id, :text)

    def initialize
      @jokes = fetch_all_jokes
    end

    def fetch_all_jokes
      fetch_paginated_data(BASE_URL).map { |data| convert_to_joke(data) }
    end

    private

    def fetch_data(path)
      HTTParty.get(path, headers: HEADERS)
    end

    def convert_to_joke(joke_result)
      return nil unless joke_result['joke']

      Joke.new(joke_result['id'], joke_result['joke'])
    end

    def fetch_paginated_data(path)
      results = []
      page = 1

      loop do
        response = fetch_data("#{path}?page=#{page}")
        break unless response.success?

        jokes = JSON.parse(response.body)['results']
        break if jokes.empty?

        results << jokes
        page += 1
      end
      results.flatten
    end
  end
end
