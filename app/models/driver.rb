class Driver < ApplicationRecord
  has_many :trips
  validates :name, presence: true
  validates :vin, presence: true

  def total_earnings
    #The driver gets 80% of the trip cost after a fee of $1.65 is subtracted
    "%.2f" % self.trips.sum { |trip| trip.cost ? 0.8 * (trip.cost - 1.65) : 0 }
  end

  def avg_rating
    return nil if self.trips.length == 0
    total_rating = self.trips.sum { |trip| trip.rating ? trip.rating : 0 }
    number_of_rides = self.trips.length

    return "%.2f" % (total_rating / number_of_rides)
  end
end
