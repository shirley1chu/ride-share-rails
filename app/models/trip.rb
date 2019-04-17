class Trip < ApplicationRecord
  belongs_to :passenger
  belongs_to :driver

  validates :passenger, presence: true
  validates :driver, presence: true
end
