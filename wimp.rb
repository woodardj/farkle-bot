require "./bot.rb"

class WimpyBot < FarkleBot
  def act(roll)
    keepers = [roll.index(5)] if roll.index(5)
    keepers = [roll.index(1)] if roll.index(1)
    triple_value = roll.group_by(&:itself).select { |k, v| v.size >= 3 }.keys.first

    keepers = roll.each_index.select{|i| roll[i] == triple_value}[0..2] unless triple_value.nil?

    {:keep => keepers, :pass => true, :puts => true}
  end
end

bot = WimpyBot.new
bot.run!
