require './lib/setup'

# usage: rake:analyze_jokes
desc 'Analyze jokes for our markov dictionary'
task :analyze_jokes do
  Setup::JokeAnalyzer.analyze_jokes
end
