# Ye olde README

## SETUP

DadJoke is a Sinatra app (a very light ruby web app framework). Setup is very simple!

1) Run `bundle install` (Note - You may have to install ruby version 2.5.3 with whatever your version manager of choice is. Or you can always change the ruby version, we're not doing anything too tricky, but stay above like 2.3?)

2) Run the following setup commands to pulll in all of our jokes that will use for the source text and to setup our markov dictionary
    * `bundle exec rake load_jokes`
    * `bundle exec rake analyze_jokes`

    (If you try to run the app without doing this step, it will throw an error at you)

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

## TECHNICAL NOTES

## CACHEING


