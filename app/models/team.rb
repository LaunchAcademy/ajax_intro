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
  class << self
    def all
      [].tap do |teams|
        CSV.foreach(DATA_FILE, headers: true) do |csv|
          teams << new({
            name: csv["Team"],
            wins: csv["W"],
            losses: csv["L"],
            rank: csv["Rk"]
          })
        end
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

