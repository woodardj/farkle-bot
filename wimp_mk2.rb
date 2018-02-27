require "./bot.rb"

class WimpyBot < FarkleBot
  # Wimp combined with some additional smarts of the McKinleyBot -- (drafts *all* scored dice, rather than *any*)
  def act(turn)
    roll = turn.last_roll

    keepers = []
    # If we have a five we'll keep it
    keepers += [roll.index(5)] if roll.index(5)

    # Just kidding, we'll keep a one instead if we got one of those
    keepers += [roll.index(1)] if roll.index(1)

    # BELAY THAT ORDER... IF WE GOT A TRIPLE, WE WANT THAT.
    triple_value = roll.group_by(&:itself).select { |k, v| v.size >= 3 }.keys.first
    keepers += roll.each_index.select{|i| roll[i] == triple_value}[0..2] unless triple_value.nil?

    # Whew. That's enough excitement for one day. Gonna pass to the next player.
    {:keep => keepers, :pass => true, :puts => true}
  end
end

bot = WimpyBot.new
bot.run!
