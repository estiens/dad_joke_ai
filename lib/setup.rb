require_relative 'markov_dictionary'
require_relative '../services/dad_joke_fetcher'

module Setup
  class JokeFetcher
    JOKES_FILE = 'shared/jokes.json'.freeze

    def self.fetch_jokes
      if File.exist?(JOKES_FILE)
        puts 'I already got jokes, no worries!'
      else
        fetch_them_all
      end
    end

    def self.fetch_them_all
      joke_text = ApiWrappers::JokeGetter.new.jokes.map(&:text)
      raise 'Sorry, I could not fetch jokes. Something went wrong!' unless joke_text.length > 1

      Dir.mkdir('shared') unless File.exist?('shared')
      File.open(JOKES_FILE, 'w') { |file| file.write(joke_text.to_json) }
      puts "Alright partner, I got you #{joke_text.length} jokes!"
      puts "I hope that's enough..."
    end
  end

  class JokeAnalyzer
    DICT_FILE = 'shared/frequency_hash.json'.freeze

    def self.analyze_jokes
      if File.exist?(DICT_FILE)
        puts 'Already analyzed the jokes, no worries!'
      else
        analyze_them_all
      end
    end

    def self.analyze_them_all
      joke_file = Setup::JokeFetcher::JOKES_FILE
      abort('You need to get the jokes first!') unless File.exist?(joke_file)
      puts "Now analyzing jokes! I'm good at this, cause I'm a computer!"
      source_text = JSON.parse(File.open(joke_file, 'r', &:read)).join(' ')
      MarkovDictionary.new(source_text: source_text, file: DICT_FILE).create_dictionary
      puts 'Whew! Got through them all, now I can invent new ones!'
    end
  end
end
