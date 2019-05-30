require './services/setup_service'

# usage: rake:load_jokes
desc 'Load jokes from the Dad Joke API'
task :load_jokes do
  if File.exists?(SetupService::JOKE_FILE)
    puts 'deleting the jokes I have, but I will get more'
    File.delete(SetupService::JOKE_FILE)
  end
  SetupService::JokeFetcher.fetch_jokes
end
