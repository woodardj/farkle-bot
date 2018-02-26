require "./farkle.rb"

class FarkleBot
  def initialize
    @turns = []
  end

  def game_points
    @turns.map(&:score).reduce(0,:+)
  end

  def act(roll)
    # This is what needs to be overridden in subclass
    keepers = [roll.index(5)] if roll.index(5)
    keepers = [roll.index(1)] if roll.index(1)
    # if keepers is still nil... wtf we rolled trips
    triple_value = roll.group_by(&:itself).select { |k, v| v.size >= 3 }.keys.first

    keepers = roll.each_index.select{|i| roll[i] == triple_value}[0..2] unless triple_value.nil?

    {:keep => keepers, :pass => true, :puts => true}
  end

  def run!
    while game_points < 10_000
      this_turn = Turn.new
      puts "#{this_turn.last_roll}"

      until this_turn.completed
        action = act(this_turn.last_roll)
        puts action
        this_turn.play(action)
      end

      @turns << this_turn
      puts "Total score: #{game_points}"
    end
    puts "Hit #{game_points} in #{@turns.length} turns."
  end
end

bot = FarkleBot.new
bot.run!
