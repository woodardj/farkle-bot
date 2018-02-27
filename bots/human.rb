require "./bot.rb"

class HumanPlayer < FarkleBot
  def act(turn)
    roll = turn.last_roll

    puts "#{roll}"

    puts "Dice to keep? [1,2,3 etc.]"
    input = gets
    keepers = input.split ","
    keepers.map!{|n| n.to_i - 1 } # Silly humans don't zero index
    puts "Keeping: #{keepers}"

    puts "Keep rolling? [yes / anything else]"
    input = gets
    continue = (input.strip == "yes")

    # puts "#{keepers}"
    # puts "#{continue}"

    {:keep => keepers, :pass => !continue, :puts => true}
  end
end

bot = HumanPlayer.new
bot.run!
