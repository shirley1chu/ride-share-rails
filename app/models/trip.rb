class Trip < ApplicationRecord
  belongs_to :passenger
  belongs_to :driver

  validates :passenger, presence: true
  validates :driver, presence: true
  # validates :rating, format: { with: /\b[1-5]\b/,
  #                              message: "only integer 1 - 5" }
end
