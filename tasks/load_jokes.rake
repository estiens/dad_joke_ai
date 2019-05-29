require 'pry'
require './services/dad_joke_fetcher'

# usage: rake:load_jokes
# will abort if file already exists, if you want to regenerate
# just delete the file at shared/jokes.json

desc 'Load jokes from the Dad Joke API'
task :load_jokes do
  abort('We already have a joke database!') if File.exist?('shared/jokes.json')
  joke_text = ApiWrappers::JokeGetter.new.jokes.map(&:text)
  abort('Sorry, I could not fetch jokes') unless joke_text.length > 1
  Dir.mkdir('shared') unless File.exist?('shared')
  File.open('shared/jokes.json', 'w') { |file| file.write(joke_text.to_json) }
  puts "Alright partner, I got you #{joke_text.length} jokes!"
  puts "I hope that's enough..."
end
