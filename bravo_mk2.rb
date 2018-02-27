require "./bot.rb"

class BravoMk2Bot < FarkleBot
  # Bravo takes the best draft each roll.
  # Bravo Mk 2 will push to two dice if it has less than a threshold of points, but will quit at three if it has more.
  def initialize(threshold = nil)
    raise("BravoBot Mk 2 needs a threshold value") if threshold.nil?
    @threshold = threshold
    super()
  end

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
    when 2 # Risk two dice if we don't already have 'threshold' points
      continue = false
      continue = true if ( turn.score + best_score < threshold )
    when 3 # DON'T roll three dice if we're already past 'threshold'
      continue = false
      continue = true unless ( turn.score + best_score > threshold )
    else
      continue = true
    end

    keepers = best_keep
    # puts "#{left_dice}"
    raise("Uh oh, we missed an edgecase: #{roll}. #{keepers}, #{continue}") if (keepers.length == 0 || continue.nil?)

    {:keep => keepers, :pass => !continue, :puts => true}
  end

  def threshold # Syntactic sugar.
    @threshold
  end
end

bot = BravoMk2Bot.new 150
bot.run!
