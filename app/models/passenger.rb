class Passenger < ApplicationRecord
  has_many :trips
  validates :name, presence: true
  validates :phone_num, presence: true

  def net_expenditures
    self.trips.sum { |trip| trip.cost ? trip.cost : 0 }
  end
end
