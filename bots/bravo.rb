require "./bot.rb"

class BravoBot < FarkleBot
  # Bravo takes the best draft each roll.
  # Bravo will push to two dice if it has less than 500 points, but will quit at three if it has more.
  def act(turn)
    roll = turn.last_roll
    keepers = []
    continue = nil

    possible_keeps = ::System.all_possible_keep_arrays( roll.length )
    best_keep = []
    best_score = 0

    possible_keeps.each do |option|
      begin
        this_score = ::System.score(roll,option)
      rescue
        # This draft was not valid. Ok, try the next one.
        this_score = 0
      end
      if this_score > best_score
        best_keep = option
        best_score = this_score
      end
    end

    dice_left = 6 - best_keep.length

    case dice_left # Fairly dumb switch statement but it was helpful to write out this way.
    when 1
      continue = false
    when 2 # Risk two dice if we don't already have 500 points
      continue = false
      continue = true if ( turn.score + best_score < 500 )
    when 3 # DON'T roll three dice if we're already past 500
      continue = false
      continue = true unless ( turn.score + best_score > 500 )
    else
      continue = true
    end

    keepers = best_keep
    # puts "#{left_dice}"
    raise("Uh oh, we missed an edgecase: #{roll}. #{keepers}, #{continue}") if (keepers.length == 0 || continue.nil?)

    {:keep => keepers, :pass => !continue, :puts => true}
  end
end

bot = BravoBot.new
bot.run!
