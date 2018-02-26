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
end

class Turn
  def initialize
    @rolls = []
    @rolls << ::System.roll
  end

  def rolls
    @rolls
  end
end
