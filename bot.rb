require "./farkle.rb"

class FarkleBot
  def initialize
    @turns = []
  end

  def game_points
    @turns.map(&:score).reduce(0,:+)
  end

  def act(turn)
    raise("Can't run abstract base-class bot! Subclass and override `act` method.")
  end

  def run!
    while game_points < 10_000
      this_turn = Turn.new
      puts "#{this_turn.last_roll}"

      until this_turn.completed
        action = act(this_turn)
        puts action
        this_turn.play(action)
      end

      @turns << this_turn
      puts "Total score: #{game_points}"
    end
    puts "#{self.class} hit #{game_points} in #{@turns.length} turns."
  end
end
