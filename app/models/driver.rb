class Driver < ApplicationRecord
  has_many :trips
  validates :name, presence: true
  validates :vin, presence: true

  def total_earnings
  #The driver gets 80% of the trip cost after a fee of $1.65 is subtracted
    self.trips.sum { |trip| trip.cost ? trip.cost : 0 }
  end

  def avg_rating
    #add formula to return average rating 
    # self.trips.rating { |trip| trip.rating ? trip.rating : 0 }
  end
end

