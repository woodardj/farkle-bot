require "./bot.rb"

class AlphaBot < FarkleBot
  # First attempt at a "real" bot
  # Written at Upslope Lee Hill.

  def act(turn)
    roll = turn.last_roll
    keepers = []
    continue = nil

    left_dice = [0,1,2,3,4,5][0..roll.length]

    # roll = [1, 5, 3, 6, 3, 1]

    # Triples is how I roll.
    triple_values = roll.group_by(&:itself).select { |k, v| v.size >= 3 }.keys
    keepers += roll.each_index.select{|i| triple_values.include?(roll[i])} # Keep all triples. Always.

    if (keepers.length > 3 && keepers.length != 6)
      keepers = keepers[0..2]
    end

    left_dice = left_dice - keepers

    remaining_ones = []
    left_dice.each do |d|
      if roll[d] == 1
        remaining_ones << d
      end
    end

    # puts "#{keepers}"

    if remaining_ones.length == 2
      keepers += remaining_ones
      continue = true
    elsif keepers.length == 0 && remaining_ones.length == 1
      keepers += remaining_ones
      continue = true
    end
    # continue = true if keepers.length > 0

    # Fives is small money.
    if (keepers.length == 0)
      keepers += [roll.index(5)] if roll.index(5)
      continue = true
    end

    left_dice = left_dice - keepers
    # puts "#{left_dice}"
    if left_dice.length == 0
      continue = true # Duh, continuing because we're in the Hot Dice space.
    elsif left_dice.length <= 2
      # Odds of Farkle are high!
      continue = false
    end

    continue = true if continue.nil? # YOLO
    # puts "#{left_dice}"
    raise("Uh oh, we missed an edgecase: #{roll}. #{keepers}, #{continue}") if (keepers.length == 0 || continue.nil?)

    {:keep => keepers, :pass => !continue, :puts => true}
  end
end

bot = AlphaBot.new
bot.run!
