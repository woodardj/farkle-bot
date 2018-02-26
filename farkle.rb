class System
  def self.roll(dice = 6)
    Array.new(dice).map{|n| rand(1..6)}
  end

  def self.score(roll, keeps)
    values = keeps.map{|n| roll[n].nil? ? raise( "Tried to draft a die we didn't have" ) : roll[n] }
    # puts values

    total_score = 0
    accumulator = Hash[1,0,2,0,3,0,4,0,5,0,6,0]
    # puts accumulator
    values.each do |d|
      # puts d
      accumulator[d] += 1
    end

    [2,3,4,6].each do |rank|
      if [0,3,6].include? accumulator[rank] # These die faces only score in sets of three.
        # 2, 2, 2 == 200
        # 3, 3, 3 == 300
        # etc...
        total_score += (accumulator[rank] / 3) * 100 * rank
      else
        raise "Can't draft a #{rank} in non-triples"
      end
    end

    [1,5].each do |rank|
      # Every three of this rank scores one way
      triples = accumulator[rank] / 3

      # Every single of the non-triples scores another way
      singles = accumulator[rank] - triples * 3

      if rank == 1
        # 1, 1, 1 == 1000
        # 1 == 100
        total_score += (1000 * triples) + (100 * singles)
      elsif rank == 5
        # 5, 5, 5 == 500
        # 5 == 50
        total_score += (500 * triples) + (50 * singles)
      end
    end
    total_score
  end

  def self.all_possible_keep_arrays (dice_count = 6)
    # The only bit of ruby fuckery, I promise.
    (1..(2**dice_count-1)).map do |combo_number|
      bitstring = "%0#{dice_count}b" % combo_number
      bit_ary = bitstring.chars.map &:to_i
      keeps_array = bit_ary.each_with_index.map{ |e, i| e == 0 ? nil : i }.compact
    end
  end

  def self.farkle? roll
    dice_count = roll.length
    combinations = (2**dice_count-1)

    self.all_possible_keep_arrays.each do |keep|
      begin
        return false if self.score(roll, keep) > 0
      rescue
        # Swallow legal-drafting exceptions during farkle check
      end
    end

    true # No possible combination of keeping yielded a score greater than zero
  end
end

class Turn
  def initialize
    @rolls = []
    @rolls << ::System.roll
    @keeps = []
    @points = []

    @complete = farkled?
    puts "FARKLE! Turn over." if @complete
  end

  def play(actions = {:keep => [], :pass => false, :puts => false})
    raise("Cannot play on a completed Turn") if @complete
    raise("Must keep at least one die") if actions[:keep].length == 0

    @keeps << actions[:keep]
    @points << ::System.score(last_roll, actions[:keep])
    puts "Keeping: #{actions[:keep].map{|i| "\##{i + 1}" }.join(", ")} for #{@points[-1]} points." if actions[:puts]

    if(actions[:pass])
      puts "Ending turn... with #{score} points." if actions[:puts]
      @complete = true
    else
      puts "Rolling again..." if actions[:puts]
      @rolls << ::System.roll(last_roll.length - actions[:keep].length)
      puts_last_roll if actions[:puts]
      if farkled?
        @complete = true
        puts "FARKLE! Turn over." if actions[:puts]
      end
    end
  end

  def completed
    @complete
  end

  def rolls
    @rolls
  end

  def last_roll
    @rolls[-1]
  end

  def puts_last_roll
    puts "Rolled: #{last_roll}"
  end

  def score
    farkled? ? 0 : @points.reduce(0, &:+)
  end

  def puts_score
    puts "Current score: #{score}"
  end

  def farkled?
    System.farkle? last_roll
  end
end
