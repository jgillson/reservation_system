# The Client model has a one-to-many relationship with the Reservation model,
# implying that a client can have multiple reservations.
class Client < ApplicationRecord
  # Defines a one-to-many association with the Reservation model.
  # When a Client object is destroyed, the associated Reservation objects
  # will also be destroyed.
  has_many :reservations
end
