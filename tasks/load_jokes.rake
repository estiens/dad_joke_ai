require './lib/setup'

# usage: rake:load_jokes
desc 'Load jokes from the Dad Joke API'
task :load_jokes do
  Setup::JokeFetcher.fetch_jokes
end
