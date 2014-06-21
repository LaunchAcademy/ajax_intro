require 'csv'
class Team
  attr_accessor :name
  attr_accessor :wins
  attr_accessor :losses
  attr_accessor :rank

  def initialize(attributes = {})
    self.name = attributes[:name]
    self.wins = attributes[:wins].to_i
    self.losses = attributes[:losses].to_i
    self.rank = attributes[:rank].to_i
  end

  DATA_FILE = File.join(File.dirname(__FILE__), '../../data/leaderboard.csv')
  GAMES_PLAYED = 82
  class << self
    def all
      standings = [].tap do |teams|
        CSV.foreach(DATA_FILE, headers: true) do |csv|
          random_wins = rand(GAMES_PLAYED) + 1
          random_losses = GAMES_PLAYED - random_wins - rand(6)
          if random_losses < 0
            random_losses = 0
          end
          teams << new({
            name: csv["Team"],
            wins: random_wins,
            losses: random_losses,
            rank: csv["Rk"]
          })
        end
      end

      standings.sort{|a, b| b.wins <=> a.wins }.each_with_index do |team, index|
        team.rank = index + 1
      end
    end
  end

  def attributes
    {
      name: self.name,
      wins: self.wins,
      losses: self.losses,
      rank: self.rank
    }
  end

  def to_json(options = {})
    attributes.to_json
  end
end

