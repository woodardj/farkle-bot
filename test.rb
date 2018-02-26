require "./farkle.rb"


def good
  puts "Pass!"
end

def bad
  puts "Fail!"
end

game = System.new

six_dice = game.roll
six_dice.length == 6 ? good : bad

dice_count = 4
less_dice = game.roll dice_count
less_dice.length == dice_count ? good : bad

ace = [1,1,1,1,1,1] # Perfect roll
score = game.score(ace, [0, 1, 2, 3, 4, 5])
score == 2000 ? good : bad

# If I were unsmart and only drafted a few of the perfect-roll 1s
score = game.score(ace, [0])
score == 100 ? good : bad

score = game.score(ace, [1, 3, 5])
score == 1000 ? good : bad
