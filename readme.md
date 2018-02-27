# FarkleBot
Farkle is a simple press-your-luck dice game played with six standard six-sided dice. It's been released by a few people with a couple of spellings and couple of slight variations on the rules. This is an attempt at building a harness for writing "Bots" which attempt to hit the winning score in as few turns as possible (since there is zero player interaction, this is fair proxy for winningness). This project was inspired during a particularly intense Farkle match at Upslope Brewing in Boulder, CO.

## Rules
Each turn, a player rolls the six dice, and must choose which of the 'scored' dice they wish to draft and bank the points for, before choosing whether or not to roll the remaining dice. Each drafted set of dice scores independently, (i.e. drafting a pair of 1s in one turn, followed by another 1 in a later roll does not count as a triple.)

If any given roll contains NO scoring dice, this is considered a Farkle and **all** points for the turn are voided, and the turn is over.

If a player manages to score all six dice on a turn, this is considered "Hot Dice" and they may re-roll all six, continuing their turn.

|Dice|Score|
|:---:|:---:|
|5|50|
|1|100|
|2,2,2|200|
|3,3,3|200|
|4,4,4|200|
|5,5,5|200|
|6,6,6|200|
|1,1,1|1000|

First player to 10,000 points is the winner.

## Bots
Bot scripts are in the `/bots` directory, and can be invoked from that directory at the command line if you've got the right version of ruby:

```
$ ruby bravo.rb
```

## Data
Next steps on this are to build a 'runner' that will iteratively re-run each bot a certain number of times, in order to determine the average and variance to compare each strategy visually.

## Writing your own Bot
Create a new file in the `/bots` directory and subclass `FarkleBot` from the 'bot.rb' file, and implement the `act` method. It should take a `Turn` object (from the `farkle.rb` file) as a parameter, and return a hash with an array of indices to draft from the "roll" array and whether or not to continue rolling or end the turn.

I'd be happy to accept PRs for Bots that used interesting strategies or won particularly fast!

## "Test suite"
I wanted to make a point here that code can be written modularly and testable, even without fancy test harnesses etc. as a project gets started.

The test suite can be invoked:

```
$ ruby test.rb
```
