require "./farkle.rb"


def good
  puts "Pass!"
end

def bad
  puts "Fail!"
end

game = System.new

begin # Test `system`'s basic rolling and scoring
  six_dice = System.roll
  six_dice.length == 6 ? good : bad

  dice_count = 4
  less_dice = System.roll dice_count
  less_dice.length == dice_count ? good : bad

  ace = [1,1,1,1,1,1] # Perfect roll

  # Because I can't seem to remember we're zero-indexed...
  begin
    System.score(ace, [6]) # Draft an out-of-bounds die
    bad
  rescue
    good # Raised an exception
  end

  score = System.score(ace, [0, 1, 2, 3, 4, 5])
  score == 2000 ? good : bad

  # If I were unsmart and only drafted a few of the perfect-roll 1s
  score = System.score(ace, [0])
  score == 100 ? good : bad

  score = System.score(ace, [1, 3, 5])
  score == 1000 ? good : bad

  score = System.score(ace, [0, 3])
  score == 200 ? good : bad

  score = System.score(ace, [2, 3, 4, 5])
  score == 1100 ? good : bad

  # Some other arbitrary rolls
  score = System.score([1, 2, 2, 2, 4, 6], [0, 1, 2, 3])
  score == 300 ? good : bad

  score = System.score([5, 5, 1, 4, 4, 3], [0, 1, 2])
  score == 200 ? good : bad
end

turn = Turn.new

puts turn.rolls
