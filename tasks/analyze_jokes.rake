require './services/setup_service'

# usage: rake:analyze_jokes
desc 'Analyze jokes for our markov dictionary'
task :analyze_jokes do
  if File.exists?(SetupService::DICT_FILE)
    puts 'deleting my analysis!'
    File.delete(SetupService::DICT_FILE)
  end
  SetupService::JokeAnalyzer.analyze_jokes
end
