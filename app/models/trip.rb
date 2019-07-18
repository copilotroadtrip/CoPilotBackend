class Trip < ApplicationRecord
  has_many :trip_pois
  has_many :pois, through: :trip_pois

  enum status: ['pending', 'ready']
  
  has_secure_token
end
