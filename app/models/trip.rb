class Trip < ApplicationRecord
  belongs_to :passenger
  belongs_to :driver

  validates :passenger, presence: true
  validates :driver, presence: true
  validates :rating, :allow_nil => true, numericality: { greater_than: 0, less_than: 6 }
end
