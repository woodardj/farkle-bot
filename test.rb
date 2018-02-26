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

  score = System.score([1, 2], [0])
  score == 100 ? good : bad

  System.farkle?( [2] ) == true ? good : bad
  System.farkle?( [2, 2] ) == true ? good : bad
  System.farkle?( [2, 2, 2] ) == false ? good : bad
  System.farkle?( [1, 2] ) == false ? good : bad
  System.farkle?( [1, 2, 3] ) == false ? good : bad
  System.farkle?( [2, 3, 4, 5, 6]) == false ? good : bad
  System.farkle?( [1, 2, 2, 3, 3, 4]) == false ? good : bad
  System.farkle?( [2, 2, 3, 3, 4, 4]) == true ? good : bad
end

srand 1
turn = Turn.new
turn.puts_last_roll

turn.play(:keep => [3], :puts => true)

# Should have 100 points after first `srand 1` keep
# turn.score == 100 ? good : bad

turn.play(:keep => [1, 2], :puts => true)

# Should have 300 points after second `srand 1` keep
# turn.score == 300 ? good : bad

turn.play(:keep => [1], :puts => true)

# Should have 350 points after third `srand 1` keep
# turn.score == 350 ? good : bad

turn.play(:keep => [1], :puts => true)

# Fourth `srand 1` keep results in a farkle.
# turn.score == 0 ? good : bad
puts; puts;

srand 2
turn = Turn.new
turn.puts_last_roll

turn.play(:keep => [0], :puts => true)
turn.play(:keep => [0], :puts => true)
turn.play(:keep => [1, 2, 3], :pass => true, :puts => true)
