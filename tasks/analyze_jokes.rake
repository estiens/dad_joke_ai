require './lib/markov_dictionary'

# usage: rake:analyze_jokes
desc 'Analyze jokes for our markov dictionary'
task :analyze_jokes do
  joke_file = 'shared/jokes.json'
  dictionary_file = 'shared/frequency_hash.json'
  abort('You need to get the jokes first!') unless File.exist?(joke_file)
  puts "Now analyzing jokes! I'm good at this, cause I'm a computer!"
  source_text = JSON.parse(File.open(joke_file, 'r') { |file| file.read }).join(' ')
  MarkovDictionary.new(source_text: source_text, file: dictionary_file).create_dictionary
  puts "Whew! Got through them all, now I can invent new ones!"
end
