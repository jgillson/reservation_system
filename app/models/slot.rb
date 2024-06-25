# The Slot model has a many-to-one relationship with the Provider model, meaning that each
# slot belongs to a particular provider.
# 
# Additionally, the Slot model has a one-to-one relationship with the Reservation model, indicating 
# that each slot can have at most one reservation associated with it.
class Slot < ApplicationRecord
  # Defines a many-to-one association with the Provider model.
  belongs_to :provider

  # Defines a one-to-one association with the Reservation model.
  has_one :reservation
end
