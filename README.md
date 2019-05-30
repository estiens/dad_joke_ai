# Ye olde README

## SETUP

DadJoke is a Sinatra app (a very light ruby web app framework). Setup is very simple!

1) Run `bundle install` (Note - You may have to install ruby version 2.5.3 with whatever your version manager of choice is. Or you can always change the ruby version, we're not doing anything too tricky, but stay above like 2.3?)

2) The first time the app runs, it will run some setup tasks to pull in all of the jokes from the API and build a frequency table/dictioanry for the markov chain. If for some reason you want to run these manually you can use.
    * `bundle exec rake load_jokes`
    * `bundle exec rake analyze_jokes`

3) Start it up with `bundle exec ruby server.rb`

## ENDPOINTS

There's only one endpoint here :D and thats `/joke`
(If you didn't change anything out of the box you should be able to hit it at `localhost:4567/joke` )

Hitting it without any params will return you one brand new joke!

Hitting it with a NUM (`/joke?num=3`) will return you that number of jokes (up to a limit of 10)

Hitting it with a TOPIC (`joke?topic=cheese`) will attempt to generate you a joke on that topic, but if it can't you'll just get a false response

Oh, its JSON and the response looks like
`{ "jokes": ["How many levels."] }`

What, you wanted a front-end? Sorry, not today :D

## TESTING

`bundle exec rspec spec` should do it!

## TECHNICAL NOTES

(or wait! where's the probability and graph traversal and stuff)

I decided to model the markov_chain as a hash in ruby, where every word is a hash key, and the hash value is every word (or punctutation) that follows that word. So, for example, if you were looking at the source text:

"The boy is big! The boy is strong! The boy sings. That's a good boy."

You would have the following value for `boy`
```ruby
{ 'boy': ['is', 'is', 'sings', '.'] }
```

So essentially, if we grab a random value from that array, we have a 50% chance of getting the word 'is', 25% chance of 'sings' and 25% of a period. Which is pretty much all we need to walk through our state machine. We start with a word, find a random value for the next word, then use that word as our next hash key, and find a random word from it's value for the next word, and so on!

## CACHEING

There is a cache with a default expiration time of 30 seconds. If you make the same request, you'll hit it. However, you can skip the cache by simply passing in a cache param like so.

`/jokes?cache=false`


