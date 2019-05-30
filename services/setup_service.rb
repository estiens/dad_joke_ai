require_relative '../lib/markov_dictionary'
require_relative 'dad_joke_fetcher'

module SetupService
  JOKE_FILE = 'shared/jokes.json'.freeze
  DICT_FILE = 'shared/frequency_hash.json'.freeze

  class JokeFetcher
    def self.fetch_jokes
      if File.exist?(JOKE_FILE)
        puts 'I already got jokes, no worries!'
      else
        puts 'Well, first we gotta get some jokes...'
        fetch_them_all
      end
    end

    def self.fetch_them_all
      joke_text = ApiWrappers::JokeGetter.new.jokes.map(&:text)
      raise 'Sorry, I could not fetch jokes. Something went wrong!' unless joke_text.length > 1

      Dir.mkdir('shared') unless File.exist?('shared')
      File.open(JOKE_FILE, 'w') { |file| file.write(joke_text.to_json) }
      puts "Alright partner, I got you #{joke_text.length} jokes!"
      puts "I hope that's enough!"
    end
  end

  class JokeAnalyzer
    def self.analyze_jokes
      if File.exist?(DICT_FILE)
        puts 'Already analyzed the jokes, no worries!'
      else
        analyze_them_all
      end
    end

    def self.analyze_them_all
      raise 'You need to get the jokes first!' unless File.exist?(JOKE_FILE)
      puts "Now analyzing jokes! I'm good at this, cause I'm a computer!"
      source_text = JSON.parse(File.open(JOKE_FILE, 'r', &:read)).join(' ')
      MarkovDictionary.new(source_text: source_text, file: DICT_FILE).create_dictionary
      puts 'Whew! Got through them all, now I can invent new ones!'
    end
  end
end
